import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import '../image_preprocessor.dart';
import '../pipeline.dart';

/// Phase 1 liveness gate — runs live during video recording.
///
/// Every [frameInterval]th frame is processed by Depth Anything V2-Small.
/// Depth variance < [_depthVarianceThreshold] for [_flatFrameLimit] consecutive
/// frames → immediate FAIL (flat surface / photo attack).
/// Frame-diff optical flow < [_flowMagnitudeThreshold] → suspicious flag.
class LivenessDetector {
  static const _depthVarianceThreshold = 0.02;
  static const _flowMagnitudeThreshold = 0.005;
  static const _flatFrameLimit = 10; // consecutive flat frames before abort
  static const frameInterval = 5;    // process every 5th frame
  static const _minFrames = 30;      // ~5 s at 6 fps

  OrtSession? _session;
  Float32List? _prevGray; // previous frame for optical flow diff
  int _prevW = 0, _prevH = 0; // actual pixel dimensions of _prevGray

  final List<double> _depthVariances = [];
  final List<Float32List> _flowVectors = [];
  int _consecutiveFlat = 0;

  Future<void> load() async {
    OrtEnv.instance.init();
    final data = await rootBundle.load('assets/models/depth_anything_v2_small.onnx');
    _session = OrtSession.fromBuffer(
        data.buffer.asUint8List(), OrtSessionOptions());
  }

  /// Process a [CameraImage] frame (NV21/YUV_420). Returns null to continue,
  /// or a fail [LivenessResult] for immediate early abort.
  Future<LivenessResult?> checkFrame(CameraImage frame) async {
    if (_session == null) return null;

    final gray = _yuv420ToGray(frame);           // [H×W] uint8 → float
    final depthMap = await _runDepth(gray, frame.width, frame.height);
    final variance = ImagePreprocessor.variance(depthMap);
    _depthVariances.add(variance);

    // Optical flow via frame difference
    final flow = _frameDiff(gray, _prevGray);
    _prevGray = gray;
    _prevW = frame.width;
    _prevH = frame.height;
    _flowVectors.add(flow);

    if (variance < _depthVarianceThreshold) {
      _consecutiveFlat++;
      if (_consecutiveFlat >= _flatFrameLimit) {
        return const LivenessResult.fail(
          reason: LivenessFailReason.flatSurface,
          userMessage: 'Flat surface detected. Point at a real 3-D scene.',
        );
      }
    } else {
      _consecutiveFlat = 0;
    }

    return null; // continue recording
  }

  /// Called once when recording ends. Returns the final liveness decision.
  Future<LivenessResult> finalize(int totalFrames) async {
    if (totalFrames < _minFrames) {
      return const LivenessResult.fail(
        reason: LivenessFailReason.tooShort,
        userMessage: 'Recording too short. Sweep for at least 5 seconds.',
      );
    }

    if (_depthVariances.isEmpty) {
      return const LivenessResult.fail(
        reason: LivenessFailReason.noDepthData,
        userMessage: 'Could not process frames. Please try again.',
      );
    }

    final avgVariance = _depthVariances.reduce((a, b) => a + b) /
        _depthVariances.length;
    final avgFlow = _flowVectors.isEmpty
        ? 0.0
        : _flowVectors
                .map((f) => f.fold<double>(0, (s, v) => s + v.abs()) / f.length)
                .reduce((a, b) => a + b) /
            _flowVectors.length;

    if (avgVariance < _depthVarianceThreshold) {
      return const LivenessResult.fail(
        reason: LivenessFailReason.flatSurface,
        userMessage: 'Scene appears flat. Try a location with more depth.',
      );
    }

    // Stationary flag — not a hard fail, passed to sensor fusion
    final isStationary = avgFlow < _flowMagnitudeThreshold;

    // Use the last depth map for Phase 2 reuse
    final lastDepthMap = (_depthVariances.isNotEmpty && _prevGray != null)
        ? await _runDepth(_prevGray!, _prevW, _prevH)
        : Float32List(256 * 256);

    return LivenessResult.pass(
      depthMap: lastDepthMap,
      flowVectors: _flowVectors.isNotEmpty
          ? _flowVectors.sublist(_flowVectors.length - 5) // last 5 frames
          : [Float32List(240 * 320)],
      depthVariance: avgVariance,
      flowMagnitude: avgFlow,
      stationaryFlag: isStationary,
    );
  }

  void reset() {
    _depthVariances.clear();
    _flowVectors.clear();
    _prevGray = null;
    _prevW = 0;
    _prevH = 0;
    _consecutiveFlat = 0;
  }

  void dispose() {
    _session?.release();
    _session = null;
  }

  // ── Private helpers ─────────────────────────────────────────────────

  // MiDaS ImageNet normalisation constants (NCHW layout)
  static const _mean = [0.485, 0.456, 0.406];
  static const _std  = [0.229, 0.224, 0.225];

  Future<Float32List> _runDepth(
      Float32List grayFlat, int origW, int origH) async {
    // Resize to 256×256 and replicate grayscale to RGB with MiDaS normalisation
    final rgb = Float32List(3 * 256 * 256);
    final scaleX = origW / 256;
    final scaleY = origH / 256;
    for (var y = 0; y < 256; y++) {
      for (var x = 0; x < 256; x++) {
        final srcX = (x * scaleX).floor().clamp(0, origW - 1);
        final srcY = (y * scaleY).floor().clamp(0, origH - 1);
        final v = grayFlat[srcY * origW + srcX]; // already [0,1]
        final dst = y * 256 + x;
        rgb[dst]               = (v - _mean[0]) / _std[0]; // R
        rgb[256 * 256 + dst]   = (v - _mean[1]) / _std[1]; // G
        rgb[2 * 256 * 256 + dst] = (v - _mean[2]) / _std[2]; // B
      }
    }

    final opts  = OrtRunOptions();
    // MiDaS exported with input name 'image'
    final input = OrtValueTensor.createTensorWithDataList(rgb, [1, 3, 256, 256]);
    final out   = _session!.run(opts, {'image': input});

    // MiDaS outputs [1, H, W] — 3-D tensor
    final raw  = out.first?.value as List<List<List<double>>>;
    final flat = Float32List.fromList(
        raw[0].expand((row) => row.map((v) => v.toDouble())).toList());

    input.release();
    opts.release();
    return flat;
  }

  /// Converts YUV_420 / NV21 CameraImage Y-plane to a normalised float32 array.
  static Float32List _yuv420ToGray(CameraImage frame) {
    final yPlane = frame.planes[0];
    final w = frame.width;
    final h = frame.height;
    final result = Float32List(w * h);
    final bytes = yPlane.bytes;
    final rowStride = yPlane.bytesPerRow;
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        result[y * w + x] = bytes[y * rowStride + x] / 255.0;
      }
    }
    return result;
  }

  /// Simple frame-difference optical flow proxy.
  static Float32List _frameDiff(Float32List curr, Float32List? prev) {
    if (prev == null || prev.length != curr.length) {
      return Float32List(curr.length);
    }
    final diff = Float32List(curr.length);
    for (var i = 0; i < curr.length; i++) {
      diff[i] = (curr[i] - prev[i]).abs();
    }
    return diff;
  }
}
