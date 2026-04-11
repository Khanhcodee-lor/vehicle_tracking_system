import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/firebase/firebase_realtime_database_service.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._realtimeService);

  final FirebaseRealtimeDatabaseService _realtimeService;

  Stream<DatabaseEvent> watchRealtimeData(String path) {
    return _realtimeService.streamData(path);
  }

  Future<DataSnapshot> getRealtimeData(String path) {
    return _realtimeService.getData(path);
  }

  Future<bool> ensureLocationPermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Stream<Position> watchCurrentPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      ),
    );
  }

  Future<List<Placemark>> reverseGeocode(double lat, double lng) {
    return placemarkFromCoordinates(lat, lng);
  }
}

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final realtimeService = ref.watch(firebaseRealtimeDatabaseServiceProvider);
  return HomeRemoteDataSource(realtimeService);
});
