import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Source Traceability Suite (§24, §25, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Source Trace 1: Event contains verifiable canonical source references', () {
      final evRes = seerahModule.getEvent('evt_badr_major');
      expect(evRes.isSuccess, isTrue);

      final event = evRes.valueOrNull!;
      expect(event.sourceIds, contains('src_maghazi_test'));
      expect(event.sourceIds, contains('src_bukhari_test'));
    });
  });
}
