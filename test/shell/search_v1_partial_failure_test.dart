import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Partial Domain Failure & Isolation Suite (§25, §26, §77, §93)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule adhkarModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      // Knowledge and other modules unmounted/null
      companionModule = CompanionModule(
        storageRegistry: storage,
        adhkarModule: adhkarModule,
      );
    });

    test('Partial Failure 1: Search succeeds gracefully returning available domain results when others are absent (§26, §77)', () async {
      final res = await companionModule.search('الله');
      expect(res.isSuccess, true);
      expect(res.valueOrNull!.isNotEmpty, true);
      expect(res.valueOrNull!.every((e) => e.moduleId == 'adhkar'), true);
    });
  });
}
