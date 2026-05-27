import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../providers/place_register_provider.dart';

/// Full-screen flow for registering a new Place (consensus round 1).
/// Step 0 → enter info, Step 1 → review, Step 2 → submitting, Step 3 → done.
class PlaceRegisterScreen extends ConsumerWidget {
  const PlaceRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(placeRegisterNotifierProvider);

    return PopScope(
      canPop: state.step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && state.step == 1) {
          ref.read(placeRegisterNotifierProvider.notifier).backToInfo();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0A),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              ref.read(placeRegisterNotifierProvider.notifier).reset();
              context.pop();
            },
          ),
          title: Text(
            state.step < 3 ? 'Register Place' : 'Place Registered',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: switch (state.step) {
          0 => _InfoStep(notifier: ref.read(placeRegisterNotifierProvider.notifier)),
          1 => _ReviewStep(state: state,
              onBack: ref.read(placeRegisterNotifierProvider.notifier).backToInfo,
              onSubmit: ref.read(placeRegisterNotifierProvider.notifier).submit),
          2 => const _SubmittingStep(),
          _ => _DoneStep(
              placeId: state.submittedPlaceId,
              onDone: () {
                ref.read(placeRegisterNotifierProvider.notifier).reset();
                context.pop();
              },
            ),
        },
      ),
    );
  }
}

// ── Step 0: Info form ─────────────────────────────────────────────────────────

class _InfoStep extends StatefulWidget {
  const _InfoStep({required this.notifier});
  final PlaceRegisterNotifier notifier;

  @override
  State<_InfoStep> createState() => _InfoStepState();
}

class _InfoStepState extends State<_InfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _category  = 'cafe';
  String _spaceType = 'indoor_artificial';
  double? _lat;
  double? _lng;
  bool _locating = false;

  static const _categories = [
    'cafe', 'restaurant', 'park', 'museum', 'gallery',
    'gym', 'library', 'bar', 'landmark', 'other',
  ];

  static const _spaceTypes = {
    'indoor_artificial':  'Indoor (building)',
    'indoor_natural':     'Indoor (cave/greenhouse)',
    'outdoor_artificial': 'Outdoor (urban)',
    'outdoor_natural':    'Outdoor (nature)',
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      bool svc = await Geolocator.isLocationServiceEnabled();
      if (!svc) throw Exception('Location services disabled');
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _locating = false);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set the location first')),
      );
      return;
    }
    widget.notifier.setInfo(
      name:      _nameCtrl.text.trim(),
      category:  _category,
      spaceType: _spaceType,
      address:   _addressCtrl.text.trim(),
      lat:       _lat!,
      lng:       _lng!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          // Name
          _label('Place name *'),
          TextFormField(
            controller: _nameCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDeco('e.g. Blue Bottle Coffee Seongsu'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),

          const SizedBox(height: 20),
          _label('Category'),
          _DropdownField<String>(
            value: _category,
            items: _categories,
            labelOf: (v) => v[0].toUpperCase() + v.substring(1),
            onChanged: (v) => setState(() => _category = v),
          ),

          const SizedBox(height: 20),
          _label('Space type'),
          _DropdownField<String>(
            value: _spaceType,
            items: _spaceTypes.keys.toList(),
            labelOf: (v) => _spaceTypes[v]!,
            onChanged: (v) => setState(() => _spaceType = v),
          ),

          const SizedBox(height: 20),
          _label('Address (optional)'),
          TextFormField(
            controller: _addressCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDeco('Street address'),
          ),

          const SizedBox(height: 20),
          _label('Location *'),
          _LocationTile(
            lat: _lat,
            lng: _lng,
            locating: _locating,
            onTap: _useCurrentLocation,
          ),

          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9E75),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Continue',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  static Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600)),
      );

  static InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF141414),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1D9E75)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final void Function(T) onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            items: items
                .map((v) => DropdownMenuItem<T>(
                      value: v,
                      child: Text(labelOf(v)),
                    ))
                .toList(),
            onChanged: (v) { if (v != null) onChanged(v); },
          ),
        ),
      );
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.lat,
    required this.lng,
    required this.locating,
    required this.onTap,
  });
  final double? lat;
  final double? lng;
  final bool locating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: locating ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: lat != null
                  ? const Color(0xFF1D9E75).withValues(alpha: 0.5)
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Row(children: [
            Icon(
              lat != null ? Icons.location_on : Icons.location_searching,
              color: lat != null
                  ? const Color(0xFF1D9E75)
                  : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: locating
                  ? const Text('Getting location…',
                      style: TextStyle(color: Colors.white38, fontSize: 13))
                  : lat != null
                      ? Text(
                          '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}',
                          style: const TextStyle(
                              color: Color(0xFF1D9E75), fontSize: 13),
                        )
                      : const Text('Tap to use current location',
                          style:
                              TextStyle(color: Colors.white38, fontSize: 13)),
            ),
            if (locating)
              const SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(
                    color: Color(0xFF1D9E75), strokeWidth: 2),
              ),
          ]),
        ),
      );
}

// ── Step 1: Review ────────────────────────────────────────────────────────────

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.state,
    required this.onBack,
    required this.onSubmit,
  });
  final PlaceRegisterState state;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Review details',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text(
            'Once submitted, this place becomes visible on the map in pending status. Three verified submissions from different angles are needed to confirm it.',
            style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.4)),

        const SizedBox(height: 24),
        _row('Name', state.name),
        _row('Category', state.category),
        _row('Space type', state.spaceType.replaceAll('_', ' ')),
        if (state.address.isNotEmpty) _row('Address', state.address),
        _row('Location',
            '${state.lat!.toStringAsFixed(5)}, ${state.lng!.toStringAsFixed(5)}'),

        if (state.error != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade900.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(state.error!,
                style:
                    const TextStyle(color: Colors.redAccent, fontSize: 13)),
          ),
        ],

        const Spacer(),

        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Color(0xFF2A2A2A)),
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9E75),
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit place',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ]),
    );
  }

  static Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13)),
          ),
        ]),
      );
}

// ── Step 2: Submitting ────────────────────────────────────────────────────────

class _SubmittingStep extends StatelessWidget {
  const _SubmittingStep();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircularProgressIndicator(color: Color(0xFF1D9E75)),
          SizedBox(height: 24),
          Text('Submitting place…',
              style: TextStyle(color: Colors.white54, fontSize: 15)),
        ]),
      );
}

// ── Step 3: Done ──────────────────────────────────────────────────────────────

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.placeId, required this.onDone});
  final String? placeId;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: Color(0xFF1D9E75), size: 40),
            ),
            const SizedBox(height: 20),
            const Text('Place submitted!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            const Text(
                'Your place is now in pending status. It will be confirmed once 3 people verify it from different angles.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white54, fontSize: 14, height: 1.5)),
            const SizedBox(height: 8),
            const Text(
                'You\'ve reserved the Pioneer badge for this place.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF1D9E75), fontSize: 13)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9E75),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}
