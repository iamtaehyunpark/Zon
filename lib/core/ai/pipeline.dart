import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pipeline.freezed.dart';

// ── Enums ──────────────────────────────────────────────────────────────────

enum AuthRoute { a, b, c, cPrime }

enum LivenessFailReason {
  flatSurface,     // depth variance below threshold
  noParallax,      // optical flow too uniform
  challengeFailed, // challenge-response not completed
  tooShort,        // video < 5 seconds
}

// ── Input / Output Types ───────────────────────────────────────────────────

@freezed
class VideoSweepInput with _$VideoSweepInput {
  const factory VideoSweepInput({
    required List<CameraImage> frames,
    required int durationMs,
    required double gpsLat,
    required double gpsLng,
    required double gpsAccuracy,
    required List<Map<String, int>> wifiScan,
    required Map<String, double> imuSnapshot,
  }) = _VideoSweepInput;
}

@freezed
class LivenessResult with _$LivenessResult {
  const factory LivenessResult.pass({
    required Float32List depthMap,
    required List<Float32List> flowVectors,
    required double depthVariance,
    required double flowMagnitude,
  }) = LivenessPass;

  const factory LivenessResult.fail({
    required LivenessFailReason reason,
    required String userMessage,
  }) = LivenessFail;
}

@freezed
class SceneMatchResult with _$SceneMatchResult {
  const factory SceneMatchResult({
    required AuthRoute route,
    required bool anchorDetected,
    required double embeddingScore,
    required double keypointScore,
    required double depthScore,
    required int inlierCount,
    required Float32List embedding,
  }) = _SceneMatchResult;
}

@freezed
class SensorFusionResult with _$SensorFusionResult {
  const factory SensorFusionResult({
    required double sensorScore,
    required bool timestampConsistent,
    required double distanceFromPlaceM,
    required double wifiSimilarity,
    required bool imuMovementDetected,
  }) = _SensorFusionResult;
}

@freezed
class VerificationResult with _$VerificationResult {
  const factory VerificationResult({
    required double finalScore,
    required bool passed,
    required bool needsChallenge,
    required LivenessResult liveness,
    required SceneMatchResult scene,
    required SensorFusionResult sensor,
    required String certificateHash,
    required String placeId,
    required DateTime verifiedAt,
  }) = _VerificationResult;
}

// ── Pipeline Interface ─────────────────────────────────────────────────────

/// Contract for the full 3-phase on-device verification pipeline.
abstract class IAuthPipeline {
  Future<LivenessResult?> checkLivenessFrame(CameraImage frame);
  Future<LivenessResult> finalizeLiveness(VideoSweepInput input);
  Future<SceneMatchResult> matchScene({
    required VideoSweepInput input,
    required LivenessPass liveness,
    required String placeId,
    required AuthRoute route,
  });
  Future<SensorFusionResult> fuseSensors({
    required VideoSweepInput input,
    required String placeId,
    required DateTime lastKnownAt,
    required double lastKnownLat,
    required double lastKnownLng,
  });
  Future<VerificationResult> finalize({
    required SceneMatchResult scene,
    required SensorFusionResult sensor,
    required String placeId,
  });
  void dispose();
}

// ── Score Calculator ───────────────────────────────────────────────────────

/// Stateless helpers for computing the ZON verification score.
/// S = 0.25·E + 0.35·K + 0.25·D + 0.15·G
class ScoreCalculator {
  static const _wE = 0.25;
  static const _wK = 0.35;
  static const _wD = 0.25;
  static const _wG = 0.15;

  static double compute({
    required double embeddingScore,
    required double keypointScore,
    required double depthScore,
    required double sensorScore,
  }) =>
      _wE * embeddingScore +
      _wK * keypointScore +
      _wD * depthScore +
      _wG * sensorScore;

  static bool passes(double score, bool anchorDetected) =>
      score > 0.75 && anchorDetected;

  static bool needsChallenge(double score, bool anchorDetected) =>
      anchorDetected && score > 0.5 && score <= 0.75;

  /// 200+ inliers = perfect keypoint score.
  static double keypointScoreFromInliers(int inlierCount) =>
      (inlierCount / 200.0).clamp(0.0, 1.0);

  /// Full score at ≤50 m, linear decay to 0 at 500 m.
  static double gpsScore(double distanceM) {
    if (distanceM < 50) return 1.0;
    if (distanceM > 500) return 0.0;
    return 1.0 - (distanceM - 50) / 450;
  }
}
