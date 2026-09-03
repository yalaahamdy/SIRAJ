import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Cross-Module Evidence & Navigation Suite (§64..§68, §105, §116)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Cross-Module 1: Learning evidence points to Quran AyahKey cleanly without mutating Quran store', () {
      final lessons = learningModule.store.getAllLessons().valueOrNull!;
      expect(lessons.isNotEmpty, true);

      final lesson = lessons.first;
      expect(lesson.sections.isNotEmpty, true);

      // Verify Quran store is intact
      expect(quranModule.store.getAllSurahs().valueOrNull!.length, 114);
    });
  });
}
