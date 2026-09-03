/// Canonical phases across Umrah and Hajj journeys (§5, §7).
enum RitualPhase {
  preparation('الاستعداد والتأهب'),
  miqatAndIhram('الميقات والإحرام'),
  arrivalAndTawaf('الوصول وطواف القدوم/العمرة'),
  sai('السعي بين الصفا والمروة'),
  tahallul('الحلق أو التقصير والتحلل'),
  tarwiyah('يوم التروية (المبيت بمنى)'),
  arafah('يوم عرفة (الوقوف بعرفات)'),
  muzdalifah('ليلة المزدلفة (المبيت وجمع الحصى)'),
  nahrAndJamarat('يوم النحر (جمرة العقبة والهدي والحلق)'),
  tawafAlIfadah('طواف الإفاضة والسعي'),
  tashreeq('أيام التشريق (المبيت بمنى ورمي الجمرات)'),
  farewellTawaf('طواف الوداع وخاتمة النسك');

  final String labelArabic;
  const RitualPhase(this.labelArabic);
}
