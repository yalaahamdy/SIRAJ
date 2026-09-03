import 'package:flutter/material.dart';

/// Design tokens for colors across Light and Dark themes.
/// High-contrast and WCAG AA/AAA compliant.
class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF0F5132); // Deep Islamic Forest Green
  static const Color primaryLight = Color(0xFF198754);
  static const Color primaryDark = Color(0xFF0A3622);

  static const Color goldAccent = Color(0xFFD4AF37); // Muted Islamic Gold
  static const Color goldAccentLight = Color(0xFFE5C158);

  // Light Mode Neutrals
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1E2125);
  static const Color textSecondaryLight = Color(0xFF6C757D);
  static const Color borderLight = Color(0xFFDEE2E6);

  // Dark Mode Neutrals
  static const Color backgroundDark = Color(0xFF121416);
  static const Color surfaceDark = Color(0xFF1E2227);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondaryDark = Color(0xFFADB5BD);
  static const Color borderDark = Color(0xFF2C3238);

  // Semantic Status
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color success = Color(0xFF198754);
  static const Color info = Color(0xFF0D6EFD);

  // Sacred Display Container (Soft background framing canonical texts)
  static const Color sacredFrameLight = Color(0xFFF4F8F5);
  static const Color sacredFrameDark = Color(0xFF17241C);
  static const Color sacredBorder = Color(0xFFC3D9C9);

  // Dynamic Semantic Color Roles (High Contrast for Light & Dark)
  static Color primaryText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;

  static Color secondaryText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;

  static Color mutedText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF8E959D) : const Color(0xFF8A929A);

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight;

  static Color elevatedSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF282D33) : const Color(0xFFF1F3F5);

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? borderDark : borderLight;

  static Color cardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight;

  static Color primaryAction(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? goldAccentLight : primary;

  static Color disabledAction(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF495057) : const Color(0xFFCED4DA);

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? borderDark : borderLight;
}

