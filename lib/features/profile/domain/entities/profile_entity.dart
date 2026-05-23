/// Domain entity for a user profile — pure Dart, no Flutter or Supabase imports.
class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.username,
    required this.createdAt,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.countryCount = 0,
    this.placeCount = 0,
    this.badgeCount = 0,
  });

  final String id;
  final String username;
  final DateTime createdAt;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final int countryCount;
  final int placeCount;
  final int badgeCount;
}
