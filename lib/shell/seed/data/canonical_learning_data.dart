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
import 'learning/learning_taharah_data.dart';
import 'learning/learning_zakah_data.dart';
import 'learning/quran_sciences/learning_quran_sciences_data.dart';
import 'learning/quran_sciences/learning_quran_tafsir_mufassal_data.dart';
import 'learning/quran_sciences/learning_quran_tafsir_rules_data.dart';
import 'learning/quran_sciences/learning_quran_tajweed_data.dart';

/// Comprehensive canonical learning and curriculum dataset (Phase 1, 2, and 3)
/// Covers 3 major tracks: Fiqh of Worship, Islamic Creed (Aqidah), and Quranic Sciences & Tafsir
/// Includes 17 learning paths, 14 advanced courses, 28 modules, 87 in-depth lessons, and 44 quizzes (§31..§35).
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

    final paths = [
      pathFiqhComprehensive,
      pathAqidahComprehensive,
      pathQuranComprehensive,
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
    ];

    // -------------------------------------------------------------------------
    // 2. Courses (14 Advanced Courses)
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
    ];

    // -------------------------------------------------------------------------
    // 3. Modules (28 Core Modules)
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
    ];

    // -------------------------------------------------------------------------
    // 4. Lessons (87 In-Depth Canonical Lessons)
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
    ];

    // -------------------------------------------------------------------------
    // 5. Quizzes (44 Formative Assessment Quizzes)
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
    ];

    return CanonicalLearningPackage.create(
      packageId: 'pkg_learning_canonical_seed_v5',
      paths: paths,
      courses: courses,
      modules: modules,
      lessons: lessons,
      quizzes: quizzes,
      signerIdentity: 'siraj.learning.curriculum.board',
      signature: 'sig_canonical_learning_v5_fiqh_aqidah_quran_verified',
      publishedAt: DateTime.utc(2026, 9, 10),
    );
  }
}
