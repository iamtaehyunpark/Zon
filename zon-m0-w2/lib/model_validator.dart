// lib/core/ai/model_validator.dart
//
// ZON — On-Device AI Model Validator
//
// Run this during M0 Week 2 to validate all models load correctly
// and measure real inference latency on device.
//
// Usage (add a temporary button to any screen during M0):
//   final results = await ModelValidator.runAll();
//   results.forEach((r) => debugPrint(r.toString()));

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:onnxruntime/onnxruntime.dart';

class ModelValidationResult {
  final String modelName;
  final bool loaded;
  final double? inferenceMs;
  final String? error;
  final double sizeMb;

  const ModelValidationResult({
    required this.modelName,
    required this.loaded,
    required this.sizeMb,
    this.inferenceMs,
    this.error,
  });

  bool get passed => loaded && (inferenceMs ?? 999) < _budgetMs;

  double get _budgetMs => switch (modelName) {
        'depth_anything_v2_small' => 300,
        'superpoint'              => 50,
        'lightglue_lite'          => 150,
        'mixvpr'                  => 100,
        _                         => 200,
      };

  @override
  String toString() {
    final status = passed ? '✅' : '❌';
    final latency = inferenceMs != null
        ? '${inferenceMs!.toStringAsFixed(1)}ms (budget: ${_budgetMs.toStringAsFixed(0)}ms)'
        : 'N/A';
    final size = '${sizeMb.toStringAsFixed(1)}MB';
    return '$status $modelName | loaded: $loaded | latency: $latency | size: $size'
        '${error != null ? " | error: $error" : ""}';
  }
}

class ModelValidator {
  static const _assetBase = 'assets/models';

  /// Run all validations and return results.
  static Future<List<ModelValidationResult>> runAll() async {
    final results = <ModelValidationResult>[];

    results.add(await _validateDepthAnything());
    results.add(await _validateSuperPoint());
    results.add(await _validateLightGlue());
    results.add(await _validateMixVPR());

    _printSummary(results);
    return results;
  }

  // ── Depth Anything V2-Small (TFLite) ─────────────────

  static Future<ModelValidationResult> _validateDepthAnything() async {
    const name = 'depth_anything_v2_small';
    final assetPath = '$_assetBase/$name.tflite';

    try {
      final data = await rootBundle.load(assetPath);
      final sizeMb = data.lengthInBytes / 1e6;

      // Load with Core ML delegate (iOS) or NNAPI (Android)
      final options = InterpreterOptions();
      try {
        options.addDelegate(CoreMlDelegate()); // iOS
      } catch (_) {
        // Not iOS — NNAPI is added automatically on Android
      }

      final stopwatch = Stopwatch()..start();
      final interpreter = await Interpreter.fromAsset(assetPath, options: options);
      final loadMs = stopwatch.elapsedMilliseconds.toDouble();

      // Warm-up run
      final inputShape = interpreter.getInputTensor(0).shape;
      // Expected: [1, 3, 256, 256] or [1, 256, 256, 3]
      final inputData = Float32List(inputShape.reduce((a, b) => a * b));
      final outputShape = interpreter.getOutputTensor(0).shape;
      final outputData = Float32List(outputShape.reduce((a, b) => a * b));

      // Benchmark: 10 runs
      final runs = 10;
      final benchStart = Stopwatch()..start();
      for (var i = 0; i < runs; i++) {
        interpreter.run(inputData.reshape(inputShape), outputData.reshape(outputShape));
      }
      final avgMs = benchStart.elapsedMilliseconds / runs;

      interpreter.close();

      return ModelValidationResult(
        modelName: name,
        loaded: true,
        sizeMb: sizeMb,
        inferenceMs: avgMs,
      );
    } catch (e) {
      return ModelValidationResult(
        modelName: name,
        loaded: false,
        sizeMb: 0,
        error: e.toString(),
      );
    }
  }

  // ── SuperPoint (ONNX) ─────────────────────────────────

  static Future<ModelValidationResult> _validateSuperPoint() async {
    const name = 'superpoint';
    final assetPath = '$_assetBase/$name.onnx';

    try {
      final data = await rootBundle.load(assetPath);
      final sizeMb = data.lengthInBytes / 1e6;
      final bytes = data.buffer.asUint8List();

      OrtEnv.instance.init();
      final sessionOptions = OrtSessionOptions();

      final stopwatch = Stopwatch()..start();
      final session = OrtSession.fromBuffer(bytes, sessionOptions);
      final loadMs = stopwatch.elapsedMilliseconds.toDouble();

      // Input: [1, 1, 240, 320] grayscale image
      final inputTensor = OrtValueTensor.createTensorWithDataList(
        Float32List(1 * 1 * 240 * 320),
        [1, 1, 240, 320],
      );

      // Warm up
      final runOptions = OrtRunOptions();
      session.run(runOptions, {'image': inputTensor});

      // Benchmark: 20 runs
      const runs = 20;
      final benchStart = Stopwatch()..start();
      for (var i = 0; i < runs; i++) {
        session.run(runOptions, {'image': inputTensor});
      }
      final avgMs = benchStart.elapsedMilliseconds / runs;

      inputTensor.release();
      runOptions.release();
      session.release();

      return ModelValidationResult(
        modelName: name,
        loaded: true,
        sizeMb: sizeMb,
        inferenceMs: avgMs,
      );
    } catch (e) {
      return ModelValidationResult(
        modelName: name,
        loaded: false,
        sizeMb: 0,
        error: e.toString(),
      );
    }
  }

  // ── LightGlue Lite (ONNX) ────────────────────────────

  static Future<ModelValidationResult> _validateLightGlue() async {
    const name = 'lightglue_lite';
    final assetPath = '$_assetBase/$name.onnx';

    try {
      final data = await rootBundle.load(assetPath);
      final sizeMb = data.lengthInBytes / 1e6;
      final bytes = data.buffer.asUint8List();

      OrtEnv.instance.init();
      final session = OrtSession.fromBuffer(bytes, OrtSessionOptions());

      // Input: desc0 [1, 512, 256], desc1 [1, 512, 256]
      final desc0 = OrtValueTensor.createTensorWithDataList(
        Float32List(1 * 512 * 256), [1, 512, 256],
      );
      final desc1 = OrtValueTensor.createTensorWithDataList(
        Float32List(1 * 512 * 256), [1, 512, 256],
      );

      final runOptions = OrtRunOptions();
      session.run(runOptions, {'desc0': desc0, 'desc1': desc1}); // warm-up

      const runs = 10;
      final benchStart = Stopwatch()..start();
      for (var i = 0; i < runs; i++) {
        session.run(runOptions, {'desc0': desc0, 'desc1': desc1});
      }
      final avgMs = benchStart.elapsedMilliseconds / runs;

      desc0.release();
      desc1.release();
      runOptions.release();
      session.release();

      return ModelValidationResult(
        modelName: name,
        loaded: true,
        sizeMb: sizeMb,
        inferenceMs: avgMs,
      );
    } catch (e) {
      return ModelValidationResult(
        modelName: name,
        loaded: false,
        sizeMb: 0,
        error: e.toString(),
      );
    }
  }

  // ── MixVPR (TFLite) ──────────────────────────────────

  static Future<ModelValidationResult> _validateMixVPR() async {
    const name = 'mixvpr';
    final assetPath = '$_assetBase/$name.tflite';

    try {
      final data = await rootBundle.load(assetPath);
      final sizeMb = data.lengthInBytes / 1e6;

      final options = InterpreterOptions();
      try {
        options.addDelegate(CoreMlDelegate());
      } catch (_) {}

      final interpreter = await Interpreter.fromAsset(assetPath, options: options);
      final inputShape = interpreter.getInputTensor(0).shape; // [1, 3, 224, 224]
      final outputShape = interpreter.getOutputTensor(0).shape; // [1, 512]

      final inputData  = Float32List(inputShape.reduce((a, b) => a * b));
      final outputData = Float32List(outputShape.reduce((a, b) => a * b));

      interpreter.run(inputData.reshape(inputShape), outputData.reshape(outputShape)); // warm-up

      const runs = 15;
      final benchStart = Stopwatch()..start();
      for (var i = 0; i < runs; i++) {
        interpreter.run(inputData.reshape(inputShape), outputData.reshape(outputShape));
      }
      final avgMs = benchStart.elapsedMilliseconds / runs;

      // Verify output is L2-normalized (cosine similarity ready)
      final norm = outputData.fold<double>(0, (s, v) => s + v * v);
      final isNormalized = (norm - 1.0).abs() < 0.05;

      interpreter.close();

      return ModelValidationResult(
        modelName: name,
        loaded: true,
        sizeMb: sizeMb,
        inferenceMs: avgMs,
        error: isNormalized ? null : 'WARNING: output not L2-normalized (norm=$norm)',
      );
    } catch (e) {
      return ModelValidationResult(
        modelName: name,
        loaded: false,
        sizeMb: 0,
        error: e.toString(),
      );
    }
  }

  // ── Full Pipeline Benchmark ───────────────────────────

  /// Simulate the full Phase 1+2 pipeline latency.
  /// This is the number that must be < 800ms.
  static Future<double> benchmarkFullPipeline() async {
    final results = await runAll();
    double total = 0;
    for (final r in results) {
      total += r.inferenceMs ?? 999;
    }
    return total;
  }

  // ── Summary ───────────────────────────────────────────

  static void _printSummary(List<ModelValidationResult> results) {
    final totalMs = results.fold<double>(0, (s, r) => s + (r.inferenceMs ?? 0));
    final totalMb = results.fold<double>(0, (s, r) => s + r.sizeMb);
    final allPassed = results.every((r) => r.passed);

    debugPrint('\n' + '='*60);
    debugPrint('ZON AI Model Validation Report');
    debugPrint('='*60);
    for (final r in results) {
      debugPrint(r.toString());
    }
    debugPrint('-'*60);
    debugPrint('Total model size:     ${totalMb.toStringAsFixed(1)}MB (budget: 56MB)');
    debugPrint('Total pipeline time:  ${totalMs.toStringAsFixed(1)}ms (budget: 800ms)');
    debugPrint('Overall result:       ${allPassed ? "✅ PASS — Ready for M1" : "❌ FAIL — Resolve before M1"}');
    debugPrint('='*60 + '\n');
  }
}


// ── Validation Screen (temporary M0 UI) ──────────────────
// Add this screen temporarily under a debug menu during M0.
// Remove before M1 begins.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModelValidationScreen extends ConsumerStatefulWidget {
  const ModelValidationScreen({super.key});

  @override
  ConsumerState<ModelValidationScreen> createState() => _ModelValidationScreenState();
}

class _ModelValidationScreenState extends ConsumerState<ModelValidationScreen> {
  List<ModelValidationResult>? _results;
  bool _running = false;

  Future<void> _run() async {
    setState(() { _running = true; _results = null; });
    final results = await ModelValidator.runAll();
    setState(() { _running = false; _results = results; });
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _results?.fold<double>(0, (s, r) => s + (r.inferenceMs ?? 0)) ?? 0;
    final allPassed = _results?.every((r) => r.passed) ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('M0 — Model Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Validates all AI models load correctly and measures '
                'real inference latency on this device.\n\n'
                'Target: full pipeline < 800ms.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),

            // Run button
            ElevatedButton.icon(
              onPressed: _running ? null : _run,
              icon: _running
                  ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.play_arrow),
              label: Text(_running ? 'Running...' : 'Run Validation'),
            ),
            const SizedBox(height: 16),

            // Results
            if (_results != null) ...[
              // Summary banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: allPassed ? Colors.green.shade50 : Colors.red.shade50,
                  border: Border.all(
                    color: allPassed ? Colors.green.shade300 : Colors.red.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      allPassed ? '✅ ALL PASS — Ready for M1' : '❌ ISSUES FOUND — Fix before M1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: allPassed ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total pipeline: ${totalMs.toStringAsFixed(1)}ms / 800ms budget',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Per-model results
              Expanded(
                child: ListView.separated(
                  itemCount: _results!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final r = _results![i];
                    return _ModelResultCard(result: r);
                  },
                ),
              ),
            ] else if (!_running)
              const Center(
                child: Text('Tap Run to start validation',
                    style: TextStyle(color: Colors.black38)),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModelResultCard extends StatelessWidget {
  final ModelValidationResult result;
  const _ModelResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.passed ? Colors.green.shade700 : Colors.red.shade700;
    final bg    = result.passed ? Colors.green.shade50  : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(result.passed ? '✅' : '❌', style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(result.modelName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${result.sizeMb.toStringAsFixed(1)} MB',
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
          ]),
          if (result.inferenceMs != null) ...[
            const SizedBox(height: 6),
            _LatencyBar(
              actual: result.inferenceMs!,
              budget: result.modelName == 'depth_anything_v2_small' ? 300
                    : result.modelName == 'superpoint' ? 50
                    : result.modelName == 'lightglue_lite' ? 150
                    : 100,
            ),
          ],
          if (result.error != null) ...[
            const SizedBox(height: 4),
            Text(result.error!,
                style: TextStyle(fontSize: 11, color: Colors.red.shade700)),
          ],
        ],
      ),
    );
  }
}

class _LatencyBar extends StatelessWidget {
  final double actual;
  final double budget;
  const _LatencyBar({required this.actual, required this.budget});

  @override
  Widget build(BuildContext context) {
    final ratio = (actual / budget).clamp(0.0, 1.5);
    final color = ratio <= 0.8 ? Colors.green
                : ratio <= 1.0 ? Colors.orange
                               : Colors.red;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${actual.toStringAsFixed(1)}ms / ${budget.toStringAsFixed(0)}ms',
            style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
