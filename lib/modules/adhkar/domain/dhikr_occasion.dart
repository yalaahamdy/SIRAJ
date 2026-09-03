/// Standard occasions and contexts for remembrance (§14).
enum DhikrOccasion {
  morning,
  evening,
  afterPrayer,
  sleep,
  waking,
  leavingHome,
  enteringHome,
  travel,
  food,
  difficulty,
  general;

  String get labelArabic {
    switch (this) {
      case DhikrOccasion.morning:
        return 'أذكار الصباح';
      case DhikrOccasion.evening:
        return 'أذكار المساء';
      case DhikrOccasion.afterPrayer:
        return 'أذكار بعد الصلاة';
      case DhikrOccasion.sleep:
        return 'أذكار النوم';
      case DhikrOccasion.waking:
        return 'أذكار الاستيقاظ';
      case DhikrOccasion.leavingHome:
        return 'الخروج من المنزل';
      case DhikrOccasion.enteringHome:
        return 'دخول المنزل';
      case DhikrOccasion.travel:
        return 'أذكار السفر';
      case DhikrOccasion.food:
        return 'أذكار الطعام';
      case DhikrOccasion.difficulty:
        return 'الكرب والهم';
      case DhikrOccasion.general:
        return 'أذكار عامة';
    }
  }
}
