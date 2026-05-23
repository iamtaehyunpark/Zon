import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/verification_result.dart';
import '../../../map/domain/entities/place_entity.dart';

part 'auth_cta_provider.freezed.dart';
part 'auth_cta_provider.g.dart';

/// Drives the entire Auth CTA multi-step flow as a state machine.
/// Each state corresponds to a screen in the flow.
@freezed
class AuthCtaState with _$AuthCtaState {
  const factory AuthCtaState.initial() = _Initial;
  const factory AuthCtaState.placeSelected(PlaceEntity place) = _PlaceSelected;
  const factory AuthCtaState.recording(PlaceEntity place) = _Recording;
  const factory AuthCtaState.livenessChecking(PlaceEntity place) = _LivenessChecking;
  const factory AuthCtaState.livenessFailed(String reason) = _LivenessFailed;
  const factory AuthCtaState.processingAI(PlaceEntity place) = _ProcessingAI;
  const factory AuthCtaState.editing(PlaceEntity place, VerificationResult result) = _Editing;
  const factory AuthCtaState.submitting() = _Submitting;
  const factory AuthCtaState.error(String message) = _Error;
}

@riverpod
class AuthCtaNotifier extends _$AuthCtaNotifier {
  @override
  AuthCtaState build() => const AuthCtaState.initial();

  void selectPlace(PlaceEntity place) =>
      state = AuthCtaState.placeSelected(place);

  void startRecording(PlaceEntity place) =>
      state = AuthCtaState.recording(place);

  void onLivenessFailed(String reason) =>
      state = AuthCtaState.livenessFailed(reason);

  void onProcessingComplete(PlaceEntity place, VerificationResult result) =>
      state = AuthCtaState.editing(place, result);

  void reset() => state = const AuthCtaState.initial();
}
