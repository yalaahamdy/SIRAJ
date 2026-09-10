import '../../../../../modules/learning/domain/course.dart';
import '../../../../../modules/learning/domain/course_module.dart';
import '../../../../../modules/learning/domain/evidence_link.dart';
import '../../../../../modules/learning/domain/learning_content_type.dart';
import '../../../../../modules/learning/domain/learning_objective.dart';
import '../../../../../modules/learning/domain/learning_path.dart' as lp;
import '../../../../../modules/learning/domain/lesson.dart';
import '../../../../../modules/learning/domain/lesson_section.dart';
import '../../../../../modules/learning/domain/quiz.dart';
import '../../../../../modules/learning/domain/quiz_question.dart';

/// بيانات مقرر الإيمان بالملائكة والكتب والرسل (5 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningAqidahMessengersData {
  static const String courseId = 'course_aqidah_angels_messengers';
  static const String pathId = 'path_aqidah_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الإيمان بالملائكة والكتب الإلهية والرسل الكرام',
      description: 'دراسة عقدية تأصيلية شاملة في أركان الإيمان بالملائكة ووظائفهم، وبالكتب السماوية المنزلة وهيمنة القرآن، وبالأنبياء والمرسلين وخاتمية رسالة محمد ﷺ.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_aqidah_angels_world', 'mod_aqidah_books_messengers'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_aqidah_angels_world',
        courseId: courseId,
        title: 'الوحدة الأولى: عالم الملائكة الأطهار',
        description: 'بيان حقيقة خلق الملائكة من نور، وعصمتهم، وأوصافهم، ووظائفهم الموكلة إليهم من الوحي وقبض الأرواح وكتابة الأعمال.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_aqidah_angels_creation_nature',
          'lsn_aqidah_angels_tasks_roles',
        ],
      ),
      CourseModule(
        moduleId: 'mod_aqidah_books_messengers',
        courseId: courseId,
        title: 'الوحدة الثانية: الإيمان بالكتب الإلهية والرسل الكرام',
        description: 'الإيمان بالكتب المنزلة وهيمنة القرآن، والإيمان برسل الله وتفاضلهم، وعصمتهم، وخاتمية نبوة نبينا محمد ﷺ وحقوقه الشريفة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_aqidah_angels_world'],
        lessonIds: const [
          'lsn_aqidah_holy_books',
          'lsn_aqidah_prophets_messengers',
          'lsn_aqidah_prophet_muhammad_seal',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: حقيقة الملائكة وخلقهم
    // -------------------------------------------------------------------------
    final evAngelsHadith = EvidenceLink.create(
      evidenceId: 'ev_ang_hadith_muslim',
      evidenceKey: 'hadith_angels_light',
      citation: 'صحيح مسلم: رقم 2996',
      sourceId: 'src_muslim_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_aqidah_angels_creation_nature',
      title: 'حقيقة الملائكة الكرام وخلقهم من نور وأوصافهم وعصمتهم',
      courseId: courseId,
      moduleId: 'mod_aqidah_angels_world',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_am1_1',
          title: 'معرفة حقيقة خلق الملائكة وأوصافهم الجبلية',
          description: 'أن يتعرف المتعلم على مادة خلقهم من نور، وعصمتهم من المعاصي، ودوام عبادتهم لله تعالى.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_am1_1',
          title: 'النص النبوي في أصل خلق الملائكة',
          contentType: LearningContentType.sourceText,
          content: 'عن عائشة رضي الله عنها قالت: قال رسول الله ﷺ: «خُلقت الملائكةُ من نور، وخُلق الجانُّ من مارجٍ من نار، وخُلق آدمُ مما وُصف لكم» رواه مسلم.',
          evidenceLinks: [evAngelsHadith],
          sourceAttribution: 'صحيح مسلم رقم 2996',
        ),
        LessonSection.create(
          sectionId: 'sec_am1_2',
          title: 'أوصاف الملائكة وعصمتهم المطلقة',
          contentType: LearningContentType.explanation,
          content: 'الملائكة عالم غيبي خلقهم الله لعبادته وطاعته، وهم أجسام نورانية لطيفة قادرة على التشكل بأشكال حسنة كما كان جبريل ينزل على النبي ﷺ في صورة دحية الكلبي أو في صورة أعرابي. وهم مفطورون على الطاعة التامة لا يعصون الله ما أمرهم ويفعلون ما يؤمرون، لا يوصفون بذكورة ولا أنوثة.',
          sourceAttribution: 'معارج القبول ج 1 ص 245',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_quran_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: وظائف الملائكة
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_aqidah_angels_tasks_roles',
      title: 'وظائف الملائكة الموكلة إليهم وأثر الإيمان بهم في السلوك',
      courseId: courseId,
      moduleId: 'mod_aqidah_angels_world',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_am2_1',
          title: 'حفظ مهام الملائكة الكبار وثمار الإيمان بهم',
          description: 'جبريل للوحي، ميكائيل للقطر، إسرافيل للصور، ملك الموت، والكرام الكاتبون.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_am2_1',
          title: 'الآيات الكريمة في وظائف الملائكة',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {قُلْ مَن كَانَ عَدُوًّا لِّجِبْرِيلَ فَإِنَّهُ نَزَّلَهُ عَلَىٰ قَلْبِكَ بِإِذْنِ اللَّهِ}. وقال: {وَإِنَّ عَلَيْكُمْ لَحَافِظِينَ * كِرَامًا كَاتِبِينَ * يَعْلَمُونَ مَا تَفْعَلُونَ}.',
          sourceAttribution: 'سورة البقرة: الآية 97، وسورة الانفطار: الآيات 10-12',
        ),
        LessonSection.create(
          sectionId: 'sec_am2_2',
          title: 'تفصيل الوظائف الموكلة والآثار السلوكية',
          contentType: LearningContentType.explanation,
          content: 'خص الله طوائف من الملائكة بمهام محددة: جبريل للوحي إلى الرسل، وميكائيل موكل بالقطر والنبات، وإسرافيل بالنفخ في الصور، وملك الموت بقبض الأرواح، ومالك خازن النار، ورضوان خازن الجنة، والحفظة الكاتبون للحسنات والسيئات، ومنكر ونكير لسؤال القبر. وثمرة الإيمان بهم: استشعار مراقبة الله، والحياء، وحب هذه المخلوقات القائمة بعبادة الله.',
          sourceAttribution: 'لوامع الأنوار البهية للسفاريني ج 2 ص 380',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_wasitiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: الإيمان بالكتب المنزلة
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_aqidah_holy_books',
      title: 'الإيمان بالكتب السماوية المنزلة وهيمنة القرآن وإعجازه وحفظه',
      courseId: courseId,
      moduleId: 'mod_aqidah_books_messengers',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_am3_1',
          title: 'الإيمان الجازم بالكتب المنزلة وهيمنة القرآن الخاتم',
          description: 'معرفة الكتب المسماة، والإيمان بأن القرآن ناسخ ومصدق ومهيمن ومحفوظ من كل تحريف.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_am3_1',
          title: 'النص الإلهي في حفظ القرآن وهيمنته',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ}. وقال: {وَأَنزَلْنَا إِلَيْكَ الْكِتَابَ بِالْحَقِّ مُصَدِّقًا لِّمَا بَيْنَ يَدَيْهِ مِنَ الْكِتَابِ وَمُهَيْمِنًا عَلَيْهِ}.',
          sourceAttribution: 'سورة الحجر: الآية 9، وسورة المائدة: الآية 48',
        ),
        LessonSection.create(
          sectionId: 'sec_am3_2',
          title: 'أحكام الإيمان بالكتب السابقة والقرآن العظيم',
          contentType: LearningContentType.explanation,
          content: 'الإيمان بالكتب ركن من أركان الإيمان؛ فنؤمن إجمالاً بأن الله أنزل على رسله كتباً بالحق والنور، ونؤمن تفصيلاً بما سمى الله منها: صحف إبراهيم وموسى، وتوراة موسى، وزبور داود، وإنجيل عيسى، وقرآن محمد ﷺ. ونعتقد أن الكتب السابقة نالها التحريف والتبديل على أيدي أهلها، بينما تكفل الله وحده بحفظ القرآن الكريم لفظاً ومعنى فلا يأتيه الباطل من بين يديه ولا من خلفه.',
          sourceAttribution: 'شرح العقيدة الطحاوية لابن أبي العز الحنفي ص 220',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_tahawiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: الإيمان بالأنبياء والرسل
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_aqidah_prophets_messengers',
      title: 'الإيمان بالأنبياء والرسل: أولو العزم، عصمتهم، وخصائص النبوة',
      courseId: courseId,
      moduleId: 'mod_aqidah_books_messengers',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_am4_1',
          title: 'فهم أصول الإيمان برسل الله وتفاضلهم وعصمتهم',
          description: 'التمييز بين النبي والرسول، ومعرفة أولي العزم الخمسة، وعصمة الأنبياء في البلاغ والكبائر.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_am4_1',
          title: 'الأمر الإلهي بالإيمان بجميع الرسل دون تفريق',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۚ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ}.',
          sourceAttribution: 'سورة البقرة: الآية 285',
        ),
        LessonSection.create(
          sectionId: 'sec_am4_2',
          title: 'حقائق النبوة وأولو العزم وعصمة الرسل',
          contentType: LearningContentType.explanation,
          content: 'الرسول من أوحي إليه بشرع جديد وأُمر بتبليغه، والنبي من أوحي إليه بشرع من قبله وجُدد على يديه. وأولو العزم من الرسل خمسة هم أفضل الخلق: نوح، وإبراهيم، وموسى، وعيسى، ومحمد ﷺ. والأنبياء والرسل معصومون إجماعاً في تبليغ الوحي وفي ارتكاب الكبائر وخوارم المروءة، وهم بشر لا يملكون من خصائص الربوبية شيئاً ولا يعلمون من الغيب إلا ما أطلعهم الله عليه.',
          sourceAttribution: 'منهاج السنة النبوية لابن تيمية ج 1 ص 470',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_minhaj_sunnah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: خاتمية نبوة محمد ﷺ وحقوقه
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_aqidah_prophet_muhammad_seal',
      title: 'خاتمية رسالة نبينا محمد ﷺ وعمومها وحقوقه الشريفة على أمته',
      courseId: courseId,
      moduleId: 'mod_aqidah_books_messengers',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_am5_1',
          title: 'ترسيخ الإيمان بخاتمية النبوة وحقوق المصطفى ﷺ',
          description: 'معرفة كفر من ادعى النبوة بعده، وحقوق النبي: المحبة، الطاعة، الاتباع، الأدب، ونصرة سنته.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_am5_1',
          title: 'النص القرآني والنبوي في خاتم النبيين',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {مَّا كَانَ مُحَمَّدٌ أَبَا أَحَدٍ مِّن رِّجَالِكُمْ وَلَٰكِن رَّسُولَ اللَّهِ وَخَاتَمَ النَّبِيِّينَ}. وقال ﷺ: «وأنا خاتم النبيين لا نبي بعدي» رواه الترمذي.',
          sourceAttribution: 'سورة الأحزاب: الآية 40، وسنن الترمذي رقم 2219',
        ),
        LessonSection.create(
          sectionId: 'sec_am5_2',
          title: 'حقوق النبي ﷺ الشريفة على أمته',
          contentType: LearningContentType.explanation,
          content: 'أوجب الله للنبي ﷺ حقوقاً عظيمة: 1. الإيمان بنبوته ورسالته العامة لجميع الثقلين، 2. محبته ﷺ محبة تفوق النفس والمال والولد، 3. طاعته فيما أمر وتصديقه فيما أخبر واجتناب ما عنه نهى وزجر، 4. اتباع سنته وتقديم قوله على قول كل أحد كائناً من كان، 5. الأدب عند ذكره بتوقيره والصلاة والسلام عليه، والذب عن سنته الشريفة.',
          sourceAttribution: 'الشفا بتعريف حقوق المصطفى للقاضي عياض ج 2 ص 15',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_tirmidhi_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Angels
    final q1 = QuizQuestion.create(
      questionId: 'q_am_angels_1',
      lessonId: 'lsn_aqidah_angels_tasks_roles',
      questionText: 'من هو الملك الموكل بالنزول بالوحي الإلهي من الله تعالى إلى أنبيائه ورسله؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qan1_1', text: 'جبريل عليه السلام (الروح الأمين)'),
        QuizOption(optionId: 'opt_qan1_2', text: 'ميكائيل عليه السلام'),
        QuizOption(optionId: 'opt_qan1_3', text: 'إسرافيل عليه السلام'),
      ],
      correctOptionIndices: const [0],
      explanation: 'جبريل عليه السلام هو الروح الأمين ورئيس الملائكة الموكل بحياة القلوب وهو الوحي الإلهي.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_aqidah_angels_belief',
      lessonId: 'lsn_aqidah_angels_tasks_roles',
      title: 'اختبار الإيمان بعالم الملائكة ووظائفهم',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Holy Books
    final q2 = QuizQuestion.create(
      questionId: 'q_am_books_1',
      lessonId: 'lsn_aqidah_holy_books',
      questionText: 'ما معنى هيمنة القرآن الكريم على سائر الكتب السماوية السابقة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qbk1_1', text: 'أنه شاهد ومؤتمن وحاكم وناسخ لها ومبين لما حرّف منها'),
        QuizOption(optionId: 'opt_qbk1_2', text: 'أنه مطابق لها في كل التفاصيل والشرائع القديمة'),
        QuizOption(optionId: 'opt_qbk1_3', text: 'أنه يلغي الإيمان بنزولها من عند الله'),
      ],
      correctOptionIndices: const [0],
      explanation: 'هيمنة القرآن تعني كونه حاكماً وشهيداً وناسخاً لما قبله، فما وافقه حق وما خالفه محرف مبدل.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_aqidah_holy_books',
      lessonId: 'lsn_aqidah_holy_books',
      title: 'اختبار الإيمان بالكتب السماوية وهيمنة القرآن',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Prophet's Rights & Seal of Prophethood
    final q3 = QuizQuestion.create(
      questionId: 'q_am_prophet_1',
      lessonId: 'lsn_aqidah_prophet_muhammad_seal',
      questionText: 'ما هو المعتقد الحق المجمع عليه في من ادعى النبوة بعد محمد ﷺ أو صدق مدعياً لها؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qpr1_1', text: 'كافر مكذب لصريح القرآن والسنة المتواترة بإجماع المسلمين'),
        QuizOption(optionId: 'opt_qpr1_2', text: 'مسلم مبتدع غير خارج من الملة'),
        QuizOption(optionId: 'opt_qpr1_3', text: 'مأجور باجتهاده'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أجمعت الأمة سلفاً وخلفاً على كفر من ادعى النبوة بعد النبي محمد ﷺ كذباً، لأنه مكذب لقوله تعالى: {وَخَاتَمَ النَّبِيِّينَ}.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_aqidah_prophet_rights',
      lessonId: 'lsn_aqidah_prophet_muhammad_seal',
      title: 'اختبار خاتمية النبوة وحقوق النبي ﷺ',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
