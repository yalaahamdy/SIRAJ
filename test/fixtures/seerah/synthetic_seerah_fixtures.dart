import 'package:siraj/modules/seerah/domain/canonical_seerah_package.dart';
import 'package:siraj/modules/seerah/domain/date_precision.dart';
import 'package:siraj/modules/seerah/domain/historical_date.dart';
import 'package:siraj/modules/seerah/domain/historical_evidence_level.dart';
import 'package:siraj/modules/seerah/domain/historical_period.dart';
import 'package:siraj/modules/seerah/domain/historical_person.dart';
import 'package:siraj/modules/seerah/domain/historical_place.dart';
import 'package:siraj/modules/seerah/domain/moral_lesson.dart';
import 'package:siraj/modules/seerah/domain/narrative_variant.dart';
import 'package:siraj/modules/seerah/domain/person_relationship.dart';
import 'package:siraj/modules/seerah/domain/seerah_event.dart';

/// Synthetic fixtures for Seerah & Islamic History testing (§45).
/// Strictly uses synthetic test data without fabricating real religious claims.
class SyntheticSeerahFixtures {
  static HistoricalPeriod createPeriod({
    String id = 'prd_madinah_early',
    String title = 'العهد المدني — التأسيس وبناء المجتمع',
    int order = 5,
  }) {
    return HistoricalPeriod(
      periodId: id,
      titleArabic: title,
      description: 'فترة الهجرة النبوية المباركة وتأسيس المسجد النبوي والمؤاخاة بين المهاجرين والأنصار.',
      orderIndex: order,
      startYearDisplay: '1 هـ',
      endYearDisplay: '3 هـ',
    );
  }

  static HistoricalPerson createPerson({
    String id = 'person_abu_bakr',
    String name = 'أبو بكر الصديق عبد الله بن أبي قحافة',
    String role = 'صحابي جليل وخليفة راشد',
    int birthYear = 51, // 51 Before Hijrah
    int deathYear = 13, // 13 AH
  }) {
    return HistoricalPerson.create(
      personId: id,
      canonicalName: name,
      kunyah: 'أبو بكر',
      titleOrLakab: 'الصديق',
      historicalRole: role,
      birthDate: HistoricalDate(
        hijriYear: birthYear,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 51 ق.هـ (573 م)',
      ),
      deathDate: HistoricalDate(
        hijriYear: deathYear,
        isBeforeHijrah: false,
        precision: DatePrecision.exactDate,
        dateDisplay: '22 جمادى الآخرة 13 هـ (634 م)',
      ),
      biographicalSummary: 'أول الخلفاء الراشدين وأحب الناس إلى رسول الله ﷺ ورفيقه في الهجرة.',
      sourceIds: const ['src_siyar_test'],
      aliases: const ['عبد الله بن عثمان', 'عتيق'],
    );
  }

  static HistoricalPlace createPlace({
    String id = 'place_badr',
    String name = 'بدر',
    String modern = 'محافظة بدر بمنطقة المدينة المنورة',
  }) {
    return HistoricalPlace.create(
      placeId: id,
      nameArabic: name,
      modernName: modern,
      region: 'الحجاز',
      latitude: 23.7833,
      longitude: 38.7833,
      geographicalDescription: 'موضع ماء معروف بين مكة والمدينة على طريق القوافل القديم.',
      certainty: PlaceCertainty.high,
      sourceIds: const ['src_buldan_test'],
    );
  }

  static PersonRelationship createRelationship({
    String id = 'rel_001',
    String fromId = 'person_prophet_muhammad',
    String toId = 'person_abu_bakr',
  }) {
    return PersonRelationship(
      relationshipId: id,
      fromPersonId: fromId,
      toPersonId: toId,
      type: RelationshipType.companionOf,
      description: 'الصحبة التامة ورفقة الهجرة النبوية',
      sourceId: 'src_bukhari_test',
    );
  }

  static NarrativeVariant createVariant({
    String id = 'var_001',
    String eventId = 'evt_badr_major',
  }) {
    return NarrativeVariant.create(
      variantId: id,
      eventId: eventId,
      narrativeSummary: 'رواية موسى بن عقبة تذكر خروج النبي ﷺ في ثلاثمائة وبضعة عشر رجلاً.',
      narratorOrScholar: 'موسى بن عقبة',
      sourceId: 'src_maghazi_test',
      evidenceLevel: HistoricalEvidenceLevel.strongReport,
      scholarlyNotes: 'رواية موسى بن عقبة من أصح كتب المغازي عند المحدثين.',
    );
  }

  static SeerahEvent createEvent({
    String id = 'evt_badr_major',
    String title = 'غزوة بدر الكبرى (يوم الفرقان)',
    String periodId = 'prd_madinah_early',
    String placeId = 'place_badr',
  }) {
    final variant = createVariant(eventId: id);
    const lesson = MoralLesson(
      lessonText: 'النصر والتأييد من عند الله تعالى مع الأخذ بالوسائل والأسباب المشروعة.',
      themeArabic: 'التوكل والأخذ بالأسباب',
      sourceOrScholar: 'الحافظ ابن كثير في البداية والنهاية',
    );

    return SeerahEvent.create(
      eventId: id,
      title: title,
      periodId: periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 2,
        isBeforeHijrah: false,
        hijriMonth: 9,
        hijriDay: 17,
        precision: DatePrecision.exactDate,
        dateDisplay: '17 رمضان 2 هـ (مارس 624 م)',
      ),
      locationId: placeId,
      participantIds: const ['person_abu_bakr'],
      summary: 'أول معركة فاصلة في الإسلام نصر الله فيها رسوله والمؤمنين على مشركي قريش.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_maghazi_test', 'src_bukhari_test'],
      variants: [variant],
      moralLessons: const [lesson],
      relatedQuranAyahs: const ['سورة الأنفال (الآيات 1-19)'],
      relatedHadithIds: const ['hadith_001'],
      isOrderUncertain: false,
      version: 1,
      reviewState: 'APPROVED',
    );
  }

  static CanonicalSeerahPackage createPackage() {
    final period = createPeriod();
    final person = createPerson();
    final place = createPlace();
    final rel = createRelationship(fromId: 'person_prophet', toId: person.personId);
    final event = createEvent(periodId: period.periodId, placeId: place.placeId);

    return CanonicalSeerahPackage.create(
      packageId: 'pkg_seerah_test_v1',
      periods: [period],
      events: [event],
      persons: [person],
      relationships: [rel],
      places: [place],
      signerIdentity: 'siraj.seerah.board',
      signature: 'sig_canonical_valid_seerah_123',
      publishedAt: DateTime.utc(2026, 8, 31),
    );
  }
}
