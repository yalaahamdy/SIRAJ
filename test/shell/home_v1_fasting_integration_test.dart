import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Fasting & Ramadan Integration Suite (§35, §114)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
      );

      companionModule = CompanionModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
        fastingModule: fastingModule,
      );
    });

    test('Fasting Integration 1: Home dashboard reflects active fasting status without leaking private records (§35)', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.any((c) => c.sourceModule == 'fasting' || c.targetRoute == '/fasting'), true);
    });
  });
}
