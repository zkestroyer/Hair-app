import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hair profile (editable)'),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Face Shape'),
              subtitle: const Text('Oval (detected)'),
            ),
            ListTile(
              title: const Text('Texture'),
              subtitle: const Text('Wavy (manual)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Edit Profile')),
          ],
        ),
      ),
    );
  }
}
