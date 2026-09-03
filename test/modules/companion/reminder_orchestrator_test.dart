import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/companion_reminder.dart';
import 'package:siraj/modules/companion/engine/reminder_orchestrator.dart';

void main() {
  group('L2 Reminder Orchestrator & Deduplication Tests (§27, §28, §29)', () {
    const orchestrator = ReminderOrchestrator();

    test('Deduplicates duplicate reminders originating from same module with identical title', () {
      final now = DateTime(2026, 8, 31, 10, 0);
      final raw = [
        CompanionReminder(
          reminderId: 'rem_1',
          sourceModule: 'prayer',
          titleArabic: 'صلاة الظهر',
          messageArabic: 'حان وقت الصلاة',
          scheduledTime: now,
          priority: ReminderPriority.high,
        ),
        CompanionReminder(
          reminderId: 'rem_2',
          sourceModule: 'prayer',
          titleArabic: 'صلاة الظهر', // Duplicate title and module
          messageArabic: 'حان وقت الصلاة (تكرار)',
          scheduledTime: now,
          priority: ReminderPriority.high,
        ),
      ];

      final processed = orchestrator.processReminders(
        rawReminders: raw,
        preferences: const CompanionPreferences(),
        currentTime: now,
      );

      expect(processed.length, equals(1));
      expect(processed.first.reminderId, equals('rem_1'));
    });

    test('Suppresses low and medium priority reminders during Quiet Hours (11 PM to 5 AM)', () {
      final nightTime = DateTime(2026, 8, 31, 23, 30); // 11:30 PM (Quiet hour)
      final raw = [
        CompanionReminder(
          reminderId: 'rem_prayer_fajr',
          sourceModule: 'prayer',
          titleArabic: 'صلاة الفجر',
          messageArabic: 'حان وقت الصلاة',
          scheduledTime: nightTime,
          priority: ReminderPriority.high,
        ),
        CompanionReminder(
          reminderId: 'rem_reading',
          sourceModule: 'quran',
          titleArabic: 'متابعة القراءة',
          messageArabic: 'وقت القراءة',
          scheduledTime: nightTime,
          priority: ReminderPriority.medium, // Should be suppressed
        ),
      ];

      final processed = orchestrator.processReminders(
        rawReminders: raw,
        preferences: const CompanionPreferences(enableQuietHours: true),
        currentTime: nightTime,
      );

      expect(processed.length, equals(1));
      expect(processed.first.reminderId, equals('rem_prayer_fajr'));
    });
  });
}
