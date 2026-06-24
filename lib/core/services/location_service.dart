import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocationService {
  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> resolvePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (e, stackTrace) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
        return null;
      }
    }
  }

  double distanceInMeters({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
