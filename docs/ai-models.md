# ZON — On-Device AI Models

All models run entirely on-device. **No image data is ever sent to a server.**

---

## Model Inventory

| ID | Model | Format | M0 Size | Target Format (M1) | Role | Phase |
|----|-------|--------|---------|-------------------|------|-------|
| M1 | Depth Anything V2-Small | ONNX (INT8) | 27 MB | TFLite fp16 ~24 MB | Liveness detection (depth variance) | MVP |
| M2 | SuperPoint | ONNX | 5.0 MB | ONNX ~1.3 MB (needs pretrained weights) | Keypoint extraction (Route A) | MVP |
| M3 | LightGlue (lite) | ONNX (stub) | 4.2 MB | ONNX ~5 MB (needs kornia for full export) | Keypoint matching (Route A) | MVP |
| M4 | MixVPR | ONNX (stub) | 4.7 MB | TFLite ~10 MB (needs real weights) | Global scene embedding (Route A/C) | MVP |
| M5 | MVSNet (lite) | — | — | TFLite ~15 MB | Spatial fingerprint / point cloud (registration) | MVP |
| M6 | Terrain Silhouette | — | — | TFLite ~2 MB | Natural terrain matching (Route B) | Phase 2 |

**M0 total (assets/models/):** ~41 MB (budget: 56 MB) ✅

**M1 action items before latency gate:**
- M2 SuperPoint: download pretrained weights from Magic Leap and re-export
- M3 LightGlue: `pip install kornia` then re-run `convert_models.py --model lightglue`
- M4 MixVPR: download checkpoint from amaralibey/MixVPR releases and re-export to TFLite
- M1 Depth Anything: downgrade `onnx` to `1.14.x` to re-enable `onnx_tf` TFLite path, or use `ai_edge_torch`

---

## Asset Location

```
assets/
└── models/
    ├── depth_anything_v2_small.tflite    # M1
    ├── superpoint.onnx                   # M2
    ├── lightglue_lite.onnx               # M3
    ├── mixvpr.tflite                     # M4
    └── mvs_lite.tflite                   # M5
```

Add to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/models/
```

---

## Pipeline Execution

### Phase 1 — Liveness Gate (live, during recording)

```
Input:  video frames (30fps, RGB)
Models: M1 (Depth Anything V2-S)

Steps:
1. Run M1 on every 5th frame → depth map (256×256)
2. Compute depth variance across map
   - variance < threshold (0.02) → flat surface → FAIL immediately
3. Compute optical flow between consecutive frames (OpenCV / TFLite)
   - uniform flow (no parallax) → FAIL
4. Pass: buffer depth maps + flow vectors for Phase 2 reuse

Latency target: <100ms per frame check
```

### Phase 2 — Scene Matching (post-recording, Route A)

```
Input:  best 3-5 frames selected from recording buffer
        + depth maps + flow vectors from Phase 1 (reused, no re-inference)
Models: M2 (SuperPoint) + M3 (LightGlue) + M4 (MixVPR)

Steps:
1. Run M4 on single best frame → 512-dim embedding vector
   - Cosine similarity vs reference embedding from place DB
   - Score: E (0.0–1.0)

2. Run M2 on best 3 frames → keypoint sets (x,y,descriptor)

3. Run M3 on keypoint pairs → matches + inlier count
   - inlier_count < 30 → anchor hard-filter FAIL
   - Score: K = min(inlier_count / 200, 1.0)

4. Anchor object check (HARD FILTER):
   - Run descriptor match for stored anchor descriptor
   - No match → immediate FAIL regardless of other scores

5. Depth signature comparison:
   - Compare depth map structure vs stored spatial fingerprint
   - Score: D (0.0–1.0)

Final score: S = 0.25·E + 0.35·K + 0.25·D + 0.15·G
  where G = sensor fusion score from Phase 3

Latency target: <700ms total (GPU/NPU delegated)
```

### Phase 2 — Scene Matching (Route B — Phase 2)

```
Input:  GPS coordinates + terrain silhouette frame
Models: M6 (Terrain Silhouette)

Steps:
1. GPS precision check: accuracy < 10m required
2. Run M6 → terrain horizon profile descriptor
3. Compare vs stored silhouette profile
4. Score: weighted GPS precision + silhouette match
```

### Phase 2 — Scene Matching (Route C — Phase 2)

```
Input:  Wi-Fi RSSI scan + frames
Models: M4 (MixVPR)

Steps:
1. Scan Wi-Fi APs → {bssid: rssi} fingerprint
2. Compare vs stored RSSI fingerprint (cosine similarity on sorted RSSI vector)
   - Score: W (0.0–1.0)
3. Run M4 → global embedding comparison
4. Anchor check (uses entrance/exterior anchor, more stable than interior)
Final score uses W in place of G (GPS not reliable indoors)
```

### Phase 3 — Sensor Fusion (parallel with Phase 2)

```
Input:  GPS, Wi-Fi scan, IMU, timestamp history

Steps:
1. GPS: compare coordinates vs place.lat/lng
   - distance < 100m → score 1.0, linear decay to 500m
2. Timestamp consistency: check vs last known location
   - physically impossible travel speed → FAIL the entire verification
   - (e.g., Seoul → Paris in 10 minutes)
3. Wi-Fi RSSI: match pattern vs stored fingerprint (if Route A/B)
4. IMU: confirm physical movement during video sweep
   - stationary device → suspicious flag (not hard fail)

Score: G = weighted combination of above
```

---

## Route Selection Logic

```dart
// Pseudo-code for route auto-detection (used for unregistered places)
AuthRoute selectRoute({
  required double gpsAccuracy,      // meters
  required int keypointDensity,     // detected keypoints count
  required double depthVariance,    // from Phase 1
  required bool hasWifi,
}) {
  if (gpsAccuracy > 50 || depthVariance < 0.05) {
    // Indoors or GPS unreliable
    return hasWifi ? AuthRoute.C : AuthRoute.Cprime;
  }
  if (keypointDensity < 50) {
    // Low texture — likely natural environment
    return AuthRoute.B;
  }
  return AuthRoute.A; // Default: outdoor artificial
}
```

For **registered places**: route is fixed from `place.space_type`. Never auto-detected.

---

## Model Loading

Models are loaded **lazily** — only when the auth pipeline starts.
Do NOT load at app startup. Do NOT keep all models in memory simultaneously.

```dart
// Pattern: load on demand, dispose after use
class DepthEstimator {
  late final Interpreter _interpreter;

  Future<void> load() async {
    final modelData = await rootBundle.load('assets/models/depth_anything_v2_small.tflite');
    _interpreter = await Interpreter.fromBuffer(modelData.buffer.asUint8List());
  }

  void dispose() => _interpreter.close();
}
```

---

## NPU Acceleration

| Platform | Delegate | Notes |
|----------|----------|-------|
| iOS | Core ML delegate | Auto-enabled for A12+ chips |
| Android | NNAPI delegate | Fallback to GPU delegate if unavailable |

```dart
// TFLite delegate setup
final options = InterpreterOptions();
if (Platform.isIOS) {
  options.addDelegate(CoreMLDelegate());
} else {
  options.addDelegate(NnApiDelegate());
}
```
