/// Historical evidence and provenance classification levels (§2, §5).
enum HistoricalEvidenceLevel {
  primarySource('مصدر أصيل مباشر'),
  strongReport('رواية قوية مسندة'),
  multipleSources('روايات متعددة متظافرة'),
  singleReport('رواية آحاد مفردة'),
  disputed('مسألة أو رواية مختلف فيها'),
  weakReport('رواية ضعيفة الإسناد'),
  unverified('غير محققة كنسياً');

  final String labelArabic;
  const HistoricalEvidenceLevel(this.labelArabic);
}
