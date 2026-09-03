import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Memorization Progress & Mastery Metrics Suite (§29..§31, §100)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();
    });

    test('Progress 1: Mastery snapshot computes completed ayahs and overall score accurately', () async {
      final now = DateTime.utc(2026, 9, 1);
      final items = [
        MemorizationItem(
          ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
          state: MemorizationState.mastered,
          masteryScore: 90.0,
          createdAt: now,
          updatedAt: now,
        ),
        MemorizationItem(
          ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 2),
          state: MemorizationState.learning,
          masteryScore: 50.0,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await memorizationModule.dataStore.saveItems(items);
      final snapshotRes = await memorizationModule.getMasterySnapshot();

      expect(snapshotRes.isSuccess, isTrue);
      final snapshot = snapshotRes.valueOrNull!;
      expect(snapshot.totalTargetedAyahs, equals(2));
      expect(snapshot.totalCompletedAyahs, equals(1));
      expect(snapshot.overallMasteryPercent, greaterThan(0));
    });
  });
}
