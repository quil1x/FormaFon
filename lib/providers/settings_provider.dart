// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // 1. Управління темою
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // 2. Управління мовою
  Locale _locale = const Locale('uk');
  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }
}