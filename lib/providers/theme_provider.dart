import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  final _box = Hive.box('settings');
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _box.put('isDarkMode', isDark); // save
    notifyListeners();
  }

  void _loadTheme() {
    if (_box.containsKey('isDarkMode')) {
      final isDark = _box.get('isDarkMode');
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system; // follow system
    }
  }

}
