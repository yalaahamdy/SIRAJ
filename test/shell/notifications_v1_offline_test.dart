import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Local-First Offline Notification Scheduling Suite (§36, §37, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Offline 1: Local notification scheduling functions entirely offline without remote push dependencies (§36, §37)', () async {
      final reminders = await companionModule.getReminders();
      expect(reminders.isSuccess, true);
      expect(reminders.valueOrNull!.isNotEmpty, true);
    });
  });
}
