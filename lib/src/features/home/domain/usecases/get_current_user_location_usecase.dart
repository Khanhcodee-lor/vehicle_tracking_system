import '../entities/location_point.dart';
import '../repositories/home_tracking_repository.dart';

class GetCurrentUserLocationUseCase {
  GetCurrentUserLocationUseCase(this._repository);

  final HomeTrackingRepository _repository;

  Future<LocationPoint?> call() {
    return _repository.getCurrentUserLocation();
  }
}
