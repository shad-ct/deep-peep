import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shell.dart';

void main() {
  runApp(const ProviderScope(child: DeepApp()));
}

class DeepApp extends StatelessWidget {
  const DeepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Peep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B), // Zinc 950
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF27272A), // Zinc 800
          surface: Color(0xFF18181B), // Zinc 900
        ),
        // Use locally bundled Inter font — no runtime network requests
        fontFamily: 'Inter',
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: const Color(0xFFD4D4D8), // Zinc 300
          displayColor: Colors.white,
          fontFamily: 'Inter',
        ),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
