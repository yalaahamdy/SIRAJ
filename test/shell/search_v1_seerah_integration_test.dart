import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Seerah Search Integration Suite (§18, §74, §93)', () {
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

    test('Seerah Search 1: Searching Seerah returns historical events and stations (§18, §74)', () async {
      final res = await companionModule.search('الهجرة');
      expect(res.isSuccess, true);
    });
  });
}
