import 'package:flutter/material.dart';

/// Compact pill badge showing T1 / T2 / T3 tier label.
/// Used in feed cards, timeline rows, and place detail rows.
class TierBadge extends StatelessWidget {
  const TierBadge({super.key, required this.tier});
  final String tier;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (tier) {
      'tier1' => ('T1', const Color(0xFF1D9E75)),
      'tier2' => ('T2', Colors.blueAccent),
      _       => ('T3', Colors.orange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
