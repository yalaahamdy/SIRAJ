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

/// بيانات مقرر الإيمان باليوم الآخر وأشراط الساعة وعالم البرزخ (6 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningAqidahAfterlifeData {
  static const String courseId = 'course_aqidah_afterlife';
  static const String pathId = 'path_aqidah_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الإيمان باليوم الآخر وأشراط الساعة وعالم البرزخ',
      description: 'دراسة عقدية تأصيلية شاملة في أحكام الموت وعالم البرزخ ونعيم القبر وعذابه، وأشراط الساعة الصغرى والكبرى، والبعث والنشور، والحساب والميزان والصراط والجنة والنار.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_aqidah_barzakh_signs', 'mod_aqidah_resurrection_judgement'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_aqidah_barzakh_signs',
        courseId: courseId,
        title: 'الوحدة الأولى: عالم البرزخ وأشراط الساعة الصغرى والكبرى',
        description: 'بيان حقيقة الموت وسؤال الملكين بالقبر، ونعيم وعذاب البرزخ، وأشراط الساعة الصغرى المتتابعة، والآيات الكبرى العظام قبل قيام الساعة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_aqidah_death_barzakh_grave',
          'lsn_aqidah_minor_signs_hour',
          'lsn_aqidah_major_signs_hour',
        ],
      ),
      CourseModule(
        moduleId: 'mod_aqidah_resurrection_judgement',
        courseId: courseId,
        title: 'الوحدة الثانية: القيامة الكبرى والجزاء الأخروي',
        description: 'النفخ في الصور، والبعث من القبور، وأهوال الموقف، والشفاعة العظمى، والحوض، والميزان، وتطاير الصحف، والصراط، والجنة والنار ورؤية المؤمنين لربهم.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_aqidah_barzakh_signs'],
        lessonIds: const [
          'lsn_aqidah_resurrection_gathering',
          'lsn_aqidah_basin_scales_scrolls',
          'lsn_aqidah_sirat_paradise_hell',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: الموت وعالم البرزخ
    // -------------------------------------------------------------------------
    final evBarzakhAyah = EvidenceLink.create(
      evidenceId: 'ev_barzakh_muminun',
      evidenceKey: '23:100',
      citation: 'سورة المؤمنون: الآية 100',
      sourceId: 'src_quran_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_aqidah_death_barzakh_grave',
      title: 'سكرات الموت وفتنة القبر وسؤال الملكين ونعيم البرزخ وعذابه',
      courseId: courseId,
      moduleId: 'mod_aqidah_barzakh_signs',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_al1_1',
          title: 'الإيمان التام بعالم البرزخ والفتنة ونعيم وعذاب القبر',
          description: 'معرفة سؤال الملكين (من ربك؟ ما دينك؟ من نبيك؟) وتثبيت الله لأهل الإيمان في الحياة والممات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_al1_1',
          title: 'النص الأصيل في حياة البرزخ',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {وَمِن وَرَائِهِم بَرْزَخٌ إِلَىٰ يَوْمِ يُبْعَثُونَ}. وقال النبي ﷺ في حديث البراء بن عازب الطويل: «فيأتيه ملكان فيجلسانه فيقولان له: من ربك؟ فيقول: ربي الله، فيقولان له: ما دينك؟ فيقول: ديني الإسلام، فيقولان له: ما هذا الرجل الذي بُعث فيكم؟ فيقول: هو رسول الله ﷺ».',
          evidenceLinks: [evBarzakhAyah],
          sourceAttribution: 'سورة المؤمنون: الآية 100، ومسند أحمد وسنن أبي داود',
        ),
        LessonSection.create(
          sectionId: 'sec_al1_2',
          title: 'عقيدة أهل السنة في نعيم وعذاب القبر',
          contentType: LearningContentType.explanation,
          content: 'أجمع أهل السنة والجماعة على أن عذاب القبر ونعيمه حق ثابت متواتر بالنصوص الصريحة من الكتاب والسنة كقوله تعالى في آل فرعون: {النَّارُ يُعْرَضُونَ عَلَيْهَا غُدُوًّا وَعَشِيًّا}. والنعيم والعذاب ينالان الروح والبدن جميعاً في البرزخ بحال تليق بتلك الدار، وإن أُحرق الجسد أو تفرق في البحار.',
          sourceAttribution: 'الروح لابن قيم الجوزية ص 60',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_abudawood_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: أشراط الساعة الصغرى
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_aqidah_minor_signs_hour',
      title: 'أشراط الساعة الصغرى: ما تحقق منها وما ينتظر ودلائل النبوة',
      courseId: courseId,
      moduleId: 'mod_aqidah_barzakh_signs',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_al2_1',
          title: 'التعرف على علامات الساعة الصغرى وترسيخ اليقين بصدق الرسول ﷺ',
          description: 'بعثة النبي ﷺ، وموته، وفتح بيت المقدس، وكثرة الفتن وتطاول الحفاة في البنيان.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_al2_1',
          title: 'النص النبوي في علامات الساعة الصغرى',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «بُعثتُ أنا والساعة كهاتين، وقرن بين السبابة والوسطى» رواه البخاري ومسلم. وقال في حديث جبريل المشهور: «وأن ترى الحفاة العراة العالة رِعاء الشاء يتطاولون في البنيان».',
          sourceAttribution: 'صحيح البخاري رقم 4936، وصحيح مسلم رقم 8',
        ),
        LessonSection.create(
          sectionId: 'sec_al2_2',
          title: 'أقسام أشراط الساعة الصغرى',
          contentType: LearningContentType.explanation,
          content: 'العلامات الصغرى هي المتقدمة على القيامة بأزمان متطاولة وتأتي تباعاً، وتنقسم إلى: 1. علامات وقعت وانقضت كبعثته ﷺ ووفاته وانشقاق القمر ونار الحجاز، 2. علامات ظهرت ولا تزال تتتابع كتقارب الزمان، وفشو التجارة، وكثرة الهرج (القتل)، 3. علامات لم تظهر بعد كعودة جزيرة العرب مروجاً وأنهاراً وحسْر الفرات عن جبل من ذهب.',
          sourceAttribution: 'أشراط الساعة ليوسف الوابل ص 75',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: أشراط الساعة الكبرى
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_aqidah_major_signs_hour',
      title: 'أشراط الساعة الكبرى الملحمية: المهدي، الدجال، نزول عيسى، ويأجوج ومأجوج',
      courseId: courseId,
      moduleId: 'mod_aqidah_barzakh_signs',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_al3_1',
          title: 'معرفة الآيات الكبرى العشر المتتابعة كعقد انفرط',
          description: 'خروج المهدي، فتنة الدجال الأعظم وكيفية النجاة منها، نزول عيسى، يأجوج ومأجوج، وطلوع الشمس من مغربها.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_al3_1',
          title: 'الحديث الجامع للآيات العشر الكبرى',
          contentType: LearningContentType.sourceText,
          content: 'عن حذيفة بن أسيد الغفاري رضي الله عنه قال: اطّلع النبي ﷺ علينا ونحن نتذاكر، فقال: «ما تذاكرون؟ قالوا: نذكر الساعة. قال: إنها لن تقوم حتى ترون قبلها عشر آيات: فذكر الدخان، والدجال، والدابة، وطلوع الشمس من مغربها، ونزول عيسى ابن مريم ﷺ، ويأجوج ومأجوج، وثلاثة خسوف: خسف بالمشرق، وخسف بالمغرب، وخسف بجزيرة العرب، وآخر ذلك نار تخرج من اليمن تطرد الناس إلى محشرهم» رواه مسلم.',
          sourceAttribution: 'صحيح مسلم رقم 2901',
        ),
        LessonSection.create(
          sectionId: 'sec_al3_2',
          title: 'الترتيب المنهجي للأشراط الكبرى وفتنة الدجال العظمى',
          contentType: LearningContentType.explanation,
          content: 'أعظم فتنة تمر على البشرية منذ خلق آدم هي فتنة المسيح الدجال؛ ولذا ما من نبي إلا أنذر أمته الدجال الأعور الكذاب. وعصمة المسلم منه تكون بالإيمان والتوحيد، وحفظ فواتح سورة الكهف، والتعوذ منه دبر كل صلاة، والفرار منه إلى مكة والمدينة فإنهما محرمتان عليه تحرسهما الملائكة، ثم ينزل عيسى بن مريم عليه السلام فيقتله بباب لُد بفلسطين ويضع الجزية ويكسر الصليب ويهلك الله في زمانه يأجوج ومأجوج.',
          sourceAttribution: 'النهاية في الفتن والملاحم لابن كثير ج 1 ص 95',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_nihayah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: النفخ في الصور والبعث والنشور
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_aqidah_resurrection_gathering',
      title: 'النفخ في الصور والبعث والنشور وأهوال الموقف والشفاعة العظمى',
      courseId: courseId,
      moduleId: 'mod_aqidah_resurrection_judgement',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_al4_1',
          title: 'الإيمان بأحداث يوم القيامة والموقف العظيم ومقام الشفاعة المحمود',
          description: 'نفخة الصعق ونفخة البعث، والحشر حفاة عراة غرلاً، ودنو الشمس، ومقام الشفاعة العظمى لسيدنا محمد ﷺ.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_al4_1',
          title: 'النص القرآني في النفخ والبعث',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {وَنُفِخَ فِي الصُّورِ فَصَعِقَ مَن فِي السَّمَاوَاتِ وَمَن فِي الْأَرْضِ إِلَّا مَن شَاءَ اللَّهُ ۖ ثُمَّ نُفِخَ فِيهِ أُخْرَىٰ فَإِذَا هُمْ قِيَامٌ يَنظُرُونَ}.',
          sourceAttribution: 'سورة الزمر: الآية 68',
        ),
        LessonSection.create(
          sectionId: 'sec_al4_2',
          title: 'مشاهد الموقف والشفاعة العظمى لنبينا ﷺ',
          contentType: LearningContentType.explanation,
          content: 'ينفخ إسرافيل في الصور نفختين: نفخة الصعق فيموت كل حي، ثم نفخة البعث فتعود الأرواح إلى أجسادها وينشق التراب عن الناس فيخرجون حفاة عراة غُرلاً (غير مختونين). وتدنو الشمس من الرؤوس بمقدار ميل حتى يغرق الناس في عرقهم بحسب أعمالهم. وحين يشتد الكرب يلجأ الخلائق إلى أولي العزم من الرسل وكلهم يقول «نفسي نفسي»، حتى يأتون نبينا محمداً ﷺ فيقول: «أنا لها»، فيسجد تحت العرش فيحمد الله بمحامد يفتحها الله عليه، فيقال له: «يا محمد، ارفع رأسك، وسل تُعطه، واشفع تُشفّع»، وهي الشفاعة العظمى لفصل القضاء.',
          sourceAttribution: 'شرح العقيدة الواسطية لابن تيمية ص 115',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الحوض والميزان والصحف
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_aqidah_basin_scales_scrolls',
      title: 'الحوض المورود وعرض الأعمال وتطاير الصحف والميزان الدقيق',
      courseId: courseId,
      moduleId: 'mod_aqidah_resurrection_judgement',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_al5_1',
          title: 'فهم صفة الحوض النبوي وحساب الأعمال وميزان الحسنات والسيئات',
          description: 'الإيمان بحوض النبي الكوثري، وتطاير كتب الأعمال باليمين أو الشمال، ووزن الأعمال بميزان حقيقي له كفتان.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_al5_1',
          title: 'صفة حوض النبي ﷺ المورود',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «حوضي مسيرة شهر، ماؤه أبيض من اللبن، وريحه أطيب من المسك، وكيزانه كنجوم السماء، من شرب منها فلا يظمأ أبداً» رواه البخاري ومسلم.',
          sourceAttribution: 'صحيح البخاري رقم 6579، وصحيح مسلم رقم 2292',
        ),
        LessonSection.create(
          sectionId: 'sec_al5_2',
          title: 'تطاير الصحف والميزان الحقيقي ذو الكفتين',
          contentType: LearningContentType.explanation,
          content: 'يُعرض الناس على الله وتتطاير الصحف، فآخذٌ كتابه بيمينه إلى جنة الفردوس، وآخذٌ كتابه بشماله أو من وراء ظهره إلى الجحيم. ثم تنصب الموازين يوم القيامة، وهو ميزان حقيقي له لسان وكفتان تُوزن به الحسنات والسيئات وتوزن به صحائف الأعمال وأجسام العباد، كما في حديث البطاقة وحديث ساقي ابن مسعود التي هي أثقل في الميزان من جبل أحد.',
          sourceAttribution: 'شرح الطحاوية ص 390',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_tahawiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 6: الصراط والجنة والنار
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_aqidah_sirat_paradise_hell',
      title: 'الصراط المضروب على متن جهنم والجنة والنار ورؤية الله تعالى',
      courseId: courseId,
      moduleId: 'mod_aqidah_resurrection_judgement',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_al6_1',
          title: 'الإيمان بالصراط، والجنة ودرجاتها، والنار ودركاتها، ورؤية المؤمنين لربهم',
          description: 'معرفة الصراط الأدق من السيف والأحد من الشعرة، وأعظم نعيم الجنة برؤية وجه الله الكريم بلا حجاب.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_al6_1',
          title: 'النص الأصيل في رؤية المؤمنين لوجه الله الكريم',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {وُجُوهٌ يَوْمَئِذٍ نَّاضِرَةٌ * إِلَىٰ رَبِّهَا نَاظِرَةٌ}. وقال ﷺ: «إنكم سترون ربكم عياناً كما ترون هذا القمر لا تضامون في رؤيته» رواه البخاري ومسلم.',
          sourceAttribution: 'سورة القيامة: الآيتان 22-23، وصحيح البخاري ومسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_al6_2',
          title: 'الصراط ومستقر الأبرار والفجار',
          contentType: LearningContentType.explanation,
          content: 'الصراط جسر منصوب على متن جهنم يدحض عليه الخلائق، وهو أدق من الشعرة وأحد من السيف وعليه كلاليب تخطف الناس بأعمالهم؛ فمنهم من يمر كالبرق، ومنهم كالريح، ومنهم كأجاويد الخيل، ومنهم من يزحف ويسقط في النار. فإذا نجوا حُبسوا على قنطرة بين الجنة والنار ليقتص بعضهم من بعض حتى يهذبوا ويدخلوا الجنة طاهرين. والجنة والنار مخلوقتان الآن لا تفنيان أبداً بإجماع السلف، وأهل الجنة مخلدون فيها بنعيم مقيم وأعظمه رؤية الله بلا كيف.',
          sourceAttribution: 'العقيدة الواسطية لشيخ الإسلام ابن تيمية فصل اليوم الآخر',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Grave & Barzakh
    final q1 = QuizQuestion.create(
      questionId: 'q_al_grave_1',
      lessonId: 'lsn_aqidah_death_barzakh_grave',
      questionText: 'ما هي الأسئلة الثلاثة العظيمة التي يسألها الملكان (منكر ونكير) للميت في قبره؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qg1_1', text: 'من ربك؟ وما دينك؟ ومن نبيك؟'),
        QuizOption(optionId: 'opt_qg1_2', text: 'كم عمرك؟ وما عملك؟ وأين مالك؟'),
        QuizOption(optionId: 'opt_qg1_3', text: 'ما اسمك؟ وما قبيلتك؟ وما بلدك؟'),
      ],
      correctOptionIndices: const [0],
      explanation: 'هذه هي أصول الدين الثلاثة التي يُمتحن بها كل إنسان في قبره: معرفة ربه، ودينه بالإسلام، ونبيه محمد ﷺ.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_aqidah_grave_barzakh',
      lessonId: 'lsn_aqidah_death_barzakh_grave',
      title: 'اختبار عالم البرزخ وفتنة وسؤال القبر',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Hour Signs
    final q2 = QuizQuestion.create(
      questionId: 'q_al_hour_1',
      lessonId: 'lsn_aqidah_major_signs_hour',
      questionText: 'بماذا ينجو المؤمن من فتنة المسيح الدجال إذا أدركه كما أرشدنا النبي ﷺ؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qh1_1', text: 'بقوة التوحيد، وحفظ فواتح سورة الكهف، والتعوذ منه دبر كل صلاة، والفرار إلى الحرمين الشريفين'),
        QuizOption(optionId: 'opt_qh1_2', text: 'بمناظرته ومجادلته بالعقل المجرد'),
        QuizOption(optionId: 'opt_qh1_3', text: 'بالبقاء في بيته بلا أي ورد أو قراءة قرآن'),
      ],
      correctOptionIndices: const [0],
      explanation: 'النبي ﷺ وجّه أمته إلى الفرار من الدجال، وقراءة فواتح سورة الكهف، واللجوء لمكة والمدينة فإنهما محروستان بالملائكة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_aqidah_hour_signs',
      lessonId: 'lsn_aqidah_major_signs_hour',
      title: 'اختبار أشراط الساعة الكبرى والنجاة من الفتن',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Sirat & Paradise
    final q3 = QuizQuestion.create(
      questionId: 'q_al_paradise_1',
      lessonId: 'lsn_aqidah_sirat_paradise_hell',
      questionText: 'ما هو أعظم نعيم يتنعم به أهل الجنة في جنات الخلود على الإطلاق؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qp1_1', text: 'النظر إلى وجه الله الكريم عياناً بلا حجاب'),
        QuizOption(optionId: 'opt_qp1_2', text: 'أنهار الخمر واللبن والعسل'),
        QuizOption(optionId: 'opt_qp1_3', text: 'القصور والحلل الفاخرة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقوله تعالى: {لِّلَّذِينَ أَحْسَنُوا الْحُسْنَىٰ وَزِيَادَةٌ}، وقد فسر النبي ﷺ الزيادة بالنظر إلى وجه الله الكريم، فما أُعطوا شيئاً أحب إليهم منه.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_aqidah_paradise_sirat',
      lessonId: 'lsn_aqidah_sirat_paradise_hell',
      title: 'اختبار الصراط وأهوال الموقف ونعيم الجنة ورؤية الله',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
