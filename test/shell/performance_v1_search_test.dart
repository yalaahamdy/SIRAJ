import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Federated Search Performance Suite (§37, §74, §123)', () {
    test('Search Perf 1: Search federation across empty stores completes under 100ms (§37, §74)', () async {
      final storage = MemoryStorageRegistry();
      final quranModule = QuranModule(storageRegistry: storage);
      final companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
      );

      final stopwatch = Stopwatch()..start();
      final results = await companionModule.search('رمضان');
      stopwatch.stop();

      // Search federation budget: ≤ 100ms (M25_V1_PERFORMANCE_BUDGET.md)
      // Device: test environment. Build: debug. Dataset: empty in-memory store.
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(results, isNotNull);
    });

    test('Search Perf 2: Search federation with empty query returns quickly (§37)', () async {
      final storage = MemoryStorageRegistry();
      final companionModule = CompanionModule(storageRegistry: storage);

      final stopwatch = Stopwatch()..start();
      final results = await companionModule.search('');
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(results, isNotNull);
    });

    test('Search Perf 3: Multiple sequential searches do not degrade (§37, §74)', () async {
      final storage = MemoryStorageRegistry();
      final companionModule = CompanionModule(storageRegistry: storage);

      for (final query in ['صلاة', 'زكاة', 'حج', 'صيام', 'أذكار']) {
        final stopwatch = Stopwatch()..start();
        await companionModule.search(query);
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      }
    });
  });
}
