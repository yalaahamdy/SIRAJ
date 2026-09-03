import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Adversarial & Degradation Resilience Suite (§99, §100, §101)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());
    });

    test('Adversarial 1: Querying non-existent Dhikr ID returns failure and does not fabricate content', () {
      final res = module.getItemById('non_existent_dhikr_id_999');
      expect(res.isFailure, isTrue);
    });

    test('Adversarial 2: Corrupted favorites storage is repaired/ignored safely without crashing', () async {
      final store = storage.getStoreForModule('mod_adhkar');
      await store.setString('adhkar_favorites', 'corrupted_json_payload_xyz');

      final favsRes = await module.getFavorites();
      expect(favsRes.isSuccess, isTrue);
      expect(favsRes.valueOrNull, isEmpty);
    });

    test('Adversarial 3: Corrupted progress storage falls back to fresh clean progress', () async {
      final store = storage.getStoreForModule('mod_adhkar');
      await store.setString('adhkar_progress_dhikr_001', 'corrupted_progress');

      final progRes = await module.getProgress('dhikr_001', 33);
      expect(progRes.isSuccess, isTrue);
      expect(progRes.valueOrNull!.currentCount, equals(0));
    });

    test('Adversarial 4: Unmounted module fails closed without fabricating items', () {
      final emptyStorage = MemoryStorageRegistry();
      final unmountedModule = AdhkarModule(storageRegistry: emptyStorage);

      final res = unmountedModule.getAllItems();
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('No Adhkar package is currently mounted'));
    });

    test('Adversarial 5 (Canonical Shield): Incrementing counter and favoriting does NOT modify canonical store items', () async {
      final originalItems = module.getAllItems().valueOrNull!;
      final originalText = originalItems.first.textArabic;
      final originalCount = originalItems.first.repetition.count;

      // Perform user actions
      await module.incrementProgress(contentId: originalItems.first.id, targetCount: originalCount);
      await module.toggleFavorite(originalItems.first.id);

      // Re-fetch from store
      final postItems = module.getAllItems().valueOrNull!;
      expect(postItems.first.textArabic, equals(originalText));
      expect(postItems.first.repetition.count, equals(originalCount));
      expect(postItems.first.integrityHash, equals(originalItems.first.integrityHash));
    });
  });
}
