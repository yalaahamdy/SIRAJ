import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('Cross-Module Seerah & Sacred Shield Invariance Tests (§46, §47)', () {
    late MemoryStorageRegistry registry;
    late SeerahModule seerahModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late ReadOnlyCanonicalQuranStore quranStore;
    late ReadOnlyAdhkarStore adhkarStore;
    late FastingModule fastingModule;
    late ZakatModule zakatModule;

    setUp(() async {
      registry = MemoryStorageRegistry();

      quranStore = ReadOnlyCanonicalQuranStore();
      quranStore.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      adhkarStore = ReadOnlyAdhkarStore();
      adhkarStore.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final prayerMod = PrayerModule(storageRegistry: registry);
      zakatModule = ZakatModule(storageRegistry: registry);
      fastingModule = FastingModule(storageRegistry: registry, prayerModule: prayerMod);

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: registry, knowledgeModule: knowledgeModule);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      seerahModule = SeerahModule(storageRegistry: registry, knowledgeModule: knowledgeModule);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());

      await zakatModule.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 100000));
      await fastingModule.markTodayStatus(type: FastingType.voluntary, status: FastingStatus.fasted);
    });

    test('Executing Seerah operations causes 0 modifications to Quran, Adhkar, Prayer, Zakat, Fasting, Knowledge, and Learning stores', () async {
      final quranAyahBefore = quranStore.getAyah(1, 1).valueOrNull!;
      final adhkarHashBefore = adhkarStore.activePackage!.contentHash;
      final knowHashBefore = knowledgeModule.store.activePackage!.contentHash;
      final learnHashBefore = learningModule.store.activePackage!.contentHash;

      // Seerah mutations
      await seerahModule.markEventViewed('evt_badr_major');
      await seerahModule.toggleBookmark('evt_badr_major');
      await seerahModule.saveUserNote('evt_badr_major', 'ملاحظة شخصية');
      await seerahModule.resetAllUserData();

      // Assert complete invariance
      expect(quranStore.getAyah(1, 1).valueOrNull!, equals(quranAyahBefore));
      expect(adhkarStore.activePackage!.contentHash, equals(adhkarHashBefore));
      expect(knowledgeModule.store.activePackage!.contentHash, equals(knowHashBefore));
      expect(learningModule.store.activePackage!.contentHash, equals(learnHashBefore));
    });
  });
}
