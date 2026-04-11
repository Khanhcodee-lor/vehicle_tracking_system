import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/ulits/logger_ulits.dart';
import '../../domain/entities/location_point.dart';
import '../../domain/entities/vehicle_tracking_snapshot.dart';
import '../../domain/repositories/home_tracking_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeTrackingRepositoryImpl implements HomeTrackingRepository {
  HomeTrackingRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  static List<String> _candidatePayloadPaths(String vehicleId) {
    return <String>[
      'vehicles/$vehicleId',
      'gps/$vehicleId',
      vehicleId,
      'gps',
      '/',
    ];
  }

  @override
  Stream<VehicleTrackingSnapshot> watchVehicleTracking({
    required String vehicleId,
  }) {
    final controller = StreamController<VehicleTrackingSnapshot>();
    final candidatePaths = _candidatePayloadPaths(vehicleId);

    StreamSubscription<DatabaseEvent>? subscription;
    Timer? discoveryTimer;
    String? activePath;
    var isDiscovering = false;
    var permissionDeniedReported = false;
    late void Function() startDiscoveryPolling;

    bool isPermissionDenied(Object error) {
      final message = error.toString().toLowerCase();
      return message.contains('permission denied') ||
          message.contains('permission_denied');
    }

    Future<void> ensureAuthToken() async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.getIdToken(true);
        }
      } catch (_) {
        // Ignore token refresh errors; stream/getData will report detailed errors.
      }
    }

    void emitSnapshot(VehicleTrackingSnapshot snapshot) {
      if (controller.isClosed) return;
      permissionDeniedReported = false;
      debugPrint(
        'TRACK emit snapshot vehicle=${snapshot.vehicleId} '
        'lat=${snapshot.location.latitude} lng=${snapshot.location.longitude} '
        'speed=${snapshot.speedKmh} updatedAt=${snapshot.updatedAt}',
      );
      controller.add(snapshot);
    }

    Future<void> reportPermissionDenied(
      Object error,
      StackTrace stackTrace,
    ) async {
      if (permissionDeniedReported || !isPermissionDenied(error)) {
        return;
      }

      permissionDeniedReported = true;
      if (!controller.isClosed) {
        controller.addError(error, stackTrace);
      }
    }

    Future<VehicleTrackingSnapshot?> fetchOnce(String path) async {
      final snapshot = await _remoteDataSource.getRealtimeData(path);
      return _parseVehicleSnapshot(snapshot.value, vehicleId);
    }

    Future<String?> discoverActivePath() async {
      if (isDiscovering || controller.isClosed) return activePath;

      isDiscovering = true;
      Object? lastPermissionDeniedError;
      StackTrace? lastPermissionDeniedStackTrace;

      try {
        await ensureAuthToken();

        for (final path in candidatePaths) {
          try {
            debugPrint('TRACK try path=$path');
            LoggerUtils.i('RTDB try path: $path');
            final parsed = await fetchOnce(path);
            if (parsed == null) {
              debugPrint('TRACK no payload path=$path');
              LoggerUtils.d('RTDB no vehicle payload at path: $path');
              continue;
            }

            activePath = path;
            debugPrint('TRACK active path=$path');
            LoggerUtils.i('RTDB active path: $path');
            emitSnapshot(parsed);
            return path;
          } catch (error, stackTrace) {
            debugPrint('TRACK path error path=$path error=$error');
            if (isPermissionDenied(error)) {
              LoggerUtils.firebaseError(
                'HomeTrackingRepositoryImpl.discoverActivePath:$path',
                error,
                stackTrace,
              );
              lastPermissionDeniedError = error;
              lastPermissionDeniedStackTrace = stackTrace;
            } else {
              LoggerUtils.e(
                'RTDB read failed at path: $path',
                error,
                stackTrace,
              );
            }
          }
        }

        if (lastPermissionDeniedError != null &&
            lastPermissionDeniedStackTrace != null) {
          await reportPermissionDenied(
            lastPermissionDeniedError,
            lastPermissionDeniedStackTrace,
          );
        }

        return null;
      } finally {
        isDiscovering = false;
      }
    }

    Future<void> attachRealtimeListener() async {
      if (subscription != null || controller.isClosed) return;

      final path = await discoverActivePath();
      if (path == null || controller.isClosed || subscription != null) {
        return;
      }

      discoveryTimer?.cancel();
      discoveryTimer = null;
      LoggerUtils.i('RTDB attach realtime listener: $path');
      subscription = _remoteDataSource
          .watchRealtimeData(path)
          .listen(
            (event) {
              final parsed = _parseVehicleSnapshot(
                event.snapshot.value,
                vehicleId,
              );
              if (parsed != null) {
                emitSnapshot(parsed);
              }
            },
            onError: (error, stackTrace) async {
              LoggerUtils.e(
                'RTDB realtime listener error at path: $path',
                error,
                stackTrace,
              );
              await subscription?.cancel();
              subscription = null;

              if (isPermissionDenied(error)) {
                await reportPermissionDenied(error, stackTrace);
              }

              startDiscoveryPolling();
            },
          );
    }

    startDiscoveryPolling = () {
      discoveryTimer ??= Timer.periodic(const Duration(seconds: 5), (_) {
        unawaited(attachRealtimeListener());
      });
      unawaited(attachRealtimeListener());
    };

    startDiscoveryPolling();

    controller.onCancel = () async {
      await subscription?.cancel();
      discoveryTimer?.cancel();
    };

    return controller.stream;
  }

  @override
  Future<LocationPoint?> getCurrentUserLocation() async {
    final hasPermission = await _remoteDataSource.ensureLocationPermission();
    if (!hasPermission) return null;

    try {
      final position = await _remoteDataSource.getCurrentPosition();
      return LocationPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<LocationPoint> watchCurrentUserLocation() async* {
    final hasPermission = await _remoteDataSource.ensureLocationPermission();
    if (!hasPermission) return;

    await for (final position in _remoteDataSource.watchCurrentPosition()) {
      yield LocationPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }

  @override
  Future<String> reverseGeocode(LocationPoint location) async {
    try {
      final placemarks = await _remoteDataSource.reverseGeocode(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isEmpty) {
        return _formatLatLng(location);
      }

      final address = _placemarkToAddress(placemarks.first);
      if (address.isEmpty) {
        return _formatLatLng(location);
      }

      return address;
    } catch (_) {
      return _formatLatLng(location);
    }
  }

  VehicleTrackingSnapshot? _parseVehicleSnapshot(
    dynamic raw,
    String targetVehicleId,
  ) {
    final payload = _findVehiclePayload(raw, targetVehicleId);
    if (payload == null) return null;

    final gps = _extractGpsMap(payload);
    if (gps == null) return null;

    final lat = _toDouble(gps['lat'] ?? gps['latitude']);
    final lng = _toDouble(gps['lng'] ?? gps['lon'] ?? gps['longitude']);
    if (lat == null || lng == null) return null;

    final speed = _toDouble(gps['speed']);
    final status = payload['status'];
    final motionState = status is Map
        ? status['motion_state']?.toString()
        : null;
    final updatedAt = _parseUpdatedAt(payload, gps);

    return VehicleTrackingSnapshot(
      vehicleId: payload['vehicle_id']?.toString() ?? targetVehicleId,
      location: LocationPoint(latitude: lat, longitude: lng),
      speedKmh: speed,
      motionState: motionState,
      updatedAt: updatedAt,
    );
  }

  Map<dynamic, dynamic>? _findVehiclePayload(
    dynamic raw,
    String targetVehicleId,
  ) {
    if (raw is! Map) return null;

    final directGps = _extractGpsMap(raw);
    if (directGps != null) {
      final rawVehicleId = raw['vehicle_id']?.toString();
      if (rawVehicleId == null || rawVehicleId == targetVehicleId) {
        return raw;
      }
    }

    final queue = <Map<dynamic, dynamic>>[raw];
    final candidates = <Map<dynamic, dynamic>>[];
    var scanned = 0;

    while (queue.isNotEmpty && scanned < 300) {
      final current = queue.removeLast();
      scanned++;

      final gps = _extractGpsMap(current);
      if (gps != null) {
        final lat = _toDouble(gps['lat'] ?? gps['latitude']);
        final lng = _toDouble(gps['lng'] ?? gps['lon'] ?? gps['longitude']);
        if (lat != null && lng != null) {
          candidates.add(current);
        }
      }

      for (final value in current.values) {
        if (value is Map) {
          queue.add(value);
        }
      }
    }

    if (candidates.isEmpty) return null;

    final preferred = candidates
        .where((item) => item['vehicle_id']?.toString() == targetVehicleId)
        .toList();

    final selected = preferred.isNotEmpty ? preferred : candidates;
    return _pickLatest(selected);
  }

  Map<dynamic, dynamic>? _pickLatest(List<Map<dynamic, dynamic>> items) {
    Map<dynamic, dynamic>? best;
    var bestTs = -1;

    for (final item in items) {
      final ts = _toInt(item['timestamp']) ?? 0;
      if (best == null || ts > bestTs) {
        best = item;
        bestTs = ts;
      }
    }

    return best;
  }

  Map<dynamic, dynamic>? _extractGpsMap(Map<dynamic, dynamic> data) {
    final gps = data['gps'];
    if (gps is Map) return gps;

    final lat = _toDouble(data['lat'] ?? data['latitude']);
    final lng = _toDouble(data['lng'] ?? data['lon'] ?? data['longitude']);

    if (lat != null && lng != null) {
      return data;
    }

    return null;
  }

  DateTime? _parseUpdatedAt(
    Map<dynamic, dynamic> payload,
    Map<dynamic, dynamic> gps,
  ) {
    final unixTime = _toInt(payload['timestamp']);
    if (unixTime != null) {
      return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    }

    final gpsTime = gps['gps_time'];
    if (gpsTime is String && gpsTime.isNotEmpty) {
      return DateTime.tryParse(gpsTime);
    }

    return null;
  }

  String _placemarkToAddress(Placemark placemark) {
    final parts = <String>[
      placemark.street ?? '',
      placemark.subLocality ?? '',
      placemark.locality ?? '',
      placemark.administrativeArea ?? '',
      placemark.country ?? '',
    ].where((item) => item.trim().isNotEmpty).toList();

    if (parts.isEmpty) return '';

    final dedup = <String>[];
    for (final part in parts) {
      if (dedup.isEmpty || dedup.last.toLowerCase() != part.toLowerCase()) {
        dedup.add(part);
      }
    }
    return dedup.join(', ');
  }

  String _formatLatLng(LocationPoint location) {
    return '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
  }

  double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }
}

final homeTrackingRepositoryProvider = Provider<HomeTrackingRepository>((ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeTrackingRepositoryImpl(remoteDataSource);
});
