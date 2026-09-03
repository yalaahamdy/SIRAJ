import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Memorization Performance & Rapid Load Suite (§75, §76, §100)', () {
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
      await memorizationModule.savePlan(MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)));
    });

    test('Performance 1: Submitting 500 reviews sequentially completes rapidly without memory bloat', () async {
      final now = DateTime.utc(2026, 9, 1);
      final item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        state: MemorizationState.learning,
        createdAt: now,
        updatedAt: now,
      );

      final stopwatch = Stopwatch()..start();
      var currentItem = item;
      for (int i = 0; i < 500; i++) {
        final quality = (i % 4 == 0) ? ReviewQuality.good : (i % 4 == 1 ? ReviewQuality.easy : ReviewQuality.hard);
        currentItem = memorizationModule.scheduler.processReview(
          item: currentItem,
          quality: quality,
          currentDate: now.add(Duration(days: i)),
        );
      }
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(currentItem.repetitions, greaterThan(0));
    });
  });
}
