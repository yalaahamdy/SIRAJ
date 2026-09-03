/// Precision classification for historical dates without false certainty (§6, §7).
enum DatePrecision {
  exactDate('تاريخ محدد باليوم والشهر'),
  approximateDate('تاريخ تقريبي مأثور'),
  yearOnly('محدد بالسنة فقط'),
  period('ضمن حقبة أو فترة زمنية'),
  unknown('تاريخ غير معلوم أو مجهول');

  final String labelArabic;
  const DatePrecision(this.labelArabic);
}
