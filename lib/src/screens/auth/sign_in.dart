import 'package:flutter/material.dart';
import 'package:hair_guidance_app/src/screens/home/home_screen.dart';
import 'package:hair_guidance_app/src/services/auth_service.dart';
import 'package:hair_guidance_app/src/services/profile_repository.dart';
import 'package:hair_guidance_app/src/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithEmail,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Sign in with Email'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _googleSignIn,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithEmail() {
    _doSignIn(
      (AuthService s) => s.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      ),
    );
  }

  void _googleSignIn() {
    _doSignIn((AuthService s) => s.signInWithGoogle());
  }

  void _doSignIn(Future<dynamic> Function(AuthService) action) async {
    setState(() => _loading = true);
    try {
      final auth = AuthService();
      final res = await action(auth);
      if (res != null) {
        // ensure default profile exists locally
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final repo = ProfileRepository();
          final existing = repo.getProfile(user.uid);
          if (existing == null) {
            final defaultProfile = UserProfile(
              uid: user.uid,
              name: user.displayName ?? user.email ?? '',
              email: user.email ?? '',
              hairProfile: HairProfile(
                faceShape: 'unknown',
                texture: 'unknown',
                thickness: 'unknown',
                porosity: 'unknown',
                issues: [],
              ),
              beardProfile: BeardProfile(
                hasBeard: false,
                beardType: 'none',
                issues: [],
              ),
            );
            await repo.saveProfile(user.uid, defaultProfile);
          }
        }
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
