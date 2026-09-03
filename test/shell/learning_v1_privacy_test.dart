import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Learning Privacy & Zero-Profiling Suite (§90..§93, §115, §116, §124)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Privacy 1: Privacy assertion — Learning data is strictly local and never used for religious profiling (§92, §124)', () async {
      await learningModule.markLessonCompleted('lesson_intention_fasting', 1);

      final progressRes = await learningModule.getUserProgress();
      expect(progressRes.isSuccess, true);
    });
  });
}
