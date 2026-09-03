import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Payload Minimization & Secret Shield Suite (§88..§90, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Payload Minimization 1: Reminders contain only compact, safe IDs and display strings (§89, §90)', () async {
      final reminders = (await companionModule.getReminders()).valueOrNull!;

      for (final r in reminders) {
        expect(r.reminderId.length, lessThan(100));
        expect(r.titleArabic.length, lessThan(100));
        expect(r.messageArabic.length, lessThan(200));
      }
    });
  });
}
