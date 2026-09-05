import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/time/clock.dart';
import '../domain/prayer_notification_settings.dart';
import '../domain/prayer_schedule.dart';
import '../domain/prayer_type.dart';

/// Scheduled reminder item for prayer times (§17, §32).
class ScheduledPrayerNotification {
  final String id;
  final PrayerType prayerType;
  final DateTime scheduledTime;
  final String title;
  final String body;
  final PrayerNotificationMode mode;
  final String soundOptionId;
  final bool isPreAthan;
  final bool isIqama;

  const ScheduledPrayerNotification({
    required this.id,
    required this.prayerType,
    required this.scheduledTime,
    required this.title,
    required this.body,
    this.mode = PrayerNotificationMode.fullAthan,
    this.soundOptionId = 'abdulbasit',
    this.isPreAthan = false,
    this.isIqama = false,
  });
}

/// Service managing the scheduling and cancellation of prayer reminders and notifications (§17, §32).
class PrayerNotificationService {
  final Clock _clock;
  final EventBus? _eventBus;
  final AppLogger? _logger;
  PrayerNotificationSettings _settings;
  final List<ScheduledPrayerNotification> _activeSchedules = [];

  PrayerNotificationService({
    Clock? clock,
    EventBus? eventBus,
    AppLogger? logger,
    PrayerNotificationSettings? initialSettings,
  })  : _clock = clock ?? const SystemClock(),
        _eventBus = eventBus,
        _logger = logger,
        _settings = initialSettings ?? PrayerNotificationSettings.defaultSettings();

  List<ScheduledPrayerNotification> get activeSchedules => List.unmodifiable(_activeSchedules);
  PrayerNotificationSettings get settings => _settings;

  /// Updates current notification settings.
  void updateSettings(PrayerNotificationSettings newSettings) {
    _settings = newSettings;
    _logger?.info('Prayer notification settings updated.');
  }

  /// Builds scheduled notifications for the five obligatory daily prayers from a [PrayerSchedule].
  Result<List<ScheduledPrayerNotification>, Failure> scheduleDailyPrayers({
    required PrayerSchedule schedule,
    DateTime? now,
    PrayerNotificationSettings? customSettings,
  }) {
    _activeSchedules.clear();
    final current = now ?? _clock.nowLocal();
    final effectiveSettings = customSettings ?? _settings;

    for (final entry in schedule.obligatoryPrayers) {
      final perPrayer = effectiveSettings.getSettingFor(entry.type);

      // Skip disabled prayers
      if (perPrayer.mode == PrayerNotificationMode.disabled) continue;

      // 1. Pre-Athan Reminder (if configured and in the future)
      if (perPrayer.preAthanMinutes > 0) {
        final preTime = entry.time.subtract(Duration(minutes: perPrayer.preAthanMinutes));
        if (preTime.isAfter(current)) {
          _activeSchedules.add(
            ScheduledPrayerNotification(
              id: 'pre_${schedule.date.year}_${schedule.date.month}_${schedule.date.day}_${entry.type.name}',
              prayerType: entry.type,
              scheduledTime: preTime,
              title: 'اقترب وقت صلاة ${entry.type.nameArabic}',
              body: 'بقي ${perPrayer.preAthanMinutes} دقيقة على دخول الوقت',
              mode: PrayerNotificationMode.notificationOnly,
              isPreAthan: true,
            ),
          );
        }
      }

      // 2. Main Athan / Prayer Entered Notification
      if (entry.time.isAfter(current)) {
        final item = ScheduledPrayerNotification(
          id: 'notif_${schedule.date.year}_${schedule.date.month}_${schedule.date.day}_${entry.type.name}',
          prayerType: entry.type,
          scheduledTime: entry.time,
          title: 'حان الآن وقت صلاة ${entry.type.nameArabic}',
          body: 'أقبل على صلاتك وذكر ربك',
          mode: perPrayer.mode,
          soundOptionId: perPrayer.soundOptionId,
        );
        _activeSchedules.add(item);
      }

      // 3. Iqama Reminder (if configured and in the future)
      if (perPrayer.iqamaMinutes > 0) {
        final iqamaTime = entry.time.add(Duration(minutes: perPrayer.iqamaMinutes));
        if (iqamaTime.isAfter(current)) {
          _activeSchedules.add(
            ScheduledPrayerNotification(
              id: 'iqama_${schedule.date.year}_${schedule.date.month}_${schedule.date.day}_${entry.type.name}',
              prayerType: entry.type,
              scheduledTime: iqamaTime,
              title: 'حان وقت إقامة صلاة ${entry.type.nameArabic}',
              body: 'استعد للصلاة بخشوع وإقبال',
              mode: PrayerNotificationMode.notificationOnly,
              isIqama: true,
            ),
          );
        }
      }
    }

    _logger?.info('Scheduled ${_activeSchedules.length} prayer notifications for ${schedule.date}');
    return Result.ok(_activeSchedules);
  }

  /// Cancels all scheduled reminders.
  void cancelAll() {
    _activeSchedules.clear();
    _logger?.info('Cancelled all prayer notifications.');
  }

  /// Triggers standard in-process prayer entered event when prayer moment is reached.
  void triggerPrayerEntered(PrayerType type, DateTime time) {
    _eventBus?.publish(
      PrayerTimeEnteredEvent(
        prayerName: type.name,
        time: time,
      ),
    );
  }
}
