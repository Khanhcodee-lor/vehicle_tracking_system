import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/location_point.dart';

part 'home_tracking_state.freezed.dart';

@freezed
abstract class HomeTrackingState with _$HomeTrackingState {
  const HomeTrackingState._();

  static const LocationPoint defaultMapCenter = LocationPoint(
    latitude: 16.047079,
    longitude: 108.206230,
  );

  const factory HomeTrackingState({
    @Default(LocationPoint(latitude: 16.047079, longitude: 108.206230))
    LocationPoint currentLocation,
    @Default(false) bool hasUserLocation,
    @Default(false) bool hasVehicleLocation,
    @Default(LocationPoint(latitude: 16.047079, longitude: 108.206230))
    LocationPoint vehicleLocation,
    @Default(<LocationPoint>[]) List<LocationPoint> routePoints,
    @Default('Dang cho du lieu') String vehicleStatus,
    @Default('-- km/h') String vehicleSpeed,
    @Default('Dang cho du lieu') String vehicleUpdatedAt,
    @Default('Dang cho du lieu vi tri xe...') String vehicleAddress,
    @Default('Dang lay dia chi cua ban...') String userAddress,
  }) = _HomeTrackingState;

  factory HomeTrackingState.initial() => const HomeTrackingState();
}
