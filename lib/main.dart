import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const ProviderScope(child: DeepApp()));
}

class DeepApp extends StatelessWidget {
  const DeepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B), // Zinc 950
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF27272A), // Zinc 800
          surface: Color(0xFF18181B), // Zinc 900
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: const Color(0xFFD4D4D8), // Zinc 300 (approx grey)
          displayColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const StartScreen(),
    );
  }
}
