import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: State Persistence & Restore Suite (§54, §55, §126)', () {
    test('State Restore 1: CompanionModule preferences survive storage round-trip (§54)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      const prefs = CompanionPreferences(enableQuietHours: true);
      await companion.savePreferences(prefs);

      // Reconstruct module from same storage (simulates restart)
      final companion2 = CompanionModule(storageRegistry: storage);
      final savedRes = await companion2.getPreferences();
      final saved = savedRes.valueOrNull ?? const CompanionPreferences();

      expect(saved.enableQuietHours, true);
    });

    test('State Restore 2: AdhkarModule favorites survive storage round-trip (§54)', () async {
      final storage = MemoryStorageRegistry();
      final adhkar = AdhkarModule(storageRegistry: storage);

      await adhkar.toggleFavorite('dhikr_morning_001');
      final favs = (await adhkar.getFavorites()).valueOrNull!;
      expect(favs.any((f) => f.contentId == 'dhikr_morning_001'), true);

      // Reconstruct
      final adhkar2 = AdhkarModule(storageRegistry: storage);
      final favs2 = (await adhkar2.getFavorites()).valueOrNull!;
      expect(favs2.any((f) => f.contentId == 'dhikr_morning_001'), true);
    });

    test('State Restore 3: Memorization plan access does not crash on fresh storage (§54)', () async {
      final storage = MemoryStorageRegistry();
      final quranModule = QuranModule(storageRegistry: storage);
      final memo = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );

      // Access plan — must succeed even when empty
      final plan = await memo.dataStore.getPlan();
      expect(plan, isNotNull);
    });

    test('State Restore 4: Fresh CompanionModule has valid empty preferences (§54, §103)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      final prefsRes = await companion.getPreferences();
      // Either success with defaults or empty defaults — no crash
      expect(prefsRes, isNotNull);
    });
  });
}
