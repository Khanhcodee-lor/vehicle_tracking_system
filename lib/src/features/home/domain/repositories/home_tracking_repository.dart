import '../entities/location_point.dart';
import '../entities/vehicle_tracking_snapshot.dart';

abstract class HomeTrackingRepository {
  Stream<VehicleTrackingSnapshot> watchVehicleTracking({
    required String vehicleId,
  });

  Future<LocationPoint?> getCurrentUserLocation();

  Stream<LocationPoint> watchCurrentUserLocation();

  Future<String> reverseGeocode(LocationPoint location);
}
