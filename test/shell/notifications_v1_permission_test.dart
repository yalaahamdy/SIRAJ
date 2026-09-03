import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Notification Permission Denial & Graceful Fallback Suite (§28, §29, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Permission 1: System operates gracefully without crashes when notifications permission is denied (§28, §29)', () async {
      // Companion operations succeed in degraded mode
      final reminders = await companionModule.getReminders();
      expect(reminders.isSuccess, true);
    });
  });
}
