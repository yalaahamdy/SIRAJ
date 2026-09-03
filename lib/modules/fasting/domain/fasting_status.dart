/// Represents user-tracked status of fasting for a specific day (§4, §5).
enum FastingStatus {
  planned('مخطط للصيام'),
  fasted('تم الصيام'),
  notFasted('مفطر'),
  missed('فاتني الصيام'),
  interrupted('تم قطع الصيام لعذر'),
  unknown('غير محدد');

  final String labelArabic;
  const FastingStatus(this.labelArabic);
}
