import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/companion_reminder.dart';
import 'package:siraj/modules/companion/engine/reminder_orchestrator.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: M40 Notifications Adversarial & Privacy Shield Suite (§106..§113)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Adversarial 1: Deterministic Plan Assertion (§108) — Same schedule + preferences yields identical reminder plan', () async {
      final now = DateTime(2026, 9, 1, 10, 0);
      final r1 = (await companionModule.getReminders(currentTime: now)).valueOrNull!;
      final r2 = (await companionModule.getReminders(currentTime: now)).valueOrNull!;

      expect(r1.length, equals(r2.length));
      for (int i = 0; i < r1.length; i++) {
        expect(r1[i].reminderId, equals(r2[i].reminderId));
        expect(r1[i].scheduledTime, equals(r2[i].scheduledTime));
      }
    });

    test('Adversarial 2: Privacy Shield Assertion (§110) — Zero piety score and zero shame in reminders', () async {
      final reminders = (await companionModule.getReminders()).valueOrNull!;

      for (final r in reminders) {
        expect(r.titleArabic.contains('مستوى إيمان'), false);
        expect(r.messageArabic.contains('عقوبة'), false);
        expect(r.messageArabic.contains('تقصير'), false);
      }
    });

    test('Adversarial 3: Quiet Hours Bypass Shield (§107) — Low/medium reminders strictly blocked in quiet window', () {
      const orchestrator = ReminderOrchestrator();
      const prefs = CompanionPreferences(
        enableQuietHours: true,
        quietHoursStartHour: 23,
        quietHoursEndHour: 5,
      );

      final raw = List.generate(
        100,
        (i) => CompanionReminder(
          reminderId: 'rem_$i',
          sourceModule: 'adhkar',
          titleArabic: 'تذكير $i',
          messageArabic: 'نص $i',
          scheduledTime: DateTime(2026, 9, 1, 23, 30),
          priority: i % 2 == 0 ? ReminderPriority.low : ReminderPriority.medium,
        ),
      );

      final result = orchestrator.processReminders(
        rawReminders: raw,
        preferences: prefs,
        currentTime: DateTime(2026, 9, 1, 23, 45),
      );

      expect(result.isEmpty, true);
    });
  });
}
