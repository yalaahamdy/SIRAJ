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

/// بيانات مقرر القواعد الفقهية الكبرى والمقاصد الشرعية (6 دروس تأصيلية + اختباران استيعاب)
class LearningMuamalatQawaidMaqasidData {
  static const String courseId = 'course_fiqh_qawaid_maqasid';
  static const String pathId = 'path_fiqh_muamalat_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر القواعد الفقهية الكبرى والمقاصد الشرعية وفقه الموازنات',
      description: 'دراسة تأصيلية جامعة للقواعد الفقهية الكبرى الخمس التي يدور عليها الفقه الإسلامي، ومقاصد الشريعة الكلية وحفظ الكليات الخمس، مع فقه الموازنات والأولويات في النوازل المعاصرة.',
      level: lp.LearningLevel.intermediate,
      moduleIds: const ['mod_qawaid_fiqhiyyah_kubra', 'mod_maqasid_sharia_priorities'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_qawaid_fiqhiyyah_kubra',
        courseId: courseId,
        title: 'الوحدة الأولى: القواعد الفقهية الكبرى الخمس وتطبيقاتها المعاصرة',
        description: 'شرح القواعد الخمس الكبرى: الأمور بمقاصدها، اليقين لا يزول بالشك، المشقة تجلب التيسير، الضرر يزال، والعادة محكمة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_qawaid_maqasid_niyyah',
          'lsn_qawaid_yaqeen_mashaqqah',
          'lsn_qawaid_darar_aadah',
        ],
      ),
      CourseModule(
        moduleId: 'mod_maqasid_sharia_priorities',
        courseId: courseId,
        title: 'الوحدة الثانية: مقاصد الشريعة والضروريات الخمس وفقه الموازنات',
        description: 'مراتب المقاصد (الضروريات، الحاجيات، التحسينيات)، الكليات الخمس الكبرى، وقواعد الموازنة عند تعارض المصالح والمفاسد.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_qawaid_fiqhiyyah_kubra'],
        lessonIds: const [
          'lsn_maqasid_three_levels',
          'lsn_maqasid_five_essentials',
          'lsn_maqasid_priorities_balances',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 19: قاعدة الأمور بمقاصدها
    // -------------------------------------------------------------------------
    final evNiyyahHadith = EvidenceLink.create(
      evidenceId: 'ev_qawaid_bukhari_1',
      evidenceKey: 'bukhari:1',
      citation: 'صحيح البخاري: «إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_qawaid_maqasid_niyyah',
      title: 'قاعدة «الأمور بمقاصدها»: النيات في العبادات، والعبرة في العقود بالمقاصد والمعاني',
      courseId: courseId,
      moduleId: 'mod_qawaid_fiqhiyyah_kubra',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mqm1_1',
          title: 'معنى قاعدة الأمور بمقاصدها وأصلها',
          description: 'فهم القاعدة الكبرى وتأسيسها على حديث النيات النبوي الشريف في تمييز العبادات عن العادات.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm1_2',
          title: 'العبرة في العقود بالمقاصد والمعاني',
          description: 'معرفة أن صحة العقد وفساده يدوران على حقيقة المقصد والنية لا على مجرد الألفاظ والمباني الظاهرة.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm1_3',
          title: 'الحيل المحرمة وإبطال الشريعة لها',
          description: 'استيعاب بطلان الحيل التي يقصد بها التوصل إلى المحرمات كحيل الربا وإسقاط الزكاة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mqm1_1',
          title: 'أصل القاعدة ومنزلتها في الشريعة',
          contentType: LearningContentType.sourceText,
          content: 'أصل هذه القاعدة العظيمة هو قول رسول الله ﷺ: «إنما الأعمال بالنيات، وإنما لكل امرئ ما نوى»؛ ومعناها أن أحكام تصرفات الإنسان القولية والفعلية تتبع قصده ونيته. وللنية وظيفتان جليلتان:\n1. تمييز العبادات عن العادات (كالغسل للتبرد أو للجنابة).\n2. تمييز رتب العبادات بعضها عن بعض (كالصلاة فرضاً أو نفلاً، والزكاة عن الصدقة).',
          evidenceLinks: [evNiyyahHadith],
          sourceAttribution: 'الأشباه والنظائر للسيوطي وقواعد ابن رجب',
        ),
        LessonSection.create(
          sectionId: 'sec_mqm1_2',
          title: 'قاعدة «العبرة في العقود بالمقاصد والمعاني لا بالألفاظ والمباني»',
          contentType: LearningContentType.explanation,
          content: 'يتفرع عن القاعدة أصل عظيم في المعاملات المالية: أن العقد يُحكم عليه بحقيقته ومقصده الشرعي لا بمجرد الألفاظ المزوقة؛ فلو سمى المتعاملان الفائدة الربوية "أتعاباً إدارية" أو "عوائد استثمارية صورية"، فإنها تظل رباً محرماً. وإذا تظاهر العاقدان ببيع وشراء صوري للوصول إلى قرض ربوي (كالعينة)، فإن العقد باطل بإجماع المحققين لأن مقصدهما هو الربا.',
          sourceAttribution: 'إعلام الموقعين لابن القيم ومجلة الأحكام العدلية',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 20: اليقين لا يزول بالشك والمشقة تجلب التيسير
    // -------------------------------------------------------------------------
    final evYaqeenHadith = EvidenceLink.create(
      evidenceId: 'ev_qawaid_muslim_361',
      evidenceKey: 'muslim:361',
      citation: 'صحيح مسلم: «فلا ينصرف حتى يسمع صوتاً أو يجد ريحاً»',
      sourceId: 'src_hadith_canonical',
    );
    final evTaysirAyah = EvidenceLink.create(
      evidenceId: 'ev_qawaid_quran_2185',
      evidenceKey: '2:185',
      citation: 'سورة البقرة: الآية 185 {يُرِيدُ اللَّهُ بِكُمُ الْيُسْرَ وَلَا يُرِيدُ بِكُمُ الْعُسْرَ}',
      sourceId: 'src_quran_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_qawaid_yaqeen_mashaqqah',
      title: 'قاعدتا «اليقين لا يزول بالشك» و «المشقة تجلب التيسير» وضوابط الرخص الشرعية',
      courseId: courseId,
      moduleId: 'mod_qawaid_fiqhiyyah_kubra',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mqm2_1',
          title: 'قاعدة «اليقين لا يزول بالشك» وتطبيقاتها',
          description: 'فهم بقاء الأمر المستيقن حتى يطرأ يقين مثله يزيله، وقطع الوساوس في الطهارة والصلاة والعقود والديون.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm2_2',
          title: 'قاعدة «الأصل براءة الذمة» و«الأصل في الأشياء الإباحة»',
          description: 'معرفة القواعد الفرعية لليقين في سلامة الذمة وإباحة المعاملات والأطعمة حتى يثبت التحريم.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm2_3',
          title: 'قاعدة «المشقة تجلب التيسير» وضوابط الرخص',
          description: 'استيعاب أنواع المشقة وأسباب التخفيف السبعة (السفر، المرض، الإكراه، النسيان، الجهل، العسر، النقص).',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mqm2_1',
          title: 'اليقين لا يزول بالشك وفروعه الكبرى',
          contentType: LearningContentType.sourceText,
          content: 'معنى القاعدة: أن الأمر المتيقن ثبوته أو انتفاؤه لا يرتفع بمجرد شك طارئ؛ قال النبي ﷺ فيمن شك في صلاته: «فلا ينصرف حتى يسمع صوتاً أو يجد ريحاً». ومن فروعها الجليلة:\n1. الأصل بقاء ما كان على ما كان.\n2. الأصل براءة الذمة: فلا يُلزم إنسان بدين أو جناية بدعوى مجردة من البينة.\n3. الأصل في العقود والشروط والمعاملات الحل والإباحة حتى يقوم دليل التحريم.',
          evidenceLinks: [evYaqeenHadith],
          sourceAttribution: 'صحيح مسلم وشرح القواعد الفقهية للزرقا',
        ),
        LessonSection.create(
          sectionId: 'sec_mqm2_2',
          title: 'المشقة تجلب التيسير وموجبات الرخص',
          contentType: LearningContentType.explanation,
          content: 'بُنيت الشريعة على اليسر ونفي الحرج؛ قال تعالى: {يُرِيدُ اللَّهُ بِكُمُ الْيُسْرَ وَلَا يُرِيدُ بِكُمُ الْعُسْرَ}، وقال سبحانه: {وَمَا جَعَلَ عَلَيْكُمْ فِي الدِّينِ مِنْ حَرَجٍ}. وضابط المشقة الجالبة للتيسير: هي المشقة الزائدة الخارجة عن المعتاد التي تلحق ضرراً بالنفس أو المال، وأسباب التخفيف المقررة سبعة: السفر، المرض، الإكراه، النسيان، الجهل، عموم البلوى، والنقص الطبيعي كالصبا والجنون.',
          evidenceLinks: [evTaysirAyah],
          sourceAttribution: 'الموافقات للشاطبي والوجيز في القواعد الفقهية للبورنو',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_quran_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 21: الضرر يزال والعادة محكمة
    // -------------------------------------------------------------------------
    final evDararHadith = EvidenceLink.create(
      evidenceId: 'ev_qawaid_ibnmajah_2340',
      evidenceKey: 'ibnmajah:2340',
      citation: 'سنن ابن ماجه: «لا ضرر ولا ضرار» حديث صحيح',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_qawaid_darar_aadah',
      title: 'قاعدتا «الضرر يزال» و «العادة محكمة»: إزالة المفاسد واعتبار الأعراف',
      courseId: courseId,
      moduleId: 'mod_qawaid_fiqhiyyah_kubra',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mqm3_1',
          title: 'قاعدة «الضرر يزال» وأصلها النبوي',
          description: 'فهم حديث «لا ضرر ولا ضرار» ووجوب دفع الضرر قبل وقوعه ورفعه بعد وقوعه.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm3_2',
          title: '«الضرورات تبيح المحظورات» و«الضرورة تقدر بقدرها»',
          description: 'معرفة ضوابط الاضطرار الشرعي وشروطه المشددة حتى لا يتخذ ذريعة للحرام.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm3_3',
          title: 'قاعدة «العادة محكمة» وشروط اعتبار العرف',
          description: 'استيعاب تحكيم العرف الصحيح في تقدير النفقات والأجور وتحديد المبيع وتقابض الأموال.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mqm3_1',
          title: 'قاعدة الضرر يزال وفروعها في دفع المفاسد',
          contentType: LearningContentType.sourceText,
          content: 'النص النبوي الجامع: «لا ضرر ولا ضرار» هو عماد هذه القاعدة؛ فلا يجوز ابتداء الإضرار بأحد، ولا مقابلة الضرر بضرر مثله. ومن فروعها الكبرى:\n1. الضرر يُدفع بقدر الإمكان.\n2. الضرر لا يُزال بضرر مثله أو أشد منه.\n3. يُتحمل الضرر الخاص لدفع الضرر العام (كهدم جدار مائل يخيف المارة، وتسعير السلع جبراً عند احتكار المحتكرين).\n4. الضرورات تبيح المحظورات، مقيدة بقاعدة: "الضرورة تُقدّر بقدرها".',
          evidenceLinks: [evDararHadith],
          sourceAttribution: 'الأشباه والنظائر لابن نجيم وجامع العلوم والحكم لابن رجب',
        ),
        LessonSection.create(
          sectionId: 'sec_mqm3_2',
          title: 'قاعدة العادة محكمة وضوابط العرف',
          contentType: LearningContentType.explanation,
          content: 'معنى القاعدة: أن العرف العام المطرد بين الناس يُحكّم للفصل في النزاعات وتفسير العقود والشروط وتحديد المقادير التي أطلقها الشرع ولم يحددها (كالقبض، والحرز في السرقة، والنفقة الزوجية بالمعروف). ويشترط في العرف المعتبر:\n1. أن يكون مطرداً أو غالباً.\n2. أن يكون عاماً أو شائعاً في بيئة العقد.\n3. ألا يخالف نصاً شرعياً قطعياً؛ فكل عرف يُبيح الربا أو القمار أو التبرج هو عرف فاسد ساقط لا قيمة له.',
          sourceAttribution: 'شرح القواعد الكبرى للدكتور مصطفى الزرقا',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 22: مراتب المقاصد الشرعية الثلاث
    // -------------------------------------------------------------------------
    final evMaqasidShatibi = EvidenceLink.create(
      evidenceId: 'ev_maqasid_shatibi_darurat',
      evidenceKey: 'maqasid:darurat_thalath',
      citation: 'الإمام الشاطبي: «الموافقات»: تكامل الضروريات والحاجيات والتحسينيات',
      sourceId: 'src_knowledge_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_maqasid_three_levels',
      title: 'مراتب مقاصد الشريعة الإسلامية: الضروريات والحاجيات والتحسينيات وتكاملها',
      courseId: courseId,
      moduleId: 'mod_maqasid_sharia_priorities',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mqm4_1',
          title: 'مرتبة الضروريات',
          description: 'معرفة ما لا بد منه لقيام مصالح الدين والدنيا بحيث إذا فُقد اختل نظام الحياة وعم الفساد.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm4_2',
          title: 'مرتبة الحاجيات',
          description: 'فهم ما يحتاج إليه الناس للتوسعة ورفع الحرج والمشقة دون أن يفضي فقده لانهيار كلي.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm4_3',
          title: 'مرتبة التحسينيات وتكامل المراتب',
          description: 'استيعاب محاسن العادات ومكارم الأخلاق ورعاية التحسينيات كخادم ومكمل للضروريات والحاجيات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mqm4_1',
          title: 'المراتب الثلاث لمصالح العباد في التشريع',
          contentType: LearningContentType.explanation,
          content: 'قسم علماء الأصول والمقاصد مصالح الخلق إلى ثلاث مراتب هرمية متكاملة:\n1. الضروريات: هي الأصول التي تتوقف عليها حياة الناس الدينية والدنيوية، وإذا اختلت فسدت الحياة وعم الهلاك وفات النعيم الأخروي، وهي الكليات الخمس.\n2. الحاجيات: ما يحتاجه الناس لرفع الضيق والحرج والتيسير عليهم، وإذا فُقدت لحق الناس الحرج والمشقة وإن لم تنهدم حياتهم (كالرخص في السفر وعقود الإجارة والسلم والشركات).\n3. التحسينيات: الأخذ بمحاسن العادات ومكارم الأخلاق (كالطهارة وستر العورة ونوافل الصدقات وآداب الأكل والشرب).',
          evidenceLinks: [evMaqasidShatibi],
          sourceAttribution: 'الموافقات للإمام الشاطبي والمستصفى للغزالي',
        ),
      ],
      sources: const ['src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 23: الكليات الخمس الكبرى
    // -------------------------------------------------------------------------
    final evNafsAyah = EvidenceLink.create(
      evidenceId: 'ev_maqasid_quran_nafs',
      evidenceKey: '5:32',
      citation: 'سورة المائدة: الآية 32 {مَن قَتَلَ نَفْسًا بِغَيْرِ نَفْسٍ أَوْ فَسَادٍ فِي الْأَرْضِ فَكَأَنَّمَا قَتَلَ النَّاسَ جَمِيعًا}',
      sourceId: 'src_quran_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_maqasid_five_essentials',
      title: 'الكليات الخمس الكبرى: حفظ الدين، النفس، العقل، النسل والعرض، وحفظ المال',
      courseId: courseId,
      moduleId: 'mod_maqasid_sharia_priorities',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mqm5_1',
          title: 'حفظ الدين والنفس',
          description: 'معرفة تشريعات حفظ الدين من جانب الوجود والعدم، وحرمة الدماء وتشريع القصاص والدفاع الشرعي.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm5_2',
          title: 'حفظ العقل والنسل والعرض',
          description: 'فهم تحريم المسكرات والمخدرات لحفظ العقل، وتشريع الزواج وتحريم الزنا والقذف لحفظ الأنساب والأعراض.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm5_3',
          title: 'حفظ المال وتداوله بالعدل',
          description: 'استيعاب تشريعات كسب المال وتنميته وتحريم السرقة والربا والرشوة وتبديد الأموال.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mqm5_1',
          title: 'الكليات الخمس وحمايتها من جانبي الوجود والعدم',
          contentType: LearningContentType.explanation,
          content: 'أجمعت كل الشرائع السماوية على حفظ الكليات الخمس، وتخدمها الشريعة الإسلامية بطريقتين:\n1. من جانب الوجود: بإقامة أركانها وتثبيت قواعدها.\n2. من جانب العدم: بدرء الأخطار ودرء ما يهدد بقاءها.\n- حفظ الدين: شرع التوحيد والعبادات (وجوداً)، وحرّم الردة والبدع والنفاق (عدماً).\n- حفظ النفس: شرع التداوي والزواج وأكل الطيبات (وجوداً)، وحرّم القتل والاعتداء والانتحار وسن القصاص (عدماً).\n- حفظ العقل: أوجب التعلم والتفكر (وجوداً)، وحرّم المسكرات والمخدرات والمفسدات الفكرية (عدماً).\n- حفظ النسل والعرض: شرع النكاح والنفقة وحسن التربية (وجوداً)، وحرّم الزنا واللواط والقذف (عدماً).\n- حفظ المال: شرع العمل والبيوع والإجارة والاستثمار (وجوداً)، وحرّم السرقة والغصب والربا والغرر والإسراف (عدماً).',
          evidenceLinks: [evNafsAyah],
          sourceAttribution: 'مقاصد الشريعة الإسلامية لابن عاشور وقواعد الأحكام للعز بن عبد السلام',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 24: فقه الموازنات والأولويات
    // -------------------------------------------------------------------------
    final evMuwazanatRule = EvidenceLink.create(
      evidenceId: 'ev_maqasid_akhaff_dararayn',
      evidenceKey: 'qawaid:akhaff_dararayn',
      citation: 'القاعدة الفقهية المجمع عليها: «يُرتكب أخف الضررين لدفع أعلاهما، وتُدرأ المفاسد قبل جلب المصالح»',
      sourceId: 'src_knowledge_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_maqasid_priorities_balances',
      title: 'فقه الموازنات والأولويات: درء المفاسد وتعارض المصالح وتقديم المصلحة العامة',
      courseId: courseId,
      moduleId: 'mod_maqasid_sharia_priorities',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mqm6_1',
          title: 'قاعدة «درء المفاسد مقدم على جلب المصالح»',
          description: 'فهم أولوية منع الشرور والمفاسد الكبرى على تحقيق المنافع المرجوة عند التساوي أو التقارب.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm6_2',
          title: 'ارتكاب أخف الضررين وتفويت أدنى المصلحتين',
          description: 'استيعاب ميزان الشريعة في التضحية بالمصلحة الصغرى لتحصيل الكبرى وقبول الضرر الأخف لدفع الكارثة الأكبر.',
        ),
        LearningObjective(
          objectiveId: 'obj_mqm6_3',
          title: 'تقديم المصلحة العامة على المصلحة الخاصة',
          description: 'تطبيق فقه الأولويات في النوازل المعاصرة والأزمات الاقتصادية والسياسة الشرعية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mqm6_1',
          title: 'قواعد الموازنة عند تعارض المصالح والمفاسد',
          contentType: LearningContentType.scholarlyView,
          content: 'الحياة مليئة بتزاحم المصالح والمفاسد، وقد وضع علماء المقاصد موازين شرعية دقيقة لحل هذا التعارض:\n1. درء المفاسد مُقدّم على جلب المصالح: لأن اعتناء الشارع بالمنهيات أشد من اعتنائه بالمأمورات.\n2. إذا تعارضت مفسدتان: ارتكبنا أخفّهما لدفع أعظمهما وأشدهما خطراً (كمسألة هجرة المسلمين إلى الحبشة تحت ملك نصراني عادل لدفع مفسدة الفتنة والقتل بمكة).\n3. إذا تزاحمت مصلحتان: قُدّمت أعلاهما وأكثرهما نفعاً للأمة وتُركت الأدنى.\n4. تُقدّم المصلحة العامة الجماعية على المصلحة الفردية الخاصة (كنزع ملكية عقار لتوسعة مسجد أو طريق عام للمسلمين مع تعويض عادل).',
          evidenceLinks: [evMuwazanatRule],
          sourceAttribution: 'قواعد الأحكام في مصالح الأنام للعز بن عبد السلام ومقاصد الشريعة للريسوني',
        ),
      ],
      sources: const ['src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: القواعد الفقهية الكبرى
    final q1 = QuizQuestion.create(
      questionId: 'q_qawaid_1',
      lessonId: 'lsn_qawaid_darar_aadah',
      questionText: 'ما هو الضابط الشرعي لتطبيق قاعدة «الضرورات تبيح المحظورات»؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qqm1_1', text: 'أن الضرورة تُقدّر بقدرها فقط، فلا يُتوسع فيها ولا يُرتكب الحرام إلا بما يدفع الهلاك الحقيقي'),
        QuizOption(optionId: 'opt_qqm1_2', text: 'أن تباح جميع المحظورات بلا حدود أو قيود بمجرد حصول أدنى حرج'),
        QuizOption(optionId: 'opt_qqm1_3', text: 'أن يجوز ارتكاب المحظور حتى لو أدى إلى إتلاف نفس معصومة أخرى'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قاعدة «الضرورات تبيح المحظورات» مقيدة بإجماع العلماء بقاعدة «الضرورة تقدر بقدرها»، بحيث يتناول المضطر فقط ما يدفع الهلاك المحقق دون زيادة.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_qawaid_fiqhiyyah_kubra',
      lessonId: 'lsn_qawaid_darar_aadah',
      title: 'اختبار القواعد الفقهية الكبرى الخمس وتطبيقاتها المعاصرة',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: المقاصد والضروريات والموازنات
    final q2 = QuizQuestion.create(
      questionId: 'q_qawaid_2',
      lessonId: 'lsn_maqasid_priorities_balances',
      questionText: 'إذا تزاحمت مفسدتان لا يمكن تفاديهما معاً في نازلة معاصرة، فكيف توجهنا الشريعة الإسلامية؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qqm2_1', text: 'يُرتكب أخف الضررين وأهون الشرين لدفع أعظمهما وأشدهما خطراً'),
        QuizOption(optionId: 'opt_qqm2_2', text: 'يُترك الأمر كلياً دون تصرف حتى لو أدى إلى هلاك الأمة بأسرها'),
        QuizOption(optionId: 'opt_qqm2_3', text: 'يُرتكب الضرر الأكبر دائماً دون مبالاة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'من قواعد فقه الموازنات الكبرى: «إذا تعارضت مفسدتان رُوعي أعظمهما بارتكاب أخفهما» لدفع الكارثة والفساد الأعظم عن الأمة والمجتمع.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_maqasid_priorities',
      lessonId: 'lsn_maqasid_priorities_balances',
      title: 'اختبار مقاصد الشريعة والكليات الخمس وفقه الموازنات والأولويات',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
