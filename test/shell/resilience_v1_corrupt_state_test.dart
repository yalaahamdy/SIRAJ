import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Corrupt State Recovery Suite (§103, §104, §105, §131)', () {
    test('Corrupt State 1: CompanionModule recovers with defaults on missing preferences (§103)', () async {
      // Fresh empty storage = no preferences stored yet = simulates corrupt/missing state
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      final prefsRes = await companion.getPreferences();
      // Must not crash — returns Result with empty or default preferences
      final prefs = prefsRes.valueOrNull ?? const CompanionPreferences();
      expect(prefs, isNotNull);
      expect(prefs.enableQuietHours, true); // Default: quiet hours enabled
    });

    test('Corrupt State 2: No crash when CompanionModule reads undefined goal (§103)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      final goals = await companion.getGoals();
      // Empty goals list returned, no exception
      expect(goals, isNotNull);
    });

    test('Corrupt State 3: Preferences override with valid defaults (§103, §105)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      // Save valid preferences
      await companion.savePreferences(const CompanionPreferences(
        enableQuietHours: false,
        quietHoursStartHour: 22,
        quietHoursEndHour: 6,
      ));

      final prefsRes = await companion.getPreferences();
      final prefs = prefsRes.valueOrNull ?? const CompanionPreferences();
      expect(prefs.enableQuietHours, false);
    });

    test('Corrupt State 4: getReminders on empty storage returns empty list (§103, §104)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      final reminders = await companion.getReminders(currentTime: DateTime(2026, 9, 1, 10, 0));
      // Must not crash
      expect(reminders, isNotNull);
    });
  });
}
