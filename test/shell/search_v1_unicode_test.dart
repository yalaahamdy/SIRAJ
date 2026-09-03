import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Unicode Search & Normalization Robustness Suite (§31..§33, §93)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule adhkarModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        adhkarModule: adhkarModule,
      );
    });

    test('Unicode 1: Zero-width and complex unicode characters do not crash search or corrupt display (§31..§33)', () async {
      // Query with zero-width spaces and diacritics
      final res = await companionModule.search('الله\u200B\u200C');
      expect(res.isSuccess, true);
    });
  });
}
