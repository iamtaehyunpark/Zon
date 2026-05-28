import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'settings_provider.g.dart';

/// Handles profile editing and account management.
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  bool build() => false; // isSaving

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? username,
  }) async {
    state = true;
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) throw Exception('Not signed in');
      await Supabase.instance.client.from('profiles').update({
        if (displayName != null) 'display_name': displayName,
        if (bio != null) 'bio': bio,
        if (username != null) 'username': username,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', uid);
    } finally {
      state = false;
    }
  }

  Future<void> updatePrivacy({required String defaultVisibility}) async {
    state = true;
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) throw Exception('Not signed in');
      await Supabase.instance.client.from('user_privacy').upsert({
        'user_id': uid,
        'default_stamp_visibility': defaultVisibility,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } finally {
      state = false;
    }
  }

  Future<void> deleteAccount() async {
    state = true;
    try {
      // Edge function deletes the auth user; cascades handle all data cleanup (GDPR).
      await Supabase.instance.client.functions.invoke('delete-account');
      await Supabase.instance.client.auth.signOut();
    } finally {
      state = false;
    }
  }
}
