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
