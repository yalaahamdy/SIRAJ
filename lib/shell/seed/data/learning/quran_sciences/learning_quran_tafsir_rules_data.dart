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

/// بيانات مقرر أصول التفسير وقواعد الترجيح وأسباب النزول (6 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningQuranTafsirRulesData {
  static const String courseId = 'course_quran_tafsir_rules';
  static const String pathId = 'path_quran_sciences_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر أصول التفسير وقواعد الترجيح وأسباب النزول',
      description: 'دراسة تأصيلية منهجية في أصول وقواعد علم التفسير: مصادره المعتمدة، مراتب التفسير، قواعد الترجيح عند السلف، أسباب النزول، الناسخ والمنسوخ، والتحذير من الإسرائيليات.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_tafsir_sources_rules', 'mod_tafsir_asbab_naskh'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_tafsir_sources_rules',
        courseId: courseId,
        title: 'الوحدة الأولى: مصادر التفسير وأصوله وقواعد الترجيح',
        description: 'بيان حقيقة التفسير وشرفه، ومراتبه الأربعة الأصيلة (القرآن، السنة، الصحابة، لسان العرب)، وقواعد ترجيح الأقوال عند الاختلاف.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_tafsir_concept_importance',
          'lsn_tafsir_sources_hierarchy',
          'lsn_tafsir_tarjeeh_rules',
        ],
      ),
      CourseModule(
        moduleId: 'mod_tafsir_asbab_naskh',
        courseId: courseId,
        title: 'الوحدة الثانية: أسباب النزول والناسخ والمنسوخ والمحكم والمتشابه',
        description: 'أهمية سبب النزول وقواعده، وحقيقة النسخ وأنواعه الثلاثة، والمحكم والمتشابه، والمنهج العلمي في نقد وتجنب الإسرائيليات.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_tafsir_sources_rules'],
        lessonIds: const [
          'lsn_tafsir_asbab_nuzul',
          'lsn_tafsir_naskh_mansukh',
          'lsn_tafsir_muhkam_mutashabih',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: مفهوم التفسير وشرفه
    // -------------------------------------------------------------------------
    final evTafsirAyah = EvidenceLink.create(
      evidenceId: 'ev_tfs_tadabbur_ayah',
      evidenceKey: '4:82',
      citation: 'سورة النساء: الآية 82',
      sourceId: 'src_quran_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_tafsir_concept_importance',
      title: 'مفهوم التفسير والتأويل وشرف هذا العلم وغايته وحاجة الأمة إليه',
      courseId: courseId,
      moduleId: 'mod_tafsir_sources_rules',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tr1_1',
          title: 'إدراك شرف علم التفسير وحاجة المسلم لفهم كلام ربه',
          description: 'الفرق بين التفسير والتأويل لغة واصطلاحاً، والدعوة القرآنية لتدبر معاني الوحي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tr1_1',
          title: 'الأمر القرآني بتدبر آيات الذكر الحكيم',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {أَفَلَا يَتَدَبَّرُونَ الْقُرْآنَ ۚ وَلَوْ كَانَ مِنْ عِندِ غَيْرِ اللَّهِ لَوَجَدُوا فِيهِ اخْتِلَافًا كَثِيرًا}. وقال: {كِتَابٌ أَنزَلْنَاهُ إِلَيْكَ مُبَارَكٌ لِّيَدَّبَّرُوا آيَاتِهِ وَلِيَتَذَكَّرَ أُولُو الْأَلْبَابِ}.',
          evidenceLinks: [evTafsirAyah],
          sourceAttribution: 'سورة النساء: الآية 82، وسورة ص: الآية 29',
        ),
        LessonSection.create(
          sectionId: 'sec_tr1_2',
          title: 'التعريف العلمي للتفسير وشرف موضوعه',
          contentType: LearningContentType.explanation,
          content: 'التفسير لغة: الكشف والبيان والإيضاح. وفي الاصطلاح: علم يبحث فيه عن أحوال القرآن المجيد من حيث دلالته على مراد الله تعالى بقدر الطاقة البشرية. وشرف العلم تابع لشرف معلومه، وموضوع التفسير هو كلام الله تعالى؛ ولذا كان من أشرف العلوم الشرعية وأجلها قدراً، ولا غنى لمسلم عن فهم ما يخاطبه به خالقه في صلاته وحياته.',
          sourceAttribution: 'مقدمة في أصول التفسير لابن تيمية ص 15',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_muqaddimah_tafsir_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: مراتب التفسير الأربعة
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_tafsir_sources_hierarchy',
      title: 'المراتب الأربعة لتفسير القرآن الكريم وضوابط الاستنباط',
      courseId: courseId,
      moduleId: 'mod_tafsir_sources_rules',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tr2_1',
          title: 'حفظ مراتب التفسير الأصيلة بالترتيب المنهجي',
          description: 'تفسير القرآن بالقرآن، ثم بالسنة، ثم بأقوال الصحابة، ثم بالتابعين ولسان العرب.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tr2_1',
          title: 'المنهج النبوي في بيان القرآن',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {وَأَنزَلْنَا إِلَيْكَ الذِّكْرَ لِتُبَيِّنَ لِلنَّاسِ مَا نُزِّلَ إِلَيْهِمْ وَلَعَلَّهُمْ يَتَفَكَّرُونَ}.',
          sourceAttribution: 'سورة النحل: الآية 44',
        ),
        LessonSection.create(
          sectionId: 'sec_tr2_2',
          title: 'تفصيل المراتب الأربعة لتفسير كتاب الله',
          contentType: LearningContentType.explanation,
          content: 'قرر شيخ الإسلام ابن تيمية أن أصح طرق التفسير مرتبة كالتالي:\n1. تفسير القرآن بالقرآن: فما أُجمل في موضع قد فُصل في موضع آخر، وما أُطلق في مكان قُيد في غيره، كقوله تعالى: {أُحِلَّتْ لَكُم بَهِيمَةُ الْأَنْعَامِ إِلَّا مَا يُتْلَىٰ عَلَيْكُمْ} ففسره بقوله: {حُرِّمَتْ عَلَيْكُمُ الْمَيْتَةُ وَالدَّمُ...}.\n2. تفسير القرآن بالسنة النبوية: فإن السنة شارحة للقرآن وموضحة لمجمله كبيان صفة الصلاة والحج وتفاصيل الأنصبة.\n3. تفسير القرآن بأقوال الصحابة: لأنهم عاصروا التنزيل وشهدوا الوقائع وعرفوا لغة التنزيل، وعلى رأسهم الخلفاء الأربعة وابن عباس ترجمان القرآن.\n4. تفسير القرآن بأقوال التابعين ولسان العرب: إذا أجمع التابعون كتلاميذ ابن عباس (مجاهد وعكرمة وسعيد بن جبير) كان حجة، مع الاستعانة بدلالات لغة العرب.',
          sourceAttribution: 'مقدمة في أصول التفسير لابن تيمية ص 35',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_muqaddimah_tafsir_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: قواعد الترجيح عند الاختلاف
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_tafsir_tarjeeh_rules',
      title: 'قواعد الترجيح المعتمدة عند اختلاف عبارات السلف في التفسير',
      courseId: courseId,
      moduleId: 'mod_tafsir_sources_rules',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tr3_1',
          title: 'فهم طبيعة خلاف السلف في التفسير (تنوع لا تضاد) وقواعد الترجيح',
          description: 'التعبير عن المعنى بألفاظ متقاربة، وتفسير اللفظ ببعض أفراده على سبيل التمثيل، وقواعد الترجيح عند التعارض الحقيقي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tr3_1',
          title: 'تحرير طبيعة اختلاف عبارات السلف',
          contentType: LearningContentType.explanation,
          content: 'أكثر الاختلاف المنقول عن السلف الصالح في التفسير هو «اختلاف تنوع» لا «اختلاف تضاد»، وله صورتان:\n1. أن يعبر كل واحد منهم عن المراد بعبارة غير عبارة صاحبه تدل على معنى في المسمى غير المعنى الآخر، مع اتحاد المسمى كأسمائه تعالى وأسماء نبيه وكتابه، مثل تفسير {الصِّرَاطَ الْمُسْتَقِيمَ} بالقرآن أو بالإسلام أو بالسنة، فكلها حق.\n2. أن يذكر أحدهم بعض أفراد الاسم العام على سبيل التمثيل للمخاطب لا الحصر، كمن يفسر {ثُمَّ أَوْرَثْنَا الْكِتَابَ الَّذِينَ اصْطَفَيْنَا مِنْ عِبَادِنَا ۖ فَمِنْهُمْ ظَالِمٌ لِّنَفْسِهِ} بالذي يؤخر الصلاة عن وقتها.',
          sourceAttribution: 'مقدمة أصول التفسير لابن تيمية ص 40',
        ),
        LessonSection.create(
          sectionId: 'sec_tr3_2',
          title: 'أبرز قواعد الترجيح عند الاختلاف الحقيقي',
          contentType: LearningContentType.scholarlyView,
          content: 'إذا تعذّر الجمع ووُجد اختلاف تضاد يُرجّح بالقواعد المعتمدة: 1. تقديم المعنى الأغلب في لغة العرب والقرآن على المعنى النادر، 2. حمل الكلام على الحقيقة أولى من حمله على المجاز ما لم تدل قرينة، 3. حمل الآية على المعنى الذي يشهد له سياق الآيات ويوافقه، 4. إعمال الكلام أولى من إهماله، 5. تقديم القول الذي تؤيده قراءة أخرى متواترة.',
          sourceAttribution: 'قواعد الترجيح عند المفسرين لحسين الحربي ص 110',
        ),
      ],
      sources: const ['src_muqaddimah_tafsir_canonical', 'src_tarjeeh_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: أسباب النزول
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_tafsir_asbab_nuzul',
      title: 'أسباب النزول: صيغها وأهميتها وقاعدة «العبرة بعموم اللفظ لا بخصوص السبب»',
      courseId: courseId,
      moduleId: 'mod_tafsir_asbab_naskh',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tr4_1',
          title: 'معرفة علم أسباب النزول وتطبيق القاعدة الأصولية الكبرى',
          description: 'بيان الفرق بين النص الصريح وغير الصريح في سبب النزول، وقاعدة عموم اللفظ وشمول الحكم لكل الأمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tr4_1',
          title: 'أهمية علم أسباب النزول',
          contentType: LearningContentType.explanation,
          content: 'سبب النزول هو ما نزلت الآية أو الآيات متحدثة عنه أو مبينة لحكمه أيام وقوعه بحادثة أو سؤال. وفوائده عظيمة: معرفة وجه الحكمة في تشريع الأحكام، وتخصيص الحكم عند من يرى ذلك، ودفع الإشكال وفهم المعنى على وجهه، كما قال الواحدي: «لا يمكن تفسير الآية دون الوقوف على قصتها وبيان سبب نزولها».',
          sourceAttribution: 'أسباب النزول للواحدي ص 12',
        ),
        LessonSection.create(
          sectionId: 'sec_tr4_2',
          title: 'القاعدة الكبرى: العبرة بعموم اللفظ لا بخصوص السبب',
          contentType: LearningContentType.example,
          content: 'أجمع الأصوليون والمفسرون على قاعدة: «العبرة بعموم اللفظ لا بخصوص السبب»؛ فالآية إذا نزلت في واقعة خاصة لشخص معين، ولكن لفظها جاء عاماً شاملاً، فإن الحكم يسري على ذلك الشخص وعلى كل من ماثله إلى يوم القيامة، كآيات اللعان التي نزلت في هلال بن أمية وزوجته، وآيات الظهار التي نزلت في أوس بن الصامت، فالحكم عام للأمة كافة.',
          sourceAttribution: 'شرح الكوكب المنير في أصول الفقه لابن النجار ج 3 ص 135',
        ),
      ],
      sources: const ['src_wahidi_canonical', 'src_itqan_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الناسخ والمنسوخ
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_tafsir_naskh_mansukh',
      title: 'الناسخ والمنسوخ في القرآن: تعريفه، شروطه، حِكَمُه، وأنواعه الثلاثة',
      courseId: courseId,
      moduleId: 'mod_tafsir_asbab_naskh',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tr5_1',
          title: 'فهم حقيقة النسخ في الشريعة الإسلامية وأقسامه الثلاثة',
          description: 'رفع حكم شرعي بدليل شرعي متأخر عنه، وأنواعه: نسخ الحكم والتلاوة، نسخ الحكم وبقاء التلاوة، نسخ التلاوة وبقاء الحكم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tr5_1',
          title: 'النص الإلهي في مشروعية النسخ وحكمته',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {مَا نَنسَخْ مِنْ آيَةٍ أَوْ نُنسِهَا نَأْتِ بِخَيْرٍ مِّنْهَا أَوْ مِثْلِهَا ۗ أَلَمْ تَعْلَمْ أَنَّ اللَّهَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ}. وقال: {وَإِذَا بَدَّلْنَا آيَةً مَّكَانَ آيَةٍ ۙ وَاللَّهُ أَعْلَمُ بِمَا يُنَزِّلُ قَالُوا إِنَّمَا أَنتَ مُفْتَرٍ ۚ بَلْ أَكْثَرُهُمْ لَا يَعْلَمُونَ}.',
          sourceAttribution: 'سورة البقرة: الآية 106، وسورة النحل: الآية 101',
        ),
        LessonSection.create(
          sectionId: 'sec_tr5_2',
          title: 'أقسام النسخ الثلاثة في القرآن الكريم',
          contentType: LearningContentType.explanation,
          content: 'النسخ في الاصطلاح: رفع الحكم الشرعي بدليل شرعي متأخر، وهو واقع في الأوامر والنواهي لا في الأخبار والعقائد. وله ثلاثة أنواع:\n1. نسخ الحكم وبقاء التلاوة: وهو الأكثر في القرآن، كنسخ حكم الاعتداد بحول كامل في قوله: {وَصِيَّةً لِّأَزْوَاجِهِم مَّتَاعًا إِلَى الْحَوْلِ} بحكم أربعة أشهر وعشراً، وبقيت الآية متلوة تعبداً وثواباً.\n2. نسخ التلاوة وبقاء الحكم: كآية الرجم التي كانت متلوة ثم نُسخ لفظها وبقي حكمها واجباً.\n3. نسخ الحكم والتلاوة معاً: كحديث عشر رضعات معلومات يُحرمن، نُسخن بخمس رضعات ثم نُسخ لفظهن.',
          sourceAttribution: 'الناسخ والمنسوخ لأبي عبيد القاسم بن سلام ص 18',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_abu_ubaid_naskh_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 6: المحكم والمتشابه والإسرائيليات
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_tafsir_muhkam_mutashabih',
      title: 'المحكم والمتشابه وموقف الراسخين في العلم والتحذير من الإسرائيليات',
      courseId: courseId,
      moduleId: 'mod_tafsir_asbab_naskh',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tr6_1',
          title: 'التمييز بين المحكم والمتشابه وتصفية التفسير من الإسرائيليات',
          description: 'رد المتشابه إلى المحكم كمنهج الراسخين في العلم، وموقف المسلم من الروايات الإسرائيلية الثلاثة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tr6_1',
          title: 'آية سورة آل عمران في المحكم والمتشابه',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {هُوَ الَّذِي أَنزَلَ عَلَيْكَ الْكِتَابَ مِنْهُ آيَاتٌ مُّحْكَمَاتٌ هُنَّ أُمُّ الْكِتَابِ وَأُخَرُ مُتَشَابِهَاتٌ ۖ فَأَمَّا الَّذِينَ فِي قُلُوبِهِمْ زَيْغٌ فَيَتَّبِعُونَ مَا تَشَابَهَ مِنْهُ ابْتِغَاءَ الْفِتْنَةِ وَابْتِغَاءَ تَأْوِيلِهِ ۗ وَمَا يَعْلَمُ تَأْوِيلَهُ إِلَّا اللَّهُ ۗ وَالرَّاسِخُونَ فِي الْعِلْمِ يَقُولُونَ آمَنَّا بِهِ كُلٌّ مِّنْ عِندِ رَبِّنَا}.',
          sourceAttribution: 'سورة آل عمران: الآية 7',
        ),
        LessonSection.create(
          sectionId: 'sec_tr6_2',
          title: 'منهج الراسخين وموقف الشريعة من الإسرائيليات',
          contentType: LearningContentType.explanation,
          content: 'المحكم: ما اتضح معناه ودلالته ولا يحتمل إلا وجهاً واحداً. والمتشابه: ما احتمل عدة أوجه أو استأثر الله بعلم حقيقته ككنه الصفات ووقت الساعة، ومنهج الراسخين رد المتشابه إلى المحكم ليصير كله محكماً.\nأما الإسرائيليات في التفسير فهي أقسام ثلاثة:\n1. ما وافق شرعنا: فهو حق ومقبول لشهادة القرآن له.\n2. ما خالف شرعنا: كنسبة النقائص للأنبياء، فهو باطل مردود محرّم اعتقاده.\n3. ما سكت عنه شرعنا: لا نصدقه ولا نكذبه، ولا فائدة دينية من ورائه كتحديد لون كلب أهل الكهف أو نوع شجرة الجنة، والأولى تركه.',
          sourceAttribution: 'تفسير القرآن العظيم لابن كثير مقدمة الكتاب',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_ibn_kathir_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Tafsir Sources
    final q1 = QuizQuestion.create(
      questionId: 'q_tr_sources_1',
      lessonId: 'lsn_tafsir_sources_hierarchy',
      questionText: 'ما هي أعلى وأصح مرتبة في مراتب تفسير كتاب الله عز وجل على الإطلاق؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qts1_1', text: 'تفسير القرآن بالقرآن (بيان القرآن بآيات أخرى من القرآن)'),
        QuizOption(optionId: 'opt_qts1_2', text: 'تفسير القرآن بالرأي المجرد والعقل المستقل'),
        QuizOption(optionId: 'opt_qts1_3', text: 'تفسير القرآن بالكتب السابقة والمنسوخة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أصح طرق التفسير وأعلاها هو تفسير القرآن بالقرآن؛ فصاحب الكلام أدرى بما أراد بكلامه.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_tafsir_sources_hierarchy',
      lessonId: 'lsn_tafsir_sources_hierarchy',
      title: 'اختبار مراتب التفسير وأصوله المعتمدة',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Asbab al-Nuzul Rule
    final q2 = QuizQuestion.create(
      questionId: 'q_tr_asbab_1',
      lessonId: 'lsn_tafsir_asbab_nuzul',
      questionText: 'ما هي القاعدة الأصولية والتفسيرية الكبرى المعتمدة عند نزول آية في شأن واقعة معينة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qta1_1', text: 'العبرة بعموم اللفظ لا بخصوص السبب'),
        QuizOption(optionId: 'opt_qta1_2', text: 'العبرة بخصوص السبب فقط ولا يتعداه الحكم قط'),
        QuizOption(optionId: 'opt_qta1_3', text: 'الحكم ينسخ فور موت صاحب الواقعة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قاعدة «العبرة بعموم اللفظ لا بخصوص السبب» تعني أن الحكم القرآني عام وشامل للأمة إلى يوم القيامة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_tafsir_asbab_nuzul',
      lessonId: 'lsn_tafsir_asbab_nuzul',
      title: 'اختبار أسباب النزول وقواعد الاستنباط',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Naskh & Israiliyyat
    final q3 = QuizQuestion.create(
      questionId: 'q_tr_israiliyyat_1',
      lessonId: 'lsn_tafsir_muhkam_mutashabih',
      questionText: 'ما هو الموقف الشرعي للمسلم من الأخبار الإسرائيلية التي سكت عنها شرعنا ولم يأتِ ما يصدقها أو يكذبها؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qti1_1', text: 'لا نصدقها ولا نكذبها ويجوز التحدث بها للعبرة دون القطع بصحتها'),
        QuizOption(optionId: 'opt_qti1_2', text: 'يجب التصديق الجازم بها واعتبارها قرآناً'),
        QuizOption(optionId: 'opt_qti1_3', text: 'تكفير من يرويها مطلقاً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقول النبي ﷺ: «حدثوا عن بني إسرائيل ولا حرج، فإذا حدثوكم فلا تصدقوهم ولا تكذبوهم، وقولوا: آمنا بالله وما أُنزل إلينا».',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_tafsir_naskh_israiliyyat',
      lessonId: 'lsn_tafsir_muhkam_mutashabih',
      title: 'اختبار الناسخ والمنسوخ وضوابط الإسرائيليات',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
