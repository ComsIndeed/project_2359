import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/theme_notifier.dart';

class AppTheme {
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB40);
  static const Color important = Color(0xFFFF4C52);

  /// `RoundedSuperellipseBorder` is a border shape that exists within the Flutter library. Do not bother looking up its definition, it just exists as a shape.

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

  static ThemeData buildTheme(
    Brightness brightness,
    Color accent, {
    BackgroundTone? backgroundTone,
  }) {
    final isDark = brightness == Brightness.dark;
    final tone = backgroundTone ?? BackgroundTone.ocean;
    final bg = tone.background(brightness);
    final surface = tone.surface(brightness);
    final secondarySurface = Color.lerp(
      surface,
      isDark ? Colors.white : Colors.black,
      0.08,
    )!;
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
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        iconTheme: IconThemeData(color: textPrimary),
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

extension AppThemeExtension on ThemeData {
  /// Returns an alternative scaffold background color that is adaptive to the current theme.
  ///
  /// This color is specifically designed for pages that need a distinct, solid feel
  /// (like collection pages) while still feeling part of the same theme family correctly.
  ///
  /// RULES FOR ALTERNATIVE COLORS (for future developers):
  /// 1. ADAPTIVE: They must be derived from the base colors (e.g., via [Color.lerp])
  ///    to ensure they automatically change when the user shifts BackgroundTones (Ocean, Stark, etc.).
  /// 2. CONTRAST: They should provide a subtle but noticeable shift from the main background
  ///    to signify a change in context (like entering a specific collection or sub-page).
  /// 3. SOLIDITY: For this specific "alt" background, we aim for a "solid dark grey" feel
  ///    in dark mode, which is achieved by lerping the theme's base background with a neutral grey.
  Color get scaffoldBackgroundAlt {
    final isDark = brightness == Brightness.dark;
    final base = scaffoldBackgroundColor;

    if (isDark) {
      // For "Global Black Mode", we ensure the alternate background is even closer to pure black.
      return Color.lerp(base, Colors.black, 0.8)!;
    } else {
      // For light mode, we create a slightly deeper, "paper-like" grey alternative.
      // This helps content pop more on pages with lots of tiles.
      return Color.lerp(base, const Color(0xFFE8E8E8), 0.4)!;
    }
  }
}
