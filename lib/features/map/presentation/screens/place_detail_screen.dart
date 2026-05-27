import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/place_status.dart';

/// Full-screen detail for a Place — shows stats, recent stamps, and verify CTA.
class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({super.key, required this.placeId});
  final String placeId;

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  Map<String, dynamic>? _place;
  List<Map<String, dynamic>> _recentStamps = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final place = await Supabase.instance.client
          .from('places')
          .select('id, name, category, space_type, status, address, '
                  'reference_count, pending_count, lat, lng')
          .eq('id', widget.placeId)
          .single();

      final stamps = await Supabase.instance.client
          .from('stamps')
          .select('id, tier, created_at, profiles!user_id(username, display_name)')
          .eq('place_id', widget.placeId)
          .eq('visibility', 'public')
          .order('created_at', ascending: false)
          .limit(5) as List<dynamic>;

      if (mounted) {
        setState(() {
          _place = place;
          _recentStamps = stamps.cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _place?['name'] as String? ?? 'Place',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1D9E75)))
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.white54)))
              : _body(),
      bottomNavigationBar: _place != null ? _VerifyBar(placeId: widget.placeId) : null,
    );
  }

  Widget _body() {
    final p = _place!;
    final status = p['status'] as String? ?? 'pending';
    final isConfirmed = status == PlaceStatus.confirmed.name;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Status + category row
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: (isConfirmed ? const Color(0xFF1D9E75) : Colors.orange)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: (isConfirmed ? const Color(0xFF1D9E75) : Colors.orange)
                      .withValues(alpha: 0.4)),
            ),
            child: Text(
              isConfirmed ? '✓ Verified place' : '⏳ Pending verification',
              style: TextStyle(
                  color: isConfirmed ? const Color(0xFF1D9E75) : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text(p['category'] as String? ?? '',
              style: const TextStyle(color: Colors.white38, fontSize: 13)),
        ]),

        const SizedBox(height: 16),

        if (p['address'] != null && (p['address'] as String).isNotEmpty) ...[
          Row(children: [
            const Icon(Icons.location_on_outlined,
                color: Colors.white38, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(p['address'] as String,
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ),
          ]),
          const SizedBox(height: 16),
        ],

        // Stats row
        Row(children: [
          _Stat(
            value: '${p['reference_count'] ?? 0}',
            label: 'Verifications',
            color: const Color(0xFF1D9E75),
          ),
          const SizedBox(width: 16),
          _Stat(
            value: '${p['pending_count'] ?? 0}',
            label: 'Pending rounds',
            color: Colors.orange,
          ),
        ]),

        // Recent stamps
        if (_recentStamps.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text('Recent visitors',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ..._recentStamps.map((s) {
            final profile = s['profiles'] as Map<String, dynamic>?;
            final name = profile?['display_name'] as String?
                ?? profile?['username'] as String?
                ?? 'user';
            final tier = s['tier'] as String? ?? 'tier1';
            final dt = DateTime.tryParse(s['created_at'] as String? ?? '');
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      const Color(0xFF1D9E75).withValues(alpha: 0.2),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                        color: Color(0xFF1D9E75), fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(name,
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ),
                _TierLabel(tier: tier),
                const SizedBox(width: 8),
                if (dt != null)
                  Text(_timeAgo(dt),
                      style: const TextStyle(
                          color: Colors.white24, fontSize: 11)),
              ]),
            );
          }),
        ],
      ]),
    );
  }

  static String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.color});
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ]),
        ),
      );
}

class _TierLabel extends StatelessWidget {
  const _TierLabel({required this.tier});
  final String tier;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (tier) {
      'tier1' => ('T1', const Color(0xFF1D9E75)),
      'tier2' => ('T2', Colors.blueAccent),
      _       => ('T3', Colors.orange),
    };
    return Text(label,
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w700));
  }
}

class _VerifyBar extends StatelessWidget {
  const _VerifyBar({required this.placeId});
  final String placeId;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: ElevatedButton.icon(
            onPressed: () {
              context.pop();
              context.pushNamed(
                'video-sweep',
                pathParameters: {'id': placeId},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9E75),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.verified_outlined),
            label: const Text('Verify presence here',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      );
}
