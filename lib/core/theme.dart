import 'package:flutter/material.dart';

/// Material 3 theme tuned to mirror the clean, modern look
/// you had with shadcn/ui on the web.
ThemeData buildTheme(Brightness brightness) {
  const seed = Color(0xFF4F46E5); // Indigo-like, legible and brand-friendly
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
    ),
  );
}
