/// Integrity status of the prayer calculation (Fail-Safe requirement §9 & §27).
enum CalculationStatus {
  /// Calculation succeeded under normal astronomical twilight.
  normal,

  /// Twilight was abnormal; an angle-based calculation adjustment was applied.
  angleBasedException,

  /// High latitude rule was explicitly applied (e.g. middle of the night).
  highLatitudeRuleApplied,

  /// Extreme polar case requiring explicit juristic configuration from the user.
  requiresConfig,

  /// Calculation is completely unavailable for given parameters.
  unavailable,
}

extension CalculationStatusX on CalculationStatus {
  String get messageArabic {
    switch (this) {
      case CalculationStatus.normal:
        return 'حساب فلكي اعتيادي';
      case CalculationStatus.angleBasedException:
        return 'تم تطبيق قاعدة استثنائية للزوايا';
      case CalculationStatus.highLatitudeRuleApplied:
        return 'تم تطبيق قاعدة خطوط العرض العالية';
      case CalculationStatus.requiresConfig:
        return 'الموقع في منطقة قطبية تتطلب ضبطاً خاصاً';
      case CalculationStatus.unavailable:
        return 'الحساب غير متاح للإحداثيات المدخلة';
    }
  }
}
