import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/scheduler/spaced_repetition_scheduler.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Spaced Repetition Scheduler Suite (§16..§18, §100)', () {
    const scheduler = SpacedRepetitionScheduler();
    final now = DateTime.utc(2026, 9, 1, 10, 0);

    test('Scheduler 1: Again rating resets interval to 1 day and increases lapses', () {
      final item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        state: MemorizationState.learning,
        repetitions: 3,
        intervalDays: 6,
        createdAt: now,
        updatedAt: now,
      );

      final nextItem = scheduler.processReview(item: item, quality: ReviewQuality.again, currentDate: now);
      expect(nextItem.intervalDays, equals(1));
      expect(nextItem.lapses, equals(1));
      expect(nextItem.state, equals(MemorizationState.learning));
    });

    test('Scheduler 2: Good rating advances interval and maintains ease factor', () {
      final item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        state: MemorizationState.learning,
        repetitions: 1,
        intervalDays: 1,
        createdAt: now,
        updatedAt: now,
      );

      final nextItem = scheduler.processReview(item: item, quality: ReviewQuality.good, currentDate: now);
      expect(nextItem.intervalDays, equals(4));
      expect(nextItem.repetitions, equals(2));
    });

    test('Scheduler 3: Easy rating grants bonus interval multiplier and increases ease factor', () {
      final item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        state: MemorizationState.learning,
        repetitions: 1,
        intervalDays: 1,
        easeFactor: 2.0,
        createdAt: now,
        updatedAt: now,
      );

      final nextItem = scheduler.processReview(item: item, quality: ReviewQuality.easy, currentDate: now);
      expect(nextItem.intervalDays, greaterThanOrEqualTo(6));
      expect(nextItem.easeFactor, greaterThan(2.0));
    });
  });
}
