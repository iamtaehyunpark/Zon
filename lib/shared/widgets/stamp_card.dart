import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../features/feed/data/models/feed_item.dart';

/// Reusable card for a single Stamp in the feed or grid views.
class StampCard extends StatelessWidget {
  const StampCard({super.key, required this.item, required this.onTap});

  final FeedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: avatar + author + place
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(children: [
                _Avatar(url: item.authorAvatarUrl, username: item.authorUsername),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.displayName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    Text('@ ${item.placeName}',
                        style: const TextStyle(
                            color: Color(0xFF1D9E75),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ]),
                ),
                _TierBadge(tier: item.tier),
              ]),
            ),

            // Photo (if any)
            if (item.photoUrls.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.zero),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: item.photoUrls.first,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: const Color(0xFF1A1A1A)),
                    errorWidget: (_, __, ___) =>
                        Container(color: const Color(0xFF1A1A1A),
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.white24)),
                  ),
                ),
              ),

            // Caption
            if (item.caption != null && item.caption!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Text(item.caption!,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ),

            // Sensory tags
            if (item.sensoryTags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: item.sensoryTags.take(4).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D9E75).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
                      ),
                      child: Text(tag,
                          style: const TextStyle(
                              color: Color(0xFF1D9E75), fontSize: 10)),
                    );
                  }).toList(),
                ),
              ),

            // Footer: likes, comments, time
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Row(children: [
                const Icon(Icons.favorite_outline, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                Text('${item.likeCount}',
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(width: 14),
                const Icon(Icons.chat_bubble_outline, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                Text('${item.commentCount}',
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const Spacer(),
                Text(_timeAgo(item.createdAt),
                    style: const TextStyle(color: Colors.white24, fontSize: 11)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)  return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    if (diff.inDays < 7)     return '${diff.inDays}d ago';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url, required this.username});
  final String? url;
  final String username;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: CachedNetworkImageProvider(url!),
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFF1D9E75).withValues(alpha: 0.2),
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : '?',
        style: const TextStyle(
            color: Color(0xFF1D9E75),
            fontWeight: FontWeight.w700,
            fontSize: 14),
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier});
  final String tier;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (tier) {
      'tier1' => ('T1', const Color(0xFF1D9E75)),
      'tier2' => ('T2', Colors.blueAccent),
      _       => ('T3', Colors.orange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
