import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Learning Session Interruption & Resume Suite (§33, §63, §104, §116)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Resume 1: Partially completed lesson saves progress and resumes seamlessly', () async {
      const lessonId = 'lesson_intention_fasting';

      // Update progress
      await learningModule.markLessonCompleted(lessonId, 1);

      // Re-read progress
      final progressRes = await learningModule.getUserProgress();
      expect(progressRes.isSuccess, true);
      final progress = progressRes.valueOrNull!;
      expect(progress.lastStudiedLessonId, equals(lessonId));
      expect(progress.completedLessonVersions[lessonId], equals(1));
    });
  });
}
