import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifier = ThemeNotifier();

enum BackgroundTone {
  ocean(
    'Ocean',
    Color(0xFF0A0E17),
    Color(0xFF111625),
    Color(0xFFF0F4FF),
    Color(0xFFFFFFFF),
  ),
  stark(
    'Stark',
    Color(0xFF000000),
    Color(0xFF0D0D0D),
    Color(0xFFFFFFFF),
    Color(0xFFF5F5F5),
  ),
  solarized(
    'Solarized',
    Color(0xFF002B36),
    Color(0xFF073642),
    Color(0xFFFDF6E3),
    Color(0xFFEEE8D5),
  ),
  highContrast(
    'High Contrast',
    Color(0xFF000000),
    Color(0xFF000000),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
    isHighContrast: true,
  ),
  vibrant(
    'Vibrant',
    Color(0xFF1A0B2E),
    Color(0xFF261447),
    Color(0xFFFFF0F5),
    Color(0xFFFFE4E1),
  );

  final String label;
  final Color darkBackground;
  final Color darkSurface;
  final Color lightBackground;
  final Color lightSurface;
  final bool isHighContrast;

  const BackgroundTone(
    this.label,
    this.darkBackground,
    this.darkSurface,
    this.lightBackground,
    this.lightSurface, {
    this.isHighContrast = false,
  });

  Color background(Brightness brightness) =>
      brightness == Brightness.dark ? darkBackground : lightBackground;

  Color surface(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurface : lightSurface;
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = const Color(0xFF448AFF);
  BackgroundTone _backgroundTone = BackgroundTone.stark;

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
    } else {
      _backgroundTone = BackgroundTone.stark;
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
