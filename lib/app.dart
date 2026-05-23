import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/feed/presentation/screens/feed_screen.dart';
import 'features/feed/presentation/screens/stamp_detail_screen.dart';
import 'features/map/presentation/screens/map_screen.dart';
import 'features/map/presentation/screens/place_detail_screen.dart';
import 'features/auth_cta/presentation/screens/place_select_screen.dart';
import 'features/auth_cta/presentation/screens/video_sweep_screen.dart';
import 'features/auth_cta/presentation/screens/ai_processing_screen.dart';
import 'features/auth_cta/presentation/screens/record_edit_screen.dart';
import 'features/auth_cta/presentation/screens/stamp_complete_screen.dart';
import 'features/place_register/presentation/screens/place_register_screen.dart';
import 'features/timeline/presentation/screens/timeline_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/debug/presentation/screens/model_validation_screen.dart';
import 'shared/widgets/main_shell.dart';

final _router = GoRouter(
  initialLocation: '/feed',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/feed',
          name: 'feed',
          builder: (_, __) => const FeedScreen(),
        ),
        GoRoute(
          path: '/map',
          name: 'map',
          builder: (_, __) => const MapScreen(),
        ),
        GoRoute(
          path: '/timeline',
          name: 'timeline',
          builder: (_, __) => const TimelineScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
    // Auth CTA — full-screen modal flow
    GoRoute(
      path: '/auth-cta',
      name: 'auth-cta',
      pageBuilder: (context, state) => const MaterialPage(
        fullscreenDialog: true,
        child: PlaceSelectScreen(),
      ),
      routes: [
        GoRoute(
          path: 'sweep/:id',
          name: 'video-sweep',
          builder: (_, s) =>
              VideoSweepScreen(placeId: s.pathParameters['id']!),
        ),
        GoRoute(
          path: 'processing',
          name: 'ai-processing',
          builder: (_, __) => const AiProcessingScreen(),
        ),
        GoRoute(
          path: 'edit',
          name: 'record-edit',
          builder: (_, __) => const RecordEditScreen(),
        ),
        GoRoute(
          path: 'complete',
          name: 'stamp-complete',
          builder: (_, __) => const StampCompleteScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/place/:id',
      name: 'place-detail',
      builder: (context, state) =>
          PlaceDetailScreen(placeId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/stamp/:id',
      name: 'stamp-detail',
      builder: (context, state) =>
          StampDetailScreen(stampId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/register-place',
      name: 'register-place',
      pageBuilder: (context, state) => const MaterialPage(
        fullscreenDialog: true,
        child: PlaceRegisterScreen(),
      ),
    ),
    GoRoute(
      path: '/profile/:id',
      name: 'user-profile',
      builder: (context, state) =>
          ProfileScreen(userId: state.pathParameters['id']),
    ),
    // TODO(M0): Remove debug route before App Store submission
    if (kDebugMode)
      GoRoute(
        path: '/debug/models',
        name: 'debug-models',
        builder: (_, __) => const ModelValidationScreen(),
      ),
  ],
);

/// Root widget. Owns the GoRouter instance and MaterialApp theme.
class ZonApp extends StatelessWidget {
  const ZonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ZON',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D9E75),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
