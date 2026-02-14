import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifier = ThemeNotifier();

enum BackgroundTone {
  deepNavy('Deep Navy', Color(0xFF0A0E17), Color(0xFF111625)),
  pureBlack('Pure Black', Color(0xFF000000), Color(0xFF0D0D0D)),
  charcoal('Charcoal', Color(0xFF121212), Color(0xFF1E1E1E)),
  warmDark('Warm Dark', Color(0xFF1A1410), Color(0xFF252018));

  final String label;
  final Color background;
  final Color surface;
  const BackgroundTone(this.label, this.background, this.surface);
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = const Color(0xFF448AFF);
  BackgroundTone _backgroundTone = BackgroundTone.deepNavy;

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  BackgroundTone get backgroundTone => _backgroundTone;

  static const _themeModeKey = 'theme_mode';
  static const _accentColorKey = 'accent_color';
  static const _backgroundToneKey = 'background_tone';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.dark.index;
    _themeMode = ThemeMode.values[modeIndex];
    final colorValue = prefs.getInt(_accentColorKey);
    if (colorValue != null) _accentColor = Color(colorValue);
    final toneIndex = prefs.getInt(_backgroundToneKey);
    if (toneIndex != null && toneIndex < BackgroundTone.values.length) {
      _backgroundTone = BackgroundTone.values[toneIndex];
    }
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

  void setBackgroundTone(BackgroundTone tone) async {
    _backgroundTone = tone;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_backgroundToneKey, tone.index);
  }
}
