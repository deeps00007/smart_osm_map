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
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl == null || imageUrl!.isEmpty
            ? Container(
                color: Colors.grey[100],
                child: Icon(Icons.place_rounded,
                    color: borderColor.withValues(alpha: 0.7),
                    size: size * 0.5),
              )
            : (imageUrl!.startsWith('http')
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[100],
                      child: Icon(Icons.broken_image_rounded,
                          color: Colors.grey[400], size: size * 0.4),
                    ),
                  )
                : Image.asset(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[100],
                      child: Icon(Icons.broken_image_rounded,
                          color: Colors.grey[400], size: size * 0.4),
                    ),
                  )),
      ),
    );
  }
}
