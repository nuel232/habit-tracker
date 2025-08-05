import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple.shade400,
    secondary: Colors.deepPurple.shade600, // Harmonious
    tertiary: Colors.deepPurple.shade200, // Better hierarchy
    surface: Colors.grey.shade900,
    inversePrimary: Colors.deepPurple.shade100, // Consistent
    onSurface: Colors.grey.shade100, // Better text contrast
    outline: Colors.grey.shade600,
  ),
);
