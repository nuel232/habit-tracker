import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.deepPurple.shade600, // Vibrant base
    secondary: Colors.deepPurple.shade200, // Lighter accent
    tertiary: Colors.deepPurple.shade300, // Balanced highlight
    surface: Colors.grey.shade100, // Light background
    inversePrimary: Colors.deepPurple.shade50, // Consistent inverse
    error: Colors.red.shade500, // Clear error state
    outline: Colors.grey.shade400, // Subtle borders
    inverseSurface: Colors.deepPurple.shade500,
  ),
);
