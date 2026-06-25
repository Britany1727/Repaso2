import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback? onRetake;

  const ImagePreviewWidget({
    super.key,
    required this.imageBytes,
    this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            imageBytes,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),
          if (onRetake != null)
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onRetake,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
