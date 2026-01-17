import 'package:flutter/material.dart';

class DefaultImageMarker extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color borderColor;

  const DefaultImageMarker({
    super.key,
    this.imageUrl,
    this.size = 56,
    this.borderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl == null
            ? const Icon(Icons.location_on, color: Colors.red, size: 30)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
      ),
    );
  }
}
