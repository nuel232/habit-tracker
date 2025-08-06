import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple.shade800, // Rich deep purple base
    secondary: Colors.deepPurple.shade400, // Softer accent
    tertiary: Colors.grey.shade800, // Light highlight
    surface: Colors.grey.shade900, // Dark background
    inversePrimary: Colors.deepPurple.shade50, // Subtle inverse
    onSurface: Colors.grey.shade200, // Good text contrast
    outline: Colors.grey.shade700, // Subtle borders
    inverseSurface: Colors.deepPurple.shade700,
    // surface: Colors.grey.shade900,
    // primary: Colors.grey.shade600,
    // secondary: const Color.fromARGB(255, 44, 44, 44),
    // tertiary: Colors.grey.shade800,
    // inversePrimary: Colors.grey.shade300,
  ),
);
