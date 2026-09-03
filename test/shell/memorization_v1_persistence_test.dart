import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Memorization Local Persistence Suite (§40, §42, §100)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());
    });

    test('Persistence 1: Saved plan and items persist and reload cleanly in a fresh module instance', () async {
      final module1 = MemorizationModule(storageRegistry: storage, quranStore: quranModule.store);
      await module1.initialize();
      await module1.savePlan(MemorizationPlan(
        id: 'custom_plan_1',
        title: 'خطة الحفظ التجريبية',
        targetSurahs: const [1],
        startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
        endAyah: const AyahKey(surahNumber: 1, ayahNumber: 7),
        dailyNewAyahs: 7,
        dailyReviewTarget: 25,
        createdAt: DateTime.utc(2026, 9, 1),
      ));
      await module1.addAyahToPlan(const AyahKey(surahNumber: 1, ayahNumber: 1));

      // Simulate app restart with a new module instance over same storage
      final module2 = MemorizationModule(storageRegistry: storage, quranStore: quranModule.store);
      await module2.initialize();

      final planRes = await module2.getPlan();
      expect(planRes.valueOrNull?.title, equals('خطة الحفظ التجريبية'));
      expect(planRes.valueOrNull?.dailyNewAyahs, equals(7));

      final itemsRes = await module2.getAllItems();
      expect(itemsRes.valueOrNull?.length, equals(1));
      expect(itemsRes.valueOrNull?.first.ayahKey, equals(const AyahKey(surahNumber: 1, ayahNumber: 1)));
    });
  });
}
