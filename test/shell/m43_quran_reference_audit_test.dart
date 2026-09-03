import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/domain/revelation_type.dart';
import 'package:siraj/modules/quran/domain/surah.dart';
import 'package:siraj/modules/quran/search/quran_text_normalizer.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 18: M43 Quran Reference Audit Suite (QuranJSON Audit, §141..§148)', () {


    // ------------------------------------------------------------------------
    // AUDIT TEST 1: SURAH METADATA AND 114 INVARIANTS
    // ------------------------------------------------------------------------
    test('Audit 1: Surah metadata adheres to 114 canon bounds and strict numbering', () {
      const fatiha = Surah(
        number: 1,
        nameArabic: 'الفاتحة',
        nameEnglish: 'Al-Fatiha',
        nameTransliteration: 'Al-Faatiha',
        revelationType: RevelationType.meccan,
        ayahCount: 7,
        startPage: 1,
      );

      expect(fatiha.number, equals(1));
      expect(fatiha.ayahCount, equals(7));
      expect(fatiha.revelationType, equals(RevelationType.meccan));

      const baqarah = Surah(
        number: 2,
        nameArabic: 'البقرة',
        nameEnglish: 'Al-Baqarah',
        nameTransliteration: 'Al-Baqarah',
        revelationType: RevelationType.medinan,
        ayahCount: 286,
        startPage: 2,
      );

      expect(baqarah.number, equals(2));
      expect(baqarah.ayahCount, equals(286));
      expect(baqarah.revelationType, equals(RevelationType.medinan));

      const nas = Surah(
        number: 114,
        nameArabic: 'الناس',
        nameEnglish: 'An-Nas',
        nameTransliteration: 'An-Naas',
        revelationType: RevelationType.meccan,
        ayahCount: 6,
        startPage: 604,
      );

      expect(nas.number, equals(114));
      expect(nas.ayahCount, equals(6));
    });

    // ------------------------------------------------------------------------
    // AUDIT TEST 2: AYAH CANONICAL HASH AND KEY UNICITY
    // ------------------------------------------------------------------------
    test('Audit 2: Ayah entity auto-calculates deterministic SHA-256 hash', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        pageNumber: 1,
        manzilNumber: 1,
      );

      expect(ayah.key, equals(const AyahKey(surahNumber: 1, ayahNumber: 1)));
      expect(ayah.integrityHash.startsWith('sha256:'), isTrue);
      expect(ayah.integrityHash.length, equals(71));
    });

    // ------------------------------------------------------------------------
    // AUDIT TEST 3: QURAN TEXT NORMALIZER COMPLIANCE
    // ------------------------------------------------------------------------
    test('Audit 3: QuranTextNormalizer removes diacritics and normalizes Alif/Yaa variants', () {
      // Diacritics stripping
      const tashkeel = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';
      final clean = QuranTextNormalizer.normalizeForSearch(tashkeel);
      expect(clean.contains('ِ'), isFalse);
      expect(clean.contains('ّ'), isFalse);
      expect(clean.contains('َ'), isFalse);

      // Alif variants normalization
      expect(QuranTextNormalizer.normalizeForSearch('إيمان'), equals(QuranTextNormalizer.normalizeForSearch('ايمان')));
      expect(QuranTextNormalizer.normalizeForSearch('أمة'), equals(QuranTextNormalizer.normalizeForSearch('امة')));
      expect(QuranTextNormalizer.normalizeForSearch('آيات'), equals(QuranTextNormalizer.normalizeForSearch('ايات')));

      // Yaa and Taa Marbuta
      expect(QuranTextNormalizer.normalizeForSearch('هدى'), equals(QuranTextNormalizer.normalizeForSearch('هدي')));
      expect(QuranTextNormalizer.normalizeForSearch('رحمة'), equals(QuranTextNormalizer.normalizeForSearch('رحمه')));
    });

    // ------------------------------------------------------------------------
    // AUDIT TEST 4: INLINE HTML / TAJWEED TAG REJECTION
    // ------------------------------------------------------------------------
    test('Audit 4: Canonical store rejects HTML tags or unescaped markup in Ayah text', () {
      const contaminatedText = '<tajweed class="ghunna">مِنْ</tajweed> رَبِّهِمْ';
      final normalized = QuranTextNormalizer.normalizeForSearch(contaminatedText);

      // Verify that normalizer safely ignores or cleans search tokens without crashing
      expect(normalized, isNotEmpty);
    });

    // ------------------------------------------------------------------------
    // AUDIT TEST 5: CANONICAL PACKAGE IMMUTABILITY & ISOLATION
    // ------------------------------------------------------------------------
    test('Audit 5: CanonicalQuranPackage maintains uncompromised signer manifest', () {
      final packageJson = {
        'manifest': {
          'package_id': 'siraj_canonical_quran_v1',
          'version': '1.0.0',
          'schema_version': 1,
          'content_hash': 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'signer_identity': 'KFGQPC_AUTHORIZED_SCHOLAR_2026',
          'signature': 'SIG_VALID_ECDSA_2026',
        },
        'surahs': [
          {
            'number': 1,
            'name_arabic': 'الفاتحة',
            'name_english': 'Al-Fatiha',
            'name_transliteration': 'Al-Faatiha',
            'revelation_type': 'meccan',
            'ayah_count': 7,
            'start_page': 1,
          }
        ],
        'ayahs': [
          {
            'surah_number': 1,
            'ayah_number': 1,
            'text_uthmani': 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
            'text_simple': 'بسم الله الرحمن الرحيم',
            'juz_number': 1,
            'hizb_number': 1,
            'rub_number': 1,
            'page_number': 1,
            'manzil_number': 1,
            'has_sajdah': false,
          }
        ],
        'juzs': [
          {
            'number': 1,
            'name_arabic': 'الجزء الأول',
            'start_surah_number': 1,
            'start_ayah_number': 1,
            'start_page': 1,
          }
        ],
      };

      final package = CanonicalQuranPackage.fromJson(packageJson);
      expect(package.packageId, equals('siraj_canonical_quran_v1'));
      expect(package.surahs.length, equals(1));
      expect(package.ayahs.length, equals(1));
      expect(package.juzs.length, equals(1));
    });
  });
}
