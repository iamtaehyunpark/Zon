import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

/// Result of validating a single on-device model.
class ModelValidationResult {
  const ModelValidationResult({
    required this.modelName,
    required this.loaded,
    required this.sizeMb,
    this.inferenceMs,
    this.error,
  });

  final String modelName;
  final bool loaded;
  final double sizeMb;
  final double? inferenceMs;
  final String? error;

  bool get passed => loaded && (inferenceMs ?? 999) < _budgetMs;

  double get _budgetMs => switch (modelName) {
        'depth_anything_v2_small' => 300,
        'superpoint'              => 120,
        'lightglue_lite'          => 400,
        'mixvpr'                  => 100,
        _                         => 200,
      };

  double get budgetMs => _budgetMs;

  @override
  String toString() {
    final status = passed ? '✅' : '❌';
    final latency = inferenceMs != null
        ? '${inferenceMs!.toStringAsFixed(1)}ms (budget: ${_budgetMs.toStringAsFixed(0)}ms)'
        : 'N/A';
    return '$status $modelName | loaded: $loaded | latency: $latency '
        '| size: ${sizeMb.toStringAsFixed(1)}MB'
        '${error != null ? " | error: $error" : ""}';
  }
}

/// Validates that all AI models load and run within their latency budgets.
/// All models are ONNX for M0; depth and mixvpr will be converted to TFLite before M1.
/// Used exclusively during M0 Week 2 validation — not referenced in production flows.
class ModelValidator {
  static const _assetBase = 'assets/models';

  static Future<List<ModelValidationResult>> runAll() async {
    OrtEnv.instance.init();
    final results = await Future.wait([
      _validateOnnx(
        name: 'depth_anything_v2_small',
        inputName: 'image',
        inputShape: [1, 3, 256, 256],
        runs: 5,
      ),
      _validateOnnx(
        name: 'superpoint',
        inputName: 'image',
        inputShape: [1, 1, 240, 320],
        runs: 20,
      ),
      _validateLightGlue(),
      _validateOnnx(
        name: 'mixvpr',
        inputName: 'image',
        inputShape: [1, 3, 224, 224],
        runs: 15,
        checkL2Norm: true,
      ),
    ]);
    _printSummary(results);
    return results;
  }

  // ── Generic ONNX validator ─────────────────────────────────────────────

  static Future<ModelValidationResult> _validateOnnx({
    required String name,
    required String inputName,
    required List<int> inputShape,
    required int runs,
    bool checkL2Norm = false,
  }) async {
    final assetPath = '$_assetBase/$name.onnx';
    try {
      final data  = await rootBundle.load(assetPath);
      final sizeMb = data.lengthInBytes / 1e6;
      final bytes = data.buffer.asUint8List();

      final session  = OrtSession.fromBuffer(bytes, OrtSessionOptions());
      final runOpts  = OrtRunOptions();
      final elemCount = inputShape.reduce((a, b) => a * b);
      final input    = OrtValueTensor.createTensorWithDataList(
        Float32List(elemCount), inputShape,
      );

      session.run(runOpts, {inputName: input}); // warm-up

      final sw = Stopwatch()..start();
      for (var i = 0; i < runs; i++) {
        session.run(runOpts, {inputName: input});
      }
      final avgMs = sw.elapsedMilliseconds / runs;

      String? warning;
      if (checkL2Norm) {
        final out = session.run(runOpts, {inputName: input});
        final outData = (out.first?.value as List<List<double>>?)?.first;
        if (outData != null) {
          final norm = outData.fold<double>(0, (s, v) => s + v * v);
          if ((norm - 1.0).abs() > 0.05) {
            warning = 'WARNING: output not L2-normalized (norm=${norm.toStringAsFixed(3)})';
          }
        }
      }

      input.release(); runOpts.release(); session.release();
      return ModelValidationResult(
          modelName: name, loaded: true, sizeMb: sizeMb, inferenceMs: avgMs, error: warning);
    } catch (e) {
      return ModelValidationResult(modelName: name, loaded: false, sizeMb: 0, error: e.toString());
    }
  }

  // ── LightGlue Lite — 4-input model (kpts0, kpts1, desc0, desc1) ──────

  static Future<ModelValidationResult> _validateLightGlue() async {
    const name = 'lightglue_lite';
    const assetPath = '$_assetBase/$name.onnx';
    const kN = 256;
    try {
      final data   = await rootBundle.load(assetPath);
      final sizeMb = data.lengthInBytes / 1e6;
      final session = OrtSession.fromBuffer(data.buffer.asUint8List(), OrtSessionOptions());
      final runOpts = OrtRunOptions();

      final kpts0 = OrtValueTensor.createTensorWithDataList(Float32List(1 * kN * 2),   [1, kN, 2]);
      final kpts1 = OrtValueTensor.createTensorWithDataList(Float32List(1 * kN * 2),   [1, kN, 2]);
      final desc0 = OrtValueTensor.createTensorWithDataList(Float32List(1 * kN * 256), [1, kN, 256]);
      final desc1 = OrtValueTensor.createTensorWithDataList(Float32List(1 * kN * 256), [1, kN, 256]);
      final inputs = {'kpts0': kpts0, 'kpts1': kpts1, 'desc0': desc0, 'desc1': desc1};

      session.run(runOpts, inputs); // warm-up

      const runs = 5;
      final sw = Stopwatch()..start();
      for (var i = 0; i < runs; i++) {
        session.run(runOpts, inputs);
      }
      final avgMs = sw.elapsedMilliseconds / runs;

      kpts0.release(); kpts1.release();
      desc0.release(); desc1.release();
      runOpts.release(); session.release();
      return ModelValidationResult(modelName: name, loaded: true, sizeMb: sizeMb, inferenceMs: avgMs);
    } catch (e) {
      return ModelValidationResult(modelName: name, loaded: false, sizeMb: 0, error: e.toString());
    }
  }

  // ── Summary ───────────────────────────────────────────────────────────

  static void _printSummary(List<ModelValidationResult> results) {
    final totalMs = results.fold<double>(0, (s, r) => s + (r.inferenceMs ?? 0));
    final totalMb = results.fold<double>(0, (s, r) => s + r.sizeMb);
    final allPassed = results.every((r) => r.passed);

    debugPrint('\n${'=' * 60}');
    debugPrint('ZON AI Model Validation Report');
    debugPrint('=' * 60);
    for (final r in results) { debugPrint(r.toString()); }
    debugPrint('-' * 60);
    debugPrint('Total size:     ${totalMb.toStringAsFixed(1)} MB  (budget: 56 MB)');
    debugPrint('Total pipeline: ${totalMs.toStringAsFixed(1)} ms  (budget: 800 ms)');
    debugPrint('Result:         ${allPassed ? "✅ PASS — Ready for M1" : "❌ FAIL — Resolve before M1"}');
    debugPrint('${'=' * 60}\n');
  }
}
