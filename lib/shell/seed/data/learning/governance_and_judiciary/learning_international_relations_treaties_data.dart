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

/// بيانات مقرر فقه العلاقات الدولية والمعاهدات والسلم والنزاعات (6 دروس تأصيلية + اختباران استيعاب)
class LearningInternationalRelationsTreatiesData {
  static const String courseId = 'course_international_relations_treaties';
  static const String pathId = 'path_governance_judiciary_rights_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه العلاقات الدولية والمعاهدات والسلم وحماية المدنيين',
      description: 'دراسة تأصيلية فقهية لأصول العلاقات الدولية في الإسلام: الأصل في العلاقات الإنسانية هو السلم والتعارف، قداسة الوفاء بالمعاهدات والمواثيق، الدبلوماسية وسفارات السلام، القانون الدولي الإنساني في الإسلام، وحماية المدنيين وأسرى الحرب والإغاثة.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_international_relations_treaties', 'mod_international_humanitarian_law'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_international_relations_treaties',
        courseId: courseId,
        title: 'الوحدة الأولى: أصول العلاقات الدولية والعهود والمواثيق في الإسلام',
        description: 'بيان الأصل في العلاقات الإنسانية، تقسيم الدور في الفقه التاريخي والواقع المعاصر، قداسة المعاهدات وحرمة الغدر، والدبلوماسية والحصانة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_international_peace_origin_abodes',
          'lsn_international_covenants_treaties_fidelity',
          'lsn_international_diplomacy_embassies_immunity',
        ],
      ),
      CourseModule(
        moduleId: 'mod_international_humanitarian_law',
        courseId: courseId,
        title: 'الوحدة الثانية: أحكام النزاعات المسلحة وحماية المدنيين والعمل الإنساني',
        description: 'ضوابط مشروعية القتال لرد العدوان، القانون الدولي الإنساني النبوي في حماية غير المقاتلين والبيئة، وأحكام أسرى الحرب والإغاثة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_international_relations_treaties'],
        lessonIds: const [
          'lsn_international_defense_legitimacy_limits',
          'lsn_international_humanitarian_rules_civilians',
          'lsn_international_prisoners_relief_humanitarian',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: الأصل في العلاقات الدولية وتقسيم الدور في الفقه التاريخي والمعاصر
    // -------------------------------------------------------------------------
    final evPeaceQuran = EvidenceLink.create(
      evidenceId: 'ev_intl_peace_quran_baqarah',
      evidenceKey: '2:208',
      citation: 'سورة البقرة: الآية 208 {يَا أَيُّهَا الَّذِينَ آمَنُوا ادْخُلُوا فِي السِّلْمِ كَافَّةً}',
      sourceId: 'src_quran_canonical',
    );
    final evTaarufQuran = EvidenceLink.create(
      evidenceId: 'ev_intl_taaruf_quran_hujurat',
      evidenceKey: '49:13',
      citation: 'سورة الحجرات: الآية 13 {وَجَعَلْنَاكُمْ شُعُوبًا وَقَبَائِلَ لِتَعَارَفُوا ۚ إِنَّ أَكْرَمَكُمْ عِندَ اللَّهِ أَتْقَاكُمْ}',
      sourceId: 'src_quran_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_international_peace_origin_abodes',
      title: 'أصول العلاقات الدولية في الإسلام: السلم والتعارف، وتأصيل مفهوم الدور في الفقه',
      courseId: courseId,
      moduleId: 'mod_international_relations_treaties',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_intl1_1',
          title: 'الأصل في العلاقات الدولية هو السلم',
          description: 'استيعاب المبدأ الفقهي الأصيل بأن السلم والتعارف والتعاون الإنساني هو الأصل الحاكم للعلاقات الدولية.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl1_2',
          title: 'فهم تقسيم الدور التاريخي (دار الإسلام ودار العهد)',
          description: 'فهم السياق التاريخي والواقعي لتقسيم الفقهاء للدور وأنه اجتهاد ظرفي متغير وليس حكماً عقدياً أبدياً.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl1_3',
          title: 'التكييف الفقهي المعاصر للمواثيق الدولية والأمم المتحدة',
          description: 'معرفة التكييف الفقهي للعهود الدولية المعاصرة وأن العالم اليوم تحكمه عهود ومواثيق دولية ملزمة (دار عهد).',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_intl1_1',
          title: 'السلم والتعارف أساس النظام الدولي الإسلامي',
          contentType: LearningContentType.sourceText,
          content: 'أرسى الإسلام قاعدة العلاقات الدولية على مبدأ السلم والتعارف الإنساني الشامل؛ فالله عز وجل يدعو المؤمنين للدخول في السلم كافة ﴿ادْخُلُوا فِي السِّلْمِ كَافَّةً﴾، وجعل التنوع البشري آية للتكامل والتعارف لا للتصادم والدمار ﴿وَجَعَلْنَاكُمْ شُعُوبًا وَقَبَائِلَ لِتَعَارَفُوا﴾. والعدوان هو الاستثناء المحرم شرعاً.',
          evidenceLinks: [evPeaceQuran, evTaarufQuran],
          sourceAttribution: 'السير الكبير للشيباني وشرح السرخسي',
        ),
        LessonSection.create(
          sectionId: 'sec_intl1_2',
          title: 'التأصيل التاريخي لمفهوم "الدور" في الفقه الإسلامي',
          contentType: LearningContentType.explanation,
          content: 'قسم الفقهاء قديماً العالم بحسب واقعهم الأمني إلى: دار الإسلام (ما تجري عليه أحكام المسلمين ويأمن فيه المسلم)، ودار الحرب (من ناصب المسلمين العداء والحرب)، ودار العهد أو الصلح (من بيننا وبينهم مواثيق ومهادنة). وهذا التقسيم تقسيم فقهي اجتهادي استقرائي فرضته طبيعة الصراعات في القرون الأولى، ولم يرد بنص قرآني ولا نبوي لازم.',
          sourceAttribution: 'أحكام أهل الذمة لابن القيم والمجموع للنووي',
        ),
        LessonSection.create(
          sectionId: 'sec_intl1_3',
          title: 'الواقع الدولي المعاصر ومفهوم "دار العهد العالمية"',
          contentType: LearningContentType.explanation,
          content: 'بانضمام الدول الإسلامية إلى منظومة الأمم المتحدة وتوقيع المعاهدات الدولية المتبادلة، أضحى العالم اليوم في المنظور الفقهي المعاصر بمثابة "دار عهد ومواثيق دولية"؛ تحرم فيها دماء غير المسلمين المعاهدين وأموالهم وأعراضهم في كل مكان تنفيذاً للمواثيق الشرعية المعتمدة.',
          sourceAttribution: 'فقه العلاقات الدولية للدكتور وهبة الزحيلي ومجمع الفقه الإسلامي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: الوفاء بالعهود والمواثيق الدولية في الإسلام وحرمة الغدر
    // -------------------------------------------------------------------------
    final evCovenantQuran1 = EvidenceLink.create(
      evidenceId: 'ev_intl_covenant_quran_isra',
      evidenceKey: '17:34',
      citation: 'سورة الإسراء: الآية 34 {وَأَوْفُوا بِالْعَهْدِ ۖ إِنَّ الْعَهْدَ كَانَ مَسْئُولًا}',
      sourceId: 'src_quran_canonical',
    );
    final evTreacityHadith = EvidenceLink.create(
      evidenceId: 'ev_intl_ghadr_hadith_bukhari',
      evidenceKey: 'bukhari:3188',
      citation: 'صحيح البخاري: «لِكُلِّ غَادِرٍ لِوَاءٌ يَوْمَ القِيَامَةِ، يُقَالُ: هَذِهِ غَدْرَةُ فُلَانٍ»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_international_covenants_treaties_fidelity',
      title: 'الوفاء بالعهود والمواثيق الدولية في الإسلام وحرمة الغدر والخيانة مع غير المسلمين',
      courseId: courseId,
      moduleId: 'mod_international_relations_treaties',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_intl2_1',
          title: 'قداسة العهد في الشريعة الإسلامية',
          description: 'إدراك أن الوفاء بالعهود فريضة دينية قطعية لا تقبل الإخلال حتى مع الأعداء.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl2_2',
          title: 'حرمة الغدر والخيانة الدولية',
          description: 'معرفة التحذير النبوي الشديد من الغدر ونصب لواء الفضيحة لكل غادر يوم القيامة.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl2_3',
          title: 'النموذج النبوي في صلح الحديبية وموقف أبي جندل',
          description: 'استلهام دقة الوفاء النبوي ببنود صلح الحديبية حتى في أشد المواقف حرجاً.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_intl2_1',
          title: 'قداسة العهود والمواثيق في القرآن الكريم',
          contentType: LearningContentType.sourceText,
          content: 'عظّم القرآن شأن العهود والمواثيق الدولية حتى جعل الوفاء بها مقدماً على نصرة المسلمين المستضعفين في بلاد المعاهدين؛ فقال تعالى: ﴿وَإِنِ اسْتَنصَرُوكُمْ فِي الدِّينِ فَعَلَيْكُمُ النَّصْرُ إِلَّا عَلَىٰ قَوْمٍ بَيْنَكُمْ وَبَيْنَهُم مِّيثَاقٌ﴾؛ وهو قمة السمو الأخلاقي في احترام المواثيق وعدم نقضها تحت أي ذريعة عاطفية.',
          evidenceLinks: [evCovenantQuran1, evTreacityHadith],
          sourceAttribution: 'أحكام القرآن للجصاص وتفسير القرطبي',
        ),
        LessonSection.create(
          sectionId: 'sec_intl2_2',
          title: 'تجريم الغدر والخيانة في العلاقات الدولية',
          contentType: LearningContentType.explanation,
          content: 'حرم الإسلام الغدر تحريماً قاطعاً واعتبره من خصال النفاق الكبرى؛ فقال ﷺ: «أربع من كن فيه كان منافقاً خالصاً... وإذا عاهد غدر»، وقال ﷺ: «لكل غادر لواء عند استه يوم القيامة يرفع له بقدر غدره، ألا ولا غادر أعظم غدراً من أمير عامة». فلا يجوز للدولة الإسلامية نقض عهد مبرم ولا مفاجأة الطرف الآخر بعدوان دون إعلام رسمي بانتهاء العهد.',
          sourceAttribution: 'صحيح مسلم وشرح النووي',
        ),
        LessonSection.create(
          sectionId: 'sec_intl2_3',
          title: 'النموذج التطبيقي المعجز في صلح الحديبية',
          contentType: LearningContentType.explanation,
          content: 'ضرب النبي ﷺ أروع الأمثلة في الانضباط بالعهود حين رد أبا جندل رضي الله عنه إلى قريش التزاماً ببنود صلح الحديبية قائلاً له: «يا أبا جندل اصبر واحتسب، فإن الله جاعل لك ولمن معك من المستضعفين فرجاً ومخرجاً، إنا قد عقدنا بيننا وبين القوم صلحاً وأعطيناهم على ذلك وأعطونا عهد الله، وإنا لا نغدر».',
          sourceAttribution: 'زاد المعاد في هدي خير العباد لابن القيم',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: الدبلوماسية وسفارات السلام والحصانة الدبلوماسية في الإسلام
    // -------------------------------------------------------------------------
    final evEnvoysHadith = EvidenceLink.create(
      evidenceId: 'ev_intl_envoys_hadith_abudawood',
      evidenceKey: 'abudawood:2761',
      citation: 'سنن أبي داود: «إِنِّي لَا أَخِيسُ بِالعَهْدِ، وَلَا أَحْبِسُ البُرُدَ (الرُّسُلَ وَالسُّفَرَاءَ)»',
      sourceId: 'src_hadith_canonical',
    );
    final evMusaylimahHadith = EvidenceLink.create(
      evidenceId: 'ev_intl_musaylimah_envoys_hadith',
      evidenceKey: 'ahmad:3811',
      citation: 'مسند أحمد: «أَمَا وَاللَّهِ لَوْلَا أَنَّ الرُّسُلَ لَا تُقْتَلُ لَضَرَبْتُ أَعْنَاقَكُمَا»',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_international_diplomacy_embassies_immunity',
      title: 'الدبلوماسية وسفارات السلام والحصانة الدبلوماسية في الهدي النبوي وتاريخ الإسلام',
      courseId: courseId,
      moduleId: 'mod_international_relations_treaties',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_intl3_1',
          title: 'تأصيل الحصانة الدبلوماسية في السنة النبوية',
          description: 'إدراك القاعدة النبوية الخالدة المقررة لحصانة الرسل والسفراء وعدم جواز التعرض لهم أو قتلهم.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl3_2',
          title: 'سفارات النبي ﷺ ورسائله لملوك العالم',
          description: 'دراسة الدبلوماسية النبوية وسفارات السلام التي أرسلها المصطفى ﷺ لكسرى وقيصر والمقوقس والنجاشي.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl3_3',
          title: 'عقد الأمان والتأشيرات الدبلوماسية المعاصرة',
          description: 'التكييف الفقهي لعقد الأمان وتأشيرات الدخول الدبلوماسية والسياحية وحرمة المساس بضيوف الدولة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_intl3_1',
          title: 'القاعدة النبوية العظمى في الحصانة الدبلوماسية',
          contentType: LearningContentType.sourceText,
          content: 'سبق الإسلام المواثيق الدولية بقرون في تقرير الحصانة التامة للمبعوثين الدبلوماسيين؛ فعندما قدم رسولا مسيلمة الكذاب إلى المدينة وأعلنا كفرهما بين يدي رسول الله ﷺ، قال لهما: «أما والله لولا أن الرسل لا تقتل لضربت أعناقكما»، فأرسى قاعدة دولية قطعية تحرم المساس بحياة السفراء والرسل أو احتجازهم حتى لو كانوا رسل أعداء معلنين.',
          evidenceLinks: [evEnvoysHadith, evMusaylimahHadith],
          sourceAttribution: 'السير للشيباني وتاريخ الطبري',
        ),
        LessonSection.create(
          sectionId: 'sec_intl3_2',
          title: 'البعثات الدبلوماسية النبوية واختيار السفراء',
          contentType: LearningContentType.explanation,
          content: 'اختار النبي ﷺ سفراءه للملوك بعناية فائقة راعت الفصاحة، والكياسة، والوسامة، والقدرة على التفاوض والإقناع؛ فأرسل دحية الكلبي إلى قيصر، وعبد الله بن حذافة السهمي إلى كسرى، وحاطب بن أبي بلتعة إلى المقوقس، وعمرو بن أمية الضمري إلى النجاشي، مما أسس لأول مدرسة دبلوماسية راقية في تاريخ الإسلام.',
          sourceAttribution: 'زاد المعاد والطبقات الكبرى لابن سعد',
        ),
        LessonSection.create(
          sectionId: 'sec_intl3_3',
          title: 'عقد الأمان وتكييف تأشيرات الدخول المعاصرة',
          contentType: LearningContentType.explanation,
          content: 'عقد الأمان في الفقه هو إعطاء الحماية والأمن لغير المسلم للدخول إلى بلاد المسلمين؛ وتأشيرة الدخول الرسمية الصادرة اليوم من سفارات الدول المسلمة هي عقد أمان شرعي ملزم يحرم بموجبه الاعتداء على المستأمن في نفسه أو ماله أو عرضه طيلة إقامته لقوله ﷺ: «ألا من ظلم معاهداً أو انتقصه أو كلفه فوق طاقته أو أخذ منه شيئاً بغير طيب نفس فأنا حجيجه يوم القيامة».',
          sourceAttribution: 'فقه الجهاد للدكتور يوسف القرضاوي والمهذب للشيرازي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: ضوابط مشروعية القتال لرد العدوان وحماية المستضعفين
    // -------------------------------------------------------------------------
    final evDefenseQuran1 = EvidenceLink.create(
      evidenceId: 'ev_intl_defense_quran_hajj',
      evidenceKey: '22:39',
      citation: 'سورة الحج: الآية 39 {أُذِنَ لِلَّذِينَ يُقَاتَلُونَ بِأَنَّهُمْ ظُلِمُوا ۚ وَإِنَّ اللَّهَ عَلَىٰ نَصْرِهِمْ لَقَدِيرٌ}',
      sourceId: 'src_quran_canonical',
    );
    final evDefenseQuran2 = EvidenceLink.create(
      evidenceId: 'ev_intl_defense_quran_baqarah',
      evidenceKey: '2:190',
      citation: 'سورة البقرة: الآية 190 {وَقَاتِلُوا فِي سَبِيلِ اللَّهِ الَّذِينَ يُقَاتِلُونَكُمْ وَلَا تَعْتَدُوا ۚ إِنَّ اللَّهَ لَا يُحِبُّ الْمُعْتَدِينَ}',
      sourceId: 'src_quran_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_international_defense_legitimacy_limits',
      title: 'ضوابط مشروعية النزاع المسلح في الإسلام: رد العدوان، حماية المستضعفين، ومنع الفتنة',
      courseId: courseId,
      moduleId: 'mod_international_humanitarian_law',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_intl4_1',
          title: 'علة مشروعية القتال في الإسلام',
          description: 'استيعاب أن علة القتال في الإسلام هي دفع العدوان والظلم وحماية حرية الدعوة وليست إجبار الناس على الدين.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl4_2',
          title: 'قاعدة «ولا تعتدوا إن الله لا يحب المعتدين»',
          description: 'معرفة التحريم الصارم للاعتداء والبغي في الحروب والتزام التناسب والضرورة العسكرية.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl4_3',
          title: 'حصر قرار الحرب في السلطة الشرعية للدولة',
          description: 'إدراك أن إعلان الحرب والجهاد موكول لولي الأمر والدولة الشرعية منعاً للفوضى والمليشيات العشوائية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_intl4_1',
          title: 'علة القتال: دفع الظلم وحماية المستضعفين',
          contentType: LearningContentType.sourceText,
          content: 'لم يشرع القتال في الإسلام لإكراه الناس على الدخول في الدين؛ لأن القرآن أعلن بوضوح قاطع: ﴿لَا إِكْرَاهَ فِي الدِّينِ﴾، و﴿أَفَأَنتَ تُكْرِهُ النَّاسَ حَتَّىٰ يَكُونُوا مُؤْمِنِينَ﴾. وإنما شرع القتال لعلتين عادلتين: الأولى رد العدوان المسلح ﴿أُذِنَ لِلَّذِينَ يُقَاتَلُونَ بِأَنَّهُمْ ظُلِمُوا﴾، والثانية نصرة المستضعفين من الرجال والنساء والولدان الذين يضطهدهم الظالمون.',
          evidenceLinks: [evDefenseQuran1, evDefenseQuran2],
          sourceAttribution: 'قواعد ابن رجب الحنبلي وتفسير المنار للشيخ رشيد رضا',
        ),
        LessonSection.create(
          sectionId: 'sec_intl4_2',
          title: 'تحريم الاعتداء والالتزام بالتناسب',
          contentType: LearningContentType.explanation,
          content: 'أمر الله عز وجل بالعدل حتى في أشد لحظات القتال فقال: ﴿وَقَاتِلُوا فِي سَبِيلِ اللَّهِ الَّذِينَ يُقَاتِلُونَكُمْ وَلَا تَعْتَدُوا ۚ إِنَّ اللَّهَ لَا يُحِبُّ الْمُعْتَدِينَ﴾. ويشمل الاعتداء المنهي عنه: مقاتلة غير المقاتلين، استخدام أسلحة الدمار الشامل العشوائي، والتمثيل بالجثث، والغدر، وتدمير المرافق الحيوية دون ضرورة حربية قاهرة.',
          sourceAttribution: 'إحكام الفصول في أحكام الأصول للباجي',
        ),
        LessonSection.create(
          sectionId: 'sec_intl4_3',
          title: 'حصر قرار الحرب في السلطة العامة المعتمدة',
          contentType: LearningContentType.explanation,
          content: 'أجمع فقهاء الأمة على أن إعلان الحرب والسلم وقرار النزاع المسلح شأن سيادي حصري لرأس الدولة وولي الأمر الشرعي ومؤسساتها الدستورية، ولا يجوز للأفراد ولا الجماعات والمليشيات إعلان الحرب أو القيام بعمليات عسكرية تنتهك عهود الدولة وتجر الويلات والفتن على الأمة.',
          sourceAttribution: 'المغني لابن قدامة ونهاية المحتاج للرملي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: القانون الدولي الإنساني في الإسلام ووصايا الصحابة بحماية المدنيين والبيئة
    // -------------------------------------------------------------------------
    final evPropheticCommandHadith = EvidenceLink.create(
      evidenceId: 'ev_intl_prophetic_command_hadith',
      evidenceKey: 'muslim:1731',
      citation: 'صحيح مسلم: «اغْزُوا وَلَا تَغُلُّوا، وَلَا تَغْدِرُوا، وَلَا تَمْثُلُوا، وَلَا تَقْتُلُوا وَلِيدًا...»',
      sourceId: 'src_hadith_canonical',
    );
    final evAbuBakrCommandsHadith = EvidenceLink.create(
      evidenceId: 'ev_intl_abu_bakr_ten_commands',
      evidenceKey: 'muwatta:malik:965',
      citation: 'موطأ مالك (وصايا الصديق لجيش أسامة): «لَا تَقْتُلُوا امْرَأَةً، وَلَا صَبِيًّا، وَلَا كَبِيرًا هَرِمًا، وَلَا تَقْطَعُوا شَجَرًا مُثْمِرًا...»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_international_humanitarian_rules_civilians',
      title: 'القانون الدولي الإنساني في الإسلام: وصايا النبي ﷺ وأبي بكر بحماية المدنيين والأعيان المدنية والبيئة',
      courseId: courseId,
      moduleId: 'mod_international_humanitarian_law',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_intl5_1',
          title: 'السبق الإسلامي للقانون الدولي الإنساني واتفاقيات جنيف',
          description: 'إدراك أسبقية الإسلام بـ 14 قرناً على اتفاقيات جنيف في تحييد المدنيين وتجريم استهدافهم.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl5_2',
          title: 'وصايا أبي بكر الصديق العشر',
          description: 'حفظ وفهم الوصايا العشر العسكرية لأبي بكر الصديق في حماية النساء والأطفال والشيوخ والرهبان والأشجار والمواشي.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl5_3',
          title: 'حظر التخريب البيئي والنهي الصارم عن المثلة والتعذيب',
          description: 'معرفة التحريم القطعي للتمثيل بجثث القتلى وتسميم الآبار وحرق الممتلكات والاعتداء على دور العبادة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_intl5_1',
          title: 'الوصايا النبوية الدائمة لقادة الجيوش والسرايا',
          contentType: LearningContentType.sourceText,
          content: 'كان النبي ﷺ إذا أمر أميراً على جيش أو سرية أوصاه بتقوى الله وبمن معه خيراً وقال: «اغزوا في سبيل الله، قاتلوا من كفر بالله، اغزوا ولا تغلوا، ولا تغدروا، ولا تمثلوا، ولا تقتلوا وليداً». ولما رأى النبي ﷺ امرأة مقتولة في إحدى الغزوات أنكر ذلك بشدة وقال: «ما كانت هذه لتقاتل!»، ونهى عن قتل النساء والصبيان.',
          evidenceLinks: [evPropheticCommandHadith, evAbuBakrCommandsHadith],
          sourceAttribution: 'صحيح مسلم وسنن أبي داود',
        ),
        LessonSection.create(
          sectionId: 'sec_intl5_2',
          title: 'وثيقة أبي بكر الصديق: أعظم ميثاق إنساني عسكري في التاريخ',
          contentType: LearningContentType.explanation,
          content: 'ودّع أبو بكر الصديق رضي الله عنه جيش الشام بالوصايا العشر الخالدة: «إني موصيكم بعشر: لا تقتلوا امرأة، ولا صبياً، ولا كبيراً هرماً، ولا تقطعوا شجراً مثمراً، ولا تخربوا عامراً، ولا تعقروا شاة ولا بعيراً إلا لمأكلة، ولا تحرقوا نخلاً ولا تغرقوه، ولا تغلل، ولا تجبن، وستمرون بأقوام فرغوا أنفسهم في الصوامع فدعوهم وما فرغوا أنفسهم له».',
          sourceAttribution: 'الموطأ للإمام مالك وتاريخ الطبري',
        ),
        LessonSection.create(
          sectionId: 'sec_intl5_3',
          title: 'حماية دور العبادة والأعيان المدنية وتجريم الإبادة',
          contentType: LearningContentType.explanation,
          content: 'يقرر الفقه الإسلامي الحرمة المطلقة لاستهداف الكنائس والبيع والصوامع والمستشفيات والمساكن؛ وتحريم تلويث مصادر المياه والبيئة. ويجرم الإسلام الإبادة الجماعية والعقوبات الجماعية والتهجير القسري؛ لأن المسؤولية الجنائية في الإسلام شخصية بحتة ﴿وَلَا تَزِرُ وَازِرَةٌ وِزْرَ أُخْرَىٰ﴾.',
          sourceAttribution: 'بداية المجتهد والسير الكبير للشيباني',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: أحكام أسرى الحرب والإغاثة الإنسانية وتبادل المحتجزين
    // -------------------------------------------------------------------------
    final evPrisonersQuran = EvidenceLink.create(
      evidenceId: 'ev_intl_prisoners_quran_insan',
      evidenceKey: '76:8',
      citation: 'سورة الإنسان: الآية 8 {وَيُطْعِمُونَ الطَّعَامَ عَلَىٰ حُبِّهِ مِسْكِينًا وَيَتِيمًا وَأَسِيرًا}',
      sourceId: 'src_quran_canonical',
    );
    final evFidaQuran = EvidenceLink.create(
      evidenceId: 'ev_intl_fida_quran_muhammad',
      evidenceKey: '47:4',
      citation: 'سورة محمد: الآية 4 {فَإِمَّا مَنًّا بَعْدُ وَإِمَّا فِدَاءً حَتَّىٰ تَضَعَ الْحَرْبُ أَوْزَارَهَا}',
      sourceId: 'src_quran_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_international_prisoners_relief_humanitarian',
      title: 'أحكام أسرى الحرب، تبادل المحتجزين، وفقه الإغاثة والمساعدات الإنسانية وقت الأزمات',
      courseId: courseId,
      moduleId: 'mod_international_humanitarian_law',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_intl6_1',
          title: 'التعامل الإنساني الكريم مع أسرى الحرب',
          description: 'إدراك المبدأ القرآني في إطعام وإكرام الأسير وحرمة تعذيبه أو إذلاله أو امتهان كرامته.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl6_2',
          title: 'خيارات التعامل مع الأسرى: المن والفداء والتبادل',
          description: 'معرفة الأحكام الفقهية في إطلاق سراح الأسرى بالمن (دون مقابل) أو الفداء المالي أو تبادل المحتجزين.',
        ),
        LearningObjective(
          objectiveId: 'obj_intl6_3',
          title: 'فقه الإغاثة الإنسانية وإيصال المساعدات',
          description: 'بيان مشروعية ووجوب إيصال الغذاء والدواء للمنكوبين والمتضررين من النزاعات دون تمييز عرقي أو ديني.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_intl6_1',
          title: 'الكرامة الإنسانية للأسير وحسن معاملته في القرآن',
          contentType: LearningContentType.sourceText,
          content: 'أثنى الله تعالى على عباده الأبرار بإطعام وإكرام الأسرى وجعل ذلك من خصال المتقين: ﴿وَيُطْعِمُونَ الطَّعَامَ عَلَىٰ حُبِّهِ مِسْكِينًا وَيَتِيمًا وَأَسِيرًا ۝ إِنَّمَا نُطْعِمُكُمْ لِوَجْهِ اللَّهِ لَا نُرِيدُ مِنكُمْ جَزَاءً وَلَا شُكُورًا﴾. وقد أوصى النبي ﷺ بأسرى بدر خيراً، فكان الصحابة يؤثرونهم بالخبز ويأكلون التمر امتثالاً لتوجيهه الكريم.',
          evidenceLinks: [evPrisonersQuran, evFidaQuran],
          sourceAttribution: 'تفسير ابن كثير وسيرة ابن هشام',
        ),
        LessonSection.create(
          sectionId: 'sec_intl6_2',
          title: 'خيارات إنهاء الأسر: المن والفداء وتبادل المحتجزين',
          contentType: LearningContentType.explanation,
          content: 'حدد القرآن الكريم الأصل في إنهاء ملف الأسرى بخيارين حكيمين: ﴿فَإِمَّا مَنًّا بَعْدُ وَإِمَّا فِدَاءً﴾؛ فالمن هو الإطلاق المجاني للأسير إحساناً وتأليفاً (كما فعل النبي ﷺ مع ثمامة بن أثال وأسرى حنين)، والفداء هو إطلاقهم بمقابل مالي أو بتبادلهم بأسرى المسلمين أو بتعليمهم لأبناء المسلمين (كما في فداء أسرى بدر).',
          sourceAttribution: 'الأحكام السلطانية والمهذب',
        ),
        LessonSection.create(
          sectionId: 'sec_intl6_3',
          title: 'العمل الإغاثي والإنساني في فقه الأزمات والكوارث',
          contentType: LearningContentType.explanation,
          content: 'الإغاثة الإنسانية وكفالة المتضررين من الحروب والزلازل والمجاعات واجب شرعي وإنساني؛ وقد أرسل النبي ﷺ نجدة مالية وإغاثية لأهل مكة أثناء قحطهم ومجاعتهم وهم في حالة عداء وحرب مع المسلمين، ليؤكد أن الرحمة الإنسانية وتوفير الغذاء والدواء لا تسقطهما الخصومات السياسية والعسكرية.',
          sourceAttribution: 'السير الكبير للشيباني وتاريخ دمشق لابن عساكر',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: العلاقات الدولية والعهود
    final q1 = QuizQuestion.create(
      questionId: 'q_intl_1',
      lessonId: 'lsn_international_covenants_treaties_fidelity',
      questionText: 'ما هو الموقف الشرعي الصارم إذا استنصر المسلمون المستضعفون في دولة أخرى، وكان بين تلك الدولة وبين الدولة الإسلامية معاهدة وميثاق أمان؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qi1_1', text: 'يحرم نقض المعاهدة عسكرياً لقوله تعالى: ﴿إِلَّا عَلَىٰ قَوْمٍ بَيْنَكُمْ وَبَيْنَهُم مِّيثَاقٌ﴾ ويجب اللجوء للحلول الدبلوماسية'),
        QuizOption(optionId: 'opt_qi1_2', text: 'يجوز نقض العهد فوراً وسراً دون إخطار الطرف الآخر'),
        QuizOption(optionId: 'opt_qi1_3', text: 'المعاهدات مع غير المسلمين لا حرمة لها شرعاً وتسقط تلقائياً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قرر القرآن مبدأ احترام المعاهدات الدولية ومنع نقضها بالقتال حتى لنصرة المسلمين المستضعفين لتعظيم حرمة العهد والوفاء به.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_international_relations_treaties',
      lessonId: 'lsn_international_covenants_treaties_fidelity',
      title: 'اختبار أصول العلاقات الدولية والمعاهدات والحصانة الدبلوماسية',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: القانون الدولي الإنساني والأسرى
    final q2 = QuizQuestion.create(
      questionId: 'q_intl_2',
      lessonId: 'lsn_international_humanitarian_rules_civilians',
      questionText: 'أي من الفئات الآتية أمر أبو بكر الصديق رضي الله عنه وأجمع الفقهاء على تحريم استهدافها أو قتلها في النزاعات المسلحة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qi2_1', text: 'النساء والأطفال والشيوخ والرهبان في صوامعهم ومن لا يقاتل ولا يشارك في المجهود الحربي'),
        QuizOption(optionId: 'opt_qi2_2', text: 'المحاربون المسلحون في أرض المعركة'),
        QuizOption(optionId: 'opt_qi2_3', text: 'قادة الجيوش العسكرية أثناء الهجوم'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أكدت وصايا النبي ﷺ وأبي بكر الصديق التحريم القاطع لقتل النساء والأطفال والرهبان والمدنيين غير المقاتلين.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_international_humanitarian_law',
      lessonId: 'lsn_international_humanitarian_rules_civilians',
      title: 'اختبار القانون الدولي الإنساني وحماية المدنيين وحقوق الأسرى',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
