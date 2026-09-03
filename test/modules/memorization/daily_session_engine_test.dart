import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Daily Session Engine Lifecycle Tests (§17, §18)', () {
    late MemoryStorageRegistry storage;
    late TestClock clock;
    late ReadOnlyCanonicalQuranStore quranStore;
    late MemorizationModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      clock = TestClock(DateTime.utc(2026, 8, 31, 10, 0));
      quranStore = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(package);

      module = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranStore,
        customClock: clock,
      );
    });

    test('Prepares daily session with new items from plan and due reviews', () async {
      await module.initialize();
      // Setup custom plan for Surah Al-Fatihah (7 ayahs) with daily new = 3
      final plan = MemorizationPlan(
        id: 'plan_fatihah',
        title: 'حفظ سورة الفاتحة',
        targetSurahs: const [1],
        startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
        endAyah: const AyahKey(surahNumber: 1, ayahNumber: 7),
        dailyNewAyahs: 3,
        dailyReviewTarget: 10,
        createdAt: clock.nowUtc(),
      );
      await module.savePlan(plan);

      final sessionRes = await module.getOrCreateTodaySession();
      expect(sessionRes.isSuccess, isTrue);

      final session = sessionRes.valueOrNull!;
      expect(session.newAyahs.length, equals(3));
      expect(session.newAyahs[0], equals(const AyahKey(surahNumber: 1, ayahNumber: 1)));
      expect(session.newAyahs[1], equals(const AyahKey(surahNumber: 1, ayahNumber: 2)));
      expect(session.newAyahs[2], equals(const AyahKey(surahNumber: 1, ayahNumber: 3)));
      expect(session.isCompleted, isFalse);
    });

    test('Executes session: Submitting all items marks session completed and increments streak', () async {
      await module.initialize();
      final plan = MemorizationPlan(
        id: 'plan_test',
        title: 'خطة سريعة',
        targetSurahs: const [1],
        startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
        endAyah: const AyahKey(surahNumber: 1, ayahNumber: 2),
        dailyNewAyahs: 2,
        dailyReviewTarget: 10,
        createdAt: clock.nowUtc(),
      );
      await module.savePlan(plan);

      var session = (await module.getOrCreateTodaySession()).valueOrNull!;
      expect(session.totalItemsCount, equals(2));

      // Review Ayah 1
      session = (await module.submitReview(
        session: session,
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        quality: ReviewQuality.good,
      )).valueOrNull!;
      expect(session.isCompleted, isFalse);

      // Review Ayah 2
      session = (await module.submitReview(
        session: session,
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 2),
        quality: ReviewQuality.easy,
      )).valueOrNull!;
      expect(session.isCompleted, isTrue);

      final streak = await module.getConsistencyStreak();
      expect(streak.valueOrNull, equals(1));
    });
  });
}
