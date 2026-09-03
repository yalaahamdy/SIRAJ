import 'package:flutter/material.dart';

/// Spacing and Radius tokens for layout consistency.
class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Standard Edge Insets
  static const EdgeInsets paddingScreen = EdgeInsets.all(m);
  static const EdgeInsets paddingCard = EdgeInsets.all(m);
  static const EdgeInsets paddingSmall = EdgeInsets.all(s);
}

/// Border radius tokens.
class AppRadius {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;

  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(s));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(m));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(l));
}
