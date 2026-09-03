/// Self-reported recall quality rating given by the user during review.
enum ReviewQuality {
  again,
  hard,
  good,
  easy;

  int get score {
    switch (this) {
      case ReviewQuality.again:
        return 1;
      case ReviewQuality.hard:
        return 2;
      case ReviewQuality.good:
        return 3;
      case ReviewQuality.easy:
        return 4;
    }
  }

  String get labelArabic {
    switch (this) {
      case ReviewQuality.again:
        return 'إعادة';
      case ReviewQuality.hard:
        return 'صعب';
      case ReviewQuality.good:
        return 'جيد';
      case ReviewQuality.easy:
        return 'سهل';
    }
  }
}
