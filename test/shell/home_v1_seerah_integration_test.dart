import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Seerah & Islamic History Integration Suite (§38, §114)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        seerahModule: seerahModule,
      );
    });

    test('Seerah Integration 1: Home dashboard presents Seerah stations entry', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.any((c) => c.sourceModule == 'seerah' || c.targetRoute == '/seerah'), true);
    });
  });
}
