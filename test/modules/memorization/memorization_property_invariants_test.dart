import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/scheduler/spaced_repetition_scheduler.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

void main() {
  group('L2 Memorization Mathematical Property Tests (§32)', () {
    const scheduler = SpacedRepetitionScheduler();
    final now = DateTime.utc(2026, 8, 31, 12, 0);

    test('Property 1: Review interval is strictly positive (>= 1 day) across all inputs', () {
      final qualities = ReviewQuality.values;
      final testIntervals = [0, 1, 2, 5, 10, 30, 90, 365];

      for (final q in qualities) {
        for (final interval in testIntervals) {
          final item = MemorizationItem(
            ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
            intervalDays: interval,
            createdAt: now,
            updatedAt: now,
          );

          final result = scheduler.processReview(item: item, quality: q, currentDate: now);
          expect(result.intervalDays, greaterThanOrEqualTo(1));
        }
      }
    });

    test('Property 2: Ease factor never drops below 1.3 minimum cognitive bound', () {
      var item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        easeFactor: 1.3,
        createdAt: now,
        updatedAt: now,
      );

      // Repeat 10 failures (Again)
      for (var i = 0; i < 10; i++) {
        item = scheduler.processReview(item: item, quality: ReviewQuality.again, currentDate: now);
        expect(item.easeFactor, greaterThanOrEqualTo(1.3));
      }
    });

    test('Property 3: Mastery score is strictly bounded within [0.0, 100.0]', () {
      final testItems = [
        MemorizationItem(ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1), intervalDays: 0, createdAt: now, updatedAt: now),
        MemorizationItem(ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1), intervalDays: 1000, repetitions: 50, createdAt: now, updatedAt: now),
      ];

      for (final item in testItems) {
        for (final q in ReviewQuality.values) {
          final res = scheduler.processReview(item: item, quality: q, currentDate: now);
          expect(res.masteryScore, greaterThanOrEqualTo(0.0));
          expect(res.masteryScore, lessThanOrEqualTo(100.0));
        }
      }
    });

    test('Property 4: Failed review (Again) never increases mastery score', () {
      final item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        state: MemorizationState.memorized,
        repetitions: 5,
        intervalDays: 20,
        masteryScore: 75.0,
        createdAt: now,
        updatedAt: now,
      );

      final failed = scheduler.processReview(item: item, quality: ReviewQuality.again, currentDate: now);
      expect(failed.masteryScore, lessThan(item.masteryScore));
    });
  });
}
