import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/memorization/scheduler/spaced_repetition_scheduler.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 10: Memorization Scheduler & Queue Suite (§32..§35, §95, §100)', () {
    const scheduler = SpacedRepetitionScheduler();
    final fixedClock = DateTime.utc(2026, 9, 1, 12, 0);

    test('Scheduler 1: Golden Determinism (Same Inputs + Same State + Same Clock = Same Next Review)', () {
      final itemA = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 2, ayahNumber: 255),
        state: MemorizationState.learning,
        repetitions: 2,
        intervalDays: 4,
        easeFactor: 2.5,
        createdAt: fixedClock,
        updatedAt: fixedClock,
      );

      final itemB = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 2, ayahNumber: 255),
        state: MemorizationState.learning,
        repetitions: 2,
        intervalDays: 4,
        easeFactor: 2.5,
        createdAt: fixedClock,
        updatedAt: fixedClock,
      );

      final nextA = scheduler.processReview(item: itemA, quality: ReviewQuality.good, currentDate: fixedClock);
      final nextB = scheduler.processReview(item: itemB, quality: ReviewQuality.good, currentDate: fixedClock);

      expect(nextA.intervalDays, equals(nextB.intervalDays));
      expect(nextA.nextReviewDue, equals(nextB.nextReviewDue));
      expect(nextA.easeFactor, equals(nextB.easeFactor));
      expect(nextA.state, equals(nextB.state));
    });

    test('Scheduler 2: Scheduler Isolation (§35, §98) — Memorization does NOT alter Learning Revision Scheduler', () async {
      final storage = MemoryStorageRegistry();
      final quranMod = QuranModule(storageRegistry: storage);
      quranMod.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      final memMod = MemorizationModule(storageRegistry: storage, quranStore: quranMod.store);
      final learnMod = LearningModule(storageRegistry: storage);
      learnMod.mountPackage(SyntheticLearningFixtures.createPackage());

      // Perform memorization reviews
      await memMod.initialize();
      final pathsBefore = learnMod.getAllPaths().valueOrNull!;

      const key = AyahKey(surahNumber: 1, ayahNumber: 1);
      await memMod.addAyahToPlan(key);
      final sessionRes = await memMod.getOrCreateTodaySession();
      await memMod.submitReview(session: sessionRes.valueOrNull!, ayahKey: key, quality: ReviewQuality.easy);

      final pathsAfter = learnMod.getAllPaths().valueOrNull!;
      expect(pathsAfter.length, equals(pathsBefore.length));
    });
  });
}
