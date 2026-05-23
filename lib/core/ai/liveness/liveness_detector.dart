import 'dart:typed_data';
import 'package:camera/camera.dart';
import '../pipeline.dart';

/// Phase 1 liveness gate — runs live during video recording.
/// Checks depth variance and optical flow to reject flat/static images.
class LivenessDetector {
  // TODO(M1): Used in checkFrame() once real depth inference is implemented.
  // ignore: unused_field
  static const _depthVarianceThreshold = 0.02;

  /// Minimum frames needed for a valid recording (~5 seconds at 6fps).
  static const _minFrames = 30;

  bool _isLoaded = false;
  final List<double> _depthVariances = [];
  final List<Float32List> _flowVectors = [];

  Future<void> load() async {
    // TODO(M1): Load depth_anything_v2_small.tflite with CoreML delegate (iOS)
    // final options = InterpreterOptions()..addDelegate(CoreMlDelegate());
    // _interpreter = await Interpreter.fromAsset(
    //   'assets/models/depth_anything_v2_small.tflite',
    //   options: options,
    // );
    _isLoaded = true;
  }

  /// Called every 5th frame during recording. Returns null to continue,
  /// or a fail result for immediate early abort.
  LivenessResult? checkFrame(CameraImage frame) {
    if (!_isLoaded) return null;
    // TODO(M1): Run depth model on frame, compute variance + optical flow.
    // Early-fail on flat surface detection (variance < threshold for 10+ frames).
    return null;
  }

  /// Called once when recording ends. Returns the final liveness decision.
  Future<LivenessResult> finalize(int totalFrames) async {
    if (totalFrames < _minFrames) {
      return const LivenessResult.fail(
        reason: LivenessFailReason.tooShort,
        userMessage: 'Recording too short. Please sweep for at least 5 seconds.',
      );
    }
    // TODO(M1): Aggregate depth variances and flow vectors for final decision.
    // Stub: always pass in M0.
    return LivenessResult.pass(
      depthMap: Float32List(256 * 256),
      flowVectors: [Float32List(240 * 320)],
      depthVariance: 0.15,
      flowMagnitude: 0.08,
    );
  }

  void reset() {
    _depthVariances.clear();
    _flowVectors.clear();
  }

  void dispose() {
    // TODO(M1): _interpreter.close()
  }
}
