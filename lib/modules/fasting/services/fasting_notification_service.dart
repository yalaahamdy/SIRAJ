import '../../../core/time/clock.dart';
import '../domain/fasting_schedule_day.dart';

/// Notification descriptor for fasting events.
class FastingNotificationPayload {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;

  const FastingNotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
  });
}

/// Service for generating neutral, deterministic notifications for fasting events (§19, §20).
class FastingNotificationService {
  final Clock _clock;

  const FastingNotificationService({
    Clock? clock,
    dynamic eventBus,
  }) : _clock = clock ?? const SystemClock();

  /// Generates the Suhoor reminder notification before Fajr / Imsak.
  FastingNotificationPayload? createSuhoorReminder({
    required FastingScheduleDay schedule,
    int minutesBefore = 45,
  }) {
    final triggerTime = schedule.suhoorImsakTime.subtract(Duration(minutes: minutesBefore));
    if (triggerTime.isBefore(_clock.nowUtc())) return null;

    return FastingNotificationPayload(
      id: 'suhoor_${schedule.date.toIso8601String().substring(0, 10)}',
      title: 'تنبيه السحور',
      body: 'حان موعد الاستعداد للسحور قبل دخول وقت الإمساك والفجر.',
      scheduledTime: triggerTime,
    );
  }

  /// Generates the Iftar notification aligned with Maghrib.
  FastingNotificationPayload? createIftarReminder({
    required FastingScheduleDay schedule,
  }) {
    if (schedule.fastEndTime.isBefore(_clock.nowUtc())) return null;

    return FastingNotificationPayload(
      id: 'iftar_${schedule.date.toIso8601String().substring(0, 10)}',
      title: 'موعد الإفطار',
      body: 'حان الآن موعد أذان المغرب وإتمام صيام اليوم، تقبل الله طاعتكم.',
      scheduledTime: schedule.fastEndTime,
    );
  }
}
