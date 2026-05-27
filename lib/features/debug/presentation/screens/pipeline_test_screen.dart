import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:onnxruntime/onnxruntime.dart';
import '../../../../core/ai/image_preprocessor.dart';

/// Debug screen — feeds a real camera frame through all 4 models and reports
/// output statistics to verify end-to-end correctness on device.
class PipelineTestScreen extends StatefulWidget {
  const PipelineTestScreen({super.key});

  @override
  State<PipelineTestScreen> createState() => _PipelineTestScreenState();
}

class _PipelineTestScreenState extends State<PipelineTestScreen> {
  CameraController? _cam;
  bool _initialising = true;
  bool _running = false;
  _PipelineResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cam?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      setState(() { _initialising = false; _error = 'No cameras found'; });
      return;
    }
    final ctrl = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
    await ctrl.initialize();
    if (mounted) setState(() { _cam = ctrl; _initialising = false; });
  }

  Future<void> _runPipeline() async {
    if (_cam == null || _running) return;
    setState(() { _running = true; _result = null; _error = null; });
    try {
      final file  = await _cam!.takePicture();
      final bytes = await file.readAsBytes();
      final result = await _runModels(bytes);
      if (mounted) setState(() { _result = result; _running = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _running = false; });
    }
  }

  Future<_PipelineResult> _runModels(Uint8List jpeg) async {
    OrtEnv.instance.init();
    final sw = Stopwatch()..start();

    // ── Depth (MiDaS Small, INT8 quantized) ─────────────────────────────
    // Apply ImageNet normalization before feeding
    final rgb256Raw = await ImagePreprocessor.toRgbTensor(jpeg, 256, 256);
    const mean = [0.485, 0.456, 0.406];
    const std  = [0.229, 0.224, 0.225];
    final rgb256 = Float32List(rgb256Raw.length);
    for (var i = 0; i < 256 * 256; i++) {
      rgb256[i]                 = (rgb256Raw[i]                 - mean[0]) / std[0];
      rgb256[256*256 + i]       = (rgb256Raw[256*256 + i]       - mean[1]) / std[1];
      rgb256[2 * 256*256 + i]   = (rgb256Raw[2 * 256*256 + i]   - mean[2]) / std[2];
    }
    final depthResult = await _runDepth(rgb256);

    // ── MixVPR (MobileNetV3-Small, 576-dim, normalization baked in) ──────
    final rgb224 = await ImagePreprocessor.toRgbTensor(jpeg, 224, 224); // [0,1]
    final mixvprResult = await _runMixvpr(rgb224);

    // ── SuperPoint (Magic Leap pretrained) ─────────────────────────────
    final gray = await ImagePreprocessor.toGrayTensor(jpeg, 320, 240);
    final spResult = await _runSuperPoint(gray);

    // ── LightGlue (3 pretrained layers, self-match as baseline) ─────────
    final lgResult = await _runLightGlue(spResult.kpts, spResult.descs);

    final totalMs = sw.elapsedMilliseconds.toDouble();
    final depthImg = await ImagePreprocessor.depthToImage(depthResult.depthMap, 256, 256);

    return _PipelineResult(
      depthVariance: depthResult.variance,
      depthImage: depthImg,
      depthMs: depthResult.ms,
      keypointCount: spResult.keypointCount,
      superPointMs: spResult.ms,
      embeddingNorm: mixvprResult.norm,
      mixvprMs: mixvprResult.ms,
      matchCount: lgResult.matchCount,
      lightGlueMs: lgResult.ms,
      totalMs: totalMs,
    );
  }

  // ── Model runners ──────────────────────────────────────────────────────

  Future<({Float32List depthMap, double variance, double ms})> _runDepth(
      Float32List rgb) async {
    final data = await _load('assets/models/depth_anything_v2_small.onnx');
    final sess = OrtSession.fromBuffer(data, OrtSessionOptions());
    final opts = OrtRunOptions();
    final inp  = OrtValueTensor.createTensorWithDataList(rgb, [1, 3, 256, 256]);

    final sw  = Stopwatch()..start();
    final out = sess.run(opts, {'image': inp}); // MiDaS input name is 'image'
    final ms  = sw.elapsedMilliseconds.toDouble();

    // Output: [1, H, W] — 3D tensor
    final raw  = out.first?.value as List<List<List<double>>>;
    final flat = Float32List.fromList(
        raw[0].expand((row) => row.map((v) => v.toDouble())).toList());

    inp.release(); opts.release(); sess.release();
    return (depthMap: flat, variance: ImagePreprocessor.variance(flat), ms: ms);
  }

  static const _kN = 256; // fixed keypoint count

  Future<({int keypointCount, Float32List kpts, Float32List descs, double ms})>
      _runSuperPoint(Float32List gray) async {
    final data = await _load('assets/models/superpoint.onnx');
    final sess = OrtSession.fromBuffer(data, OrtSessionOptions());
    final opts = OrtRunOptions();
    final inp  = OrtValueTensor.createTensorWithDataList(gray, [1, 1, 240, 320]);

    final sw  = Stopwatch()..start();
    final out = sess.run(opts, {'image': inp});
    final ms  = sw.elapsedMilliseconds.toDouble();

    // out[0] = scores [1, 65, 30, 40], out[1] = descriptors [1, 256, 30, 40]
    final rawScores = <double>[];
    final rawDescs  = <double>[];
    void flattenInto(dynamic v, List<double> buf) {
      if (v is double) buf.add(v);
      else if (v is List) { for (final e in v) flattenInto(e, buf); }
    }
    flattenInto(out[0]?.value, rawScores);
    flattenInto(out[1]?.value, rawDescs);

    // Pick top-_kN cells by score (64 non-dustbin channels, 30×40 = 1200 cells)
    const cells = 30 * 40;
    final cellScores = List.generate(cells, (ci) {
      var best = -1e9;
      for (var c = 0; c < 64; c++) {
        final v = rawScores[c * cells + ci];
        if (v > best) best = v;
      }
      return (score: best, cell: ci);
    });
    cellScores.sort((a, b) => b.score.compareTo(a.score));
    final top = cellScores.take(_kN).toList();
    final keypointCount = top.where((e) => e.score > 0.0).length;

    final kpts  = Float32List(_kN * 2);
    final descs = Float32List(_kN * 256);
    for (var i = 0; i < _kN; i++) {
      final ci  = top[i].cell;
      final row = ci ~/ 40;
      final col = ci %  40;
      kpts[i * 2]     = col * 8.0 + 4.0;
      kpts[i * 2 + 1] = row * 8.0 + 4.0;
      for (var d = 0; d < 256; d++) {
        descs[i * 256 + d] = rawDescs[d * cells + ci];
      }
    }

    inp.release(); opts.release(); sess.release();
    return (keypointCount: keypointCount, kpts: kpts, descs: descs, ms: ms);
  }

  Future<({double norm, double ms})> _runMixvpr(Float32List rgb) async {
    final data = await _load('assets/models/mixvpr.onnx');
    final sess = OrtSession.fromBuffer(data, OrtSessionOptions());
    final opts = OrtRunOptions();
    final inp  = OrtValueTensor.createTensorWithDataList(rgb, [1, 3, 224, 224]);

    final sw  = Stopwatch()..start();
    final out = sess.run(opts, {'image': inp});
    final ms  = sw.elapsedMilliseconds.toDouble();

    // Output: [1, 576] L2-normalized
    final raw  = out.first?.value as List<List<double>>;
    final norm = ImagePreprocessor.l2Norm(raw[0]);

    inp.release(); opts.release(); sess.release();
    return (norm: norm, ms: ms);
  }

  Future<({int matchCount, double ms})> _runLightGlue(
      Float32List kpts, Float32List descs) async {
    final data = await _load('assets/models/lightglue_lite.onnx');
    final sess = OrtSession.fromBuffer(data, OrtSessionOptions());
    final opts = OrtRunOptions();
    final k0 = OrtValueTensor.createTensorWithDataList(kpts,  [1, _kN, 2]);
    final k1 = OrtValueTensor.createTensorWithDataList(kpts,  [1, _kN, 2]);
    final d0 = OrtValueTensor.createTensorWithDataList(descs, [1, _kN, 256]);
    final d1 = OrtValueTensor.createTensorWithDataList(descs, [1, _kN, 256]);

    final sw  = Stopwatch()..start();
    final out = sess.run(opts, {'kpts0': k0, 'kpts1': k1, 'desc0': d0, 'desc1': d1});
    final ms  = sw.elapsedMilliseconds.toDouble();

    // Output: [1, 256] match scores — self-match baseline
    var matchCount = 0;
    void count(dynamic v) {
      if (v is double && v > 0.1) matchCount++;
      else if (v is List) { for (final e in v) count(e); }
    }
    count(out.first?.value);

    k0.release(); k1.release(); d0.release(); d1.release();
    opts.release(); sess.release();
    return (matchCount: matchCount, ms: ms);
  }

  Future<Uint8List> _load(String path) async {
    final data = await DefaultAssetBundle.of(context).load(path);
    return data.buffer.asUint8List();
  }

  // ── UI ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pipeline Test')),
      body: _initialising
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (_cam != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: _cam!.value.aspectRatio,
                      child: CameraPreview(_cam!),
                    ),
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _running ? null : _runPipeline,
                  icon: _running
                      ? const SizedBox(width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.camera_alt),
                  label: Text(_running ? 'Running…' : 'Capture & Run All Models'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
                if (_result != null) ...[
                  const SizedBox(height: 16),
                  _ResultsPanel(result: _result!),
                ],
              ]),
            ),
    );
  }
}

class _ResultsPanel extends StatelessWidget {
  const _ResultsPanel({required this.result});
  final _PipelineResult result;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _header('Depth — MiDaS Small INT8', result.depthMs),
      _row('Depth variance', result.depthVariance.toStringAsFixed(4),
          hint: '> 0.02 = 3-D scene  |  < 0.02 = suspect flat'),
      if (result.depthImage != null) ...[
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: RawImage(image: result.depthImage, fit: BoxFit.cover, height: 140),
        ),
      ],
      const SizedBox(height: 16),
      _header('MixVPR — MobileNetV3 576-dim', result.mixvprMs),
      _row('Embedding L² norm', result.embeddingNorm.toStringAsFixed(4),
          hint: '≈ 1.0000 when properly L²-normalised'),
      const SizedBox(height: 16),
      _header('SuperPoint — Magic Leap pretrained', result.superPointMs),
      _row('Active keypoints', result.keypointCount.toString(),
          hint: 'cells with score > 0 from top-256 selection'),
      const SizedBox(height: 16),
      _header('LightGlue — 3 pretrained layers (self-match)', result.lightGlueMs),
      _row('Confident matches', result.matchCount.toString(),
          hint: 'scores > 0.1 — self-match should be high'),
      const Divider(height: 24),
      _row('Total pipeline', '${result.totalMs.toStringAsFixed(0)} ms',
          hint: 'budget: 800 ms'),
    ],
  );

  Widget _header(String title, double ms) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Expanded(child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
      Text('${ms.toStringAsFixed(0)} ms',
          style: const TextStyle(fontSize: 12, color: Colors.black45)),
    ]),
  );

  Widget _row(String label, String value, {String? hint}) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
      if (hint != null)
        Text(hint, style: const TextStyle(fontSize: 11, color: Colors.black38)),
    ]),
  );
}

class _PipelineResult {
  const _PipelineResult({
    required this.depthVariance, required this.depthImage, required this.depthMs,
    required this.keypointCount, required this.superPointMs,
    required this.embeddingNorm, required this.mixvprMs,
    required this.matchCount, required this.lightGlueMs, required this.totalMs,
  });

  final double depthVariance;
  final ui.Image? depthImage;
  final double depthMs, superPointMs, mixvprMs, lightGlueMs, totalMs;
  final int keypointCount, matchCount;
  final double embeddingNorm;
}
