import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Cross-Module Context & Evidence Navigation Suite (§41..§45, §75, §93)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Cross Module 1: Learning lessons declare explicit evidence relations without inference (§46, §47)', () {
      final lessons = learningModule.store.getAllLessons().valueOrNull!;
      expect(lessons.isNotEmpty, true);
      final lesson = lessons.first;
      expect(lesson.sections.isNotEmpty, true);
      expect(lesson.sections.first.evidenceLinks.isNotEmpty, true);
    });
  });
}
