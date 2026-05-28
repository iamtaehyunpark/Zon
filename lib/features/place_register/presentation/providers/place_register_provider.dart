import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_register_provider.freezed.dart';
part 'place_register_provider.g.dart';

@freezed
class PlaceRegisterState with _$PlaceRegisterState {
  const factory PlaceRegisterState({
    @Default(0) int step,             // 0=info, 1=review, 2=submitting, 3=done
    @Default('') String name,
    @Default('') String category,
    @Default('') String spaceType,
    @Default('') String address,
    double? lat,
    double? lng,
    String? submittedPlaceId,
    String? error,
  }) = _PlaceRegisterState;
}

@riverpod
class PlaceRegisterNotifier extends _$PlaceRegisterNotifier {
  @override
  PlaceRegisterState build() => const PlaceRegisterState();

  void setInfo({
    required String name,
    required String category,
    required String spaceType,
    required String address,
    required double lat,
    required double lng,
  }) {
    state = state.copyWith(
      name: name,
      category: category,
      spaceType: spaceType,
      address: address,
      lat: lat,
      lng: lng,
      step: 1,
      error: null,
    );
  }

  void backToInfo() => state = state.copyWith(step: 0, error: null);

  Future<void> submit() async {
    state = state.copyWith(step: 2, error: null);
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) throw Exception('Not signed in');

      final row = await Supabase.instance.client
          .from('places')
          .insert({
            'name':          state.name,
            'category':      state.category,
            'space_type':    state.spaceType,
            'address':       state.address.isEmpty ? null : state.address,
            'lat':           state.lat,
            'lng':           state.lng,
            'status':        'pending',
            'registered_by': uid,
          })
          .select('id')
          .single();

      final placeId = row['id'] as String;

      state = state.copyWith(step: 3, submittedPlaceId: placeId);
    } catch (e) {
      state = state.copyWith(step: 1, error: e.toString());
    }
  }

  void reset() => state = const PlaceRegisterState();
}
