/// Categorizes the religious or personal type of fasting (§4, §6).
enum FastingType {
  ramadan('رمضان المبارك'),
  qada('قضاء رمضان'),
  vow('صيام نذر'),
  voluntary('صيام تطوع'),
  other('صيام مخصص');

  final String labelArabic;
  const FastingType(this.labelArabic);
}
