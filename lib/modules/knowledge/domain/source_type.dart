/// Classification of authoritative scholarly and religious sources (§6).
enum SourceType {
  quran('مصحف شريف'),
  hadithCollection('مصنف حديثي'),
  fiqhReference('مرجع فقهي'),
  tafsir('كتاب تفسير'),
  seerah('كتاب سيرة نبوية'),
  scholarWork('مؤلف / مصنف عالم'),
  institutionalPublication('إصدار مؤسسي / مجمع فقهي'),
  encyclopedia('موسوعة علمية'),
  historicalSource('مصدر تاريخي');

  final String labelArabic;
  const SourceType(this.labelArabic);
}
