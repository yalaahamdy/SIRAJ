import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: App / Device Restart Restoration Suite (§30, §104, §106)', () {
    test('Restart 1: Restores notification preferences from persistent local storage (§30, §104)', () async {
      final storage = MemoryStorageRegistry();
      final mod1 = CompanionModule(storageRegistry: storage);

      await mod1.savePreferences(const CompanionPreferences(
        enableQuietHours: true,
        quietHoursStartHour: 23,
        quietHoursEndHour: 5,
      ));

      // Simulate App Restart with new instance sharing storage
      final mod2 = CompanionModule(storageRegistry: storage);
      final restored = (await mod2.getPreferences()).valueOrNull!;

      expect(restored.enableQuietHours, true);
      expect(restored.quietHoursStartHour, 23);
      expect(restored.quietHoursEndHour, 5);
    });
  });
}
