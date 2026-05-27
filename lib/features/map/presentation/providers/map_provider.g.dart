// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPositionHash() => r'e04adf9254e1ed41eb96743cd3e157a4eff37bea';

/// Holds the user's current GPS fix — updated once on load.
///
/// Copied from [userPosition].
@ProviderFor(userPosition)
final userPositionProvider = AutoDisposeFutureProvider<Position?>.internal(
  userPosition,
  name: r'userPositionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userPositionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserPositionRef = AutoDisposeFutureProviderRef<Position?>;
String _$mapNotifierHash() => r'c5ab4b4ba586d882bb232ffe02ebe5acd836aa46';

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
