import 'dart:typed_data';
import '../pipeline.dart';

/// Phase 2 scene matching — runs after recording completes.
/// Route A: SuperPoint + LightGlue + MixVPR + anchor hard filter.
class SceneMatcher {
  Future<void> load() async {
    // TODO(M1): Load SuperPoint (ONNX), LightGlue (ONNX), MixVPR (TFLite).
    // Models are loaded lazily here, not at app startup.
  }

  /// Match the recorded frames against the stored place reference data.
  Future<SceneMatchResult> match({
    required LivenessPass liveness,
    required AuthRoute route,
    required Uint8List referenceEmbedding,
    required Uint8List referenceAnchorDesc,
    required Uint8List referenceSpatialFp,
  }) async {
    // TODO(M1): Implement Route A pipeline:
    //   1. Run MixVPR on best frame → 512-dim embedding, cosine sim → E
    //   2. Run SuperPoint on 3 best frames → keypoints + descriptors
    //   3. Run LightGlue → matches + inlier count → K
    //   4. Anchor descriptor match → hard filter (fail if no anchor)
    //   5. Depth map comparison → D
    // Stub scores for M0 validation:
    return SceneMatchResult(
      route: AuthRoute.a,
      anchorDetected: true,
      embeddingScore: 0.88,
      keypointScore: 0.72,
      depthScore: 0.85,
      inlierCount: 144,
      embedding: Float32List(512),
    );
  }

  void dispose() {
    // TODO(M1): Close all interpreters and ONNX sessions.
  }
}
