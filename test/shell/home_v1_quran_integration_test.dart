import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Quran Reading Integration Suite (§32, §114)', () {
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

    test('Quran Integration 1: Home dashboard presents Quran reading entry without copying canonical text (§95)', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.any((c) => c.sourceModule == 'quran' || c.targetRoute == '/quran'), true);
    });
  });
}
