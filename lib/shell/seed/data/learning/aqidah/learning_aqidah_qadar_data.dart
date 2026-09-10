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

/// بيانات مقرر الإيمان بالقدر خيره وشره (5 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningAqidahQadarData {
  static const String courseId = 'course_aqidah_qadar';
  static const String pathId = 'path_aqidah_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الإيمان بالقدر خيره وشره ومراتب القضاء',
      description: 'دراسة عقدية تأصيلية شاملة في الركن السادس من أركان الإيمان: مراتب القدر الأربعة، ومشيئة الله ومشيئة العبد، والرد على شبهات الجبر والتعطيل، وفقه الأخذ بالأسباب والرضا بالقضاء.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_aqidah_qadar_ranks', 'mod_aqidah_qadar_human_will'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_aqidah_qadar_ranks',
        courseId: courseId,
        title: 'الوحدة الأولى: مراتب القدر الأربعة واللوح المحفوظ',
        description: 'بيان حقيقة القدر، ومرتبة العلم الإلهي الشامل، والكتابة في اللوح المحفوظ قبل خلق السماوات والأرض، والمشيئة النافذة، والخلق والإيجاد.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_aqidah_qadar_concept_knowledge',
          'lsn_aqidah_qadar_writing_will',
          'lsn_aqidah_qadar_creation',
        ],
      ),
      CourseModule(
        moduleId: 'mod_aqidah_qadar_human_will',
        courseId: courseId,
        title: 'الوحدة الثانية: مشيئة العبد والأسباب والرضا بالقضاء',
        description: 'إثبات قدرة العبد واختياره التابع لمشيئة الله، والتفريق بين الإرادة الكونية والشرعية، والجمع بين التوكل والأخذ بالأسباب وثمرات الرضا.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_aqidah_qadar_ranks'],
        lessonIds: const [
          'lsn_aqidah_human_will_choice',
          'lsn_aqidah_causes_reliance_contentment',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: حقيقة القدر ومرتبة العلم
    // -------------------------------------------------------------------------
    final evQadarHadith = EvidenceLink.create(
      evidenceId: 'ev_qad_hadith_jibril',
      evidenceKey: 'hadith_jibril_qadar',
      citation: 'صحيح مسلم: رقم 8',
      sourceId: 'src_muslim_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_aqidah_qadar_concept_knowledge',
      title: 'حقيقة الإيمان بالقدر ومشروعيته ومرتبة العلم الإلهي الشامل',
      courseId: courseId,
      moduleId: 'mod_aqidah_qadar_ranks',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qd1_1',
          title: 'معرفة مفهوم القدر ومرتبة العلم الأزلي المحيط',
          description: 'أن يدرك المتعلم أن الإيمان بالقدر ركن أصيل، وأن علم الله محيط بما كان وما يكون وما لم يكن لو كان كيف يكون.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qd1_1',
          title: 'النص في ركنية الإيمان بالقدر',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {إِنَّا كُلَّ شَيْءٍ خَلَقْنَاهُ بِقَدَرٍ}. وقال النبي ﷺ لجبريل حين سأله عن الإيمان: «وأن تؤمن بالقدر خيره وشره» رواه مسلم.',
          evidenceLinks: [evQadarHadith],
          sourceAttribution: 'سورة القمر: الآية 49، وصحيح مسلم رقم 8',
        ),
        LessonSection.create(
          sectionId: 'sec_qd1_2',
          title: 'مرتبة العلم الإلهي الأزلي والمحيط',
          contentType: LearningContentType.explanation,
          content: 'المرتبة الأولى من مراتب القدر هي «العلم»: وهو إيمان جازم بأن الله تعالى علم أزلاً بكل شيء من حركات وسكنات، وأرزاق وآجال، وأفعال العباد وطاعتهم ومعصيتهم، وعلم ما كان، وما سيكون، وما لم يكن لو كان كيف كان يكون، لا يعزب عنه مثقال ذرة في السماوات ولا في الأرض.',
          sourceAttribution: 'شفاء العليل في مسائل القضاء والقدر والحكمة والتعليل لابن القيم ص 25',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: مرتبتا الكتابة والمشيئة
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_aqidah_qadar_writing_will',
      title: 'مرتبة الكتابة في اللوح المحفوظ ومرتبة المشيئة الإلهية النافذة',
      courseId: courseId,
      moduleId: 'mod_aqidah_qadar_ranks',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qd2_1',
          title: 'فهم كتابة المقادير ونفوذ مشيئة الله في الكون',
          description: 'الكتابة في اللوح المحفوظ قبل خلق السماوات والأرض بخمسين ألف سنة، وأن ما شاء الله كان وما لم يشأ لم يكن.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qd2_1',
          title: 'النص النبوي في كتابة المقادير قبل الخلق',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «كتب الله مقادير الخلائق قبل أن يخلق السماوات والأرض بخمسين ألف سنة، وكان عرشه على الماء» رواه مسلم.',
          sourceAttribution: 'صحيح مسلم رقم 2653',
        ),
        LessonSection.create(
          sectionId: 'sec_qd2_2',
          title: 'الجمع بين الكتابة والمشيئة النافذة',
          contentType: LearningContentType.explanation,
          content: 'المرتبة الثانية «الكتابة»: أن الله كتب كل مقادير المخلوقات في اللوح المحفوظ، فلا تبديل لما كتبه. والمرتبة الثالثة «المشيئة»: الإيمان بأن مشيئة الله نافذة، وقدرته شاملة، فما شاء الله كان ولا راد لقضائه، وما لم يشأ لم يكن ولا معقب لحكمه، ولا يخرج عن مشيئته شيء في الوجود.',
          sourceAttribution: 'شرح العقيدة الواسطية لابن عثيمين ج 2 ص 180',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_wasitiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: مرتبة الخلق
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_aqidah_qadar_creation',
      title: 'مرتبة الخلق والتكوين: شمول خلق الله للذوات والأفعال',
      courseId: courseId,
      moduleId: 'mod_aqidah_qadar_ranks',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qd3_1',
          title: 'الإيمان بمرتبة الخلق الرابعة',
          description: 'أن الله خالق كل صانع وصنعته، وخالق أفعال العباد وقدراتهم وإراداتهم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qd3_1',
          title: 'النص الإلهي في خلق كل شيء',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {اللَّهُ خَالِقُ كُلِّ شَيْءٍ ۖ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ وَكِيلٌ}. وقال حكاية عن إبراهيم: {وَاللَّهُ خَلَقَكُمْ وَمَا تَعْمَلُونَ}.',
          sourceAttribution: 'سورة الزمر: الآية 62، وسورة الصافات: الآية 96',
        ),
        LessonSection.create(
          sectionId: 'sec_qd3_2',
          title: 'تقرير أهل السنة في مرتبة الخلق',
          contentType: LearningContentType.explanation,
          content: 'المرتبة الرابعة «الخلق»: أن تؤمن بأن الله خالق كل شيء، ما من ذرة في الكون إلا والله بارئها وخالقها. وأفعال العباد من جملة المخلوقات؛ فالله خلق العبد وخلق فيه القدرة والإرادة، وإذا وُجدت القدرة التامة والإرادة الجازمة وُجد الفعل بمشيئة الله وخلقه، فالعبد فاعل حقيقة، والله خالق فعله.',
          sourceAttribution: 'منهاج السنة النبوية لابن تيمية ج 3 ص 110',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_minhaj_sunnah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: مشيئة العبد والاختيار
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_aqidah_human_will_choice',
      title: 'إثبات المشيئة والاختيار للعبد والرد الحاسم على الجبرية والقدرية',
      courseId: courseId,
      moduleId: 'mod_aqidah_qadar_human_will',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qd4_1',
          title: 'بيان وسطية أهل السنة بين الجبر المحض ونفي القدر',
          description: 'إثبات أن الإنسان مخير ومسؤول عن أفعاله وله مشيئة حقيقية تحت مشيئة الله الكونية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qd4_1',
          title: 'الآية الجامعة بين مشيئة العبد ومشيئة الرب',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {لِمَن شَاءَ مِنكُمْ أَن يَسْتَقِيمَ * وَمَا تَشَاءُونَ إِلَّا أَن يَشَاءَ اللَّهُ رَبُّ الْعَالَمِينَ}.',
          sourceAttribution: 'سورة التكوير: الآيتان 28-29',
        ),
        LessonSection.create(
          sectionId: 'sec_qd4_2',
          title: 'وسطية أهل السنة والرد على الفرق المنحرفة',
          contentType: LearningContentType.explanation,
          content: 'أهل السنة وسط بين طائفتين: 1. الجبرية الذين زعموا أن العبد كالريشة في مهب الريح مسلوب الإرادة، وهذا باطل يناقض العدل الإلهي والتكليف، 2. القدرية (المجوسية) الذين زعموا أن العبد يخلق فعل نفسه مستقلاً عن مشيئة الله وعلمه. أما معتقد السلف: فللعبد مشيئة واختيار حقيقي يُثاب عليه ويعاقب، ولكن مشيئته تابعة لمشيئة الله المحيطة ولا تخرج عنها.',
          sourceAttribution: 'شرح الطحاوية ص 310',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_tahawiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الأخذ بالأسباب والرضا بالقضاء
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_aqidah_causes_reliance_contentment',
      title: 'مشروعية الأخذ بالأسباب مع توكل القلب وثمرات الرضا بالقضاء',
      courseId: courseId,
      moduleId: 'mod_aqidah_qadar_human_will',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qd5_1',
          title: 'الربط المنهجي بين الأسباب والتوكل والسكينة الإيمانية',
          description: 'أن الأخذ بالأسباب سنة نبوية والاعتماد عليها شرك وتركها قدح في العقل، وثمار الرضا عند المصائب.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qd5_1',
          title: 'النص النبوي في العمل ومغالبة الأقدار بالأقدار',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «احرص على ما ينفعك، واستعن بالله ولا تعجز، وإن أصابك شيء فلا تقل: لو أني فعلت كذا كان كذا وكذا، ولكن قل: قَدَرُ اللهِ وما شاء فعل، فإن «لو» تفتح عمل الشيطان» رواه مسلم.',
          sourceAttribution: 'صحيح مسلم رقم 2664',
        ),
        LessonSection.create(
          sectionId: 'sec_qd5_2',
          title: 'قواعد التوكل والرضا عند السلف',
          contentType: LearningContentType.explanation,
          content: 'الإيمان بالقدر يورث المسلم شجاعة لا تنثني وراحة نفسية عميقة؛ فلا يأس على ما فات ولا بطر بما آت، كما قال تعالى: {لِّكَيْلَا تَأْسَوْا عَلَىٰ مَا فَاتَكُمْ وَلَا تَفْرَحُوا بِمَا آتَاكُمْ}. والمسلم مأمور شرعاً ببذل السبب المشروع كالعلاج والتجارة، مع قطع التفات القلب للأسباب وجعل التوكل خالصاً لله وحده.',
          sourceAttribution: 'مدارج السالكين لابن قيم الجوزية ج 2 ص 115',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_madarij_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Qadar Ranks
    final q1 = QuizQuestion.create(
      questionId: 'q_qd_ranks_1',
      lessonId: 'lsn_aqidah_qadar_writing_will',
      questionText: 'ما هي المراتب الأربعة التي لا يصح الإيمان بالقدر إلا بالاعتقاد الجازم بها جميعاً؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qqr1_1', text: 'العلم، والكتابة في اللوح المحفوظ، والمشيئة النافذة، والخلق والإيجاد'),
        QuizOption(optionId: 'opt_qqr1_2', text: 'النية، والقول، والعمل، والاعتقاد'),
        QuizOption(optionId: 'opt_qqr1_3', text: 'المعرفة، والتخمين، والمحاولة، والجزاء'),
      ],
      correctOptionIndices: const [0],
      explanation: 'مراتب القدر الأربعة المجمع عليها عند سلف الأمة هي: علم الله الأزلي، وكتابته في اللوح المحفوظ، ومشيئته النافذة، وخلقه لكل كائن.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_aqidah_qadar_ranks',
      lessonId: 'lsn_aqidah_qadar_writing_will',
      title: 'اختبار مراتب القدر الأربعة وقواعد الإيمان بها',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Human Will
    final q2 = QuizQuestion.create(
      questionId: 'q_qd_will_1',
      lessonId: 'lsn_aqidah_human_will_choice',
      questionText: 'ما هو معتقد أهل السنة والجماعة في أفعال العباد ومشيئتهم؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qqw1_1', text: 'للعبد قدرة ومشيئة حقيقية واختيار يحاسب عليه، وهي تابعة لمشيئة الله الكونية'),
        QuizOption(optionId: 'opt_qqw1_2', text: 'العبد مجبر على أفعاله تماماً كالجماد ولا إرادة له قط (مذهب الجبرية)'),
        QuizOption(optionId: 'opt_qqw1_3', text: 'العبد يخلق أفعاله باستقلال تام عن علم الله ومشيئته (مذهب القدرية)'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أهل السنة وسط بين الجبرية والقدرية؛ فللإنسان إرادة واختيار حقيقي يكلف بموجبه، ومشيئته لا تخرج عن مشيئة الله العامة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_aqidah_qadar_will_creation',
      lessonId: 'lsn_aqidah_human_will_choice',
      title: 'اختبار مشيئة العبد ومسؤوليته والرد على الفرق',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Causes & Reliance
    final q3 = QuizQuestion.create(
      questionId: 'q_qd_causes_1',
      lessonId: 'lsn_aqidah_causes_reliance_contentment',
      questionText: 'ما هو الموقف الشرعي الصحيح للمسلم عند نزول المصائب بعد استنفاد الأسباب؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qqc1_1', text: 'الصبر والرضا وقول «قَدَرُ اللهِ وما شاء فعل» دون فتح باب الحسرة بقول «لو»'),
        QuizOption(optionId: 'opt_qqc1_2', text: 'الندم واللوم والاعتراض على القدر وسؤال «لماذا حدث لي هذا»'),
        QuizOption(optionId: 'opt_qqc1_3', text: 'ترك كل علاج وأخذ بالأسباب في المستقبل'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقول النبي ﷺ: «وإن أصابك شيء فلا تقل: لو أني فعلت كان كذا، ولكن قل: قَدَرُ اللهِ وما شاء فعل، فإن «لو» تفتح عمل الشيطان».',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_aqidah_causes_satisfaction',
      lessonId: 'lsn_aqidah_causes_reliance_contentment',
      title: 'اختبار الأخذ بالأسباب والرضا بالقضاء والتوكل',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
