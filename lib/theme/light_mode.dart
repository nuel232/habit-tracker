import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.deepPurple.shade600,
    secondary: Colors.deepPurple.shade100, // More cohesive
    surface: Colors.grey.shade200,
    inversePrimary: Colors.deepPurple.shade50, // Consistent with theme
    tertiary: Colors.deepPurple.shade300, // Better differentiation
    error: Colors.red.shade600, // Add error handling
    outline: Colors.grey.shade300, // Useful for borders
  ),
);
