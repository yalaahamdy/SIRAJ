import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Notification Localization & RTL Alignment Suite (§78, §79, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Localization 1: Reminders render cleanly in Arabic (§78, §79)', () async {
      final reminders = (await companionModule.getReminders()).valueOrNull!;

      for (final r in reminders) {
        expect(r.titleArabic.isNotEmpty, true);
        expect(r.priority.labelArabic.isNotEmpty, true);
      }
    });
  });
}
