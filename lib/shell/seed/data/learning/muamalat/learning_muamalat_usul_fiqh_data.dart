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

/// بيانات مقرر مبادئ أصول الفقه ومصادر التشريع والاجتهاد (6 دروس تأصيلية + اختباران استيعاب)
class LearningMuamalatUsulFiqhData {
  static const String courseId = 'course_fiqh_usul_intro';
  static const String pathId = 'path_fiqh_muamalat_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر مبادئ أصول الفقه ومصادر التشريع والاجتهاد',
      description: 'دراسة تأصيلية منهجية في علم أصول الفقه: حقيقته، أقسام الحكم التكليفي والوضعي، الأدلة المتفق عليها (القرآن، السنة، الإجماع، القياس)، الأدلة التبعية، وقواعد دلالات الألفاظ والاجتهاد والفتوى.',
      level: lp.LearningLevel.intermediate,
      moduleIds: const ['mod_usul_intro_rulings_sources', 'mod_usul_secondary_sources_ijtihad'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_usul_intro_rulings_sources',
        courseId: courseId,
        title: 'الوحدة الأولى: حقيقة أصول الفقه والحكم الشرعي والمصادر الأصلية المتفق عليها',
        description: 'مفهوم علم أصول الفقه، الحكم التكليفي والوضعي، وأدلة التشريع الكبرى: القرآن والسنة والإجماع والقياس.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_usul_nature_and_scope',
          'lsn_usul_sharia_rulings',
          'lsn_usul_agreed_sources',
        ],
      ),
      CourseModule(
        moduleId: 'mod_usul_secondary_sources_ijtihad',
        courseId: courseId,
        title: 'الوحدة الثانية: الأدلة التبعية وقواعد الاستنباط وضوابط الاجتهاد والفتوى',
        description: 'الأدلة التبعية (المصالح، الاستحسان، سد الذرائع، العرف)، دلالات الألفاظ، وضوابط الفتوى والاجتهاد والتقليد.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_usul_intro_rulings_sources'],
        lessonIds: const [
          'lsn_usul_secondary_sources',
          'lsn_usul_dalalat_al_alfaz',
          'lsn_usul_ijtihad_fatwa_rules',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 13: حقيقة علم أصول الفقه وغايته
    // -------------------------------------------------------------------------
    final evUsulDefinition = EvidenceLink.create(
      evidenceId: 'ev_usul_shafii_risala',
      evidenceKey: 'usul:shafii_risala',
      citation: 'الإمام الشافعي: كتاب «الرسالة» أول تدوين منهجي في أصول الفقه',
      sourceId: 'src_knowledge_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_usul_nature_and_scope',
      title: 'حقيقة علم أصول الفقه وغايته والفرق بينه وبين الفقه والقواعد الفقهية',
      courseId: courseId,
      moduleId: 'mod_usul_intro_rulings_sources',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mus1_1',
          title: 'تعريف أصول الفقه لغة واصطلاحاً',
          description: 'معرفة أصول الفقه باعتباره القواعد الكلية التي يتوصل بها إلى استنباط الأحكام الشرعية العملية من أدلتها التفصيلية.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus1_2',
          title: 'الغاية الكبرى من دراسة الأصول',
          description: 'فهم دور أصول الفقه في ضبط فهم النصوص الشرعية وحماية العقل المسلم من التخبط والانحراف الفكري.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus1_3',
          title: 'الفروق الدقيقة بين الفقه والأصول والقواعد',
          description: 'التمييز بين الحكم الجزئي (الفقه)، والقاعدة المنهجية الكلية (الأصول)، والضابط الجامع للفروع المتشابهة (القاعدة الفقهية).',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mus1_1',
          title: 'تعريف أصول الفقه ونشأته التدوينية',
          contentType: LearningContentType.explanation,
          content: 'أصول الفقه هو: "العلم بالقواعد التي يُتوصل بها إلى استنباط الأحكام الشرعية الفرعية من أدلتها التفصيلية". وموضوعه: الأدلة الشرعية الإجمالية والأحكام وكيفية الاستنباط وحال المستفيد (المجتهد). وأول من دوّن هذا العلم على وجه مستقل هو الإمام محمد بن إدريس الشافعي رحمه الله في كتابه الفذ "الرسالة"، واضعاً به ميزاناً عقلياً لضبط الاستدلال بالقرآن والبيان النبوي والإجماع والقياس.',
          evidenceLinks: [evUsulDefinition],
          sourceAttribution: 'الرسالة للشافعي والبحر المحيط للزركشي',
        ),
        LessonSection.create(
          sectionId: 'sec_mus1_2',
          title: 'الفرق الجوهري بين الأصول والفقه والقواعد',
          contentType: LearningContentType.scholarlyView,
          content: '1. الأصولي: يبحث في الأدلة الإجمالية المجردة، كقوله: "الأمر المطلق يقتضي الوجوب".\n2. الفقيه: يطبق القاعدة الأصولية على النص الخاص لاستنباط الحكم الجزئي، كقوله: "أقيموا الصلاة" أمر، فالصلاة واجبة.\n3. القاعدة الفقهية: تجمع الفروع والمسائل الفقهية المتشابهة بعد استنباطها لربطها بمقصد واحد، كقاعدة: "اليقين لا يزول بالشك".',
          sourceAttribution: 'شرح اللمع للشيرازي وقواعد الأحكام للعز بن عبد السلام',
        ),
      ],
      sources: const ['src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 14: أقسام الحكم الشرعي
    // -------------------------------------------------------------------------
    final evRulingsQuran = EvidenceLink.create(
      evidenceId: 'ev_usul_rulings_ayah',
      evidenceKey: '4:59',
      citation: 'سورة النساء: الآية 59 {يَا أَيُّهَا الَّذِينَ آمَنُوا أَطِيعُوا اللَّهَ وَأَطِيعُوا الرَّسُولَ}',
      sourceId: 'src_quran_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_usul_sharia_rulings',
      title: 'أقسام الحكم الشرعي: الحكم التكليفي الخماسي والحكم الوضعي',
      courseId: courseId,
      moduleId: 'mod_usul_intro_rulings_sources',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mus2_1',
          title: 'تعريف الحكم الشرعي التكليفي والوضعي',
          description: 'معرفة أن الحكم الشرعي هو خطاب الشارع المتعلق بأفعال المكلفين بالطلب أو التخيير أو الوضع.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus2_2',
          title: 'الأحكام التكليفية الخمسة',
          description: 'استيعاب أقسام الحكم التكليفي: الواجب، المندوب، المحرم، المكروه، والمباح.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus2_3',
          title: 'الأحكام الوضعية الخمسة',
          description: 'معرفة خطاب الوضع: السبب، الشرط، المانع، الصحة، والفساد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mus2_1',
          title: 'الأحكام التكليفية الخمسة وضوابطها',
          contentType: LearningContentType.explanation,
          content: 'ينقسم الحكم التكليفي إلى خمسة أقسام:\n1. الواجب (الفرض): ما طلب الشارع فعله طلباً جازماً، يُثاب فاعله امتثالاً ويستحق العقاب تاركه (كالصلوات والزكاة).\n2. المندوب (المستحب): ما طلب الشارع فعله طلباً غير جازم، يُثاب فاعله ولا يُعاقب تاركه (كالرواتب والسنن).\n3. المحرم (الحرام): ما طلب الشارع تركه طلباً جازماً، يُثاب تاركه امتثالاً ويستحق العقاب فاعله (كالربا والزنا).\n4. المكروه: ما طلب الشارع تركه طلباً غير جازم، يُثاب تاركه ولا يُعاقب فاعله.\n5. المباح: ما خيّر الشارع المكلف بين فعله وتركه دون ثواب أو عقاب في ذاته.',
          evidenceLinks: [evRulingsQuran],
          sourceAttribution: 'روضة الناظر لابن قدامة والمنخول للغزالي',
        ),
        LessonSection.create(
          sectionId: 'sec_mus2_2',
          title: 'الأحكام الوضعية وربطها بأفعال المكلفين',
          contentType: LearningContentType.scholarlyView,
          content: 'الحكم الوضعي هو جعل الشارع الشيء علامة على حكم تكليفي:\n1. السبب: ما يلزم من وجوده الوجود ومن عدمه العدم لذاته (كزوال الشمس سبب لوجوب صلاة الظهر).\n2. الشرط: ما يلزم من عدمه العدم ولا يلزم من وجوده وجود ولا عدم (كالطهارة شرط لصحة الصلاة).\n3. المانع: ما يلزم من وجوده العدم ولا يلزم من عدمه وجود ولا عدم (كالقتل مانع من الإرث).\n4. الصحة والفساد: الصحة ترتب الآثار الشرعية على الفعل، والفساد أو البطلان عدم ترتب الآثار وسقوط المطالبة.',
          sourceAttribution: 'إحكام الفصول للباجي والإحكام للآمدي',
        ),
      ],
      sources: const ['src_quran_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 15: الأدلة الأربعة المتفق عليها
    // -------------------------------------------------------------------------
    final evMuadhHadith = EvidenceLink.create(
      evidenceId: 'ev_usul_muadh_hadith',
      evidenceKey: 'tirmidhi:1327',
      citation: 'جامع الترمذي: حديث معاذ بن جبل في مراتب الاستدلال: «بكتاب الله، فبسنة رسوله، فأجتهد رأيي»',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_usul_agreed_sources',
      title: 'الأدلة الشرعية المتفق عليها: القرآن، السنة، الإجماع، والقياس بأركانه',
      courseId: courseId,
      moduleId: 'mod_usul_intro_rulings_sources',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mus3_1',
          title: 'القرآن الكريم والسنة النبوية',
          description: 'معرفة حجية القرآن القطعية وقطعية متنه، ومراتب السنة وأقسامها في بيان القرآن.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus3_2',
          title: 'الإجماع: تعريفه وشروطه وحجيته',
          description: 'فهم اتفاق مجتهدي أمة محمد ﷺ في عصر بعد وفاته على حكم شرعي وحجيته القطعية.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus3_3',
          title: 'القياس وأركانه الأربعة',
          description: 'استيعاب أركان القياس: الأصل، الفرع، حكم الأصل، والعلة الجامعة بينهما وشروطها.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mus3_1',
          title: 'مراتب الأدلة الأربعة المتفق عليها',
          contentType: LearningContentType.sourceText,
          content: 'أجمع أئمة الإسلام على أن أصول الأحكام ومصادر التشريع الكبرى أربعة مرتبة بحسب حجيتها:\n1. كتاب الله تعالى: المصدر الأول المهيمن على كل تشريع.\n2. سنة رسول الله ﷺ: المصدر الثاني المفسر والشارح والمستقل بتشريع الأحكام.\n3. الإجماع: حجة معصومة لقوله ﷺ: «إن أمتي لا تجتمع على ضلالة».\n4. القياس: إلحاق فرع لم يرد فيه نص بأصل ورد فيه نص لاشتراكهما في علة الحكم.',
          evidenceLinks: [evMuadhHadith],
          sourceAttribution: 'المستصفى للغزالي وشرح تنقيح الفصول للقرافي',
        ),
        LessonSection.create(
          sectionId: 'sec_mus3_2',
          title: 'أركان القياس الأربعة وشروط العلة',
          contentType: LearningContentType.explanation,
          content: 'يقوم القياس الصحيح على أربعة أركان متكاملة:\n1. الأصل: المقيس عليه الثابت حكمه بنص أو إجماع (كالخمر).\n2. الفرع: المقيس الحادث الذي لم يرد فيه نص خاص (كالمخدرات والحبوب المسكرة).\n3. حكم الأصل: الحكم الشرعي الثابت للأصل (كالتحريم).\n4. العلة: الوصف الظاهر المنضبط الذي عُلق عليه الحكم ودار معه وجوداً وعدماً (وهو الإسكار وإذهاب العقل).\nفإذا تحققت العلة في الفرع أُعطي حكم الأصل بيقين، وهذا سر مرونة الفقه الإسلامي في استيعاب كافة المستجدات إلى يوم القيامة.',
          sourceAttribution: 'أصول الفقه للشيخ محمد الخضري بك والمذكرة للشنقيطي',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_quran_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 16: الأدلة التبعية المختلف فيها
    // -------------------------------------------------------------------------
    final evMaslaha = EvidenceLink.create(
      evidenceId: 'ev_usul_maslaha_rule',
      evidenceKey: 'usul:maslahah_mursalah',
      citation: 'الإمام الشاطبي: كتاب «الموافقات» في اعتبار المصالح وتأصيلها',
      sourceId: 'src_knowledge_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_usul_secondary_sources',
      title: 'الأدلة التبعية: الاستحسان، المصالح المرسلة، الاستصحاب، والعرف المعتبر',
      courseId: courseId,
      moduleId: 'mod_usul_secondary_sources_ijtihad',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mus4_1',
          title: 'الاستحسان وضوابطه',
          description: 'فهم العدول بمسألة عن نظائرها لدليل خاص أقوى من قياس ظاهر إلى قياس خفي أو نص أو مصلحة.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus4_2',
          title: 'المصلحة المرسلة وشروط العمل بها',
          description: 'معرفة المصالح التي سكت عنها الشارع ولم ينص على اعتبارها ولا إلغائها وضوابط انضباطها بالكليات.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus4_3',
          title: 'الاستصحاب والعرف',
          description: 'استيعاب استصحاب البراءة الأصلية أو الإباحة، وشروط العرف الصحيح الذي لا يصادم نصاً شرعياً.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mus4_1',
          title: 'المصالح المرسلة والاستحسان في الفقه الإسلامي',
          contentType: LearningContentType.explanation,
          content: '1. المصلحة المرسلة: هي المصلحة المطلقة التي لم يشهد لها الشارع بدليل معين بالإلغاء أو الاعتبار، وتعود لحفظ الدين أو النفس أو العقل أو النسل أو المال، ومن تطبيقاتها: جمع الصحابة للمصحف وتدوين الدواوين وسن قوانين المرور والتوثيق المعاصر.\n2. الاستحسان: هو ترجيح دليل خاص لمصلحة راجحة ورفعاً للحرج (كالاستصناع وتضمين الأجراء المشتركين).',
          evidenceLinks: [evMaslaha],
          sourceAttribution: 'الموافقات للشاطبي والاعتصام',
        ),
        LessonSection.create(
          sectionId: 'sec_mus4_2',
          title: 'الاستصحاب والعرف',
          contentType: LearningContentType.scholarlyView,
          content: '3. الاستصحاب: الحكم ببقاء ما كان على ما كان حتى يثبت المغير، كاستصحاب الطهارة حتى يثبت الحدث بيقين، واستصحاب براءة الذمة من الديون.\n4. العرف: ما تعارف عليه الناس وألفوه من قول أو عمل، ويُعتبر مصدراً ما لم يصادم نصاً شرعياً، فإن خالف النص (كالعرف في شرب الخمور أو الربا) فهو عرف فاسد باطل لا عبرة به.',
          sourceAttribution: 'الأشباه والنظائر للسيوطي وابن نجيم',
        ),
      ],
      sources: const ['src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 17: سد الذرائع ودلالات الألفاظ
    // -------------------------------------------------------------------------
    final evSadDharai = EvidenceLink.create(
      evidenceId: 'ev_usul_sadd_dharai_ayah',
      evidenceKey: '6:108',
      citation: 'سورة الأنعام: الآية 108 {وَلَا تَسُبُّوا الَّذِينَ يَدْعُونَ مِن دُونِ اللَّهِ فَيَسُبُّوا اللَّهَ عَدْوًا بِغَيْرِ عِلْمٍ}',
      sourceId: 'src_quran_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_usul_dalalat_al_alfaz',
      title: 'سد الذرائع وقواعد دلالات الألفاظ: الأمر والنهي والعام والخاص والمقيد',
      courseId: courseId,
      moduleId: 'mod_usul_secondary_sources_ijtihad',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mus5_1',
          title: 'أصل سد الذرائع وأهميته الفقهية',
          description: 'معرفة منع الوسائل والذرائع المباحة إذا كانت تفضي غالباً إلى مفاسد ومحرمات قطعية.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus5_2',
          title: 'دلالات الأوامر والنواهي',
          description: 'استيعاب دلالة الأمر المطلق على الوجوب والفور، والنهي المطلق على التحريم والفساد.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus5_3',
          title: 'العام والخاص والمطلق والمقيد',
          description: 'معرفة صيغ العموم وكيفية تخصيص العام وحمل المطلق على المقيد عند اتحاد السبب والحكم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mus5_1',
          title: 'قاعدة سد الذرائع وأثرها في التشريع',
          contentType: LearningContentType.sourceText,
          content: 'سد الذرائع هو حسم مادة وسائل الفساد بدفعها؛ فإن الفعل وإن كان مباحاً في أصله يُمنع إذا كان ذريعة مؤدية إلى الحرام؛ قال الله تعالى: {وَلَا تَسُبُّوا الَّذِينَ يَدْعُونَ مِن دُونِ اللَّهِ فَيَسُبُّوا اللَّهَ عَدْوًا بِغَيْرِ عِلْمٍ}؛ فنهى سبحانه عن سب آلهة المشركين (وهو حق في أصله) لأنه ذريعة لسب الله تعالى.',
          evidenceLinks: [evSadDharai],
          sourceAttribution: 'إعلام الموقعين لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_mus5_2',
          title: 'قواعد دلالات الألفاظ الكبرى',
          contentType: LearningContentType.explanation,
          content: '1. الأمر: صيغة "افعل" تقتضي الوجوب إلا لصارف (كقوله: أقيموا الصلاة).\n2. النهي: صيغة "لا تفعل" تقتضي التحريم وفساد المنهي عنه إلا لقرينة.\n3. العام: اللفظ المستغرق لجميع أفراده بحسب وضعه (كالأسماء المعرفة بأل الاستغراقية، والنكرة في سياق النفي)، والخاص يُقصر الحكم على بعض أفراده.\n4. المطلق والمقيد: المطلق يتناول واحداً لا بعينه، فإن قُيّد بوصف حُمل عليه (كتحرير رقبة مقيدة بـ "مؤمنة" في كفارة القتل).',
          sourceAttribution: 'الورقات للجويني ومراقي السعود',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 18: الاجتهاد والتقليد والفتوى
    // -------------------------------------------------------------------------
    final evIjtihadReward = EvidenceLink.create(
      evidenceId: 'ev_usul_ijtihad_hadith',
      evidenceKey: 'bukhari:7352',
      citation: 'صحيح البخاري: «إذا حكم الحاكم فاجتهد ثم أصاب فله أجران، وإذا حكم فاجتهد ثم أخطأ فله أجر»',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_usul_ijtihad_fatwa_rules',
      title: 'شروط المجتهد وضوابط التقليد وآداب الفتوى وخطر التجرؤ بغير علم',
      courseId: courseId,
      moduleId: 'mod_usul_secondary_sources_ijtihad',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mus6_1',
          title: 'شروط الاجتهاد المعتبرة شرعاً',
          description: 'معرفة شروط المجتهد من إتقان اللغة العربية، معرفة آيات وأحاديث الأحكام، الناسخ والمنسوخ، ومواطن الإجماع.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus6_2',
          title: 'ضوابط التقليد للعامة والتمذهب الفقهي',
          description: 'فهم وجوب سؤال أهل العلم على من لا قدرة له على الاستنباط: {فَاسْأَلُوا أَهْلَ الذِّكْرِ}.',
        ),
        LearningObjective(
          objectiveId: 'obj_mus6_3',
          title: 'آداب الفتوى وحرمة التجرؤ والقول بغير علم',
          description: 'استشعار عظمة التوقيع عن رب العالمين والتحذير من تتبع رخص المذاهب وإفتاء الجهال.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mus6_1',
          title: 'مشروعية الاجتهاد وفضل المجتهد المأجور',
          contentType: LearningContentType.sourceText,
          content: 'الاجتهاد هو بذل الوسع في استنباط الأحكام الشرعية العملية من أدلتها؛ روى البخاري ومسلم عن عمرو بن العاص رضي الله عنه أنه سمع رسول الله ﷺ يقول: «إِذَا حَكَمَ الحَاكِمُ فَاجْتَهَدَ ثُمَّ أَصَابَ فَلَهُ أَجْرَانِ، وَإِذَا حَكَمَ فَاجْتَهَدَ ثُمَّ أَخْطَأَ فَلَهُ أَجْرٌ». وهذا للمجتهد المستجمع لشروط النظر، أما من تجرأ وتكلم بغير علم فهو آثم هالك متعدٍ على الشريعة.',
          evidenceLinks: [evIjtihadReward],
          sourceAttribution: 'صحيح البخاري: كتاب الاعتصام بالكتاب والسنة',
        ),
        LessonSection.create(
          sectionId: 'sec_mus6_2',
          title: 'التقليد المنضبط وآداب المفتي والمستفتي',
          contentType: LearningContentType.explanation,
          content: '1. التقليد: هو قبول قول القائل بغير حجة ملزمة، وفرض العامي غير القادر على النظر سؤال العالم الموثوق بدينه وعلمه لقوله تعالى: {فَاسْأَلُوا أَهْلَ الذِّكْرِ إِن كُنتُمْ لَا تَعْلَمُونَ}.\n2. التمذهب: دراسة الفقه على مذهب معتبر وسيلة تعليمية رصيدة لحفظ الأصول، ولكن لا يجوز التعصب الأعمى إذا ظهر الدليل الصحيح الصريح.\n3. الفتوى: المفتي موقع عن الله تعالى، فيحرم عليه التسرع أو اتباع الهوى أو تتبع زلات العلماء ورخصهم المهلكة.',
          sourceAttribution: 'إعلام الموقعين لابن القيم وأدب الفتيا للنووي',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_quran_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: أصول الفقه والحكم والمصادر المتفق عليها
    final q1 = QuizQuestion.create(
      questionId: 'q_usul_1',
      lessonId: 'lsn_usul_agreed_sources',
      questionText: 'ما هي الأركان الأربعة التأسيسية التي يقوم عليها القياس في أصول الفقه؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qus1_1', text: 'الأصل، والفرع، وحكم الأصل، والعلة الجامعة بينهما'),
        QuizOption(optionId: 'opt_qus1_2', text: 'القرآن، والسنة، والإجماع، والعرف'),
        QuizOption(optionId: 'opt_qus1_3', text: 'الواجب، والمندوب، والمحرم، والمباح'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يقوم القياس الشرعي على أربعة أركان متلازمة: الأصل المقيس عليه، والفرع المقيس، وحكم الأصل الثابت بنص، والعلة الجامعة بينهما.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_usul_rulings_sources',
      lessonId: 'lsn_usul_agreed_sources',
      title: 'اختبار أصول الفقه والحكم الشرعي والمصادر الأصلية المتفق عليها',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: الأدلة التبعية والاجتهاد والفتوى
    final q2 = QuizQuestion.create(
      questionId: 'q_usul_2',
      lessonId: 'lsn_usul_ijtihad_fatwa_rules',
      questionText: 'إذا اجتهد العالم المستجمع لشروط الاجتهاد في مسألة نازلة فأخطأ فيها، فما حكمه وأجره؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qus2_1', text: 'يُعذر في خطئه وله أجر واحد على بذل وسعه واستفراغ طاقته في طلب الحق'),
        QuizOption(optionId: 'opt_qus2_2', text: 'يأثم إثماً عظيماً ويبطل اجتهاده مطلقاً'),
        QuizOption(optionId: 'opt_qus2_3', text: 'له أجران كاملان كمن أصاب الحق تماماً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقول النبي ﷺ: «إذا حكم الحاكم فاجتهد ثم أخطأ فله أجر»؛ فأجره على بذل الوسع واستفراغ الطاقة في طلب حكم الله تعالى.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_usul_ijtihad_sources',
      lessonId: 'lsn_usul_ijtihad_fatwa_rules',
      title: 'اختبار الأدلة التبعية وقواعد الاستنباط والاجتهاد وآداب الفتوى',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
