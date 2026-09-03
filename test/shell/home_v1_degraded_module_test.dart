import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Degraded Module & Partial Home Fail-Safe Suite (§40, §43..§45, §106, §114)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      // Other modules omitted/unmounted
      companionModule = CompanionModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
      );
    });

    test('Degraded 1: Failure or absence of some modules does not crash Home dashboard (§45, §106)', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.isNotEmpty, true);
      expect(cards.any((c) => c.sourceModule == 'prayer'), true);
    });
  });
}
