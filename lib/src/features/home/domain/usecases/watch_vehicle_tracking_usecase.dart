import '../entities/vehicle_tracking_snapshot.dart';
import '../repositories/home_tracking_repository.dart';

class WatchVehicleTrackingUseCase {
  WatchVehicleTrackingUseCase(this._repository);

  final HomeTrackingRepository _repository;

  Stream<VehicleTrackingSnapshot> call({required String vehicleId}) {
    return _repository.watchVehicleTracking(vehicleId: vehicleId);
  }
}
