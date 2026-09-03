/// Available reading modes tailored for spiritual reflection and deep study.
enum QuranReaderMode {
  /// Pure Quranic Arabic reading prioritizing continuous, card-free visual flow.
  mushaf,

  /// Displays canonical Arabic text accompanied by verified translation.
  translation,

  /// Equips the reader with fast access to Tafsir and word insights.
  study,

  /// Distraction-free, full-screen environment for sustained recitation.
  focus;

  String get labelArabic {
    switch (this) {
      case QuranReaderMode.mushaf:
        return 'المصحف';
      case QuranReaderMode.translation:
        return 'الترجمة';
      case QuranReaderMode.study:
        return 'الدراسة والتفسير';
      case QuranReaderMode.focus:
        return 'الخشوع والتركيز';
    }
  }

  String get descriptionArabic {
    switch (this) {
      case QuranReaderMode.mushaf:
        return 'قراءة متصلة هادئة بالرسم العثماني';
      case QuranReaderMode.translation:
        return 'عرض النص العربي مع ترجمة المعاني';
      case QuranReaderMode.study:
        return 'أدوات الوصول السريع للتفسير والكلمات';
      case QuranReaderMode.focus:
        return 'قراءة خاشعة بإخفاء كافة الأشرطة والأدوات';
    }
  }
}

/// Visual theme presets specifically tailored for long-duration Quranic reading.
enum QuranReaderThemeMode {
  /// Gentle daylight presentation with crisp, dark typography.
  light,

  /// Low-emission night presentation reducing optical fatigue.
  dark,

  /// Classic warm Mushaf paper texture inspired by the Madinah edition.
  sepia;

  String get labelArabic {
    switch (this) {
      case QuranReaderThemeMode.light:
        return 'نهاري';
      case QuranReaderThemeMode.dark:
        return 'ليلي';
      case QuranReaderThemeMode.sepia:
        return 'ورق المصحف';
    }
  }
}
