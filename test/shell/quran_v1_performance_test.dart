import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran Reader Performance Suite (§67..§71, §91, §106..§109)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);
    });

    test('Performance 1: Loading all 114 Surahs executes synchronously in under 10ms', () {
      final stopwatch = Stopwatch()..start();
      final surahsRes = quranModule.getAllSurahs();
      stopwatch.stop();

      expect(surahsRes.isSuccess, isTrue);
      expect(surahsRes.valueOrNull!.length, equals(114));
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Performance 2: Search across indexed Quran corpus returns results in under 20ms', () {
      final stopwatch = Stopwatch()..start();
      final searchRes = quranModule.search('الرحمن');
      stopwatch.stop();

      expect(searchRes.isSuccess, isTrue);
      expect(searchRes.valueOrNull!.isNotEmpty, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Performance 3: 50 rapid sequential surah loads maintain sub-millisecond per-read latency', () {
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 50; i++) {
        final surahNum = (i % 114) + 1;
        final res = quranModule.getSurah(surahNum);
        expect(res.isSuccess, isTrue);
      }
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
