import 'package:flutter_test/flutter_test.dart';
import 'package:hair_guidance_app/src/services/recommendation_engine.dart';

void main() {
  test(
    'recommendation engine loads rules and returns recommendations for oval face',
    () async {
      final engine = RecommendationEngine();
      await engine.loadRulesFromAssets();
      final recs = engine.recommend({'faceShape': 'oval'});
      expect(recs, isNotEmpty);
    },
  );
}
