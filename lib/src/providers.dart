import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_guidance_app/src/services/recommendation_engine.dart';
import 'package:hair_guidance_app/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final recommendationEngineProvider = Provider<RecommendationEngine>(
  (ref) => RecommendationEngine(),
);
