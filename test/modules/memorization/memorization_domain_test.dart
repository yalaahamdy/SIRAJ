import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/mistake_record.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/domain/review_result.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Memorization Domain Models & Lifecycle Tests (§4, §5, §6)', () {
    final now = DateTime.utc(2026, 8, 31, 12, 0);

    test('MemorizationItem creation and copyWith invariants', () {
      final key = const AyahKey(surahNumber: 1, ayahNumber: 1);
      final item = MemorizationItem(
        ayahKey: key,
        state: MemorizationState.learning,
        createdAt: now,
        updatedAt: now,
      );

      expect(item.ayahKey, equals(key));
      expect(item.state, equals(MemorizationState.learning));
      expect(item.easeFactor, equals(2.5));
      expect(item.intervalDays, equals(0));
      expect(item.masteryScore, equals(0.0));

      final updated = item.copyWith(
        state: MemorizationState.memorized,
        repetitions: 3,
        intervalDays: 14,
        masteryScore: 85.0,
      );

      expect(updated.state, equals(MemorizationState.memorized));
      expect(updated.repetitions, equals(3));
      expect(updated.intervalDays, equals(14));
      expect(updated.masteryScore, equals(85.0));
      expect(updated.ayahKey, equals(key));
    });

    test('MemorizationItem isDue calculates due dates correctly', () {
      final key = const AyahKey(surahNumber: 114, ayahNumber: 1);
      final item = MemorizationItem(
        ayahKey: key,
        state: MemorizationState.memorized,
        nextReviewDue: DateTime.utc(2026, 9, 1),
        createdAt: now,
        updatedAt: now,
      );

      // On 2026-08-31 -> not due yet
      expect(item.isDue(DateTime.utc(2026, 8, 31)), isFalse);

      // On 2026-09-01 -> due today
      expect(item.isDue(DateTime.utc(2026, 9, 1)), isTrue);

      // On 2026-09-02 -> overdue
      expect(item.isDue(DateTime.utc(2026, 9, 2)), isTrue);
    });

    test('ReviewResult serializes and deserializes without data loss', () {
      final result = ReviewResult(
        ayahKey: const AyahKey(surahNumber: 112, ayahNumber: 1),
        quality: ReviewQuality.good,
        scheduledIntervalDays: 4,
        timeTakenMs: 3200,
        mistake: MistakeRecord(
          ayahKey: const AyahKey(surahNumber: 112, ayahNumber: 1),
          category: MistakeCategory.stoppedEarly,
          note: 'تردد في بداية الآية',
          recordedAt: now,
        ),
        reviewedAt: now,
      );

      final map = result.toMap();
      final parsed = ReviewResult.fromMap(map);

      expect(parsed.ayahKey, equals(result.ayahKey));
      expect(parsed.quality, equals(ReviewQuality.good));
      expect(parsed.scheduledIntervalDays, equals(4));
      expect(parsed.mistake?.category, equals(MistakeCategory.stoppedEarly));
      expect(parsed.isSuccessful, isTrue);
    });

    test('MemorizationPlan creates default Juz Amma plan', () {
      final plan = MemorizationPlan.createDefaultJuzAmma(now);
      expect(plan.id, equals('plan_juz_amma'));
      expect(plan.targetSurahs.length, equals(37)); // Surahs 78 to 114
      expect(plan.startAyah, equals(const AyahKey(surahNumber: 78, ayahNumber: 1)));
      expect(plan.endAyah, equals(const AyahKey(surahNumber: 114, ayahNumber: 6)));
      expect(plan.dailyNewAyahs, equals(5));
      expect(plan.isActive, isTrue);
    });

    test('getTodayWirdAyahs auto-includes remaining <= 3 ayahs of final surah to complete it', () async {
      final storage = MemoryStorageRegistry();
      final quranModule = QuranModule(storageRegistry: storage);
      quranModule.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      final memModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memModule.initialize();

      // Surah 113 has 5 ayahs, Surah 114 has 6 ayahs
      final plan = MemorizationPlan(
        id: 'test_plan_falaq_nas',
        title: 'خطة الفلق والناس',
        targetSurahs: const [113, 114],
        startAyah: const AyahKey(surahNumber: 113, ayahNumber: 1),
        endAyah: const AyahKey(surahNumber: 114, ayahNumber: 6),
        dailyNewAyahs: 5,
        createdAt: now,
      );

      // Case 1: Target = 3 ayahs. 2 remain in Surah 113 (<= 3).
      // Auto-inclusion triggers -> Returns 5 ayahs (completes Surah 113).
      final wird3 = await memModule.getTodayWirdAyahs(plan, customTargetAyahs: 3);
      expect(wird3.isSuccess, isTrue);
      expect(wird3.valueOrNull!.length, equals(5));
      expect(wird3.valueOrNull!.every((a) => a.surahNumber == 113), isTrue);

      // Case 2: Target = 6 ayahs. Takes 5 from Surah 113 + 1 from Surah 114.
      // 5 remain in Surah 114 (> 3). Auto-inclusion does NOT trigger -> Returns 6 ayahs.
      final wird6 = await memModule.getTodayWirdAyahs(plan, customTargetAyahs: 6);
      expect(wird6.isSuccess, isTrue);
      expect(wird6.valueOrNull!.length, equals(6));
      expect(wird6.valueOrNull!.where((a) => a.surahNumber == 113).length, equals(5));
      expect(wird6.valueOrNull!.where((a) => a.surahNumber == 114).length, equals(1));

      // Case 3: Target = 8 ayahs. Takes 5 from Surah 113 + 3 from Surah 114.
      // 3 remain in Surah 114 (<= 3). Auto-inclusion triggers -> Returns 11 ayahs (completes both surahs).
      final wird8 = await memModule.getTodayWirdAyahs(plan, customTargetAyahs: 8);
      expect(wird8.isSuccess, isTrue);
      expect(wird8.valueOrNull!.length, equals(11));
    });
  });
}
