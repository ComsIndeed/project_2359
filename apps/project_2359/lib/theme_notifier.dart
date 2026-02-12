import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifier = ThemeNotifier();

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = const Color(0xFF448AFF);

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  static const _themeModeKey = 'theme_mode';
  static const _accentColorKey = 'accent_color';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.dark.index;
    _themeMode = ThemeMode.values[modeIndex];
    final colorValue = prefs.getInt(_accentColorKey);
    if (colorValue != null) _accentColor = Color(colorValue);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeModeKey, mode.index);
  }

  void setAccentColor(Color color) async {
    _accentColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_accentColorKey, color.toARGB32());
  }
}
