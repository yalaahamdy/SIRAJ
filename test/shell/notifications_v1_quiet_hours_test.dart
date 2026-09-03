import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/companion_reminder.dart';
import 'package:siraj/modules/companion/engine/reminder_orchestrator.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Quiet Hours Orchestration Suite (§20, §21, §101, §106)', () {
    test('Quiet Hours 1: Suppresses non-critical reminders during user-defined quiet hours (§20, §21)', () {
      const orchestrator = ReminderOrchestrator();
      const prefs = CompanionPreferences(
        enableQuietHours: true,
        quietHoursStartHour: 22,
        quietHoursEndHour: 6,
      );

      final raw = [
        CompanionReminder(
          reminderId: 'rem_reading',
          sourceModule: 'quran',
          titleArabic: 'تلاوة الورد',
          messageArabic: 'تلاوة الورد القرآني',
          scheduledTime: DateTime(2026, 9, 1, 23, 0),
          priority: ReminderPriority.medium,
        ),
        CompanionReminder(
          reminderId: 'rem_fajr',
          sourceModule: 'prayer',
          titleArabic: 'صلاة الفجر',
          messageArabic: 'حان وقت صلاة الفجر',
          scheduledTime: DateTime(2026, 9, 1, 5, 0),
          priority: ReminderPriority.high,
        ),
      ];

      final processed = orchestrator.processReminders(
        rawReminders: raw,
        preferences: prefs,
        currentTime: DateTime(2026, 9, 1, 23, 30),
      );

      // Only high priority allowed in quiet hours
      expect(processed.every((r) => r.priority == ReminderPriority.high), true);
    });
  });
}
