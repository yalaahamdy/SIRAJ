import '../../../modules/learning/domain/canonical_learning_package.dart';
import '../../../modules/learning/domain/course.dart';
import '../../../modules/learning/domain/course_module.dart';
import '../../../modules/learning/domain/learning_path.dart' as lp;
import '../../../modules/learning/domain/lesson.dart';
import '../../../modules/learning/domain/quiz.dart';
import 'learning/learning_fasting_data.dart';
import 'learning/learning_hajj_data.dart';
import 'learning/learning_salah_data.dart';
import 'learning/learning_taharah_data.dart';
import 'learning/learning_zakah_data.dart';

/// Comprehensive canonical learning and curriculum dataset (Phase 1: Fiqh of Worship Comprehensive Track)
/// Includes 6 learning paths, 5 advanced courses, 10 modules, 32 in-depth lessons, and 17 quizzes (§31..§35).
class CanonicalLearningData {
  static CanonicalLearningPackage getPackage() {
    // -------------------------------------------------------------------------
    // 1. Learning Paths
    // -------------------------------------------------------------------------

    // A. Master Comprehensive Worship Path (Unites all 5 courses)
    final pathComprehensive = lp.LearningPath.create(
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

    // B. Individual Specialized Paths
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

    final paths = [
      pathComprehensive,
      pathTaharah,
      pathSalah,
      pathZakah,
      pathFasting,
      pathHajj,
    ];

    // -------------------------------------------------------------------------
    // 2. Courses (5 Advanced Courses)
    // -------------------------------------------------------------------------
    final List<Course> courses = [
      LearningTaharahData.getCourse(),
      LearningSalahData.getCourse(),
      LearningZakahData.getCourse(),
      LearningFastingData.getCourse(),
      LearningHajjData.getCourse(),
    ];

    // -------------------------------------------------------------------------
    // 3. Modules (10 Core Modules)
    // -------------------------------------------------------------------------
    final List<CourseModule> modules = [
      ...LearningTaharahData.getModules(),
      ...LearningSalahData.getModules(),
      ...LearningZakahData.getModules(),
      ...LearningFastingData.getModules(),
      ...LearningHajjData.getModules(),
    ];

    // -------------------------------------------------------------------------
    // 4. Lessons (32 In-Depth Canonical Lessons)
    // -------------------------------------------------------------------------
    final List<Lesson> lessons = [
      ...LearningTaharahData.getLessons(),
      ...LearningSalahData.getLessons(),
      ...LearningZakahData.getLessons(),
      ...LearningFastingData.getLessons(),
      ...LearningHajjData.getLessons(),
    ];

    // -------------------------------------------------------------------------
    // 5. Quizzes (17 Formative Assessment Quizzes)
    // -------------------------------------------------------------------------
    final List<Quiz> quizzes = [
      ...LearningTaharahData.getQuizzes(),
      ...LearningSalahData.getQuizzes(),
      ...LearningZakahData.getQuizzes(),
      ...LearningFastingData.getQuizzes(),
      ...LearningHajjData.getQuizzes(),
    ];

    return CanonicalLearningPackage.create(
      packageId: 'pkg_learning_canonical_seed_v3',
      paths: paths,
      courses: courses,
      modules: modules,
      lessons: lessons,
      quizzes: quizzes,
      signerIdentity: 'siraj.learning.curriculum.board',
      signature: 'sig_canonical_learning_v3_worship_comprehensive_verified',
      publishedAt: DateTime.utc(2026, 9, 10),
    );
  }
}
