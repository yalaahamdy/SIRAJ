/// Grounding state of an AI response with respect to verified evidence (§42, §43).
enum GroundingStatus {
  fullyGrounded,
  partiallyGrounded,
  insufficientEvidence,
  conflictingSources,
  outOfScope,
  abstained;

  String get labelArabic {
    switch (this) {
      case GroundingStatus.fullyGrounded:
        return 'مسند بالكامل بالأدلة الموثقة';
      case GroundingStatus.partiallyGrounded:
        return 'مسند جزئياً بالأدلة المتاحة';
      case GroundingStatus.insufficientEvidence:
        return 'أدلة غير كافية لحسم الجواب';
      case GroundingStatus.conflictingSources:
        return 'اختلاف معتبر بين المصادر';
      case GroundingStatus.outOfScope:
        return 'خارج نطاق المنظومة الموثقة';
      case GroundingStatus.abstained:
        return 'امتناع شرعي / تحفظ معلن';
    }
  }
}
