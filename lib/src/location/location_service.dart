import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Explicit permission states (NO ambiguity)
enum LocationResult {
  success,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  failed,
}

class LocationService {
  /// Requests location and returns both result + coordinates
  Future<(LocationResult, LatLng?)> getCurrentLocationWithStatus() async {
    // 1️⃣ Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return (LocationResult.serviceDisabled, null);
    }

    // 2️⃣ Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return (LocationResult.permissionDenied, null);
    }

    if (permission == LocationPermission.deniedForever) {
      return (LocationResult.permissionDeniedForever, null);
    }

    // 3️⃣ Fetch position
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return (
        LocationResult.success,
        LatLng(position.latitude, position.longitude),
      );
    } catch (_) {
      return (LocationResult.failed, null);
    }
  }
}
