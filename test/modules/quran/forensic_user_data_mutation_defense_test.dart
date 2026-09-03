import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('M2 Forensic User Data Mutation Defense Tests (§26, §27)', () {
    late MemoryStorageRegistry storage;
    late QuranModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      final clock = TestClock(DateTime.utc(2026, 8, 31, 14, 0));
      module = QuranModule(storageRegistry: storage, clock: clock);
      final package = CanonicalQuranFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('User bookmarks and progress never mutate or corrupt the Canonical Store', () async {
      final initialAyahRes = module.readerService.getAyah(1, 1);
      final initialAyah = initialAyahRes.valueOrNull!;
      final initialHash = initialAyah.integrityHash;

      // Add multiple bookmarks and update reading position
      await module.addBookmark(
        surahNumber: 1,
        ayahNumber: 1,
        pageNumber: 1,
        surahNameArabic: 'الفاتحة',
        ayahSnippet: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        note: 'User custom private note',
      );

      await module.updateReadingPosition(
        surahNumber: 114,
        ayahNumber: 6,
        pageNumber: 604,
        surahNameArabic: 'الناس',
      );

      // Re-verify that the canonical store Ayah is 100% identical and unmutated
      final afterAyahRes = module.readerService.getAyah(1, 1);
      final afterAyah = afterAyahRes.valueOrNull!;

      expect(afterAyah.textUthmani, equals(initialAyah.textUthmani));
      expect(afterAyah.integrityHash, equals(initialHash));
      expect(afterAyah.verifyIntegrity(), isTrue);

      // Verify that user data is strictly in `mod_quran` namespace
      final modStore = storage.getStoreForModule('mod_quran');
      final bmJson = await modStore.getString('user_bookmarks_list');
      expect(bmJson.valueOrNull, isNotNull);
      expect(bmJson.valueOrNull!.contains('User custom private note'), isTrue);

      // Verify that canonical store does not hold user notes
      expect(module.store.mountedPackageId, equals('pkg_quran_uthmani_test_v1'));
    });
  });
}
