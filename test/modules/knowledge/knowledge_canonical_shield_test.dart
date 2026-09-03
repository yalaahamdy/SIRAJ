import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('Cross-Module Knowledge & Sacred Shield Invariance Tests (§41, §49)', () {
    late MemoryStorageRegistry registry;
    late ReadOnlyCanonicalQuranStore quranStore;
    late ReadOnlyAdhkarStore adhkarStore;
    late PrayerModule prayerModule;
    late ZakatModule zakatModule;
    late FastingModule fastingModule;
    late KnowledgeModule knowledgeModule;

    setUp(() async {
      registry = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: registry);
      zakatModule = ZakatModule(storageRegistry: registry);
      fastingModule = FastingModule(storageRegistry: registry, prayerModule: prayerModule);
      knowledgeModule = KnowledgeModule(storageRegistry: registry);

      // Mount Canonical Quran
      quranStore = ReadOnlyCanonicalQuranStore();
      final quranPkg = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(quranPkg);

      // Mount Canonical Adhkar
      adhkarStore = ReadOnlyAdhkarStore();
      final adhkarPkg = CanonicalAdhkarFixture.createValidTestPackage();
      adhkarStore.mountPackage(adhkarPkg);

      // Add Zakat & Fasting data
      await zakatModule.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 50000));
      await fastingModule.markTodayStatus(type: FastingType.voluntary, status: FastingStatus.fasted);

      // Mount Knowledge Package
      final knowPkg = SyntheticKnowledgeFixtures.createPackage();
      knowledgeModule.mountPackage(knowPkg);
    });

    test('Executing Knowledge operations causes 0 modifications to Quran, Adhkar, Prayer, Zakat, and Fasting stores', () async {
      final initialAyahRes = quranStore.getAyah(1, 1);
      expect(initialAyahRes.isSuccess, isTrue);
      final initialAyah = initialAyahRes.valueOrNull!;

      final initialAdhkarHash = adhkarStore.activePackage!.contentHash;
      final zakatAssetsBefore = (await zakatModule.userDataStore.getAssets()).valueOrNull!.length;
      final fastingRecordsBefore = (await fastingModule.getDayRecords()).valueOrNull!.length;

      // Perform extensive Knowledge operations
      await knowledgeModule.markCompleted('hadith_001');
      await knowledgeModule.toggleBookmark('topic_niyyah_fasting');
      await knowledgeModule.saveNote('hadith_001', 'ملاحظة');
      knowledgeModule.search('الاعمال');
      await knowledgeModule.resetAllUserData();

      // Check invariance across all previous modules
      final afterAyahRes = quranStore.getAyah(1, 1);
      expect(afterAyahRes.isSuccess, isTrue);
      expect(afterAyahRes.valueOrNull!, equals(initialAyah));
      expect(afterAyahRes.valueOrNull!.integrityHash, equals(initialAyah.integrityHash));

      expect(adhkarStore.activePackage!.contentHash, equals(initialAdhkarHash));

      final zakatAssetsAfter = (await zakatModule.userDataStore.getAssets()).valueOrNull!.length;
      expect(zakatAssetsAfter, equals(zakatAssetsBefore));

      final fastingRecordsAfter = (await fastingModule.getDayRecords()).valueOrNull!.length;
      expect(fastingRecordsAfter, equals(fastingRecordsBefore));
    });
  });
}
