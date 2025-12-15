import 'dart:convert';

import 'package:flutter/services.dart';

class RecommendationEngine {
  Map<String, dynamic> _rules = {};

  Future<void> loadRulesFromAssets() async {
    final raw = await rootBundle.loadString('assets/rules.json');
    _rules = json.decode(raw) as Map<String, dynamic>;
  }

  List<String> recommend(Map<String, dynamic> profile) {
    // Simple deterministic example: find rules matching face shape
    final face = profile['faceShape'] as String? ?? 'unknown';
    final rulesForFace = _rules['faceShape']?[face] as List?;
    if (rulesForFace != null) {
      return rulesForFace.map((e) => e.toString()).toList();
    }
    return ['No deterministic recommendation found.'];
  }
}
