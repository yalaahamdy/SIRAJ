import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Search Query Processing & Trimming Suite (§6, §7, §93)', () {
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

    test('Query 1: Empty and whitespace-only queries return empty result list without errors', () async {
      final res1 = await companionModule.search('');
      final res2 = await companionModule.search('   ');

      expect(res1.isSuccess, true);
      expect(res1.valueOrNull!.isEmpty, true);

      expect(res2.isSuccess, true);
      expect(res2.valueOrNull!.isEmpty, true);
    });

    test('Query 2: Valid Arabic query returns matching domain records', () async {
      final res = await companionModule.search('الله');
      expect(res.isSuccess, true);
      expect(res.valueOrNull!.isNotEmpty, true);
    });
  });
}
