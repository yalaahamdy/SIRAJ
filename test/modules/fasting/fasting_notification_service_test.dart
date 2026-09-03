import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/fasting/domain/fasting_schedule_day.dart';
import 'package:siraj/modules/fasting/domain/hijri_date.dart';
import 'package:siraj/modules/fasting/services/fasting_notification_service.dart';

void main() {
  group('L2 FastingNotificationService Neutral Reminder Tests (§19, §20)', () {
    final fixedNow = DateTime.utc(2026, 8, 31, 3, 0, 0); // 03:00 AM
    final testClock = TestClock(fixedNow);
    final service = FastingNotificationService(clock: testClock);

    final schedule = FastingScheduleDay(
      date: DateTime.utc(2026, 8, 31),
      hijriDate: const HijriDate(year: 1448, month: 3, day: 19),
      isRamadan: false,
      suhoorImsakTime: DateTime.utc(2026, 8, 31, 4, 30, 0),
      fastStartTime: DateTime.utc(2026, 8, 31, 4, 30, 0),
      fastEndTime: DateTime.utc(2026, 8, 31, 18, 30, 0),
      fastingDuration: const Duration(hours: 14),
      isCurrentlyFasting: false,
      nextBoundaryLabel: 'أذان الفجر',
      nextBoundaryTime: DateTime.utc(2026, 8, 31, 4, 30, 0),
      remainingToNextBoundary: const Duration(hours: 1, minutes: 30),
    );

    test('Generates Suhoor reminder accurately (45 min before Suhoor/Fajr)', () {
      final payload = service.createSuhoorReminder(schedule: schedule, minutesBefore: 45);
      expect(payload, isNotNull);
      expect(payload!.title, equals('تنبيه السحور'));
      expect(payload.scheduledTime, equals(DateTime.utc(2026, 8, 31, 3, 45, 0)));
      expect(payload.body.contains('حان موعد الاستعداد للسحور'), isTrue);
    });

    test('Generates Iftar reminder at exact Maghrib time', () {
      final payload = service.createIftarReminder(schedule: schedule);
      expect(payload, isNotNull);
      expect(payload!.title, equals('موعد الإفطار'));
      expect(payload.scheduledTime, equals(schedule.fastEndTime));
      expect(payload.body.contains('حان الآن موعد أذان المغرب'), isTrue);
    });
  });
}
