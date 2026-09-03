/// Recognized Islamic Jurisprudential Schools and Scholarly Standpoints (§13, §14).
enum FiqhSchool {
  hanafi('المذهب الحنفي'),
  maliki('المذهب المالكي'),
  shafii('المذهب الشافعي'),
  hanbali('المذهب الحنبلي'),
  consensus('الإجماع المنقول'),
  majority('جمهور الفقهاء'),
  otherRecognized('أقوال معتبرة أخرى');

  final String labelArabic;
  const FiqhSchool(this.labelArabic);
}
