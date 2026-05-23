# ZON — M0 Pre-Development Checklist

Complete every item before writing feature code.
Claude Code: work through this list top-to-bottom.

---

## Week 1 — Environment Setup

- [ ] Create Flutter project: `flutter create zon --org app.getzon --platforms ios,android`
- [ ] Add all dependencies from `docs/flutter-structure.md` to `pubspec.yaml`
- [ ] Create folder structure exactly as defined in `CLAUDE.md §3`
- [ ] Set up Supabase project (free tier)
- [ ] Configure `.env` with Supabase URL + anon key + Mapbox token
- [ ] Set up GitHub repo + branch protection (main requires PR)
- [ ] Configure GitHub Actions: `flutter analyze` + `flutter test` on every PR
- [ ] Set up Fastlane (iOS only for M0)
- [ ] Add `CLAUDE.md` to project root
- [ ] Verify `flutter run` on iOS simulator with no errors

---

## Week 2 — AI Model Validation (CRITICAL)

- [ ] Download Depth Anything V2-Small weights
- [ ] Convert to TFLite: `python convert_depth_anything.py`
- [ ] Verify TFLite runs on iOS simulator (CPU fallback OK for validation)
- [ ] Verify TFLite runs on physical iPhone with Core ML delegate
- [ ] Measure inference latency on iPhone (target: <300ms per frame)
- [ ] Download SuperPoint weights + convert to ONNX
- [ ] Verify ONNX Runtime Mobile runs SuperPoint on device
- [ ] Download LightGlue (lite) weights + verify ONNX
- [ ] Download MixVPR weights + convert to TFLite
- [ ] Measure full Phase 1+2 pipeline latency (target: <800ms total)
- [ ] **GATE: If any model fails, resolve before proceeding to Week 3**
- [ ] Document actual model sizes in `docs/ai-models.md`
- [ ] Document actual latency measurements in `docs/ai-models.md`

---

## Week 3 — Database & UX Foundation

- [ ] Run `docs/schema.sql` in Supabase SQL editor
- [ ] Verify all RLS policies work: test as anonymous, authenticated, and service_role
- [ ] Create Supabase Storage buckets: `stamps` (public), `audio` (authenticated), `avatars` (public)
- [ ] Set up PostGIS extension (required for `places_within_radius` function)
- [ ] Enable `pgvector` extension (required for `global_embedding` column)
- [ ] Seed landmarks: run `scripts/seed_landmarks.sql` (Google Places API → 100 records)
- [ ] Create Freezed data models for: `Stamp`, `Place`, `Badge`, `UserProfile`, `AuthTier`
- [ ] Run `build_runner` and verify generated files
- [ ] Set up go_router with all routes from `docs/flutter-structure.md`
- [ ] Verify navigation between all 5 tabs works
- [ ] Set up Riverpod providers skeleton (empty implementations, no logic yet)
- [ ] Implement `MainShell` widget with bottom tab bar

---

## Week 4 — Integration Validation

- [ ] Supabase Auth: Apple Sign-In working end-to-end on device
- [ ] Supabase Auth: Google Sign-In working end-to-end on device
- [ ] Mapbox: full-screen map renders on device (conquest map style)
- [ ] Mapbox: `places_within_radius` Postgres function returns results on map
- [ ] Camera plugin: live preview renders without lag
- [ ] Geolocator: GPS permissions + location fix working
- [ ] All models loaded lazily without app startup delay
- [ ] End-to-end smoke test: login → see map → tap place → camera opens
- [ ] M1 sprint plan finalized with 2-week sprints

---

## Validation Sign-Off

Before starting M1, confirm:

```
[ ] AI pipeline runs <800ms on target device (iPhone 12 or newer)
[ ] Supabase schema deployed with all RLS policies active
[ ] All 5 navigation tabs render without errors
[ ] Apple + Google login works on physical device
[ ] No hardcoded secrets in codebase
[ ] flutter analyze returns 0 errors, 0 warnings
```

**Do not start M1 until all items above are checked.**
