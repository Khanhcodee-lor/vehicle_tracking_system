import '../entities/location_point.dart';
import '../repositories/home_tracking_repository.dart';

class ReverseGeocodeUseCase {
  ReverseGeocodeUseCase(this._repository);

  final HomeTrackingRepository _repository;

  Future<String> call(LocationPoint location) {
    return _repository.reverseGeocode(location);
  }
}
