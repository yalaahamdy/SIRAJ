/// Distinct classifications of sacred remembrance and supplication content (§4).
enum DhikrType {
  transmittedDhikr,
  transmittedDua,
  generalDua,
  scholarlyRecommendation,
  unverified;

  String get labelArabic {
    switch (this) {
      case DhikrType.transmittedDhikr:
        return 'ذكر مأثور';
      case DhikrType.transmittedDua:
        return 'دعاء مأثور';
      case DhikrType.generalDua:
        return 'دعاء عام';
      case DhikrType.scholarlyRecommendation:
        return 'صيغة موصى بها';
      case DhikrType.unverified:
        return 'غير موثق';
    }
  }
}
