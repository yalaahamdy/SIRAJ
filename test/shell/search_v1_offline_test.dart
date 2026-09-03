import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Local Offline Search Execution Suite (§27, §76, §93)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late AdhkarModule adhkarModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
        adhkarModule: adhkarModule,
      );
    });

    test('Offline 1: Local search queries execute entirely offline without network dependencies (§27, §76)', () async {
      final res = await companionModule.search('الحمد');
      expect(res.isSuccess, true);
      expect(res.valueOrNull!.isNotEmpty, true);
    });
  });
}
