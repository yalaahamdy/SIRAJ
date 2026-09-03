import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Hajj Resume Suite (§33..§35, §107)', () {
    late MemoryStorageRegistry registry;

    setUp(() {
      registry = MemoryStorageRegistry();
    });

    test('Resume 1: Resumes from exact current unfinished step after interruption', () async {
      final module1 = HajjModule(storageRegistry: registry);
      module1.mountPackage(SyntheticHajjFixtures.createPackage());

      await module1.setJourneyType(JourneyType.umrah);
      await module1.markStepCompleted('step_umrah_ihram');

      // Restart process
      final module2 = HajjModule(storageRegistry: registry);
      module2.mountPackage(SyntheticHajjFixtures.createPackage());

      final snap = (await module2.getJourneySnapshot()).valueOrNull!;
      expect(snap.currentStep?.stepId, equals('step_umrah_tawaf'));
      expect(snap.completedStepsCount, equals(1));
    });
  });
}
