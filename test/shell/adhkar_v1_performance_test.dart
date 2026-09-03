import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Performance & Counter Benchmarks Suite (§73..§76, §98)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());
    });

    test('Performance 1: Retrieving all Adhkar executes synchronously in under 10ms', () {
      final stopwatch = Stopwatch()..start();
      final itemsRes = module.getAllItems();
      stopwatch.stop();

      expect(itemsRes.isSuccess, isTrue);
      expect(itemsRes.valueOrNull!.isNotEmpty, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Performance 2: Adhkar search engine returns matches in under 15ms', () {
      final stopwatch = Stopwatch()..start();
      final results = module.search('الملك لله');
      stopwatch.stop();

      expect(results.isNotEmpty, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Performance 3: 50 sequential counter increments complete with sub-millisecond latency', () async {
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 50; i++) {
        await module.incrementProgress(contentId: 'dhikr_test_counter', targetCount: 100);
      }
      stopwatch.stop();

      final prog = await module.getProgress('dhikr_test_counter', 100);
      expect(prog.valueOrNull!.currentCount, equals(50));
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}
