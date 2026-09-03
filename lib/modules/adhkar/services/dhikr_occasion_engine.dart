import '../../../core/time/clock.dart';
import '../domain/dhikr_occasion.dart';

/// Data-driven context and time resolution engine for Remembrance occasions (§14, §15).
class DhikrOccasionEngine {
  final Clock _clock;

  const DhikrOccasionEngine({Clock? clock}) : _clock = clock ?? const SystemClock();

  /// Resolves the primary active occasion based on injected clock time in UTC.
  DhikrOccasion resolveCurrentOccasion({DateTime? customTime}) {
    final now = customTime ?? _clock.nowUtc();
    final hour = now.hour;

    // Morning: 04:00 - 11:59
    if (hour >= 4 && hour < 12) {
      return DhikrOccasion.morning;
    }
    // Midday / After Prayer: 12:00 - 14:59
    if (hour >= 12 && hour < 15) {
      return DhikrOccasion.afterPrayer;
    }
    // Evening: 15:00 - 20:59
    if (hour >= 15 && hour < 21) {
      return DhikrOccasion.evening;
    }
    // Night / Sleep: 21:00 - 03:59
    return DhikrOccasion.sleep;
  }

  /// Returns recommended order of occasions for the daily home feed.
  List<DhikrOccasion> getDailyOccasionsOrder({DateTime? customTime}) {
    final current = resolveCurrentOccasion(customTime: customTime);
    final all = List<DhikrOccasion>.from(DhikrOccasion.values);
    all.remove(current);
    return [current, ...all];
  }
}
