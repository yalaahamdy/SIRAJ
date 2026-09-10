import '../../../modules/learning/domain/canonical_learning_package.dart';
import '../../../modules/learning/domain/course.dart';
import '../../../modules/learning/domain/course_module.dart';
import '../../../modules/learning/domain/learning_path.dart' as lp;
import '../../../modules/learning/domain/lesson.dart';
import '../../../modules/learning/domain/quiz.dart';
import 'learning/aqidah/learning_aqidah_afterlife_data.dart';
import 'learning/aqidah/learning_aqidah_messengers_data.dart';
import 'learning/aqidah/learning_aqidah_qadar_data.dart';
import 'learning/aqidah/learning_aqidah_sunnah_data.dart';
import 'learning/aqidah/learning_aqidah_tawheed_data.dart';
import 'learning/learning_fasting_data.dart';
import 'learning/learning_hajj_data.dart';
import 'learning/learning_salah_data.dart';
import 'learning/hadith/learning_hadith_grading_rules_data.dart';
import 'learning/hadith/learning_hadith_mustalah_intro_data.dart';
import 'learning/hadith/learning_hadith_nawawi_part1_data.dart';
import 'learning/hadith/learning_hadith_nawawi_part2_data.dart';
import 'learning/learning_taharah_data.dart';
import 'learning/learning_zakah_data.dart';
import 'learning/quran_sciences/learning_quran_sciences_data.dart';
import 'learning/quran_sciences/learning_quran_tafsir_mufassal_data.dart';
import 'learning/quran_sciences/learning_quran_tafsir_rules_data.dart';
import 'learning/quran_sciences/learning_quran_tajweed_data.dart';
import 'learning/muamalat/learning_muamalat_buyu_data.dart';
import 'learning/muamalat/learning_muamalat_contemporary_banking_data.dart';
import 'learning/muamalat/learning_muamalat_qawaid_maqasid_data.dart';
import 'learning/muamalat/learning_muamalat_usul_fiqh_data.dart';
import 'learning/seerah/learning_seerah_makkan_data.dart';
import 'learning/seerah/learning_seerah_medinan_data.dart';
import 'learning/seerah/learning_seerah_shamail_data.dart';
import 'learning/family_and_society/learning_family_inheritance_data.dart';
import 'learning/family_and_society/learning_ethics_adab_tarbiyah_data.dart';
import 'learning/family_and_society/learning_dawah_hisbah_dialogue_data.dart';
import 'learning/family_and_society/learning_thought_awareness_data.dart';
import 'learning/governance_and_judiciary/learning_judiciary_evidence_data.dart';
import 'learning/governance_and_judiciary/learning_siyasah_shariyyah_governance_data.dart';
import 'learning/governance_and_judiciary/learning_international_relations_treaties_data.dart';
import 'learning/governance_and_judiciary/learning_human_rights_liberties_data.dart';
import 'learning/medical_and_environment/learning_medical_surgeries_transplants_data.dart';
import 'learning/medical_and_environment/learning_genetics_assisted_reproduction_data.dart';
import 'learning/medical_and_environment/learning_epidemics_public_health_dispensations_data.dart';
import 'learning/medical_and_environment/learning_environment_earth_stewardship_data.dart';

/// Comprehensive canonical learning and curriculum dataset (Phases 1 through 9)
/// Covers 9 major tracks: Fiqh of Worship, Islamic Creed (Aqidah), Quranic Sciences & Tafsir, Hadith Sciences, Seerah & Islamic History, Contemporary Financial Fiqh & Usul al-Fiqh, Family Fiqh & Ethics, Judiciary & Governance, and Contemporary Medical Fiqh, Bioethics & Environmental Stewardship
/// Includes 46 learning paths, 37 advanced courses, 74 modules, 230 in-depth lessons, and 94 quizzes (§31..§35).
class CanonicalLearningData {
  static CanonicalLearningPackage getPackage() {
    // -------------------------------------------------------------------------
    // 1. Learning Paths (المسارات التعليمية المعتمدة)
    // -------------------------------------------------------------------------

    // --- A. مسارات فقه العبادات الموسع والتأصيلي ---
    final pathFiqhComprehensive = lp.LearningPath.create(
      pathId: 'path_fiqh_worship_comprehensive',
      title: 'مسار فقه العبادات الموسع والتأصيلي',
      description: 'مسار منهجي موسوعي تأصيلي يغطي فقه أركان الإسلام العملية: الطهارة والمياه، الصلاة وسجود السهو والجنائز، الزكاة والأنصبة المعاصرة، الصيام ومقاصده ونوازله، والحج والعمرة والزيارة النبوية.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const [
        LearningTaharahData.courseId,
        LearningSalahData.courseId,
        LearningZakahData.courseId,
        LearningFastingData.courseId,
        LearningHajjData.courseId,
      ],
      estimatedHours: 25,
    );

    final pathTaharah = lp.LearningPath.create(
      pathId: 'path_fiqh_taharah',
      title: 'مسار فقه الطهارة والمياه والتطهير',
      description: 'دراسة تأصيلية مفصلة في أقسام المياه، وإزالة النجاسات، وفقه الوضوء والغسل والمسح على الخفين والتيمم وأحكام الدماء الطبيعية.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningTaharahData.courseId],
      estimatedHours: 5,
    );

    final pathSalah = lp.LearningPath.create(
      pathId: 'path_fiqh_salah',
      title: 'مسار فقه الصلاة والسهو والجماعة والجنائز',
      description: 'دراسة تأصيلية شاملة لشروط وأركان وواجبات الصلاة، وهيئتها النبوية، وسجود السهو، وصلاة الجماعة، وصلوات الأعذار، والجنائز.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningSalahData.courseId],
      estimatedHours: 6,
    );

    final pathZakah = lp.LearningPath.create(
      pathId: 'path_fiqh_zakah',
      title: 'مسار فقه الزكاة والأنصبة المعاصرة',
      description: 'دراسة فقهية لشروط وجوب الزكاة، وحساب أنصبة الأموال النقدية والأسهم والذهب وعروض التجارة، والمصارف الثمانية، وزكاة الفطر.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningZakahData.courseId],
      estimatedHours: 4,
    );

    final pathFasting = lp.LearningPath.create(
      pathId: 'path_fiqh_fasting',
      title: 'مسار فقه الصيام ومقاصده والنوازل المعاصرة',
      description: 'دراسة شاملة لشروط الصيام، ومفسداته المعاصرة، والنوازل الطبية، وأعذار الفطر والقضاء والكفارات، وفقه الاعتكاف.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningFastingData.courseId],
      estimatedHours: 4,
    );

    final pathHajj = lp.LearningPath.create(
      pathId: 'path_fiqh_hajj',
      title: 'مسار فقه الحج والعمرة والزيارة المشروعة',
      description: 'دراسة شاملة لشروط الاستطاعة، والمواقيت، والأنساك الثلاثة، ومحظورات الإحرام، وأعمال الحج خطوة بخطوة، وصفة العمرة والزيارة.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningHajjData.courseId],
      estimatedHours: 6,
    );

    // --- B. مسارات العقيدة الإسلامية وأصول الإيمان والتأصيل العقدي ---
    final pathAqidahComprehensive = lp.LearningPath.create(
      pathId: 'path_aqidah_comprehensive',
      title: 'مسار العقيدة الإسلامية وأصول الإيمان التأصيلي',
      description: 'مسار منهجي موسوعي تأصيلي يغطي أركان الإيمان الستة: أصول التوحيد والإيمان بالله، الإيمان بالملائكة والكتب والرسل، الإيمان باليوم الآخر وأشراط الساعة وعالم البرزخ، الإيمان بالقدر خيره وشره، ومعتقد أهل السنة والتحصين الفكري.',
      category: 'العقيدة الإسلامية',
      level: lp.LearningLevel.beginner,
      courseIds: const [
        LearningAqidahTawheedData.courseId,
        LearningAqidahMessengersData.courseId,
        LearningAqidahAfterlifeData.courseId,
        LearningAqidahQadarData.courseId,
        LearningAqidahSunnahData.courseId,
      ],
      estimatedHours: 25,
    );

    final pathAqidahTawheed = lp.LearningPath.create(
      pathId: 'path_aqidah_tawheed',
      title: 'مسار أصول التوحيد والإيمان بالله تعالى',
      description: 'دراسة تأصيلية في أقسام التوحيد الثلاثة، وشروط لا إله إلا الله، وقواعد الأسماء والصفات، والتحذير من الشرك ونواقض الإسلام.',
      category: 'العقيدة الإسلامية',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningAqidahTawheedData.courseId],
      estimatedHours: 6,
    );

    final pathAqidahMessengers = lp.LearningPath.create(
      pathId: 'path_aqidah_messengers',
      title: 'مسار الإيمان بالملائكة والكتب والرسل',
      description: 'دراسة عقدية في عالم الملائكة ووظائفهم، والإيمان بالكتب المنزلة وهيمنة القرآن، والإيمان بالرسل وخاتمية نبوة محمد ﷺ.',
      category: 'العقيدة الإسلامية',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningAqidahMessengersData.courseId],
      estimatedHours: 5,
    );

    final pathAqidahAfterlife = lp.LearningPath.create(
      pathId: 'path_aqidah_afterlife',
      title: 'مسار الإيمان باليوم الآخر وأشراط الساعة وعالم البرزخ',
      description: 'دراسة مفصلة في أحكام الموت وعالم البرزخ، وأشراط الساعة الصغرى والكبرى، والبعث والنشور، والحوض والميزان والصراط والجنة والنار.',
      category: 'العقيدة الإسلامية',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningAqidahAfterlifeData.courseId],
      estimatedHours: 6,
    );

    final pathAqidahQadar = lp.LearningPath.create(
      pathId: 'path_aqidah_qadar',
      title: 'مسار الإيمان بالقدر خيره وشره',
      description: 'دراسة عقدية في مراتب القدر الأربعة، ومشيئة الله ومشيئة العبد، والجمع بين التوكل والأخذ بالأسباب، وثمرات الرضا بالقضاء.',
      category: 'العقيدة الإسلامية',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningAqidahQadarData.courseId],
      estimatedHours: 4,
    );

    final pathAqidahSunnah = lp.LearningPath.create(
      pathId: 'path_aqidah_sunnah',
      title: 'مسار معتقد أهل السنة والجماعة والتحصين الفكري',
      description: 'دراسة أصول أهل السنة في الصحابة والقرابة، وحقيقة الإيمان، ولزوم السنة ونبذ البدع، وضوابط التكفير، ومناهج التحصين الفكري المعاصر.',
      category: 'العقيدة الإسلامية',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningAqidahSunnahData.courseId],
      estimatedHours: 5,
    );

    // --- C. مسارات علوم القرآن والتفسير وأحكام التجويد التأصيلي ---
    final pathQuranComprehensive = lp.LearningPath.create(
      pathId: 'path_quran_sciences_comprehensive',
      title: 'مسار علوم القرآن والتفسير وأحكام التجويد التأصيلي',
      description: 'مسار منهجي موسوعي تأصيلي يغطي علوم كتاب الله العزيز: أحكام التجويد ومخارج الحروف، علوم القرآن وتاريخ نزوله وجمعه وإعجازه، أصول وقواعد التفسير ومناهج المفسرين، وتفسير جزء عم وقصار المفصل.',
      category: 'علوم القرآن والتفسير',
      level: lp.LearningLevel.beginner,
      courseIds: const [
        LearningQuranTajweedData.courseId,
        LearningQuranSciencesData.courseId,
        LearningQuranTafsirRulesData.courseId,
        LearningQuranTafsirMufassalData.courseId,
      ],
      estimatedHours: 20,
    );

    final pathQuranTajweed = lp.LearningPath.create(
      pathId: 'path_quran_tajweed',
      title: 'مسار أحكام التلاوة والتجويد العملي',
      description: 'دراسة تأصيلية تطبيقية لأحكام النون والتنوين والميم الساكنة، وأحكام المدود، ومخارج وصفات الحروف، والتفخيم والترقيق.',
      category: 'علوم القرآن والتفسير',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningQuranTajweedData.courseId],
      estimatedHours: 6,
    );

    final pathQuranSciences = lp.LearningPath.create(
      pathId: 'path_quran_sciences',
      title: 'مسار مباحث علوم القرآن وتاريخ النزول والجمع',
      description: 'دراسة في كيفية نزول الوحي، وضوابط المكي والمدني، وتاريخ جمع وتدوين القرآن، ووجوه الإعجاز والقراءات المتواترة.',
      category: 'علوم القرآن والتفسير',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningQuranSciencesData.courseId],
      estimatedHours: 5,
    );

    final pathQuranTafsirRules = lp.LearningPath.create(
      pathId: 'path_quran_tafsir_rules',
      title: 'مسار أصول التفسير وقواعد الترجيح وأسباب النزول',
      description: 'دراسة في مصادر التفسير ومراتبه الأربعة، وقواعد الترجيح عند السلف، وأسباب النزول، والناسخ والمنسوخ والمحكم والمتشابه.',
      category: 'علوم القرآن والتفسير',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningQuranTafsirRulesData.courseId],
      estimatedHours: 5,
    );

    final pathQuranTafsirMufassal = lp.LearningPath.create(
      pathId: 'path_quran_tafsir_mufassal',
      title: 'مسار التفسير المنهجي لسورة الفاتحة وقصار المفصل',
      description: 'دراسة تفسيرية وتدبرية شاملة لأم الكتاب سورة الفاتحة وسور جزء عم وقصار المفصل مع مقاصدها العقدية والتربوية.',
      category: 'علوم القرآن والتفسير',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningQuranTafsirMufassalData.courseId],
      estimatedHours: 5,
    );

    // --- D. مسارات علوم الحديث ومصطلحه وشرح الأربعين النووية ---
    final pathHadithComprehensive = lp.LearningPath.create(
      pathId: 'path_hadith_sciences_comprehensive',
      title: 'مسار علوم الحديث النبوي ومصطلحه وشرح الأربعين النووية التأصيلي',
      description: 'مسار منهجي موسوعي تأصيلي يغطي حجية السنة وتاريخ التدوين ومناهج الكتب الستة، وقواعد التصنيف والجرح والتعديل والوضع، مع الشرح التأصيلي والتربوي الموسع لمتن الأربعين النووية (الأحاديث 1 إلى 42 كاملة).',
      category: 'علوم الحديث النبوي',
      level: lp.LearningLevel.beginner,
      courseIds: const [
        LearningHadithMustalahIntroData.courseId,
        LearningHadithGradingRulesData.courseId,
        LearningHadithNawawiPart1Data.courseId,
        LearningHadithNawawiPart2Data.courseId,
      ],
      estimatedHours: 30,
    );

    final pathHadithMustalah = lp.LearningPath.create(
      pathId: 'path_hadith_mustalah',
      title: 'مسار مبادئ علم مصطلح الحديث وتاريخ التدوين',
      description: 'دراسة تأصيلية في حجية السنة، ومصطلحات السند والمتن، ومراحل تدوين الحديث، والكتب الستة، والحديث المتواتر والآحاد.',
      category: 'علوم الحديث النبوي',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningHadithMustalahIntroData.courseId],
      estimatedHours: 6,
    );

    final pathHadithGrading = lp.LearningPath.create(
      pathId: 'path_hadith_grading',
      title: 'مسار قواعد تصنيف الحديث وقبوله ورده وعلم الجرح والتعديل',
      description: 'دراسة متخصصة في شروط الحديث الصحيح والحسن، والسقط في الإسناد، والطعن في الراوي، والأحاديث الموضوعة، وضوابط الجرح والتعديل.',
      category: 'علوم الحديث النبوي',
      level: lp.LearningLevel.intermediate,
      courseIds: const [LearningHadithGradingRulesData.courseId],
      estimatedHours: 8,
    );

    final pathHadithNawawiFull = lp.LearningPath.create(
      pathId: 'path_hadith_nawawi_full',
      title: 'مسار الشرح التأصيلي الموسع للأربعين النووية كاملة',
      description: 'الشرح التحليلي والفقهي والتربوي الشامل لمتن الأربعين النووية (42 حديثاً نبوياً) التي تدور عليها كليات وقواعد الإسلام وأصول الإيمان والسلوك.',
      category: 'السنة والحديث الشريف',
      level: lp.LearningLevel.beginner,
      courseIds: const [
        LearningHadithNawawiPart1Data.courseId,
        LearningHadithNawawiPart2Data.courseId,
      ],
      estimatedHours: 16,
    );

    final pathHadithNawawiPart1 = lp.LearningPath.create(
      pathId: 'path_hadith_nawawi_part1',
      title: 'مسار الأربعين النووية (الجزء الأول: الأحاديث 1 إلى 21)',
      description: 'دراسة الأحاديث 1 إلى 21 من الأربعين النووية: أصول النيات، حديث جبريل في مراتب الدين، حفظ الشريعة، الورع، ومحاسن الأخلاق.',
      category: 'السنة والحديث الشريف',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningHadithNawawiPart1Data.courseId],
      estimatedHours: 8,
    );

    // --- E. مسارات السيرة النبوية والشمائل والتاريخ الإسلامي التأصيلي ---
    final pathSeerahComprehensive = lp.LearningPath.create(
      pathId: 'path_seerah_history_curriculum',
      title: 'مسار السيرة النبوية والشمائل والتاريخ الإسلامي التأصيلي',
      description: 'مسار منهجي موسوعي تأصيلي يغطي العهد المكي والبعثة النبوية، والعهد المدني وتأسيس الدولة والمغازي الكبرى، والشمائل المحمدية ومعالم وأعلام السيرة الموثقة في موسوعة السيرة النبوية بسِراج.',
      category: 'السيرة النبوية والتاريخ الإسلامي',
      level: lp.LearningLevel.beginner,
      courseIds: const [
        LearningSeerahMakkanData.courseId,
        LearningSeerahMedinanData.courseId,
        LearningSeerahShamailData.courseId,
      ],
      estimatedHours: 24,
    );

    final pathSeerahMakkan = lp.LearningPath.create(
      pathId: 'path_seerah_makkan',
      title: 'مسار دراسة العهد المكي والبعثة النبوية والابتلاءات',
      description: 'دراسة تأصيلية منهجية في سيرة المصطفى ﷺ بمكة المكرمة: من المولد والنشأة الشريفة وبدء الوحي إلى الهجرتين وعام الحزن والإسراء والمعراج وبيعتي العقبة.',
      category: 'السيرة النبوية والتاريخ الإسلامي',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningSeerahMakkanData.courseId],
      estimatedHours: 8,
    );

    final pathSeerahMedinan = lp.LearningPath.create(
      pathId: 'path_seerah_medinan',
      title: 'مسار دراسة العهد المدني وتأسيس الدولة والمغازي الكبرى',
      description: 'دراسة تأصيلية في العهد المدني: الهجرة الشريفة، بناء المسجد، وثيقة المدينة، المؤاخاة، تحويل القبلة، المغازي الكبرى، صلح الحديبية، فتح مكة الأعظم، وحجة الوداع.',
      category: 'السيرة النبوية والتاريخ الإسلامي',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningSeerahMedinanData.courseId],
      estimatedHours: 10,
    );

    final pathSeerahShamail = lp.LearningPath.create(
      pathId: 'path_seerah_shamail',
      title: 'مسار الشمائل المحمدية ومعالم وأعلام السيرة النبوية',
      description: 'دراسة محققة في صفات النبي ﷺ الخَلقية والخُلقية، وهديه الشريف، وأعلام الصحابة وآل البيت الـ 16، والمواقع والمعالم التاريخية الـ 15 الموثقة في سِراج.',
      category: 'السيرة النبوية والتاريخ الإسلامي',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningSeerahShamailData.courseId],
      estimatedHours: 6,
    );

    // --- F. مسارات فقه المعاملات المالية المعاصرة وأصول الفقه والقواعد الفقهية ---
    final pathMuamalatComprehensive = lp.LearningPath.create(
      pathId: 'path_fiqh_muamalat_comprehensive',
      title: 'مسار فقه المعاملات المالية المعاصرة وأصول الفقه والقواعد الفقهية والمقاصد',
      description: 'مسار منهجي موسوعي تأصيلي يغطي فقه البيوع والعقود المالية والخيارات والربا والغرر، والمعاملات المصرفية والنوازل الاستثمارية والأسهم والتأمين التكافلي، مع مبادئ أصول الفقه ومصادر التشريع والاجتهاد، والقواعد الفقهية الكبرى ومقاصد الشريعة وفقه الموازنات.',
      category: 'فقه المعاملات وأصول الفقه',
      level: lp.LearningLevel.intermediate,
      courseIds: const [
        LearningMuamalatBuyuData.courseId,
        LearningMuamalatContemporaryBankingData.courseId,
        LearningMuamalatUsulFiqhData.courseId,
        LearningMuamalatQawaidMaqasidData.courseId,
      ],
      estimatedHours: 32,
    );

    final pathMuamalatBuyu = lp.LearningPath.create(
      pathId: 'path_fiqh_buyu',
      title: 'مسار فقه البيوع والعقود المالية والخيارات ومفسداتها',
      description: 'دراسة تأصيلية فقهية لأركان البيع، ضوابط التراضي، أحكام الخيارات الأربعة، ومفسدات العقود من الربا والغرر وبيوع الغش والاحتكار.',
      category: 'فقه المعاملات وأصول الفقه',
      level: lp.LearningLevel.intermediate,
      courseIds: const [LearningMuamalatBuyuData.courseId],
      estimatedHours: 8,
    );

    final pathMuamalatBanking = lp.LearningPath.create(
      pathId: 'path_fiqh_banking',
      title: 'مسار المعاملات المصرفية والنوازل المالية المعاصرة',
      description: 'دراسة فقهية للنوازل المصرفية والاستثمارية: الحسابات البنكية، صيغ التمويل الإسلامي، البطاقات الائتمانية، الأسهم، التأمين التكافلي، والعملات المشفرة.',
      category: 'فقه المعاملات وأصول الفقه',
      level: lp.LearningLevel.intermediate,
      courseIds: const [LearningMuamalatContemporaryBankingData.courseId],
      estimatedHours: 8,
    );

    final pathMuamalatUsul = lp.LearningPath.create(
      pathId: 'path_fiqh_usul',
      title: 'مسار مبادئ أصول الفقه ومصادر التشريع والاجتهاد',
      description: 'دراسة منهجية في حقيقة علم الأصول، الحكم التكليفي والوضعي، الأدلة المتفق عليها والمختلف فيها، ودلالات الألفاظ وشروط الاجتهاد والفتوى.',
      category: 'فقه المعاملات وأصول الفقه',
      level: lp.LearningLevel.intermediate,
      courseIds: const [LearningMuamalatUsulFiqhData.courseId],
      estimatedHours: 8,
    );

    final pathMuamalatQawaid = lp.LearningPath.create(
      pathId: 'path_fiqh_qawaid',
      title: 'مسار القواعد الفقهية الكبرى والمقاصد الشرعية وفقه الموازنات',
      description: 'دراسة جامعة للقواعد الفقهية الخمس الكبرى وفروعها، وحفظ الكليات الخمس، وفقه الموازنات والأولويات عند تزاحم المصالح والمفاسد.',
      category: 'فقه المعاملات وأصول الفقه',
      level: lp.LearningLevel.intermediate,
      courseIds: const [LearningMuamalatQawaidMaqasidData.courseId],
      estimatedHours: 8,
    );

    // --- G. مسارات فقه الأسرة المسلمة والمواريث والأخلاق والدعوة والفكر المعاصر ---
    final pathFamilySocietyComprehensive = lp.LearningPath.create(
      pathId: 'path_family_ethics_society_comprehensive',
      title: 'مسار فقه الأسرة المسلمة والمواريث ومكارم الأخلاق وفقه الدعوة والفكر الإسلامي المعاصر',
      description: 'مسار منهجي موسوعي تأصيلي يغطي فقه النكاح والعلاقات الأسرية وحقوق الزوجين والفرقة وعلم الفرائض والمواريث والوصايا، ومكارم الأخلاق وتزكية النفس وآداب المعاشرة، وأصول الدعوة وفقه الأمر بالمعروف والنهي عن المنكر وأدب الحوار، ومقومات الهوية والوسطية وبراهين الإيمان وتفنيد الشبهات المعاصرة.',
      category: 'فقه الأسرة والأخلاق والمجتمع',
      level: lp.LearningLevel.intermediate,
      courseIds: const [
        LearningFamilyInheritanceData.courseId,
        LearningEthicsAdabTarbiyahData.courseId,
        LearningDawahHisbahDialogueData.courseId,
        LearningThoughtAwarenessData.courseId,
      ],
      estimatedHours: 32,
    );

    final pathFamilyInheritance = lp.LearningPath.create(
      pathId: 'path_fiqh_family_inheritance',
      title: 'مسار فقه الأسرة المسلمة والأحوال الشخصية وعلم الفرائض',
      description: 'دراسة تأصيلية فقهية لأركان الزواج وحقوق الزوجين، فقه الطلاق والخلع والحضانة، وأصحاب الفروض والعصبات والحجب وتصفية التركات والوصايا.',
      category: 'فقه الأسرة والأخلاق والمجتمع',
      level: lp.LearningLevel.intermediate,
      courseIds: const [LearningFamilyInheritanceData.courseId],
      estimatedHours: 8,
    );

    final pathEthicsAdab = lp.LearningPath.create(
      pathId: 'path_ethics_adab_tarbiyah',
      title: 'مسار مكارم الأخلاق والتربية والآداب الإسلامية وتزكية النفس',
      description: 'دراسة تأصيلية تربوية لأمهات الفضائل (الصدق والأمانة والحياء والتواضع)، تطهير القلوب من الكبر والرياء والحسد، وبر الوالدين وحقوق الجوار وآداب اللسان.',
      category: 'فقه الأسرة والأخلاق والمجتمع',
      level: lp.LearningLevel.beginner,
      courseIds: const [LearningEthicsAdabTarbiyahData.courseId],
      estimatedHours: 8,
    );

    final pathDawahHisbah = lp.LearningPath.create(
      pathId: 'path_dawah_hisbah_dialogue',
      title: 'مسار فقه الدعوة إلى الله والاحتساب والحوار الحضاري',
      description: 'دراسة منهجية لأصول الدعوة والحكمة والموعظة الحسنة، فقه الأمر بالمعروف والنهي عن المنكر، أدب الحوار والمناظرة، واستثمار الإعلام الرقمي ودعوة غير المسلمين.',
      category: 'فقه الأسرة والأخلاق والمجتمع',
      level: lp.LearningLevel.intermediate,
      courseIds: const [LearningDawahHisbahDialogueData.courseId],
      estimatedHours: 8,
    );

    final pathThoughtAwareness = lp.LearningPath.create(
      pathId: 'path_thought_awareness',
      title: 'مسار الفكر الإسلامي المعاصر وبناء الوعي وتفنيد الشبهات',
      description: 'دراسة فكرية عقدية معاصرة في مقومات الهوية والوسطية ونبذ الغلو، ضوابط التجديد، براهين الإيمان ومواجهة الإلحاد، والرد التأصيلي على الشبهات المعاصرة.',
      category: 'فقه الأسرة والأخلاق والمجتمع',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningThoughtAwarenessData.courseId],
      estimatedHours: 8,
    );

    // --- H. مسارات فقه القضاء والسياسة الشرعية والعلاقات الدولية وحقوق الإنسان ---
    final pathGovernanceJudiciaryRightsComprehensive = lp.LearningPath.create(
      pathId: 'path_governance_judiciary_rights_comprehensive',
      title: 'مسار فقه القضاء والسياسة الشرعية والعلاقات الدولية وحقوق الإنسان في الإسلام',
      description: 'مسار منهجي موسوعي تأصيلي يغطي فقه القضاء وطرق الإثبات الشرعية والقرائن المعاصرة، أصول السياسة الشرعية وأنظمة الحكم الرشيد وإدارة الشأن العام، فقه العلاقات الدولية والمعاهدات والسلم وحماية المدنيين، وتأصيل حقوق الإنسان والحريات العامة وكرامة بني آدم في الشريعة الإسلامية.',
      category: 'القضاء والسياسة الشرعية وحقوق الإنسان',
      level: lp.LearningLevel.advanced,
      courseIds: const [
        LearningJudiciaryEvidenceData.courseId,
        LearningSiyasahShariyyahGovernanceData.courseId,
        LearningInternationalRelationsTreatiesData.courseId,
        LearningHumanRightsLibertiesData.courseId,
      ],
      estimatedHours: 32,
    );

    final pathJudiciaryEvidence = lp.LearningPath.create(
      pathId: 'path_fiqh_judiciary_evidence',
      title: 'مسار فقه القضاء وطرق الإثبات الشرعية والقرائن المعاصرة',
      description: 'دراسة تأصيلية لنظام القضاء وشروط القاضي وآدابه ومجلس الحكم، وطرق الإثبات الشرعية من الإقرار والشهادة واليمين والقرائن القطعية والخبرة الفنية المعاصرة (البصمة الوراثية والطب الشرعي).',
      category: 'القضاء والسياسة الشرعية وحقوق الإنسان',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningJudiciaryEvidenceData.courseId],
      estimatedHours: 8,
    );

    final pathSiyasahShariyyah = lp.LearningPath.create(
      pathId: 'path_siyasah_shariyyah_governance',
      title: 'مسار السياسة الشرعية وأنظمة الحكم الرشيد وإدارة الشأن العام',
      description: 'دراسة فقهية تأصيلية لقواعد السياسة الشرعية ومقاصد الإمامة، مبادئ الحكم الرشيد (الشورى والعدل والرقابة والمساءلة ومكافحة الفساد)، وتدبير المال العام والتنظيم الإداري والمؤسسي.',
      category: 'القضاء والسياسة الشرعية وحقوق الإنسان',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningSiyasahShariyyahGovernanceData.courseId],
      estimatedHours: 8,
    );

    final pathInternationalRelations = lp.LearningPath.create(
      pathId: 'path_international_relations_treaties',
      title: 'مسار فقه العلاقات الدولية والمعاهدات والسلم وحماية المدنيين',
      description: 'دراسة تأصيلية لأصول العلاقات الدولية في الإسلام، الوفاء بالعهود والمواثيق الدولية، فقه الجهاد وضوابطه وأخلاقياته، حماية المدنيين والبيئة، والتمثيل الدبلوماسي وحل النزاعات سلماً.',
      category: 'القضاء والسياسة الشرعية وحقوق الإنسان',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningInternationalRelationsTreatiesData.courseId],
      estimatedHours: 8,
    );

    final pathHumanRightsLiberties = lp.LearningPath.create(
      pathId: 'path_human_rights_liberties',
      title: 'مسار تأصيل حقوق الإنسان والحريات العامة في الشريعة الإسلامية',
      description: 'دراسة تأصيلية مقارنة لمرتكزات كرامة الإنسان وحقوقه في الإسلام، الحقوق الأساسية (الحياة، التدين، التفكير والتعبير، التملك، والكرامة الإنسانية)، وحقوق الفئات الأولى بالرعاية (المرأة، الطفل، ذوي الإعاقة، وغير المسلمين).',
      category: 'القضاء والسياسة الشرعية وحقوق الإنسان',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningHumanRightsLibertiesData.courseId],
      estimatedHours: 8,
    );

    // --- I. مسارات فقه النوازل الطبية المعاصرة والأخلاقيات البيولوجية وعمارة البيئة ---
    final pathMedicalBioethicsEnvironmentComprehensive = lp.LearningPath.create(
      pathId: 'path_medical_bioethics_environment_comprehensive',
      title: 'مسار فقه النوازل الطبية المعاصرة والأخلاقيات البيولوجية وعمارة البيئة',
      description: 'مسار منهجي موسوعي تأصيلي يغطي فقه النوازل الطبية والجراحية والتداوي والموت الدماغي وزراعة الأعضاء، الهندسة الوراثية والإنجاب المساعد والأخلاقيات الحيوية (Bioethics)، فقه الأوبئة والطب الوقائي والرخص الطبية في العبادات، وفقه البيئة وعمارة الأرض وحفظ الموارد والرفق بالحيوان ومكافحة التلوث.',
      category: 'النوازل الطبية والأخلاقيات الحيوية والبيئة',
      level: lp.LearningLevel.advanced,
      courseIds: const [
        LearningMedicalSurgeriesTransplantsData.courseId,
        LearningGeneticsAssistedReproductionData.courseId,
        LearningEpidemicsPublicHealthDispensationsData.courseId,
        LearningEnvironmentEarthStewardshipData.courseId,
      ],
      estimatedHours: 32,
    );

    final pathMedicalSurgeries = lp.LearningPath.create(
      pathId: 'path_medical_surgeries_transplants',
      title: 'مسار النوازل الطبية والجراحية وأحكام التداوي ونقل الأعضاء',
      description: 'دراسة تأصيلية لأحكام التداوي والمسؤولية الطبية، الموت الدماغي ورفع أجهزة الإنعاش، زراعة الأعضاء البشرية، بنوك الدم والقرنيات، وضوابط الجراحة التجميلية.',
      category: 'النوازل الطبية والأخلاقيات الحيوية والبيئة',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningMedicalSurgeriesTransplantsData.courseId],
      estimatedHours: 8,
    );

    final pathGeneticsAssisted = lp.LearningPath.create(
      pathId: 'path_genetics_assisted_reproduction',
      title: 'مسار الهندسة الوراثية والإنجاب المساعد والأخلاقيات الحيوية',
      description: 'دراسة تأصيلية لوسائل الإنجاب المساعد (أطفال الأنابيب، الحقن المجهري)، تحريم تأجير الأرحام، الفحص الوراثي، الاستنساخ، وتعديل الجينوم وأبحاث الخلايا الجذعية.',
      category: 'النوازل الطبية والأخلاقيات الحيوية والبيئة',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningGeneticsAssistedReproductionData.courseId],
      estimatedHours: 8,
    );

    final pathEpidemicsDispensations = lp.LearningPath.create(
      pathId: 'path_epidemics_public_health_dispensations',
      title: 'مسار فقه الأوبئة والصحة العامة والصيام والرخص الطبية',
      description: 'دراسة فقهية للطب الوقائي النبوي، الحجر الصحي وإدارة الجوائح، أحكام اللقاحات، والمفطرات الطبية المعاصرة ورخص المرضى في الصلاة والصيام والحج.',
      category: 'النوازل الطبية والأخلاقيات الحيوية والبيئة',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningEpidemicsPublicHealthDispensationsData.courseId],
      estimatedHours: 8,
    );

    final pathEnvironmentStewardship = lp.LearningPath.create(
      pathId: 'path_environment_earth_stewardship',
      title: 'مسار فقه البيئة وعمارة الأرض وحماية الموارد الطبيعية',
      description: 'دراسة تأصيلية لمفهوم الاستخلاف وعمارة الأرض، فقه الموارد المائية، إحياء الموات والتشجير والمحميات، التوازن الكوني والمناخي، والرفق بالحيوان ومكافحة التلوث.',
      category: 'النوازل الطبية والأخلاقيات الحيوية والبيئة',
      level: lp.LearningLevel.advanced,
      courseIds: const [LearningEnvironmentEarthStewardshipData.courseId],
      estimatedHours: 8,
    );

    final paths = [
      pathFiqhComprehensive,
      pathAqidahComprehensive,
      pathQuranComprehensive,
      pathHadithComprehensive,
      pathSeerahComprehensive,
      pathMuamalatComprehensive,
      pathFamilySocietyComprehensive,
      pathGovernanceJudiciaryRightsComprehensive,
      pathMedicalBioethicsEnvironmentComprehensive,
      pathTaharah,
      pathSalah,
      pathZakah,
      pathFasting,
      pathHajj,
      pathAqidahTawheed,
      pathAqidahMessengers,
      pathAqidahAfterlife,
      pathAqidahQadar,
      pathAqidahSunnah,
      pathQuranTajweed,
      pathQuranSciences,
      pathQuranTafsirRules,
      pathQuranTafsirMufassal,
      pathHadithMustalah,
      pathHadithGrading,
      pathHadithNawawiFull,
      pathHadithNawawiPart1,
      pathSeerahMakkan,
      pathSeerahMedinan,
      pathSeerahShamail,
      pathMuamalatBuyu,
      pathMuamalatBanking,
      pathMuamalatUsul,
      pathMuamalatQawaid,
      pathFamilyInheritance,
      pathEthicsAdab,
      pathDawahHisbah,
      pathThoughtAwareness,
      pathJudiciaryEvidence,
      pathSiyasahShariyyah,
      pathInternationalRelations,
      pathHumanRightsLiberties,
      pathMedicalSurgeries,
      pathGeneticsAssisted,
      pathEpidemicsDispensations,
      pathEnvironmentStewardship,
    ];

    // -------------------------------------------------------------------------
    // 2. Courses (29 Advanced Courses)
    // -------------------------------------------------------------------------
    final List<Course> courses = [
      // Fiqh of Worship Courses (5)
      LearningTaharahData.getCourse(),
      LearningSalahData.getCourse(),
      LearningZakahData.getCourse(),
      LearningFastingData.getCourse(),
      LearningHajjData.getCourse(),
      // Islamic Creed (Aqidah) Courses (5)
      LearningAqidahTawheedData.getCourse(),
      LearningAqidahMessengersData.getCourse(),
      LearningAqidahAfterlifeData.getCourse(),
      LearningAqidahQadarData.getCourse(),
      LearningAqidahSunnahData.getCourse(),
      // Quranic Sciences & Tafsir Courses (4)
      LearningQuranTajweedData.getCourse(),
      LearningQuranSciencesData.getCourse(),
      LearningQuranTafsirRulesData.getCourse(),
      LearningQuranTafsirMufassalData.getCourse(),
      // Hadith Sciences & Forty Hadith Courses (4)
      LearningHadithMustalahIntroData.getCourse(),
      LearningHadithGradingRulesData.getCourse(),
      LearningHadithNawawiPart1Data.getCourse(),
      LearningHadithNawawiPart2Data.getCourse(),
      // Seerah & Islamic History Courses (3)
      LearningSeerahMakkanData.getCourse(),
      LearningSeerahMedinanData.getCourse(),
      LearningSeerahShamailData.getCourse(),
      // Contemporary Financial Fiqh & Usul al-Fiqh Courses (4)
      LearningMuamalatBuyuData.getCourse(),
      LearningMuamalatContemporaryBankingData.getCourse(),
      LearningMuamalatUsulFiqhData.getCourse(),
      LearningMuamalatQawaidMaqasidData.getCourse(),
      // Family Fiqh, Islamic Ethics, Dawah & Contemporary Thought Courses (4)
      LearningFamilyInheritanceData.getCourse(),
      LearningEthicsAdabTarbiyahData.getCourse(),
      LearningDawahHisbahDialogueData.getCourse(),
      LearningThoughtAwarenessData.getCourse(),
      // Governance, Judiciary, International Relations & Human Rights Courses (4)
      LearningJudiciaryEvidenceData.getCourse(),
      LearningSiyasahShariyyahGovernanceData.getCourse(),
      LearningInternationalRelationsTreatiesData.getCourse(),
      LearningHumanRightsLibertiesData.getCourse(),
      // Contemporary Medical Fiqh, Bioethics & Environmental Stewardship Courses (4)
      LearningMedicalSurgeriesTransplantsData.getCourse(),
      LearningGeneticsAssistedReproductionData.getCourse(),
      LearningEpidemicsPublicHealthDispensationsData.getCourse(),
      LearningEnvironmentEarthStewardshipData.getCourse(),
    ];

    // -------------------------------------------------------------------------
    // 3. Modules (74 Core Modules)
    // -------------------------------------------------------------------------
    final List<CourseModule> modules = [
      // Fiqh of Worship Modules (10)
      ...LearningTaharahData.getModules(),
      ...LearningSalahData.getModules(),
      ...LearningZakahData.getModules(),
      ...LearningFastingData.getModules(),
      ...LearningHajjData.getModules(),
      // Islamic Creed (Aqidah) Modules (10)
      ...LearningAqidahTawheedData.getModules(),
      ...LearningAqidahMessengersData.getModules(),
      ...LearningAqidahAfterlifeData.getModules(),
      ...LearningAqidahQadarData.getModules(),
      ...LearningAqidahSunnahData.getModules(),
      // Quranic Sciences & Tafsir Modules (8)
      ...LearningQuranTajweedData.getModules(),
      ...LearningQuranSciencesData.getModules(),
      ...LearningQuranTafsirRulesData.getModules(),
      ...LearningQuranTafsirMufassalData.getModules(),
      // Hadith Sciences & Forty Hadith Modules (8)
      ...LearningHadithMustalahIntroData.getModules(),
      ...LearningHadithGradingRulesData.getModules(),
      ...LearningHadithNawawiPart1Data.getModules(),
      ...LearningHadithNawawiPart2Data.getModules(),
      // Seerah & Islamic History Modules (6)
      ...LearningSeerahMakkanData.getModules(),
      ...LearningSeerahMedinanData.getModules(),
      ...LearningSeerahShamailData.getModules(),
      // Contemporary Financial Fiqh & Usul al-Fiqh Modules (8)
      ...LearningMuamalatBuyuData.getModules(),
      ...LearningMuamalatContemporaryBankingData.getModules(),
      ...LearningMuamalatUsulFiqhData.getModules(),
      ...LearningMuamalatQawaidMaqasidData.getModules(),
      // Family Fiqh, Islamic Ethics, Dawah & Contemporary Thought Modules (8)
      ...LearningFamilyInheritanceData.getModules(),
      ...LearningEthicsAdabTarbiyahData.getModules(),
      ...LearningDawahHisbahDialogueData.getModules(),
      ...LearningThoughtAwarenessData.getModules(),
      // Governance, Judiciary, International Relations & Human Rights Modules (8)
      ...LearningJudiciaryEvidenceData.getModules(),
      ...LearningSiyasahShariyyahGovernanceData.getModules(),
      ...LearningInternationalRelationsTreatiesData.getModules(),
      ...LearningHumanRightsLibertiesData.getModules(),
      // Contemporary Medical Fiqh, Bioethics & Environmental Stewardship Modules (8)
      ...LearningMedicalSurgeriesTransplantsData.getModules(),
      ...LearningGeneticsAssistedReproductionData.getModules(),
      ...LearningEpidemicsPublicHealthDispensationsData.getModules(),
      ...LearningEnvironmentEarthStewardshipData.getModules(),
    ];

    // -------------------------------------------------------------------------
    // 4. Lessons (230 In-Depth Canonical Lessons)
    // -------------------------------------------------------------------------
    final List<Lesson> lessons = [
      // Fiqh of Worship Lessons (32)
      ...LearningTaharahData.getLessons(),
      ...LearningSalahData.getLessons(),
      ...LearningZakahData.getLessons(),
      ...LearningFastingData.getLessons(),
      ...LearningHajjData.getLessons(),
      // Islamic Creed (Aqidah) Lessons (29)
      ...LearningAqidahTawheedData.getLessons(),
      ...LearningAqidahMessengersData.getLessons(),
      ...LearningAqidahAfterlifeData.getLessons(),
      ...LearningAqidahQadarData.getLessons(),
      ...LearningAqidahSunnahData.getLessons(),
      // Quranic Sciences & Tafsir Lessons (26)
      ...LearningQuranTajweedData.getLessons(),
      ...LearningQuranSciencesData.getLessons(),
      ...LearningQuranTafsirRulesData.getLessons(),
      ...LearningQuranTafsirMufassalData.getLessons(),
      // Hadith Sciences & Forty Hadith Lessons (31)
      ...LearningHadithMustalahIntroData.getLessons(),
      ...LearningHadithGradingRulesData.getLessons(),
      ...LearningHadithNawawiPart1Data.getLessons(),
      ...LearningHadithNawawiPart2Data.getLessons(),
      // Seerah & Islamic History Lessons (16)
      ...LearningSeerahMakkanData.getLessons(),
      ...LearningSeerahMedinanData.getLessons(),
      ...LearningSeerahShamailData.getLessons(),
      // Contemporary Financial Fiqh & Usul al-Fiqh Lessons (24)
      ...LearningMuamalatBuyuData.getLessons(),
      ...LearningMuamalatContemporaryBankingData.getLessons(),
      ...LearningMuamalatUsulFiqhData.getLessons(),
      ...LearningMuamalatQawaidMaqasidData.getLessons(),
      // Family Fiqh, Islamic Ethics, Dawah & Contemporary Thought Lessons (24)
      ...LearningFamilyInheritanceData.getLessons(),
      ...LearningEthicsAdabTarbiyahData.getLessons(),
      ...LearningDawahHisbahDialogueData.getLessons(),
      ...LearningThoughtAwarenessData.getLessons(),
      // Governance, Judiciary, International Relations & Human Rights Lessons (24)
      ...LearningJudiciaryEvidenceData.getLessons(),
      ...LearningSiyasahShariyyahGovernanceData.getLessons(),
      ...LearningInternationalRelationsTreatiesData.getLessons(),
      ...LearningHumanRightsLibertiesData.getLessons(),
      // Contemporary Medical Fiqh, Bioethics & Environmental Stewardship Lessons (24)
      ...LearningMedicalSurgeriesTransplantsData.getLessons(),
      ...LearningGeneticsAssistedReproductionData.getLessons(),
      ...LearningEpidemicsPublicHealthDispensationsData.getLessons(),
      ...LearningEnvironmentEarthStewardshipData.getLessons(),
    ];

    // -------------------------------------------------------------------------
    // 5. Quizzes (94 Formative Assessment Quizzes)
    // -------------------------------------------------------------------------
    final List<Quiz> quizzes = [
      // Fiqh of Worship Quizzes (17)
      ...LearningTaharahData.getQuizzes(),
      ...LearningSalahData.getQuizzes(),
      ...LearningZakahData.getQuizzes(),
      ...LearningFastingData.getQuizzes(),
      ...LearningHajjData.getQuizzes(),
      // Islamic Creed (Aqidah) Quizzes (15)
      ...LearningAqidahTawheedData.getQuizzes(),
      ...LearningAqidahMessengersData.getQuizzes(),
      ...LearningAqidahAfterlifeData.getQuizzes(),
      ...LearningAqidahQadarData.getQuizzes(),
      ...LearningAqidahSunnahData.getQuizzes(),
      // Quranic Sciences & Tafsir Quizzes (12)
      ...LearningQuranTajweedData.getQuizzes(),
      ...LearningQuranSciencesData.getQuizzes(),
      ...LearningQuranTafsirRulesData.getQuizzes(),
      ...LearningQuranTafsirMufassalData.getQuizzes(),
      // Hadith Sciences & Forty Hadith Quizzes (12)
      ...LearningHadithMustalahIntroData.getQuizzes(),
      ...LearningHadithGradingRulesData.getQuizzes(),
      ...LearningHadithNawawiPart1Data.getQuizzes(),
      ...LearningHadithNawawiPart2Data.getQuizzes(),
      // Seerah & Islamic History Quizzes (6)
      ...LearningSeerahMakkanData.getQuizzes(),
      ...LearningSeerahMedinanData.getQuizzes(),
      ...LearningSeerahShamailData.getQuizzes(),
      // Contemporary Financial Fiqh & Usul al-Fiqh Quizzes (8)
      ...LearningMuamalatBuyuData.getQuizzes(),
      ...LearningMuamalatContemporaryBankingData.getQuizzes(),
      ...LearningMuamalatUsulFiqhData.getQuizzes(),
      ...LearningMuamalatQawaidMaqasidData.getQuizzes(),
      // Family Fiqh, Islamic Ethics, Dawah & Contemporary Thought Quizzes (8)
      ...LearningFamilyInheritanceData.getQuizzes(),
      ...LearningEthicsAdabTarbiyahData.getQuizzes(),
      ...LearningDawahHisbahDialogueData.getQuizzes(),
      ...LearningThoughtAwarenessData.getQuizzes(),
      // Governance, Judiciary, International Relations & Human Rights Quizzes (8)
      ...LearningJudiciaryEvidenceData.getQuizzes(),
      ...LearningSiyasahShariyyahGovernanceData.getQuizzes(),
      ...LearningInternationalRelationsTreatiesData.getQuizzes(),
      ...LearningHumanRightsLibertiesData.getQuizzes(),
      // Contemporary Medical Fiqh, Bioethics & Environmental Stewardship Quizzes (8)
      ...LearningMedicalSurgeriesTransplantsData.getQuizzes(),
      ...LearningGeneticsAssistedReproductionData.getQuizzes(),
      ...LearningEpidemicsPublicHealthDispensationsData.getQuizzes(),
      ...LearningEnvironmentEarthStewardshipData.getQuizzes(),
    ];

    return CanonicalLearningPackage.create(
      packageId: 'pkg_learning_canonical_seed_v11',
      paths: paths,
      courses: courses,
      modules: modules,
      lessons: lessons,
      quizzes: quizzes,
      signerIdentity: 'siraj.learning.curriculum.board',
      signature: 'sig_canonical_learning_v11_fiqh_aqidah_quran_hadith_seerah_muamalat_family_governance_medical_verified',
      publishedAt: DateTime.utc(2026, 9, 10),
    );
  }
}
