import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/tawasheeh_item.dart';
import 'package:siraj/modules/quran/services/tawasheeh_offline_audio_service.dart';
import 'package:siraj/modules/quran/store/tawasheeh_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tawasheeh ZIP Import & Downloads Group Test Suite', () {
    late Directory tempDir;
    late TawasheehOfflineAudioService audioService;
    late TawasheehStore store;

    final baseCatalog = [
      const TawasheehItem(
        id: 'tawasheeh_001',
        cleanTitle: 'ابتهال: إلهى . إن يكن ذنبى عظيما',
        fullTitle: 'إبتهال // إلهى . إن يكن ذنبى عظيما // محمد عمران',
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
    ];

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('tawasheeh_zip_test_');
      audioService = TawasheehOfflineAudioService();
      await audioService.init(overrideBasePath: tempDir.path);

      store = TawasheehStore();
      await store.load(initialItems: List.from(baseCatalog));
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    });

    test('ZIP import does NOT overwrite existing items starting with 01, 02 and creates separate custom items in التنزيلات', () async {
      // 1. Create a dummy ZIP file with 5 tracks named '01 - custom.mp3', '02 - custom.mp3', etc.
      final zipFilePath = '${tempDir.path}${Platform.pathSeparator}test_tawasheeh.zip';
      final archive = Archive();
      for (int i = 1; i <= 5; i++) {
        final trackName = '${i.toString().padLeft(2, '0')} - تسجيل مخصص للشيخ سيد النقشبندي.mp3';
        final dummyBytes = List<int>.filled(2048, 42); // valid > 1024 bytes
        archive.addFile(ArchiveFile(trackName, dummyBytes.length, dummyBytes));
      }
      final zipData = ZipEncoder().encode(archive);
      File(zipFilePath).writeAsBytesSync(zipData!);

      // 2. Import the ZIP
      final result = await audioService.importZipFile(
        zipFilePath: zipFilePath,
        store: store,
      );

      expect(result.isSuccess, isTrue);
      expect(result.importedTracksCount, equals(5));

      // 3. Verify that base catalog items (tawasheeh_001, tawasheeh_002) WERE NOT OVERWRITTEN
      final item1 = store.getById('tawasheeh_001');
      expect(item1, isNotNull);
      expect(item1!.cleanTitle, equals('ابتهال: إلهى . إن يكن ذنبى عظيما'));
      expect(item1.isCustomLocal, isFalse);
      expect(item1.localFilePath, isNull);

      final item2 = store.getById('tawasheeh_002');
      expect(item2, isNotNull);
      expect(item2!.cleanTitle, equals('يا مالك الملك ورب الأرباب'));
      expect(item2.isCustomLocal, isFalse);
      expect(item2.localFilePath, isNull);

      // 4. Verify that 5 separate custom items were added to the store
      expect(store.allItems.length, equals(7)); // 2 catalog + 5 imported
      final customItems = store.allItems.where((it) => it.isCustomLocal).toList();
      expect(customItems.length, equals(5));

      // 5. Verify reciter detection and title cleanup
      final firstCustom = customItems.first;
      expect(firstCustom.reciter, equals('سيد النقشبندي'));
      expect(firstCustom.cleanTitle, contains('تسجيل مخصص للشيخ سيد النقشبندي'));
      expect(firstCustom.cleanTitle.startsWith('01'), isFalse); // number stripped

      // 6. Verify "التنزيلات" group in getReciters()
      final reciters = store.getReciters();
      expect(reciters.contains('التنزيلات'), isTrue);

      // 7. Verify filtering by "التنزيلات"
      final downloadedItems = store.filter(reciter: 'التنزيلات');
      expect(downloadedItems.length, equals(5));

      // 8. Test removeCustomItem
      await store.removeCustomItem(firstCustom.id);
      expect(store.allItems.length, equals(6));
      expect(store.filter(reciter: 'التنزيلات').length, equals(4));
    });
  });
}
