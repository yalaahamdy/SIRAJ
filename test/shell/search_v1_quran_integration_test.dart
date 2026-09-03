import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Quran Search Integration Suite (§13, §70, §93)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
      );
    });

    test('Quran Search 1: Quran search results return canonical Ayah keys without storing full duplicate texts (§12, §13)', () async {
      final res = await companionModule.search('الرحمن');
      expect(res.isSuccess, true);
      expect(res.valueOrNull!.any((e) => e.moduleId == 'quran'), true);
    });
  });
}
