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

/// بيانات مقرر معتقد أهل السنة والجماعة والتحصين الفكري (5 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningAqidahSunnahData {
  static const String courseId = 'course_aqidah_sunnah';
  static const String pathId = 'path_aqidah_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر معتقد أهل السنة والجماعة والتحصين الفكري',
      description: 'دراسة عقدية تأصيلية شاملة في أصول أهل السنة: فضل الصحابة وآل البيت، وحقيقة الإيمان وزيادته ونقصانه، والاعتصام بالسنة ونبذ البدع، وضوابط التكفير وموانعه، وقواعد رد الشبهات الفكرية والإلحاد.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_aqidah_sahabah_faith', 'mod_aqidah_sunnah_safeguards'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_aqidah_sahabah_faith',
        courseId: courseId,
        title: 'الوحدة الأولى: معتقد أهل السنة في الصحابة والقرابة وحقيقة الإيمان',
        description: 'بيان فضل الصحابة الأبرار، والخلفاء الراشدين، وآل بيت النبي ﷺ، ومعتقد السلف الصالح في أن الإيمان قول وعمل يزيد وينقص.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_aqidah_sahabah_virtues_rights',
          'lsn_aqidah_faith_definition_increase',
        ],
      ),
      CourseModule(
        moduleId: 'mod_aqidah_sunnah_safeguards',
        courseId: courseId,
        title: 'الوحدة الثانية: الاعتصام بالسنة ومناهج التحصين الفكري المعاصر',
        description: 'لزوم جماعة المسلمين والتحذير من البدع والمحدثات، وضوابط التكفير المانعة من الغلو، والمنهج القرآني في تفنيد الشبهات المعاصرة والإلحاد.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_aqidah_sahabah_faith'],
        lessonIds: const [
          'lsn_aqidah_holding_sunnah_bidah',
          'lsn_aqidah_takfir_rules_impediments',
          'lsn_aqidah_contemporary_intellectual_defence',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: فضل الصحابة وآل البيت
    // -------------------------------------------------------------------------
    final evSahabahHadith = EvidenceLink.create(
      evidenceId: 'ev_sah_hadith_bukhari',
      evidenceKey: 'hadith_sahabah_stars',
      citation: 'صحيح البخاري: رقم 3673',
      sourceId: 'src_bukhari_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_aqidah_sahabah_virtues_rights',
      title: 'فضل الصحابة الكرام والخلفاء الراشدين وآل البيت وحرمة سبهم',
      courseId: courseId,
      moduleId: 'mod_aqidah_sahabah_faith',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_as1_1',
          title: 'ترسيخ معتقد أهل السنة في محبة الصحابة وآل البيت والترضي عنهم',
          description: 'عدالة الصحابة جميعاً بنص القرآن، وترتيب الخلفاء الأربعة في الفضل، وموالاة آل البيت وحرمة الخوض فيما شجر بينهم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_as1_1',
          title: 'النهي النبوي الصريح عن سب أصحاب النبي ﷺ',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «لا تسبوا أصحابي، فلو أن أحدكم أنفق مثل أُحدٍ ذهباً ما بلغ مُدّ أحدهم ولا نَصيفه» رواه البخاري ومسلم.',
          evidenceLinks: [evSahabahHadith],
          sourceAttribution: 'صحيح البخاري رقم 3673، وصحيح مسلم رقم 2540',
        ),
        LessonSection.create(
          sectionId: 'sec_as1_2',
          title: 'معتقد السلف في الصحابة وقرابة النبي ﷺ',
          contentType: LearningContentType.explanation,
          content: 'من أصول أهل السنة والجماعة: سلامة قلوبهم وألسنتهم لأصحاب رسول الله ﷺ، والترضي عنهم وتوليهم، واعتقاد أن أفضل الأمة بعد نبيها: أبو بكر الصديق، ثم عمر الفاروق، ثم عثمان ذو النورين، ثم علي المرتضى رضي الله عنهم أجمعين. كما يوجب أهل السنة محبة آل بيت النبي ﷺ ورعاية وصيته فيهم بلا غلو ولا جفاء، والكف عما شجر بين الصحابة وحمل ما وقع منهم على حسن الظن والاجتهاد.',
          sourceAttribution: 'العقيدة الواسطية لشيخ الإسلام ابن تيمية فصل الصحابة',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_wasitiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: حقيقة الإيمان وزيادته ونقصانه
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_aqidah_faith_definition_increase',
      title: 'حقيقة الإيمان عند أهل السنة: قول وعمل، يزيد بالطاعة وينقص بالمعصية',
      courseId: courseId,
      moduleId: 'mod_aqidah_sahabah_faith',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_as2_1',
          title: 'التعرف على حد الإيمان الشرعي والرد على المرجئة والخوارج',
          description: 'أن الإيمان قول اللسان واعتقاد الجنان وعمل الأركان، يزيد بالطاعات وينقص بالمعاصي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_as2_1',
          title: 'النص القرآني في زيادة الإيمان',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {إِنَّمَا الْمُؤْمِنُونَ الَّذِينَ إِذَا ذُكِرَ اللَّهُ وَجِلَتْ قُلُوبُهُمْ وَإِذَا تُلِيَتْ عَلَيْهِمْ آيَاتُهُ زَادَتْهُمْ إِيمَانًا}. وقال ﷺ: «الإيمان بضع وسبعون شعبة، فأعلاها قول لا إله إلا الله، وأدناها إماطة الأذى عن الطريق، والحياء شعبة من الإيمان».',
          sourceAttribution: 'سورة الأنفال: الآية 2، وصحيح مسلم رقم 35',
        ),
        LessonSection.create(
          sectionId: 'sec_as2_2',
          title: 'تقرير أهل السنة الفارق في الإيمان',
          contentType: LearningContentType.explanation,
          content: 'الإيمان عند أهل السنة والجماعة مركب من ثلاثة أركان متلازمة: قول اللسان، واعتقاد القلب، وعمل الجوارح والأركان، يزيد بطاعة الرحمن، وينقص بطاعة الشيطان ومعصية الرحمن. وبذلك فارق أهل السنة: 1. المرجئة الذين أخرجوا العمل من مسمى الإيمان وزعموا أن إيمان أفسق الناس كإيمان جبريل، 2. الخوارج الذين كفّروا مرتكب الكبيرة وأخرجوه من الإيمان وخلدوه في النيران.',
          sourceAttribution: 'كتاب الإيمان لأبي عبيد القاسم بن سلام ص 12',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: لزوم السنة والتحذير من البدع
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_aqidah_holding_sunnah_bidah',
      title: 'الاعتصام بالكتاب والسنة والتحذير من البدع والمحدثات في الدين',
      courseId: courseId,
      moduleId: 'mod_aqidah_sunnah_safeguards',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_as3_1',
          title: 'إدراك خطورة الابتداع في الدين وفضل الاتباع النبوي',
          description: 'معرفة ضابط البدعة في الدين، ووجوب الاتباع ولزوم هدي السلف الصالح.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_as3_1',
          title: 'الوصية الجامعة للعرباض بن سارية',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «عليكم بسنتي وسنة الخلفاء المهديين الراشدين، تمسكوا بها وعضوا عليها بالنواجذ، وإياكم ومحدثات الأمور، فإن كل محدثة بدعة، وكل بدعة ضلالة» رواه أبو داود والترمذي وقال حسن صحيح.',
          sourceAttribution: 'سنن أبي داود رقم 4607، وسنن الترمذي رقم 2676',
        ),
        LessonSection.create(
          sectionId: 'sec_as3_2',
          title: 'تعريف البدعة وضوابطها الشرعية',
          contentType: LearningContentType.explanation,
          content: 'البدعة في الدين: طريقة في الدين مخترعة تُضاهي الشريعة يُقصد بالسلوك عليها التقرب إلى الله مما لم يشرعه الله ورسوله. والابتداع استدراك على الشرع وطعن في كماله؛ ولذا قال الإمام مالك رحمه الله: «من ابتدع في الإسلام بدعة يراها حسنة فقد زعم أن محمداً خان الرسالة، لأن الله يقول: {الْيَوْمَ أَكْمَلْتُ لَكُمْ دِينَكُمْ}، فما لم يكن يومئذٍ ديناً فلا يكون اليوم ديناً».',
          sourceAttribution: 'الاعتصام للإمام الشاطبي ج 1 ص 49',
        ),
      ],
      sources: const ['src_abudawood_canonical', 'src_itisam_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: ضوابط التكفير وموانعه
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_aqidah_takfir_rules_impediments',
      title: 'ضوابط التكفير وموانعه الشرعية والتحذير الصارم من الغلو والتفجير',
      courseId: courseId,
      moduleId: 'mod_aqidah_sunnah_safeguards',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_as4_1',
          title: 'فهم شروط وموانع التكفير المعين والحذر من مذهب الخوارج',
          description: 'خطورة رمي المسلمين بالكفر، وتحقيق شروط التكفير وموانعه (الجهل، الإكراه، الخطأ، التأويل).',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_as4_1',
          title: 'التحذير النبوي الرهيب من تكفير المسلم بغير حق',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «أيّما امرئٍ قال لأخيه: يا كافر، فقد باء بها أحدهما؛ فإن كان كما قال وإلا رجعت عليه» رواه البخاري ومسلم.',
          sourceAttribution: 'صحيح البخاري رقم 6104، وصحيح مسلم رقم 60',
        ),
        LessonSection.create(
          sectionId: 'sec_as4_2',
          title: 'قواعد وموانع التكفير عند المحققين من العلماء',
          contentType: LearningContentType.explanation,
          content: 'التكفير حكم شرعي مرجعه إلى الله ورسوله، وليس بالتشهي أو الهوى. وموانع التكفير المعين أربعة كبرى: 1. الجهل المعتبر شرعاً، 2. الإكراه المعتبر بنص قوله تعالى: {إِلَّا مَنْ أُكْرِهَ وَقَلْبُهُ مُطْمَئِنٌّ بِالإِيمَانِ}، 3. الخطأ غير المقصود كحديث الرجل الذي أضل ناقته فقال من شدة الفرح: «اللهم أنت عبدي وأنا ربك»، 4. التأويل والشبهة السائغة. فلا يقدم على تكفير المعين إلا القضاة والعلماء الراسخون بعد إقامة الحجة واستتابته.',
          sourceAttribution: 'القواعد والضوابط الفقهية في التكفير ص 85',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: التحصين الفكري المعاصر
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_aqidah_contemporary_intellectual_defence',
      title: 'التحصين الفكري المعاصر في مواجهة الإلحاد، النسبية، والشبهات العصرية',
      courseId: courseId,
      moduleId: 'mod_aqidah_sunnah_safeguards',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_as5_1',
          title: 'امتلاك أدوات الوعي الفكري والرد القرآني على الإلحاد والشبهات',
          description: 'تفصيل برهان السببية، ودقة الضبط الكوني، والرد على شبهات الشر والوجود بلغة علمية مؤصلة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_as5_1',
          title: 'النص الإلهي في دلائل الصنعة والضبط الكوني',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {سَنُرِيهِمْ آيَاتِنَا فِي الْآفَاقِ وَفِي أَنفُسِهِمْ حَتَّىٰ يَتَبَيَّنَ لَهُمْ أَنَّهُ الْحَقُّ ۗ أَوَلَمْ يَكْفِ بِرَبِّكَ أَنَّهُ عَلَىٰ كُلِّ شَيْءٍ شَهِيدٌ}.',
          sourceAttribution: 'سورة فصلت: الآية 53',
        ),
        LessonSection.create(
          sectionId: 'sec_as5_2',
          title: 'أصول مناظرة الإلحاد وتفنيد الشبهات المعاصرة',
          contentType: LearningContentType.example,
          content: 'يرتكز التحصين الفكري الإيماني على ثلاث براهين كبرى لا تدحض: 1. برهان السببية والحدوث: أن كل حادث لابد له من محدث، فالكون بقوانينه الدقيقة لا يمكن أن يوجد صدفة أو من العدم، 2. برهان الإتقان والغائية (الضبط الكوني): الثوابت الفيزيائية الدقيقة تعلن عن إرادة عليمة حكيمة، 3. برهان الفطرة والأخلاق: إدراك الخير والشر والنزوع نحو الحق غريزة إلهية مركوزة في النفس البشرية لا يفسرها المذهب المادي العشوائي.',
          sourceAttribution: 'براهين النبوة وسامي عامري ص 140',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_contemporary_intellect_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Sahabah
    final q1 = QuizQuestion.create(
      questionId: 'q_as_sahabah_1',
      lessonId: 'lsn_aqidah_sahabah_virtues_rights',
      questionText: 'ما هو معتقد أهل السنة والجماعة في الصحابة الكرام والخلافات التي جرت بينهم؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qsh1_1', text: 'محبتهم جميعاً، والترضي عنهم، واعتقاد عدالتهم، والكف عما شجر بينهم وحمله على حسن الاجتهاد'),
        QuizOption(optionId: 'opt_qsh1_2', text: 'تفضيل بعضهم مع سب الباقين والطعن في نياتهم'),
        QuizOption(optionId: 'opt_qsh1_3', text: 'اعتقاد العصمة التامة في كل واحد منهم كعصمة الأنبياء'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أهل السنة يتولون جميع الصحابة، ويشهدون بعدالتهم بنص القرآن، ويمسكون عما شجر بينهم مع الاعتراف بفضلهم وسابقتهم.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_aqidah_sahabah_belief',
      lessonId: 'lsn_aqidah_sahabah_virtues_rights',
      title: 'اختبار فضل الصحابة الكرام وآل البيت وعدالتهم',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Iman Nature
    final q2 = QuizQuestion.create(
      questionId: 'q_as_iman_1',
      lessonId: 'lsn_aqidah_faith_definition_increase',
      questionText: 'ما هو تعريف الإيمان عند أهل السنة والجماعة وما علاقته بالطاعة والمعصية؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qim1_1', text: 'قول باللسان، واعتقاد بالجنان، وعمل بالأركان، يزيد بالطاعة وينقص بالمعصية'),
        QuizOption(optionId: 'opt_qim1_2', text: 'المعرفة القلبية فقط ولا علاقة للعمل أو اللسان به (قول المرجئة)'),
        QuizOption(optionId: 'opt_qim1_3', text: 'كل لا يتجزأ فإن نقص منه شيء زال كله (قول الخوارج)'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الإيمان عند سلف الأمة وأئمتها هو: قول وعمل ونية، يزيد بالطاعة وينقص بالمعصية، وهو شعب متفاضلة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_aqidah_iman_nature',
      lessonId: 'lsn_aqidah_faith_definition_increase',
      title: 'اختبار حقيقة الإيمان وزيادته ونقصانه ومذاهب الفرق',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Takfir Rules
    final q3 = QuizQuestion.create(
      questionId: 'q_as_takfir_1',
      lessonId: 'lsn_aqidah_takfir_rules_impediments',
      questionText: 'ما الذي يجب توفره قبل الحكم على مسلم معين بالخروج من الإسلام والردة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qtk1_1', text: 'ثبوت الشروط وانتفاء الموانع (كالجهل، والإكراه، والخطأ، والتأويل) بعد إقامة الحجة بواسطة القضاء والعلماء الراسخين'),
        QuizOption(optionId: 'opt_qtk1_2', text: 'مجرد وقوعه في معصية كبرى كالسرقة أو شرب الخمر'),
        QuizOption(optionId: 'opt_qtk1_3', text: 'حكم آحاد العوام بمجرد التهمة والاشتباه'),
      ],
      correctOptionIndices: const [0],
      explanation: 'التكفير المعين خطير جداً، ولا يحكم به إلا القضاء والعلماء بعد استيفاء الشروط (العلم والعمد والاختيار) وانتفاء موانع الجهل والإكراه والخطأ والتأويل.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_aqidah_sunnah_takfir_rules',
      lessonId: 'lsn_aqidah_takfir_rules_impediments',
      title: 'اختبار ضوابط التكفير وموانعه ومواجهة الغلو',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
