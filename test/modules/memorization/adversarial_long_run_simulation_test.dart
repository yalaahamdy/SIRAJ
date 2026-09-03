import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('M3 Adversarial 365-Day Long-Run Simulations (§10, §11, §23)', () {
    late MemoryStorageRegistry storage;
    late TestClock clock;
    late ReadOnlyCanonicalQuranStore quranStore;
    late MemorizationModule module;

    setUp(() async {
      storage = MemoryStorageRegistry();
      clock = TestClock(DateTime.utc(2026, 1, 1, 8, 0));
      quranStore = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(package);

      module = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranStore,
        customClock: clock,
      );
      await module.initialize();
    });

    test('Simulation A: Perfect User over 365 days achieves stable mastery with capped intervals', () async {
      await module.savePlan(
        MemorizationPlan(
          id: 'plan_sim_a',
          title: 'خطة المستخدم المثالي',
          targetSurahs: const [1],
          startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
          endAyah: const AyahKey(surahNumber: 1, ayahNumber: 7),
          dailyNewAyahs: 2,
          dailyReviewTarget: 10,
          createdAt: clock.nowUtc(),
        ),
      );

      for (var day = 0; day < 365; day++) {
        final sessionRes = await module.getOrCreateTodaySession();
        expect(sessionRes.isSuccess, isTrue);
        var session = sessionRes.valueOrNull!;

        final queue = [...session.weakAyahs, ...session.reviewAyahs, ...session.newAyahs];
        for (final key in queue) {
          session = (await module.submitReview(
            session: session,
            ayahKey: key,
            quality: ReviewQuality.good,
          )).valueOrNull!;
        }

        // Advance 1 day
        clock.advance(const Duration(days: 1));
      }

      final items = (await module.getAllItems()).valueOrNull!;
      expect(items.isNotEmpty, isTrue);

      for (final item in items) {
        expect(item.intervalDays, lessThanOrEqualTo(365));
        expect(item.masteryScore, greaterThanOrEqualTo(90.0));
        expect(item.state == MemorizationState.memorized || item.state == MemorizationState.mastered, isTrue);
      }
    });

    test('Simulation B: Inconsistent User (3 days on, 4 days off) does not experience scheduler collapse', () async {
      await module.savePlan(
        MemorizationPlan(
          id: 'plan_sim_b',
          title: 'خطة غير منتظمة',
          targetSurahs: const [1],
          startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
          endAyah: const AyahKey(surahNumber: 1, ayahNumber: 7),
          dailyNewAyahs: 2,
          dailyReviewTarget: 15,
          createdAt: clock.nowUtc(),
        ),
      );

      for (var week = 0; week < 20; week++) {
        // 3 days active
        for (var d = 0; d < 3; d++) {
          final session = (await module.getOrCreateTodaySession()).valueOrNull!;
          final queue = [...session.weakAyahs, ...session.reviewAyahs, ...session.newAyahs];
          var s = session;
          for (final k in queue) {
            s = (await module.submitReview(session: s, ayahKey: k, quality: ReviewQuality.good)).valueOrNull!;
          }
          clock.advance(const Duration(days: 1));
        }

        // 4 days skipped
        clock.advance(const Duration(days: 4));
      }

      final sessionAfterBreak = (await module.getOrCreateTodaySession()).valueOrNull!;
      // Review count must be capped by dailyReviewTarget (15) preventing backlog explosion
      expect(sessionAfterBreak.reviewAyahs.length, lessThanOrEqualTo(15));
    });

    test('Simulation C: Long Break User (30 days study, 180 days break, returns)', () async {
      await module.savePlan(
        MemorizationPlan(
          id: 'plan_sim_c',
          title: 'خطة الانقطاع الطويل',
          targetSurahs: const [1],
          startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
          endAyah: const AyahKey(surahNumber: 1, ayahNumber: 7),
          dailyNewAyahs: 2,
          dailyReviewTarget: 20,
          createdAt: clock.nowUtc(),
        ),
      );

      // Study for 30 days
      for (var d = 0; d < 30; d++) {
        final session = (await module.getOrCreateTodaySession()).valueOrNull!;
        final queue = [...session.weakAyahs, ...session.reviewAyahs, ...session.newAyahs];
        var s = session;
        for (final k in queue) {
          s = (await module.submitReview(session: s, ayahKey: k, quality: ReviewQuality.good)).valueOrNull!;
        }
        clock.advance(const Duration(days: 1));
      }

      // 180 days break
      clock.advance(const Duration(days: 180));

      // User returns
      final returnSession = (await module.getOrCreateTodaySession()).valueOrNull!;
      expect(returnSession.reviewAyahs.isNotEmpty, isTrue);

      // User reviews with Hard/Again
      var s = returnSession;
      for (final k in returnSession.reviewAyahs) {
        s = (await module.submitReview(session: s, ayahKey: k, quality: ReviewQuality.again)).valueOrNull!;
      }

      final itemsAfterReturn = (await module.getAllItems()).valueOrNull!;
      for (final i in itemsAfterReturn) {
        expect(i.intervalDays, greaterThanOrEqualTo(1));
        expect(i.lapses, greaterThanOrEqualTo(1));
      }
    });
  });
}
