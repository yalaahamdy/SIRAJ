import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/revelation_type.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('M2 Forensic Cross-Check & Structural Invariant Verification (§8, §9, §10, §20)', () {
    final surahs = CanonicalQuranFixture.create114Surahs();
    final juzs = CanonicalQuranFixture.create30Juzs();

    test('Surah Index: Exactly 114 Surahs with continuous contiguous numbering from 1 to 114', () {
      expect(surahs.length, equals(114));

      for (var i = 0; i < 114; i++) {
        final expectedNumber = i + 1;
        expect(surahs[i].number, equals(expectedNumber), reason: 'Surah index gap or discontinuity at $expectedNumber');
        expect(surahs[i].nameArabic.trim().isNotEmpty, isTrue);
        expect(surahs[i].nameEnglish.trim().isNotEmpty, isTrue);
        expect(surahs[i].ayahCount >= 3, isTrue, reason: 'Shortest Surah (Al-Kawthar) has 3 ayahs');
        expect(surahs[i].startPage >= 1 && surahs[i].startPage <= 604, isTrue);
      }
    });

    test('Surah Chronology and Revelation Classification Cross-Check', () {
      // Meccan benchmarks
      final fatihah = surahs.firstWhere((s) => s.number == 1);
      expect(fatihah.nameArabic, equals('الفاتحة'));
      expect(fatihah.revelationType, equals(RevelationType.meccan));
      expect(fatihah.ayahCount, equals(7));

      final ikhlas = surahs.firstWhere((s) => s.number == 112);
      expect(ikhlas.nameArabic, equals('الإخلاص'));
      expect(ikhlas.revelationType, equals(RevelationType.meccan));

      // Medinan benchmarks
      final baqarah = surahs.firstWhere((s) => s.number == 2);
      expect(baqarah.nameArabic, equals('البقرة'));
      expect(baqarah.revelationType, equals(RevelationType.medinan));
      expect(baqarah.ayahCount, equals(286));

      final nisa = surahs.firstWhere((s) => s.number == 4);
      expect(nisa.nameArabic, equals('النساء'));
      expect(nisa.revelationType, equals(RevelationType.medinan));
      expect(nisa.ayahCount, equals(176));
    });

    test('Page Boundary Monotonicity: Surah start pages never decrease', () {
      for (var i = 0; i < surahs.length - 1; i++) {
        final current = surahs[i];
        final next = surahs[i + 1];
        expect(
          next.startPage >= current.startPage,
          isTrue,
          reason: 'Surah ${next.number} page (${next.startPage}) cannot precede Surah ${current.number} page (${current.startPage})',
        );
      }
    });

    test('Juz Index: Exactly 30 Juzs with start pages spanning 1 to 604', () {
      expect(juzs.length, equals(30));

      for (var i = 0; i < 30; i++) {
        final expectedNumber = i + 1;
        expect(juzs[i].number, equals(expectedNumber));
        expect(juzs[i].startPage >= 1 && juzs[i].startPage <= 604, isTrue);
      }
    });
  });
}
