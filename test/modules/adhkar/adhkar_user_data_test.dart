import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('L2 Adhkar User Data Isolation & Local-First Tests (§19, §21, §24)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;
    final now = DateTime.utc(2026, 8, 31, 10, 0);

    setUp(() async {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(
        storageRegistry: storage,
        customClock: TestClock(now),
      );
      await module.initialize();
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Saves and retrieves daily repetition progress strictly in mod_adhkar', () async {
      final initialProg = (await module.getProgress('dhikr_morning_001', 3)).valueOrNull!;
      expect(initialProg.currentCount, equals(0));
      expect(initialProg.isCompleted, isFalse);

      // Increment 1
      final inc1 = (await module.incrementProgress(contentId: 'dhikr_morning_001', targetCount: 3)).valueOrNull!;
      expect(inc1.currentCount, equals(1));
      expect(inc1.isCompleted, isFalse);

      // Increment 2 -> count = 2
      await module.incrementProgress(contentId: 'dhikr_morning_001', targetCount: 3);

      // Increment 3 -> count = 3, isCompleted = true
      final inc3 = (await module.incrementProgress(contentId: 'dhikr_morning_001', targetCount: 3)).valueOrNull!;
      expect(inc3.currentCount, equals(3));
      expect(inc3.isCompleted, isTrue);
    });

    test('Toggles favorite and verifies persistence by content ID only', () async {
      expect((await module.isFavorite('dhikr_morning_001')).valueOrNull, isFalse);

      // Toggle ON
      final onRes = await module.toggleFavorite('dhikr_morning_001');
      expect(onRes.valueOrNull, isTrue);
      expect((await module.isFavorite('dhikr_morning_001')).valueOrNull, isTrue);

      final favs = (await module.getFavorites()).valueOrNull!;
      expect(favs.length, equals(1));
      expect(favs.first.contentId, equals('dhikr_morning_001'));

      // Toggle OFF
      final offRes = await module.toggleFavorite('dhikr_morning_001');
      expect(offRes.valueOrNull, isFalse);
      expect((await module.isFavorite('dhikr_morning_001')).valueOrNull, isFalse);
    });

    test('resetAllUserData clears only mod_adhkar and leaves other stores untouched', () async {
      // Put data in mod_adhkar
      await module.toggleFavorite('dhikr_morning_001');

      // Put dummy data in mod_quran
      final quranStore = storage.getStoreForModule('mod_quran');
      await quranStore.setString('bookmark_1', 'surah_1');

      // Reset Adhkar
      await module.resetAllUserData();

      expect((await module.getFavorites()).valueOrNull, isEmpty);
      expect((await quranStore.getString('bookmark_1')).valueOrNull, equals('surah_1'));
    });
  });
}
