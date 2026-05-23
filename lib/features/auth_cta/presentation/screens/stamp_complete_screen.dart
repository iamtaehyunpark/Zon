import 'package:flutter/material.dart';

/// Step 5: Stamp created. Shows earned badges and share prompt.
class StampCompleteScreen extends StatelessWidget {
  const StampCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stamp Created!')),
      body: const Center(child: Text('Stamp Complete — TODO(M2)')),
    );
  }
}
