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
      final elapsedSec = verificationTime.difference(lastKnownTime).inSeconds;
      final distFromLast = _haversineDistance(gpsLat, gpsLng, lastKnownLat, lastKnownLng);
      // 350 m/s ≈ commercial aircraft cruising speed
      if (distFromLast > elapsedSec * 350.0) {
        timestampOk = false;
      }
    }

    // Wi-Fi similarity (defaults to neutral 0.5 when no reference exists).
    final wifiSim = (referenceWifi != null && referenceWifi.isNotEmpty)
        ? _wifiCosineSimilarity(wifiScan, referenceWifi)
        : 0.5;

    // IMU: device must have moved during the sweep.
    final ax = imu['ax'] ?? 0.0;
    final ay = imu['ay'] ?? 0.0;
    final az = imu['az'] ?? 9.81;
    final imuMagnitude = ax * ax + ay * ay + (az - 9.81) * (az - 9.81);

    final sensorScore = (gpsScore * 0.6 + wifiSim * 0.4).clamp(0.0, 1.0);

    return SensorFusionResult(
      sensorScore: sensorScore,
      timestampConsistent: timestampOk,
      distanceFromPlaceM: dist,
      wifiSimilarity: wifiSim,
      imuMovementDetected: imuMagnitude > 0.01,
    );
  }

  double _haversineDistance(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_toRad(lat1)) * math.cos(_toRad(lat2)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * r * math.asin(math.sqrt(a.toDouble()));
  }

  double _toRad(double deg) => deg * math.pi / 180;

  double _wifiCosineSimilarity(
    List<Map<String, int>> scan,
    List<Map<String, int>> reference,
  ) {
    // TODO(M1): Build RSSI vectors aligned by BSSID and compute cosine similarity.
    return 0.75; // stub
  }
}
