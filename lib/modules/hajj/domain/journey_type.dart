/// Classification of Pilgrimage journeys and Hajj nusuk types (§6, §12).
enum JourneyType {
  umrah('العمرة المفردة'),
  hajjTamattu('حج التمتع (عمرة ثم حج)'),
  hajjQiran('حج القِران (عمرة وحج معاً)'),
  hajjIfrad('حج الإفراد (حج فقط)');

  final String labelArabic;
  const JourneyType(this.labelArabic);
}
