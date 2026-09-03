import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/revelation_type.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Quran Golden Structural & Invariant Tests (§18, §21)', () {
    test('Canonical Surah Index strictly contains 114 Surahs in authentic order', () {
      final surahs = CanonicalQuranFixture.create114Surahs();

      expect(surahs.length, equals(114));

      // Surah 1: Al-Fatihah
      expect(surahs[0].number, equals(1));
      expect(surahs[0].nameArabic, equals('الفاتحة'));
      expect(surahs[0].revelationType, equals(RevelationType.meccan));
      expect(surahs[0].ayahCount, equals(7));
      expect(surahs[0].startPage, equals(1));

      // Surah 2: Al-Baqarah
      expect(surahs[1].number, equals(2));
      expect(surahs[1].nameArabic, equals('البقرة'));
      expect(surahs[1].revelationType, equals(RevelationType.medinan));
      expect(surahs[1].ayahCount, equals(286));
      expect(surahs[1].startPage, equals(2));

      // Surah 36: Ya-Sin
      expect(surahs[35].number, equals(36));
      expect(surahs[35].nameArabic, equals('يس'));
      expect(surahs[35].ayahCount, equals(83));

      // Surah 112: Al-Ikhlas
      expect(surahs[111].number, equals(112));
      expect(surahs[111].nameArabic, equals('الإخلاص'));
      expect(surahs[111].ayahCount, equals(4));

      // Surah 114: An-Nas
      expect(surahs[113].number, equals(114));
      expect(surahs[113].nameArabic, equals('الناس'));
      expect(surahs[113].ayahCount, equals(6));
      expect(surahs[113].startPage, equals(604));

      // Verify strictly monotonic numbering
      for (var i = 0; i < 114; i++) {
        expect(surahs[i].number, equals(i + 1));
      }
    });

    test('Canonical Juz Index strictly contains 30 Juzs', () {
      final juzs = CanonicalQuranFixture.create30Juzs();

      expect(juzs.length, equals(30));
      for (var i = 0; i < 30; i++) {
        expect(juzs[i].number, equals(i + 1));
      }
    });
  });
}
