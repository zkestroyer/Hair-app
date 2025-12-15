import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_guidance_app/src/screens/splash_screen.dart';

class HairGuidanceApp extends StatelessWidget {
  const HairGuidanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Hair Guidance App',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.purpleAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
