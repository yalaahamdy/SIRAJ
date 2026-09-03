import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/store/seerah_user_data_store.dart';

void main() {
  group('L2 Seerah User Data & Local Privacy Isolation Tests (§33, §35)', () {
    late MemoryStorageRegistry registry;
    late SeerahUserDataStore store;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = SeerahUserDataStore(storageRegistry: registry);
    });

    test('Saves and retrieves viewed events, bookmarks, and user notes strictly in mod_seerah', () async {
      await store.markEventViewed('evt_badr_major');
      await store.toggleBookmark('evt_badr_major');
      await store.saveUserNote('evt_badr_major', 'تأمل شخصي في غزوة بدر');

      final progressRes = await store.getProgress();
      expect(progressRes.isSuccess, isTrue);
      final p = progressRes.valueOrNull!;

      expect(p.viewedEventIds.contains('evt_badr_major'), isTrue);
      expect(p.bookmarkedEventIds.contains('evt_badr_major'), isTrue);
      expect(p.userNotes['evt_badr_major'], equals('تأمل شخصي في غزوة بدر'));

      // Verify stored strictly in mod_seerah namespace
      final modStore = registry.getStoreForModule('mod_seerah');
      final rawRes = await modStore.getString('user_seerah_progress');
      expect(rawRes.isSuccess, isTrue);
      expect(rawRes.valueOrNull, contains('تأمل شخصي في غزوة بدر'));
    });

    test('resetAllUserData clears strictly mod_seerah and leaves other module stores untouched', () async {
      await store.markEventViewed('evt_badr_major');

      final otherStore = registry.getStoreForModule('mod_quran');
      await otherStore.setString('bookmark_key', 'surah_1');

      await store.resetAllUserData();

      final pRes = await store.getProgress();
      expect(pRes.valueOrNull!.viewedEventIds.isEmpty, isTrue);

      final otherRes = await otherStore.getString('bookmark_key');
      expect(otherRes.valueOrNull, equals('surah_1'));
    });
  });
}
