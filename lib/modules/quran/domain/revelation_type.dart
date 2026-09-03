/// Classification of Surah revelation (Meccan or Medinan).
enum RevelationType {
  meccan,
  medinan;

  String get nameArabic => this == meccan ? 'مكية' : 'مدنية';
  String get nameEnglish => this == meccan ? 'Meccan' : 'Medinan';
}
