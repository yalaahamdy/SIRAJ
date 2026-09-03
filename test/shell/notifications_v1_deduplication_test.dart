import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/companion_reminder.dart';
import 'package:siraj/modules/companion/engine/reminder_orchestrator.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Notification Deduplication Suite (§22..§24, §106, §109)', () {
    test('Deduplication 1: Identical reminder keys from multiple triggers are collapsed to a single notification (§22, §109)', () {
      const orchestrator = ReminderOrchestrator();
      const prefs = CompanionPreferences(enableQuietHours: false);

      final raw = [
        CompanionReminder(
          reminderId: 'rem_1',
          sourceModule: 'adhkar',
          titleArabic: 'أذكار الصباح',
          messageArabic: 'أذكار الصباح',
          scheduledTime: DateTime(2026, 9, 1, 6, 30),
          priority: ReminderPriority.medium,
        ),
        CompanionReminder(
          reminderId: 'rem_2',
          sourceModule: 'adhkar',
          titleArabic: 'أذكار الصباح',
          messageArabic: 'أذكار الصباح',
          scheduledTime: DateTime(2026, 9, 1, 6, 30),
          priority: ReminderPriority.medium,
        ),
      ];

      final processed = orchestrator.processReminders(
        rawReminders: raw,
        preferences: prefs,
        currentTime: DateTime(2026, 9, 1, 6, 0),
      );

      expect(processed.length, 1);
    });
  });
}
