import 'package:flutter/material.dart';

/// Step 2: Live camera recording with real-time liveness gate (Phase 1 AI).
class VideoSweepScreen extends StatelessWidget {
  const VideoSweepScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Sweep')),
      body: Center(child: Text('Video Sweep for $placeId — TODO(M1)')),
    );
  }
}
