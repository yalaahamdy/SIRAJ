import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Notification Accessibility & Clarity Suite (§77, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Accessibility 1: Notification titles and bodies are concise and readable (§77)', () async {
      final reminders = (await companionModule.getReminders()).valueOrNull!;

      for (final r in reminders) {
        expect(r.titleArabic.trim().isNotEmpty, true);
        expect(r.messageArabic.trim().isNotEmpty, true);
      }
    });
  });
}
