import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Canonical Quran Store Tests (§8, §9)', () {
    late ReadOnlyCanonicalQuranStore store;

    setUp(() {
      store = ReadOnlyCanonicalQuranStore();
    });

    test('Mounts valid package and enables indexed O(1) lookups', () {
      final package = CanonicalQuranFixture.createValidTestPackage();
      final mountRes = store.mountPackage(package);

      expect(mountRes.isSuccess, isTrue);
      expect(store.isMounted, isTrue);
      expect(store.mountedPackageId, equals('pkg_quran_uthmani_test_v1'));

      // 1. Get Ayah
      final ayahRes = store.getAyah(1, 1);
      expect(ayahRes.isSuccess, isTrue);
      expect(ayahRes.valueOrNull!.textUthmani, equals('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'));

      // 2. Get Surah Ayahs
      final surahAyahsRes = store.getSurahAyahs(1);
      expect(surahAyahsRes.isSuccess, isTrue);
      expect(surahAyahsRes.valueOrNull!.length, equals(7));

      // 3. Get Page
      final pageRes = store.getPage(1);
      expect(pageRes.isSuccess, isTrue);
      expect(pageRes.valueOrNull!.pageNumber, equals(1));
      expect(pageRes.valueOrNull!.surahNames, contains('الفاتحة'));

      // 4. Get Surahs list
      final allSurahsRes = store.getAllSurahs();
      expect(allSurahsRes.isSuccess, isTrue);
      expect(allSurahsRes.valueOrNull!.length, equals(114));
    });

    test('Returns error when querying unmounted store', () {
      final res = store.getAyah(1, 1);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull!.code, equals('PACKAGE_NOT_MOUNTED'));
    });

    test('Returns ContentNotFoundFailure for non-existent Ayah', () {
      final package = CanonicalQuranFixture.createValidTestPackage();
      store.mountPackage(package);

      final res = store.getAyah(1, 99);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull!.code, equals('AYAH_NOT_FOUND'));
    });
  });
}
