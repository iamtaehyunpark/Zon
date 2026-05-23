// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapNotifierHash() => r'af07061b0554e4e0063a39f5b79239a0dc5abb0b';

/// Manages nearby Places shown on the map and the currently selected Place.
///
/// Copied from [MapNotifier].
@ProviderFor(MapNotifier)
final mapNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MapNotifier, List<PlaceEntity>>.internal(
  MapNotifier.new,
  name: r'mapNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mapNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MapNotifier = AutoDisposeAsyncNotifier<List<PlaceEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
