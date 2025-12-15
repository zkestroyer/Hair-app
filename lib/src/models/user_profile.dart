class UserProfile {
  final String uid;
  final String name;
  final String email;
  final HairProfile hairProfile;
  final BeardProfile beardProfile;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.hairProfile,
    required this.beardProfile,
  });
}

class HairProfile {
  final String faceShape;
  final String texture;
  final String thickness;
  final String porosity;
  final List<String> issues;
  HairProfile({
    required this.faceShape,
    required this.texture,
    required this.thickness,
    required this.porosity,
    required this.issues,
  });
}

class BeardProfile {
  final bool hasBeard;
  final String beardType;
  final List<String> issues;
  BeardProfile({
    required this.hasBeard,
    required this.beardType,
    required this.issues,
  });
}
