import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Quran Memorization Notifications Suite (§13, §14, §98, §106)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
        memorizationModule: memorizationModule,
      );
    });

    test('Memorization 1: Review notifications preserve privacy without exposing mistake counts or weak verses (§14)', () async {
      final reminders = (await companionModule.getReminders(
        currentTime: DateTime(2026, 9, 1, 14, 0),
      )).valueOrNull!;

      for (final r in reminders) {
        expect(r.messageArabic.contains('خطأ'), false);
        expect(r.messageArabic.contains('ضعيف'), false);
      }
    });
  });
}
