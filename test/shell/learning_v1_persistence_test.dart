import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Learning Local Persistence Suite (§63, §116)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    test('Persistence 1: Learning progress and completed lessons persist and reload cleanly in a fresh module', () async {
      final module1 = LearningModule(storageRegistry: storage);
      module1.mountPackage(SyntheticLearningFixtures.createPackage());

      await module1.markLessonCompleted('lesson_intention_fasting', 1);

      // New module instance over same storage
      final module2 = LearningModule(storageRegistry: storage);
      module2.mountPackage(SyntheticLearningFixtures.createPackage());

      final progressRes = await module2.getUserProgress();
      expect(progressRes.isSuccess, true);
      final progress = progressRes.valueOrNull!;
      expect(progress.completedLessonVersions['lesson_intention_fasting'], 1);
    });
  });
}
