import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AnimatedRadiusLayer extends StatelessWidget {
  final LatLng center;
  final Animation<double> animation;
  final double radiusInMeters;
  final Color color;
  final int numberOfRipples;

  const AnimatedRadiusLayer({
    super.key,
    required this.center,
    required this.animation,
    required this.radiusInMeters,
    this.color = Colors.blue,
    this.numberOfRipples = 3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CircleLayer(
          circles: List.generate(numberOfRipples, (index) {
            // Calculate staggered animation value for each ripple
            // The offset allows ripples to start at different times
            final value = (animation.value + (index / numberOfRipples)) % 1.0;

            return CircleMarker(
              point: center,
              radius: radiusInMeters * value,
              useRadiusInMeter: true,
              color: color.withValues(
                alpha: 0.15 * (1 - value),
              ),
              borderColor: color.withValues(
                alpha: 0.4 * (1 - value),
              ),
              borderStrokeWidth: 2,
            );
          }),
        );
      },
    );
  }
}
