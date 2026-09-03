import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Performance Suite (§64, §105, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Performance 1: Seerah search completes in < 50ms', () {
      final stopwatch = Stopwatch()..start();
      final res = seerahModule.search('بدر');
      stopwatch.stop();

      expect(res.isSuccess, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Performance 2: Chronology sequencing and validation completes in < 50ms', () {
      final stopwatch = Stopwatch()..start();
      final res = seerahModule.getSequencedTimeline();
      stopwatch.stop();

      expect(res.isSuccess, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });
  });
}
