/// Semantic classification of educational content types within lessons (§6).
enum LearningContentType {
  sourceText('نص مصدري أصيل'),
  explanation('شرح وبيان تأصيلي'),
  scholarlyView('قول واجتهاد فقهي'),
  translation('ترجمة منسوبة'),
  summary('خلاصة واستنتاج'),
  example('مثال وتطبيق معاصر'),
  quiz('تقييم واستيعاب'),
  userNote('ملاحظة شخصية للمتعلم');

  final String labelArabic;
  const LearningContentType(this.labelArabic);
}
