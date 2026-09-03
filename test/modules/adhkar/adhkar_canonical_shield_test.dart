import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Adhkar Canonical Sacred Shield & Cross-Module Isolation Tests (§33)', () {
    late MemoryStorageRegistry storage;
    late ReadOnlyCanonicalQuranStore quranStore;
    late AdhkarModule adhkarModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranStore = ReadOnlyCanonicalQuranStore();
      final quranPkg = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(quranPkg);

      adhkarModule = AdhkarModule(
        storageRegistry: storage,
        customClock: const SystemClock(),
      );
      await adhkarModule.initialize();
      final adhkarPkg = CanonicalAdhkarFixture.createValidTestPackage();
      adhkarModule.mountPackage(adhkarPkg);
    });

    test('Executing hundreds of Adhkar operations (progress, favorites, resets) leaves Quran Canonical Store 100% untouched', () async {
      // 1. Snapshot Quran initial state & hash
      final initialSurah1 = quranStore.getSurah(1).valueOrNull!;
      final initialAyah1 = quranStore.getAyah(1, 1).valueOrNull!;
      final initialHash = initialAyah1.integrityHash;

      // 2. Perform hundreds of Adhkar operations
      for (var i = 0; i < 50; i++) {
        await adhkarModule.incrementProgress(contentId: 'dhikr_morning_001', targetCount: 100);
        await adhkarModule.toggleFavorite('dhikr_morning_001');
        adhkarModule.search('اصبحنا');
      }

      // 3. Reset Adhkar data
      await adhkarModule.resetAllUserData();

      // 4. Verify Quran Canonical Store is completely identical
      final postSurah1 = quranStore.getSurah(1).valueOrNull!;
      final postAyah1 = quranStore.getAyah(1, 1).valueOrNull!;

      expect(postAyah1.integrityHash, equals(initialHash));
      expect(postAyah1.textUthmani, equals(initialAyah1.textUthmani));
      expect(postSurah1.nameArabic, equals(initialSurah1.nameArabic));
    });
  });
}
