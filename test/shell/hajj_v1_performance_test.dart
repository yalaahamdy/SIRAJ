import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Hajj Performance Suite (§90..§95, §107)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
    });

    test('Performance 1: Canonical package mount executes in < 100ms', () {
      final pkg = SyntheticHajjFixtures.createPackage();
      final sw = Stopwatch()..start();
      final res = hajjModule.mountPackage(pkg);
      sw.stop();

      expect(res.isSuccess, isTrue);
      expect(sw.elapsedMilliseconds, lessThan(100));
    });

    test('Performance 2: Snapshot calculation executes in < 50ms', () async {
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
      await hajjModule.setJourneyType(JourneyType.hajjTamattu);

      final sw = Stopwatch()..start();
      final snapRes = await hajjModule.getJourneySnapshot();
      sw.stop();

      expect(snapRes.isSuccess, isTrue);
      expect(sw.elapsedMilliseconds, lessThan(100));
    });

    test('Performance 3: Miqat distance lookup executes in < 50ms', () {
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());

      final sw = Stopwatch()..start();
      final res = hajjModule.findClosestMiqats(21.42, 39.82);
      sw.stop();

      expect(res.isSuccess, isTrue);
      expect(sw.elapsedMilliseconds, lessThan(50));
    });
  });
}
