import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/auth_tier.dart';

/// Handles all stamp writes — keeps DB calls out of screen widgets.
class StampService {
  static final _db = Supabase.instance.client;

  static Future<void> createStamp({
    required String placeId,
    required AuthTier tier,
    required double visionScore,
    required double sensorScore,
    required double finalScore,
    required String certificateHash,
    String? caption,
    List<String> sensoryTags = const [],
  }) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw const AuthException('Not signed in');

    await _db.from('stamps').insert({
      'user_id':          uid,
      'place_id':         placeId,
      'tier':             tier.name,
      'visibility':       'public',
      'caption':          caption?.isEmpty == true ? null : caption,
      'sensory_tags':     sensoryTags,
      'vision_score':     visionScore,
      'sensor_score':     sensorScore,
      'final_score':      finalScore,
      'certificate_hash': certificateHash,
    });
  }
}
