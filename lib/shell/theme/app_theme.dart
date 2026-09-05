import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// App theme builders for Light and Dark modes with WCAG AAA contrast.
class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.goldAccent,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        error: AppColors.error,
        outline: AppColors.borderLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimaryLight,
        iconColor: AppColors.primary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge(false),
        displayMedium: AppTypography.displayMedium(false),
        displaySmall: AppTypography.displaySmall(false),
        titleLarge: AppTypography.titleLarge(false),
        titleMedium: AppTypography.titleMedium(false),
        titleSmall: AppTypography.titleSmall(false),
        bodyLarge: AppTypography.bodyLarge(false),
        bodyMedium: AppTypography.bodyMedium(false),
        bodySmall: AppTypography.bodySmall(false),
        labelLarge: AppTypography.labelLarge(false),
        labelMedium: AppTypography.labelMedium(false),
        labelSmall: AppTypography.labelSmall(false),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.goldAccent,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        error: AppColors.error,
        outline: AppColors.borderDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusMedium,
          side: BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimaryDark,
        iconColor: AppColors.textSecondaryDark,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge(true),
        displayMedium: AppTypography.displayMedium(true),
        displaySmall: AppTypography.displaySmall(true),
        titleLarge: AppTypography.titleLarge(true),
        titleMedium: AppTypography.titleMedium(true),
        titleSmall: AppTypography.titleSmall(true),
        bodyLarge: AppTypography.bodyLarge(true),
        bodyMedium: AppTypography.bodyMedium(true),
        bodySmall: AppTypography.bodySmall(true),
        labelLarge: AppTypography.labelLarge(true),
        labelMedium: AppTypography.labelMedium(true),
        labelSmall: AppTypography.labelSmall(true),
      ),
    );
  }
}
