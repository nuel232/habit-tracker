import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //start the app in light mode
  ThemeData _themeData = lightMode;

  // getter to get the current theme
  ThemeData get themeData => _themeData;

  //is current theme dart mode
  bool get isDarkMode => _themeData == darkTheme;

  //set theme
  set themeData(ThemeData themeDate) {
    _themeData = themeDate;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkTheme;
    } else {
      themeData = lightMode;
    }
  }
}
