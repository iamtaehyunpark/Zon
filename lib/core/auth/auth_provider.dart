import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

/// Exposes the current Supabase [Session]. Null = not signed in.
@riverpod
Stream<Session?> authSession(Ref ref) =>
    Supabase.instance.client.auth.onAuthStateChange
        .map((event) => event.session);

/// Convenience: current user or null.
@riverpod
User? currentUser(Ref ref) =>
    ref.watch(authSessionProvider).valueOrNull?.user;

/// True while the auth state stream is loading (app cold start).
@riverpod
bool authLoading(Ref ref) => ref.watch(authSessionProvider).isLoading;
