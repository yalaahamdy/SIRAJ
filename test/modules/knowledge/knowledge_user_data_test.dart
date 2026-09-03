import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/store/knowledge_user_data_store.dart';

void main() {
  group('L2 Knowledge User Data & Privacy Isolation Tests (§33, §36)', () {
    late MemoryStorageRegistry registry;
    late KnowledgeUserDataStore store;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = KnowledgeUserDataStore(storageRegistry: registry);
    });

    test('Saves and retrieves item completion and bookmarks strictly in mod_knowledge', () async {
      await store.markItemCompleted('hadith_001');
      await store.toggleBookmark('topic_niyyah_fasting');
      await store.saveUserNote('hadith_001', 'ملاحظة شخصية حول الحديث');

      final progressRes = await store.getProgress();
      expect(progressRes.isSuccess, isTrue);
      final p = progressRes.valueOrNull!;

      expect(p.completedItemIds.contains('hadith_001'), isTrue);
      expect(p.bookmarkedItemIds.contains('topic_niyyah_fasting'), isTrue);
      expect(p.userNotes['hadith_001'], equals('ملاحظة شخصية حول الحديث'));
      expect(p.lastReadItemId, equals('hadith_001'));
    });

    test('resetAllUserData clears strictly mod_knowledge and leaves other stores untouched', () async {
      await store.markItemCompleted('hadith_001');

      final fastingStore = registry.getStoreForModule('mod_fasting');
      await fastingStore.setString('fast_key', 'some_value');

      await store.resetAllUserData();

      final progressAfter = await store.getProgress();
      expect(progressAfter.valueOrNull!.completedItemIds, isEmpty);

      final fastingVal = await fastingStore.getString('fast_key');
      expect(fastingVal.valueOrNull, equals('some_value')); // Unaffected
    });
  });
}
