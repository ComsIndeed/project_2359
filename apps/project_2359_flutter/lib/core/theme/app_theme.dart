import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _background = Color(0xFF09090b);
  static const Color _surface = Color(0xFF1E1E1E);
  static const Color _accent = Color(0xFF00D9FF);
  static const Color _textPrimary = Color(0xFFEDEDED);
  static const Color _textSecondary = Color(0xFF9CA3AF);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _background,
    colorScheme: const ColorScheme.dark(
      primary: _accent,
      surface: _surface,
      onSurface: _textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        color: _textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.inter(
        color: _textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.inter(
        color: _textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(color: _textPrimary, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: _textPrimary, fontSize: 14),
      labelSmall: GoogleFonts.inter(
        color: _textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _background,
      selectedItemColor: _accent,
      unselectedItemColor: _textSecondary,
      elevation: 0,
      showUnselectedLabels: true,
    ),
    cardTheme: CardThemeData(
      color: _surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _accent,
        foregroundColor: _background,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );
}
