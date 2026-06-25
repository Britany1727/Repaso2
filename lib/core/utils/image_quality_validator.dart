import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageQualityValidator {
  static const double laplacianThreshold = 100.0;

  static double computeLaplacianVariance(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('No se pudo decodificar la imagen');
    }

    final gray = img.grayscale(image);
    final width = gray.width;
    final height = gray.height;

    double sum = 0;
    final values = <double>[];
    final count = (width - 2) * (height - 2);

    if (count <= 0) return 0;

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final c = gray.getPixel(x, y);
        final t = gray.getPixel(x, y - 1);
        final b = gray.getPixel(x, y + 1);
        final l = gray.getPixel(x - 1, y);
        final r = gray.getPixel(x + 1, y);

        final laplacian = (4 * c.r.toInt() -
                t.r.toInt() -
                b.r.toInt() -
                l.r.toInt() -
                r.r.toInt())
            .toDouble();

        values.add(laplacian);
        sum += laplacian;
      }
    }

    final mean = sum / count;
    final variance =
        values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
            count;

    return variance;
  }

  static bool isBlurry(Uint8List imageBytes) {
    final variance = computeLaplacianVariance(imageBytes);
    return variance < laplacianThreshold;
  }
}
