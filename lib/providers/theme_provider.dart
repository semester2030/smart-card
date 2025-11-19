import 'package:flutter/material.dart';

/// Theme Provider
/// إدارة حالة الثيم (فاتح/داكن)
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Toggle theme
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// Set light theme
  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// Set dark theme
  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  /// Set system theme
  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

