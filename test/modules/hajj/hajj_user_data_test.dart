import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/store/hajj_user_data_store.dart';

void main() {
  group('L2 Hajj User Data & Local Privacy Isolation Tests (§37, §38)', () {
    late MemoryStorageRegistry registry;
    late HajjUserDataStore store;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = HajjUserDataStore(registry: registry);
    });

    test('Saves and retrieves completed steps, checklist items, and user notes in mod_hajj', () async {
      await store.setJourneyType(JourneyType.hajjTamattu);
      await store.markStepCompleted('step_tamattu_tarwiyah');
      await store.togglePreparationItem('prep_passport_visa');
      await store.saveUserNote('step_tamattu_tarwiyah', 'وصلت إلى منى مع الحملة بسلام.');

      final res = await store.getProgress();
      expect(res.isSuccess, isTrue);
      final progress = res.valueOrNull!;

      expect(progress.activeJourneyType, equals(JourneyType.hajjTamattu));
      expect(progress.completedStepIds, contains('step_tamattu_tarwiyah'));
      expect(progress.checkedPreparationItemIds, contains('prep_passport_visa'));
      expect(progress.userNotes['step_tamattu_tarwiyah'], equals('وصلت إلى منى مع الحملة بسلام.'));
    });

    test('resetAllUserData clears strictly mod_hajj storage and leaves other scopes untouched', () async {
      final otherStore = registry.getStoreForModule('mod_quran');
      await otherStore.setString('bookmark', 'surah_1');

      await store.markStepCompleted('step_umrah_ihram');
      await store.resetAllUserData();

      final res = await store.getProgress();
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull!.completedStepIds.isEmpty, isTrue);

      final otherValueRes = await otherStore.getString('bookmark');
      expect(otherValueRes.isSuccess, isTrue);
      expect(otherValueRes.valueOrNull, equals('surah_1'));
    });
  });
}
