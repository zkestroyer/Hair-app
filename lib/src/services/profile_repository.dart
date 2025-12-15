import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hair_guidance_app/src/models/user_profile.dart';

class ProfileRepository {
  static const _boxName = 'profiles';

  Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  Future<void> saveProfile(String uid, UserProfile profile) async {
    final box = Hive.box(_boxName);
    // store as JSON for now
    final data = {
      'uid': profile.uid,
      'name': profile.name,
      'email': profile.email,
      'hairProfile': {
        'faceShape': profile.hairProfile.faceShape,
        'texture': profile.hairProfile.texture,
        'thickness': profile.hairProfile.thickness,
        'porosity': profile.hairProfile.porosity,
        'issues': profile.hairProfile.issues,
      },
      'beardProfile': {
        'hasBeard': profile.beardProfile.hasBeard,
        'beardType': profile.beardProfile.beardType,
        'issues': profile.beardProfile.issues,
      },
    };
    await box.put(uid, json.encode(data));
  }

  UserProfile? getProfile(String uid) {
    final box = Hive.box(_boxName);
    final raw = box.get(uid) as String?;
    if (raw == null) return null;
    final map = json.decode(raw) as Map<String, dynamic>;
    final hp = map['hairProfile'] as Map<String, dynamic>? ?? {};
    final bp = map['beardProfile'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      uid: map['uid'] ?? uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      hairProfile: HairProfile(
        faceShape: hp['faceShape'] ?? 'unknown',
        texture: hp['texture'] ?? 'unknown',
        thickness: hp['thickness'] ?? 'unknown',
        porosity: hp['porosity'] ?? 'unknown',
        issues: List<String>.from(hp['issues'] ?? []),
      ),
      beardProfile: BeardProfile(
        hasBeard: bp['hasBeard'] ?? false,
        beardType: bp['beardType'] ?? 'none',
        issues: List<String>.from(bp['issues'] ?? []),
      ),
    );
  }
}
