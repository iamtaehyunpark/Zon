# ZON — Flutter Project Structure & Component Spec

---

## pubspec.yaml Dependencies

```yaml
name: zon
description: Proof-of-Presence social platform

environment:
  sdk: ">=3.3.0 <4.0.0"
  flutter: ">=3.22.0"

dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^14.0.0

  # Backend
  supabase_flutter: ^2.5.0

  # Maps
  mapbox_maps_flutter: ^2.2.0

  # Camera & AR
  camera: ^0.11.0
  arkit_plugin: ^1.0.6          # iOS AR overlay
  ar_flutter_plugin: ^0.7.3     # Android AR

  # AI / ML
  tflite_flutter: ^0.10.4
  onnxruntime: ^1.16.0

  # Location & Sensors
  geolocator: ^12.0.0
  geofence_service: ^4.0.2
  sensors_plus: ^4.0.2
  wifi_scan: ^0.4.1              # Wi-Fi RSSI (Phase 2)

  # Data models
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Local storage
  hive_flutter: ^1.1.0

  # Networking
  dio: ^5.4.3
  connectivity_plus: ^6.0.3

  # Media
  camera: ^0.11.0
  image_picker: ^1.1.0
  flutter_image_compress: ^2.2.0
  cached_network_image: ^3.3.1
  video_player: ^2.8.3
  record: ^5.1.0                 # Audio recording

  # Auth & Security
  local_auth: ^2.2.0
  flutter_secure_storage: ^9.0.0

  # Utils
  flutter_dotenv: ^5.1.0
  intl: ^0.19.0
  path_provider: ^2.1.3
  share_plus: ^9.0.0
  url_launcher: ^6.3.0
  permission_handler: ^11.3.1
  uuid: ^4.4.0
  crypto: ^3.0.3
  fpdart: ^1.1.0                 # Either type for error handling

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.9
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.0
  mockito: ^5.4.4
  flutter_lints: ^4.0.0
```

---

## Core Data Models

### Stamp
```dart
@freezed
class Stamp with _$Stamp {
  const factory Stamp({
    required String id,
    required String userId,
    required String placeId,
    required AuthTier tier,
    required DateTime createdAt,
    required Visibility visibility,
    String? caption,
    @Default([]) List<String> photoUrls,
    String? audioUrl,
    MusicTrack? musicTrack,
    @Default([]) List<String> sensoryTags,
    @Default([]) List<String> taggedUserIds,
    String? weather,
    String? season,
    String? timeOfDay,
    double? visionScore,
    double? finalScore,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(false) bool isLiked,
    @Default(false) bool isSaved,
  }) = _Stamp;

  factory Stamp.fromJson(Map<String, dynamic> json) => _$StampFromJson(json);
}

enum AuthTier { tier1, tier2, tier3 }
enum Visibility { public, friends, private }
```

### Place
```dart
@freezed
class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required String category,
    required SpaceType spaceType,
    required PlaceStatus status,
    required double lat,
    required double lng,
    String? address,
    int? pendingCount,
    int? referenceCount,
    bool? hasBadge,
    PlaceCoverage? coverage,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

enum SpaceType { outdoorArtificial, outdoorNatural, indoorArtificial, indoorNatural }
enum PlaceStatus { pending, confirmed, external }
```

### Badge
```dart
@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String name,
    required BadgeType badgeType,
    String? description,
    String? iconUrl,
    String? placeId,
    required String rarity,
    @Default(false) bool isLimited,
    DateTime? availableFrom,
    DateTime? availableUntil,
    DateTime? earnedAt,
    @Default(false) bool isEarned,
    @Default(false) bool isBackfilled,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

enum BadgeType { placeSignature, seasonal, pioneer, founder, confirmer, quest, brand }
```

---

## Riverpod Provider Patterns

### Feed Provider
```dart
// features/feed/presentation/providers/feed_provider.dart

@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  Future<List<Stamp>> build() async {
    return ref.watch(feedRepositoryProvider).getFeed();
  }

  Future<void> loadMore(String cursor) async { ... }
  Future<void> toggleLike(String stampId) async { ... }
}
```

### Auth CTA Flow Provider
```dart
// features/auth_cta/presentation/providers/auth_cta_provider.dart

@riverpod
class AuthCtaNotifier extends _$AuthCtaNotifier {
  @override
  AuthCtaState build() => const AuthCtaState.initial();

  void selectPlace(Place place) { ... }
  void onLivenessResult(LivenessResult result) { ... }
  void onSceneMatchResult(SceneMatchResult result) { ... }
  Future<void> createStamp(StampDraft draft) async { ... }
  void reset() => state = const AuthCtaState.initial();
}

@freezed
class AuthCtaState with _$AuthCtaState {
  const factory AuthCtaState.initial() = _Initial;
  const factory AuthCtaState.placeSelected(Place place) = _PlaceSelected;
  const factory AuthCtaState.recording(Place place) = _Recording;
  const factory AuthCtaState.livenessChecking(Place place) = _LivenessChecking;
  const factory AuthCtaState.livenessFailed(String reason) = _LivenessFailed;
  const factory AuthCtaState.processingAI(Place place, LivenessResult liveness) = _ProcessingAI;
  const factory AuthCtaState.editing(Place place, VerificationResult verification) = _Editing;
  const factory AuthCtaState.submitting() = _Submitting;
  const factory AuthCtaState.complete(Stamp stamp, List<Badge> badgesEarned) = _Complete;
  const factory AuthCtaState.error(String message) = _Error;
}
```

---

## Navigation (go_router)

```dart
// lib/app.dart

final router = GoRouter(
  initialLocation: '/feed',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/feed',     name: 'feed',     builder: (_, __) => const FeedScreen()),
        GoRoute(path: '/map',      name: 'map',      builder: (_, __) => const MapScreen()),
        GoRoute(path: '/timeline', name: 'timeline', builder: (_, __) => const TimelineScreen()),
        GoRoute(path: '/profile',  name: 'profile',  builder: (_, __) => const ProfileScreen()),
      ],
    ),
    // Auth CTA — modal full-screen
    GoRoute(
      path: '/auth-cta',
      name: 'auth-cta',
      pageBuilder: (context, state) => MaterialPage(
        fullscreenDialog: true,
        child: const PlaceSelectScreen(),
      ),
      routes: [
        GoRoute(path: 'sweep',      name: 'video-sweep',   builder: (_, s) => VideoSweepScreen(placeId: s.pathParameters['id']!)),
        GoRoute(path: 'processing', name: 'ai-processing', builder: (_, __) => const AiProcessingScreen()),
        GoRoute(path: 'edit',       name: 'record-edit',   builder: (_, __) => const RecordEditScreen()),
        GoRoute(path: 'complete',   name: 'stamp-complete',builder: (_, __) => const StampCompleteScreen()),
      ],
    ),
    GoRoute(
      path: '/place/:id',
      name: 'place-detail',
      builder: (context, state) => PlaceDetailScreen(placeId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/stamp/:id',
      name: 'stamp-detail',
      builder: (context, state) => StampDetailScreen(stampId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/register-place',
      name: 'register-place',
      pageBuilder: (context, state) => MaterialPage(
        fullscreenDialog: true,
        child: const PlaceRegisterScreen(),
      ),
    ),
    GoRoute(
      path: '/profile/:id',
      name: 'user-profile',
      builder: (context, state) => ProfileScreen(userId: state.pathParameters['id']),
    ),
  ],
);
```

---

## Key Screen Specs

### MapScreen
- Full-screen Mapbox `MapWidget` with no padding
- Conquest lights layer: custom `CircleAnnotationManager` per Stamp Tier
  - Tier 1: teal (#1D9E75), opacity 0.85, radius 12
  - Tier 2: blue (#378ADD), opacity 0.6, radius 8
  - Tier 3: gray, opacity 0.4, radius 5
- Bottom sheet: `DraggableScrollableSheet` with nearby places list
- Place tap → `showModalBottomSheet` with `PlaceDetailModal`
- Search bar: overlaid on top of map (position: absolute top)
- **No split-panel layout.** Map fills 100% of screen.

### VideoSweepScreen
- Camera preview fills full screen
- AR overlay: `CustomPainter` drawing corner brackets at anchor detection region
- Progress bar: bottom overlay, 0–100% over 5 seconds
- Liveness checklist: floating card (bottom-left), items check off in real time
- Anchor detected: green corner brackets + "Anchor detected" chip appears

### FeedScreen
- `CustomScrollView` with `SliverList`
- `StampCard` widget: photo (AspectRatio 4:3) + header row + caption + tags + actions
- Pull-to-refresh: `CupertinoSliverRefreshControl`
- Infinite scroll: load more when 3 items from bottom

### TimelineScreen
- Default view: `TableCalendar` (or custom equivalent)
- Day with stamps: dot indicator below date number
- Day tap: slide-up panel showing that day's Stamps
- View toggle in nav bar: calendar / map / list icons

### ProfileScreen
- Stats row: 3 `StatCard` widgets (country, place, badge counts)
- Conquest map mini: `SizedBox(height: 120)` Mapbox widget, no interaction, tap → full screen
- Badge grid: `GridView` 4 columns, earned badges colored, unearned badges grayscale + lock icon
- Stamp grid: `GridView` 3 columns of photo thumbnails

---

## Edge Cases (MVP Required)

| Scenario | Handling |
|----------|----------|
| Phone call during recording | `WidgetsBindingObserver.didChangeAppLifecycleState` → `AppLifecycleState.inactive` → stop recording, show "Recording interrupted. Please try again." |
| App backgrounded > 5s during recording | Reset auth CTA state, show restart prompt |
| GPS unavailable | Show "GPS unavailable. Try moving to an open area." Disable confirm button |
| Liveness FAIL | "A flat image was detected. Please film the actual space." + retry button |
| Network offline during stamp submit | Queue with `hive`, retry on reconnect, show "Saving locally..." |
| Duplicate stamp (same place, <24h) | Server returns 409 → "You've already Zon'd here today!" |
| Route C (indoor) pre-Phase 2 | Auto-detect indoor → show "Indoor verification coming soon. GPS check-in only." → downgrade to Tier 3 |
