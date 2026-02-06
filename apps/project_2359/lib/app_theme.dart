import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF0A0E17);
  static const Color surface = Color(0xFF111625);
  static const Color primary = Color(0xFF448AFF);
  static const Color primaryOption2 = Color(
    0xFF2962FF,
  ); // Slightly darker variant
  static const Color secondarySurface = Color(0xFF1E2738);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8F9BB3);
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB40);

  // Border
  static ShapeBorder defaultShape = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(32),
  );

  static ShapeBorder defaultShapeWithSide = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(32),
    side: BorderSide(color: primary, width: 1.5),
  );

  static ShapeBorder cardShape = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(24),
  );

  static ShapeBorder buttonShape = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.circular(20),
  );

  static const double defaultPadding = 16.0;

  // CardButton Style Defaults
  static const CardButtonStyle cardButtonStyle = CardButtonStyle(
    saturation: 0.7,
    lightness: 0.05,
    disabledSaturation: 0.1,
    disabledLightness: 0.02,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryOption2,
        surface: surface,
        onSurface: textPrimary,
        error: error,
      ),

      // Predictive Back Navigation (Android)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),

      // Typography
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

      // Card Theme
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: cardShape,
        margin: EdgeInsets.all(8),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
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
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
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
          foregroundColor: primary,
          shape: buttonShape as OutlinedBorder,
        ),
      ),

      // Input Decoration
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
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: textSecondary, size: 24),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: background, // Transparent/Background
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: defaultShape,
      ),
    );
  }
}

/// Style configuration for CardButton widget
class CardButtonStyle {
  final double saturation;
  final double lightness;
  final double disabledSaturation;
  final double disabledLightness;

  const CardButtonStyle({
    this.saturation = 0.7,
    this.lightness = 0.05,
    this.disabledSaturation = 0.1,
    this.disabledLightness = 0.02,
  });

  CardButtonStyle copyWith({
    double? saturation,
    double? lightness,
    double? disabledSaturation,
    double? disabledLightness,
  }) {
    return CardButtonStyle(
      saturation: saturation ?? this.saturation,
      lightness: lightness ?? this.lightness,
      disabledSaturation: disabledSaturation ?? this.disabledSaturation,
      disabledLightness: disabledLightness ?? this.disabledLightness,
    );
  }
}
