import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AnimatedRadiusLayer extends StatelessWidget {
  final LatLng center;
  final Animation<double> animation;
  final double radiusInMeters;
  final Color color;

  const AnimatedRadiusLayer({
    super.key,
    required this.center,
    required this.animation,
    required this.radiusInMeters,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CircleLayer(
      circles: [
        CircleMarker(
          point: center,
          radius: radiusInMeters * animation.value,
          useRadiusInMeter: true,
          color: color.withOpacity(0.15 * (1 - animation.value)),
          borderColor: color.withOpacity(0.4 * (1 - animation.value)),
          borderStrokeWidth: 2,
        ),
      ],
    );
  }
}
