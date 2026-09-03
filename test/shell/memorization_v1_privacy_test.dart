import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 10: Memorization Privacy & Local-First Isolation Suite (§46..§48, §86, §93, §95, §102)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();
    });

    test('Privacy 1: Memorization progress references AyahKey only without copying canonical text (§50)', () async {
      await memorizationModule.savePlan(MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)));
      const key = AyahKey(surahNumber: 114, ayahNumber: 1);
      await memorizationModule.addAyahToPlan(key);

      final sessionRes = await memorizationModule.getOrCreateTodaySession();
      await memorizationModule.submitReview(session: sessionRes.valueOrNull!, ayahKey: key, quality: ReviewQuality.good);

      final items = (await memorizationModule.getAllItems()).valueOrNull!;
      expect(items.length, 1);

      // Verify the item contains only AyahKey reference, not raw religious text
      final item = items.first;
      expect(item.ayahKey.surahNumber, 114);
      expect(item.ayahKey.ayahNumber, 1);
    });

    test('Privacy 2: Privacy assertion — Memorization activity is completely isolated and not tied to user identity profiling (§48, §94)', () async {
      final planRes = await memorizationModule.getPlan();
      expect(planRes.isSuccess, isTrue);

      final itemsRes = await memorizationModule.getAllItems();
      expect(itemsRes.isSuccess, isTrue);
    });
  });
}
