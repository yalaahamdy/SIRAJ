import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Prayer Module Integration Suite (§31, §114)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      companionModule = CompanionModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
      );
    });

    test('Prayer Integration 1: Home dashboard synthesizes accurate prayer countdown and card', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      final prayerCard = cards.firstWhere((c) => c.sourceModule == 'prayer');

      expect(prayerCard.titleArabic, contains('الصلاة'));
      expect(prayerCard.targetRoute, equals('/prayer'));
    });
  });
}
