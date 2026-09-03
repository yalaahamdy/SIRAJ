/// Modes for reviewing and recalling Quranic verses.
enum ReviewMode {
  readAndRecall,
  completeAyah,
  nextAyah,
  reverseContext,
  passageRecall;

  String get labelArabic {
    switch (this) {
      case ReviewMode.readAndRecall:
        return 'القراءة والاستدعاء';
      case ReviewMode.completeAyah:
        return 'إكمال الآية';
      case ReviewMode.nextAyah:
        return 'استدعاء الآية التالية';
      case ReviewMode.reverseContext:
        return 'الربط بالسابق';
      case ReviewMode.passageRecall:
        return 'استدعاء مقطع كامل';
    }
  }
}
