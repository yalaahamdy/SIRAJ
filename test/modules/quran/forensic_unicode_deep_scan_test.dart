import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/search/quran_text_normalizer.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('M2 Forensic Unicode Deep Scan & Anomaly Detection Tests (§11, §12)', () {
    final allAyahs = CanonicalQuranFixture.createSampleCanonicalAyahs();

    test('Zero-Width and Hidden Characters: No illegal hidden control characters in canonical text', () {
      final illegalCharsRegex = RegExp(r'[\u200B\u200C\u200D\uFEFF\u202A-\u202E]');

      for (final ayah in allAyahs) {
        final hasIllegal = illegalCharsRegex.hasMatch(ayah.textUthmani);
        expect(
          hasIllegal,
          isFalse,
          reason: 'Illegal hidden or directional override character found in ${ayah.key}: "${ayah.textUthmani}"',
        );
      }
    });

    test('Numeric Pollution: Canonical text contains no embedded ASCII Latin digits', () {
      final asciiDigitsRegex = RegExp(r'[0-9]');

      for (final ayah in allAyahs) {
        final hasAsciiDigits = asciiDigitsRegex.hasMatch(ayah.textUthmani);
        expect(
          hasAsciiDigits,
          isFalse,
          reason: 'Embedded ASCII digit found in canonical text of ${ayah.key}',
        );
      }
    });

    test('Sacred Normalization Isolation: Search normalization never alters canonical text in memory', () {
      for (final ayah in allAyahs) {
        final canonicalBefore = ayah.textUthmani;
        final hashBefore = ayah.integrityHash;

        // Perform search normalization
        final normalized = QuranTextNormalizer.normalizeForSearch(ayah.textUthmani);

        // Verification of immutable separation
        expect(ayah.textUthmani, equals(canonicalBefore));
        expect(ayah.integrityHash, equals(hashBefore));
        expect(ayah.verifyIntegrity(), isTrue);

        // Normalized copy must differ from canonical by having no diacritics
        expect(normalized, isNot(equals(canonicalBefore)));
      }
    });

    test('Quranic Marks: Verifies authentic presence of Uthmanic specific Unicode points', () {
      final fatihah1 = allAyahs.firstWhere((a) => a.surahNumber == 1 && a.ayahNumber == 1);
      // Contains Alef Khanjareeya (Dagger Alef) U+0670
      expect(fatihah1.textUthmani.codeUnits.contains(0x0670), isTrue);

      // Contains Alef Wasla U+0671
      expect(fatihah1.textUthmani.codeUnits.contains(0x0671), isTrue);

      // Surah Al-Ikhlas Ayah 4 contains Small High Waw U+06E5
      final ikhlas4 = allAyahs.firstWhere((a) => a.surahNumber == 112 && a.ayahNumber == 4);
      expect(ikhlas4.textUthmani.codeUnits.contains(0x06E5), isTrue);
    });
  });
}
