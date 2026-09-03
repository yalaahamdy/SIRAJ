import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/location/location_models.dart';
import '../../../core/storage/storage_contract.dart';
import '../../../core/time/clock.dart';
import '../contracts/prayer_contract.dart';
import 'domain/calculation_parameters.dart';
import 'domain/prayer_adjustments.dart';
import 'domain/prayer_schedule.dart';
import 'domain/qibla_result.dart';
import 'engine/astronomical_calculator.dart';
import 'engine/prayer_calculation_engine.dart';
import 'services/prayer_countdown_service.dart';
import 'services/prayer_notification_service.dart';
import 'services/prayer_schedule_service.dart';
import 'services/prayer_tracker_service.dart';
import 'services/qibla_service.dart';
import 'services/user_calibration_service.dart';

/// Unified Module Facade for the Prayer subsystem (L2).
/// Implements [PrayerModuleContract] and encapsulates all prayer services.
class PrayerModule implements PrayerModuleContract {
  final Clock clock;
  final PrayerScheduleService scheduleService;
  final PrayerCountdownService countdownService;
  final QiblaService qiblaService;
  final PrayerTrackerService trackerService;
  final UserCalibrationService calibrationService;
  final PrayerNotificationService notificationService;

  PrayerModule({
    required StorageRegistry storageRegistry,
    PrayerCalculationEngine? engine,
    Clock? clock,
    EventBus? eventBus,
  })  : clock = clock ?? const SystemClock(),
        scheduleService = PrayerScheduleService(
          engine: engine ?? const AstronomicalPrayerCalculator(),
          clock: clock,
          eventBus: eventBus,
        ),
        countdownService = PrayerCountdownService(
          scheduleService: PrayerScheduleService(
            engine: engine ?? const AstronomicalPrayerCalculator(),
            clock: clock,
            eventBus: eventBus,
          ),
          clock: clock,
        ),
        qiblaService = const QiblaService(),
        trackerService = PrayerTrackerService(
          storageRegistry: storageRegistry,
          clock: clock,
          eventBus: eventBus,
        ),
        calibrationService = UserCalibrationService(
          storageRegistry: storageRegistry,
        ),
        notificationService = PrayerNotificationService(
          clock: clock,
          eventBus: eventBus,
        );

  @override
  Future<Result<Map<String, DateTime>, Failure>> getPrayerTimes({
    required GeoCoordinates location,
    required DateTime date,
    required String calculationMethod,
  }) async {
    final adjRes = await calibrationService.getAdjustments();
    final adjustments = adjRes.valueOrNull ?? PrayerAdjustments.zero;

    // Resolve matching profile preset or default to MWL for raw contract
    CalculationParameters params;
    switch (calculationMethod) {
      case 'Egyptian':
        params = CalculationParameters.egyptian;
        break;
      case 'UmmAlQura':
        params = CalculationParameters.ummAlQura;
        break;
      case 'Karachi':
        params = CalculationParameters.karachi;
        break;
      case 'ISNA':
        params = CalculationParameters.isna;
        break;
      default:
        params = CalculationParameters.muslimWorldLeague;
        break;
    }

    final scheduleRes = scheduleService.getSchedule(
      date: date,
      location: location,
      parameters: params,
      adjustments: adjustments,
    );

    if (scheduleRes.isFailure) {
      return Result.err(scheduleRes.failureOrNull!);
    }

    final schedule = scheduleRes.valueOrNull!;
    final map = <String, DateTime>{};
    for (final entry in schedule.entries.entries) {
      map[entry.key.name] = entry.value.time;
    }

    return Result.ok(map);
  }

  @override
  Future<Result<double, Failure>> getQiblaDirection(GeoCoordinates location) async {
    final res = qiblaService.calculateQibla(location);
    if (res.isFailure) return Result.err(res.failureOrNull!);
    return Result.ok(res.valueOrNull!.directionDegrees);
  }

  /// Calculates a full typed [PrayerSchedule].
  Future<Result<PrayerSchedule, Failure>> getSchedule({
    required DateTime date,
    required GeoCoordinates location,
    required CalculationParameters parameters,
    Duration? timezoneOffset,
    PrayerAdjustments? adjustments,
  }) async {
    final adj = adjustments ?? (await calibrationService.getAdjustments()).valueOrNull ?? PrayerAdjustments.zero;

    return scheduleService.getSchedule(
      date: date,
      location: location,
      parameters: parameters,
      timezoneOffset: timezoneOffset,
      adjustments: adj,
    );
  }

  /// Calculates Qibla direction with distance.
  Result<QiblaResult, Failure> getQibla(GeoCoordinates location) {
    return qiblaService.calculateQibla(location);
  }
}
