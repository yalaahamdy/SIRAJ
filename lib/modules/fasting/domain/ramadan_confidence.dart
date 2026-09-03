/// Degree of certainty in the declaration or calculation of Ramadan boundaries (§8, §9).
enum RamadanConfidence {
  confirmed('مؤكد بالإعلان الشرعي'),
  estimated('تقدير حسابي فلكي'),
  userConfigured('محدد يدوياً من المستخدم'),
  unresolved('غير محسوم');

  final String labelArabic;
  const RamadanConfidence(this.labelArabic);
}
