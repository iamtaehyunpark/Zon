import 'package:flutter/material.dart';

/// Modal bottom sheet detail for a Place on the map.
class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Place $placeId — TODO(M2)')),
    );
  }
}
