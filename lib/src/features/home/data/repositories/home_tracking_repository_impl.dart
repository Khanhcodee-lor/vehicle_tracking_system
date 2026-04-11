import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import '../../domain/entities/location_point.dart';
import '../../domain/entities/vehicle_tracking_snapshot.dart';
import '../../domain/repositories/home_tracking_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeTrackingRepositoryImpl implements HomeTrackingRepository {
  HomeTrackingRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  static const List<String> _streamPaths = ['/', 'gps', 'GPS'];

  @override
  Stream<VehicleTrackingSnapshot> watchVehicleTracking({
    required String vehicleId,
  }) {
    final controller = StreamController<VehicleTrackingSnapshot>();

    StreamSubscription<DatabaseEvent>? subscription;
    Timer? fallbackTimer;
    var currentPathIndex = 0;

    Future<void> fetchOnce(String path) async {
      try {
        final snapshot = await _remoteDataSource.getRealtimeData(path);
        final parsed = _parseVehicleSnapshot(snapshot.value, vehicleId);
        if (parsed != null && !controller.isClosed) {
          controller.add(parsed);
        }
      } catch (_) {
        // Ignore one-shot read failures here; stream/fallback handles reconnection.
      }
    }

    void startFallbackPolling() {
      fallbackTimer ??= Timer.periodic(const Duration(seconds: 5), (_) {
        unawaited(fetchOnce('/'));
      });
      unawaited(fetchOnce('/'));
    }

    void startListen(int index) {
      final path = _streamPaths[index];
      unawaited(fetchOnce(path));
      subscription = _remoteDataSource
          .watchRealtimeData(path)
          .listen(
            (event) {
              final parsed = _parseVehicleSnapshot(
                event.snapshot.value,
                vehicleId,
              );
              if (parsed != null) {
                fallbackTimer?.cancel();
                fallbackTimer = null;
                controller.add(parsed);
              }
            },
            onError: (error, stackTrace) {
              if (currentPathIndex < _streamPaths.length - 1) {
                currentPathIndex += 1;
                subscription?.cancel();
                startListen(currentPathIndex);
                return;
              }
              startFallbackPolling();
            },
          );
    }

    startListen(currentPathIndex);

    controller.onCancel = () async {
      await subscription?.cancel();
      fallbackTimer?.cancel();
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

    final lat = _toDouble(
      gps['lat'] ?? gps['Lat'] ?? gps['latitude'] ?? gps['Latitude'],
    );
    final lng = _toDouble(
      gps['lng'] ??
          gps['Lng'] ??
          gps['lon'] ??
          gps['Lon'] ??
          gps['longitude'] ??
          gps['Longitude'],
    );
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
        final lat = _toDouble(
          gps['lat'] ?? gps['Lat'] ?? gps['latitude'] ?? gps['Latitude'],
        );
        final lng = _toDouble(
          gps['lng'] ??
              gps['Lng'] ??
              gps['lon'] ??
              gps['Lon'] ??
              gps['longitude'] ??
              gps['Longitude'],
        );
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
    final gps = data['gps'] ?? data['GPS'] ?? data['Gps'];
    if (gps is Map) return gps;

    final lat = _toDouble(
      data['lat'] ?? data['Lat'] ?? data['latitude'] ?? data['Latitude'],
    );
    final lng = _toDouble(
      data['lng'] ??
          data['Lng'] ??
          data['lon'] ??
          data['Lon'] ??
          data['longitude'] ??
          data['Longitude'],
    );

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
