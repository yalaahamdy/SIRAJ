import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Hajj Persistence Suite (§61, §101, §107)', () {
    late MemoryStorageRegistry registry;

    setUp(() {
      registry = MemoryStorageRegistry();
    });

    test('Persistence 1: Persists completed steps, checklist, and notes across module reload', () async {
      final module1 = HajjModule(storageRegistry: registry);
      module1.mountPackage(SyntheticHajjFixtures.createPackage());

      await module1.setJourneyType(JourneyType.hajjTamattu);
      await module1.markStepCompleted('step_tamattu_umrah_ihram');
      await module1.togglePreparationItem('prep_documents');
      await module1.saveUserNote('step_tamattu_umrah_ihram', 'تذكر لبس الإحرام من الطائرة');

      // Create new module instance using same storage
      final module2 = HajjModule(storageRegistry: registry);
      module2.mountPackage(SyntheticHajjFixtures.createPackage());

      final prog = (await module2.getUserProgress()).valueOrNull!;
      expect(prog.activeJourneyType, equals(JourneyType.hajjTamattu));
      expect(prog.completedStepIds.contains('step_tamattu_umrah_ihram'), isTrue);
      expect(prog.checkedPreparationItemIds.contains('prep_documents'), isTrue);
      expect(prog.userNotes['step_tamattu_umrah_ihram'], equals('تذكر لبس الإحرام من الطائرة'));
    });
  });
}
