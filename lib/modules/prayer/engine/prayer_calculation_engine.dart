import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/location/location_models.dart';
import '../domain/calculation_parameters.dart';
import '../domain/prayer_adjustments.dart';
import '../domain/prayer_schedule.dart';

/// Abstract contract for prayer time calculation engines.
/// Decoupled from UI and downstream modules to allow multiple verifiable calculation providers.
abstract class PrayerCalculationEngine {
  /// Calculates the complete daily prayer schedule for a specific date and coordinates.
  Result<PrayerSchedule, Failure> calculateSchedule({
    required DateTime date,
    required GeoCoordinates location,
    required CalculationParameters parameters,
    Duration? timezoneOffset,
    PrayerAdjustments adjustments = PrayerAdjustments.zero,
  });
}
