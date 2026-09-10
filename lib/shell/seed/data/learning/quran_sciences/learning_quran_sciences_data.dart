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

/// بيانات مقرر مدخل إلى علوم القرآن وتاريخ نزوله وجمعه (6 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningQuranSciencesData {
  static const String courseId = 'course_quran_sciences_intro';
  static const String pathId = 'path_quran_sciences_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر مباحث علوم القرآن وتاريخ النزول والجمع والإعجاز',
      description: 'دراسة تأصيلية شاملة في نشأة وتاريخ علوم القرآن: نزول الوحي، المكي والمدني، تاريخ جمع القرآن وتدوينه، وجوه الإعجاز القرآني، والأحرف السبعة والقراءات المتواترة.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_quran_revelation_compilation', 'mod_quran_miracle_qiraat'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_quran_revelation_compilation',
        courseId: courseId,
        title: 'الوحدة الأولى: نزول الوحي وتاريخ جمع القرآن والمكي والمدني',
        description: 'بيان كيفية نزول الوحي ومنجمية القرآن وحكمتها، وضوابط المكي والمدني، وتاريخ تدوين وجمع القرآن الكريم حتى المصحف الإمام.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_quran_revelation_stages',
          'lsn_quran_makki_madani',
          'lsn_quran_compilation_history',
        ],
      ),
      CourseModule(
        moduleId: 'mod_quran_miracle_qiraat',
        courseId: courseId,
        title: 'الوحدة الثانية: وجوه الإعجاز القرآني والقراءات المتواترة',
        description: 'دراسة دلائل إعجاز القرآن البيانية والتشريعية، والوقوف على حديث الأحرف السبعة، وأركان القراءة الصحيحة وتراجم القراء العشرة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_quran_revelation_compilation'],
        lessonIds: const [
          'lsn_quran_miraculous_nature',
          'lsn_quran_seven_letters_hadith',
          'lsn_quran_ten_qiraat_rules',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: الوحي ومراحل النزول
    // -------------------------------------------------------------------------
    final evQadrAyah = EvidenceLink.create(
      evidenceId: 'ev_qsc_qadr_1',
      evidenceKey: '97:1',
      citation: 'سورة القدر: الآية 1',
      sourceId: 'src_quran_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_quran_revelation_stages',
      title: 'نزول الوحي ومراحله ونزول القرآن الكريم مفرقاً في 23 سنة وحِكَمُه',
      courseId: courseId,
      moduleId: 'mod_quran_revelation_compilation',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qs1_1',
          title: 'فهم تنزلات القرآن الكريم وحكمة تفريقه',
          description: 'النزول جملة واحدة إلى بيت العزة في ليلة القدر، ثم تنزيله مفرقاً بحسب الوقائع لتثبيت قلب النبي ﷺ وتربية الأمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qs1_1',
          title: 'النص القرآني في ابتداء نزول القرآن وحكمة تنجيمه',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {إِنَّا أَنزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ}. وقال: {وَقُرْآنًا فَرَقْنَاهُ لِتَقْرَأَهُ عَلَى النَّاسِ عَلَىٰ مُكْثٍ وَنَزَّلْنَاهُ تَنزِيلًا}. وقال: {وَقَالَ الَّذِينَ كَفَرُوا لَوْلَا نُزِّلَ عَلَيْهِ الْقُرْآنُ جُمْلَةً وَاحِدَةً ۚ كَذَٰلِكَ لِنُثَبِّتَ بِهِ فُؤَادَكَ ۖ وَرَتَّلْنَاهُ تَرْتِيلًا}.',
          evidenceLinks: [evQadrAyah],
          sourceAttribution: 'سورة القدر: الآية 1، الإسراء: الآية 106، والفرقان: الآية 32',
        ),
        LessonSection.create(
          sectionId: 'sec_qs1_2',
          title: 'مراتب نزول القرآن العظيم وأسراره التشريعية',
          contentType: LearningContentType.explanation,
          content: 'للعلماء في نزول القرآن تحقيقان: الأول: نزوله جملة واحدة من اللوح المحفوظ إلى بيت العزة في السماء الدنيا في ليلة القدر المباركة، والثاني: نزوله مفرقاً (منجماً) بواسطة جبريل عليه السلام على قلب النبي ﷺ في نحو 23 سنة بحسب الأحداث والأسئلة. وحكمة تنجيمه: 1. تثبيت فؤاد النبي ﷺ وتأييده، 2. التدرج في تربية الأمة وتثبيت الأحكام كالخمر، 3. مسايرة الحوادث والإجابة عن الوقائع فور حدوثها، 4. إظهار الإعجاز البياني بأن هذا الكلام المنجم على مدار ربع قرن شديد الإحكام لا تناقض فيه قط.',
          sourceAttribution: 'الإتقان في علوم القرآن للسيوطي ج 1 ص 115',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_itqan_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: المكي والمدني
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_quran_makki_madani',
      title: 'علم المكي والمدني: ضوابطه، خصائصهما الموضوعية والأسلوبية وفوائد معرفته',
      courseId: courseId,
      moduleId: 'mod_quran_revelation_compilation',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qs2_1',
          title: 'التمييز الدقيق بين الآيات والسور المكية والمدنية',
          description: 'الضابط الزمني المعتمد (ما نزل قبل الهجرة وما نزل بعدها)، وخصائص المكي (التوحيد والقصص) والمدني (التشريع والجهاد).',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qs2_1',
          title: 'الأثر المأثور عن ابن مسعود في علم التنزيل',
          contentType: LearningContentType.sourceText,
          content: 'عن عبد الله بن مسعود رضي الله عنه قال: «والذي لا إله غيره ما أنزلت سورة من كتاب الله إلا وأنا أعلم أين نزلت، ولا أنزلت آية من كتاب الله إلا وأنا أعلم فيمن أنزلت، ولو أعلم أحداً أعلم مني بكتاب الله تبلغه الإبل لركبت إليه» رواه البخاري ومسلم.',
          sourceAttribution: 'صحيح البخاري رقم 5002',
        ),
        LessonSection.create(
          sectionId: 'sec_qs2_2',
          title: 'الضوابط والخصائص المميزة للمكي والمدني',
          contentType: LearningContentType.explanation,
          content: 'الراجح عند المحققين أن المكي هو ما نزل قبل الهجرة وإن نزل خارج مكة كعرفات والحديبية، والمدني هو ما نزل بعد الهجرة وإن نزل بمكة يوم الفتح.\n- خصائص السور المكية: التركيز على التوحيد والعقيدة وإبطال الشرك، وإيراد قصص الأنبياء والأمم السابقة، ومجادلة المشركين، وقِصر السور وقوة الألفاظ والجرس، وورود لفظ «كلا» وسجدات التلاوة وصيغة {يَا أَيُّهَا النَّاسُ}.\n- خصائص السور المدنية: تفصيل الشرائع والحدود والمعاملات والفرائض، والحديث عن الجهاد ومنافقين وأهل الكتاب، وطول السور والآيات، وصيغة {يَا أَيُّهَا الَّذِينَ آمَنُوا}.',
          sourceAttribution: 'مباحث في علوم القرآن لمناع القطان ص 55',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_mabahith_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: تاريخ جمع القرآن
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_quran_compilation_history',
      title: 'تاريخ جمع القرآن العظيم: في العهد النبوي، وعهد الصديق، والمصاحف العثمانية',
      courseId: courseId,
      moduleId: 'mod_quran_revelation_compilation',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qs3_1',
          title: 'إدراك مراحل حفظ القرآن وتدوينه التاريخي وصيانته من التحريف',
          description: 'كتابة الوحي بين يدي النبي ﷺ، جمع الصديق في صحف واحدة، وتوحيد عثمان للأمة على المصحف الإمام.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qs3_1',
          title: 'النص التاريخي لجمع القرآن في عهد أبي بكر الصديق',
          contentType: LearningContentType.sourceText,
          content: 'عن زيد بن ثابت رضي الله عنه قال: «أرسل إليّ أبو بكر مقتل أهل اليمامة، فإذا عمر بن الخطاب عنده، قال أبو بكر: إن عمر أتاني فقال: إن القتل قد استحرّ بقراء القرآن يوم اليمامة، وإني أخشى أن يستحرّ القتل بالقراء في المواطن فيذهب كثير من القرآن، وإني أرى أن تأمر بجمع القرآن... فتتبعت القرآن أجمعه من العُسُب واللِّخاف وصدور الرجال» رواه البخاري.',
          sourceAttribution: 'صحيح البخاري رقم 4986',
        ),
        LessonSection.create(
          sectionId: 'sec_qs3_2',
          title: 'المراحل الثلاث الكبرى لجمع المصحف الشريف',
          contentType: LearningContentType.explanation,
          content: 'مر حفظ القرآن بثلاث مراحل:\n1. العهد النبوي: كان محفوظاً في الصدور ومكتوباً مفرقاً على الرقاع والعُسب واللخاف بأمر النبي ﷺ ومراجعته وإشراف كُتّاب الوحي كعلي وزيد وأبي بن كعب.\n2. عهد أبي بكر الصديق (12 هـ): بعد استشهاد نحو 70 قارئاً في اليمامة، أشار عمر بجمعه، فكلف زيد بن ثابت فجمعه في صحف واحدة مرتبة الآيات بدقة متناهية لا يقبل آية إلا بشاهدي عدل ورواية وكتابة.\n3. عهد عثمان بن عفان (25 هـ): لما اتسعت الفتوحات واختلف الناس في القراءة في أذربيجان وأرمينيا، أمر عثمان بنسخ صحف أبي بكر في مصاحف متعددة على حرف قريش وأرسل نسخة لكل مصر وحرّق ما عداها ليقطع دابر الاختلاف ويوحد الأمة.',
          sourceAttribution: 'تاريخ القرآن وإعجازه لمحمد عبد العظيم الزرقاني (مناهل العرفان) ج 1 ص 240',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_manahil_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: إعجاز القرآن
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_quran_miraculous_nature',
      title: 'وجوه إعجاز القرآن الكريم: الإعجاز البياني، والتشريعي، والغيبي',
      courseId: courseId,
      moduleId: 'mod_quran_miracle_qiraat',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qs4_1',
          title: 'معرفة وجوه إعجاز كتاب الله وعجز البشر والجن عن معارضته',
          description: 'التحدي بالقرآن كله ثم بعشر سور ثم بسورة واحدة، وتكامل البلاغة والتشريع والغيب في آياته.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qs4_1',
          title: 'آية التحدي الخالدة لجميع الثقلين',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {قُل لَّئِنِ اجْتَمَعَتِ الْإِنسُ وَالْجِنُّ عَلَىٰ أَن يَأْتُوا بِمِثْلِ هَٰذَا الْقُرْآنِ لَا يَأْتُونَ بِمِثْلِهِ وَلَوْ كَانَ بَعْضُهُمْ لِبَعْضٍ ظَهِيرًا}. وقال: {فَأْتُوا بِسُورَةٍ مِّن مِّثْلِهِ}.',
          sourceAttribution: 'سورة الإسراء: الآية 88، وسورة البقرة: الآية 23',
        ),
        LessonSection.create(
          sectionId: 'sec_qs4_2',
          title: 'وجوه الإعجاز الثلاثة الكبرى',
          contentType: LearningContentType.explanation,
          content: 'الإعجاز هو إثبات عجز الخلق عن الإتيان بمثل القرآن. ووجوهه متعددة متكاملة: 1. الإعجاز اللغوي والبياني: في فصاحة ألفاظه، وجزالة نظمه، وروعة أسلوبه الذي أبهر فصحاء العرب وألجمهم، 2. الإعجاز التشريعي: كمال شريعته وصلاحيتها لكل زمان ومكان وحفظها للضروريات الخمس وتحقيقها العدل التام، 3. الإعجاز الغيبي: إخباره عن مغيبات الماضي كأمم نوح وعاد وثمود، ومغيبات المستقبل التي وقعت كما أخبر كغلبة الروم في أدنى الأرض.',
          sourceAttribution: 'إعجاز القرآن للباقلاني، والنبأ العظيم لدراز',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_naba_azeem_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الأحرف السبعة
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_quran_seven_letters_hadith',
      title: 'حديث نزول القرآن على سبعة أحرف: مفهومها وحكمتها وفضل التيسير',
      courseId: courseId,
      moduleId: 'mod_quran_miracle_qiraat',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qs5_1',
          title: 'فهم حقيقة الأحرف السبعة والفرق بينها وبين القراءات العشر',
          description: 'تيسير تلاوة القرآن على قبائل العرب باختلاف لهجاتها مع وحدة المعنى والأصل المعجز.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qs5_1',
          title: 'الحديث المتواتر في نزول القرآن على سبعة أحرف',
          contentType: LearningContentType.sourceText,
          content: 'عن عمر بن الخطاب رضي الله عنه قال: سمعتُ هشام بن حكيم يقرأ سورة الفرقان في حياة رسول الله ﷺ... فلما انصرف لَبَّبْتُهُ بردائه، فجئت به رسول الله ﷺ... فقال رسول الله ﷺ: «أرسله يا عمر، اقرأ يا هشام، فقرأ، فقال: هكذا أُنزلت، ثم قال: اقرأ يا عمر، فقرأتُ، فقال: هكذا أُنزلت؛ إن هذا القرآن أُنزل على سبعة أحرف، فاقرءوا ما تيسر منه» متفق عليه.',
          sourceAttribution: 'صحيح البخاري رقم 4992، وصحيح مسلم رقم 818',
        ),
        LessonSection.create(
          sectionId: 'sec_qs5_2',
          title: 'تحرير معنى الأحرف السبعة والحكمة منها',
          contentType: LearningContentType.explanation,
          content: 'أجمع العلماء على أن الأحرف السبعة نزلت تيسيراً ورحمة بالأمة لاختلاف لهجات قبائل العرب وألسنتهم (كقريش وهذيل وتميم) في إبدال بعض الكلمات المترادفة، أو وجوه الإعراب، أو التقديم والتأخير، أو الهمز والتسهيل دون تناقض في الأحكام. والمصاحف العثمانية كُتبت برسم يحتمل ما صح وثبت من هذه الأحرف، والقراءات المتواترة اليوم هي ما تضمنه رسم المصحف العثماني من الأحرف السبعة.',
          sourceAttribution: 'النشر في القراءات العشر لابن الجزري ج 1 ص 21',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_nashr_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 6: القراءات المتواترة وأركانها
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_quran_ten_qiraat_rules',
      title: 'القراءات القرآنية العشر المتواترة وأركان القراءة الصحيحة',
      courseId: courseId,
      moduleId: 'mod_quran_miracle_qiraat',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_qs6_1',
          title: 'حفظ أركان القراءة الصحيحة الثلاثة والتعرف على أئمة القراءات',
          description: 'صحة السند مع التواتر، موافقة الرسم العثماني ولو احتمالاً، وموافقة وجه من وجوه اللغة العربية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_qs6_1',
          title: 'قاعدة ابن الجزري في أركان القراءة الصحيحة',
          contentType: LearningContentType.sourceText,
          content: 'فكلُّ ما وافقَ وجهَ نَحْوِ ... وكانَ للرسمِ احتمالاً يَحْوي\nوصحَّ إسناداً هو القرآنُ ... فهذهِ الثلاثةُ الأركانُ\nوحيثُما يَخْتَلُّ ركنٌ أثبِتِ ... شذوذَهُ لو أنهُ في السبعةِ',
          sourceAttribution: 'طيبة النشر في القراءات العشر لابن الجزري',
        ),
        LessonSection.create(
          sectionId: 'sec_qs6_2',
          title: 'أركان القراءة المقبولة والقراء العشرة ورواتهم',
          contentType: LearningContentType.explanation,
          content: 'لا تكون القراءة قرآناً متلواً إلا باجتماع 3 أركان: 1. صحة السند وتواتره إلى النبي ﷺ، 2. موافقة الرسم العثماني ولو تقديراً، 3. موافقتها لوجه من وجوه النحو العربي ولو ضعيفاً. والقراءات المعتمدة المتواترة عشر قراءات، أشهر أئمتها: نافع المدني (ورواياه: قالون وورش)، وابن كثير المكي (البزي وقنبل)، وأبو عمرو البصري (الدوري والسوسي)، وابن عامر الشامي (هشام وابن ذكوان)، وعاصم الكوفي (شعبة وحفص وهو الأكثر انتشاراً اليوم)، وحمزة الكوفي (خلف وخلاد)، والكسائي الكوفي (أبو الحارث والدوري)، وأبو جعفر، ويعقوب، وخلف العاشر.',
          sourceAttribution: 'معرفة القراء الكبار على الطبقات والحروف للذهبي',
        ),
      ],
      sources: const ['src_tayyibah_canonical', 'src_nashr_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Compilation History
    final q1 = QuizQuestion.create(
      questionId: 'q_qs_compilation_1',
      lessonId: 'lsn_quran_compilation_history',
      questionText: 'من هو الصحابي الجليل الذي اختاره أبو بكر وعمر ثم عثمان لجمع المصحف الشريف في المرتين؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qc1_1', text: 'زيد بن ثابت الأنصاري رضي الله عنه (كاتب وحي النبي ﷺ)'),
        QuizOption(optionId: 'opt_qc1_2', text: 'عبد الله بن مسعود رضي الله عنه'),
        QuizOption(optionId: 'opt_qc1_3', text: 'أبي بن كعب رضي الله عنه'),
      ],
      correctOptionIndices: const [0],
      explanation: 'زيد بن ثابت رضي الله عنه كان شاباً عاقلاً كاتباً للوحي شهد العرضة الأخيرة للقرآن مع النبي ﷺ.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_quran_compilation',
      lessonId: 'lsn_quran_compilation_history',
      title: 'اختبار تاريخ جمع وتدوين القرآن الكريم',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Makki & Madani
    final q2 = QuizQuestion.create(
      questionId: 'q_qs_makki_1',
      lessonId: 'lsn_quran_makki_madani',
      questionText: 'ما هو الضابط الزمني الأصح المعتمد عند جمهور العلماء في التمييز بين المكي والمدني؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qm1_1', text: 'المكي ما نزل قبل الهجرة وإن نزل خارج مكة، والمدني ما نزل بعد الهجرة وإن نزل بمكة'),
        QuizOption(optionId: 'opt_qm1_2', text: 'المكي ما نزل داخل حدود مكة المكرمة فقط بغض النظر عن الزمان'),
        QuizOption(optionId: 'opt_qm1_3', text: 'المكي ما خاطب أهل قريش فقط والمدني ما خاطب الأنصار'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الضابط الزمني المعتمد يعتبر الهجرة النبوية الشريفة هي الحد الفاصل بين العهدين المكي والمدني.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_quran_makki_madani',
      lessonId: 'lsn_quran_makki_madani',
      title: 'اختبار ضوابط وخصائص المكي والمدني',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Qiraat Rules
    final q3 = QuizQuestion.create(
      questionId: 'q_qs_qiraat_1',
      lessonId: 'lsn_quran_ten_qiraat_rules',
      questionText: 'ما هي الأركان الثلاثة الواجب توفرها معاً لصحة القراءة القرآنية وثبوت قرآنيتها؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qq1_1', text: 'صحة السند وتواتره، وموافقة الرسم العثماني، وموافقة وجه من وجوه اللغة العربية'),
        QuizOption(optionId: 'opt_qq1_2', text: 'الشهرة بين العوام، وحسن الصوت، وموافقة قراءة حفص فقط'),
        QuizOption(optionId: 'opt_qq1_3', text: 'موافقة كتب التفسير، وسهولة النطق، والترجمة الحرفية'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أركان القراءة الصحيحة ثلاثة كما نظمها ابن الجزري: صحة السند، موافقة الرسم العثماني، وموافقة النحو العربي.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_quran_miracle_qiraat',
      lessonId: 'lsn_quran_ten_qiraat_rules',
      title: 'اختبار إعجاز القرآن والقراءات المتواترة',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
