import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB40);

  static ShapeBorder defaultShape = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(32),
  );

  static ShapeBorder cardShape = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(24),
  );

  static ShapeBorder buttonShape = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(20),
  );

  static const double defaultPadding = 16.0;

  static CardButtonStyle cardButtonStyle = CardButtonStyle(
    saturation: 0.7,
    lightness: 0.05,
    disabledSaturation: 0.1,
    disabledLightness: 0.02,
    labelStyle: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    subLabelStyle: GoogleFonts.inter(
      fontWeight: FontWeight.normal,
      fontSize: 10,
      color: Colors.white.withValues(alpha: 0.55),
    ),
  );

  static ThemeData buildTheme(Brightness brightness, Color accent) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0A0E17) : const Color(0xFFF5F6FA);
    final surface = isDark ? const Color(0xFF111625) : Colors.white;
    final secondarySurface = isDark
        ? const Color(0xFF1E2738)
        : const Color(0xFFE8EAF0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textSecondary = isDark
        ? const Color(0xFF8F9BB3)
        : const Color(0xFF6B7280);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      primaryColor: accent,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accent,
        onPrimary: Colors.white,
        secondary: accent.withValues(alpha: 0.8),
        onSecondary: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: secondarySurface,
        error: error,
        onError: Colors.white,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: GoogleFonts.outfit(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        displaySmall: GoogleFonts.outfit(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        headlineMedium: GoogleFonts.outfit(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: GoogleFonts.inter(
          color: textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.inter(color: textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: textSecondary, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: cardShape,
        margin: EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: buttonShape as OutlinedBorder,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent, width: 1.5),
          shape: buttonShape as OutlinedBorder,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          shape: buttonShape as OutlinedBorder,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondarySurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      iconTheme: IconThemeData(color: textSecondary, size: 24),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bg,
        selectedItemColor: accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        shape: defaultShape,
      ),
    );
  }
}

class CardButtonStyle {
  final double saturation;
  final double lightness;
  final double disabledSaturation;
  final double disabledLightness;
  final TextStyle? labelStyle;
  final TextStyle? subLabelStyle;

  const CardButtonStyle({
    this.saturation = 0.7,
    this.lightness = 0.05,
    this.disabledSaturation = 0.1,
    this.disabledLightness = 0.02,
    this.labelStyle,
    this.subLabelStyle,
  });

  CardButtonStyle copyWith({
    double? saturation,
    double? lightness,
    double? disabledSaturation,
    double? disabledLightness,
    TextStyle? labelStyle,
    TextStyle? subLabelStyle,
  }) {
    return CardButtonStyle(
      saturation: saturation ?? this.saturation,
      lightness: lightness ?? this.lightness,
      disabledSaturation: disabledSaturation ?? this.disabledSaturation,
      disabledLightness: disabledLightness ?? this.disabledLightness,
      labelStyle: labelStyle ?? this.labelStyle,
      subLabelStyle: subLabelStyle ?? this.subLabelStyle,
    );
  }
}
