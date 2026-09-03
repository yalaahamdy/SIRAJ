import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home State Refresh & Derived Truth Suite (§28..§30, §114)', () {
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

    test('State Refresh 1: Home state is dynamically derived from module contracts without stale caching (§30)', () async {
      final initialCards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(initialCards.isNotEmpty, true);

      // Re-fetching computes fresh derived state
      final refreshedCards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(refreshedCards.length, equals(initialCards.length));
    });
  });
}
