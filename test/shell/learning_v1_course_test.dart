import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Learning Courses & Modules Structure Suite (§41, §42, §116)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Course 1: Curriculum engine loads paths, courses, modules, and lessons structure', () {
      final pathsRes = learningModule.getAllPaths();
      expect(pathsRes.isSuccess, true);
      final paths = pathsRes.valueOrNull!;
      expect(paths.isNotEmpty, true);

      final path = paths.first;
      expect(path.courseIds.isNotEmpty, true);
      final courseRes = learningModule.getCourse(path.courseIds.first);
      expect(courseRes.isSuccess, true);
      final course = courseRes.valueOrNull!;
      expect(course.moduleIds.isNotEmpty, true);
      expect(course.title.isNotEmpty, true);
    });
  });
}
