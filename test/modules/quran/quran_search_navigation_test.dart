import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranModule quranModule;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    quranModule = QuranModule(storageRegistry: MemoryStorageRegistry());
    quranModule.mountPackage(package);
  });

  group('M02 Quran Search & Navigation Tests', () {
    test('Search returns authentic canonical verse matches with accurate references', () {
      final results = quranModule.search('الرحمن');
      expect(results.isSuccess, isTrue);
      expect(results.valueOrNull, isNotEmpty);

      // Verify search matches include Surah 1 Ayah 1
      expect(
        results.valueOrNull!.any((r) => r.ayah.surahNumber == 1 && r.ayah.ayahNumber == 1),
        isTrue,
      );
    });

    test('Search finds matches in late Surahs (Surah 114 An-Nas)', () {
      final results = quranModule.search('الوسواس');
      expect(results.isSuccess, isTrue);
      expect(results.valueOrNull, isNotEmpty);

      final match = results.valueOrNull!.firstWhere((r) => r.ayah.surahNumber == 114);
      expect(match.ayah.ayahNumber, equals(4));
    });
  });
}
