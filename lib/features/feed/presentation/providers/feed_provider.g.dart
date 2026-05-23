// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedNotifierHash() => r'd72a63bb67059a47a7a71333bd245351fadeb26e';

/// Loads and manages the social feed of Stamps.
/// Uses AsyncNotifierProvider because feed data is fetched from Supabase.
///
/// Copied from [FeedNotifier].
@ProviderFor(FeedNotifier)
final feedNotifierProvider =
    AutoDisposeAsyncNotifierProvider<FeedNotifier, List<StampEntity>>.internal(
  FeedNotifier.new,
  name: r'feedNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$feedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FeedNotifier = AutoDisposeAsyncNotifier<List<StampEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
