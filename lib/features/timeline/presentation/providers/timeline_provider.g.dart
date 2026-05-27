// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineNotifierHash() => r'cba6d61de0cdc1f2a5a59a6e0806b46f46f20c2a';

/// Loads the current user's stamps ordered by date, grouped by calendar day.
///
/// Copied from [TimelineNotifier].
@ProviderFor(TimelineNotifier)
final timelineNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TimelineNotifier, Map<DateTime, List<FeedItem>>>.internal(
  TimelineNotifier.new,
  name: r'timelineNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timelineNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimelineNotifier
    = AutoDisposeAsyncNotifier<Map<DateTime, List<FeedItem>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
