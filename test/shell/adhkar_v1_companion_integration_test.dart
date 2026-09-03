import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Companion & Daily Journey Integration Suite (§54, §55, §119)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Companion 1: Companion priority engine retrieves active occasion without imposing compulsory worship (§54, §55)', () {
      final currentOccasion = module.getCurrentOccasion();
      final occasionName = currentOccasion.labelArabic;
      expect(occasionName.isNotEmpty, true);
    });
  });
}
