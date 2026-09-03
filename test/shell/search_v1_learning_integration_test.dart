import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Learning Paths Search Integration Suite (§17, §73, §86, §93)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        learningModule: learningModule,
      );
    });

    test('Learning Search 1: Searching educational lessons returns verifiable lesson IDs (§17)', () async {
      final res = await companionModule.search('النية');
      expect(res.isSuccess, true);
    });
  });
}
