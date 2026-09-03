import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Adhkar Local Persistence Suite (§65, §66, §119)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    test('Persistence 1: Dhikr progress and favorites persist and reload across fresh module instances', () async {
      final module1 = AdhkarModule(storageRegistry: storage);
      module1.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final item = module1.getAllItems().valueOrNull!.first;
      await module1.incrementProgress(contentId: item.id, targetCount: item.repetition.count);
      await module1.toggleFavorite(item.id);

      // Reload fresh instance over same storage
      final module2 = AdhkarModule(storageRegistry: storage);
      module2.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final progRes = await module2.getProgress(item.id, item.repetition.count);
      final isFavRes = await module2.isFavorite(item.id);

      expect(progRes.isSuccess, true);
      expect(progRes.valueOrNull!.currentCount, 1);
      expect(isFavRes.isSuccess, true);
      expect(isFavRes.valueOrNull, true);
    });
  });
}
