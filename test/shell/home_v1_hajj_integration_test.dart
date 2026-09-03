import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Hajj & Umrah Integration Suite (§39, §102, §114)', () {
    late MemoryStorageRegistry storage;
    late HajjModule hajjModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: storage);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        hajjModule: hajjModule,
      );
    });

    test('Hajj Integration 1: Home dashboard presents active Hajj/Umrah journey when started (§39, §102)', () async {
      await hajjModule.setJourneyType(JourneyType.umrah);

      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.any((c) => c.sourceModule == 'hajj' || c.targetRoute == '/hajj'), true);
    });
  });
}
