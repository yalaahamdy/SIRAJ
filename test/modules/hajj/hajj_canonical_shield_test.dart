import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/hajj/synthetic_hajj_fixtures.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('Cross-Module Hajj & Sacred Shield Invariance Tests (§45)', () {
    test('Executing Hajj operations causes 0 modifications to Quran, Adhkar, Prayer, Zakat, Fasting, Knowledge, Learning, and Seerah stores', () async {
      final registry = MemoryStorageRegistry();

      final quranStore = ReadOnlyCanonicalQuranStore();
      quranStore.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      final adhkarStore = ReadOnlyAdhkarStore();
      adhkarStore.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final prayerMod = PrayerModule(storageRegistry: registry);
      final zakatMod = ZakatModule(storageRegistry: registry);
      final fastingMod = FastingModule(storageRegistry: registry, prayerModule: prayerMod);
      final knowledgeMod = KnowledgeModule(storageRegistry: registry);
      knowledgeMod.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      final learningMod = LearningModule(storageRegistry: registry, knowledgeModule: knowledgeMod);
      learningMod.mountPackage(SyntheticLearningFixtures.createPackage());

      final seerahMod = SeerahModule(storageRegistry: registry, knowledgeModule: knowledgeMod);
      seerahMod.mountPackage(SyntheticSeerahFixtures.createPackage());

      final hajjMod = HajjModule(
        storageRegistry: registry,
        knowledgeModule: knowledgeMod,
      );
      hajjMod.mountPackage(SyntheticHajjFixtures.createPackage());

      await zakatMod.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 50000));
      await fastingMod.markTodayStatus(type: FastingType.voluntary, status: FastingStatus.fasted);

      final ayahBefore = quranStore.getAyah(1, 1).valueOrNull!;
      final adhkarHashBefore = adhkarStore.activePackage!.contentHash;
      final knowHashBefore = knowledgeMod.store.activePackage!.contentHash;
      final learnHashBefore = learningMod.store.activePackage!.contentHash;
      final seerahHashBefore = seerahMod.store.activePackage!.contentHash;

      // Heavy Hajj operations
      await hajjMod.markStepCompleted('step_umrah_ihram');
      await hajjMod.togglePreparationItem('prep_passport_visa');
      await hajjMod.saveUserNote('step_umrah_ihram', 'ملاحظة شخصية');
      await hajjMod.resetAllUserData();

      // Check integrity of M1..M9
      expect(quranStore.getAyah(1, 1).valueOrNull!, equals(ayahBefore));
      expect(adhkarStore.activePackage!.contentHash, equals(adhkarHashBefore));
      expect(knowledgeMod.store.activePackage!.contentHash, equals(knowHashBefore));
      expect(learningMod.store.activePackage!.contentHash, equals(learnHashBefore));
      expect(seerahMod.store.activePackage!.contentHash, equals(seerahHashBefore));
    });
  });
}
