import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/sharawy_item.dart';
import 'package:siraj/modules/quran/store/sharawy_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharawyStore Domain & Catalog Tests (§14, §20)', () {
    late SharawyStore store;

    final sampleItems = [
      const SharawyItem(
        id: 'sharawy_0001',
        cleanTitle: 'مقدمات التفسير - الدرس 1',
        fullTitle: 'مقدمات التفسير - الدرس 1',
        surahNumber: 0,
        surahName: 'المقدمات',
        verseRange: 'الدرس 1',
        scholar: 'الشيخ محمد متولي الشعراوي',
        duration: '40:40',
        durationSeconds: 2440.73,
        url: 'https://archive.org/download/000_Intro1.mp3',
        filename: '000_Intro1.mp3',
        sizeBytes: 7322200,
      ),
      const SharawyItem(
        id: 'sharawy_0005',
        cleanTitle: 'سورة الفاتحة - الآية 1',
        fullTitle: 'سورة الفاتحة - الآية 1',
        surahNumber: 1,
        surahName: 'الفاتحة',
        verseRange: 'الآية 1',
        scholar: 'الشيخ محمد متولي الشعراوي',
        duration: '20:25',
        durationSeconds: 1225.31,
        url: 'https://archive.org/download/001_Al-Fatihah_001.mp3',
        filename: '001_Al-Fatihah_001.mp3',
        sizeBytes: 3675932,
      ),
      const SharawyItem(
        id: 'sharawy_0009',
        cleanTitle: 'سورة البقرة - الآيات 6-16',
        fullTitle: 'سورة البقرة - الآيات 6-16',
        surahNumber: 2,
        surahName: 'البقرة',
        verseRange: 'الآيات 6-16',
        scholar: 'الشيخ محمد متولي الشعراوي',
        duration: '40:03',
        durationSeconds: 2403.6,
        url: 'https://archive.org/download/002_Al-Baqarah(006_016).mp3',
        filename: '002_Al-Baqarah(006_016).mp3',
        sizeBytes: 7210800,
      ),
    ];

    setUp(() {
      store = SharawyStore();
    });

    test('Loads initial items accurately and sets isLoaded flag', () async {
      await store.load(initialItems: sampleItems);

      expect(store.isLoaded, isTrue);
      expect(store.allItems.length, equals(3));
      expect(store.allItems.first.id, equals('sharawy_0001'));
      expect(store.allItems.first.scholar, equals('الشيخ محمد متولي الشعراوي'));
    });

    test('getSurahs returns unique categories including الكل, المفضلة, التنزيلات', () async {
      await store.load(initialItems: sampleItems);

      final surahs = store.getSurahs();
      expect(surahs.contains('الكل'), isTrue);
      expect(surahs.contains('المفضلة'), isTrue);
      expect(surahs.contains('التنزيلات'), isTrue);
      expect(surahs.contains('المقدمات'), isTrue);
      expect(surahs.contains('الفاتحة'), isTrue);
      expect(surahs.contains('البقرة'), isTrue);
    });

    test('Filters by surah category correctly', () async {
      await store.load(initialItems: sampleItems);

      final baqarah = store.filter(surah: 'البقرة');
      expect(baqarah.length, equals(1));
      expect(baqarah.first.cleanTitle, contains('البقرة'));

      final fatihah = store.filter(surah: 'الفاتحة');
      expect(fatihah.length, equals(1));
      expect(fatihah.first.cleanTitle, contains('الفاتحة'));
    });

    test('Search query matches title, surah name, and verse range', () async {
      await store.load(initialItems: sampleItems);

      final searchByAyah = store.filter(query: '6-16');
      expect(searchByAyah.length, equals(1));
      expect(searchByAyah.first.id, equals('sharawy_0009'));

      final searchBySurah = store.filter(query: 'المقدمات');
      expect(searchBySurah.length, equals(1));
      expect(searchBySurah.first.id, equals('sharawy_0001'));
    });

    test('Favorites toggling and filtering', () async {
      await store.load(initialItems: sampleItems);

      expect(store.isFavorite('sharawy_0005'), isFalse);
      expect(store.filter(surah: 'المفضلة').isEmpty, isTrue);

      await store.toggleFavorite('sharawy_0005');
      expect(store.isFavorite('sharawy_0005'), isTrue);

      final favs = store.filter(surah: 'المفضلة');
      expect(favs.length, equals(1));
      expect(favs.first.id, equals('sharawy_0005'));

      await store.toggleFavorite('sharawy_0005');
      expect(store.isFavorite('sharawy_0005'), isFalse);
      expect(store.filter(surah: 'المفضلة').isEmpty, isTrue);
    });

    test('Custom imported item is isolated and appears under التنزيلات', () async {
      await store.load(initialItems: sampleItems);

      const customItem = SharawyItem(
        id: 'sharawy_custom_999',
        cleanTitle: 'درس مستورد خاص بالشيخ الشعراوي',
        fullTitle: 'درس مستورد خاص بالشيخ الشعراوي.mp3',
        surahNumber: 0,
        surahName: 'التنزيلات',
        verseRange: '',
        scholar: 'الشيخ محمد متولي الشعراوي',
        duration: '15:00',
        durationSeconds: 900.0,
        url: '',
        filename: 'custom.mp3',
        sizeBytes: 5000000,
        localFilePath: '/mock/path/custom.mp3',
        isCustomLocal: true,
      );

      store.addCustomItem(customItem);
      expect(store.allItems.length, equals(4));

      final downloads = store.filter(surah: 'التنزيلات');
      expect(downloads.length, equals(1));
      expect(downloads.first.id, equals('sharawy_custom_999'));

      // Original catalog items remain untouched
      expect(store.allItems.any((it) => it.id == 'sharawy_0001'), isTrue);
    });
  });
}
