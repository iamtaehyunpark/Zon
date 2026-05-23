/// Result produced by the on-device AI pipeline after Phase 1+2+3 completes.
class VerificationResult {
  const VerificationResult({
    required this.finalScore,
    required this.tier1Passed,
    required this.anchorDetected,
    this.visionScore,
    this.sensorScore,
    this.certificateHash,
  });

  final double finalScore;
  final bool tier1Passed;
  final bool anchorDetected;
  final double? visionScore;
  final double? sensorScore;

  /// SHA-256 of the on-device signed verification certificate.
  final String? certificateHash;
}
