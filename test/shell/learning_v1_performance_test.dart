import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Learning Real-World Performance Suite (§97, §116)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Performance 1: Loading curriculum paths and lessons executes rapidly', () {
      final stopwatch = Stopwatch()..start();
      final paths = learningModule.getAllPaths().valueOrNull!;
      final lessons = learningModule.store.getAllLessons().valueOrNull!;
      stopwatch.stop();

      expect(paths.isNotEmpty, true);
      expect(lessons.isNotEmpty, true);
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
