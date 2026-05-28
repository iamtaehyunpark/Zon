import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around Supabase auth — keeps auth logic out of widgets.
class AuthService {
  static final _client = Supabase.instance.client;

  static Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.zonapp.zon://login-callback',
    );
  }

  static Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.zonapp.zon://login-callback',
    );
  }

  static Future<void> signInWithTestAccount() async {
    await _client.auth.signInWithPassword(
      email: 'test@zon.app',
      password: 'zon-test-2026',
    );
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
