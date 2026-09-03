import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Midnight Rollover Notification Regeneration Suite (§34, §61, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Midnight 1: Crossing 00:00:00 regenerates fresh reminders for the new day (§34, §61)', () async {
      final remBefore = (await companionModule.getReminders(
        currentTime: DateTime(2026, 9, 1, 23, 59, 59),
      )).valueOrNull!;

      final remAfter = (await companionModule.getReminders(
        currentTime: DateTime(2026, 9, 2, 0, 0, 1),
      )).valueOrNull!;

      expect(remBefore.isNotEmpty, true);
      expect(remAfter.isNotEmpty, true);
      expect(remAfter.first.scheduledTime.day, 2);
    });
  });
}
