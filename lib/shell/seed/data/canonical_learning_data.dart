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

/// Comprehensive canonical learning and curriculum dataset (Phase 1 & Phase 2)
/// Covers 2 major tracks: Fiqh of Worship & Islamic Creed (Aqidah)
/// Includes 12 learning paths, 10 advanced courses, 20 modules, 61 in-depth lessons, and 32 quizzes (§31..§35).
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

    final paths = [
      pathFiqhComprehensive,
      pathAqidahComprehensive,
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
    ];

    // -------------------------------------------------------------------------
    // 2. Courses (10 Advanced Courses)
    // -------------------------------------------------------------------------
    final List<Course> courses = [
      // Fiqh of Worship Courses
      LearningTaharahData.getCourse(),
      LearningSalahData.getCourse(),
      LearningZakahData.getCourse(),
      LearningFastingData.getCourse(),
      LearningHajjData.getCourse(),
      // Islamic Creed (Aqidah) Courses
      LearningAqidahTawheedData.getCourse(),
      LearningAqidahMessengersData.getCourse(),
      LearningAqidahAfterlifeData.getCourse(),
      LearningAqidahQadarData.getCourse(),
      LearningAqidahSunnahData.getCourse(),
    ];

    // -------------------------------------------------------------------------
    // 3. Modules (20 Core Modules)
    // -------------------------------------------------------------------------
    final List<CourseModule> modules = [
      // Fiqh of Worship Modules
      ...LearningTaharahData.getModules(),
      ...LearningSalahData.getModules(),
      ...LearningZakahData.getModules(),
      ...LearningFastingData.getModules(),
      ...LearningHajjData.getModules(),
      // Islamic Creed (Aqidah) Modules
      ...LearningAqidahTawheedData.getModules(),
      ...LearningAqidahMessengersData.getModules(),
      ...LearningAqidahAfterlifeData.getModules(),
      ...LearningAqidahQadarData.getModules(),
      ...LearningAqidahSunnahData.getModules(),
    ];

    // -------------------------------------------------------------------------
    // 4. Lessons (61 In-Depth Canonical Lessons)
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
    ];

    // -------------------------------------------------------------------------
    // 5. Quizzes (32 Formative Assessment Quizzes)
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
    ];

    return CanonicalLearningPackage.create(
      packageId: 'pkg_learning_canonical_seed_v4',
      paths: paths,
      courses: courses,
      modules: modules,
      lessons: lessons,
      quizzes: quizzes,
      signerIdentity: 'siraj.learning.curriculum.board',
      signature: 'sig_canonical_learning_v4_fiqh_aqidah_verified',
      publishedAt: DateTime.utc(2026, 9, 10),
    );
  }
}
