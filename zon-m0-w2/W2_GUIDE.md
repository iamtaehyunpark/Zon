# ZON — M0 Week 2: AI Model Validation Guide

## Goal

Confirm every AI model runs on a physical iPhone within latency budget
before writing a single line of feature code.

**If any model fails: stop, resolve, then continue. Do not proceed to M1 with unresolved model issues.**

---

## Step 1: Download Model Weights

### Depth Anything V2-Small
```bash
# Option A — Auto (via conversion script)
python scripts/convert_models.py --model depth

# Option B — Manual (if HuggingFace download fails)
# 1. Go to: https://huggingface.co/depth-anything/Depth-Anything-V2-Small-hf
# 2. Download model weights
# 3. Run: python scripts/convert_models.py --model depth
#    (script will detect local weights and skip download)

# Option C — Use pre-converted TFLite (community)
# https://huggingface.co/collections/depth-anything (check for .tflite releases)
```

### SuperPoint
```bash
# Option A — Official pretrained weights
curl -L https://github.com/magicleap/SuperPointPretrainedNetwork/raw/master/superpoint_v1.pth \
     -o scripts/superpoint_v1.pth
python scripts/convert_models.py --model superpoint

# Option B — Use ALIKE (lighter alternative, same interface)
# https://github.com/Shiaoming/ALIKE
# Replace superpoint.onnx with alike-n.onnx and update model_validator.dart input shapes
```

### LightGlue Lite
```bash
# Option A — From official repo
git clone https://github.com/cvg/LightGlue.git scripts/LightGlue
python scripts/convert_models.py --model lightglue

# Option B — Use LoFTR (alternative matcher, ONNX available)
# https://github.com/zju3dv/LoFTR
# Heavier (~45MB) but easier ONNX export

# Option C — Use SuperGlue (Magic Leap, same ecosystem as SuperPoint)
# https://github.com/magicleap/SuperGluePretrainedNetwork
```

### MixVPR
```bash
# Option A — Official pretrained checkpoint
# https://github.com/amaralibey/MixVPR/releases
# Download: resnet50_R512_G512.ckpt → save as scripts/mixvpr_resnet50_R_512_G_512.ckpt
python scripts/convert_models.py --model mixvpr

# Option B — Use EigenPlaces (lighter, similar accuracy)
# https://github.com/gmberton/EigenPlaces
# Download ONNX directly from releases

# Option C — Use NetVLAD (proven, widely tested on mobile)
# https://github.com/Nanne/pytorch-NetVlad
```

---

## Step 2: Copy to Flutter Assets

```bash
# After conversion:
ls assets/models/
# Expected:
#   depth_anything_v2_small.tflite   (~24MB)
#   superpoint.onnx                  (~1.3MB)
#   lightglue_lite.onnx              (~5MB)
#   mixvpr.tflite                    (~10MB)

# Total should be < 56MB
du -sh assets/models/
```

Update `pubspec.yaml` if not already done:
```yaml
flutter:
  assets:
    - assets/models/
```

---

## Step 3: Add Validation Screen (Temporary)

In `lib/app.dart`, add a temporary debug route:
```dart
GoRoute(
  path: '/debug/models',
  name: 'debug-models',
  builder: (_, __) => const ModelValidationScreen(),
),
```

Add a temporary button in `ProfileScreen` (bottom of screen, remove before M1):
```dart
// TODO(M0): Remove before M1
if (kDebugMode)
  TextButton(
    onPressed: () => context.pushNamed('debug-models'),
    child: const Text('M0: Validate AI Models'),
  ),
```

---

## Step 4: Run on Physical Device

```bash
# Connect iPhone via USB
flutter run --release    # IMPORTANT: run in release mode for realistic NPU latency
```

Navigate to the debug model validation screen and tap **Run Validation**.

---

## Step 5: Record Results

Fill in actual measurements below:

```
Device tested: _______________  (e.g., iPhone 14 Pro)
iOS version:   _______________
Date:          _______________

Model                        | Loaded | Size (MB) | Latency (ms) | Budget | Pass?
-----------------------------|--------|-----------|--------------|--------|------
depth_anything_v2_small      |        |           |              | 300ms  |
superpoint                   |        |           |              |  50ms  |
lightglue_lite               |        |           |              | 150ms  |
mixvpr                       |        |           |              | 100ms  |
-----------------------------|--------|-----------|--------------|--------|------
TOTAL PIPELINE               |        |           |              | 800ms  |
```

Paste results into `docs/ai-models.md` under "Validated Latency" section.

---

## Step 6: Gate Check

Before proceeding to M0 Week 3, confirm:

```
[ ] All 4 models load without crash on physical iPhone
[ ] All 4 models pass latency budget
[ ] Total pipeline < 800ms
[ ] Total model size < 56MB
[ ] No memory warnings during inference
[ ] flutter analyze → 0 issues after adding model_validator.dart and pipeline.dart
```

---

## Fallback Decision Tree

```
depth_anything fails:
  → Try MiDaS V2 (tflite already available)
    https://tfhub.dev/intel/midas/v2_1_small/1

superpoint fails:
  → Try ALIKE-N (smaller, ONNX friendly)
    https://github.com/Shiaoming/ALIKE

lightglue fails:
  → Use cosine similarity matching only (no LightGlue)
  → Rely more on MixVPR global embedding + anchor hard filter
  → Reduces K weight in scoring formula

mixvpr fails:
  → Try CosPlace (similar architecture, often smaller)
    https://github.com/gmberton/CosPlace
  → Or NetVLAD (proven mobile deployment)
```

---

## File Placement After Week 2

```
zon/
├── assets/models/
│   ├── depth_anything_v2_small.tflite   ✅
│   ├── superpoint.onnx                  ✅
│   ├── lightglue_lite.onnx              ✅
│   └── mixvpr.tflite                    ✅
├── lib/core/ai/
│   ├── pipeline.dart                    ✅ (types + interfaces)
│   ├── model_validator.dart             ✅ (M0 validation only)
│   ├── liveness/
│   │   └── liveness_detector.dart       ✅ (skeleton)
│   ├── scene/
│   │   └── scene_matcher.dart           ✅ (skeleton)
│   └── sensor/
│       └── sensor_fusion.dart           ✅ (skeleton)
├── scripts/
│   └── convert_models.py                ✅
└── docs/
    └── ai-models.md                     → update with actual measurements
```

When Week 2 is complete, update `docs/m0-checklist.md` Week 2 items and proceed to Week 3.
