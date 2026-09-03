import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Learning Progress & Persistence Suite (§47..§52, §120)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Progress 1: Completing lesson, saving notes, and bookmarking persists across instances', () async {
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);
      await learningModule.toggleBookmark('lsn_wudu_pillars');
      await learningModule.saveUserNote('lsn_wudu_pillars', 'ملاحظة مهمة: الترتيب والموالاة من سنن الوضوء');

      // Create new instance on same storage
      final restoredModule = LearningModule(storageRegistry: storage);
      restoredModule.mountPackage(SyntheticLearningFixtures.createPackage());

      final progRes = await restoredModule.getUserProgress();
      expect(progRes.isSuccess, isTrue);
      final prog = progRes.valueOrNull!;

      expect(prog.isLessonCompleted('lsn_wudu_pillars', 1), isTrue);
      expect(prog.bookmarkedLessonIds.contains('lsn_wudu_pillars'), isTrue);
      expect(prog.userNotes['lsn_wudu_pillars'], contains('الترتيب والموالاة'));
    });
  });
}
