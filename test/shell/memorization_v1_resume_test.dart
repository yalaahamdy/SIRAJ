import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Memorization Session Interruption & Resume Suite (§41, §88..§90, §100)', () {
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
      await memorizationModule.addAyahToPlan(const AyahKey(surahNumber: 1, ayahNumber: 1));
      await memorizationModule.addAyahToPlan(const AyahKey(surahNumber: 1, ayahNumber: 2));
    });

    test('Resume 1: Partially completed session resumes from the first unfinished Ayah', () async {
      final session1 = (await memorizationModule.getOrCreateTodaySession()).valueOrNull!;
      expect(session1.results.isEmpty, isTrue);

      // Complete 1 review
      final session2 = (await memorizationModule.submitReview(
        session: session1,
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        quality: ReviewQuality.good,
      )).valueOrNull!;

      expect(session2.results.length, equals(1));
      expect(session2.isCompleted, isFalse);

      // Re-fetch today's session (simulating restart / return to dashboard)
      final sessionResumed = (await memorizationModule.getOrCreateTodaySession()).valueOrNull!;
      expect(sessionResumed.results.length, equals(1));
      expect(sessionResumed.results.first.ayahKey, equals(const AyahKey(surahNumber: 1, ayahNumber: 1)));
    });
  });
}
