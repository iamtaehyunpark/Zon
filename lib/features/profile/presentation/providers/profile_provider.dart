import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../data/datasources/remote/stamp_select.dart';
import '../../../feed/data/models/feed_item.dart';

part 'profile_provider.g.dart';

/// Holds the combined profile + stamp data for a user.
class ProfileData {
  const ProfileData({
    required this.profile,
    required this.recentStamps,
  });
  final UserProfile profile;
  final List<FeedItem> recentStamps;
}

/// Loads profile + recent stamps. Null userId = own profile.
@riverpod
class ProfileNotifier extends _$ProfileNotifier {

  @override
  Future<ProfileData?> build(String? userId) => _load();

  Future<ProfileData?> _load() async {
    // `userId` is the family arg — set as a late field by the generated code
    final targetId =
        userId ?? Supabase.instance.client.auth.currentUser?.id;
    if (targetId == null) return null;

    final profileRow = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', targetId)
        .maybeSingle();

    if (profileRow == null) return null;

    final profile = UserProfile.fromJson(profileRow);

    final stamps = await Supabase.instance.client
        .from('stamps')
        .select(kStampSelect)
        .eq('user_id', targetId)
        .order('created_at', ascending: false)
        .limit(30) as List<dynamic>;

    final recentStamps = stamps
        .map((r) => FeedItem.fromJson(r as Map<String, dynamic>))
        .toList();

    return ProfileData(profile: profile, recentStamps: recentStamps);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }
}
