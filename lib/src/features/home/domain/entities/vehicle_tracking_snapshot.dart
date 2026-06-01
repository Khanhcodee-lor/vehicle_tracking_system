import 'location_point.dart';

class VehicleTrackingSnapshot {
  const VehicleTrackingSnapshot({
    required this.vehicleId,
    required this.location,
    this.speedKmh,
    this.motionState,
    this.updatedAt,
    this.temperature,
    this.humidity,
  });

  final String vehicleId;
  final LocationPoint location;
  final double? speedKmh;
  final String? motionState;
  final DateTime? updatedAt;
  final double? temperature;
  final double? humidity;
}
