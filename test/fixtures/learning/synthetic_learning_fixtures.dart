import 'package:siraj/modules/learning/domain/canonical_learning_package.dart';
import 'package:siraj/modules/learning/domain/course.dart';
import 'package:siraj/modules/learning/domain/course_module.dart';
import 'package:siraj/modules/learning/domain/evidence_link.dart';
import 'package:siraj/modules/learning/domain/learning_content_type.dart';
import 'package:siraj/modules/learning/domain/learning_objective.dart';
import 'package:siraj/modules/learning/domain/learning_path.dart';
import 'package:siraj/modules/learning/domain/lesson.dart';
import 'package:siraj/modules/learning/domain/lesson_section.dart';
import 'package:siraj/modules/learning/domain/quiz.dart';
import 'package:siraj/modules/learning/domain/quiz_question.dart';

/// Synthetic Learning & Curriculum fixtures for testing (§46).
class SyntheticLearningFixtures {
  static LearningPath createPath({
    String pathId = 'path_fiqh_basics',
    String title = 'مسار الفقه التأسيسي للمسلم',
    String description = 'مسار شامل يتعلم فيه المسلم أحكام الطهارة والصلاة بأسلوب منهجي وميسر.',
    LearningLevel level = LearningLevel.beginner,
  }) {
    return LearningPath.create(
      pathId: pathId,
      title: title,
      description: description,
      category: 'فقه العبادات',
      level: level,
      courseIds: const ['course_taharah_101'],
      estimatedHours: 4,
    );
  }

  static Course createCourse({
    String courseId = 'course_taharah_101',
    String pathId = 'path_fiqh_basics',
    String title = 'مقرر فقه الطهارة والوضوء',
  }) {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: title,
      description: 'مقرر تأصيلي في شروط وأركان وسنن الوضوء والطهارة.',
      level: LearningLevel.beginner,
      moduleIds: const ['mod_wudu_basics'],
      author: 'لجنة التأصيل المنهجي',
      version: 1,
    );
  }

  static CourseModule createModule({
    String moduleId = 'mod_wudu_basics',
    String courseId = 'course_taharah_101',
    String title = 'الوحدة الأولى: أحكام الوضوء',
  }) {
    return CourseModule(
      moduleId: moduleId,
      courseId: courseId,
      title: title,
      description: 'دراسة أركان الوضوء وشروطه ومبطلاته.',
      orderIndex: 1,
      lessonIds: const ['lsn_wudu_pillars'],
    );
  }

  static Lesson createLesson({
    String lessonId = 'lsn_wudu_pillars',
    String courseId = 'course_taharah_101',
    String moduleId = 'mod_wudu_basics',
    int version = 1,
  }) {
    final obj = const LearningObjective(
      objectiveId: 'obj_1',
      title: 'معرفة فرائض الوضوء الأربعة المنصوصة في القرآن الكريم',
      description: 'أن يعدد المتعلم أركان الوضوء مع استحضار آية سورة المائدة.',
    );

    final ev1 = EvidenceLink.create(
      evidenceId: 'ev_ayah_wudu',
      evidenceKey: '5:6',
      citation: 'قوله تعالى: ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا قُمْتُمْ إِلَى الصَّلَاةِ فَاغْسِلُوا وُجُوهَكُمْ...﴾ [المائدة: 6]',
      sourceId: 'src_quran_canonical',
    );

    final s1 = LessonSection.create(
      sectionId: 'sec_1',
      title: 'النص القرآني في فرائض الوضوء',
      contentType: LearningContentType.sourceText,
      content: '﴿يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا قُمْتُمْ إِلَى الصَّلَاةِ فَاغْسِلُوا وُجُوهَكُمْ وَأَيْدِيَكُمْ إِلَى الْمَرَافِقِ وَامْسَحُوا بِرُءُوسِكُمْ وَأَرْجُلَكُمْ إِلَى الْكَعْبَيْنِ﴾',
      evidenceLinks: [ev1],
      sourceAttribution: 'سورة المائدة: الآية 6',
    );

    final s2 = LessonSection.create(
      sectionId: 'sec_2',
      title: 'البيان والتأصيل الفقهي للأركان',
      contentType: LearningContentType.explanation,
      content: 'أجمع أهل العلم على أن أركان الوضوء المذكورة في الآية أربعة: غسل الوجه، وغسل اليدين إلى المرفقين، ومسح الرأس، وغسل الرجلين إلى الكعبين.',
      sourceAttribution: 'المجموع للنووي ج 1 ص 240',
    );

    return Lesson.create(
      lessonId: lessonId,
      title: 'فرائض الوضوء وأركانه الأساسية',
      courseId: courseId,
      moduleId: moduleId,
      orderIndex: 1,
      objectives: [obj],
      sections: [s1, s2],
      sources: const ['src_quran_canonical', 'src_majmoo_test'],
      authorOrEditor: 'مركز إعداد المناهج',
      version: version,
      reviewState: 'APPROVED',
    );
  }

  static Quiz createQuiz({
    String quizId = 'quiz_wudu_1',
    String lessonId = 'lsn_wudu_pillars',
  }) {
    final opt1 = const QuizOption(optionId: 'opt_1', text: 'أربعة أركان منصوصة في آية المائدة');
    final opt2 = const QuizOption(optionId: 'opt_2', text: 'ركنان فقط');
    final opt3 = const QuizOption(optionId: 'opt_3', text: 'سبعة أركان بلا خلاف');

    final q1 = QuizQuestion.create(
      questionId: 'q_wudu_count',
      lessonId: lessonId,
      questionText: 'كم عدد فرائض الوضوء المنصوصة في آية سورة المائدة؟',
      questionType: QuestionType.multipleChoice,
      options: [opt1, opt2, opt3],
      correctOptionIndices: const [0],
      explanation: 'الفرائض المنصوصة في الآية أربعة: غسل الوجه، واليدين، ومسح الرأس، والرجلين.',
      sourceId: 'src_majmoo_test',
    );

    return Quiz.create(
      quizId: quizId,
      lessonId: lessonId,
      title: 'اختبار استيعاب فرائض الوضوء',
      questions: [q1],
      passingScorePercentage: 70,
    );
  }

  static CanonicalLearningPackage createPackage() {
    final path = createPath();
    final course = createCourse();
    final module = createModule();
    final lesson = createLesson();
    final quiz = createQuiz();

    return CanonicalLearningPackage.create(
      packageId: 'pkg_learning_test_v1',
      paths: [path],
      courses: [course],
      modules: [module],
      lessons: [lesson],
      quizzes: [quiz],
      signerIdentity: 'siraj.curriculum.board',
      signature: 'sig_canonical_valid_learning_123',
      publishedAt: DateTime.utc(2026, 8, 31),
    );
  }
}
