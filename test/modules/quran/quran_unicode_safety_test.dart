import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/search/quran_text_normalizer.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Quran Unicode Safety & Normalization Isolation Tests (§10, §11, §24)', () {
    test('Canonical Uthmani text contains and preserves authentic Quranic Unicode marks', () {
      final ayahs = CanonicalQuranFixture.createSampleCanonicalAyahs();

      final bismillah = ayahs.first.textUthmani;
      // Dagger Alef in Ar-Rahman (U+0670) and Wasla in Allah (U+0671)
      expect(bismillah.contains('\u0670'), isTrue, reason: 'Dagger Alef missing in Bismillah');
      expect(bismillah.contains('\u0671'), isTrue, reason: 'Alef Wasla missing in Bismillah');

      // Surah Al-Ikhlas Ayah 4 contains Small Waw (U+06E5)
      final ikhlasAyah4 = ayahs.firstWhere((a) => a.surahNumber == 112 && a.ayahNumber == 4);
      expect(ikhlasAyah4.textUthmani.contains('\u06E5'), isTrue, reason: 'Small Waw missing in Al-Ikhlas 4');
    });

    test('QuranTextNormalizer strips Tashkeel and unifies Alef for search without mutating original', () {
      const originalText = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
      final normalized = QuranTextNormalizer.normalizeForSearch(originalText);

      expect(normalized, equals('بسم الله الرحمن الرحيم'));
      // Ensure original string remains completely intact
      expect(originalText, equals('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'));
    });

    test('Normalizes various Hamza and Alef forms for keyword discovery', () {
      expect(QuranTextNormalizer.normalizeForSearch('إِيَّاكَ نَعْبُدُ'), equals('اياك نعبد'));
      expect(QuranTextNormalizer.normalizeForSearch('قُلْ أَعُوذُ'), equals('قل اعوذ'));
      expect(QuranTextNormalizer.normalizeForSearch('ٱلْفَلَقِ'), equals('الفلق'));
    });
  });
}
