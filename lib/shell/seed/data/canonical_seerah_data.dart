import '../../../modules/seerah/domain/canonical_seerah_package.dart';
import '../../../modules/seerah/domain/historical_period.dart';
import '../../../modules/seerah/domain/person_relationship.dart';
import '../../../modules/seerah/domain/seerah_event.dart';
import 'seerah/seerah_events_part1_data.dart';
import 'seerah/seerah_events_part2_data.dart';
import 'seerah/seerah_persons_data.dart';
import 'seerah/seerah_places_data.dart';

/// Comprehensive, verified canonical Seerah & Islamic History dataset (§28, §29).
/// Contains 3 comprehensive periods, 22 detailed events, 16 historical figures, 15 holy places, and verified relationships.
class CanonicalSeerahData {
  static CanonicalSeerahPackage getPackage() {
    // -------------------------------------------------------------------------
    // 1. Historical Periods (3 Periods)
    // -------------------------------------------------------------------------
    final p1 = HistoricalPeriod(
      periodId: 'prd_makkan',
      titleArabic: 'الفترة المكية وبدء الدعوة والاصطفاء',
      description:
          'من المولد النبوي الشريف والنشأة الكريمة ونزول الوحي بغار حراء والدعوة السرية والجهرية والابتلاءات والهجرتين وعام الحزن والإسراء والمعراج إلى بيعتي العقبة (نحو 53 ق.هـ - 1 هـ / 571 - 622 م).',
      orderIndex: 1,
      startYearDisplay: '53 ق.هـ',
      endYearDisplay: '1 هـ',
    );

    final p2 = HistoricalPeriod(
      periodId: 'prd_medinan_early',
      titleArabic: 'الفترة المدنية الأولى وتأسيس الدولة الإسلامية',
      description:
          'من الهجرة النبوية المباركة وبناء المسجد والمؤاخاة ووثيقة المدينة الدستورية وتحويل القبلة إلى معارك بدر وأحد والخندق وإجلاء بني النضير (1 هـ - 5 هـ / 622 - 627 م).',
      orderIndex: 2,
      startYearDisplay: '1 هـ',
      endYearDisplay: '5 هـ',
    );

    final p3 = HistoricalPeriod(
      periodId: 'prd_medinan_late',
      titleArabic: 'الفترة المدنية المتأخرة والفتوحات الكبرى وعالمية الرسالة',
      description:
          'من صلح الحديبية ورسائل الملوك وفتح خيبر وسرية مؤتة إلى فتح مكة الأعظم وحنين وتبوك وحجة الوداع والوفاة الشريفة بالمدينة (6 هـ - 11 هـ / 628 - 632 م).',
      orderIndex: 3,
      startYearDisplay: '6 هـ',
      endYearDisplay: '11 هـ',
    );

    // -------------------------------------------------------------------------
    // 2. Historical Places (15 Places)
    // -------------------------------------------------------------------------
    final places = SeerahPlacesData.getPlaces();

    // -------------------------------------------------------------------------
    // 3. Historical Persons (16 Figures)
    // -------------------------------------------------------------------------
    final persons = SeerahPersonsData.getPersons();

    // -------------------------------------------------------------------------
    // 4. Seerah Events (22 Comprehensive Pivotal Events)
    // -------------------------------------------------------------------------
    final events = <SeerahEvent>[
      ...SeerahEventsPart1Data.getEvents(),
      ...SeerahEventsPart2Data.getEvents(),
    ];

    // -------------------------------------------------------------------------
    // 5. Documented Historical Relationships
    // -------------------------------------------------------------------------
    final relationships = [
      const PersonRelationship(
        relationshipId: 'rel_prophet_abubakr',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_abu_bakr',
        type: RelationshipType.companionOf,
        description: 'الصحبة التامة ورفقة الهجرة في الغار والمصاهرة والخلافة الراشدة الأولى.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_umar',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_umar',
        type: RelationshipType.companionOf,
        description: 'الصحبة والوزارة والمصاهرة (زواج النبي ﷺ من حفصة رضي الله عنها) والخلافة الثانية.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_uthman',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_uthman',
        type: RelationshipType.companionOf,
        description: 'صهره بزواجه من ابنتيه رقية ثم أم كلثوم رضي الله عنهما والصحبة والتجهيز.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_ali',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_ali',
        type: RelationshipType.companionOf,
        description: 'ابن عمه وزوج ابنته فاطمة الزهراء ووالد سبطيه الحسن والحسين وفدائي الهجرة.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_khadijah',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_khadijah',
        type: RelationshipType.spouseOf,
        description: 'أولى أزواجه وأم أولاده وأول من آمن به مطلقاً وواسته بمالها ونفسها.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_aisha',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_aisha',
        type: RelationshipType.spouseOf,
        description: 'زوجه وحبيبته في بيت النبوة وابنة الصديق وفقيهة الأمة وراوية الحديث.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_fatimah',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_fatimah',
        type: RelationshipType.parentOf,
        description: 'ابنته الحبيبة وبضعته وسيدة نساء أهل الجنة وأم السبطين الحسن والحسين.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_hamzah',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_hamzah',
        type: RelationshipType.companionOf,
        description: 'عمه وأخوه من الرضاعة وأسد الله ورسوله وسيد الشهداء.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_jafar',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_jafar',
        type: RelationshipType.companionOf,
        description: 'ابن عمه، أشبه الناس خلقاً وخلقاً برسول الله، ذو الجناحين وشهيد مؤتة.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_bilal',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_bilal',
        type: RelationshipType.companionOf,
        description: 'مؤذنه الخاص وخازن بيت المال ورمز التوحيد والصبر على البلاء.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_salman',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_salman',
        type: RelationshipType.companionOf,
        description: 'صاحب مشورة حفر الخندق، وقال فيه ﷺ: «سلمان منا أهل البيت».',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_khalid',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_khalid',
        type: RelationshipType.companionOf,
        description: 'قائده العسكري وسيف الله المسلول الذي سله الله على المشركين.',
        sourceId: 'src_bukhari_canonical',
      ),
    ];

    return CanonicalSeerahPackage.create(
      packageId: 'pkg_seerah_canonical_seed_v3_comprehensive',
      periods: [p1, p2, p3],
      events: events,
      persons: persons,
      relationships: relationships,
      places: places,
      signerIdentity: 'siraj.seerah.authority',
      signature: 'sig_canonical_seerah_v3_comprehensive_verified',
      publishedAt: DateTime.utc(2026, 9, 4),
    );
  }
}
