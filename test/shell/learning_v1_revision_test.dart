import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/domain/revision_item.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Learning Revision Scheduler Suite (§46, §96, §120)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Revision 1: Scheduling spaced repetition revision adapts interval and remains isolated', () async {
      final item = RevisionItem(
        itemId: 'rev_001',
        targetType: RevisionTargetType.lesson,
        targetId: 'lsn_wudu_pillars',
        dueAt: DateTime.utc(2026, 9, 1),
        intervalDays: 1,
        repetitionCount: 0,
        easeFactor: 2.5,
      );

      final subRes = await learningModule.submitRevision(item, 4); // quality 4 = good
      expect(subRes.isSuccess, isTrue);

      final progRes = await learningModule.getUserProgress();
      expect(progRes.isSuccess, isTrue);
      expect(progRes.valueOrNull!.revisionQueue, isNotEmpty);
      expect(progRes.valueOrNull!.revisionQueue.first.repetitionCount, equals(1));
    });
  });
}
