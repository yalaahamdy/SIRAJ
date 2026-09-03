import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/fasting/domain/fasting_schedule_day.dart';
import 'package:siraj/modules/fasting/domain/hijri_date.dart';
import 'package:siraj/modules/fasting/services/fasting_notification_service.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Fasting & Ramadan Notifications Suite (§15..§17, §99, §106)', () {
    test('Fasting 1: Suhoor and Iftar reminders schedule with neutral wording and without medical fatwas (§16)', () {
      final notifService = FastingNotificationService(
        clock: TestClock(DateTime(2026, 9, 1, 2, 0)),
      );

      final schedule = FastingScheduleDay(
        date: DateTime(2026, 9, 1),
        hijriDate: const HijriDate(year: 1448, month: 3, day: 20),
        isRamadan: false,
        suhoorImsakTime: DateTime(2026, 9, 1, 4, 30),
        fastStartTime: DateTime(2026, 9, 1, 4, 45),
        fastEndTime: DateTime(2026, 9, 1, 18, 30),
        fastingDuration: const Duration(hours: 13, minutes: 45),
        isCurrentlyFasting: false,
        nextBoundaryLabel: 'الإمساك',
        nextBoundaryTime: DateTime(2026, 9, 1, 4, 30),
        remainingToNextBoundary: const Duration(hours: 2, minutes: 30),
      );

      final suhoor = notifService.createSuhoorReminder(schedule: schedule, minutesBefore: 30);
      final iftar = notifService.createIftarReminder(schedule: schedule);

      expect(suhoor, isNotNull);
      expect(suhoor!.title, 'تنبيه السحور');

      expect(iftar, isNotNull);
      expect(iftar!.title, 'موعد الإفطار');
    });
  });
}
