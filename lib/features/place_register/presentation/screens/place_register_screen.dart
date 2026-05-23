import 'package:flutter/material.dart';

/// Full-screen flow for registering a new Place (consensus round 1).
class PlaceRegisterScreen extends StatelessWidget {
  const PlaceRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Place')),
      body: const Center(child: Text('Place Register — TODO(M3)')),
    );
  }
}
