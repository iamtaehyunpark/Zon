import 'package:flutter/material.dart';

/// Step 1 of the Auth CTA flow: choose the Place to verify.
class PlaceSelectScreen extends StatelessWidget {
  const PlaceSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Place')),
      body: const Center(child: Text('Place Select — TODO(M1)')),
    );
  }
}
