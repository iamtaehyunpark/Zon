import 'package:flutter/material.dart';

/// Full-screen detail view for a single Stamp.
class StampDetailScreen extends StatelessWidget {
  const StampDetailScreen({super.key, required this.stampId});

  final String stampId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Stamp $stampId — TODO(M2)')),
    );
  }
}
