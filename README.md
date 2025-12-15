# Hair Guidance App (MVP)

This repository contains a scaffolded Flutter MVP for the Hair Guidance App described in `plan.txt`.

Key features included in the scaffold:
- Android-first Flutter app
- Firebase integration placeholders (Auth, Firestore, Storage)
- Email/password + Google Sign-In (Firebase Auth)
- Camera flow with guided selfie capture (placeholder for on-device ML)
- Placeholder TFLite model and integration points for hair/beard segmentation
- Rule-based recommendation engine using local JSON (assets/rules.json)
- Riverpod for state management
- Offline caching using Hive
- Clean, vibrant Material theme with Google Fonts

What's included
- `lib/` core app source
- `assets/rules.json` example rules
- `assets/models/` placeholder model files
- `android/` basic Android config placeholders (developer needs to run `flutter create` for full platform setup)

Getting started (developer steps)
1. Install Flutter SDK and Android toolchain.
2. In the project root run:

```powershell
flutter pub get
```

3. Configure Firebase for Android (add `google-services.json` to `android/app/` and follow README steps).
4. Run the app on an Android emulator or device:

```powershell
flutter run -d emulator-5554
```

Notes
- This scaffold focuses on the app architecture and wiring; on-device models are placeholders and example rule sets can be extended.
- See `lib/` for implementation notes and next steps.

Firebase setup
- Create a Firebase project and register an Android app.
- Download `google-services.json` and place it in `android/app/`.
- Enable Email/Password and Google sign-in in Firebase Auth.

Models & On-device ML
- The `assets/models/sample_segmentation.tflite` file is a placeholder. Replace with a proper segmentation model and update `lib/src/services/tflite_service.dart` preprocessing accordingly.

Running tests

```powershell
flutter test
```

Next steps
- Implement camera UI and hook the `FaceService` and `TFLiteService` to run on-device analysis.
- Add Firestore rules storage option for recommendations if dynamic updates are desired.

License: MIT
