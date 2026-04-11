import '../entities/location_point.dart';
import '../repositories/home_tracking_repository.dart';

class WatchCurrentUserLocationUseCase {
  WatchCurrentUserLocationUseCase(this._repository);

  final HomeTrackingRepository _repository;

  Stream<LocationPoint> call() {
    return _repository.watchCurrentUserLocation();
  }
}
