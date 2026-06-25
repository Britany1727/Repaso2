import 'package:flutter/material.dart';

class QualityIndicatorWidget extends StatelessWidget {
  final double variance;
  final bool isBlurry;

  const QualityIndicatorWidget({
    super.key,
    required this.variance,
    required this.isBlurry,
  });

  @override
  Widget build(BuildContext context) {
    final color = isBlurry ? const Color(0xFFEF3340) : const Color(0xFF00B894);
    final icon = isBlurry ? Icons.blur_on_rounded : Icons.check_circle_rounded;
    final label = isBlurry ? 'Imagen borrosa' : 'Imagen nítida';
    final subtitle = isBlurry
        ? 'Varianza: ${variance.toStringAsFixed(1)} (mín. 100)'
        : 'Varianza: ${variance.toStringAsFixed(1)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
            child: Center(
              child: Text(
                variance.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
