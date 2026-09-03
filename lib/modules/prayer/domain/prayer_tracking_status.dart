/// Status of a specific prayer log entry.
enum PrayerTrackingStatus {
  notRecorded,
  prayed,
  missed,
  excused,
}

extension PrayerTrackingStatusX on PrayerTrackingStatus {
  String get nameArabic {
    switch (this) {
      case PrayerTrackingStatus.notRecorded:
        return 'لم تُسجل';
      case PrayerTrackingStatus.prayed:
        return 'تمت الصلاة';
      case PrayerTrackingStatus.missed:
        return 'فاتت';
      case PrayerTrackingStatus.excused:
        return 'عذر';
    }
  }
}
