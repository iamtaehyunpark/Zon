# ZON — Dependency Decisions

All packages added to `pubspec.yaml` are documented here with rationale.
**Never add a package without updating this file.**

---

## Runtime Dependencies

| Package | Version | Reason |
|---------|---------|--------|
| `flutter_riverpod` | ^2.5.1 | State management — code-gen style with `@riverpod` annotation |
| `riverpod_annotation` | ^2.5.1 | Code generation annotations for Riverpod |
| `go_router` | ^14.0.0 | Declarative routing; supports ShellRoute for persistent tab bar |
| `supabase_flutter` | ^2.5.0 | Backend: PostgreSQL + Auth + Storage + Realtime |
| `mapbox_maps_flutter` | ^2.2.0 | Full-featured Mapbox SDK; required for conquest map style and custom layers |
| `camera` | ^0.11.0 | Live camera preview for the video sweep screen |
| `tflite_flutter` | ^0.10.4 | Run TFLite models on-device (Depth Anything V2-S, MixVPR) |
| `onnxruntime` | ^1.4.1 | Run ONNX models on-device (SuperPoint, LightGlue) |
| `geolocator` | ^12.0.0 | GPS position + accuracy for sensor fusion (Phase 3) |
| `geofence_service` | ^6.0.0+1 | Background geofencing to detect proximity to registered Places |
| `sensors_plus` | ^4.0.2 | IMU access (accelerometer, gyroscope) for Phase 3 sensor fusion |
| `freezed_annotation` | ^2.4.4 | Immutable data classes with `copyWith`, pattern matching |
| `json_annotation` | ^4.9.0 | JSON serialization for Freezed models |
| `hive_flutter` | ^1.1.0 | Local storage for cached place fingerprints and draft Stamps |
| `dio` | ^5.4.3 | HTTP client with interceptors for auth token injection |
| `connectivity_plus` | ^6.0.3 | Detect network state for offline stamp queueing |
| `image_picker` | ^1.1.0 | Photo selection for stamp attachments |
| `flutter_image_compress` | ^2.2.0 | Compress photos before upload to Supabase Storage |
| `cached_network_image` | ^3.3.1 | Cache remote stamp photos and avatars |
| `video_player` | ^2.8.3 | Playback of recorded video sweeps in review screen |
| `record` | ^5.2.1 | Audio recording for optional stamp voice notes |
| `local_auth` | ^2.3.0 | Biometric + device credential auth for Secure Enclave signing |
| `flutter_secure_storage` | ^9.2.4 | Store verification certificate private key in Keychain / Keystore |
| `flutter_dotenv` | ^5.2.1 | Load `.env` at startup; keeps secrets out of source code |
| `intl` | ^0.19.0 | Date/time formatting for timeline and stamp timestamps |
| `path_provider` | ^2.1.3 | Access to app documents/cache directories for Hive and model cache |
| `share_plus` | ^9.0.0 | Native share sheet for stamp sharing |
| `url_launcher` | ^6.3.0 | Open external links (place websites, social profiles) |
| `permission_handler` | ^11.4.0 | Unified permission requests (camera, location, microphone) |
| `uuid` | ^4.4.0 | Client-side UUID generation for draft Stamps before server sync |
| `crypto` | ^3.0.3 | SHA-256 hashing for verification certificate |
| `fpdart` | ^1.1.0 | `Either<AppException, T>` return type for all repository methods |

---

## Dev Dependencies

| Package | Version | Reason |
|---------|---------|--------|
| `build_runner` | ^2.4.9 | Runs code generation for Freezed, json_serializable, Riverpod |
| `freezed` | ^2.5.8 | Code generator for immutable Freezed classes |
| `json_serializable` | ^6.9.5 | Code generator for `fromJson`/`toJson` |
| `riverpod_generator` | ^2.6.4 | Code generator for `@riverpod` annotated providers |
| `mockito` | ^5.4.6 | Mock generation for unit tests |
| `flutter_lints` | ^4.0.0 | Enforced lint rules; matches `analysis_options.yaml` |

---

## Removed / Rejected Packages

| Package | Reason rejected |
|---------|----------------|
| `wifi_scan` | Phase 2 only (Route C indoor verification); not needed for MVP |
| `arkit_plugin` | Replaced by custom `CustomPainter` AR overlay; plugin is unmaintained |
| `ar_flutter_plugin` | Android Phase 2; not in MVP scope |

---

## Notes

- `geofence_service` is discontinued (replaced by `geofencing_api`) but still functional. Migrate in Phase 2.
- All model binaries (`.tflite`, `.onnx`) are listed in `.gitignore` — download separately via `scripts/download_models.sh` (TODO M1).
