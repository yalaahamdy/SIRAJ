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

/// بيانات مقرر تأصيل حقوق الإنسان والحريات العامة في الشريعة الإسلامية (6 دروس تأصيلية + اختباران استيعاب)
class LearningHumanRightsLibertiesData {
  static const String courseId = 'course_human_rights_liberties';
  static const String pathId = 'path_governance_judiciary_rights_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر تأصيل حقوق الإنسان والحريات العامة في الشريعة الإسلامية',
      description: 'دراسة تأصيلية فكرية وحقوقية لمنظومة حقوق الإنسان في الإسلام: الكرامة الإنسانية الكونية، حق الحياة والحرية والمساواة، حقوق المرأة والطفل والفئات الضعيفة، حماية الأقليات الدينية، ومقارنة الشريعة الإسلامية بالمواثيق الدولية المعاصرة.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_human_rights_dignity_liberties', 'mod_human_rights_vulnerable_comparison'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_human_rights_dignity_liberties',
        courseId: courseId,
        title: 'الوحدة الأولى: الكرامة الإنسانية الكونية وحقوق الأفراد الأساسية',
        description: 'بيان أصل الكرامة الإنسانية، الحق في الحياة وحرمة التعذيب، الحريات العامة كحرية الاعتقاد والتعبير الرشيد، وحق التملك واللجوء.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_human_rights_universal_dignity_nature',
          'lsn_human_rights_life_torture_prohibition',
          'lsn_human_rights_liberties_belief_expression',
        ],
      ),
      CourseModule(
        moduleId: 'mod_human_rights_vulnerable_comparison',
        courseId: courseId,
        title: 'الوحدة الثانية: حقوق الفئات الضعيفة والعدالة الاجتماعية والمقارنة الدولية',
        description: 'حقوق المرأة والطفل وأصحاب الهمم، حماية الأقليات الدينية والمدنية، وموازنة نقدية مقارنة بين الشريعة والإعلانات الدولية لحقوق الإنسان.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_human_rights_dignity_liberties'],
        lessonIds: const [
          'lsn_human_rights_women_children_disability',
          'lsn_human_rights_minorities_dhimmi_protection',
          'lsn_human_rights_cairo_universal_comparison',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: الكرامة الإنسانية الكونية وطبيعة الحق في الإسلام
    // -------------------------------------------------------------------------
    final evDignityQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_dignity_quran_isra',
      evidenceKey: '17:70',
      citation: 'سورة الإسراء: الآية 70 {وَلَقَدْ كَرَّمْنَا بَنِي آدَمَ وَحَمَلْنَاهُمْ فِي الْبَرِّ وَالْبَحْرِ وَرَزَقْنَاهُم مِّنَ الطَّيِّبَاتِ وَفَضَّلْنَاهُمْ عَلَىٰ كَثِيرٍ مِّمَّنْ خَلَقْنَا تَفْضِيلًا}',
      sourceId: 'src_quran_canonical',
    );
    final evAdamHadith = EvidenceLink.create(
      evidenceId: 'ev_rights_adam_hadith_tirmidhi',
      evidenceKey: 'tirmidhi:3270',
      citation: 'سنن الترمذي: «كُلُّكُمْ لِآدَمَ، وَآدَمُ مِنْ تُرَابٍ»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_human_rights_universal_dignity_nature',
      title: 'الكرامة الإنسانية الكونية وطبيعة الحق في الإسلام: الحق فريضة شرعية ملزمة',
      courseId: courseId,
      moduleId: 'mod_human_rights_dignity_liberties',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_rgt1_1',
          title: 'الكرامة الإنسانية منحة إلهية فطرية',
          description: 'استيعاب المبدأ القرآني في تكريم مطلق بني آدم بصرف النظر عن دينهم أو عرقهم أو جنسهم.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt1_2',
          title: 'طبيعة الحق في الإسلام (الحق كواجب إلهي)',
          description: 'إدراك أن الحقوق في الإسلام ليست مجرد مطالب قانونية تمنحها الدول، بل تكاليف وفرائض دينية يسأل عنها العبد أمام الله.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt1_3',
          title: 'أصل المساواة البشرية المطلقة',
          description: 'معرفة إلغاء التمايز الطبقي والعرقي والقبلي في ميزان الإسلام وقاعدة «كلكم لآدم وآدم من تراب».',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_rgt1_1',
          title: 'الكرامة الإنسانية المطلقة لجميع بني آدم',
          contentType: LearningContentType.sourceText,
          content: 'قرر القرآن الكريم أصل الكرامة الإنسانية بصفة كلية مطلقة تشمل الجنس البشري أجمع دون استثناء: ﴿وَلَقَدْ كَرَّمْنَا بَنِي آدَمَ﴾. فالكرامة في الإسلام سابقة على القوانين والمواثيق الوضعية؛ لأنها هبة من الخالق سبحانه مستمدة من نفخة الروح الإلهية، لا تملك سلطة ولا دولة سلبها أو إسقاطها عن أي إنسان.',
          evidenceLinks: [evDignityQuran, evAdamHadith],
          sourceAttribution: 'حقوق الإنسان في الإسلام للشيخ محمد الغزالي والزحيلي',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt1_2',
          title: 'طبيعة الحق في الشريعة: الحق كفريضة وواجب',
          contentType: LearningContentType.explanation,
          content: 'ينفرد المفهوم الإسلامي للحق بأنه يرتفع بحقوق الإنسان لتصبح "فرائض دينية وتكاليف واجبة" على المجتمع والدولة؛ فحق الحياة يقابله فريضة حفظ النفس، وحق الكفاية للفقير يقابله فريضة الزكاة، وحق التعلم يقابله فريضة طلب العلم؛ مما يمنح الحقوق قداسة ذاتية ووازعاً ضميرياً يمنع انتهاكها.',
          sourceAttribution: 'مقاصد الشريعة الإسلامية لابن عاشور',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt1_3',
          title: 'المساواة الإنسانية وإسقاط العنصرية',
          contentType: LearningContentType.explanation,
          content: 'حطم الإسلام كل أشكال التمييز العنصري والطبقي؛ وأعلن النبي ﷺ في خطبة الوداع الخالدة: «أيها الناس، إن ربكم واحد وإن أباكم واحد، كلكم لآدم وآدم من تراب، لا فضل لعربي على أعجمي ولا لأعجمي على عربي ولا لأحمر على أسود إلا بالتقوى»، فألغى امتيازات الأشراف وسوى بين بلال الحبشي وسلمان الفارسي وأبي ذر الغفاري.',
          sourceAttribution: 'سيرة ابن هشام ومسند أحمد',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: حق الحياة وسلامة الجسد وحرمة التعذيب في الفقه الإسلامي
    // -------------------------------------------------------------------------
    final evLifeQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_life_quran_maidah',
      evidenceKey: '5:32',
      citation: 'سورة المائدة: الآية 32 {مَن قَتَلَ نَفْسًا بِغَيْرِ نَفْسٍ أَوْ فَسَادٍ فِي الْأَرْضِ فَكَأَنَّمَا قَتَلَ النَّاسَ جَمِيعًا وَمَنْ أَحْيَاهَا فَكَأَنَّمَا أَحْيَا النَّاسَ جَمِيعًا}',
      sourceId: 'src_quran_canonical',
    );
    final evTortureHadith = EvidenceLink.create(
      evidenceId: 'ev_rights_torture_hadith_muslim',
      evidenceKey: 'muslim:2613',
      citation: 'صحيح مسلم: «إِنَّ اللَّهَ يُعَذِّبُ الَّذِينَ يُعَذِّبُونَ النَّاسَ فِي الدُّنْيَا»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_human_rights_life_torture_prohibition',
      title: 'حق الحياة، صيانة سلامة الجسد، والتحريم القطعي للتعذيب والامتهان في الإسلام',
      courseId: courseId,
      moduleId: 'mod_human_rights_dignity_liberties',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_rgt2_1',
          title: 'قداسة حق الحياة في القرآن',
          description: 'إدراك عظمة التشبيه القرآني بأن قتل نفس واحدة بغير حق كقتل الناس جميعاً وإحياءها كإحياء الناس جميعاً.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt2_2',
          title: 'التحريم القطعي للتعذيب والامتهان الجسدي',
          description: 'معرفة التحريم الصارم لتعذيب البشر أو امتهان أجسادهم واستخراج الاعترافات بالإكراه والوعيد الإلهي للمعذبين.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt2_3',
          title: 'صيانة حرمة المسكن والخصوصية الشخصية',
          description: 'استيعاب حرمة التجسس وتفتيش البيوت وانتهاك خصوصية الأفراد دون إذن قضائي صريح.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_rgt2_1',
          title: 'حق الحياة: أول المقاصد الضرورية وحرمة الدماء',
          contentType: LearningContentType.sourceText,
          content: 'الحياة في الإسلام حق مقدس منحه الله تعالى، ولا يجوز سلبها إلا بسلطان الشريعة وبحكم قضائي بات؛ وجعل القرآن الاعتداء على نفس واحدة عدواناً على الوجود البشري كله: ﴿أَنَّهُ مَن قَتَلَ نَفْسًا بِغَيْرِ نَفْسٍ أَوْ فَسَادٍ فِي الْأَرْضِ فَكَأَنَّمَا قَتَلَ النَّاسَ جَمِيعًا﴾. وحرم الإسلام الانتحار والإجهاض العمدي بعد نفخ الروح كحرمة قتل الغير تماماً.',
          evidenceLinks: [evLifeQuran, evTortureHadith],
          sourceAttribution: 'الموافقات للشاطبي والجامع لأحكام القرآن',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt2_2',
          title: 'التحريم الصارم للتعذيب والاعتداء على الجسد',
          contentType: LearningContentType.explanation,
          content: 'جاء الوعيد الإلهي القاطع في الحديث الصحيح: «إن الله يعذب الذين يعذبون الناس في الدنيا». وقد أجمع فقهاء الإسلام على بطلان أي اعتراف ينتزع بالضرب أو التهديد أو الحبس الانفرادي أو التعذيب النفسي، واعتبروا ذلك جريمة موجبة للمحاسبة والقصاص والتعويض؛ لأن الجسد البشري أمانة مصونة لا يجوز امتهانها.',
          sourceAttribution: 'تبصرة الحكام لابن فرحون والشرح الكبير',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt2_3',
          title: 'حرمة الخصوصية والمسكن ومنع التجسس',
          contentType: LearningContentType.explanation,
          content: 'صان الإسلام خصوصية الإنسان وحرم اقتحام البيوت دون استئذان ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا لَا تَدْخُلُوا بُيُوتًا غَيْرَ بُيُوتِكُمْ حَتَّىٰ تَسْتَأْنِسُوا﴾، ونهى عن التجسس نهياً باتاً ﴿وَلَا تَجَسَّسُوا﴾. وأسقط النبي ﷺ الدية عمن فقئت عينه وهو يسترق النظر إلى عورات بيت مسلم، تأكيداً لقداسة الحرمات والخصوصية الفردية.',
          sourceAttribution: 'الأحكام السلطانية والآداب الشرعية',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: الحريات العامة: حرية الاعتقاد والتعبير والتملك واللجوء
    // -------------------------------------------------------------------------
    final evNoCompulsionQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_ikrah_quran_baqarah',
      evidenceKey: '2:256',
      citation: 'سورة البقرة: الآية 256 {لَا إِكْرَاهَ فِي الدِّينِ ۖ قَد تَّبَيَّنَ الرُّشْدُ مِنَ الْغَيِّ}',
      sourceId: 'src_quran_canonical',
    );
    final evAsylumQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_asylum_quran_tawbah',
      evidenceKey: '9:6',
      citation: 'سورة التوبة: الآية 6 {وَإِنْ أَحَدٌ مِّنَ الْمُشْرِكِينَ اسْتَجَارَكَ فَأَجِرْهُ حَتَّىٰ يَسْمَعَ كَلَامَ اللَّهِ ثُمَّ أَبْلِغْهُ مَأْمَنَهُ}',
      sourceId: 'src_quran_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_human_rights_liberties_belief_expression',
      title: 'منظومة الحريات العامة: حرية الاعتقاد، التعبير الرشيد، حق التملك الخاص، وحق اللجوء',
      courseId: courseId,
      moduleId: 'mod_human_rights_dignity_liberties',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_rgt3_1',
          title: 'حرية الاعتقاد والضمير ونفي الإكراه',
          description: 'استيعاب الأصل القرآني القطعي ﴿لَا إِكْرَاهَ فِي الدِّينِ﴾ وبطلان إجبار أي شخص على اعتناق الإسلام.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt3_2',
          title: 'حرية التعبير والقول بالحق وضوابطها الأخلاقية',
          description: 'معرفة مشروعية حرية التعبير والنقد البناء والأمر بالمعروف وضوابط منع خطاب الكراهية والتشهير.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt3_3',
          title: 'حق التملك الخاص وحق اللجوء الإنساني',
          description: 'إدراك حماية الملكية الفردية المشروعة وسبق الإسلام في تقرير حق اللجوء السياسي والإنساني للأجانب.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_rgt3_1',
          title: 'حرية الاعتقاد ونفي الإكراه في الشريعة',
          contentType: LearningContentType.sourceText,
          content: 'أرسى القرآن مبدأ حرية الضمير والمعتقد بنص محكم: ﴿لَا إِكْرَاهَ فِي الدِّينِ ۖ قَد تَّبَيَّنَ الرُّشْدُ مِنَ الْغَيِّ﴾، وقال سبحانه: ﴿وَلَوْ شَاءَ رَبُّكَ لَآمَنَ مَن فِي الْأَرْضِ كُلُّهُمْ جَمِيعًا ۚ أَفَأَنتَ تُكْرِهُ النَّاسَ حَتَّىٰ يَكُونُوا مُؤْمِنِينَ﴾. والإيمان في جوهره تصديق قلبي واختيار حر، والإكراه يناقض حقيقة الإيمان ولا يولد إلا النفاق.',
          evidenceLinks: [evNoCompulsionQuran, evAsylumQuran],
          sourceAttribution: 'تفسير ابن كثير ومحاسن التأويل للقاسمي',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt3_2',
          title: 'حرية الرأي والتعبير الرشيد والنقد الهادف',
          contentType: LearningContentType.explanation,
          content: 'التعبير عن الرأي وإبداء النصيحة في الإسلام ليس مجرد حق، بل هو واجب شرعي وأفضل الجهاد لقوله ﷺ: «أفضل الجهاد كلمة عدل عند سلطان جائر». وضوابطه الأخلاقية تقتضي: الصدق، الموضوعية، عدم القذف والسب، عدم ترويج الشائعات الكاذبة، والابتعاد عن خطاب الكراهية وإثارة الفتن.',
          sourceAttribution: 'الحرية الدينية في الإسلام للدكتور عبد المتعال الصعيدي',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt3_3',
          title: 'حق التملك الخاص وحق اللجوء الإنساني',
          contentType: LearningContentType.explanation,
          content: 'يحمي الإسلام الملكية الخاصة للأفراد ويحرم مصادرتها أو فرض ضرائب جائرة عليها بغير حق. كما سبق الإسلام القانون الدولي في تقرير "حق اللجوء الإنساني والسياسي"؛ فأوجب على الدولة المسلمة إجارة كل من طلب الأمان وحمايته وإيصاله لمأمنه ﴿وَإِنْ أَحَدٌ مِّنَ الْمُشْرِكِينَ اسْتَجَارَكَ فَأَجِرْهُ ... ثُمَّ أَبْلِغْهُ مَأْمَنَهُ﴾.',
          sourceAttribution: 'حقوق الإنسان بين تعاليم الإسلام وإعلان الأمم المتحدة',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: حقوق المرأة والطفل وذوي الإعاقة (أصحاب الهمم) في الإسلام
    // -------------------------------------------------------------------------
    final evWomenRightsHadith = EvidenceLink.create(
      evidenceId: 'ev_rights_women_hadith_tirmidhi',
      evidenceKey: 'tirmidhi:1163',
      citation: 'سنن الترمذي: «أَلَا وَاسْتَوْصُوا بِالنِّسَاءِ خَيْرًا، فَإِنَّهُنَّ عَوَانٍ عِنْدَكُمْ»',
      sourceId: 'src_hadith_canonical',
    );
    final evChildRightsQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_children_quran_anam',
      evidenceKey: '6:151',
      citation: 'سورة الأنعام: الآية 151 {وَلَا تَقْتُلُوا أَوْلَادَكُم مِّنْ إِمْلَاقٍ ۖ نَّحْنُ نَرْزُقُكُمْ وَإِيَّاهُمْ}',
      sourceId: 'src_quran_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_human_rights_women_children_disability',
      title: 'حقوق الفئات الأولى بالرعاية: حقوق المرأة، كفالة وحماية الطفل، ورعاية ذوي الإعاقة (أصحاب الهمم)',
      courseId: courseId,
      moduleId: 'mod_human_rights_vulnerable_comparison',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_rgt4_1',
          title: 'الذمة المالية المستقلة والأهلية الكاملة للمرأة',
          description: 'إدراك تقرير الإسلام للأهلية القانونية والمالية الكاملة للمرأة وحقها في التملك والتعاقد دون وصاية.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt4_2',
          title: 'منظومة حقوق الطفل في الإسلام',
          description: 'معرفة حقوق الطفل من ثبوت النسب والرضاع والنفقة والتعليم والتربية وحظر العنف والإساءة ضده.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt4_3',
          title: 'حقوق ذوي الإعاقة وكبار السن في الهدي النبوي',
          description: 'استيعاب النموذج النبوي في تكريم ذوي الإعاقة (كابن أم مكتوم) وإدماجهم في القيادة والمجتمع وتوفير سبل تيسير حياتهم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_rgt4_1',
          title: 'تحرير المرأة والأهلية القانونية والمالية الكاملة',
          contentType: LearningContentType.sourceText,
          content: 'أعطى الإسلام المرأة شخصية قانونية وذمة مالية مستقلة تماماً عن أبيها وزوجها منذ 14 قرناً، في وقت كانت فيه القوانين الغربية تعتبر المرأة فاقدة الأهلية وتابعة للزوج حتى القرن العشرين. فللمرأة المسلمة كامل الحق في التملك، والبيع، والشراء، والوقف، والهبة، والتقاضي باسمها المستقل دون حاجة لإذن أحد.',
          evidenceLinks: [evWomenRightsHadith, evChildRightsQuran],
          sourceAttribution: 'تحرير المرأة في عصر الرسالة لعبد الحليم أبو شقة',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt4_2',
          title: 'حقوق الطفل: من قبل الولادة إلى سن الرشد',
          contentType: LearningContentType.explanation,
          content: 'تبدأ رعاية الطفل في الإسلام قبل ولادته بحسن اختيار الزوجين وتحريم الإجهاض، ثم بثبوت نسبه واسمه الحسن، وحقه في الرضاعة والحضانة والنفقة الواجبة، وحقه في التعليم واكتساب المهارات، وحمايته من الاستغلال وتشغيل الأطفال القسري وإهانة كرامته.',
          sourceAttribution: 'حقوق الأطفال في الشريعة الإسلامية ومقارنتها بالاتفاقيات الدولية',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt4_3',
          title: 'حقوق ذوي الإعاقة وأصحاب الهمم والمسنين',
          contentType: LearningContentType.explanation,
          content: 'ضرب النبي ﷺ أروع الأمثلة في إكرام ذوي الإعاقة وإدماجهم؛ فاستخلف عبد الله بن أم مكتوم وهو كفيف على المدينة المنورة يؤم الناس ويدير شؤون العاصمة ثلاث عشرة مرة، وولى عتاب بن أسيد وغيرهم. وأوجب الفقه توفير الرعاية الصحية الشاملة، وإزالة المشاق المعمارية والبيئية، وتخصيص مساعدات دائمة لهم من بيت المال.',
          sourceAttribution: 'رعاية المعوقين في الفقه الإسلامي والتاريخ',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: حقوق الأقليات غير المسلمة في المجتمع المسلم (وثيقة المدينة وتاريخ التسامح)
    // -------------------------------------------------------------------------
    final evMuahidHadith = EvidenceLink.create(
      evidenceId: 'ev_rights_muahid_hadith_bukhari',
      evidenceKey: 'bukhari:3166',
      citation: 'صحيح البخاري: «مَنْ قَتَلَ مُعَاهَدًا لَمْ يَرِحْ رَائِحَةَ الجَنَّةِ، وَإِنَّ رِيحَهَا تُوجَدُ مِنْ مَسِيرَةِ أَرْبَعِينَ عَامًا»',
      sourceId: 'src_hadith_canonical',
    );
    final evBirrQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_birr_quran_mumtahanah',
      evidenceKey: '60:8',
      citation: 'سورة الممتحنة: الآية 8 {أَن تَبَرُّوهُمْ وَتُقْسِطُوا إِلَيْهِمْ ۚ إِنَّ اللَّهَ يُحِبُّ الْمُقْسِطِينَ}',
      sourceId: 'src_quran_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_human_rights_minorities_dhimmi_protection',
      title: 'حقوق الأقليات غير المسلمة في المجتمع المسلم: وثيقة المدينة، المواطنة، وحماية الحريات الدينية والمدنية',
      courseId: courseId,
      moduleId: 'mod_human_rights_vulnerable_comparison',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_rgt5_1',
          title: 'وثيقة المدينة وأول دستور للمواطنة والتعايش',
          description: 'استيعاب عبقرية وثيقة المدينة النبوية في إقرار التعددية واعتبار المسلمين واليهود أمة مع المؤمنين في الحقوق المدنية والدفاع المشترك.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt5_2',
          title: 'حرمة الاعتداء على غير المسلمين المعاهدين',
          description: 'معرفة التحذير النبوي الشديد: «من قتل معاهداً لم يرح رائحة الجنة» وحرمة ظلمهم أو تكليفهم ما لا يطيقون.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt5_3',
          title: 'حرية ممارسة الشعائر واستقلال القضاء في الأحوال الشخصية',
          description: 'إدراك كفالة الشريعة لحرية عبادة غير المسلمين وصيانة كنائسهم وتركهم وما يدينون في أحوالهم الشخصية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_rgt5_1',
          title: 'وثيقة المدينة: أول دستور مواطنة وتعددية في التاريخ',
          contentType: LearningContentType.sourceText,
          content: 'أسس النبي ﷺ في وثيقة المدينة المنورة أول عقد سياسي مدني يساوي بين مواطني الدولة في الحقوق والواجبات؛ حيث نصت الوثيقة على أن: «يهود بني عوف أمة مع المؤمنين، لليهود دينهم وللمسلمين دينهم، مواليهم وأنفسهم، وأن بينهم النصح والنصيحة والبر دون الإثم، وأن بينهم النصر على من حارب أهل هذه الصحيفة».',
          evidenceLinks: [evMuahidHadith, evBirrQuran],
          sourceAttribution: 'سيرة ابن هشام ومجموعة الوثائق السياسية للعهد النبوي لمحمد حميد الله',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt5_2',
          title: 'حرمة دماء وأموال وأعراض غير المسلمين في الفقه',
          contentType: LearningContentType.explanation,
          content: 'قرر الفقهاء قاعدة ذهبية في حقوق غير المسلمين في المجتمع المسلم: «لهم ما لنا وعليهم ما علينا». ودماؤهم معصومة بالإجماع لقوله ﷺ: «من قتل معاهداً لم يرح رائحة الجنة»، وأموالهم محرمة كأموال المسلمين، وتضمن الدولة كفالتهم الاجتماعية عند العجز والشيخوخة؛ كما فعل عمر بن الخطاب مع الشيخ اليهودي حين أمر له براتب من بيت المال وقال: «ما أنصفناه إن أكلنا شبيبته ثم نخذله عند الهرم!».',
          sourceAttribution: 'الأموال لأبي عبيد والبداية والنهاية',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt5_3',
          title: 'الحرية الدينية واستقلال القضاء للأقليات',
          contentType: LearningContentType.explanation,
          content: 'كفل الإسلام للأقليات حرية إقامة شعائرهم وصيانة دور عبادتهم (الكنائس والأديرة والمعابد)؛ ومنع التدخل في عقائدهم أو إجبارهم على تغييرها. كما ترك لهم الشارع الحكيم الاستقلال في قضايا الأسرة والأحوال الشخصية والزواج والميراث والطعمة بحسب شريعتهم الخاصة دون فرض أحكام الإسلام عليهم في خصوصياتهم الدينية.',
          sourceAttribution: 'أحكام أهل الذمة لابن القيم وفتاوى القرافي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: موازنة مقارنة بين إعلان القاهرة لحقوق الإنسان في الإسلام والمواثيق الدولية
    // -------------------------------------------------------------------------
    final evUniversalJusticeQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_justice_quran_maidah',
      evidenceKey: '5:8',
      citation: 'سورة المائدة: الآية 8 {وَلَا يَجْرِمَنَّكُمْ شَنَآنُ قَوْمٍ عَلَىٰ أَلَّا تَعْدِلُوا ۚ اعْدِلُوا هُوَ أَقْرَبُ لِلتَّقْوَىٰ}',
      sourceId: 'src_quran_canonical',
    );
    final evTruthQuran = EvidenceLink.create(
      evidenceId: 'ev_rights_truth_quran_haqq',
      evidenceKey: '4:105',
      citation: 'سورة النساء: الآية 105 {إِنَّا أَنزَلْنَا إِلَيْكَ الْكِتَابَ بِالْحَقِّ لِتَحْكُمَ بَيْنَ النَّاسِ بِمَا أَرَاكَ اللَّهُ}',
      sourceId: 'src_quran_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_human_rights_cairo_universal_comparison',
      title: 'موازنة نقدية مقارنة بين إعلان القاهرة لحقوق الإنسان في الإسلام والمواثيق الدولية المعاصرة',
      courseId: courseId,
      moduleId: 'mod_human_rights_vulnerable_comparison',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_rgt6_1',
          title: 'أوجه الالتقاء بين الإسلام والمواثيق الدولية',
          description: 'معرفة مجالات التطابق والالتقاء في الحقوق الأساسية كحق الحياة والكرامة ومنع التعذيب والعدالة القضائية.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt6_2',
          title: 'أوجه التمايز والخصوصية في المنظور الإسلامي',
          description: 'فهم التمايز الأخلاقي والقيمي في الإسلام بربط الحقوق بالمسؤوليات والأسرة الفطرية ومنع الشذوذ والانحلال.',
        ),
        LearningObjective(
          objectiveId: 'obj_rgt6_3',
          title: 'معالم إعلان القاهرة لحقوق الإنسان في الإسلام (1990)',
          description: 'استيعاب محاور إعلان القاهرة لمنظمة التعاون الإسلامي كصيغة حقوقية تأصيلية معاصرة تجمع بين الأصالة والعصر.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_rgt6_1',
          title: 'نقاط الالتقاء الجوهرية مع الإعلان العالمي لحقوق الإنسان',
          contentType: LearningContentType.sourceText,
          content: 'تلتقي الشريعة الإسلامية مع المواثيق الدولية المعاصرة (كالإعلان العالمي لحقوق الإنسان 1948 والعهدين الدوليين) في كبريات المبادئ الإنسانية: تجريم التمييز العنصري، حق الحياة والأمن الشخصي، حرية التنقل، كفالة المحاكمة العادلة، حظر الرق والتعذيب، وحق التملك والعمل، وهي مقاصد أصيلة دعت إليها الشريعة قبل ظهور هذه المواثيق بقرون.',
          evidenceLinks: [evUniversalJusticeQuran, evTruthQuran],
          sourceAttribution: 'حقوق الإنسان بين الشريعة الإسلامية والقانون الدولي المقارن',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt6_2',
          title: 'التمايز القيمي والخصوصية الأخلاقية في الإسلام',
          contentType: LearningContentType.explanation,
          content: 'تتميز الرؤية الإسلامية بـ: 1- المصدرية الإلهية للحقوق التي تعصمها من أهواء الأغلبيات السياسية المتغيرة. 2- التلازم التام بين الحق والواجب، والحرية والمسؤولية الأخلاقية. 3- رفض الحريات المنفلتة التي تهدم الأسرة الفطرية (كإباحة الشذوذ والإجهاض العشوائي والزنا الرضائي والاتجار بالجنس) التي تسللت لبعض التفسيرات الغربية المتطرفة.',
          sourceAttribution: 'إشكالية العالمية والخصوصية في حقوق الإنسان',
        ),
        LessonSection.create(
          sectionId: 'sec_rgt6_3',
          title: 'إعلان القاهرة لحقوق الإنسان في الإسلام لعام 1990',
          contentType: LearningContentType.explanation,
          content: 'يمثل إعلان القاهرة الصادر عن وزراء خارجية منظمة التعاون الإسلامي (57 دولة) وثيقة حقوقية مرجعية راقية تتكون من 25 مادة؛ تؤكد كرامة الإنسان، قداسة الحياة، حرمة الأسرة ورعايتها، حرية التعبير بالحق، وضمانات المحاكمة العادلة، منضبطة بمرجعية الشريعة ومقاصدها الإنسانية العليا.',
          sourceAttribution: 'وثيقة إعلان القاهرة لحقوق الإنسان في الإسلام 1990',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: الكرامة والحريات العامة
    final q1 = QuizQuestion.create(
      questionId: 'q_rgt_1',
      lessonId: 'lsn_human_rights_universal_dignity_nature',
      questionText: 'ما هي الطبيعة الفريدة لـ "الحق" في المفهوم الإسلامي مقارنة بالفلسفات الوضعية؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qr1_1', text: 'الحق في الإسلام فريضة دينية وتكليف إلهي ملزم ومحاسب عليه أمام الله، وليس مجرد منحة من حاكم أو برلمان'),
        QuizOption(optionId: 'opt_qr1_2', text: 'الحق مجرد رغبة شخصية غير ملزمة يجوز للمجتمع إسقاطها متى شاء'),
        QuizOption(optionId: 'opt_qr1_3', text: 'الحقوق تثبت فقط للأثرياء وأصحاب النفوذ السياسي'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يرفع الإسلام الحقوق لتكون فرائض وتكاليف شرعية، مما يضفي عليها قداسة وحصانة إيمانية تحميها من عسف الحكام والأغلبيات.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_human_rights_dignity_liberties',
      lessonId: 'lsn_human_rights_universal_dignity_nature',
      title: 'اختبار الكرامة الإنسانية وحق الحياة والحريات العامة',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: حقوق الأقليات والمقارنة الدولية
    final q2 = QuizQuestion.create(
      questionId: 'q_rgt_2',
      lessonId: 'lsn_human_rights_minorities_dhimmi_protection',
      questionText: 'ماذا تضمنت وثيقة المدينة النبوية الشريفة بشأن علاقة المسلمين واليهود وسكان يثرب؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qr2_1', text: 'اعتبار يهود بني عوف أمة مع المؤمنين، لليهود دينهم وللمسلمين دينهم، والتعاون المشترك في حماية المدينة'),
        QuizOption(optionId: 'opt_qr2_2', text: 'إجبار جميع سكان المدينة على اعتناق الإسلام قهراً وفوراً'),
        QuizOption(optionId: 'opt_qr2_3', text: 'مصادرة أموال غير المسلمين وطردهم خارج المدينة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أقرت وثيقة المدينة النبوية التعددية الدينية والحرية الاعتقادية والمواطنة المشتركة والتعايش السلمي كأول دستور مدني في التاريخ.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_human_rights_vulnerable_comparison',
      lessonId: 'lsn_human_rights_minorities_dhimmi_protection',
      title: 'اختبار حقوق الفئات الضعيفة والأقليات ومقارنة الشريعة بالمواثيق الدولية',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
