import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DistanceUtils {
  static double distanceInMeters(LatLng a, LatLng b) {
    return Geolocator.distanceBetween(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }
}
