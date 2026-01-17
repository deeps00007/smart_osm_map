import 'package:latlong2/latlong.dart';

class InternalMapItem<T> {
  final String id;
  final LatLng position;
  final T data;

  InternalMapItem({
    required this.id,
    required this.position,
    required this.data,
  });
}
