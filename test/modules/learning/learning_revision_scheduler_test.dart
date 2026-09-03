import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/learning/domain/revision_item.dart';
import 'package:siraj/modules/learning/scheduler/learning_revision_scheduler.dart';

void main() {
  group('L2 Learning Spaced Revision Scheduler Tests (§22, §23)', () {
    const scheduler = LearningRevisionScheduler();
    final baseTime = DateTime.utc(2026, 9, 1);

    test('Initial review step progresses from 1 to 3 to 7 days upon good recall', () {
      final initial = RevisionItem(
        itemId: 'rev_1',
        targetType: RevisionTargetType.lesson,
        targetId: 'lsn_1',
        dueAt: baseTime,
      );

      // 1st successful review
      final step1 = scheduler.scheduleNextReview(current: initial, quality: 4, now: baseTime);
      expect(step1.repetitionCount, equals(1));
      expect(step1.intervalDays, equals(1));

      // 2nd successful review
      final step2 = scheduler.scheduleNextReview(current: step1, quality: 4, now: step1.dueAt);
      expect(step2.repetitionCount, equals(2));
      expect(step2.intervalDays, equals(3));

      // 3rd successful review
      final step3 = scheduler.scheduleNextReview(current: step2, quality: 4, now: step2.dueAt);
      expect(step3.repetitionCount, equals(3));
      expect(step3.intervalDays, equals(7));
    });

    test('Failed review resets interval to 1 day and repetition count to 0', () {
      final advanced = RevisionItem(
        itemId: 'rev_1',
        targetType: RevisionTargetType.lesson,
        targetId: 'lsn_1',
        dueAt: baseTime,
        repetitionCount: 4,
        intervalDays: 20,
        easeFactor: 2.5,
      );

      final failed = scheduler.scheduleNextReview(current: advanced, quality: 1, now: baseTime);
      expect(failed.repetitionCount, equals(0));
      expect(failed.intervalDays, equals(1));
      expect(failed.easeFactor >= 1.3, isTrue);
    });

    test('Ease factor never drops below 1.3 cognitive minimum bound', () {
      var item = RevisionItem(
        itemId: 'rev_1',
        targetType: RevisionTargetType.lesson,
        targetId: 'lsn_1',
        dueAt: baseTime,
        easeFactor: 1.35,
      );

      for (int i = 0; i < 5; i++) {
        item = scheduler.scheduleNextReview(current: item, quality: 1, now: baseTime);
        expect(item.easeFactor >= 1.3, isTrue);
      }
    });
  });
}
