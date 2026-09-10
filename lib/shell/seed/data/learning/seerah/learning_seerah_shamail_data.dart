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

/// بيانات مقرر الشمائل المحمدية ومعالم وأعلام السيرة النبوية (4 دروس تأصيلية + اختباران استيعاب)
/// يربط تأصيلياً بالأعلام الـ 16 والأماكن المقدسة الـ 15 الموثقة في موديول السيرة بسِراج
class LearningSeerahShamailData {
  static const String courseId = 'course_seerah_shamail_study';
  static const String pathId = 'path_seerah_history_curriculum';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الشمائل المحمدية ومعالم وأعلام السيرة النبوية',
      description: 'دراسة تأصيلية محققة في صفات النبي ﷺ الخَلقية الشريفة، ومكارم أخلاقه الخُلقية العلية، وهديه في عبادته ومعاملاته، مع التعريف بأعلام الصحابة وآل البيت الـ 16، والمواقع والمعالم التاريخية المقدسة الـ 15 في موديول السيرة.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_seerah_shamail_character', 'mod_seerah_sacred_places_persons'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_seerah_shamail_character',
        courseId: courseId,
        title: 'الوحدة الأولى: الشمائل الخَلقية والخُلقية والهدي النبوي الشريف',
        description: 'بيان صفة النبي ﷺ الخَلقية من لحيته ووجهه وخاتم النبوة وطيبه، ومكارم أخلاقه من الحلم والجود والشجاعة والتواضع والرحمة الشاملة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_seerah_physical_traits',
          'lsn_seerah_moral_character',
        ],
      ),
      CourseModule(
        moduleId: 'mod_seerah_sacred_places_persons',
        courseId: courseId,
        title: 'الوحدة الثانية: أعلام الصحابة وأهل البيت والمواقع التاريخية المقدسة',
        description: 'التعريف بأعلام الرعيل الأول والخلفاء الراشدين وأمهات المؤمنين (16 شخصية)، واستكشاف المواقع والمعالم التاريخية النبوية (15 موقعاً مقدساً) في موديول السيرة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_seerah_shamail_character'],
        lessonIds: const [
          'lsn_seerah_companions_household',
          'lsn_seerah_geography_places',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 13: الشمائل الخَلقية الشريفة
    // -------------------------------------------------------------------------
    final evShamail1 = EvidenceLink.create(
      evidenceId: 'ev_srh_shm_face',
      evidenceKey: 'bukhari:3549',
      citation: 'صحيح البخاري: حديث البراء بن عازب في صفة النبي ﷺ',
      sourceId: 'src_hadith_canonical',
    );
    final evShamail2 = EvidenceLink.create(
      evidenceId: 'ev_srh_shm_tirmidhi',
      evidenceKey: 'tirmidhi:shamail_1',
      citation: 'الشمائل المحمدية للترمذي: حديث علي بن أبي طالب في نعت النبي ﷺ',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_seerah_physical_traits',
      title: 'الشمائل الخَلقية الشريفة: صورة النبي ﷺ وخاتم النبوة وهيئته وطيبه',
      courseId: courseId,
      moduleId: 'mod_seerah_shamail_character',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_ssh1_1',
          title: 'جمال الخَلقة النبوية',
          description: 'معرفة صفة وجه النبي ﷺ وقامته وشعره كما وصفه أصحابه الكرام.',
        ),
        LearningObjective(
          objectiveId: 'obj_ssh1_2',
          title: 'خاتم النبوة وطيب الرائحة',
          description: 'استيعاب صفة خاتم النبوة بين كتفيه وطيب رائحته وعرقه الشريف.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_ssh1_1',
          title: 'صفة النبي ﷺ الخَلقية البهية',
          contentType: LearningContentType.sourceText,
          content: 'عن البراء بن عازب رضي الله عنه قال: «كَانَ رَسُولُ اللَّهِ ﷺ أَحْسَنَ النَّاسِ وَجْهًا، وَأَحْسَنَهُ خَلْقًا، لَيْسَ بِالطَّوِيلِ البَائِنِ، وَلاَ بِالقَصِيرِ» (رواه البخاري). وقال علي رضي الله عنه: «لم يكن بالطويل الممغط، ولا القصير المتردد، كان ربعة من القوم، أزهر اللون، أدعج العينين، أهدب الأشفار، إذا مشى تكفأ تكفؤاً كأنما ينحط من صبب، من رآه بديهة هابه، ومن خالطه معرفة أحبه، يقول ناعته: لم أرَ قبله ولا بعده مثله ﷺ».',
          evidenceLinks: [evShamail1, evShamail2],
          sourceAttribution: 'صحيح البخاري والشمائل المحمدية للترمذي',
        ),
        LessonSection.create(
          sectionId: 'sec_ssh1_2',
          title: 'خاتم النبوة وطيب النبي ﷺ وهديه في اللباس',
          contentType: LearningContentType.explanation,
          content: 'كان بين كتفي النبي ﷺ خاتم النبوة كبيضة الحمامة فيه شامات عليه شعر، وهو من علامات نبوته المذكورة في الكتب السابقة. وكان ﷺ أطيب الناس ريحاً؛ قال أنس: «ما شممت عنبراً قط ولا مسكاً أطيب من ريح رسول الله ﷺ»، وكان يلبس البردة والحلة ويفضل البياض من الثياب تواضعاً ونظافة.',
          sourceAttribution: 'صحيح مسلم والشمائل للترمذي',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 14: الشمائل الخُلقية العظيمة
    // -------------------------------------------------------------------------
    final evAkhlaqAyah = EvidenceLink.create(
      evidenceId: 'ev_srh_akhlaq_ayah',
      evidenceKey: '68:4',
      citation: 'سورة القلم: الآية 4',
      sourceId: 'src_quran_canonical',
    );
    final evKhuluqAishah = EvidenceLink.create(
      evidenceId: 'ev_srh_khuluq_aishah',
      evidenceKey: 'muslim:746',
      citation: 'صحيح مسلم: حديث عائشة: «كان خلقه القرآن»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_seerah_moral_character',
      title: 'الشمائل الخُلقية العظيمة: حلمه وكرمه وشجاعته وزهده وتواضعه ورحمته',
      courseId: courseId,
      moduleId: 'mod_seerah_shamail_character',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_ssh2_1',
          title: 'عظمة الخلق القرآني النبوي',
          description: 'استيعاب معنى قول عائشة رضي الله عنها: «كان خلقه القرآن».',
        ),
        LearningObjective(
          objectiveId: 'obj_ssh2_2',
          title: 'الرحمة المهداة والحلم والشجاعة',
          description: 'معرفة نماذج من حلمه على المسيء وشجاعته في المعارك وجوده الذي لا يخشى الفقر.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_ssh2_1',
          title: 'الخلق المحمدي العظيم: قرآن يمشي على الأرض',
          contentType: LearningContentType.sourceText,
          content: 'قال الله تعالى: {وَإِنَّكَ لَعَلَىٰ خُلُقٍ عَظِيمٍ}. وسئلت عائشة رضي الله عنها عن خلق رسول الله ﷺ فقالت: «فَإِنَّ خُلُقَ نَبِيِّ اللَّهِ ﷺ كَانَ الْقُرْآنَ»؛ يرضى لرضاه ويسخط لسخطه، ويأتمر بأوامره وينتهي عن نواهيه.',
          evidenceLinks: [evAkhlaqAyah, evKhuluqAishah],
          sourceAttribution: 'سورة القلم وصحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_ssh2_2',
          title: 'فيض الجود والحلم والشجاعة والتواضع النبوي',
          contentType: LearningContentType.scholarlyView,
          content: 'كان النبي ﷺ أجود الناس بالخير من الريح المرسلة، وما سُئل شيئاً قط فقال: لا. وكان أحلم الناس لا يغضب لنفسه وإنما يغضب إذا انتهكت حرمات الله. وكان أشجع الناس؛ قال علي رضي الله عنه: «كنا إذا احمر البأس ولقي القوم القوم اتقينا برسول الله ﷺ، فما يكون أحد أقرب إلى العدو منه». وكان أرحم الناس بالصبيان والنساء والضعفاء والدواب.',
          sourceAttribution: 'زاد المعاد لابن القيم والشفاء للقاضي عياض',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical', 'src_seerah_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 15: أعلام الصحابة وأهل البيت الأطهار
    // -------------------------------------------------------------------------
    final evPersonsDoc = EvidenceLink.create(
      evidenceId: 'ev_srh_persons_doc',
      evidenceKey: 'person_prophet_muhammad',
      citation: 'موسوعة السيرة بسِراج: أعلام وشخصيات السيرة النبوية الـ 16',
      sourceId: 'src_seerah_canonical',
      context: 'توثيق تراجم الخلفاء الأربعة وأمهات المؤمنين وآل البيت وكبار الصحابة',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_seerah_companions_household',
      title: 'أعلام السيرة النبوية: الخلفاء الراشدون وأمهات المؤمنين وكبار الصحابة',
      courseId: courseId,
      moduleId: 'mod_seerah_sacred_places_persons',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_ssh3_1',
          title: 'الخلفاء الأربعة وفضلهم',
          description: 'معرفة مناقب أبي بكر وعمر وعثمان وعلي رضي الله عنهم ودورهم التأسيسي.',
        ),
        LearningObjective(
          objectiveId: 'obj_ssh3_2',
          title: 'أمهات المؤمنين وآل البيت',
          description: 'إدراك مكانة خديجة وعائشة وفاطمة رضي الله عنهن وآل البيت الأطهار.',
        ),
        LearningObjective(
          objectiveId: 'obj_ssh3_3',
          title: 'أعلام الفدائية والبذل',
          description: 'معرفة تراجم حمزة وبلال ومصعب وخالد بن الوليد وسلمان الفارسي الموثقة بسِراج.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_ssh3_1',
          title: 'أعلام النبوة والرعيل الأول في موسوعة سِراج',
          contentType: LearningContentType.explanation,
          content: 'وثقت موسوعة سِراج للسيرة النبوية 16 علماً تاريخياً مركزياً:\n1. الخلفاء الراشدون: الصديق رفيق الغار، والفاروق مظهر العزة، وذو النورين جامع المصحف، وأبو السبطين بطل خيبر.\n2. أمهات المؤمنين وآل البيت: خديجة ناصرة الوحي الأولى، وعائشة وعاء الفقه، وفاطمة سيدة نساء أهل الجنة.\n3. أبطال الصحابة: أسد الله حمزة، مؤذن الرسول بلال، سفير القرآن مصعب، سيف الله خالد، باحث الحقيقة سلمان، وأمين الأمة أبو عبيدة عامر بن الجراح.',
          evidenceLinks: [evPersonsDoc],
          sourceAttribution: 'سير أعلام النبلاء للذهبي والاستيعاب لابن عبد البر وموسوعة سِراج',
        ),
      ],
      sources: const ['src_seerah_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 16: المواقع الجغرافية والمعالم المقدسة
    // -------------------------------------------------------------------------
    final evPlacesDoc = EvidenceLink.create(
      evidenceId: 'ev_srh_places_doc',
      evidenceKey: 'place_makkah',
      citation: 'موسوعة السيرة بسِراج: المواقع والمعالم التاريخية الـ 15 المقدسة',
      sourceId: 'src_seerah_canonical',
      context: 'توثيق مكة والمدينة وحراء وثور وقباء وبدر وأحد والخندق وحنين وتبوك',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_seerah_geography_places',
      title: 'معالم ومواقع السيرة النبوية الشريفة: أطلس الأماكن والمغازي المقدسة',
      courseId: courseId,
      moduleId: 'mod_seerah_sacred_places_persons',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_ssh4_1',
          title: 'المواقع المقدسة بمكة المكرمة والمدينة',
          description: 'معرفة حرم مكة والمدينة والمسجد الحرام وغاري حراء وثور ومسجد قباء والمسجد النبوي.',
        ),
        LearningObjective(
          objectiveId: 'obj_ssh4_2',
          title: 'ميادين المغازي والفتوحات التاريخية',
          description: 'استيعاب جغرافيا بدر وأحد والخندق والحديبية وخيبر ومؤتة وحنين وتبوك الموثقة بسِراج.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_ssh4_1',
          title: 'أطلس الأماكن والمعالم النبوية في موسوعة سِراج',
          contentType: LearningContentType.explanation,
          content: 'تشتمل موسوعة سِراج على 15 موقعاً تاريخياً مقدساً ترتبط بها أحداث السيرة:\n1. المشاعر والمهابط: مكة المكرمة، غار حراء (مهبط الوحي)، غار ثور (معجزة الهجرة)، والمدينة المنورة (دار الهجرة).\n2. المساجد التأسيسية: مسجد قباء، والمسجد النبوي الشريف، والمسجد الأقصى.\n3. ساحات الفرقان والتمكين: بدر الكبرى، جبل أحد، الخندق بالأحزاب، الحديبية، خيبر، وادي حنين، وتبوك.\nويمكن للدارس استعراض خريطة وتفاصيل كل موقع وإحداثياته مباشرة عبر المخطط الزمني التفاعلي بسِراج.',
          evidenceLinks: [evPlacesDoc],
          sourceAttribution: 'معجم البلدان لياقوت الحموي وأطلس السيرة النبوية وموسوعة سِراج',
        ),
      ],
      sources: const ['src_seerah_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: الشمائل النبوية
    final q1 = QuizQuestion.create(
      questionId: 'q_srh_shm_1',
      lessonId: 'lsn_seerah_moral_character',
      questionText: 'بماذا وصفت أم المؤمنين عائشة رضي الله عنها خُلق رسول الله ﷺ حين سئلت عنه؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qshm1_1', text: '«كَانَ خُلُقُهُ الْقُرْآنَ» يرضى لرضاه ويسخط لسخطه'),
        QuizOption(optionId: 'opt_qshm1_2', text: 'كان شديد الغضب لنفسه'),
        QuizOption(optionId: 'opt_qshm1_3', text: 'كان يرفض مجالسة المساكين'),
      ],
      correctOptionIndices: const [0],
      explanation: 'بينت عائشة رضي الله عنها أن النبي ﷺ كان قرآناً يمشي بين الناس؛ يأتمر بأمره وينتهي بنهيه ويتحلى بكل مكارم الأخلاق.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_seerah_shamail_character',
      lessonId: 'lsn_seerah_moral_character',
      title: 'اختبار الشمائل النبوية الشريفة ومكارم الأخلاق',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: أعلام وأماكن السيرة
    final q2 = QuizQuestion.create(
      questionId: 'q_srh_shm_2',
      lessonId: 'lsn_seerah_companions_household',
      questionText: 'من هو الصحابي الجليل الذي أرسله النبي ﷺ بعد بيعة العقبة الأولى إلى يثرب وكان أول سفير ومقرئ في الإسلام؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qshm2_1', text: 'مصعب بن عمير رضي الله عنه'),
        QuizOption(optionId: 'opt_qshm2_2', text: 'خالد بن الوليد رضي الله عنه'),
        QuizOption(optionId: 'opt_qshm2_3', text: 'عمرو بن العاص رضي الله عنه'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أرسل النبي ﷺ مصعب بن عمير رضي الله عنه معلماً ومقرئاً لأهل يثرب، فأسلم على يديه كبار الأوس والخزرج وسعد بن معاذ.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_seerah_sacred_places_persons',
      lessonId: 'lsn_seerah_companions_household',
      title: 'اختبار أعلام الصحابة والمواقع التاريخية في السيرة',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
