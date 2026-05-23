# ZON — Claude Code Project Context

> **Read this file before every session. Do not deviate from the rules below.**

---

## 1. What is ZON

ZON is a **Proof-of-Presence social platform**. Users verify they were physically at a location using on-device AI (liveness detection + scene matching + sensor fusion), collect cryptographically-signed Stamps, earn Badges, and share their experiences.

**Core loop:** Select place → Record video sweep → On-device AI verifies → Stamp created → Badge earned → Shared on feed

---

## 2. Tech Stack (Non-Negotiable)

| Layer | Choice | Notes |
|---|---|---|
| App | Flutter (Dart) | iOS first, Android Phase 2 |
| State Management | Riverpod | Use `@riverpod` code generation |
| Navigation | go_router | Declarative routing only |
| Backend | Supabase | PostgreSQL + Auth + Storage + Realtime + Edge Functions |
| Maps | Mapbox Flutter SDK | Full-screen overlay style (Snapchat-like) |
| On-Device AI | TensorFlow Lite + ONNX Runtime Mobile | See `/lib/core/ai/` |
| Local Storage | Hive | For cached place fingerprints and draft Stamps |
| HTTP | Dio | With interceptors for auth tokens |
| Image | flutter_image_compress + cached_network_image | |
| Camera | camera plugin + custom AR overlay | |
| Location | geolocator + geofence_service | |
| Sensors | sensors_plus | IMU access |

**Never introduce new dependencies without updating `pubspec.yaml` and documenting in `docs/dependencies.md`.**

---

## 3. Project Folder Structure

```
zon/
├── CLAUDE.md                    ← You are here
├── pubspec.yaml
├── docs/
│   ├── schema.sql               ← Supabase DB schema (source of truth)
│   ├── api.md                   ← Edge Function API reference
│   ├── ai-models.md             ← On-device model specs
│   └── dependencies.md          ← All package decisions + reasons
├── supabase/
│   ├── migrations/              ← SQL migration files (numbered)
│   └── functions/               ← Edge Functions (Deno/TypeScript)
│       ├── verify-stamp/
│       ├── tier2-import/
│       └── place-coverage/
├── lib/
│   ├── main.dart
│   ├── app.dart                 ← MaterialApp + go_router setup
│   ├── core/
│   │   ├── ai/                  ← On-device AI pipeline
│   │   │   ├── liveness/        ← Phase 1: optical flow + depth
│   │   │   ├── scene/           ← Phase 2: route A/B/C matching
│   │   │   └── sensor/          ← Phase 3: GPS + WiFi + IMU fusion
│   │   ├── auth/                ← Supabase auth service
│   │   ├── location/            ← GPS + geofencing service
│   │   ├── camera/              ← Camera controller + AR overlay
│   │   └── errors/              ← AppException types + handler
│   ├── data/
│   │   ├── models/              ← Freezed data classes
│   │   │   ├── stamp.dart
│   │   │   ├── place.dart
│   │   │   ├── badge.dart
│   │   │   ├── user_profile.dart
│   │   │   └── auth_tier.dart
│   │   ├── repositories/        ← Abstract interfaces
│   │   └── datasources/
│   │       ├── remote/          ← Supabase calls
│   │       └── local/           ← Hive cache
│   ├── features/
│   │   ├── feed/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── feed_screen.dart
│   │   │       ├── stamp_card.dart
│   │   │       └── stamp_detail_screen.dart
│   │   ├── map/
│   │   │   ├── presentation/
│   │   │   │   ├── map_screen.dart           ← Full-screen Mapbox
│   │   │   │   ├── place_bottom_sheet.dart   ← Nearby places
│   │   │   │   └── place_detail_modal.dart
│   │   ├── auth_cta/            ← The central CTA flow
│   │   │   ├── presentation/
│   │   │   │   ├── place_select_screen.dart
│   │   │   │   ├── video_sweep_screen.dart
│   │   │   │   ├── ai_processing_screen.dart
│   │   │   │   ├── record_edit_screen.dart
│   │   │   │   └── stamp_complete_screen.dart
│   │   ├── place_register/      ← New place registration flow
│   │   ├── timeline/
│   │   │   ├── presentation/
│   │   │   │   ├── timeline_screen.dart
│   │   │   │   ├── calendar_view.dart
│   │   │   │   ├── map_view.dart
│   │   │   │   └── list_view.dart
│   │   └── profile/
│   │       ├── presentation/
│   │       │   ├── profile_screen.dart
│   │       │   ├── badge_gallery.dart
│   │       │   └── conquest_map_screen.dart
│   ├── shared/
│   │   ├── widgets/             ← Reusable widgets (no business logic)
│   │   ├── theme/               ← Design tokens (TBD — placeholder only)
│   │   └── utils/
└── test/
    ├── unit/
    ├── widget/
    └── integration/
```

---

## 4. Architecture Rules

### 4.1 Feature Structure (Clean Architecture)
Every feature follows this pattern:
```
feature/
├── data/
│   ├── datasources/  ← Supabase / Hive calls
│   ├── models/       ← JSON serialization
│   └── repositories/ ← Implements domain interface
├── domain/
│   ├── entities/     ← Pure Dart, no Flutter
│   ├── repositories/ ← Abstract interface
│   └── usecases/     ← Single-responsibility business logic
└── presentation/
    ├── providers/    ← Riverpod providers (state)
    └── screens/      ← UI only, no business logic
```

### 4.2 State Management
- **All state goes through Riverpod providers.** No setState() in screens except for purely local ephemeral UI (e.g., animation controller).
- Use `AsyncNotifierProvider` for data that loads from Supabase.
- Use `NotifierProvider` for synchronous state.
- Provider files live in `features/<name>/presentation/providers/`.

### 4.3 Navigation
- All routes defined in `lib/app.dart` using `go_router`.
- Use named routes only. No `Navigator.push()` directly in widgets.
- Pass only IDs between routes, never full objects.

### 4.4 Error Handling
- All repository methods return `Either<AppException, T>` (using `fpdart`).
- Never swallow exceptions silently.
- UI shows error state, not crash.

---

## 5. AI Pipeline Rules

### 5.1 On-Device Only
- **Images never leave the device.** The AI pipeline runs entirely on-device.
- Only the signed verification result (score + hash + metadata) is sent to Supabase.
- This is a privacy and legal requirement, not a preference.

### 5.2 Pipeline Phases
```
Phase 1 (Liveness Gate) — runs LIVE during recording
  ├── Optical flow: detect flat image (parallax pattern check)
  ├── Depth estimation: Depth Anything V2-S (TFLite, ~24MB)
  └── If FAIL → abort immediately, show user-friendly message

Phase 2 (Scene Matching) — runs AFTER recording completes
  ├── Re-use Phase 1 depth map + flow vectors (no re-inference)
  ├── Route selection: A (outdoor artificial) / B (outdoor natural) / C (indoor)
  ├── Route A: SuperPoint (~1.3MB) + LightGlue (~5MB) + MixVPR (~10MB) + Anchor hard filter
  ├── Route B: GPS precision + terrain silhouette matching
  └── Route C: Wi-Fi RSSI fingerprint + Anchor + MixVPR

Phase 3 (Sensor Fusion) — runs in PARALLEL with Phase 2
  ├── GPS coordinates + timestamp consistency
  ├── Wi-Fi RSSI scan
  └── IMU movement pattern

Final score: S = 0.25·E + 0.35·K + 0.25·D + 0.15·G
  ├── S > 0.75 AND anchor detected → Tier 1 PASS
  ├── 0.5 < S ≤ 0.75 → Challenge-response retry
  └── S ≤ 0.5 OR anchor missing → FAIL
```

### 5.3 Model Files
- All `.tflite` and `.onnx` model files go in `assets/models/`.
- Models are loaded lazily (not at app start).
- Total model size budget: **56MB**.

---

## 6. Supabase Rules

- **Never write raw SQL in Dart code.** Use Supabase client methods or Edge Functions.
- **All user data access must go through RLS policies.** Test RLS before any feature is considered complete.
- Realtime subscriptions: only for feed and notifications. Dispose subscriptions in widget `dispose()`.
- Edge Functions are written in **TypeScript (Deno)**. Located in `supabase/functions/`.
- Environment variables: stored in `.env` (never committed). Access via `flutter_dotenv`.

---

## 7. Coding Conventions

### Dart / Flutter
```dart
// ✅ DO: Use Freezed for data classes
@freezed
class Stamp with _$Stamp {
  const factory Stamp({
    required String id,
    required String placeId,
    required AuthTier tier,
    required DateTime createdAt,
  }) = _Stamp;
}

// ✅ DO: Use sealed classes for states
sealed class StampState {}
class StampInitial extends StampState {}
class StampLoading extends StampState {}
class StampLoaded extends StampState { final List<Stamp> stamps; ... }
class StampError extends StampState { final String message; ... }

// ❌ DON'T: Business logic in widgets
// ❌ DON'T: Direct Supabase calls in widgets
// ❌ DON'T: setState() for anything that persists beyond a rebuild
```

### File Naming
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/methods: `camelCase`
- Constants: `kCamelCase`
- Riverpod providers: `camelCaseProvider`

### Comments
- Every public class and method needs a doc comment (`///`).
- Explain **why**, not **what** the code does.
- Mark unfinished sections with `// TODO(phase2):` or `// TODO(phase3):`.

---

## 8. MVP Scope (M0–M3 Only)

**What IS in MVP:**
- Liveness gate (Phase 1 full)
- Route A authentication pipeline only
- Stamp creation, feed, basic badge system
- Map tab (full-screen Mapbox + conquest lights)
- Timeline (calendar + list view)
- Profile (stats + badge gallery)
- New place registration flow
- Consensus registration (n-round cross-verification)
- Apple + Google social login
- On-device signing + proof certificate
- Privacy controls (visibility settings)

**What is NOT in MVP (do not implement):**
- Route B (outdoor natural) — Phase 2
- Route C (indoor / Wi-Fi RSSI) — Phase 2
- Friends / follow system — Phase 2
- Joint Memory — Phase 2
- Music tagging — Phase 2
- Tier 2 historical import — Phase 3
- Quests / streaks — Phase 3
- Real-time friend location — Phase 3
- B2B dashboard — Phase 4
- Any monetization features — Phase 4

**If asked to implement a non-MVP feature, respond:**
> "This is a Phase [N] feature. I'll add a TODO comment and skip implementation for now."

---

## 9. Security & Privacy Rules (Non-Negotiable)

1. **Images never sent to server.** Only verification score + hash + metadata.
2. **No hardcoded API keys or secrets.** Use `.env` + `flutter_dotenv`.
3. **All Supabase tables have RLS enabled.** No exceptions.
4. **Location data:** Never log raw coordinates to console in production builds.
5. **Verification certificate:** Signed with device Secure Enclave key via `local_auth` + `flutter_secure_storage`.
6. **GDPR:** User data deletion must fully remove all Supabase records + storage objects.

---

## 10. Testing Requirements

- **Unit tests:** All use cases and repository logic.
- **Widget tests:** All screens with meaningful state (feed, auth CTA flow).
- **Integration tests:** Full auth CTA flow end-to-end (M3 before App Store submission).
- Minimum coverage target: **70%** on `lib/core/` and `lib/data/`.
- Run `flutter test` before every PR.

---

## 11. Phase Tracking

Current phase: **M0 (Pre-development)**

Update this section as phases progress:
- [x] M0: Tech validation + schema + folder structure
- [ ] M1: Auth pipeline + core AI
- [ ] M2: Stamp + Feed + Map + Timeline + Profile
- [ ] M3: Place registration + Account + App Store launch
- [ ] M4–M6: Phase 2 features
- [ ] M7–M9: Phase 3 features
- [ ] M10–M12: Phase 4 features

---

## 12. Quick Reference

| Question | Answer |
|---|---|
| Where does business logic go? | `domain/usecases/` |
| Where does Supabase code go? | `data/datasources/remote/` |
| Where do AI models live? | `assets/models/` |
| How do I add a new screen? | Add route in `app.dart` + create screen in `features/<name>/presentation/` |
| How do I share state between features? | Riverpod provider in `lib/core/` or `lib/shared/` |
| Where is the DB schema? | `docs/schema.sql` |
| Can I send images to server? | **NO. Never.** |
| Can I use setState()? | Only for purely local ephemeral UI (animations, text fields) |
