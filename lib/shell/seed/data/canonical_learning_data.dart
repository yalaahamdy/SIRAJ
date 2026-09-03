import '../../../modules/learning/domain/canonical_learning_package.dart';
import '../../../modules/learning/domain/course.dart';
import '../../../modules/learning/domain/course_module.dart';
import '../../../modules/learning/domain/evidence_link.dart';
import '../../../modules/learning/domain/learning_content_type.dart';
import '../../../modules/learning/domain/learning_objective.dart';
import '../../../modules/learning/domain/learning_path.dart' as lp;
import '../../../modules/learning/domain/lesson.dart';
import '../../../modules/learning/domain/lesson_section.dart';
import '../../../modules/learning/domain/quiz.dart';
import '../../../modules/learning/domain/quiz_question.dart';

/// Comprehensive canonical learning and curriculum dataset (3 courses, 8 lessons, 3 quizzes) (§31..§35).
class CanonicalLearningData {
  static CanonicalLearningPackage getPackage() {
    // -------------------------------------------------------------------------
    // 1. Path 1: Fiqh of Taharah & Wudu
    // -------------------------------------------------------------------------
    final pathTaharah = lp.LearningPath.create(
      pathId: 'path_fiqh_taharah',
      title: 'مسار فقه الطهارة والوضوء',
      description: 'مسار منهجي تأصيلي يتعلم فيه المسلم أحكام الطهارة وشروط الوضوء وأركانه وسننه ونواقضه.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const ['course_taharah_101'],
      estimatedHours: 3,
    );

    final courseTaharah = Course.create(
      courseId: 'course_taharah_101',
      pathId: 'path_fiqh_taharah',
      title: 'مقرر فقه الوضوء والطهارة',
      description: 'دراسة تأصيلية مفصلة في شروط وأركان وسنن ومبطلات الوضوء.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_wudu_basics'],
      author: 'لجنة التأصيل والتعليم المنهجي',
      version: 1,
    );

    final moduleWudu = CourseModule(
      moduleId: 'mod_wudu_basics',
      courseId: 'course_taharah_101',
      title: 'الوحدة الأولى: أحكام الوضوء التأسيسية',
      description: 'بيان الفرائض الأربعة والسنن والنواقض المجمع عليها.',
      orderIndex: 1,
      lessonIds: const ['lsn_wudu_pillars', 'lsn_wudu_sunan', 'lsn_wudu_nullifiers'],
    );

    // Lesson 1: Wudu Pillars
    final evWudu1 = EvidenceLink.create(
      evidenceId: 'ev_wudu_ayah',
      evidenceKey: '5:6',
      citation: 'سورة المائدة: الآية 6',
      sourceId: 'src_quran_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_wudu_pillars',
      title: 'فرائض الوضوء وأركانه الأساسية',
      courseId: 'course_taharah_101',
      moduleId: 'mod_wudu_basics',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_w1',
          title: 'معرفة فرائض الوضوء الأربعة المنصوص عليها في القرآن',
          description: 'أن يعدد المتعلم أركان الوضوء مع استحضار آية سورة المائدة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_w1_1',
          title: 'النص القرآني في فرائض الوضوء',
          contentType: LearningContentType.sourceText,
          content: 'غسل الوجه واليدين إلى المرافق ومسح الرأس وغسل الرجلين إلى الكعبين.',
          evidenceLinks: [evWudu1],
          sourceAttribution: 'سورة المائدة: الآية 6',
        ),
        LessonSection.create(
          sectionId: 'sec_w1_2',
          title: 'التأصيل الفقهي للأركان',
          contentType: LearningContentType.explanation,
          content: 'أجمع العلماء على أن أركان الوضوء المذكورة في الآية أربعة: غسل الوجه، وغسل اليدين إلى المرفقين، ومسح الرأس، وغسل الرجلين إلى الكعبين، وزاد الجمهور النية والترتيب والموالاة.',
          sourceAttribution: 'المجموع للنووي ج 1 ص 240',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // Lesson 2: Wudu Sunan
    final lsn2 = Lesson.create(
      lessonId: 'lsn_wudu_sunan',
      title: 'سنن الوضوء ومستحباته المأثورة',
      courseId: 'course_taharah_101',
      moduleId: 'mod_wudu_basics',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_w2',
          title: 'التمييز بين فرائض الوضوء وسننه المأثورة',
          description: 'أن يتقن المتوضئ التسمية والسواك وتثليث الغسل والبدء باليمين.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_w2_1',
          title: 'السنن القولية والفعلية للوضوء',
          contentType: LearningContentType.explanation,
          content: 'من سنن الوضوء المؤكدة: التسمية في أوله، واستعمال السواك، وغسل الكفين ثلاثاً قبل إدخالهما الإناء، والمضمضة والاستنشاق، وتخليل اللحية الكثة وأصابع اليدين والرجلين، والتيامن، والتثليث في الغسل، والدعاء المأثور عقبه.',
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 140',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // Lesson 3: Wudu Nullifiers
    final lsn3 = Lesson.create(
      lessonId: 'lsn_wudu_nullifiers',
      title: 'نواقض الوضوء ومبطلاته',
      courseId: 'course_taharah_101',
      moduleId: 'mod_wudu_basics',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_w3',
          title: 'إدراك ما ينقض الوضوء بيقين وما لا ينقضه بالشك',
          description: 'التعرف على الخارج من السبيلين والنوم المستغرق وزوال العقل.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_w3_1',
          title: 'النواقض المجمع عليها',
          contentType: LearningContentType.explanation,
          content: 'ينقض الوضوء: الخارج من أحد السبيلين من بول أو غائط أو ريح، وزوال العقل بنوم مستغرق أو إغماء، وأكل لحم الإبل عند الحنابلة، واليقين لا يزول بالشك عياذاً من الوسواس.',
          sourceAttribution: 'بداية المجتهد ج 1 ص 45',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // 2. Path 2: Salah Pillars & Sunan
    // -------------------------------------------------------------------------
    final pathSalah = lp.LearningPath.create(
      pathId: 'path_fiqh_salah',
      title: 'مسار أركان الصلاة وسننها',
      description: 'مسار تعليمي لتعلّم شروط الصلاة وأركانها الأربعة عشر وسننها القولية والفعلية وسجود السهو.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const ['course_salah_101'],
      estimatedHours: 4,
    );

    final courseSalah = Course.create(
      courseId: 'course_salah_101',
      pathId: 'path_fiqh_salah',
      title: 'مقرر صفة الصلاة المعتمدة',
      description: 'دراسة مفصلة في هيئة الصلاة من تكبيرة الإحرام إلى التسليم.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_salah_pillars'],
      author: 'لجنة التأصيل والتعليم المنهجي',
      version: 1,
    );

    final moduleSalah = CourseModule(
      moduleId: 'mod_salah_pillars',
      courseId: 'course_salah_101',
      title: 'الوحدة الأولى: الشروط والأركان وسجود السهو',
      description: 'أركان الصلاة الـ 14 وما تبطل بتركه عمداً أو سهواً.',
      orderIndex: 1,
      lessonIds: const ['lsn_salah_conditions', 'lsn_salah_pillars', 'lsn_salah_duties'],
    );

    final lsn4 = Lesson.create(
      lessonId: 'lsn_salah_conditions',
      title: 'شروط صحة الصلاة واستقبال القبلة',
      courseId: 'course_salah_101',
      moduleId: 'mod_salah_pillars',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s1',
          title: 'تمييز شروط الصلاة السابقة عليها',
          description: 'معرفة الإسلام، والعقل، والتمييز، ودخول الوقت، والطهارة، وستر العورة، واستقبال القبلة، والنية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s1_1',
          title: 'الشروط التسعة لصحة الصلاة',
          contentType: LearningContentType.explanation,
          content: 'شروط الصلاة تسعة: الإسلام، والعقل، والتمييز، ورفع الحدث، وإزالة النجاسة، وستر العورة، ودخول الوقت، واستقبال القبلة، والنية. والشرط يسبق العبادة ويستمر معها.',
          sourceAttribution: 'شروط الصلاة وأركانها وواجباتها',
        ),
      ],
      sources: const ['src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    final lsn5 = Lesson.create(
      lessonId: 'lsn_salah_pillars',
      title: 'أركان الصلاة الأربعة عشر',
      courseId: 'course_salah_101',
      moduleId: 'mod_salah_pillars',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s2',
          title: 'حفظ أركان الصلاة الأربعة عشر وما لا يسقط سهواً',
          description: 'القيام، وتكبيرة الإحرام، وقراءة الفاتحة، والركوع، والسجود، والرفع منهما، والاطمئنان، والتشهد الأخير، والسلام.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s2_1',
          title: 'تفصيل الأركان الـ 14',
          contentType: LearningContentType.explanation,
          content: 'أركان الصلاة: 1. القيام مع القدرة في الفرض، 2. تكبيرة الإحرام، 3. قراءة الفاتحة، 4. الركوع، 5. الرفع منه، 6. الاعتدال قائماً، 7. السجود على الأعضاء السبعة، 8. الرفع من السجود، 9. الجلوس بين السجدتين، 10. الطمأنينة في الكل، 11. التشهد الأخير، 12. الجلوس له، 13. التسليم، 14. الترتيب.',
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 500',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    final lsn6 = Lesson.create(
      lessonId: 'lsn_salah_duties',
      title: 'واجبات الصلاة وسجود السهو',
      courseId: 'course_salah_101',
      moduleId: 'mod_salah_pillars',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s3',
          title: 'معرفة واجبات الصلاة التي تجبر بسجود السهو',
          description: 'التكبيرات غير الإحرام، والتسبيح في الركوع والسجود، والتشهد الأول.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s3_1',
          title: 'الواجبات الثمانية ومسائل السهو',
          contentType: LearningContentType.explanation,
          content: 'الواجبات هي ما تبطل الصلاة بتركه عمداً ويسقط سهواً ويجبر بسجود السهو: تكبيرات الانتقال، قول سمع الله لمن حمده للإمام والمنفرد، ربنا ولك الحمد للكل، سبحان ربي العظيم في الركوع، سبحان ربي الأعلى في السجود، رب اغفر لي بين السجدتين، والتشهد الأول والجلوس له.',
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 680',
        ),
      ],
      sources: const ['src_majmoo_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // 3. Path 3: Fiqh of Fasting (Ramadan Basics)
    // -------------------------------------------------------------------------
    final pathFasting = lp.LearningPath.create(
      pathId: 'path_fiqh_fasting',
      title: 'مسار أحكام الصيام الأساسية',
      description: 'مسار شامل يتعلم فيه الصائم شروط الصيام ومفطراته ومستحباته وأعذار الفطر والقضاء.',
      category: 'فقه العبادات',
      level: lp.LearningLevel.beginner,
      courseIds: const ['course_fasting_101'],
      estimatedHours: 2,
    );

    final courseFasting = Course.create(
      courseId: 'course_fasting_101',
      pathId: 'path_fiqh_fasting',
      title: 'مقرر فقه الصيام ومقاصده',
      description: 'أحكام صيام شهر رمضان المبارك وسنن الإمساك والإفطار.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_fasting_basics'],
      author: 'لجنة التأصيل والتعليم المنهجي',
      version: 1,
    );

    final moduleFasting = CourseModule(
      moduleId: 'mod_fasting_basics',
      courseId: 'course_fasting_101',
      title: 'الوحدة الأولى: أركان الصيام ومفسداته',
      description: 'الإمساك والنية والمفطرات المعاصرة.',
      orderIndex: 1,
      lessonIds: const ['lsn_fasting_conditions', 'lsn_fasting_nullifiers'],
    );

    final lsn7 = Lesson.create(
      lessonId: 'lsn_fasting_conditions',
      title: 'شروط وجوب صيام رمضان وصحته',
      courseId: 'course_fasting_101',
      moduleId: 'mod_fasting_basics',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_f1',
          title: 'معرفة من يجب عليه الصوم ومن يرخص له الفطر',
          description: 'الإسلام، البلوغ، العقل، القدرة، الإقامة، وخلو المرأة من الحيض والنفاس.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_f1_1',
          title: 'شروط الوجوب والصحة',
          contentType: LearningContentType.explanation,
          content: 'يشترط لوجوب الصوم: الإسلام، والبلوغ، والعقل، والقدرة، والإقامة، والسلامة من الموانع كالمرض الشديد والسفر والحيض، وتصح من الصبي المميز أجراً وتدريباً.',
          sourceAttribution: 'المجموع شرح المهذب ج 6 ص 250',
        ),
      ],
      sources: const ['src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    final lsn8 = Lesson.create(
      lessonId: 'lsn_fasting_nullifiers',
      title: 'مفسدات الصيام وما يعفى عنه',
      courseId: 'course_fasting_101',
      moduleId: 'mod_fasting_basics',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_f2',
          title: 'معرفة المفطرات الظاهرة والباطنة',
          description: 'الأكل والشرب عمداً، وما يدخل الجوف من منافذ مفتوحة، والفرق بين الناسي والمتعمد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_f2_1',
          title: 'المفطرات وما لا يفطر',
          contentType: LearningContentType.explanation,
          content: 'يفسد الصوم بالأكل والشرب عمداً، والجماع، وإنزال المني بشهوة، والاستقاءة عمداً. أما من أكل أو شرب ناسياً فصومه صحيح ويتم صومه، وقطرة العين والأذن وبخاخ الربو وتحليل الدم اليسير لا يفطر على الراجح.',
          sourceAttribution: 'المغني لابن قدامة ج 3 ص 105',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // 4. Assessment Quizzes
    // -------------------------------------------------------------------------
    // Quiz 1: Wudu Pillars
    final q1 = QuizQuestion.create(
      questionId: 'q_wudu_1',
      lessonId: 'lsn_wudu_pillars',
      questionText: 'كم عدد فرائض الوضوء المنصوص عليها صراحة في سورة المائدة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_1', text: 'أربعة فرائض (غسل الوجه واليدين ومسح الرأس وغسل الرجلين)'),
        QuizOption(optionId: 'opt_2', text: 'ستة فرائض'),
        QuizOption(optionId: 'opt_3', text: 'ثمانية فرائض'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الفرائض الأربعة المذكورة بنص الآية الكريمة هي: غسل الوجه، وغسل اليدين إلى المرافق، ومسح الرأس، وغسل الأرجل إلى الكعبين.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_wudu_1',
      lessonId: 'lsn_wudu_pillars',
      title: 'اختبار فرائض الوضوء وأركانه',
      questions: [q1],
      passingScorePercentage: 70,
    );

    // Quiz 2: Salah Pillars
    final q2 = QuizQuestion.create(
      questionId: 'q_salah_1',
      lessonId: 'lsn_salah_pillars',
      questionText: 'ما الفرق بين ركن الصلاة وواجبها عند السهو؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_s1', text: 'الركن لا يسقط سهواً ولابد من الإتيان به، بينما الواجب يجبر بسجود السهو'),
        QuizOption(optionId: 'opt_s2', text: 'الركن يسقط بسجود السهو دائماً'),
        QuizOption(optionId: 'opt_s3', text: 'لا فرق بينهما في الحكم'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أركان الصلاة لا تسقط بحال، فإن نسيها لزمه الإتيان بها وسجود السهو، أما الواجبات فتسقط سهواً وتجبر بسجدتي السهو.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_salah_1',
      lessonId: 'lsn_salah_pillars',
      title: 'اختبار أركان الصلاة ومبطلاتها',
      questions: [q2],
      passingScorePercentage: 70,
    );

    // Quiz 3: Fasting
    final q3 = QuizQuestion.create(
      questionId: 'q_fast_1',
      lessonId: 'lsn_fasting_nullifiers',
      questionText: 'ما حكم من أكل أو شرب في نهار رمضان ناسياً؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_f1', text: 'صومه صحيح ويتم صومه ولا قضاء عليه ولا كفارة'),
        QuizOption(optionId: 'opt_f2', text: 'يبطل صومه وعليه القضاء'),
        QuizOption(optionId: 'opt_f3', text: 'عليه كفارة مغلظة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقول النبي ﷺ: "من نسي وهو صائم، فأكل أو شرب، فليتم صومه، فإنما أطعمه الله وسقاه" رواه البخاري ومسلم.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_fasting_1',
      lessonId: 'lsn_fasting_nullifiers',
      title: 'اختبار مفسدات الصيام وما يعفى عنه',
      questions: [q3],
      passingScorePercentage: 70,
    );

    return CanonicalLearningPackage.create(
      packageId: 'pkg_learning_canonical_seed_v2',
      paths: [pathTaharah, pathSalah, pathFasting],
      courses: [courseTaharah, courseSalah, courseFasting],
      modules: [moduleWudu, moduleSalah, moduleFasting],
      lessons: [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6, lsn7, lsn8],
      quizzes: [quiz1, quiz2, quiz3],
      signerIdentity: 'siraj.learning.curriculum.board',
      signature: 'sig_canonical_learning_v2_s21_verified',
      publishedAt: DateTime.utc(2026, 9, 2),
    );
  }
}
