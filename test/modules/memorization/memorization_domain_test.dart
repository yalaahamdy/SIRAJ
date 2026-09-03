import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/mistake_record.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/domain/review_result.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

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
  });
}
