// lib/core/ai/pipeline.dart
//
// ZON — Authentication AI Pipeline
//
// This file defines the interfaces and data types for the full
// 3-phase on-device verification pipeline.
//
// Implementation is split across:
//   liveness/liveness_detector.dart   ← Phase 1
//   scene/scene_matcher.dart          ← Phase 2
//   sensor/sensor_fusion.dart         ← Phase 3

import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';

part 'pipeline.freezed.dart';

// ── Enums ────────────────────────────────────────────────

enum AuthRoute { a, b, c, cPrime }

enum LivenessFailReason {
  flatSurface,      // depth variance too low
  noParallax,       // optical flow too uniform
  challengeFailed,  // challenge-response not completed
  tooShort,         // video < 5 seconds
}

// ── Input / Output Types ──────────────────────────────────

@freezed
class VideoSweepInput with _$VideoSweepInput {
  const factory VideoSweepInput({
    required List<CameraImage> frames,   // raw frames from camera plugin
    required int durationMs,
    required double gpsLat,
    required double gpsLng,
    required double gpsAccuracy,
    required List<Map<String, int>> wifiScan,  // [{bssid, rssi}]
    required Map<String, double> imuSnapshot,  // {ax, ay, az, gx, gy, gz}
  }) = _VideoSweepInput;
}

@freezed
class LivenessResult with _$LivenessResult {
  const factory LivenessResult.pass({
    required Float32List depthMap,         // reused in Phase 2
    required List<Float32List> flowVectors, // reused in Phase 2
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
    required bool anchorDetected,   // hard filter
    required double embeddingScore, // E: global embedding cosine similarity
    required double keypointScore,  // K: inlier count normalized
    required double depthScore,     // D: spatial fingerprint match
    required int inlierCount,
    required Float32List embedding, // 512-dim for Tier 2 import reuse
  }) = _SceneMatchResult;
}

@freezed
class SensorFusionResult with _$SensorFusionResult {
  const factory SensorFusionResult({
    required double sensorScore,       // G: 0.0–1.0
    required bool timestampConsistent, // false = teleport detected
    required double distanceFromPlaceM,
    required double wifiSimilarity,
    required bool imuMovementDetected,
  }) = _SensorFusionResult;
}

@freezed
class VerificationResult with _$VerificationResult {
  const factory VerificationResult({
    required double finalScore,       // S = 0.25E + 0.35K + 0.25D + 0.15G
    required bool passed,             // S > 0.75 AND anchorDetected
    required bool needsChallenge,     // 0.5 < S <= 0.75
    required LivenessResult liveness,
    required SceneMatchResult scene,
    required SensorFusionResult sensor,
    required String certificateHash,  // on-device signed
    required String placeId,
    required DateTime verifiedAt,
  }) = _VerificationResult;
}

// ── Pipeline Interface ─────────────────────────────────────

abstract class IAuthPipeline {
  /// Phase 1: run during live recording.
  /// Call this with each frame batch (every ~5th frame).
  Future<LivenessResult?> checkLivenessFrame(CameraImage frame);

  /// Phase 1 finalize: called when recording completes.
  /// Returns final liveness decision.
  Future<LivenessResult> finalizeLiveness(VideoSweepInput input);

  /// Phase 2: run after recording. Reuses Phase 1 results.
  Future<SceneMatchResult> matchScene({
    required VideoSweepInput input,
    required LivenessPass liveness,
    required String placeId,
    required AuthRoute route,
  });

  /// Phase 3: run in parallel with Phase 2.
  Future<SensorFusionResult> fuseSensors({
    required VideoSweepInput input,
    required String placeId,
    required DateTime lastKnownAt,
    required double lastKnownLat,
    required double lastKnownLng,
  });

  /// Combine Phase 2+3 results into final verdict.
  Future<VerificationResult> finalize({
    required SceneMatchResult scene,
    required SensorFusionResult sensor,
    required String placeId,
  });

  void dispose();
}

// ── Score Calculator ───────────────────────────────────────

class ScoreCalculator {
  static const _wE = 0.25; // global embedding weight
  static const _wK = 0.35; // keypoint inlier weight
  static const _wD = 0.25; // depth signature weight
  static const _wG = 0.15; // sensor fusion weight

  static double compute({
    required double embeddingScore,
    required double keypointScore,
    required double depthScore,
    required double sensorScore,
  }) {
    return _wE * embeddingScore
         + _wK * keypointScore
         + _wD * depthScore
         + _wG * sensorScore;
  }

  static bool passes(double score, bool anchorDetected) {
    return score > 0.75 && anchorDetected;
  }

  static bool needsChallenge(double score, bool anchorDetected) {
    return anchorDetected && score > 0.5 && score <= 0.75;
  }

  /// Normalize inlier count to 0–1 score.
  /// 200+ inliers = perfect score.
  static double keypointScoreFromInliers(int inlierCount) {
    return (inlierCount / 200.0).clamp(0.0, 1.0);
  }

  /// GPS distance decay: full score at 0m, 0 at 500m.
  static double gpsScore(double distanceM) {
    if (distanceM < 50) return 1.0;
    if (distanceM > 500) return 0.0;
    return 1.0 - (distanceM - 50) / 450;
  }
}


// lib/core/ai/liveness/liveness_detector.dart
//
// Phase 1 implementation skeleton.
// Replace stub logic with real TFLite inference in M1.

class LivenessDetector {
  static const _depthVarianceThreshold = 0.02;
  static const _minFrames = 30; // ~5 seconds at 6fps (every 5th frame)

  bool _isLoaded = false;
  final List<double> _depthVariances = [];
  final List<Float32List> _flowVectors = [];

  Future<void> load() async {
    // TODO(M1): Load depth_anything_v2_small.tflite
    // final interpreter = await Interpreter.fromAsset(
    //   'assets/models/depth_anything_v2_small.tflite',
    //   options: _buildOptions(),
    // );
    _isLoaded = true;
  }

  /// Called every 5th frame during live recording.
  /// Returns null = continue recording, non-null = early fail.
  LivenessResult? checkFrame(CameraImage frame) {
    if (!_isLoaded) return null;

    // TODO(M1): Run depth estimation on frame
    // final depthMap = _runDepthModel(frame);
    // final variance = _computeVariance(depthMap);
    // _depthVariances.add(variance);

    // TODO(M1): Compute optical flow between this frame and previous
    // final flow = _computeOpticalFlow(frame);
    // _flowVectors.add(flow);

    // Early fail: flat surface detected early in recording
    // if (_depthVariances.length >= 10) {
    //   final avgVariance = _depthVariances.average;
    //   if (avgVariance < _depthVarianceThreshold) {
    //     return const LivenessResult.fail(
    //       reason: LivenessFailReason.flatSurface,
    //       userMessage: 'A flat surface was detected. Please film the actual 3D space.',
    //     );
    //   }
    // }

    return null; // Continue recording
  }

  /// Called when recording ends. Returns final decision.
  Future<LivenessResult> finalize(int totalFrames) async {
    if (totalFrames < _minFrames) {
      return const LivenessResult.fail(
        reason: LivenessFailReason.tooShort,
        userMessage: 'Recording too short. Please sweep for at least 5 seconds.',
      );
    }

    // TODO(M1): Aggregate depth variances and flow vectors
    // Final check: overall depth variance
    // if (_depthVariances.average < _depthVarianceThreshold) { ... }

    // Stub: always pass in M0 validation
    return LivenessResult.pass(
      depthMap: Float32List(256 * 256),      // stub
      flowVectors: [Float32List(240 * 320)], // stub
      depthVariance: 0.15,                   // stub > threshold
      flowMagnitude: 0.08,                   // stub
    );
  }

  void reset() {
    _depthVariances.clear();
    _flowVectors.clear();
  }

  void dispose() {
    // TODO(M1): interpreter.close()
  }
}


// lib/core/ai/scene/scene_matcher.dart
//
// Phase 2 implementation skeleton.

class SceneMatcher {
  Future<void> load() async {
    // TODO(M1): Load SuperPoint, LightGlue, MixVPR
  }

  Future<SceneMatchResult> match({
    required LivenessPass liveness,
    required AuthRoute route,
    required Uint8List referenceEmbedding,     // from place DB
    required Uint8List referenceAnchorDesc,    // from place DB
    required Uint8List referenceSpatialFp,     // from place DB
  }) async {
    // TODO(M1): Implement per route
    // Route A:
    //   1. Run MixVPR on best frame → embedding
    //   2. Cosine similarity vs referenceEmbedding → E
    //   3. Run SuperPoint on 3 best frames → keypoints
    //   4. Run LightGlue on keypoint pairs → matches
    //   5. RANSAC inlier count → K
    //   6. Anchor descriptor match vs referenceAnchorDesc → hard filter
    //   7. Depth map comparison vs referenceSpatialFp → D

    // Stub
    return const SceneMatchResult(
      route: AuthRoute.a,
      anchorDetected: true,
      embeddingScore: 0.88,
      keypointScore: 0.72,
      depthScore: 0.85,
      inlierCount: 144,
      embedding: Float32List.fromList([]), // stub
    );
  }

  void dispose() {}
}


// lib/core/ai/sensor/sensor_fusion.dart
//
// Phase 3 implementation skeleton.

class SensorFusion {
  SensorFusionResult fuse({
    required double gpsLat,
    required double gpsLng,
    required double placeLat,
    required double placeLng,
    required List<Map<String, int>> wifiScan,
    required List<Map<String, int>>? referenceWifi,
    required Map<String, double> imu,
    required DateTime verificationTime,
    required DateTime? lastKnownTime,
    required double? lastKnownLat,
    required double? lastKnownLng,
  }) {
    // 1. GPS distance score
    final dist = _haversineDistance(gpsLat, gpsLng, placeLat, placeLng);
    final gpsScore = ScoreCalculator.gpsScore(dist);

    // 2. Timestamp consistency (teleport detection)
    bool timestampOk = true;
    if (lastKnownTime != null && lastKnownLat != null && lastKnownLng != null) {
      final elapsedSec = verificationTime.difference(lastKnownTime).inSeconds;
      final distFromLast = _haversineDistance(gpsLat, gpsLng, lastKnownLat, lastKnownLng);
      // Max realistic speed: 350 m/s (commercial aircraft)
      final maxDist = elapsedSec * 350.0;
      if (distFromLast > maxDist) {
        timestampOk = false; // TELEPORT DETECTED → hard fail
      }
    }

    // 3. Wi-Fi RSSI similarity
    double wifiSim = 0.5; // default when no reference
    if (referenceWifi != null && referenceWifi.isNotEmpty) {
      wifiSim = _wifiCosineSimilarity(wifiScan, referenceWifi);
    }

    // 4. IMU: was device moving during sweep?
    final ax = imu['ax'] ?? 0.0;
    final ay = imu['ay'] ?? 0.0;
    final az = imu['az'] ?? 9.81;
    final imuMagnitude = (ax * ax + ay * ay + (az - 9.81) * (az - 9.81));
    final imuMoving = imuMagnitude > 0.01; // threshold

    final sensorScore = (gpsScore * 0.6 + wifiSim * 0.4).clamp(0.0, 1.0);

    return SensorFusionResult(
      sensorScore: sensorScore,
      timestampConsistent: timestampOk,
      distanceFromPlaceM: dist,
      wifiSimilarity: wifiSim,
      imuMovementDetected: imuMoving,
    );
  }

  double _haversineDistance(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0; // Earth radius in meters
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = _sin2(dLat / 2) + _cos(_toRad(lat1)) * _cos(_toRad(lat2)) * _sin2(dLng / 2);
    return 2 * r * _asin(_sqrt(a));
  }

  double _wifiCosineSimilarity(
    List<Map<String, int>> scan,
    List<Map<String, int>> reference,
  ) {
    // Build RSSI vectors aligned by BSSID
    // TODO(M1): full implementation
    return 0.75; // stub
  }

  double _toRad(double deg) => deg * 3.14159265 / 180;
  double _sin2(double x) { final s = _sin(x); return s * s; }
  double _sin(double x)  => x - x*x*x/6 + x*x*x*x*x/120; // Taylor approx (sufficient for small angles)
  double _cos(double x)  => 1 - x*x/2 + x*x*x*x/24;
  double _asin(double x) => x + x*x*x/6; // approx for small x
  double _sqrt(double x) => x <= 0 ? 0 : x * (1.5 - 0.5 * x);  // Newton approx
}
