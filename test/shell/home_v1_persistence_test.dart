import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Companion Preferences Local Persistence Suite (§67..§70, §114)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    test('Persistence 1: Custom home preferences persist and reload cleanly in a new CompanionModule', () async {
      final module1 = CompanionModule(storageRegistry: storage);
      await module1.savePreferences(
        const CompanionPreferences(
          maxDailyCards: 4,
          hiddenCardIds: {'card_zakat_check'},
        ),
      );

      // Fresh instance over same storage
      final module2 = CompanionModule(storageRegistry: storage);
      final prefRes = await module2.getPreferences();

      expect(prefRes.isSuccess, true);
      final prefs = prefRes.valueOrNull!;
      expect(prefs.maxDailyCards, 4);
      expect(prefs.hiddenCardIds, contains('card_zakat_check'));
    });
  });
}
