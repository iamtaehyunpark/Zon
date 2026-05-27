// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authSessionHash() => r'd26a1b605b23f1bc3371c3ca64a8fb5b118eb834';

/// Exposes the current Supabase [Session]. Null = not signed in.
///
/// Copied from [authSession].
@ProviderFor(authSession)
final authSessionProvider = AutoDisposeStreamProvider<Session?>.internal(
  authSession,
  name: r'authSessionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthSessionRef = AutoDisposeStreamProviderRef<Session?>;
String _$currentUserHash() => r'13b562f2ce0fd40e9b770e77540eba33892f82de';

/// Convenience: current user or null.
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<User?>;
String _$authLoadingHash() => r'7cee7daaf6d7bb324de7c5636c0e46c3d014b30a';

/// True while the auth state stream is loading (app cold start).
///
/// Copied from [authLoading].
@ProviderFor(authLoading)
final authLoadingProvider = AutoDisposeProvider<bool>.internal(
  authLoading,
  name: r'authLoadingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthLoadingRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
