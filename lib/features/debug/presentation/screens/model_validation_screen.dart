import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/model_validator.dart';

/// M0 validation screen — shows per-model load + latency results on device.
/// Accessed via the debug button in ProfileScreen (kDebugMode only).
/// Remove the debug button entry point before App Store submission.
class ModelValidationScreen extends ConsumerStatefulWidget {
  const ModelValidationScreen({super.key});

  @override
  ConsumerState<ModelValidationScreen> createState() =>
      _ModelValidationScreenState();
}

class _ModelValidationScreenState
    extends ConsumerState<ModelValidationScreen> {
  List<ModelValidationResult>? _results;
  bool _running = false;

  Future<void> _run() async {
    setState(() { _running = true; _results = null; });
    final results = await ModelValidator.runAll();
    if (mounted) setState(() { _running = false; _results = results; });
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
            const _InfoCard(
              'Validates all AI models load correctly and measures '
              'inference latency on this device.\nTarget: full pipeline < 800 ms.',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _running ? null : _run,
              icon: _running
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.play_arrow),
              label: Text(_running ? 'Running…' : 'Run Validation'),
            ),
            const SizedBox(height: 16),
            if (_results != null) ...[
              _SummaryBanner(allPassed: allPassed, totalMs: totalMs),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _results!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _ModelResultCard(result: _results![i]),
                ),
              ),
            ] else if (!_running)
              const Expanded(
                child: Center(
                  child: Text('Tap Run to start',
                      style: TextStyle(color: Colors.black38)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      );
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({required this.allPassed, required this.totalMs});
  final bool allPassed;
  final double totalMs;

  @override
  Widget build(BuildContext context) => Container(
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
              'Total: ${totalMs.toStringAsFixed(1)} ms / 800 ms budget',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      );
}

class _ModelResultCard extends StatelessWidget {
  const _ModelResultCard({required this.result});
  final ModelValidationResult result;

  @override
  Widget build(BuildContext context) {
    final color = result.passed ? Colors.green.shade700 : Colors.red.shade700;
    final bg    = result.passed ? Colors.green.shade50  : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
              child: Text('${result.sizeMb.toStringAsFixed(1)} MB',
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
          ]),
          if (result.inferenceMs != null) ...[
            const SizedBox(height: 6),
            _LatencyBar(actual: result.inferenceMs!, budget: result.budgetMs),
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
  const _LatencyBar({required this.actual, required this.budget});
  final double actual;
  final double budget;

  @override
  Widget build(BuildContext context) {
    final ratio = (actual / budget).clamp(0.0, 1.5);
    final color = ratio <= 0.8 ? Colors.green
                : ratio <= 1.0 ? Colors.orange
                               : Colors.red;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${actual.toStringAsFixed(1)} ms / ${budget.toStringAsFixed(0)} ms',
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
