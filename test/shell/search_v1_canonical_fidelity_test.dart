import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Canonical Fidelity & Source-of-Truth Separation Suite (§11, §12, §82, §83, §93, §98)', () {
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

    test('Canonical Fidelity 1: Search indexing never mutates underlying canonical text or hashes (§82, §98)', () async {
      final initialItem = adhkarModule.getAllItems().valueOrNull!.first;
      final initialHash = initialItem.integrityHash;

      // Execute 20 search queries
      for (int i = 0; i < 20; i++) {
        await companionModule.search('الله');
      }

      final verifyItem = adhkarModule.getItemById(initialItem.id).valueOrNull!;
      expect(verifyItem.integrityHash, equals(initialHash));
    });
  });
}
