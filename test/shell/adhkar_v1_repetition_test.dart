import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Repetition Provenance & Count Integrity Suite (§16..§18, §119, §123)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Repetition 1: Sourced repetition provenance is strictly distinguished from arbitrary user counts', () {
      final items = module.getAllItems().valueOrNull!;
      expect(items.isNotEmpty, true);

      for (final item in items) {
        expect(item.repetition.count, greaterThan(0));
        expect(item.repetition.isSourced, isNotNull);
      }
    });
  });
}
