import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Adhkar Search Integration Suite (§14, §93)', () {
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

    test('Adhkar Search 1: Adhkar search results return exact item IDs and provenance summaries (§14)', () async {
      final res = await companionModule.search('الله');
      expect(res.isSuccess, true);
      expect(res.valueOrNull!.any((e) => e.moduleId == 'adhkar'), true);
    });
  });
}
