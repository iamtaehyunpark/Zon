/// Richly-joined feed row: stamp + place name + author info.
/// Built from a Supabase select that joins stamps → places + profiles.
class FeedItem {
  const FeedItem({
    required this.stampId,
    required this.tier,
    required this.createdAt,
    required this.placeId,
    required this.placeName,
    required this.placeCategory,
    required this.authorId,
    required this.authorUsername,
    this.authorDisplayName,
    this.authorAvatarUrl,
    this.caption,
    this.photoUrls = const [],
    this.sensoryTags = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.finalScore,
  });

  final String stampId;
  final String tier;
  final DateTime createdAt;
  final String placeId;
  final String placeName;
  final String placeCategory;
  final String authorId;
  final String authorUsername;
  final String? authorDisplayName;
  final String? authorAvatarUrl;
  final String? caption;
  final List<String> photoUrls;
  final List<String> sensoryTags;
  final int likeCount;
  final int commentCount;
  final double? finalScore;

  String get displayName => authorDisplayName ?? authorUsername;

  factory FeedItem.fromJson(Map<String, dynamic> j) {
    final place   = j['places']   as Map<String, dynamic>?;
    final profile = j['profiles'] as Map<String, dynamic>?;
    return FeedItem(
      stampId:          j['id'] as String,
      tier:             j['tier'] as String,
      createdAt:        DateTime.parse(j['created_at'] as String),
      placeId:          place?['id'] as String? ?? '',
      placeName:        place?['name'] as String? ?? 'Unknown place',
      placeCategory:    place?['category'] as String? ?? '',
      authorId:         profile?['id'] as String? ?? '',
      authorUsername:   profile?['username'] as String? ?? 'user',
      authorDisplayName: profile?['display_name'] as String?,
      authorAvatarUrl:  profile?['avatar_url'] as String?,
      caption:          j['caption'] as String?,
      photoUrls:        (j['photo_urls'] as List?)?.cast<String>() ?? [],
      sensoryTags:      (j['sensory_tags'] as List?)?.cast<String>() ?? [],
      likeCount:        (j['like_count'] as num?)?.toInt() ?? 0,
      commentCount:     (j['comment_count'] as num?)?.toInt() ?? 0,
      finalScore:       (j['final_score'] as num?)?.toDouble(),
    );
  }
}
