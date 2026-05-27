import 'dart:math' as math;
import '../pipeline.dart';

/// Phase 3 sensor fusion — runs in parallel with Phase 2.
/// Combines GPS, Wi-Fi RSSI, and IMU to produce a sensor score G.
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
    final dist = _haversineDistance(gpsLat, gpsLng, placeLat, placeLng);
    final gpsScore = ScoreCalculator.gpsScore(dist);

    // Teleport detection: reject physically impossible travel speed.
    var timestampOk = true;
    if (lastKnownTime != null && lastKnownLat != null && lastKnownLng != null) {
      final elapsedSec =
          verificationTime.difference(lastKnownTime).inSeconds.abs();
      if (elapsedSec > 0) {
        final distFromLast =
            _haversineDistance(gpsLat, gpsLng, lastKnownLat, lastKnownLng);
        // 350 m/s ≈ commercial aircraft cruising speed — physically impossible
        if (distFromLast > elapsedSec * 350.0) {
          timestampOk = false;
        }
      }
    }

    // Wi-Fi RSSI cosine similarity vs stored fingerprint
    final wifiSim = (referenceWifi != null && referenceWifi.isNotEmpty)
        ? _wifiCosineSimilarity(wifiScan, referenceWifi)
        : 0.5; // neutral when no reference stored

    // IMU: device must have physically moved during the video sweep.
    final ax = imu['ax'] ?? 0.0;
    final ay = imu['ay'] ?? 0.0;
    final az = imu['az'] ?? 9.81;
    // Subtract gravity component from az
    final imuMagnitude =
        math.sqrt(ax * ax + ay * ay + (az - 9.81) * (az - 9.81));
    final imuMovementDetected = imuMagnitude > 0.15; // 0.15 m/s² threshold

    // GPS weight 60%, Wi-Fi weight 40%
    final sensorScore = (gpsScore * 0.6 + wifiSim * 0.4).clamp(0.0, 1.0);

    return SensorFusionResult(
      sensorScore: sensorScore,
      timestampConsistent: timestampOk,
      distanceFromPlaceM: dist,
      wifiSimilarity: wifiSim,
      imuMovementDetected: imuMovementDetected,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  static double _haversineDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * r * math.asin(math.sqrt(a.toDouble()));
  }

  static double _toRad(double deg) => deg * math.pi / 180;

  /// Cosine similarity between two RSSI fingerprints aligned by BSSID.
  ///
  /// Each fingerprint is a list of {bssid → rssi} maps (one per scan sample).
  /// We merge by BSSID, build aligned vectors, and compute cosine similarity.
  static double _wifiCosineSimilarity(
    List<Map<String, int>> scan,
    List<Map<String, int>> reference,
  ) {
    if (scan.isEmpty || reference.isEmpty) return 0.5;

    // Flatten to single {bssid → rssi} by averaging across samples
    Map<String, double> toVector(List<Map<String, int>> samples) {
      final sums = <String, int>{};
      final counts = <String, int>{};
      for (final s in samples) {
        for (final e in s.entries) {
          sums[e.key] = (sums[e.key] ?? 0) + e.value;
          counts[e.key] = (counts[e.key] ?? 0) + 1;
        }
      }
      return {
        for (final k in sums.keys) k: sums[k]! / counts[k]!,
      };
    }

    final vecA = toVector(scan);
    final vecB = toVector(reference);
    final bssids = {...vecA.keys, ...vecB.keys};

    double dot = 0, normA = 0, normB = 0;
    for (final b in bssids) {
      final a = vecA[b] ?? -100.0; // absent AP = very weak signal
      final bVal = vecB[b] ?? -100.0;
      // Shift from dBm range [-100, 0] to [0, 100]
      final aNorm = a + 100;
      final bNorm = bVal + 100;
      dot   += aNorm * bNorm;
      normA += aNorm * aNorm;
      normB += bNorm * bNorm;
    }

    final denom = math.sqrt(normA) * math.sqrt(normB);
    return denom > 0 ? (dot / denom).clamp(0.0, 1.0) : 0.5;
  }
}
