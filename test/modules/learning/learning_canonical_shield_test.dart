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
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('Cross-Module Learning & Sacred Shield Invariance Tests (§47, §51)', () {
    late MemoryStorageRegistry registry;
    late ReadOnlyCanonicalQuranStore quranStore;
    late ReadOnlyAdhkarStore adhkarStore;
    late PrayerModule prayerModule;
    late ZakatModule zakatModule;
    late FastingModule fastingModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;

    setUp(() async {
      registry = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: registry);
      zakatModule = ZakatModule(storageRegistry: registry);
      fastingModule = FastingModule(storageRegistry: registry, prayerModule: prayerModule);
      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      learningModule = LearningModule(storageRegistry: registry, knowledgeModule: knowledgeModule);

      // Mount Quran
      quranStore = ReadOnlyCanonicalQuranStore();
      final quranPkg = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(quranPkg);

      // Mount Adhkar
      adhkarStore = ReadOnlyAdhkarStore();
      final adhkarPkg = CanonicalAdhkarFixture.createValidTestPackage();
      adhkarStore.mountPackage(adhkarPkg);

      // Add Zakat & Fasting
      await zakatModule.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 40000));
      await fastingModule.markTodayStatus(type: FastingType.voluntary, status: FastingStatus.fasted);

      // Mount Knowledge
      final knowPkg = SyntheticKnowledgeFixtures.createPackage();
      knowledgeModule.mountPackage(knowPkg);

      // Mount Learning
      final learnPkg = SyntheticLearningFixtures.createPackage();
      learningModule.mountPackage(learnPkg);
    });

    test('Executing Learning operations causes 0 modifications to Quran, Adhkar, Prayer, Zakat, Fasting, and Knowledge stores', () async {
      final initialAyahRes = quranStore.getAyah(1, 1);
      final initialAyah = initialAyahRes.valueOrNull!;

      final initialAdhkarHash = adhkarStore.activePackage!.contentHash;
      final initialKnowledgeHash = knowledgeModule.store.activePackage!.contentHash;
      final zakatAssetsBefore = (await zakatModule.userDataStore.getAssets()).valueOrNull!.length;
      final fastingRecordsBefore = (await fastingModule.getDayRecords()).valueOrNull!.length;

      // Perform extensive Learning operations
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);
      await learningModule.toggleBookmark('lsn_wudu_pillars');
      await learningModule.saveUserNote('lsn_wudu_pillars', 'ملاحظتي');
      learningModule.evaluateQuiz(quizId: 'quiz_wudu_1', userAnswers: {'q_wudu_count': [0]});
      learningModule.search('الوضوء');
      await learningModule.resetAllUserData();

      // Check invariance across all previous modules
      final afterAyahRes = quranStore.getAyah(1, 1);
      expect(afterAyahRes.valueOrNull!, equals(initialAyah));
      expect(afterAyahRes.valueOrNull!.integrityHash, equals(initialAyah.integrityHash));

      expect(adhkarStore.activePackage!.contentHash, equals(initialAdhkarHash));
      expect(knowledgeModule.store.activePackage!.contentHash, equals(initialKnowledgeHash));

      final zakatAssetsAfter = (await zakatModule.userDataStore.getAssets()).valueOrNull!.length;
      expect(zakatAssetsAfter, equals(zakatAssetsBefore));

      final fastingRecordsAfter = (await fastingModule.getDayRecords()).valueOrNull!.length;
      expect(fastingRecordsAfter, equals(fastingRecordsBefore));
    });
  });
}
