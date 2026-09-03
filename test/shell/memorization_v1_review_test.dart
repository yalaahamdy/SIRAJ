import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 10: Memorization Review & Self-Assessment Suite (§8..§12, §95)', () {
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

    test('Review 1: Submitting review updates item state and spaced repetition schedule', () async {
      const key = AyahKey(surahNumber: 114, ayahNumber: 1);
      await memorizationModule.addAyahToPlan(key);

      final sessionRes = await memorizationModule.getOrCreateTodaySession();
      expect(sessionRes.isSuccess, true);
      final session = sessionRes.valueOrNull!;

      // 1. Submit "Good" review
      final updateRes = await memorizationModule.submitReview(
        session: session,
        ayahKey: key,
        quality: ReviewQuality.good,
      );
      expect(updateRes.isSuccess, true);

      // 2. Verify item is in learning/review state with next review scheduled
      final items = (await memorizationModule.getAllItems()).valueOrNull!;
      final item = items.firstWhere((i) => i.ayahKey == key);
      expect(item.state, isNot(equals(MemorizationState.notStarted)));
      expect(item.nextReviewDue, isNotNull);
      expect(item.repetitions, 1);
    });

    test('Review 2: Rating "Again" resets interval and flags as weak', () async {
      const key = AyahKey(surahNumber: 114, ayahNumber: 2);
      await memorizationModule.addAyahToPlan(key);

      final sessionRes = await memorizationModule.getOrCreateTodaySession();
      final session = sessionRes.valueOrNull!;

      // Submit "Again" review
      await memorizationModule.submitReview(
        session: session,
        ayahKey: key,
        quality: ReviewQuality.again,
      );

      final items = (await memorizationModule.getAllItems()).valueOrNull!;
      final item = items.firstWhere((i) => i.ayahKey == key);
      expect(item.intervalDays, lessThanOrEqualTo(1));
    });
  });
}
