import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../data/models/user_profile.dart';
import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';

/// Account settings: profile edit, privacy, sign out, delete account.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _displayNameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _usernameCtrl;
  String _visibility = 'public';
  bool _initialised = false;

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _bioCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  void _initFrom(UserProfile p) {
    if (_initialised) return;
    _displayNameCtrl = TextEditingController(text: p.displayName ?? '');
    _bioCtrl         = TextEditingController(text: p.bio ?? '');
    _usernameCtrl    = TextEditingController(text: p.username);
    _initialised = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPrivacy());
  }

  Future<void> _loadPrivacy() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || !mounted) return;
    final row = await Supabase.instance.client
        .from('user_privacy')
        .select('default_stamp_visibility')
        .eq('user_id', uid)
        .maybeSingle();
    if (mounted && row != null) {
      final v = row['default_stamp_visibility'] as String?;
      if (v != null) setState(() => _visibility = v);
    }
  }

  Future<void> _save() async {
    try {
      await ref.read(settingsNotifierProvider.notifier).updateProfile(
        displayName: _displayNameCtrl.text.trim(),
        bio:         _bioCtrl.text.trim(),
        username:    _usernameCtrl.text.trim(),
      );
      await ref.read(settingsNotifierProvider.notifier).updatePrivacy(
        defaultVisibility: _visibility,
      );
      // Reload profile
      ref.invalidate(profileNotifierProvider(null));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    if (mounted) context.go('/feed');
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text('Delete Account',
            style: TextStyle(color: Colors.white)),
        content: const Text(
            'This permanently deletes your profile, stamps, and badges. This cannot be undone.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ref.read(settingsNotifierProvider.notifier).deleteAccount();
      if (mounted) context.go('/feed');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider(null));
    final isSaving = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          if (isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    color: Color(0xFF1D9E75), strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Save',
                  style: TextStyle(
                      color: Color(0xFF1D9E75), fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF1D9E75))),
        error: (e, _) => Center(
            child: Text(e.toString(),
                style: const TextStyle(color: Colors.white38))),
        data: (data) {
          if (data == null) return const SizedBox.shrink();
          _initFrom(data.profile);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              _section('Profile'),
              _field('Display name', _displayNameCtrl),
              const SizedBox(height: 12),
              _field('Username', _usernameCtrl),
              const SizedBox(height: 12),
              _field('Bio', _bioCtrl, maxLines: 3),

              const SizedBox(height: 28),
              _section('Privacy'),
              _visibilityPicker(),

              const SizedBox(height: 28),
              _section('Account'),
              _dangerButton(
                label: 'Sign out',
                icon: Icons.logout,
                color: Colors.white70,
                onTap: _signOut,
              ),
              const SizedBox(height: 12),
              _dangerButton(
                label: 'Delete account',
                icon: Icons.delete_forever,
                color: Colors.redAccent,
                onTap: _deleteAccount,
              ),

              const SizedBox(height: 28),
              Center(
                child: Text(
                  'ZON v0.1.0',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 11),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8)),
      );

  Widget _field(String hint, TextEditingController ctrl, {int maxLines = 1}) =>
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      );

  Widget _visibilityPicker() => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          children: [
            _visibilityOption('public', 'Public', 'Anyone can see your stamps',
                Icons.public),
            const Divider(color: Color(0xFF2A2A2A), height: 1),
            _visibilityOption('friends', 'Friends only',
                'Only friends can see your stamps', Icons.people),
            const Divider(color: Color(0xFF2A2A2A), height: 1),
            _visibilityOption('private', 'Private',
                'Only you can see your stamps', Icons.lock_outline),
          ],
        ),
      );

  Widget _visibilityOption(
      String value, String label, String subtitle, IconData icon) {
    final selected = _visibility == value;
    return ListTile(
      leading: Icon(icon,
          color: selected ? const Color(0xFF1D9E75) : Colors.white38,
          size: 20),
      title: Text(label,
          style: TextStyle(
              color: selected ? Colors.white : Colors.white70, fontSize: 13)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: Colors.white38, fontSize: 11)),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 18)
          : null,
      onTap: () => setState(() => _visibility = value),
    );
  }

  Widget _dangerButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) =>
      OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      );
}
