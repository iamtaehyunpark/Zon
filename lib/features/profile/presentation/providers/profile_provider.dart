import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_provider.g.dart';

/// Loads a user profile. Null userId = own profile (from auth session).
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<ProfileEntity?> build(String? userId) async {
    // TODO(M2): load profile from Supabase profiles table
    return null;
  }
}
