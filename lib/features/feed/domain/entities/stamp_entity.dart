import '../../../../data/models/auth_tier.dart';
import '../../../../data/models/stamp_visibility.dart';

/// Domain entity for a Stamp — pure Dart, no Flutter or Supabase imports.
class StampEntity {
  const StampEntity({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.tier,
    required this.visibility,
    required this.createdAt,
    this.caption,
    this.photoUrls = const [],
    this.likeCount = 0,
    this.commentCount = 0,
  });

  final String id;
  final String userId;
  final String placeId;
  final AuthTier tier;
  final StampVisibility visibility;
  final DateTime createdAt;
  final String? caption;
  final List<String> photoUrls;
  final int likeCount;
  final int commentCount;
}
