import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Hajj Progress Suite (§23, §67..§69, §100, §107)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
    });

    test('Progress 1: Calculates progress strictly as navigation percentage without spiritual score', () async {
      await hajjModule.setJourneyType(JourneyType.umrah);
      var snap = (await hajjModule.getJourneySnapshot()).valueOrNull!;

      expect(snap.totalSteps, equals(4));
      expect(snap.completedStepsCount, equals(0));
      expect(snap.progressPercentage, equals(0.0));
      expect(snap.completedStepsCount == snap.totalSteps, isFalse);

      await hajjModule.markStepCompleted('step_umrah_ihram');
      await hajjModule.markStepCompleted('step_umrah_tawaf');

      snap = (await hajjModule.getJourneySnapshot()).valueOrNull!;
      expect(snap.completedStepsCount, equals(2));
      expect(snap.progressPercentage, equals(50.0));
      expect(snap.completedStepsCount == snap.totalSteps, isFalse);

      await hajjModule.markStepCompleted('step_umrah_sai');
      await hajjModule.markStepCompleted('step_umrah_tahallul');

      snap = (await hajjModule.getJourneySnapshot()).valueOrNull!;
      expect(snap.completedStepsCount, equals(4));
      expect(snap.progressPercentage, equals(100.0));
      expect(snap.completedStepsCount == snap.totalSteps, isTrue);
    });
  });
}
