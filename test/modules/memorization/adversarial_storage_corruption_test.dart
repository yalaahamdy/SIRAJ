import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/store/memorization_user_data_store.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

void main() {
  group('M3 Adversarial Storage Corruption & Data Sanitization Tests (§15, §16)', () {
    late MemoryStorageRegistry storage;
    late MemorizationUserDataStore store;

    setUp(() {
      storage = MemoryStorageRegistry();
      store = MemorizationUserDataStore(storageRegistry: storage);
    });

    test('Sanitizes out-of-bounds metrics (negative intervals, crazy ease factors, out of bound mastery)', () async {
      final corruptedRawList = [
        {
          'ayah_key': '1:1',
          'state': 'memorized',
          'repetitions': 10,
          'lapses': 0,
          'ease_factor': 0.5, // illegally low -> must clamp to 1.3
          'interval_days': -20, // illegally negative -> must clamp to 0
          'mastery_score': 999.9, // illegally high -> must clamp to 100.0
          'created_at': '2026-08-31T12:00:00.000Z',
          'updated_at': '2026-08-31T12:00:00.000Z',
        },
      ];

      final memStore = storage.getStoreForModule('mod_memorization');
      await memStore.setString('memorization_items', jsonEncode(corruptedRawList));

      final itemsRes = await store.getItems();
      expect(itemsRes.isSuccess, isTrue);

      final item = itemsRes.valueOrNull!.first;
      expect(item.easeFactor, equals(1.3));
      expect(item.intervalDays, equals(0));
      expect(item.masteryScore, equals(100.0));
      expect(item.ayahKey, equals(const AyahKey(surahNumber: 1, ayahNumber: 1)));
    });

    test('Malformed JSON returns typed StorageFailure without crashing the application', () async {
      final memStore = storage.getStoreForModule('mod_memorization');
      await memStore.setString('memorization_items', 'INVALID_TRUNCATED_JSON_STREAM_<<<>>>');

      final itemsRes = await store.getItems();
      expect(itemsRes.isFailure, isTrue);
      expect(itemsRes.failureOrNull?.message.contains('Corrupted'), isTrue);
    });
  });
}
