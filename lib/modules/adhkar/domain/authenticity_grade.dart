/// Scholarly verification and authenticity grades of transmitted narrations (§6).
enum AuthenticityGrade {
  authenticated,
  acceptedWithNote,
  disputed,
  weak,
  unverified,
  rejected;

  String get labelArabic {
    switch (this) {
      case AuthenticityGrade.authenticated:
        return 'صحيح أو حسن ثابت';
      case AuthenticityGrade.acceptedWithNote:
        return 'مقبول مع بيان';
      case AuthenticityGrade.disputed:
        return 'مختلف فيه';
      case AuthenticityGrade.weak:
        return 'ضعيف';
      case AuthenticityGrade.unverified:
        return 'قيد التحقق';
      case AuthenticityGrade.rejected:
        return 'متروك أو لا أصل له';
    }
  }

  bool get isApprovedForDisplay =>
      this == AuthenticityGrade.authenticated ||
      this == AuthenticityGrade.acceptedWithNote ||
      this == AuthenticityGrade.disputed;
}
