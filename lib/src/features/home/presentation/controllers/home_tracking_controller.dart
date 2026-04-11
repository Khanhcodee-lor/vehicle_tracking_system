import 'dart:async';

import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/home_tracking_repository_impl.dart';
import '../../domain/entities/location_point.dart';
import '../../domain/entities/vehicle_tracking_snapshot.dart';
import '../../domain/usecases/get_current_user_location_usecase.dart';
import '../../domain/usecases/reverse_geocode_usecase.dart';
import '../../domain/usecases/watch_current_user_location_usecase.dart';
import '../../domain/usecases/watch_vehicle_tracking_usecase.dart';
import 'home_tracking_state.dart';

part 'home_tracking_controller.g.dart';

@riverpod
class HomeTrackingController extends _$HomeTrackingController {
  static const String _targetVehicleId = 'xe_001';

  final Distance _distance = const Distance();

  late WatchVehicleTrackingUseCase _watchVehicleTrackingUseCase;
  late GetCurrentUserLocationUseCase _getCurrentUserLocationUseCase;
  late WatchCurrentUserLocationUseCase _watchCurrentUserLocationUseCase;
  late ReverseGeocodeUseCase _reverseGeocodeUseCase;

  StreamSubscription<VehicleTrackingSnapshot>? _vehicleSubscription;
  StreamSubscription<LocationPoint>? _userLocationSubscription;

  LocationPoint? _lastVehicleAddressLocation;
  LocationPoint? _lastUserAddressLocation;
  DateTime? _lastVehicleAddressAt;
  DateTime? _lastUserAddressAt;
  bool _isResolvingVehicleAddress = false;
  bool _isResolvingUserAddress = false;
  bool _initialized = false;

  @override
  HomeTrackingState build() {
    final repository = ref.watch(homeTrackingRepositoryProvider);

    _watchVehicleTrackingUseCase = WatchVehicleTrackingUseCase(repository);
    _getCurrentUserLocationUseCase = GetCurrentUserLocationUseCase(repository);
    _watchCurrentUserLocationUseCase = WatchCurrentUserLocationUseCase(
      repository,
    );
    _reverseGeocodeUseCase = ReverseGeocodeUseCase(repository);

    ref.onDispose(() {
      _vehicleSubscription?.cancel();
      _userLocationSubscription?.cancel();
    });

    if (!_initialized) {
      _initialized = true;
      _startVehicleTracking();
      unawaited(_loadCurrentUserLocation(forceAddress: true));
      _startUserLocationStream();
    }

    return HomeTrackingState.initial();
  }

  Future<void> refreshCurrentUserLocation() {
    return _loadCurrentUserLocation(forceAddress: true);
  }

  void _startVehicleTracking() {
    _vehicleSubscription?.cancel();
    _vehicleSubscription =
        _watchVehicleTrackingUseCase(vehicleId: _targetVehicleId).listen(
          _onVehicleSnapshot,
          onError: (error, stackTrace) {
            state = state.copyWith(
              vehicleStatus: 'Dang thu ket noi du lieu xe',
            );
          },
        );
  }

  void _startUserLocationStream() {
    _userLocationSubscription?.cancel();
    _userLocationSubscription = _watchCurrentUserLocationUseCase().listen(
      (location) {
        state = state.copyWith(
          currentLocation: location,
          hasUserLocation: true,
        );
        unawaited(_updateUserAddress(location));
      },
      onError: (error, stackTrace) {
        state = state.copyWith(
          userAddress: 'Khong the theo doi vi tri realtime',
        );
      },
    );
  }

  Future<void> _loadCurrentUserLocation({bool forceAddress = false}) async {
    final location = await _getCurrentUserLocationUseCase();
    if (location == null) {
      state = state.copyWith(userAddress: 'Khong co quyen vi tri');
      return;
    }

    state = state.copyWith(currentLocation: location, hasUserLocation: true);
    unawaited(_updateUserAddress(location, force: forceAddress));
  }

  void _onVehicleSnapshot(VehicleTrackingSnapshot snapshot) {
    final nextLocation = snapshot.location;
    final locationChanged = nextLocation != state.vehicleLocation;

    if (locationChanged) {
      unawaited(_updateVehicleAddress(nextLocation));
    }

    var nextRoute = state.routePoints;
    if (locationChanged) {
      nextRoute = [...state.routePoints, nextLocation];
      if (nextRoute.length > 50) {
        nextRoute = nextRoute.sublist(nextRoute.length - 50);
      }
    }

    var displayStatus = _mapMotionState(snapshot.motionState);
    if (displayStatus == 'Dang cap nhat') {
      displayStatus = 'Da ket noi du lieu xe';
    }

    final speedText = snapshot.speedKmh != null
        ? '${snapshot.speedKmh!.toStringAsFixed(1)} km/h'
        : state.vehicleSpeed;

    state = state.copyWith(
      hasVehicleLocation: true,
      vehicleLocation: nextLocation,
      routePoints: nextRoute,
      vehicleStatus: displayStatus,
      vehicleSpeed: speedText,
      vehicleUpdatedAt: _formatUpdatedAt(snapshot.updatedAt),
    );
  }

  String _mapMotionState(String? stateValue) {
    final raw = stateValue?.trim();
    if (raw == null || raw.isEmpty) return 'Dang cap nhat';

    switch (raw.toLowerCase()) {
      case 'moving':
        return 'Dang di chuyen';
      case 'stopped':
        return 'Dung xe';
      case 'idle':
        return 'Dang no may';
      default:
        return raw;
    }
  }

  String _formatUpdatedAt(DateTime? updatedAt) {
    if (updatedAt == null) return 'Dang cho du lieu';
    return '${updatedAt.hour.toString().padLeft(2, '0')}:${updatedAt.minute.toString().padLeft(2, '0')}';
  }

  bool _shouldRefreshAddress({
    required LocationPoint current,
    required LocationPoint? previous,
    required DateTime? previousAt,
    required double minDistanceMeter,
    required int minIntervalSecond,
    bool force = false,
  }) {
    if (force || previous == null || previousAt == null) {
      return true;
    }

    final movedMeter = _distance.as(
      LengthUnit.Meter,
      LatLng(previous.latitude, previous.longitude),
      LatLng(current.latitude, current.longitude),
    );
    final elapsed = DateTime.now().difference(previousAt).inSeconds;

    return movedMeter >= minDistanceMeter && elapsed >= minIntervalSecond;
  }

  Future<void> _updateVehicleAddress(LocationPoint location) async {
    if (_isResolvingVehicleAddress) return;

    final shouldRefresh = _shouldRefreshAddress(
      current: location,
      previous: _lastVehicleAddressLocation,
      previousAt: _lastVehicleAddressAt,
      minDistanceMeter: 120,
      minIntervalSecond: 30,
    );

    if (!shouldRefresh) return;

    _isResolvingVehicleAddress = true;
    try {
      final address = await _reverseGeocodeUseCase(location);
      _lastVehicleAddressLocation = location;
      _lastVehicleAddressAt = DateTime.now();
      state = state.copyWith(vehicleAddress: address);
    } finally {
      _isResolvingVehicleAddress = false;
    }
  }

  Future<void> _updateUserAddress(
    LocationPoint location, {
    bool force = false,
  }) async {
    if (_isResolvingUserAddress) return;

    final shouldRefresh = _shouldRefreshAddress(
      current: location,
      previous: _lastUserAddressLocation,
      previousAt: _lastUserAddressAt,
      minDistanceMeter: 120,
      minIntervalSecond: 45,
      force: force,
    );

    if (!shouldRefresh) return;

    _isResolvingUserAddress = true;
    try {
      final address = await _reverseGeocodeUseCase(location);
      _lastUserAddressLocation = location;
      _lastUserAddressAt = DateTime.now();
      state = state.copyWith(userAddress: address);
    } finally {
      _isResolvingUserAddress = false;
    }
  }
}
