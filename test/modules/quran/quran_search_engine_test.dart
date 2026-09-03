import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/search/quran_search_engine.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Quran Search Engine Tests (§11, §23)', () {
    late ReadOnlyCanonicalQuranStore store;
    late QuranSearchEngine searchEngine;

    setUp(() {
      store = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      store.mountPackage(package);
      searchEngine = QuranSearchEngine(store: store);
    });

    test('Searches by plain un-diacritized keyword and returns canonical Uthmani Ayah', () {
      final res = searchEngine.search('اياك نعبد');

      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;
      expect(list.isNotEmpty, isTrue);
      expect(list.first.ayah.surahNumber, equals(1));
      expect(list.first.ayah.ayahNumber, equals(5));
      expect(list.first.ayah.textUthmani, equals('إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ'));
    });

    test('Searches for "الفلق" finds Surah Al-Falaq Ayah 1', () {
      final res = searchEngine.search('الفلق');

      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;
      expect(list.any((r) => r.ayah.surahNumber == 113 && r.ayah.ayahNumber == 1), isTrue);
    });

    test('Empty query returns empty results immediately', () {
      final res = searchEngine.search('');
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull!.isEmpty, isTrue);
    });
  });
}
