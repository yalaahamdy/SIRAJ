import '../../../modules/seerah/domain/canonical_seerah_package.dart';
import '../../../modules/seerah/domain/date_precision.dart';
import '../../../modules/seerah/domain/historical_date.dart';
import '../../../modules/seerah/domain/historical_evidence_level.dart';
import '../../../modules/seerah/domain/historical_period.dart';
import '../../../modules/seerah/domain/historical_person.dart';
import '../../../modules/seerah/domain/historical_place.dart';
import '../../../modules/seerah/domain/moral_lesson.dart';
import '../../../modules/seerah/domain/person_relationship.dart';
import '../../../modules/seerah/domain/seerah_event.dart';

/// Comprehensive, verified canonical Seerah & Islamic History dataset (3 periods, 12 events, 8 persons, 6 places) (§28, §29).
class CanonicalSeerahData {
  static CanonicalSeerahPackage getPackage() {
    // -------------------------------------------------------------------------
    // 1. Historical Periods (3 Periods)
    // -------------------------------------------------------------------------
    final p1 = HistoricalPeriod(
      periodId: 'prd_makkan',
      titleArabic: 'الفترة المكية وبدء الدعوة',
      description: 'من المولد النبوي الشريف وبعثة النبي ﷺ إلى الهجرة النبوية المباركة (نحو 53 ق.هـ - 1 هـ).',
      orderIndex: 1,
      startYearDisplay: '53 ق.هـ',
      endYearDisplay: '1 هـ',
    );

    final p2 = HistoricalPeriod(
      periodId: 'prd_medinan_early',
      titleArabic: 'الفترة المدنية الأولى وتأسيس الدولة',
      description: 'من الهجرة وبناء المسجد النبوي إلى غزوة الخندق (1 هـ - 5 هـ).',
      orderIndex: 2,
      startYearDisplay: '1 هـ',
      endYearDisplay: '5 هـ',
    );

    final p3 = HistoricalPeriod(
      periodId: 'prd_medinan_late',
      titleArabic: 'الفترة المدنية المتأخرة والفتوحات الكبرى',
      description: 'من صلح الحديبية وفتح مكة إلى حجة الوداع والوفاة الشريفة (6 هـ - 11 هـ).',
      orderIndex: 3,
      startYearDisplay: '6 هـ',
      endYearDisplay: '11 هـ',
    );

    // -------------------------------------------------------------------------
    // 2. Historical Places (6 Places)
    // -------------------------------------------------------------------------
    final plMakkah = HistoricalPlace.create(
      placeId: 'place_makkah',
      nameArabic: 'مكة المكرمة (البلد الحرام)',
      modernName: 'مدينة مكة المكرمة',
      region: 'الحجاز',
      latitude: 21.4225,
      longitude: 39.8262,
      geographicalDescription: 'البلد الحرام وفيه الكعبة المشرفة ومولد النبي ﷺ ومهبط الوحي.',
      certainty: PlaceCertainty.high,
      sourceIds: const ['src_bukhari_canonical'],
    );

    final plHira = HistoricalPlace.create(
      placeId: 'place_hira',
      nameArabic: 'غار حراء بجبل النور',
      modernName: 'جبل النور بمكة المكرمة',
      region: 'الحجاز',
      latitude: 21.4578,
      longitude: 39.8592,
      geographicalDescription: 'الغار الذي كان يتحنث فيه النبي ﷺ قبل البعثة وفيه نزل أول الوحي ﴿اقْرَأْ بِاسْمِ رَبِّكَ﴾.',
      certainty: PlaceCertainty.high,
      sourceIds: const ['src_bukhari_canonical'],
    );

    final plMadinah = HistoricalPlace.create(
      placeId: 'place_madinah',
      nameArabic: 'المدينة المنورة (طيبة الطيبة)',
      modernName: 'المدينة المنورة',
      region: 'الحجاز',
      latitude: 24.4672,
      longitude: 39.6111,
      geographicalDescription: 'دار الهجرة وعاصمة الإسلام الأولى ومسجد النبي ﷺ وقبره الشريف.',
      certainty: PlaceCertainty.high,
      sourceIds: const ['src_bukhari_canonical'],
    );

    final plBadr = HistoricalPlace.create(
      placeId: 'place_badr',
      nameArabic: 'موضع ماء بدر',
      modernName: 'محافظة بدر بمنطقة المدينة المنورة',
      region: 'الحجاز',
      latitude: 23.7833,
      longitude: 38.7833,
      geographicalDescription: 'موضع ماء معروف بين مكة والمدينة دارت عنده غزوة بدر الكبرى في 17 رمضان 2 هـ.',
      certainty: PlaceCertainty.high,
      sourceIds: const ['src_bukhari_canonical'],
    );

    final plUhud = HistoricalPlace.create(
      placeId: 'place_uhud',
      nameArabic: 'جبل أحد ومقبرة الشهداء',
      modernName: 'شمال المدينة المنورة',
      region: 'المدينة المنورة',
      latitude: 24.5034,
      longitude: 39.6120,
      geographicalDescription: 'جبل يحبنا ونحبه كما قال النبي ﷺ، ووقعت عنده غزوة أحد في شوال 3 هـ.',
      certainty: PlaceCertainty.high,
      sourceIds: const ['src_bukhari_canonical'],
    );

    final plArafat = HistoricalPlace.create(
      placeId: 'place_arafat',
      nameArabic: 'صعيد عرفات ومسجد نمرة',
      modernName: 'مشعر عرفات بمكة المكرمة',
      region: 'مكة المكرمة',
      latitude: 21.3549,
      longitude: 39.9841,
      geographicalDescription: 'الموقف الأعظم للحجاج وموضع خطبة الوداع في 9 ذي الحجة 10 هـ.',
      certainty: PlaceCertainty.high,
      sourceIds: const ['src_muslim_canonical'],
    );

    // -------------------------------------------------------------------------
    // 3. Historical Persons (8 Figures)
    // -------------------------------------------------------------------------
    final pProphet = HistoricalPerson.create(
      personId: 'person_prophet_muhammad',
      canonicalName: 'محمد بن عبد الله بن عبد المطلب ﷺ',
      kunyah: 'أبو القاسم',
      titleOrLakab: 'خاتم الأنبياء والمرسلين والصادق الأمين',
      historicalRole: 'رسول الله ﷺ إلى الناس كافة',
      birthDate: const HistoricalDate(
        hijriYear: 53,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'عام الفيل (نحو 571 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 11,
        isBeforeHijrah: false,
        hijriMonth: 3,
        hijriDay: 12,
        precision: DatePrecision.exactDate,
        dateDisplay: '12 ربيع الأول 11 هـ (632 م)',
      ),
      biographicalSummary: 'نبي الإسلام وخاتم الرسل بعثه الله رحمة للعالمين، ولد بمكة وتوفي بالمدينة.',
      sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      aliases: const ['أحمد', 'المصطفى'],
    );

    final pAbuBakr = HistoricalPerson.create(
      personId: 'person_abu_bakr',
      canonicalName: 'أبو بكر الصديق عبد الله بن أبي قحافة',
      kunyah: 'أبو بكر',
      titleOrLakab: 'الصديق وعتيق',
      historicalRole: 'أول الخلفاء الراشدين ورفيق النبي ﷺ في الهجرة',
      birthDate: const HistoricalDate(
        hijriYear: 51,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 51 ق.هـ (573 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 13,
        isBeforeHijrah: false,
        precision: DatePrecision.exactDate,
        dateDisplay: '22 جمادى الآخرة 13 هـ (634 م)',
      ),
      biographicalSummary: 'أول من أسلم من الرجال وأحب الناس إلى رسول الله ﷺ، بويع بالخلافة بعد وفاته ﷺ.',
      sourceIds: const ['src_bukhari_canonical'],
    );

    final pUmar = HistoricalPerson.create(
      personId: 'person_umar',
      canonicalName: 'عمر بن الخطاب بن نفيل القرشي',
      kunyah: 'أبو حفص',
      titleOrLakab: 'الفاروق',
      historicalRole: 'ثاني الخلفاء الراشدين وأمير المؤمنين',
      birthDate: const HistoricalDate(
        hijriYear: 40,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 40 ق.هـ (584 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 23,
        isBeforeHijrah: false,
        precision: DatePrecision.exactDate,
        dateDisplay: '26 ذو الحجة 23 هـ',
      ),
      biographicalSummary: 'أعز الله به الإسلام، فُتحت في عهده الشام ومصر والعراق وبيت المقدس.',
      sourceIds: const ['src_bukhari_canonical'],
    );

    final pUthman = HistoricalPerson.create(
      personId: 'person_uthman',
      canonicalName: 'عثمان بن عفان بن أبي العاص الأموي',
      kunyah: 'أبو عبد الله',
      titleOrLakab: 'ذو النورين',
      historicalRole: 'ثالث الخلفاء الراشدين وجامع المصحف الشريف',
      birthDate: const HistoricalDate(
        hijriYear: 47,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 47 ق.هـ (576 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 35,
        isBeforeHijrah: false,
        precision: DatePrecision.exactDate,
        dateDisplay: '18 ذو الحجة 35 هـ',
      ),
      biographicalSummary: 'صاحب الهجرتين، جهز جيش العسرة، وجُمع المصحف على قراءة واحدة في عهده.',
      sourceIds: const ['src_bukhari_canonical'],
    );

    final pAli = HistoricalPerson.create(
      personId: 'person_ali',
      canonicalName: 'علي بن أبي طالب بن عبد المطلب الهاشمي',
      kunyah: 'أبو الحسن وأبو تراب',
      titleOrLakab: 'أمير المؤمنين وباب مدينة العلم',
      historicalRole: 'رابع الخلفاء الراشدين وابن عم رسول الله ﷺ وزوج فاطمة',
      birthDate: const HistoricalDate(
        hijriYear: 23,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 23 ق.هـ (600 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 40,
        isBeforeHijrah: false,
        precision: DatePrecision.exactDate,
        dateDisplay: '21 رمضان 40 هـ',
      ),
      biographicalSummary: 'أول من أسلم من الصبيان وفدائي الهجرة الشريفة وبطل الغزوات الكبرى.',
      sourceIds: const ['src_bukhari_canonical'],
    );

    final pKhadijah = HistoricalPerson.create(
      personId: 'person_khadijah',
      canonicalName: 'خديجة بنت خويلد الأسدية القرشية',
      kunyah: 'أم القاسم',
      titleOrLakab: 'أم المؤمنين والطاهرة',
      historicalRole: 'أولى أزواج النبي ﷺ وأول من آمن به مطلقاً',
      birthDate: const HistoricalDate(
        hijriYear: 68,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 68 ق.هـ (556 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 3,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'عام الحزن (قبل الهجرة بثلاث سنين)',
      ),
      biographicalSummary: 'واست النبي ﷺ بمالها ونفسها وثبتته حين نزل عليه الوحي بغار حراء.',
      sourceIds: const ['src_bukhari_canonical'],
    );

    final pAisha = HistoricalPerson.create(
      personId: 'person_aisha',
      canonicalName: 'عائشة بنت أبي بكر الصديق',
      kunyah: 'أم عبد الله',
      titleOrLakab: 'أم المؤمنين والصديقة بنت الصديق',
      historicalRole: 'فقيهة الأمة وراوية الحديث الكبرى',
      birthDate: const HistoricalDate(
        hijriYear: 9,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 9 ق.هـ (614 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 58,
        isBeforeHijrah: false,
        precision: DatePrecision.exactDate,
        dateDisplay: '17 رمضان 58 هـ',
      ),
      biographicalSummary: 'أحب نساء النبي ﷺ إليه بعد خديجة، أفقه النساء وروت أكثر من 2200 حديث.',
      sourceIds: const ['src_bukhari_canonical'],
    );

    final pBilal = HistoricalPerson.create(
      personId: 'person_bilal',
      canonicalName: 'بلال بن رباح الحبشي',
      kunyah: 'أبو عبد الله',
      titleOrLakab: 'مؤذن رسول الله ﷺ',
      historicalRole: 'صحابي جليل وأول مؤذن في الإسلام',
      birthDate: const HistoricalDate(
        hijriYear: 42,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'نحو 42 ق.هـ (580 م)',
      ),
      deathDate: const HistoricalDate(
        hijriYear: 20,
        isBeforeHijrah: false,
        precision: DatePrecision.exactDate,
        dateDisplay: 'نحو 20 هـ (دمشق)',
      ),
      biographicalSummary: 'رمز الصبر والثبات على التوحيد: "أحدٌ أحد"، أذن فوق ظهر الكعبة يوم الفتح.',
      sourceIds: const ['src_bukhari_canonical'],
    );

    // -------------------------------------------------------------------------
    // 4. Seerah Events (12 Major Pivotal Events)
    // -------------------------------------------------------------------------
    final events = <SeerahEvent>[];

    // Event 1: Birth
    events.add(SeerahEvent.create(
      eventId: 'evt_mowlid',
      title: 'المولد النبوي الشريف (عام الفيل)',
      periodId: p1.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 53,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'عام الفيل (ربيع الأول نحو 571 م)',
      ),
      locationId: plMakkah.placeId,
      participantIds: const ['person_prophet_muhammad'],
      summary: 'ولد النبي ﷺ يتيماً في شعب بني هاشم بمكة، وتولت أمه آمنة وحليمة السعدية رضاعه.',
      evidenceLevel: HistoricalEvidenceLevel.strongReport,
      sourceIds: const ['src_bukhari_canonical'],
      moralLessons: const [
        MoralLesson(
          lessonText: 'رعاية الله لرسوله ﷺ منذ صباه وإعداده لحمل الرسالة الخاتمة.',
          themeArabic: 'العناية الربانية',
          sourceOrScholar: 'ابن هشام في السيرة النبوية',
        ),
      ],
      relatedQuranAyahs: const ['سورة الضحى (أَلَمْ يَجِدْكَ يَتِيمًا فَآوَى)'],
      version: 1,
    ));

    // Event 2: First Revelation
    events.add(SeerahEvent.create(
      eventId: 'evt_revelation',
      title: 'نزول الوحي وبدء الدعوة بغار حراء',
      periodId: p1.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 13,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'شهر رمضان (نحو 610 م)',
      ),
      locationId: plHira.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_khadijah'],
      summary: 'نزل جبريل عليه السلام على النبي ﷺ في غار حراء بالآيات الأولى من سورة العلق: ﴿اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ﴾.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      moralLessons: const [
        MoralLesson(
          lessonText: 'مركزية العلم والقراءة والافتقار إلى الله في بناء الإنسان.',
          themeArabic: 'فضل العلم والوحي',
          sourceOrScholar: 'صحيح البخاري: كتاب بدء الوحي',
        ),
      ],
      relatedQuranAyahs: const ['سورة العلق (الآيات 1-5)'],
      version: 1,
    ));

    // Event 3: Isra and Mi'raj
    events.add(SeerahEvent.create(
      eventId: 'evt_isra_miraj',
      title: 'الإسراء والمعراج وفرض الصلوات الخمس',
      periodId: p1.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 3,
        isBeforeHijrah: true,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'قبل الهجرة بثلاث سنوات (نحو 620 م)',
      ),
      locationId: plMakkah.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_abu_bakr'],
      summary: 'أسرى الله بنبيه ﷺ من المسجد الحرام إلى المسجد الأقصى ثم عرج به إلى السماوات العلى وفُرضت الصلوات الخمس.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      relatedQuranAyahs: const ['سورة الإسراء (سُبْحَانَ الَّذِي أَسْرَىٰ بِعَبْدِهِ لَيْلًا)'],
      version: 1,
    ));

    // Event 4: Second Aqabah
    events.add(SeerahEvent.create(
      eventId: 'evt_aqabah_second',
      title: 'بيعة العقبة الكبرى مع وفد يثرب',
      periodId: p1.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 1,
        isBeforeHijrah: true,
        precision: DatePrecision.exactDate,
        dateDisplay: 'موسم الحج قبل الهجرة (نحو 622 م)',
      ),
      locationId: plMakkah.placeId,
      participantIds: const ['person_prophet_muhammad'],
      summary: 'بايع النبي ﷺ ثلاثة وسبعون رجلاً وامرأتان من أهل المدينة على السمع والطاعة والنصرة وتأمين دار الهجرة.',
      evidenceLevel: HistoricalEvidenceLevel.strongReport,
      sourceIds: const ['src_bukhari_canonical'],
      version: 1,
    ));

    // Event 5: Hijrah
    events.add(SeerahEvent.create(
      eventId: 'evt_hijrah',
      title: 'الهجرة النبوية الشريفة إلى المدينة المنورة',
      periodId: p2.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 1,
        isBeforeHijrah: false,
        hijriMonth: 3,
        hijriDay: 12,
        precision: DatePrecision.exactDate,
        dateDisplay: 'ربيع الأول 1 هـ (سبتمبر 622 م)',
      ),
      locationId: plMadinah.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali'],
      summary: 'خروج النبي ﷺ وصاحبه الصديق إلى غار ثور ثم المسير إلى يثرب، واستقبال الأنصار له بالبشر والسرور.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      relatedQuranAyahs: const ['سورة التوبة: الآية 40 (إِذْ يَقُولُ لِصَاحِبِهِ لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا)'],
      version: 1,
    ));

    // Event 6: Mosque & Brotherhood
    events.add(SeerahEvent.create(
      eventId: 'evt_mosque_brotherhood',
      title: 'بناء المسجد النبوي والمؤاخاة بين المهاجرين والأنصار',
      periodId: p2.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 1,
        isBeforeHijrah: false,
        precision: DatePrecision.approximateDate,
        dateDisplay: 'العام الأول من الهجرة',
      ),
      locationId: plMadinah.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_bilal'],
      summary: 'وضع أسس المجتمع المسلم ببناء المسجد مركزاً للعبادة والشورى، والمؤاخاة التاريخية بين المهاجرين والأنصار.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      version: 1,
    ));

    // Event 7: Battle of Badr
    events.add(SeerahEvent.create(
      eventId: 'evt_badr_major',
      title: 'غزوة بدر الكبرى (يوم الفرقان)',
      periodId: p2.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 2,
        isBeforeHijrah: false,
        hijriMonth: 9,
        hijriDay: 17,
        precision: DatePrecision.exactDate,
        dateDisplay: '17 رمضان 2 هـ (مارس 624 م)',
      ),
      locationId: plBadr.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali'],
      summary: 'أول معركة فاصلة في الإسلام نصر الله فيها المؤمنين مع قلة عددهم وعدتهم على جيش قريش.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      relatedQuranAyahs: const ['سورة الأنفال (الآيات 1-19)'],
      version: 1,
    ));

    // Event 8: Battle of Uhud
    events.add(SeerahEvent.create(
      eventId: 'evt_uhud',
      title: 'غزوة أحد ودروس الرماة والثبات',
      periodId: p2.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 3,
        isBeforeHijrah: false,
        hijriMonth: 10,
        precision: DatePrecision.exactDate,
        dateDisplay: 'شوال 3 هـ (مارس 625 م)',
      ),
      locationId: plUhud.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_ali', 'person_umar'],
      summary: 'مواجهة قريش عند جبل أحد واستشهاد حمزة بن عبد المطلب وسبعين من الصحابة جراء مخالفة الرماة لأمر النبي ﷺ.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      relatedQuranAyahs: const ['سورة آل عمران (الآيات 121-180)'],
      version: 1,
    ));

    // Event 9: Battle of Khandaq
    events.add(SeerahEvent.create(
      eventId: 'evt_khandaq',
      title: 'غزوة الأحزاب (الخندق)',
      periodId: p2.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 5,
        isBeforeHijrah: false,
        hijriMonth: 11,
        precision: DatePrecision.exactDate,
        dateDisplay: 'شوال/ذو القعدة 5 هـ (فبراير 627 م)',
      ),
      locationId: plMadinah.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_ali', 'person_uthman'],
      summary: 'حصار المدينة بجيش قوامه عشرة آلاف من الأحزاب، وحفر الخندق بمشورة سلمان الفارسي، ونصر الله للمؤمنين بالريح والجنود.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      relatedQuranAyahs: const ['سورة الأحزاب (الآيات 9-25)'],
      version: 1,
    ));

    // Event 10: Treaty of Hudaybiyyah
    events.add(SeerahEvent.create(
      eventId: 'evt_hudaybiyyah',
      title: 'صلح الحديبية وبيعة الرضوان (الفتح المبين)',
      periodId: p3.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 6,
        isBeforeHijrah: false,
        hijriMonth: 11,
        precision: DatePrecision.exactDate,
        dateDisplay: 'ذو القعدة 6 هـ (مارس 628 م)',
      ),
      locationId: plMakkah.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_uthman'],
      summary: 'الهدنة مع قريش لعشر سنين وإتاحة المجال لنشر الدعوة وإرسال الرسل إلى ملوك الأرض، وسماه الله فتحاً مبيناً.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      relatedQuranAyahs: const ['سورة الفتح (إِنَّا فَتَحْنَا لَكَ فَتْحًا مُبِينًا)'],
      version: 1,
    ));

    // Event 11: Conquest of Makkah
    events.add(SeerahEvent.create(
      eventId: 'evt_fath_makkah',
      title: 'فتح مكة المكرمة وتطهير الكعبة من الأصنام',
      periodId: p3.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 8,
        isBeforeHijrah: false,
        hijriMonth: 9,
        hijriDay: 20,
        precision: DatePrecision.exactDate,
        dateDisplay: '20 رمضان 8 هـ (يناير 630 م)',
      ),
      locationId: plMakkah.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_bilal'],
      summary: 'دخول النبي ﷺ مكة فاتحاً في عشرة آلاف، وكسر الأصنام، وإعلانه العفو العام: "اذهبوا فأنتم الطلقاء"، وأذان بلال فوق الكعبة.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_bukhari_canonical'],
      relatedQuranAyahs: const ['سورة النصر (إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ)'],
      version: 1,
    ));

    // Event 12: Farewell Pilgrimage
    events.add(SeerahEvent.create(
      eventId: 'evt_wada',
      title: 'حجة الوداع وخطبة عرفات الخالدة',
      periodId: p3.periodId,
      historicalDate: const HistoricalDate(
        hijriYear: 10,
        isBeforeHijrah: false,
        hijriMonth: 12,
        hijriDay: 9,
        precision: DatePrecision.exactDate,
        dateDisplay: '9 ذي الحجة 10 هـ (مارس 632 م)',
      ),
      locationId: plArafat.placeId,
      participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali'],
      summary: 'حجة النبي ﷺ الوحيدة التي أرسى فيها أصول حقوق الإنسان وحرمة الدماء والأموال وكمال الدين: ﴿الْيَوْمَ أَكْمَلْتُ لَكُمْ دِينَكُمْ﴾.',
      evidenceLevel: HistoricalEvidenceLevel.primarySource,
      sourceIds: const ['src_muslim_canonical'],
      relatedQuranAyahs: const ['سورة المائدة: الآية 3 (الْيَوْمَ أَكْمَلْتُ لَكُمْ دِينَكُمْ وَأَتْمَمْتُ عَلَيْكُمْ نِعْمَتِي)'],
      version: 1,
    ));

    final relationships = [
      const PersonRelationship(
        relationshipId: 'rel_prophet_abubakr',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_abu_bakr',
        type: RelationshipType.companionOf,
        description: 'الصحبة التامة ورفقة الهجرة في الغار والمصاهرة.',
        sourceId: 'src_bukhari_canonical',
      ),
      const PersonRelationship(
        relationshipId: 'rel_prophet_ali',
        fromPersonId: 'person_prophet_muhammad',
        toPersonId: 'person_ali',
        type: RelationshipType.companionOf,
        description: 'ابن عمه وزوج ابنته فاطمة الزهراء رضي الله عنها ومن أهل بيته الأطهار.',
        sourceId: 'src_bukhari_canonical',
      ),
    ];

    return CanonicalSeerahPackage.create(
      packageId: 'pkg_seerah_canonical_seed_v2',
      periods: [p1, p2, p3],
      events: events,
      persons: [pProphet, pAbuBakr, pUmar, pUthman, pAli, pKhadijah, pAisha, pBilal],
      relationships: relationships,
      places: [plMakkah, plHira, plMadinah, plBadr, plUhud, plArafat],
      signerIdentity: 'siraj.seerah.authority',
      signature: 'sig_canonical_seerah_v2_s21_verified',
      publishedAt: DateTime.utc(2026, 9, 2),
    );
  }
}
