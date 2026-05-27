import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/feed_item.dart';

/// Full-screen detail view for a single Stamp.
class StampDetailScreen extends StatefulWidget {
  const StampDetailScreen({super.key, required this.stampId});
  final String stampId;

  @override
  State<StampDetailScreen> createState() => _StampDetailScreenState();
}

class _StampDetailScreenState extends State<StampDetailScreen> {
  FeedItem? _item;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final row = await Supabase.instance.client
          .from('stamps')
          .select(
              'id, tier, caption, photo_urls, sensory_tags, like_count, comment_count, '
              'final_score, vision_score, sensor_score, created_at, '
              'places!place_id(id, name, category, address), '
              'profiles!user_id(id, username, display_name, avatar_url)')
          .eq('id', widget.stampId)
          .single();

      if (mounted) {
        setState(() {
          _item = FeedItem.fromJson(row);
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
        title: const Text('Stamp', style: TextStyle(color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1D9E75)))
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.white54)))
              : _body(),
    );
  }

  Widget _body() {
    final item = _item!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Author row
        Row(children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF1D9E75).withValues(alpha: 0.2),
            backgroundImage: item.authorAvatarUrl != null
                ? CachedNetworkImageProvider(item.authorAvatarUrl!)
                : null,
            child: item.authorAvatarUrl == null
                ? Text(item.authorUsername[0].toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFF1D9E75), fontWeight: FontWeight.w700))
                : null,
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.displayName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            Text('@${item.authorUsername}',
                style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ]),
          const Spacer(),
          _TierChip(tier: item.tier),
        ]),

        const SizedBox(height: 20),

        // Place
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Row(children: [
            const Icon(Icons.place, color: Color(0xFF1D9E75), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.placeName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                Text(item.placeCategory,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 12)),
              ]),
            ),
            TextButton(
              onPressed: () => context.pushNamed('auth-cta'),
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1D9E75)),
              child: const Text('Verify here'),
            ),
          ]),
        ),

        // Photo
        if (item.photoUrls.isNotEmpty) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.photoUrls.first,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],

        // Caption
        if (item.caption != null && item.caption!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(item.caption!,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        ],

        // Sensory tags
        if (item.sensoryTags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: item.sensoryTags.map((tag) => Chip(
              label: Text(tag, style: const TextStyle(
                  color: Color(0xFF1D9E75), fontSize: 11)),
              backgroundColor: const Color(0xFF1D9E75).withValues(alpha: 0.1),
              side: BorderSide(
                  color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )).toList(),
          ),
        ],

        // Scores
        if (item.finalScore != null) ...[
          const SizedBox(height: 20),
          const Divider(color: Color(0xFF2A2A2A)),
          const SizedBox(height: 12),
          const Text('Verification score',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
          const SizedBox(height: 10),
          _ScoreBar('Final score', item.finalScore!),
        ],

        const SizedBox(height: 24),
        Text(
          _fullDate(item.createdAt),
          style: const TextStyle(color: Colors.white24, fontSize: 12),
        ),
      ]),
    );
  }

  static String _fullDate(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · '
        '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
  }
}

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier});
  final String tier;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (tier) {
      'tier1' => ('AI Verified · Tier 1', const Color(0xFF1D9E75)),
      'tier2' => ('Photo Match · Tier 2', Colors.blueAccent),
      _       => ('Tier 3', Colors.orange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar(this.label, this.value);
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value > 0.75
        ? const Color(0xFF1D9E75)
        : value > 0.5 ? Colors.orange : Colors.red;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        SizedBox(
          width: 110,
          child: Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(value.toStringAsFixed(2),
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
