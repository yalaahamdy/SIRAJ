import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/hajj/domain/canonical_hajj_package.dart';
import 'package:siraj/modules/hajj/domain/hajj_user_progress.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/domain/ritual_step.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/hajj/store/read_only_hajj_store.dart';
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
  group('M10 Hajj & Umrah Forensic / Ritual Safety Audit Suite', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: registry, knowledgeModule: knowledgeModule);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      seerahModule = SeerahModule(storageRegistry: registry, knowledgeModule: knowledgeModule);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());

      hajjModule = HajjModule(
        storageRegistry: registry,
        knowledgeModule: knowledgeModule,
        adhkarModule: adhkarModule,
      );
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
    });

    test('Audit 1: Journey Type Separation & Stream Invariance', () {
      final umrahStepsRes = hajjModule.getStepsForJourney(JourneyType.umrah);
      final hajjTamattuStepsRes = hajjModule.getStepsForJourney(JourneyType.hajjTamattu);

      expect(umrahStepsRes.isSuccess, isTrue);
      expect(hajjTamattuStepsRes.isSuccess, isTrue);

      final umrahSteps = umrahStepsRes.valueOrNull!;
      final hajjSteps = hajjTamattuStepsRes.valueOrNull!;

      expect(umrahSteps.every((s) => s.journeyType == JourneyType.umrah), isTrue);
      expect(hajjSteps.every((s) => s.journeyType == JourneyType.hajjTamattu), isTrue);
      expect(umrahSteps.length, equals(4));
      expect(hajjSteps.length, equals(7));
    });

    test('Audit 2: State Machine & Step Progression Determinism Without Religious Validity Claims', () {
      const progress = HajjUserProgress(
        activeJourneyType: JourneyType.umrah,
        journeyState: JourneyState.inProgress,
        completedStepIds: {'step_umrah_ihram', 'step_umrah_tawaf'},
      );

      final snapRes = hajjModule.journeyEngine.calculateSnapshot(progress);
      expect(snapRes.isSuccess, isTrue);
      final snap = snapRes.valueOrNull!;

      expect(snap.completedStepsCount, equals(2));
      expect(snap.totalSteps, equals(4));
      expect(snap.progressPercentage, equals(50.0));
      expect(snap.currentStep?.stepId, equals('step_umrah_sai'));
      // Snapshot reflects purely user progress without asserting "valid / accepted worship"
      expect(snap.journeyState, equals(JourneyState.inProgress));
    });

    test('Audit 3: Fiqh Options Anti-Collapse & School Attribution Preservation', () {
      final stepRes = hajjModule.getStep('step_umrah_tawaf');
      expect(stepRes.isSuccess, isTrue);
      final step = stepRes.valueOrNull!;

      expect(step.fiqhOptions.isNotEmpty, isTrue);
      final opt = step.fiqhOptions.first;
      expect(opt.schoolOrScholar, equals('الأئمة الأربعة'));
      expect(opt.positionArabic, contains('الطهارة من الحدثين'));
      expect(opt.evidenceSummary, contains('حديث عائشة'));
    });

    test('Audit 4: Ritual Step Ordering & Unique Sequence Identity', () {
      final stepsRes = hajjModule.getStepsForJourney(JourneyType.umrah);
      final steps = stepsRes.valueOrNull!;

      final sequences = steps.map((s) => s.sequence).toList();
      expect(sequences, equals([1, 2, 3, 4]));
      for (final s in steps) {
        expect(s.verifyHash(), isTrue);
      }
    });

    test('Audit 5: Adhkar Integration Resolves from M4 Without Text Duplication', () {
      final refsRes = hajjModule.resolveStepReferences('step_umrah_ihram');
      expect(refsRes.isSuccess, isTrue);
      final refs = refsRes.valueOrNull!;

      expect(refs.adhkar.isNotEmpty, isTrue);
      expect(refs.adhkar.first.textArabic, contains('أَصْبَحْنَا'));
    });

    test('Audit 6: Quran & Hadith Link Traceability Resolves from M7 Knowledge', () {
      final refsRes = hajjModule.resolveStepReferences('step_umrah_ihram');
      expect(refsRes.isSuccess, isTrue);
      final refs = refsRes.valueOrNull!;

      expect(refs.sources.isNotEmpty, isTrue);
      expect(refs.sources.first.title, contains('صحيح البخاري'));
    });

    test('Audit 7: Miqat Service Informational Proximity Bounds (No Binding Fatwa)', () {
      // Near Madinah
      final res = hajjModule.findClosestMiqats(24.412, 39.543);
      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;

      expect(list.first.miqat.nameArabic, equals('ذو الحليفة'));
      expect(list.first.distanceKm, lessThan(1.0));
    });

    test('Audit 8: Sacred Locations & Coordinate Integrity', () {
      final locRes = hajjModule.getLocation('loc_masjid_al_haram');
      expect(locRes.isSuccess, isTrue);
      final loc = locRes.valueOrNull!;

      expect(loc.nameArabic, contains('المسجد الحرام'));
      expect(loc.latitude, closeTo(21.422, 0.01));
      expect(loc.longitude, closeTo(39.826, 0.01));
      expect(loc.verifyHash(), isTrue);
    });

    test('Audit 9: Local-First Privacy & User Note Injection Defense', () async {
      await hajjModule.saveUserNote('step_umrah_ihram', 'ملاحظة شخصية عن الإحرام');

      final progRes = await hajjModule.getUserProgress();
      expect(progRes.isSuccess, isTrue);
      expect(progRes.valueOrNull!.userNotes['step_umrah_ihram'], equals('ملاحظة شخصية عن الإحرام'));

      final stepRes = hajjModule.getStep('step_umrah_ihram');
      final step = stepRes.valueOrNull!;
      expect(step.verifyHash(), isTrue);
      expect(step.description, isNot(contains('ملاحظة شخصية')));
    });

    test('Audit 10: Package Cryptographic Fail-Closed Security', () {
      final validPkg = SyntheticHajjFixtures.createPackage();
      final validStep = validPkg.steps.first;

      final tamperedStep = RitualStep(
        stepId: validStep.stepId,
        journeyType: validStep.journeyType,
        phase: validStep.phase,
        sequence: validStep.sequence,
        title: 'الإحرام من جدة (تحريف غير موثق)',
        description: validStep.description,
        isRequired: validStep.isRequired,
        timeContext: validStep.timeContext,
        sourceIds: validStep.sourceIds,
        integrityHash: validStep.integrityHash,
      );

      final tamperedPkg = CanonicalHajjPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        steps: [tamperedStep, ...validPkg.steps.skip(1)],
        miqats: validPkg.miqats,
        locations: validPkg.locations,
        preparationItems: validPkg.preparationItems,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final testStore = ReadOnlyHajjStore();
      final res = testStore.mountPackage(tamperedPkg);

      expect(res.isFailure, isTrue);
      expect(testStore.isMounted, isFalse);
    });

    test('Audit 11: Cross-Module Sacred Shield Invariance Across All Modules (M1..M10)', () async {
      final quranStore = ReadOnlyCanonicalQuranStore();
      quranStore.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      final prayerMod = PrayerModule(storageRegistry: registry);
      final zakatMod = ZakatModule(storageRegistry: registry);
      final fastingMod = FastingModule(storageRegistry: registry, prayerModule: prayerMod);

      await zakatMod.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 100000));
      await fastingMod.markTodayStatus(type: FastingType.voluntary, status: FastingStatus.fasted);

      final ayahBefore = quranStore.getAyah(1, 1).valueOrNull!;
      final adhkarHashBefore = adhkarModule.store.activePackage!.contentHash;
      final knowHashBefore = knowledgeModule.store.activePackage!.contentHash;
      final learnHashBefore = learningModule.store.activePackage!.contentHash;
      final seerahHashBefore = seerahModule.store.activePackage!.contentHash;

      // Heavy Hajj Operations
      await hajjModule.setJourneyType(JourneyType.hajjTamattu);
      await hajjModule.markStepCompleted('step_tamattu_tarwiyah');
      await hajjModule.togglePreparationItem('prep_passport_visa');
      await hajjModule.saveUserNote('step_tamattu_tarwiyah', 'في الطريق إلى منى');
      await hajjModule.resetAllUserData();

      // Invariance check
      expect(quranStore.getAyah(1, 1).valueOrNull!, equals(ayahBefore));
      expect(adhkarModule.store.activePackage!.contentHash, equals(adhkarHashBefore));
      expect(knowledgeModule.store.activePackage!.contentHash, equals(knowHashBefore));
      expect(learningModule.store.activePackage!.contentHash, equals(learnHashBefore));
      expect(seerahModule.store.activePackage!.contentHash, equals(seerahHashBefore));
    });
  });
}
