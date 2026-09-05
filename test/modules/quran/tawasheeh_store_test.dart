import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/tawasheeh_item.dart';
import 'package:siraj/modules/quran/store/tawasheeh_store.dart';

void main() {
  group('TawasheehStore Test Suite (§14, §20)', () {
    late TawasheehStore store;

    final sampleItems = [
      const TawasheehItem(
        id: 'tawasheeh_001',
        cleanTitle: 'ابتهال: إلهى . إن يكن ذنبى عظيما',
        fullTitle: 'إبتهال 270214 // إلهى . إن يكن ذنبى عظيما // محمد عمران',
        reciter: 'محمد عمران',
        duration: '03:59',
        durationSeconds: 239.39,
        url: 'https://archive.org/download/2071215/sample1.mp3',
      ),
      const TawasheehItem(
        id: 'tawasheeh_002',
        cleanTitle: 'يا مالك الملك ورب الأرباب',
        fullTitle: 'يا مالك الملك - الشيخ نصر الدين طوبار',
        reciter: 'نصر الدين طوبار',
        duration: '06:12',
        durationSeconds: 372.0,
        url: 'https://archive.org/download/2071215/sample2.mp3',
      ),
      const TawasheehItem(
        id: 'tawasheeh_003',
        cleanTitle: 'يا رب ساعدنا واهدينا',
        fullTitle: 'يا رب ساعدنا واهدينا - الشيخ كامل يوسف البهتيمي',
        reciter: 'كامل يوسف البهتيمي',
        duration: '02:59',
        durationSeconds: 179.83,
        url: 'https://archive.org/download/2071215/sample3.mp3',
      ),
    ];

    setUp(() {
      store = TawasheehStore();
    });

    test('Loads initial items correctly and sets isLoaded to true', () async {
      expect(store.isLoaded, isFalse);
      await store.load(initialItems: sampleItems);

      expect(store.isLoaded, isTrue);
      expect(store.allItems.length, equals(3));
      expect(store.allItems.first.reciter, equals('محمد عمران'));
    });

    test('Filters correctly by reciter name', () async {
      await store.load(initialItems: sampleItems);

      final tobarItems = store.filter(reciter: 'نصر الدين طوبار');
      expect(tobarItems.length, equals(1));
      expect(tobarItems.first.cleanTitle, contains('يا مالك الملك'));

      final allItems = store.filter(reciter: 'الكل');
      expect(allItems.length, equals(3));
    });

    test('Filters correctly by search query in title or reciter', () async {
      await store.load(initialItems: sampleItems);

      final searchResults = store.filter(query: 'ساعدنا');
      expect(searchResults.length, equals(1));
      expect(searchResults.first.reciter, equals('كامل يوسف البهتيمي'));

      final reciterSearch = store.filter(query: 'عمران');
      expect(reciterSearch.length, equals(1));
      expect(reciterSearch.first.id, equals('tawasheeh_001'));
    });

    test('Returns unique sorted reciters list with "الكل" as first element', () async {
      await store.load(initialItems: sampleItems);

      final reciters = store.getReciters();
      expect(reciters.first, equals('الكل'));
      expect(reciters.contains('محمد عمران'), isTrue);
      expect(reciters.contains('نصر الدين طوبار'), isTrue);
      expect(reciters.contains('كامل يوسف البهتيمي'), isTrue);
      expect(reciters.length, equals(4)); // 'الكل' + 3 reciters
    });

    test('Retrieves item by ID successfully', () async {
      await store.load(initialItems: sampleItems);

      final item = store.getById('tawasheeh_002');
      expect(item, isNotNull);
      expect(item!.cleanTitle, equals('يا مالك الملك ورب الأرباب'));

      final nonExistent = store.getById('tawasheeh_999');
      expect(nonExistent, isNull);
    });

    test('Loads fallback seed items if asset loading fails', () async {
      // Calling load without parameters in non-asset test environment uses fallback
      await store.load();
      expect(store.isLoaded, isTrue);
      expect(store.allItems.isNotEmpty, isTrue);
    });

    test('Favorites toggle, persist, and filtering works correctly', () async {
      await store.load(initialItems: sampleItems);

      expect(store.isFavorite('tawasheeh_001'), isFalse);
      await store.toggleFavorite('tawasheeh_001');
      expect(store.isFavorite('tawasheeh_001'), isTrue);
      expect(store.favoriteIds.contains('tawasheeh_001'), isTrue);

      final favOnly = store.filter(onlyFavorites: true);
      expect(favOnly.length, equals(1));
      expect(favOnly.first.id, equals('tawasheeh_001'));

      await store.toggleFavorite('tawasheeh_001');
      expect(store.isFavorite('tawasheeh_001'), isFalse);
      expect(store.filter(onlyFavorites: true), isEmpty);
    });

    test('updateLocalPath attaches offline file path properly', () async {
      await store.load(initialItems: sampleItems);

      store.updateLocalPath('tawasheeh_001', '/data/user/0/siraj/t1.mp3');
      final updated = store.getById('tawasheeh_001');
      expect(updated?.localFilePath, equals('/data/user/0/siraj/t1.mp3'));
      expect(updated?.isOfflineAvailable, isTrue);
    });
  });
}
