import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/location/location_models.dart';
import '../../../core/storage/storage_contract.dart';
import '../../../core/time/clock.dart';
import '../prayer/domain/calculation_parameters.dart';
import '../prayer/prayer_module.dart';
import 'calendar/hijri_calendar_service.dart';
import 'domain/fasting_day_record.dart';
import 'domain/fasting_policy.dart';
import 'domain/fasting_record_snapshot.dart';
import 'domain/fasting_schedule_day.dart';
import 'domain/fasting_status.dart';
import 'domain/fasting_type.dart';
import 'domain/qada_plan.dart';
import 'services/fasting_notification_service.dart';
import 'services/fasting_schedule_service.dart';
import 'services/qada_planner_service.dart';
import 'store/fasting_user_data_store.dart';

/// Unified Facade for the Fasting & Ramadan subsystem (L2).
class FastingModule {
  final PrayerModule prayerModule;
  final HijriCalendarService calendarService;
  final FastingScheduleService scheduleService;
  final QadaPlannerService qadaPlannerService;
  final FastingNotificationService notificationService;
  final FastingUserDataStore userDataStore;
  final Clock clock;

  FastingModule({
    required StorageRegistry storageRegistry,
    required this.prayerModule,
    Clock? clock,
    EventBus? eventBus,
  })  : clock = clock ?? const SystemClock(),
        calendarService = HijriCalendarService(clock: clock),
        scheduleService = FastingScheduleService(
          prayerModule: prayerModule,
          calendarService: HijriCalendarService(clock: clock),
          clock: clock,
        ),
        qadaPlannerService = QadaPlannerService(clock: clock),
        notificationService = FastingNotificationService(clock: clock, eventBus: eventBus),
        userDataStore = FastingUserDataStore(storageRegistry: storageRegistry);

  /// Retrieves the active fasting policy.
  Future<FastingPolicy> getActivePolicy() async {
    final polIdRes = await userDataStore.getSelectedPolicyId();
    final polId = polIdRes.valueOrNull;
    if (polId == FastingPolicy.precautionaryImsak.policyId) {
      return FastingPolicy.precautionaryImsak;
    }
    return FastingPolicy.standard;
  }

  /// Sets the active fasting policy.
  Future<Result<void, Failure>> setActivePolicy(String policyId) async {
    return userDataStore.setSelectedPolicyId(policyId);
  }

  /// Retrieves the computed fasting schedule for today.
  Future<Result<FastingScheduleDay, Failure>> getTodaySchedule({
    required GeoCoordinates location,
    required CalculationParameters calculationParameters,
    Duration? timezoneOffset,
  }) async {
    final policy = await getActivePolicy();
    final offsetRes = await userDataStore.getCalendarOffsetDays();
    final offset = offsetRes.valueOrNull ?? 0;

    return scheduleService.getFastingSchedule(
      date: clock.nowUtc(),
      location: location,
      calculationParameters: calculationParameters,
      policy: policy,
      calendarOffsetDays: offset,
      timezoneOffset: timezoneOffset,
    );
  }

  /// Marks today's fasting status.
  Future<Result<void, Failure>> markTodayStatus({
    required FastingType type,
    required FastingStatus status,
    String? note,
  }) async {
    final now = clock.nowUtc();
    final offsetRes = await userDataStore.getCalendarOffsetDays();
    final offset = offsetRes.valueOrNull ?? 0;
    final hijri = calendarService.getHijriDate(now, offsetDays: offset);

    final record = FastingDayRecord(
      recordId: 'fast_${now.toIso8601String().substring(0, 10)}',
      date: DateTime.utc(now.year, now.month, now.day),
      hijriDate: hijri,
      type: type,
      status: status,
      note: note,
      createdAt: now,
    );

    final saveRes = await userDataStore.saveDayRecord(record);
    if (saveRes.isFailure) return saveRes;

    // If marked fasted and type is Qada, increment completed days
    if (type == FastingType.qada && status == FastingStatus.fasted) {
      await incrementQadaCompleted();
    }

    return Result.ok(null);
  }

  /// Retrieves all recorded fasting days.
  Future<Result<List<FastingDayRecord>, Failure>> getDayRecords() async {
    return userDataStore.getDayRecords();
  }

  /// Retrieves user's Qada plan.
  Future<Result<QadaPlan, Failure>> getQadaPlan() async {
    return userDataStore.getQadaPlan();
  }

  /// Updates or sets user's Qada plan.
  Future<Result<void, Failure>> updateQadaPlan(QadaPlan plan) async {
    return userDataStore.saveQadaPlan(plan);
  }

  /// Increments completed Qada days by 1.
  Future<Result<void, Failure>> incrementQadaCompleted() async {
    final planRes = await getQadaPlan();
    if (planRes.isFailure) return planRes;
    final current = planRes.valueOrNull!;
    final updated = current.copyWith(
      completedDays: current.completedDays + 1,
      updatedAt: clock.nowUtc(),
    );
    return updateQadaPlan(updated);
  }

  /// Saves a verifiable historical audit snapshot.
  Future<Result<FastingRecordSnapshot, Failure>> saveSnapshot() async {
    final recordsRes = await getDayRecords();
    if (recordsRes.isFailure) return Result.err(recordsRes.failureOrNull!);

    final planRes = await getQadaPlan();
    final plan = planRes.valueOrNull;

    final policy = await getActivePolicy();
    final now = clock.nowUtc();
    final snapId = 'snap_fast_${now.millisecondsSinceEpoch}';

    final snapshot = FastingRecordSnapshot.create(
      snapshotId: snapId,
      records: recordsRes.valueOrNull!,
      qadaPlan: plan,
      policy: policy,
      createdAt: now,
    );

    final saveRes = await userDataStore.saveSnapshot(snapshot);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(snapshot);
  }

  /// Retrieves historical snapshots.
  Future<Result<List<FastingRecordSnapshot>, Failure>> getSnapshots() async {
    return userDataStore.getSnapshots();
  }

  /// Resets all fasting user data.
  Future<Result<void, Failure>> resetAllUserData() async {
    return userDataStore.resetAllUserData();
  }
}
