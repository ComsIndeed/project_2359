import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        // Main Page Titles (e.g., "Profile", "Sources")
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        // Secondary Titles / Modal Headers
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: -0.2,
        ),
        // Section Headers (e.g., "Recent", "All Materials")
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        // Card Titles / Important Labels
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        // List Item Titles / Bold Body
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Standard Body Text
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        // Secondary Body Text
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        // Captions / Small Labels
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textTertiary),
        // Overline / Tiny Bold Labels (e.g., "DEADLINE HORIZON")
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppColors.textTertiary,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
    );
  }
}
