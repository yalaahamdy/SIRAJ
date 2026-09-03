import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — M29 Memorization Experience Adversarial & Integrity Suite (§100, §102..§106)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;

    late CanonicalQuranPackage canonicalPackage;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      canonicalPackage = CanonicalQuranFixture.createValidTestPackage();
      quranModule.store.mountPackage(canonicalPackage);

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();
    });

    test('Adversarial 1 (Canonical Shield): 500 reviews do not alter canonical Quran store package checksum', () async {
      final initialHash = canonicalPackage.contentHash;

      final now = DateTime.utc(2026, 9, 1);
      final item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        state: MemorizationState.learning,
        createdAt: now,
        updatedAt: now,
      );

      var currentItem = item;
      for (int i = 0; i < 500; i++) {
        currentItem = memorizationModule.scheduler.processReview(
          item: currentItem,
          quality: ReviewQuality.good,
          currentDate: now.add(Duration(days: i)),
        );
      }

      final finalHash = canonicalPackage.contentHash;
      expect(finalHash, equals(initialHash));
    });

    test('Adversarial 2 (Corrupted Local Data Recovery): Corrupted local JSON fails gracefully without crashing', () async {
      final memStore = storage.getStoreForModule('mod_memorization');
      await memStore.setString('memorization_items', 'INVALID_JSON_CORRUPT_DATA{{{');

      final itemsRes = await memorizationModule.getAllItems();
      expect(itemsRes.isFailure, isTrue);

      // Safe recovery by saving valid items
      await memorizationModule.dataStore.saveItems([]);
      final recoveredItems = await memorizationModule.getAllItems();
      expect(recoveredItems.isSuccess, isTrue);
      expect(recoveredItems.valueOrNull, isEmpty);
    });

    test('Adversarial 3 (Long-Run 365 Days): Simulating 365 days of mixed user reviews keeps intervals within bounds', () {
      final now = DateTime.utc(2026, 1, 1);
      var item = MemorizationItem(
        ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
        state: MemorizationState.notStarted,
        createdAt: now,
        updatedAt: now,
      );

      for (int day = 0; day < 365; day++) {
        final reviewDate = now.add(Duration(days: day));
        if (item.isDue(reviewDate) || item.state == MemorizationState.notStarted) {
          // Mixed pattern: 70% good, 15% easy, 10% hard, 5% again
          final mod = day % 20;
          final quality = (mod == 0)
              ? ReviewQuality.again
              : (mod <= 2 ? ReviewQuality.hard : (mod <= 17 ? ReviewQuality.good : ReviewQuality.easy));

          item = memorizationModule.scheduler.processReview(
            item: item,
            quality: quality,
            currentDate: reviewDate,
          );

          expect(item.intervalDays, greaterThanOrEqualTo(0));
          expect(item.easeFactor, greaterThanOrEqualTo(1.3));
        }
      }

      expect(item.repetitions, greaterThan(0));
    });

    test('Adversarial 4 (Duplicate Defense): Adding existing Ayah to plan is idempotent', () async {
      const key = AyahKey(surahNumber: 1, ayahNumber: 1);
      await memorizationModule.addAyahToPlan(key);
      await memorizationModule.addAyahToPlan(key);
      await memorizationModule.addAyahToPlan(key);

      final itemsRes = await memorizationModule.getAllItems();
      final matches = itemsRes.valueOrNull!.where((i) => i.ayahKey == key).length;
      expect(matches, equals(1));
    });
  });
}
