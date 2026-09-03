import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/quran_tafsir.dart';
import 'package:siraj/modules/quran/services/quran_tafsir_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CanonicalTafsirPackage tafsirPackage;
  late QuranTafsirService tafsirService;

  setUpAll(() async {
    tafsirPackage = await CanonicalQuranLoader.loadTafsir();
    tafsirService = DefaultQuranTafsirService(package: tafsirPackage);
  });

  group('M02 Quran Tafsir Subsystem Tests (Al-Tafsir Al-Muyassar)', () {
    test('Canonical Tafsir package loads all 6,236 Ayah records offline', () {
      expect(tafsirPackage.totalRecords, equals(6236));
      expect(tafsirPackage.edition.id, equals('ar.muyassar'));
      expect(tafsirPackage.edition.publisher, contains('مجمع الملك فهد'));
      expect(tafsirService.isAvailable, isTrue);
    });

    test('Retrieves authentic Tafsir for Surah 1 (Al-Fatihah) verses 1..7', () {
      final t1 = tafsirService.getTafsir(1, 1);
      expect(t1, isNotNull);
      expect(t1!.ayahNumber, equals(1));
      expect(t1.tafsirText, contains('باسم الله'));

      final t7 = tafsirService.getTafsir(1, 7);
      expect(t7, isNotNull);
      expect(t7!.ayahNumber, equals(7));
      expect(t7.tafsirText, contains('الصراط المستقيم'));
    });

    test('Retrieves authentic Tafsir for major verses (Ayat Al-Kursi 2:255, Al-Kahf 18:1, An-Nas 114:1)', () {
      final kursi = tafsirService.getTafsir(2, 255);
      expect(kursi, isNotNull);
      expect(kursi!.tafsirText, isNotEmpty);

      final kahf1 = tafsirService.getTafsir(18, 1);
      expect(kahf1, isNotNull);
      expect(kahf1!.tafsirText, isNotEmpty);

      final nas = tafsirService.getTafsir(114, 1);
      expect(nas, isNotNull);
      expect(nas!.ayahNumber, equals(1));
      expect(nas.tafsirText, isNotEmpty);
    });

    test('getSurahTafsir returns all verses of a Surah', () {
      final fatihahTafsirs = tafsirService.getSurahTafsir(1);
      expect(fatihahTafsirs.length, equals(7));

      final nasTafsirs = tafsirService.getSurahTafsir(114);
      expect(nasTafsirs.length, equals(6));
    });

    test('getRangeTafsir returns contiguous range of Tafsir records', () {
      final range = tafsirService.getRangeTafsir(2, 255, 257);
      expect(range.length, equals(3));
      expect(range[0].ayahNumber, equals(255));
      expect(range[1].ayahNumber, equals(256));
      expect(range[2].ayahNumber, equals(257));
    });
  });
}
