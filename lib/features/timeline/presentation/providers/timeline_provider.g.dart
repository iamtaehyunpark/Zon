// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineNotifierHash() => r'f6e7b0a255f6f4ea5eda2100fd5f714064f6f741';

/// Loads the user's personal Stamp history grouped by date for the calendar view.
///
/// Copied from [TimelineNotifier].
@ProviderFor(TimelineNotifier)
final timelineNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TimelineNotifier, Map<DateTime, List<StampEntity>>>.internal(
  TimelineNotifier.new,
  name: r'timelineNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timelineNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimelineNotifier
    = AutoDisposeAsyncNotifier<Map<DateTime, List<StampEntity>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
