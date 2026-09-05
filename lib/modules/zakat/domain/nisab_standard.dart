/// Standard basis for evaluating Nisab threshold (§8).
enum NisabStandard {
  gold85g,
  silver595g,
  custom;

  String get labelArabic {
    switch (this) {
      case NisabStandard.gold85g:
        return 'معيار الذهب (85 جرام عيار 24)';
      case NisabStandard.silver595g:
        return 'معيار الفضة (595 جرام)';
      case NisabStandard.custom:
        return 'معيار مخصص';
    }
  }

  String get labelShortArabic {
    switch (this) {
      case NisabStandard.gold85g:
        return 'الذهب (85 جرام)';
      case NisabStandard.silver595g:
        return 'الفضة (595 جرام)';
      case NisabStandard.custom:
        return 'قيمة يدوية مباشرة';
    }
  }

  String get descriptionArabic {
    switch (this) {
      case NisabStandard.gold85g:
        return 'الأصل المعاصر المعتمد لدى مجمع الفقه الإسلامي وهيئات كبار العلماء (85 جرام ذهب نقي عيار 24).';
      case NisabStandard.silver595g:
        return 'المعيار المعتمد لدى المذهب الحنفي ودار الإفتاء المصرية، وهو أصلح للفقراء والمحتاجين (595 جرام فضة).';
      case NisabStandard.custom:
        return 'إدخال القيمة النقدية للنصاب مباشرة حسب الفتاوى المحلية المتبعة أو التقدير الشخصي.';
    }
  }

  double get defaultWeightGrams {
    switch (this) {
      case NisabStandard.gold85g:
        return 85.0;
      case NisabStandard.silver595g:
        return 595.0;
      case NisabStandard.custom:
        return 85.0;
    }
  }
}
