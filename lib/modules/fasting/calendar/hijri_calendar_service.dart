import '../../../core/time/clock.dart';
import '../domain/hijri_date.dart';
import '../domain/ramadan_confidence.dart';

/// Pure, deterministic service for Islamic Hijri calendar calculations and conversions (§7, §8, §9).
class HijriCalendarService {
  final Clock _clock;

  const HijriCalendarService({Clock? clock}) : _clock = clock ?? const SystemClock();

  /// Converts a Gregorian [DateTime] to an Islamic [HijriDate] with optional [offsetDays].
  HijriDate getHijriDate(DateTime date, {int offsetDays = 0}) {
    final jd = _gregorianToJulianDay(date.year, date.month, date.day);
    return _julianDayToHijri(jd, offsetDays: offsetDays);
  }

  /// Converts current clock date to [HijriDate].
  HijriDate getTodayHijri({int offsetDays = 0}) {
    return getHijriDate(_clock.nowUtc(), offsetDays: offsetDays);
  }

  /// Checks if given Gregorian date falls within the Holy month of Ramadan.
  bool isRamadan(DateTime date, {int offsetDays = 0}) {
    final hDate = getHijriDate(date, offsetDays: offsetDays);
    return hDate.month == 9;
  }

  /// Returns the Ramadan day number (1..30) if the date is in Ramadan, or null otherwise.
  int? getRamadanDayNumber(DateTime date, {int offsetDays = 0}) {
    final hDate = getHijriDate(date, offsetDays: offsetDays);
    return hDate.month == 9 ? hDate.day : null;
  }

  /// Returns the number of days in a specific Hijri month (29 or 30).
  int getDaysInHijriMonth(int year, int month) {
    if (month < 1 || month > 12) return 30;
    // Odd months have 30 days, even months have 29 days, except 12th month in leap years
    if (month % 2 == 1) return 30;
    if (month == 12 && _isHijriLeapYear(year)) return 30;
    return 29;
  }

  /// Returns the confidence level in Ramadan boundary determination.
  RamadanConfidence getRamadanConfidence({bool hasOfficialDeclaration = false, int offsetDays = 0}) {
    if (hasOfficialDeclaration) return RamadanConfidence.confirmed;
    if (offsetDays != 0) return RamadanConfidence.userConfigured;
    return RamadanConfidence.estimated;
  }

  bool _isHijriLeapYear(int year) {
    final remainder = (11 * year + 14) % 30;
    return remainder < 11;
  }

  int _gregorianToJulianDay(int year, int month, int day) {
    var y = year;
    var m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + day + b - 1524;
  }

  HijriDate _julianDayToHijri(int jd, {int offsetDays = 0}) {
    final adjustedJd = jd + offsetDays;
    final l = adjustedJd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final l1 = l - 10631 * n + 354;
    final j = (((10985 - l1) / 5316).floor()) * (((50 * l1) / 17719).floor()) +
        ((l1 / 5670).floor()) * (((43 * l1) / 15238).floor());
    final l2 = l1 - (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
        ((j / 16).floor()) * (((15238 * j) / 43).floor()) + 29;
    final m = ((24 * l2) / 709).floor();
    final d = l2 - ((709 * m) / 24).floor();
    final y = 30 * n + j - 30;

    final validM = m.clamp(1, 12);
    final validD = d.clamp(1, 30);
    return HijriDate(year: y, month: validM, day: validD);
  }
}
