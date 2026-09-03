import 'package:equatable/equatable.dart';

/// Abstract Clock interface.
/// Allows pure, deterministic testing without reliance on system time.
abstract class Clock {
  const Clock();

  /// Returns the current DateTime in UTC.
  DateTime nowUtc();

  /// Returns the current DateTime in local timezone.
  DateTime nowLocal();

  /// Returns current UTC timestamp in milliseconds.
  int nowMillisecondsSinceEpoch() => nowUtc().millisecondsSinceEpoch;
}

/// Standard system clock using actual system time.
class SystemClock extends Clock {
  const SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();

  @override
  DateTime nowLocal() => DateTime.now();
}

/// Settable and advanceable clock designed specifically for deterministic unit & golden tests.
class TestClock extends Clock {
  DateTime _currentUtc;

  TestClock(DateTime initialTime) : _currentUtc = initialTime.toUtc();

  /// Sets clock to specific DateTime.
  void setTime(DateTime time) {
    _currentUtc = time.toUtc();
  }

  /// Advances the clock by a given duration.
  void advance(Duration duration) {
    _currentUtc = _currentUtc.add(duration);
  }

  /// Rewinds the clock by a given duration.
  void rewind(Duration duration) {
    _currentUtc = _currentUtc.subtract(duration);
  }

  @override
  DateTime nowUtc() => _currentUtc;

  @override
  DateTime nowLocal() => _currentUtc.toLocal();
}

/// Time utility for timezone and day boundary calculations.
class TimeUtils {
  /// Checks if two DateTimes represent the same local calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Calculates start of day in UTC for a given DateTime.
  static DateTime startOfDayUtc(DateTime date) {
    final utc = date.toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day);
  }

  /// Calculates end of day in UTC for a given DateTime.
  static DateTime endOfDayUtc(DateTime date) {
    final utc = date.toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day, 23, 59, 59, 999);
  }
}

/// Safe time of day model (hour, minute, second).
class SafeTimeOfDay extends Equatable {
  final int hour;
  final int minute;
  final int second;

  const SafeTimeOfDay({
    required this.hour,
    required this.minute,
    this.second = 0,
  })  : assert(hour >= 0 && hour < 24, 'Hour must be between 0 and 23'),
        assert(minute >= 0 && minute < 60, 'Minute must be between 0 and 59'),
        assert(second >= 0 && second < 60, 'Second must be between 0 and 59');

  @override
  List<Object?> get props => [hour, minute, second];

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
}
