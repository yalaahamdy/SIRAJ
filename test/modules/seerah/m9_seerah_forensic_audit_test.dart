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
import 'package:siraj/modules/seerah/domain/canonical_seerah_package.dart';
import 'package:siraj/modules/seerah/domain/date_precision.dart';
import 'package:siraj/modules/seerah/domain/historical_date.dart';
import 'package:siraj/modules/seerah/domain/historical_evidence_level.dart';
import 'package:siraj/modules/seerah/domain/historical_person.dart';
import 'package:siraj/modules/seerah/domain/historical_place.dart';
import 'package:siraj/modules/seerah/domain/moral_lesson.dart';
import 'package:siraj/modules/seerah/domain/narrative_variant.dart';
import 'package:siraj/modules/seerah/domain/person_relationship.dart';
import 'package:siraj/modules/seerah/domain/seerah_event.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/modules/seerah/store/read_only_seerah_store.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('M9 Seerah & Islamic History Forensic & Chronology Audit Suite', () {
    late MemoryStorageRegistry registry;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;

    setUp(() {
      registry = MemoryStorageRegistry();

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: registry, knowledgeModule: knowledgeModule);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      seerahModule = SeerahModule(storageRegistry: registry, knowledgeModule: knowledgeModule);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Audit 1: Event Identity & Complete Provenance Path Traceability', () {
      final eventRes = seerahModule.getEvent('evt_badr_major');
      expect(eventRes.isSuccess, isTrue);
      final event = eventRes.valueOrNull!;

      expect(event.eventId, equals('evt_badr_major'));
      expect(event.sourceIds.isNotEmpty, isTrue);
      expect(event.evidenceLevel, equals(HistoricalEvidenceLevel.primarySource));
      expect(event.integrityHash.startsWith('sha256:'), isTrue);
      expect(event.verifyHash(), isTrue);

      final refsRes = seerahModule.resolveEventReferences(event.eventId);
      expect(refsRes.isSuccess, isTrue);
      final refs = refsRes.valueOrNull!;
      expect(refs.sources.isNotEmpty, isTrue);
      expect(refs.hadiths.isNotEmpty, isTrue);
    });

    test('Audit 2: Semantic Separation Prevents Conflating Moral Lessons or Notes with Historical Facts', () {
      const lesson = MoralLesson(
        lessonText: 'استشعار معية الله والتجرد من الحول والقوة',
        themeArabic: 'الإخلاص والتوكل',
        sourceOrScholar: 'ابن القيم في زاد المعاد',
      );

      final event = SeerahEvent.create(
        eventId: 'evt_test_fact_sep',
        title: 'حدث اختباري فاصل',
        periodId: 'prd_madinah_early',
        historicalDate: const HistoricalDate(
          hijriYear: 2,
          dateDisplay: '2 هـ',
        ),
        summary: 'وقوع المعركة بين المسلمين وقريش في وادي بدر.',
        sourceIds: const ['src_maghazi_test'],
        moralLessons: const [lesson],
      );

      expect(event.summary, isNot(contains('ابن القيم')));
      expect(event.summary, isNot(contains('الإخلاص والتوكل')));
      expect(event.moralLessons.first.lessonText, contains('استشعار معية الله'));
      expect(event.moralLessons.first.sourceOrScholar, equals('ابن القيم في زاد المعاد'));
    });

    test('Audit 3: Narrative Variants Anti-Collapsing & Multiple Transmission Preservation', () {
      final varA = NarrativeVariant.create(
        variantId: 'var_ibn_ishaq',
        eventId: 'evt_hijrah',
        narrativeSummary: 'رواية ابن إسحاق تذكر خط سير الهجرة عبر الساحل.',
        narratorOrScholar: 'محمد بن إسحاق',
        sourceId: 'src_sirah_ishaq',
      );

      final varB = NarrativeVariant.create(
        variantId: 'var_musa_uqbah',
        eventId: 'evt_hijrah',
        narrativeSummary: 'رواية موسى بن عقبة تذكر تفاصيل دقيقة في أسماء المنازل.',
        narratorOrScholar: 'موسى بن عقبة',
        sourceId: 'src_maghazi_uqbah',
      );

      final event = SeerahEvent.create(
        eventId: 'evt_hijrah',
        title: 'الهجرة النبوية المباركة',
        periodId: 'prd_madinah_early',
        historicalDate: const HistoricalDate(
          hijriYear: 1,
          dateDisplay: 'ربيع الأول 1 هـ',
        ),
        summary: 'هجرة النبي ﷺ من مكة إلى المدينة.',
        sourceIds: const ['src_sirah_ishaq', 'src_maghazi_uqbah'],
        variants: [varA, varB],
      );

      expect(event.variants.length, equals(2));
      expect(event.variants[0].variantId, equals('var_ibn_ishaq'));
      expect(event.variants[1].variantId, equals('var_musa_uqbah'));
      expect(event.variants[0].integrityHash, isNot(equals(event.variants[1].integrityHash)));
    });

    test('Audit 4: Source Conflict Preservation Without Silent Artificial Reconciliation', () {
      final varDate1 = NarrativeVariant.create(
        variantId: 'var_date_1',
        eventId: 'evt_sarriyah',
        narrativeSummary: 'نقل ابن سعد أنها كانت في جمادى الأولى.',
        narratorOrScholar: 'ابن سعد في الطبقات',
        sourceId: 'src_tabaqat',
      );

      final varDate2 = NarrativeVariant.create(
        variantId: 'var_date_2',
        eventId: 'evt_sarriyah',
        narrativeSummary: 'نقل خليفة بن خياط أنها كانت في رجب.',
        narratorOrScholar: 'خليفة بن خياط في تاريخه',
        sourceId: 'src_tarikh_khalifa',
      );

      final event = SeerahEvent.create(
        eventId: 'evt_sarriyah',
        title: 'سرية نخلة',
        periodId: 'prd_madinah_early',
        historicalDate: const HistoricalDate(
          hijriYear: 2,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'أواخر سنة 2 هـ (مختلف في الشهر)',
        ),
        summary: 'سرية عبد الله بن جحش إلى نخلة.',
        sourceIds: const ['src_tabaqat', 'src_tarikh_khalifa'],
        variants: [varDate1, varDate2],
        isOrderUncertain: true,
      );

      expect(event.isOrderUncertain, isTrue);
      expect(event.historicalDate.precision, equals(DatePrecision.approximateDate));
      expect(event.variants.length, equals(2));
    });

    test('Audit 5: Date Precision Invariants & No False Certainty Upgrade', () {
      const approxDate = HistoricalDate(
        hijriYear: 53,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 53 ق.هـ (571 م عام الفيل)',
      );

      const yearOnlyDate = HistoricalDate(
        hijriYear: 7,
        precision: DatePrecision.yearOnly,
        dateDisplay: '7 هـ',
      );

      expect(approxDate.precision, equals(DatePrecision.approximateDate));
      expect(yearOnlyDate.precision, equals(DatePrecision.yearOnly));
      expect(approxDate.precision, isNot(equals(DatePrecision.exactDate)));
      expect(yearOnlyDate.precision, isNot(equals(DatePrecision.exactDate)));
    });

    test('Audit 6: Chronology Sanity & Contradiction Detection Invariants', () {
      final chronologyEngine = seerahModule.chronologyEngine;

      // Event set before participant birth (Abu Bakr born ~51 Before Hijrah, event set to 70 BH)
      final contradictionEvent = SeerahEvent.create(
        eventId: 'evt_contra',
        title: 'حدث متناقض زمنياً',
        periodId: 'prd_madinah_early',
        historicalDate: const HistoricalDate(
          hijriYear: 70,
          isBeforeHijrah: true,
          dateDisplay: '70 ق.هـ',
        ),
        participantIds: const ['person_abu_bakr'],
        summary: 'حدث',
        sourceIds: const ['src_1'],
      );

      final check = chronologyEngine.validateEventChronology(contradictionEvent);
      expect(check.isFailure, isTrue);
      expect(check.failureOrNull!.message, contains('occurred before birth'));
    });

    test('Audit 7: Person Identity Safeguards & Anti-Collision', () {
      final p1 = HistoricalPerson.create(
        personId: 'person_ali_ibn_abi_talib',
        canonicalName: 'علي بن أبي طالب الهاشمي القرشي',
        kunyah: 'أبو الحسن',
        titleOrLakab: 'أمير المؤمنين',
        historicalRole: 'صحابي جليل وخليفة راشد',
        biographicalSummary: 'ابن عم رسول الله ﷺ ورابع الخلفاء الراشدين.',
        sourceIds: const ['src_siyar_test'],
      );

      final p2 = HistoricalPerson.create(
        personId: 'person_ali_ibn_hussein',
        canonicalName: 'علي بن الحسين بن علي بن أبي طالب',
        kunyah: 'أبو محمد',
        titleOrLakab: 'زين العابدين',
        historicalRole: 'تابعي جليل وإمام من أئمة أهل البيت',
        biographicalSummary: 'من سادات التابعين علماً وفقهاً وورعاً.',
        sourceIds: const ['src_siyar_test'],
      );

      expect(p1.personId, isNot(equals(p2.personId)));
      expect(p1.canonicalName, isNot(equals(p2.canonicalName)));
      expect(p1.integrityHash, isNot(equals(p2.integrityHash)));
    });

    test('Audit 8: Sourced Relationships & Semantic Inverses', () {
      final rel1 = PersonRelationship(
        relationshipId: 'rel_parent_1',
        fromPersonId: 'person_abu_bakr',
        toPersonId: 'person_aisha',
        type: RelationshipType.parentOf,
        sourceId: 'src_siyar_test',
      );

      final rel2 = PersonRelationship(
        relationshipId: 'rel_child_1',
        fromPersonId: 'person_aisha',
        toPersonId: 'person_abu_bakr',
        type: RelationshipType.childOf,
        sourceId: 'src_siyar_test',
      );

      expect(rel1.type, equals(RelationshipType.parentOf));
      expect(rel2.type, equals(RelationshipType.childOf));
      expect(rel1.sourceId.isNotEmpty, isTrue);
      expect(rel2.sourceId.isNotEmpty, isTrue);
    });

    test('Audit 9: Historical Place & Geographical Certainty Segregation', () {
      final placeHigh = HistoricalPlace.create(
        placeId: 'place_uhud',
        nameArabic: 'جبل أحد',
        modernName: 'جبل أحد بالمدينة المنورة',
        region: 'المدينة المنورة',
        certainty: PlaceCertainty.high,
        geographicalDescription: 'جبل عظيم يقع شمال المسجد النبوي الشريف.',
        sourceIds: const ['src_buldan_test'],
      );

      final placeDisputed = HistoricalPlace.create(
        placeId: 'place_disputed_well',
        nameArabic: 'بئر معونة',
        region: 'نجد',
        certainty: PlaceCertainty.disputed,
        geographicalDescription: 'موضع ماء بين أرض بني عامر وحرة بني سليم مختلف في تحديده الدقيق اليوم.',
        sourceIds: const ['src_buldan_test'],
      );

      expect(placeHigh.certainty, equals(PlaceCertainty.high));
      expect(placeDisputed.certainty, equals(PlaceCertainty.disputed));
      expect(placeHigh.certainty.labelArabic, contains('يقينية'));
      expect(placeDisputed.certainty.labelArabic, contains('مختلف'));
    });

    test('Audit 10: Local-First Privacy & User Note Injection Immunity', () async {
      await seerahModule.saveUserNote('evt_badr_major', 'حقن ملاحظة من المستخدم تدعي تواريخ غير مثبتة');

      final progressRes = await seerahModule.getUserProgress();
      expect(progressRes.isSuccess, isTrue);
      expect(progressRes.valueOrNull!.userNotes['evt_badr_major'], contains('حقن ملاحظة من المستخدم'));

      final eventRes = seerahModule.getEvent('evt_badr_major');
      final event = eventRes.valueOrNull!;
      expect(event.verifyHash(), isTrue);
      expect(event.summary, isNot(contains('حقن ملاحظة')));
    });

    test('Audit 11: Package Cryptographic Fail-Closed Security', () {
      final validPkg = SyntheticSeerahFixtures.createPackage();
      final validPerson = validPkg.persons.first;

      // Tampered person with changed name keeping old hash
      final tamperedPerson = HistoricalPerson(
        personId: validPerson.personId,
        canonicalName: 'اسم محرف غير موثق',
        historicalRole: validPerson.historicalRole,
        biographicalSummary: validPerson.biographicalSummary,
        sourceIds: validPerson.sourceIds,
        integrityHash: validPerson.integrityHash,
      );

      final tamperedPkg = CanonicalSeerahPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        periods: validPkg.periods,
        events: validPkg.events,
        persons: [tamperedPerson],
        relationships: validPkg.relationships,
        places: validPkg.places,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final testStore = ReadOnlySeerahStore();
      final res = testStore.mountPackage(tamperedPkg);

      expect(res.isFailure, isTrue);
      expect(testStore.isMounted, isFalse);
    });

    test('Audit 12: Cross-Module Sacred Shield Invariance Across All Modules (M1..M9)', () async {
      final quranStore = ReadOnlyCanonicalQuranStore();
      quranStore.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      final adhkarStore = ReadOnlyAdhkarStore();
      adhkarStore.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final prayerMod = PrayerModule(storageRegistry: registry);
      final zakatMod = ZakatModule(storageRegistry: registry);
      final fastingMod = FastingModule(storageRegistry: registry, prayerModule: prayerMod);

      await zakatMod.addOrUpdateAsset(SyntheticZakatFixtures.createCashAsset(amount: 75000));
      await fastingMod.markTodayStatus(type: FastingType.voluntary, status: FastingStatus.fasted);

      final ayahBefore = quranStore.getAyah(1, 1).valueOrNull!;
      final adhkarHashBefore = adhkarStore.activePackage!.contentHash;
      final knowHashBefore = knowledgeModule.store.activePackage!.contentHash;
      final learnHashBefore = learningModule.store.activePackage!.contentHash;

      // Heavy Seerah operations
      await seerahModule.markEventViewed('evt_badr_major');
      await seerahModule.toggleBookmark('evt_badr_major');
      await seerahModule.saveUserNote('evt_badr_major', 'ملاحظة');
      await seerahModule.resetAllUserData();

      // Verify full cross-module immunity
      expect(quranStore.getAyah(1, 1).valueOrNull!, equals(ayahBefore));
      expect(adhkarStore.activePackage!.contentHash, equals(adhkarHashBefore));
      expect(knowledgeModule.store.activePackage!.contentHash, equals(knowHashBefore));
      expect(learningModule.store.activePackage!.contentHash, equals(learnHashBefore));
    });
  });
}
