import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Narrative Variants & Anti-Merging Suite (§17..§21, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Narrative 1: Narrative variants remain isolated per narrator and source without synthesis', () {
      final evRes = seerahModule.getEvent('evt_badr_major');
      expect(evRes.isSuccess, isTrue);

      final event = evRes.valueOrNull!;
      expect(event.variants, isNotEmpty);
      expect(event.variants.first.narratorOrScholar, equals('موسى بن عقبة'));
      expect(event.variants.first.sourceId, equals('src_maghazi_test'));
    });
  });
}
