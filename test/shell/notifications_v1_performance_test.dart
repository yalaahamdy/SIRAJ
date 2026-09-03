import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Reminder Orchestration Performance Suite (§81..§84, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Performance 1: Daily reminder generation and deduplication executes in < 50ms (§81)', () async {
      final stopwatch = Stopwatch()..start();
      final res = await companionModule.getReminders();
      stopwatch.stop();

      expect(res.isSuccess, true);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });
  });
}
