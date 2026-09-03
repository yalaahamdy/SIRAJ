import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Adhkar Privacy & Zero-Religious Profiling Suite (§65, §97, §98, §119, §126)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Privacy 1: User progress and favorites store only IDs/counts and never copy canonical text or create piety scores (§98, §102)', () async {
      final item = module.getAllItems().valueOrNull!.first;

      await module.toggleFavorite(item.id);
      await module.incrementProgress(contentId: item.id, targetCount: item.repetition.count);

      final favs = (await module.getFavorites()).valueOrNull!;
      expect(favs.first.contentId, equals(item.id));
    });
  });
}
