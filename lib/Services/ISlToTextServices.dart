import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Service to handle ISL (Indian Sign Language) to text conversion
class IslToTextService {

  img.Image convertYUV420ToImage(CameraImage inputImage) {
    final img.Image outputImage = img.Image(
      width: inputImage.width,
      height: inputImage.height,
    );

    final yRowStride = inputImage.planes[0].bytesPerRow;
    final uvRowStride = inputImage.planes[1].bytesPerRow;
    final uvPixelStride = inputImage.planes[1].bytesPerPixel ?? 1;

    // More accurate YUV -> RGB conversion coefficients
    const double ry = 1.0;
    const double gy = 1.0;
    const double by = 1.0;
    const double ru = 0.0;
    const double gu = -0.344136;
    const double bu = 1.772;
    const double rv = 1.402;
    const double gv = -0.714136;
    const double bv = 0.0;

    for (int y = 0; y < inputImage.height; y++) {
      for (int x = 0; x < inputImage.width; x++) {
        final int yIndex = y * yRowStride + x;

        // Proper UV index calculation with pixel stride
        final int uvRow = y ~/ 2;
        final int uvCol = x ~/ 2;
        final int uvIndex = uvRow * uvRowStride + uvCol * uvPixelStride;

        // Extract YUV values
        final int yValue = inputImage.planes[0].bytes[yIndex];
        final int uValue = inputImage.planes[1].bytes[uvIndex];
        final int vValue = inputImage.planes[2].bytes[uvIndex];

        // Adjusted YUV -> RGB conversion
        final double yNormalized = (yValue - 16) * 1.164;
        final double uDiff = uValue - 128;
        final double vDiff = vValue - 128;

        final int r = (yNormalized + rv * vDiff).round().clamp(0, 255);
        final int g = (yNormalized + gu * uDiff + gv * vDiff).round().clamp(0, 255);
        final int b = (yNormalized + bu * uDiff).round().clamp(0, 255);

        outputImage.setPixelRgb(x, y, r, g, b);
      }
    }

    return outputImage;
  }

}