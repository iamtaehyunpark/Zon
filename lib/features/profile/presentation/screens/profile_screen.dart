import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Profile screen: stats, conquest map mini, badge gallery, stamp grid.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.userId});

  /// Null = own profile. Non-null = another user's profile.
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Profile — TODO(M2)'),
            // TODO(M0): Remove before M1
            if (kDebugMode) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () => context.pushNamed('debug-models'),
                icon: const Icon(Icons.memory, size: 16),
                label: const Text('M0: Validate AI Models'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
