import 'package:equatable/equatable.dart';

/// Immutable domain model representing a Hijri Calendar date.
class HijriDate extends Equatable {
  final int year;
  final int month;
  final int day;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
  })  : assert(month >= 1 && month <= 12, 'Hijri month must be 1..12'),
        assert(day >= 1 && day <= 30, 'Hijri day must be 1..30');

  /// Arabic month names
  static const List<String> monthNamesArabic = [
    'المحرّم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوّال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  String get monthName => monthNamesArabic[month - 1];

  String formatArabic() => '$day $monthName $year هـ';

  @override
  List<Object?> get props => [year, month, day];

  @override
  String toString() => 'HijriDate($year-$month-$day)';
}

/// Abstract contract for Hijri Date conversions.
/// Allows injecting standard astronomical / Umm al-Qura algorithms once confirmed via ADR/OPEN-06.
abstract class HijriCalendarConverter {
  /// Converts a Gregorian DateTime into a HijriDate with an optional day adjustment offset (-2..+2).
  HijriDate fromGregorian(DateTime gregorian, {int adjustmentDays = 0});

  /// Converts a HijriDate back into a Gregorian DateTime.
  DateTime toGregorian(HijriDate hijri);

  /// Returns the length of the specified Hijri month (29 or 30 days).
  int getMonthLength(int year, int month);
}

/// A standard tabular / algorithmic converter used as the baseline default.
/// Implements standard arithmetic approximation for calendar math before external canonical tables.
class TabularHijriConverter implements HijriCalendarConverter {
  const TabularHijriConverter();

  @override
  HijriDate fromGregorian(DateTime gregorian, {int adjustmentDays = 0}) {
    final adjusted = gregorian.add(Duration(days: adjustmentDays));
    final jd = _gregorianToJulianDay(adjusted.year, adjusted.month, adjusted.day);
    return _julianDayToHijri(jd);
  }

  @override
  DateTime toGregorian(HijriDate hijri) {
    final jd = _hijriToJulianDay(hijri.year, hijri.month, hijri.day);
    return _julianDayToGregorian(jd);
  }

  @override
  int getMonthLength(int year, int month) {
    if (month % 2 == 1) return 30;
    if (month == 12 && _isHijriLeapYear(year)) return 30;
    return 29;
  }

  static bool _isHijriLeapYear(int year) {
    // 30-year cycle leap years: 2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29
    const leapYearsInCycle = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29];
    final remainder = year % 30;
    return leapYearsInCycle.contains(remainder);
  }

  static int _gregorianToJulianDay(int year, int month, int day) {
    int y = year;
    int m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + day + b - 1524;
  }

  static HijriDate _julianDayToHijri(int jd) {
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final l1 = l - 10631 * n + 354;
    final j = ((10985 - l1) / 5316).floor() * ((50 * l1) / 17719).floor() +
        ((l1 / 5670).floor()) * ((43 * l1) / 15238).floor();
    final l2 = l1 -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    final month = ((24 * l2) / 709).floor();
    final day = l2 - ((709 * month) / 24).floor();
    final year = 30 * n + j - 30;
    return HijriDate(year: year, month: month, day: day);
  }

  static int _hijriToJulianDay(int year, int month, int day) {
    return ((11 * year + 3) / 30).floor() +
        354 * year +
        30 * month -
        ((month - 1) / 2).floor() +
        day +
        1948440 -
        385;
  }

  static DateTime _julianDayToGregorian(int jd) {
    final z = jd + 0.5;
    final w = ((z - 1867216.25) / 36524.25).floor();
    final x = (w / 4).floor();
    final a = z + 1 + w - x;
    final b = a + 1524;
    final c = ((b - 122.1) / 365.25).floor();
    final d = (365.25 * c).floor();
    final e = ((b - d) / 30.6001).floor();
    final day = (b - d - (30.6001 * e).floor()).floor();
    final month = e < 14 ? e - 1 : e - 13;
    final year = month > 2 ? c - 4716 : c - 4715;
    return DateTime.utc(year, month, day);
  }
}
