import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import '../image_preprocessor.dart';
import '../pipeline.dart';

/// Phase 2 scene matching — Route A (outdoor artificial).
///
/// Runs after recording completes, reusing Phase 1 depth map + flow vectors.
/// Pipeline:
///   1. MixVPR     → global 512-dim scene embedding (cosine vs stored ref)
///   2. SuperPoint → keypoints + descriptors on best 3 frames
///   3. LightGlue  → keypoint matches → inlier count
///   4. Anchor hard-filter (descriptor cosine vs stored anchor)
///   5. Depth signature comparison vs stored spatial fingerprint
class SceneMatcher {
  OrtSession? _superPoint;
  OrtSession? _lightGlue;
  OrtSession? _mixvpr;

  Future<void> load() async {
    OrtEnv.instance.init();
    final futures = await Future.wait([
      rootBundle.load('assets/models/superpoint.onnx'),
      rootBundle.load('assets/models/lightglue_lite.onnx'),
      rootBundle.load('assets/models/mixvpr.onnx'),
    ]);
    _superPoint = OrtSession.fromBuffer(
        futures[0].buffer.asUint8List(), OrtSessionOptions());
    _lightGlue = OrtSession.fromBuffer(
        futures[1].buffer.asUint8List(), OrtSessionOptions());
    _mixvpr = OrtSession.fromBuffer(
        futures[2].buffer.asUint8List(), OrtSessionOptions());
  }

  /// Run full Route A scene matching.
  ///
  /// [frames] — best 3-5 JPEG frames from the recording buffer.
  /// [livenessPass] — reused depth map + flow from Phase 1.
  /// [place] — stored reference data loaded from Supabase.
  Future<SceneMatchResult> match({
    required List<Uint8List> frames,
    required LivenessPass livenessPass,
    required PlaceReference place,
  }) async {
    assert(_superPoint != null && _lightGlue != null && _mixvpr != null,
        'Call load() before match()');

    // ── Step 1: MixVPR global embedding ──────────────────────────────────
    final bestFrame = frames.first;
    final rgbTensor = await ImagePreprocessor.toRgbTensor(bestFrame, 224, 224);
    final embedding = await _runMixvpr(rgbTensor);
    final embeddingScore = place.globalEmbedding != null
        ? _cosineSimilarity(embedding, place.globalEmbedding!)
        : 0.5; // no reference stored yet — neutral

    // ── Step 2: SuperPoint keypoints on best 3 frames ────────────────────
    final allDescs = <Float32List>[];
    final allKpts  = <Float32List>[];
    for (final frame in frames.take(3)) {
      final grayTensor =
          await ImagePreprocessor.toGrayTensor(frame, 320, 240);
      final result = await _runSuperPoint(grayTensor);
      allDescs.add(result.descriptors);
      allKpts.add(result.kpts);
    }

    // ── Step 3: LightGlue matching between frame 0 and frame 1 ──────────
    int inlierCount = 0;
    if (allDescs.length >= 2) {
      inlierCount = await _runLightGlue(
          allDescs[0], allDescs[1], allKpts[0], allKpts[1]);
    }
    final keypointScore = math.min(inlierCount / 200.0, 1.0);

    // ── Step 4: Anchor hard-filter ────────────────────────────────────────
    bool anchorDetected = true; // pass-through if no anchor stored yet
    if (place.anchorDescriptor != null && allDescs.isNotEmpty) {
      final anchorSim =
          _cosineSimilarity(allDescs.first, place.anchorDescriptor!);
      anchorDetected = anchorSim > 0.6;
    }

    // ── Step 5: Depth signature comparison ───────────────────────────────
    final depthScore = place.depthFingerprint != null
        ? _cosineSimilarity(livenessPass.depthMap, place.depthFingerprint!)
        : 0.5; // no reference yet — neutral

    return SceneMatchResult(
      route: AuthRoute.a,
      anchorDetected: anchorDetected,
      embeddingScore: embeddingScore,
      keypointScore: keypointScore,
      depthScore: depthScore,
      inlierCount: inlierCount,
      embedding: embedding,
    );
  }

  void dispose() {
    _superPoint?.release();
    _lightGlue?.release();
    _mixvpr?.release();
    _superPoint = null;
    _lightGlue = null;
    _mixvpr = null;
  }

  // ── Model runners ─────────────────────────────────────────────────────

  Future<Float32List> _runMixvpr(Float32List rgb) async {
    final opts  = OrtRunOptions();
    // Model bakes ImageNet normalization — caller passes raw [0,1] RGB
    final input = OrtValueTensor.createTensorWithDataList(rgb, [1, 3, 224, 224]);
    final out = _mixvpr!.run(opts, {'image': input});
    // Output: [1, 576] L2-normalized embedding from MobileNetV3-Small backbone
    final raw = out.first?.value as List<List<double>>;
    final vec = Float32List.fromList(raw[0].map((v) => v.toDouble()).toList());
    input.release();
    opts.release();
    return vec;
  }

  /// Fixed keypoint count used as the LightGlue sequence length.
  static const int _kN = 256;

  Future<({int keypointCount, Float32List descriptors, Float32List kpts})> _runSuperPoint(
      Float32List gray) async {
    final opts  = OrtRunOptions();
    final input =
        OrtValueTensor.createTensorWithDataList(gray, [1, 1, 240, 320]);
    final out = _superPoint!.run(opts, {'image': input});

    // out[0] = scores [1, 65, 30, 40]  (64 sub-pixel bins + dustbin)
    // out[1] = descriptors [1, 256, 30, 40]
    final rawScores = <double>[];
    final rawDescs  = <double>[];
    void flattenInto(dynamic v, List<double> buf) {
      if (v is double) { buf.add(v); }
      else if (v is List) { for (final e in v) flattenInto(e, buf); }
    }
    flattenInto(out[0]?.value, rawScores); // [65 × 30 × 40] = 78 000
    flattenInto(out[1]?.value, rawDescs);  // [256 × 30 × 40] = 307 200

    // Pick top-_kN cells by max score across the 64 (non-dustbin) channels.
    // Score layout: [c, row, col], c in [0,64), cell stride = 30*40 = 1200
    const cellH = 30, cellW = 40, cells = cellH * cellW; // 1200 cells
    final cellScores = List<({double score, int cell})>.generate(cells, (ci) {
      var best = -1e9;
      for (var c = 0; c < 64; c++) {
        final v = rawScores[c * cells + ci];
        if (v > best) best = v;
      }
      return (score: best, cell: ci);
    });
    cellScores.sort((a, b) => b.score.compareTo(a.score));
    final topCells = cellScores.take(_kN).toList();
    final keypointCount = topCells.where((e) => e.score > 0.0).length;

    // Build [_kN, 2] keypoint pixel coords and [_kN, 256] descriptors
    final kpts  = Float32List(_kN * 2);
    final descs = Float32List(_kN * 256);
    for (var i = 0; i < _kN; i++) {
      final ci   = topCells[i].cell;
      final row  = ci ~/ cellW;
      final col  = ci % cellW;
      kpts[i * 2]     = col * 8.0 + 4.0; // centre of 8×8 cell, x
      kpts[i * 2 + 1] = row * 8.0 + 4.0; // centre of 8×8 cell, y
      // Descriptor for this cell: rawDescs layout [256, 30, 40]
      for (var d = 0; d < 256; d++) {
        descs[i * 256 + d] = rawDescs[d * cells + ci];
      }
    }

    input.release();
    opts.release();
    return (keypointCount: keypointCount, descriptors: descs, kpts: kpts);
  }

  Future<int> _runLightGlue(
      Float32List desc0, Float32List desc1,
      Float32List kpts0, Float32List kpts1) async {
    final opts = OrtRunOptions();
    final d0   = OrtValueTensor.createTensorWithDataList(desc0, [1, _kN, 256]);
    final d1   = OrtValueTensor.createTensorWithDataList(desc1, [1, _kN, 256]);
    final k0   = OrtValueTensor.createTensorWithDataList(kpts0, [1, _kN, 2]);
    final k1   = OrtValueTensor.createTensorWithDataList(kpts1, [1, _kN, 2]);
    // Model: 3 pretrained LightGlue transformer layers, inputs: kpts0/1 + desc0/1
    final out  = _lightGlue!.run(opts, {
      'kpts0': k0, 'kpts1': k1, 'desc0': d0, 'desc1': d1,
    });

    var matches = 0;
    void count(dynamic v) {
      if (v is double && v > 0.5) matches++;
      else if (v is List) { for (final e in v) count(e); }
    }
    count(out.first?.value);

    d0.release(); d1.release();
    k0.release(); k1.release();
    opts.release();
    return matches;
  }

  static double _cosineSimilarity(Float32List a, Float32List b) {
    final len = math.min(a.length, b.length);
    double dot = 0, normA = 0, normB = 0;
    for (var i = 0; i < len; i++) {
      dot   += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    final denom = math.sqrt(normA) * math.sqrt(normB);
    return denom > 0 ? (dot / denom).clamp(0.0, 1.0) : 0.0;
  }
}

/// Stored reference data for a place, loaded from Supabase.
class PlaceReference {
  const PlaceReference({
    this.globalEmbedding,
    this.anchorDescriptor,
    this.depthFingerprint,
  });

  final Float32List? globalEmbedding;   // MixVPR 576-dim L2 (MobileNetV3-Small backbone)
  final Float32List? anchorDescriptor;  // SuperPoint descriptor bytes
  final Float32List? depthFingerprint;  // depth map spatial signature
}
