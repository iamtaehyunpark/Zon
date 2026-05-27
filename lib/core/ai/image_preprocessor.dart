import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Converts raw JPEG/PNG bytes into float32 tensors for on-device models.
/// All tensors are NCHW format (batch=1).
class ImagePreprocessor {
  /// RGB tensor [1, 3, H, W] normalised to [0, 1].
  static Future<Float32List> toRgbTensor(
      Uint8List imageBytes, int width, int height) async {
    final pixels = await _decodeToRgba(imageBytes, width, height);
    final tensor = Float32List(3 * height * width);
    for (var i = 0; i < height * width; i++) {
      tensor[i]                    = pixels[i * 4]     / 255.0; // R
      tensor[height * width + i]   = pixels[i * 4 + 1] / 255.0; // G
      tensor[2 * height * width + i] = pixels[i * 4 + 2] / 255.0; // B
    }
    return tensor;
  }

  /// Grayscale tensor [1, 1, H, W] normalised to [0, 1] — used by SuperPoint.
  static Future<Float32List> toGrayTensor(
      Uint8List imageBytes, int width, int height) async {
    final pixels = await _decodeToRgba(imageBytes, width, height);
    final tensor = Float32List(height * width);
    for (var i = 0; i < height * width; i++) {
      final r = pixels[i * 4]     / 255.0;
      final g = pixels[i * 4 + 1] / 255.0;
      final b = pixels[i * 4 + 2] / 255.0;
      tensor[i] = 0.299 * r + 0.587 * g + 0.114 * b;
    }
    return tensor;
  }

  /// Converts a [H×W] float32 depth tensor to a displayable grayscale image.
  static Future<ui.Image> depthToImage(
      Float32List data, int width, int height) async {
    var min = data[0], max = data[0];
    for (final v in data) {
      if (v < min) min = v;
      if (v > max) max = v;
    }
    final range = max - min;
    final rgba = Uint8List(width * height * 4);
    for (var i = 0; i < width * height; i++) {
      final lum = range > 0 ? ((data[i] - min) / range * 255).round().clamp(0, 255) : 128;
      rgba[i * 4]     = lum;
      rgba[i * 4 + 1] = lum;
      rgba[i * 4 + 2] = lum;
      rgba[i * 4 + 3] = 255;
    }
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
        rgba, width, height, ui.PixelFormat.rgba8888, completer.complete);
    return completer.future;
  }

  /// Variance of a flat tensor — used for liveness depth-variance check.
  static double variance(Float32List data) {
    if (data.isEmpty) return 0;
    var mean = 0.0;
    for (final v in data) mean += v;
    mean /= data.length;
    var variance = 0.0;
    for (final v in data) {
      final d = v - mean;
      variance += d * d;
    }
    return variance / data.length;
  }

  /// L2 norm of a flat tensor — used to verify MixVPR embedding normalisation.
  static double l2Norm(List<double> vec) {
    var sum = 0.0;
    for (final v in vec) sum += v * v;
    return sum; // should be ≈ 1.0 for a properly L2-normalised embedding
  }

  // ── Internal ──────────────────────────────────────────────────────────

  static Future<Uint8List> _decodeToRgba(
      Uint8List bytes, int width, int height) async {
    final codec = await ui.instantiateImageCodec(
        bytes, targetWidth: width, targetHeight: height);
    final frame = await codec.getNextFrame();
    final byteData =
        await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
    frame.image.dispose();
    return byteData!.buffer.asUint8List();
  }
}
