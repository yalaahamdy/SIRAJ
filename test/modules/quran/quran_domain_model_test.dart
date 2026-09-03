import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/domain/quran_edition.dart';
import 'package:siraj/modules/quran/domain/revelation_type.dart';
import 'package:siraj/modules/quran/domain/surah.dart';

void main() {
  group('L2 Quran Domain Model & Canonical Identity Tests (§6, §7)', () {
    test('AyahKey parses and formats deterministically', () {
      final key = AyahKey(surahNumber: 1, ayahNumber: 1);
      expect(key.toString(), equals('1:1'));
      expect(key.toCanonicalId('uthmani_hafs'), equals('quran:uthmani_hafs:1:1'));

      final parsed = AyahKey.parse('114:6');
      expect(parsed.surahNumber, equals(114));
      expect(parsed.ayahNumber, equals(6));

      final parsedPrefixed = AyahKey.parse('quran:uthmani:2:255');
      expect(parsedPrefixed.surahNumber, equals(2));
      expect(parsedPrefixed.ayahNumber, equals(255));
    });

    test('Ayah entity calculates and verifies SHA-256 hash', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        pageNumber: 1,
        manzilNumber: 1,
      );

      expect(ayah.verifyIntegrity(), isTrue);
      expect(ayah.integrityHash.startsWith('sha256:'), isTrue);
    });

    test('Surah entity preserves structural invariants and revelation type', () {
      final fatihah = Surah(
        number: 1,
        nameArabic: 'الفاتحة',
        nameEnglish: 'Al-Fatihah',
        nameTransliteration: 'Al-Fatihah',
        revelationType: RevelationType.meccan,
        ayahCount: 7,
        startPage: 1,
      );

      expect(fatihah.number, equals(1));
      expect(fatihah.ayahCount, equals(7));
      expect(fatihah.revelationType, equals(RevelationType.meccan));
      expect(fatihah.revelationType.nameArabic, equals('مكية'));
    });

    test('QuranEdition preserves transmission details', () {
      const edition = QuranEdition.uthmaniHafs;
      expect(edition.id, equals('uthmani_hafs'));
      expect(edition.scriptType, equals('uthmani'));
      expect(edition.language, equals('ar'));
    });
  });
}
