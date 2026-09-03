import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography tokens prioritizing Arabic script legibility (RTL).
class AppTypography {
  static const String arabicFontFamily = 'Cairo'; // Fallback to system fonts smoothly
  static const String quranFontFamily = 'Amiri';

  static TextStyle displayLarge(bool isDark) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.3,
      );

  static TextStyle titleLarge(bool isDark) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.35,
      );

  static TextStyle bodyMedium(bool isDark) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.5,
      );

  static TextStyle bodySmall(bool isDark) => TextStyle(
        fontFamily: arabicFontFamily,
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        height: 1.4,
      );

  static TextStyle sacredText(bool isDark) => TextStyle(
        fontFamily: quranFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.8,
      );
}
