import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/time/clock.dart';
import '../domain/prayer_schedule.dart';
import '../domain/prayer_type.dart';

/// Scheduled reminder item for prayer times.
class ScheduledPrayerNotification {
  final String id;
  final PrayerType prayerType;
  final DateTime scheduledTime;
  final String title;
  final String body;

  const ScheduledPrayerNotification({
    required this.id,
    required this.prayerType,
    required this.scheduledTime,
    required this.title,
    required this.body,
  });
}

/// Service managing the scheduling and cancellation of prayer reminders and notifications (§17).
class PrayerNotificationService {
  final Clock _clock;
  final EventBus? _eventBus;
  final AppLogger? _logger;
  final List<ScheduledPrayerNotification> _activeSchedules = [];

  PrayerNotificationService({
    Clock? clock,
    EventBus? eventBus,
    AppLogger? logger,
  })  : _clock = clock ?? const SystemClock(),
        _eventBus = eventBus,
        _logger = logger;

  List<ScheduledPrayerNotification> get activeSchedules => List.unmodifiable(_activeSchedules);

  /// Builds scheduled notifications for the five obligatory daily prayers from a [PrayerSchedule].
  Result<List<ScheduledPrayerNotification>, Failure> scheduleDailyPrayers({
    required PrayerSchedule schedule,
    DateTime? now,
  }) {
    _activeSchedules.clear();
    final current = now ?? _clock.nowLocal();

    for (final entry in schedule.obligatoryPrayers) {
      if (entry.time.isAfter(current)) {
        final item = ScheduledPrayerNotification(
          id: 'notif_${schedule.date.year}_${schedule.date.month}_${schedule.date.day}_${entry.type.name}',
          prayerType: entry.type,
          scheduledTime: entry.time,
          title: 'حان الآن وقت صلاة ${entry.type.nameArabic}',
          body: 'أقبل على صلاتك وذكر ربك',
        );
        _activeSchedules.add(item);
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
