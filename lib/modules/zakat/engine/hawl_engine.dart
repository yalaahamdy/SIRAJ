import '../../../core/time/clock.dart';

/// Pure engine for tracking Hawl duration and maturity dates (§12).
class HawlEngine {
  final Clock _clock;

  const HawlEngine({Clock? clock}) : _clock = clock ?? const SystemClock();

  /// Total days in standard lunar Hijri year vs solar Gregorian year.
  static const int daysInHijriYear = 354;
  static const int daysInGregorianYear = 365;

  DateTime calculateHawlDueDate({
    required DateTime startDate,
    bool isHijri = true,
  }) {
    final days = isHijri ? daysInHijriYear : daysInGregorianYear;
    return startDate.add(Duration(days: days));
  }

  int calculateDaysRemaining({
    required DateTime startDate,
    DateTime? currentTime,
    bool isHijri = true,
  }) {
    final now = currentTime ?? _clock.nowUtc();
    final dueDate = calculateHawlDueDate(startDate: startDate, isHijri: isHijri);
    final diff = dueDate.difference(now).inDays;
    return diff < 0 ? 0 : diff;
  }

  bool isHawlCompleted({
    required DateTime startDate,
    DateTime? currentTime,
    bool isHijri = true,
  }) {
    final now = currentTime ?? _clock.nowUtc();
    final dueDate = calculateHawlDueDate(startDate: startDate, isHijri: isHijri);
    return !now.isBefore(dueDate);
  }

  double calculateHawlProgress({
    required DateTime startDate,
    DateTime? currentTime,
    bool isHijri = true,
  }) {
    final now = currentTime ?? _clock.nowUtc();
    final totalDays = isHijri ? daysInHijriYear : daysInGregorianYear;
    final elapsedDays = now.difference(startDate).inDays;
    if (elapsedDays <= 0) return 0.0;
    if (elapsedDays >= totalDays) return 1.0;
    return (elapsedDays / totalDays).clamp(0.0, 1.0);
  }
}
