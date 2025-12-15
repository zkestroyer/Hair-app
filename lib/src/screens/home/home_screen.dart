import 'package:flutter/material.dart';
import 'package:hair_guidance_app/src/screens/camera/camera_flow.dart';
import 'package:hair_guidance_app/src/screens/profile/profile_screen.dart';
import 'package:hair_guidance_app/src/screens/auth/sign_in.dart';
import 'package:hair_guidance_app/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.displayName ?? user?.email ?? 'Hair Guidance'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              // return to sign-in
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CameraFlow())),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture Selfie'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
              icon: const Icon(Icons.person),
              label: const Text('Profile & Hair Info'),
            ),
            const SizedBox(height: 12),
            // Placeholder for recommendations
            Expanded(
              child: Center(
                child: Text(
                  'Recommendations will appear here',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
