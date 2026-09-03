import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/scheduler/spaced_repetition_scheduler.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

void main() {
  group('L2 Spaced Repetition Scheduler Mathematical Tests (§6, §7, §30)', () {
    const scheduler = SpacedRepetitionScheduler();
    final baseDate = DateTime.utc(2026, 8, 31, 10, 0);
    const testKey = AyahKey(surahNumber: 1, ayahNumber: 1);

    test('Initial Recall: Easy ratings give higher starting interval and memorized state', () {
      final initialItem = MemorizationItem(
        ayahKey: testKey,
        state: MemorizationState.notStarted,
        createdAt: baseDate,
        updatedAt: baseDate,
      );

      final easyResult = scheduler.processReview(
        item: initialItem,
        quality: ReviewQuality.easy,
        currentDate: baseDate,
      );

      expect(easyResult.intervalDays, equals(5));
      expect(easyResult.state, equals(MemorizationState.memorized));
      expect(easyResult.repetitions, equals(1));
      expect(easyResult.nextReviewDue, equals(DateTime.utc(2026, 9, 5)));
    });

    test('Progression: Successive Good reviews compound intervals deterministically', () {
      var item = MemorizationItem(
        ayahKey: testKey,
        state: MemorizationState.notStarted,
        createdAt: baseDate,
        updatedAt: baseDate,
      );

      // Review 1: Good -> Interval 3
      item = scheduler.processReview(item: item, quality: ReviewQuality.good, currentDate: baseDate);
      expect(item.intervalDays, equals(3));
      expect(item.repetitions, equals(1));

      // Review 2: Good -> Interval = 3 * 2.5 = 7
      item = scheduler.processReview(item: item, quality: ReviewQuality.good, currentDate: DateTime.utc(2026, 9, 3));
      expect(item.intervalDays, equals(7));
      expect(item.repetitions, equals(2));

      // Review 3: Good -> Interval = 7 * 2.5 = 17
      item = scheduler.processReview(item: item, quality: ReviewQuality.good, currentDate: DateTime.utc(2026, 9, 10));
      expect(item.intervalDays, equals(17));
      expect(item.repetitions, equals(3));

      // Review 4: Good -> Interval = 17 * 2.5 = 42 -> Mastered!
      item = scheduler.processReview(item: item, quality: ReviewQuality.good, currentDate: DateTime.utc(2026, 9, 27));
      expect(item.intervalDays, greaterThanOrEqualTo(30));
      expect(item.state, equals(MemorizationState.memorized));
    });

    test('Lapse Handling: Failure (Again) resets interval to 1 and transitions state to learning/weak', () {
      final matureItem = MemorizationItem(
        ayahKey: testKey,
        state: MemorizationState.memorized,
        repetitions: 5,
        lapses: 0,
        intervalDays: 20,
        easeFactor: 2.5,
        masteryScore: 85.0,
        createdAt: baseDate,
        updatedAt: baseDate,
      );

      // Lapse 1
      final lapsed1 = scheduler.processReview(
        item: matureItem,
        quality: ReviewQuality.again,
        currentDate: baseDate,
      );
      expect(lapsed1.intervalDays, equals(1));
      expect(lapsed1.repetitions, equals(0));
      expect(lapsed1.lapses, equals(1));
      expect(lapsed1.state, equals(MemorizationState.learning));
      expect(lapsed1.easeFactor, equals(2.3));

      // Multiple lapses -> Transition to Weak state
      var weakItem = lapsed1.copyWith(lapses: 2);
      weakItem = scheduler.processReview(
        item: weakItem,
        quality: ReviewQuality.again,
        currentDate: baseDate,
      );
      expect(weakItem.lapses, equals(3));
      expect(weakItem.state, equals(MemorizationState.weak));
    });
  });
}
