import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat & Learning Module Integration Suite (§100, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;
    late LearningModule learningModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
      learningModule = LearningModule(storageRegistry: registry);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Learning Integration 1: Learning paths and Zakat module operate independently and safely', () async {
      final pathsRes = learningModule.getAllPaths();
      expect(pathsRes.isSuccess, true);
      expect(pathsRes.valueOrNull!.isNotEmpty, true);

      // Verify that zakat calculation doesn't alter learning progress
      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);

      final pathsAfter = learningModule.getAllPaths();
      expect(pathsAfter.valueOrNull!.length, pathsRes.valueOrNull!.length);
    });
  });
}
