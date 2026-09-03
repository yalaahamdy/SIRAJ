import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah & Learning Integration Suite (§51, §107)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Learning Integration 1: Seerah module and Learning module operate harmoniously on common storage', () async {
      await seerahModule.markEventViewed('evt_badr_major');
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);

      final seerahProg = await seerahModule.getUserProgress();
      final learningProg = await learningModule.getUserProgress();

      expect(seerahProg.valueOrNull!.viewedEventIds, contains('evt_badr_major'));
      expect(learningProg.valueOrNull!.isLessonCompleted('lsn_wudu_pillars', 1), isTrue);
    });
  });
}
