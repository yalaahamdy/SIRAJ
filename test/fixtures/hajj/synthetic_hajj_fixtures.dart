import 'package:siraj/modules/hajj/domain/canonical_hajj_package.dart';
import 'package:siraj/modules/hajj/domain/fiqh_option.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/domain/miqat.dart';
import 'package:siraj/modules/hajj/domain/preparation_item.dart';
import 'package:siraj/modules/hajj/domain/ritual_phase.dart';
import 'package:siraj/modules/hajj/domain/ritual_step.dart';
import 'package:siraj/modules/hajj/domain/sacred_location.dart';

class SyntheticHajjFixtures {
  static List<Miqat> createMiqats() {
    return [
      Miqat.create(
        miqatId: 'miqat_dhul_hulayfah',
        nameArabic: 'ذو الحليفة',
        historicalName: 'ذو الحليفة',
        modernName: 'أبيار علي (آبار علي)',
        region: 'المدينة المنورة',
        latitude: 24.412,
        longitude: 39.543,
        distanceFromMakkahKm: 420.0,
        designatedFor: 'أهل المدينة المنورة ومن مر بها',
        sourceId: 'src_bukhari_test',
      ),
      Miqat.create(
        miqatId: 'miqat_al_juhfah',
        nameArabic: 'الجحفة',
        historicalName: 'مهيعة',
        modernName: 'الجحفة (بالقرب من رابغ)',
        region: 'منطقة مكة المكرمة / رابغ',
        latitude: 22.705,
        longitude: 39.146,
        distanceFromMakkahKm: 187.0,
        designatedFor: 'أهل الشام ومصر والمغرب ومن مر بها',
        sourceId: 'src_bukhari_test',
      ),
      Miqat.create(
        miqatId: 'miqat_qarn_al_manazil',
        nameArabic: 'قرن المنازل',
        historicalName: 'قرن الثعالب',
        modernName: 'السيل الكبير / وادي محرم',
        region: 'منطقة الطائف',
        latitude: 21.633,
        longitude: 40.426,
        distanceFromMakkahKm: 75.0,
        designatedFor: 'أهل نجد والطائف ومن جاء من جهتهم',
        sourceId: 'src_bukhari_test',
      ),
      Miqat.create(
        miqatId: 'miqat_yalamlam',
        nameArabic: 'يلملم',
        historicalName: 'يلملم',
        modernName: 'السعدية',
        region: 'منطقة مكة المكرمة / الليث',
        latitude: 20.520,
        longitude: 39.870,
        distanceFromMakkahKm: 100.0,
        designatedFor: 'أهل اليمن ومن مر بها',
        sourceId: 'src_bukhari_test',
      ),
      Miqat.create(
        miqatId: 'miqat_dhat_irq',
        nameArabic: 'ذات عِرق',
        historicalName: 'ذات عرق',
        modernName: 'الضريبة',
        region: 'شمال شرق مكة المكرمة',
        latitude: 21.933,
        longitude: 40.433,
        distanceFromMakkahKm: 94.0,
        designatedFor: 'أهل العراق والمشرق ومن مر بها',
        sourceId: 'src_bukhari_test',
      ),
    ];
  }

  static List<SacredLocation> createLocations() {
    return [
      SacredLocation.create(
        locationId: 'loc_masjid_al_haram',
        nameArabic: 'المسجد الحرام والكعبة المشرفة',
        description: 'أعظم المساجد وقبلة المسلمين، وموضع الطواف.',
        latitude: 21.4225,
        longitude: 39.8262,
        historicalContext: 'بناه إبراهيم وإسماعيل عليهما السلام.',
        sourceId: 'src_bukhari_test',
      ),
      SacredLocation.create(
        locationId: 'loc_safa_marwa',
        nameArabic: 'الصفا والمروة (المسعى)',
        description: 'الجبلان الشريفان موضع السعي بينهما سبعة أشواط.',
        latitude: 21.4230,
        longitude: 39.8275,
        historicalContext: 'شعيرة هاجر عليها السلام وسنة النبي ﷺ.',
        sourceId: 'src_bukhari_test',
      ),
      SacredLocation.create(
        locationId: 'loc_mina',
        nameArabic: 'مشعر مِنَى',
        description: 'موضع المبيت أيام التروية والتشريق، ورمي الجمرات، ونحر الهدي.',
        latitude: 21.4133,
        longitude: 39.8933,
        historicalContext: 'موضع مناسك إبراهيم عليه السلام ورمي الجمار.',
        sourceId: 'src_bukhari_test',
      ),
      SacredLocation.create(
        locationId: 'loc_arafah',
        nameArabic: 'مشعر عرفات (وجبل الرحمة ومسجد نمرة)',
        description: 'موضع الوقوف في اليوم التاسع من ذي الحجة (الركن الأعظم).',
        latitude: 21.3547,
        longitude: 39.9841,
        historicalContext: 'الحج عرفة، وموضع خطبة الوداع.',
        sourceId: 'src_bukhari_test',
      ),
      SacredLocation.create(
        locationId: 'loc_muzdalifah',
        nameArabic: 'مشعر مزدلفة (المشعر الحرام)',
        description: 'موضع المبيت ليلة النحر والجمع بين المغرب والعشاء والتقاط الحصى.',
        latitude: 21.3833,
        longitude: 39.9333,
        historicalContext: 'فإذا أفضتم من عرفات فاذكروا الله عند المشعر الحرام.',
        sourceId: 'src_bukhari_test',
      ),
    ];
  }

  static List<RitualStep> createSteps() {
    return [
      // --- UMRAH STEPS ---
      RitualStep.create(
        stepId: 'step_umrah_ihram',
        journeyType: JourneyType.umrah,
        phase: RitualPhase.miqatAndIhram,
        sequence: 1,
        title: 'الإحرام من الميقات والتلبية',
        description: 'الاغتسال والتطيب للبدن، ولبس إزار ورداء أبيضين للرجل وما تيسر للمرأة، وعقد النية بقول: "لبيك عمرة".',
        isRequired: true,
        locationId: 'miqat_dhul_hulayfah',
        timeContext: 'عند محاذاة الميقات المكاني أو قبله بيسير',
        fiqhOptions: const [
          FiqhOption(
            schoolOrScholar: 'الجمهور',
            positionArabic: 'الإحرام من الميقات واجب يجبر بدم لمن جاوزه بغير إحرام.',
            evidenceSummary: 'حديث المواقيت: "هن لهن ولمن أتى عليهن من غير أهلهن".',
          ),
        ],
        duaAdhkarKeys: const ['dhikr_morning_001'],
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_umrah_tawaf',
        journeyType: JourneyType.umrah,
        phase: RitualPhase.arrivalAndTawaf,
        sequence: 2,
        title: 'طواف العمرة (سبعة أشواط)',
        description: 'الطواف حول الكعبة المشرفة 7 أشواط بدءاً من الحجر الأسود والانتهاء عنده، والاضطباع والرمل في الأشواط الثلاثة الأولى للرجل، ثم صلاة ركعتين خلف المقام.',
        isRequired: true,
        locationId: 'loc_masjid_al_haram',
        timeContext: 'عند الوصول إلى المسجد الحرام',
        fiqhOptions: const [
          FiqhOption(
            schoolOrScholar: 'الأئمة الأربعة',
            positionArabic: 'الطهارة من الحدثين شرط لصحة الطواف عند الجمهور، وسنة عند الحنفية.',
            evidenceSummary: 'حديث عائشة: "أول شيء بدأ به حين قدم أنه توضأ ثم طاف".',
          ),
        ],
        duaAdhkarKeys: const ['dhikr_after_prayer_001'],
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_umrah_sai',
        journeyType: JourneyType.umrah,
        phase: RitualPhase.sai,
        sequence: 3,
        title: 'السعي بين الصفا والمروة (سبعة أشواط)',
        description: 'السعي 7 أشواط تبدأ بالصفا وتنتهي بالمروة، وقراءة آية الصفا عند البدء والدعاء عند ارتقائهما، والهرولة للرجل بين العلمين الأخضرين.',
        isRequired: true,
        locationId: 'loc_safa_marwa',
        timeContext: 'عقب الفراغ من الطواف وركعتي المقام',
        fiqhOptions: const [
          FiqhOption(
            schoolOrScholar: 'الجمهور',
            positionArabic: 'السعي ركن من أركان العمرة والحج، وعند الحنفية واجب.',
            evidenceSummary: 'حديث: "اسعوا فإن الله كتب عليكم السعي".',
          ),
        ],
        duaAdhkarKeys: const ['dhikr_evening_001'],
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_umrah_tahallul',
        journeyType: JourneyType.umrah,
        phase: RitualPhase.tahallul,
        sequence: 4,
        title: 'الحلق أو التقصير والتحلل التام',
        description: 'حلق شعر الرأس كاملاً أو تقصيره من جميع جوانب الرأس للرجل، وتقصير قدر أنملة للمرأة من ضفائرها، وبذلك يحل المعتمر من إحرامه بالكامل.',
        isRequired: true,
        locationId: 'loc_masjid_al_haram',
        timeContext: 'عقب إتمام الشوط السابع من السعي عند المروة',
        fiqhOptions: const [
          FiqhOption(
            schoolOrScholar: 'الجمهور',
            positionArabic: 'الحلق أفضل للرجال من التقصير لأن النبي ﷺ دعا للمحلقين ثلاثاً وللمقصرين مرة.',
            evidenceSummary: 'حديث: "اللهم اغفر للمحلقين".',
          ),
        ],
        sourceIds: const ['src_bukhari_test'],
      ),

      // --- HAJJ TAMATTU' STEPS ---
      RitualStep.create(
        stepId: 'step_tamattu_tarwiyah',
        journeyType: JourneyType.hajjTamattu,
        phase: RitualPhase.tarwiyah,
        sequence: 1,
        title: 'الإحرام بالحج والتوجه إلى منى (يوم التروية 8 ذي الحجة)',
        description: 'الإحرام بالحج صباح يوم 8 ذي الحجة من مسكن الحاج بمكة، والانطلاق إلى منى وصلاة الظهر والعصر والمغرب والعشاء وفجر 9 قصراً بلا جمع والمبيت بها.',
        isRequired: false, // Tarwiyah is sunnah
        locationId: 'loc_mina',
        timeContext: 'صباح اليوم الثامن من ذي الحجة',
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_tamattu_arafah',
        journeyType: JourneyType.hajjTamattu,
        phase: RitualPhase.arafah,
        sequence: 2,
        title: 'الوقوف بعرفة (يوم 9 ذي الحجة - الركن الأعظم)',
        description: 'الانطلاق بعد شروق شمس 9 ذي الحجة إلى عرفة، وصلاة الظهر والعصر جمع تقديم وقصراً بأذان وإقامتين، واستغراق الوقت بالدعاء والتضرع إلى ما بعد غروب الشمس.',
        isRequired: true,
        locationId: 'loc_arafah',
        timeContext: 'من زوال شمس يوم 9 ذي الحجة إلى فجر يوم النحر',
        fiqhOptions: const [
          FiqhOption(
            schoolOrScholar: 'إجماع',
            positionArabic: 'الوقوف بعرفة هو الركن الأعظم الذي يبطل الحج بفوته.',
            evidenceSummary: 'قوله ﷺ: "الحج عرفة".',
          ),
        ],
        duaAdhkarKeys: const ['dhikr_sleep_001'],
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_tamattu_muzdalifah',
        journeyType: JourneyType.hajjTamattu,
        phase: RitualPhase.muzdalifah,
        sequence: 3,
        title: 'الإفاضة إلى مزدلفة والمبيت بها (ليلة 10 ذي الحجة)',
        description: 'الدفع من عرفة بعد الغروب بسكينة إلى مزدلفة، وصلاة المغرب والعشاء جمع تأخير وقصراً، والمبيت بها وصلاة الفجر بمزدلفة وذكر الله عند المشعر الحرام.',
        isRequired: true,
        locationId: 'loc_muzdalifah',
        timeContext: 'ليلة العاشر من ذي الحجة بعد غروب شمس عرفة',
        fiqhOptions: const [
          FiqhOption(
            schoolOrScholar: 'الجمهور',
            positionArabic: 'يجوز للضعفة والنساء الدفع من مزدلفة بعد منتصف الليل لتفادي الزحام.',
            evidenceSummary: 'ترخيص النبي ﷺ لضعفة أهله.',
          ),
        ],
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_tamattu_nahr',
        journeyType: JourneyType.hajjTamattu,
        phase: RitualPhase.nahrAndJamarat,
        sequence: 4,
        title: 'أعمال يوم النحر (رمي جمرة العقبة، الهدي، والحلق)',
        description: 'الانطلاق من مزدلفة إلى منى قبل شروق الشمس، ورمي جمرة العقبة الكبرى بـ 7 حصيات مع التكبير، ثم ذبح الهدي للمتمتع، ثم الحلق أو التقصير (التحلل الأول).',
        isRequired: true,
        locationId: 'loc_mina',
        timeContext: 'يوم النحر (10 ذي الحجة)',
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_tamattu_ifadah',
        journeyType: JourneyType.hajjTamattu,
        phase: RitualPhase.tawafAlIfadah,
        sequence: 5,
        title: 'طواف الإفاضة وسعي الحج (التحلل الأكبر)',
        description: 'التوجه إلى المسجد الحرام لأداء طواف الإفاضة (ركن الحج) سبعة أشواط، ثم سعي الحج بين الصفا والمروة للمتمتع، وبذلك يحل للحاج كل شيء حتى النساء.',
        isRequired: true,
        locationId: 'loc_masjid_al_haram',
        timeContext: 'يوم النحر أو خلال أيام التشريق',
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_tamattu_tashreeq',
        journeyType: JourneyType.hajjTamattu,
        phase: RitualPhase.tashreeq,
        sequence: 6,
        title: 'المبيت بمنى ورمي الجمرات الثلاث (أيام التشريق 11، 12، 13)',
        description: 'المبيت بمنى ليالي التشريق، ورمي الجمرات الثلاث (الصغرى ثم الوسطى ثم الكبرى العقبة) كل جمرة بـ 7 حصيات بعد الزوال كل يوم، والدعاء بعد الصغرى والوسطى.',
        isRequired: true,
        locationId: 'loc_mina',
        timeContext: 'أيام 11 و 12 و 13 ذي الحجة بعد الزوال',
        sourceIds: const ['src_bukhari_test'],
      ),
      RitualStep.create(
        stepId: 'step_tamattu_wada',
        journeyType: JourneyType.hajjTamattu,
        phase: RitualPhase.farewellTawaf,
        sequence: 7,
        title: 'طواف الوداع (خاتمة المناسك)',
        description: 'الطواف بالبيت سبعة أشواط عند إرادة السفر ومغادرة مكة المكرمة ليكون آخر عهد الحاج بالبيت، ويسقط عن الحائض والنفساء.',
        isRequired: true,
        locationId: 'loc_masjid_al_haram',
        timeContext: 'قبيل مغادرة مكة المكرمة مباشرة',
        sourceIds: const ['src_bukhari_test'],
      ),
    ];
  }

  static List<PreparationItem> createPreparationItems() {
    return const [
      PreparationItem(
        itemId: 'prep_passport_visa',
        titleArabic: 'جواز السفر وتأشيرة/تصريح الحج والعمرة',
        description: 'التأكد من سريان الجواز واستخراج التصريح النظامي.',
        category: PreparationCategory.documents,
        isEssential: true,
      ),
      PreparationItem(
        itemId: 'prep_ihram_clothes',
        titleArabic: 'لباس الإحرام (إزار ورداء وحزام) وسجادة صلاة',
        description: 'إزاران أبيضان نظيفان غير مخيطين للرجال ومثبت أو حزام.',
        category: PreparationCategory.ihramEssentials,
        isEssential: true,
      ),
      PreparationItem(
        itemId: 'prep_unscented_soap',
        titleArabic: 'صابون وشامبو ومناديل خالية من العطر',
        description: 'لاستخدامها حال الإحرام تجنباً لمحضورات الطيب.',
        category: PreparationCategory.ihramEssentials,
        isEssential: true,
      ),
      PreparationItem(
        itemId: 'prep_knowledge_guide',
        titleArabic: 'قراءة دليل المناسك وحفظ الأدعية المأثورة',
        description: 'التفقه في صفة حجة النبي ﷺ وأحكام المناسك قبل السفر.',
        category: PreparationCategory.knowledgeAndSpiritual,
        isEssential: true,
      ),
    ];
  }

  static CanonicalHajjPackage createPackage() {
    final steps = createSteps();
    final miqats = createMiqats();
    final locations = createLocations();
    final prepItems = createPreparationItems();

    return CanonicalHajjPackage.create(
      packageId: 'pkg_siraj_canonical_hajj_v1',
      schemaVersion: '1.0.0',
      steps: steps,
      miqats: miqats,
      locations: locations,
      preparationItems: prepItems,
      signerIdentity: 'siraj_hajj_fiqh_board_canonical',
      signature: 'sig_rsa_sha256_canonical_hajj_synthetic_valid',
      publishedAt: DateTime.utc(2026, 8, 31),
    );
  }
}
