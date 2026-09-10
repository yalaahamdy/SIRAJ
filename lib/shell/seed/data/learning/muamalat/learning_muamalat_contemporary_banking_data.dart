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

/// بيانات مقرر المعاملات المصرفية والنوازل المالية المعاصرة (6 دروس تأصيلية + اختباران استيعاب)
class LearningMuamalatContemporaryBankingData {
  static const String courseId = 'course_fiqh_banking_contemporary';
  static const String pathId = 'path_fiqh_muamalat_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر المعاملات المصرفية والنوازل المالية المعاصرة',
      description: 'دراسة تأصيلية فقهية للنوازل المصرفية والمالية الحديثة: الحسابات البنكية، صيغ التمويل الإسلامي، البطاقات الائتمانية، الأسهم والصكوك، التأمين التكافلي، والعملات الرقمية والتضخم.',
      level: lp.LearningLevel.intermediate,
      moduleIds: const ['mod_banking_contemporary_services', 'mod_banking_investment_contemporary'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_banking_contemporary_services',
        courseId: courseId,
        title: 'الوحدة الأولى: العمليات والخدمات المصرفية الإسلامية وصيغ التمويل',
        description: 'التكييف الفقهي للحسابات الجارية والاستثمارية، صيغ التمويل الإسلامي كالمرابحة والمشاركة، وأحكام البطاقات الائتمانية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_banking_accounts_deposits',
          'lsn_banking_islamic_financing',
          'lsn_banking_credit_cards',
        ],
      ),
      CourseModule(
        moduleId: 'mod_banking_investment_contemporary',
        courseId: courseId,
        title: 'الوحدة الثانية: فقه الاستثمار المعاصر: الأسهم، التأمين، والعملات الرقمية والتضخم',
        description: 'ضوابط تداول الأسهم والصكوك، الفرق بين التأمين التجاري والتكافلي، والنوازل النقدية الحديثة كالتضخم والعملات المشفرة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_banking_contemporary_services'],
        lessonIds: const [
          'lsn_banking_stocks_sukuk',
          'lsn_banking_takaful_insurance',
          'lsn_banking_crypto_inflation',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 7: الحسابات البنكية والودائع
    // -------------------------------------------------------------------------
    final evQardhManfaa = EvidenceLink.create(
      evidenceId: 'ev_bank_qardh_rule',
      evidenceKey: 'qawaid:qardh_manfaa',
      citation: 'الإجماع والقاعدة الفقهية: «كل قرض جر نفعاً مشروطاً فهو ربا»',
      sourceId: 'src_knowledge_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_banking_accounts_deposits',
      title: 'الحسابات البنكية الجارية والاستثمارية والتكييف الفقهي لفوائد الودائع',
      courseId: courseId,
      moduleId: 'mod_banking_contemporary_services',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mbk1_1',
          title: 'التكييف الفقهي للحساب الجاري',
          description: 'فهم الحساب الجاري باعتباره قرضاً مضموناً من العميل للبنك دون زيادة.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk1_2',
          title: 'التكييف الفقهي لحسابات الاستثمار',
          description: 'معرفة حسابات الاستثمار القائمة على عقد المضاربة الشرعية وتقاسم الأرباح والخسائر.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk1_3',
          title: 'حكم فوائد الودائع الثابتة في البنوك التقليدية',
          description: 'استيعاب إجماع المجامع الفقهية على أن الفوائد المحددة مقدماً هي عين ربا النسيئة المحرم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mbk1_1',
          title: 'التكييف الفقهي للحسابات الجارية',
          contentType: LearningContentType.explanation,
          content: 'أجمع الفقهاء المعاصرون على أن الحساب الجاري في البنوك يُكيّف فقهياً بأنه "قرض" من العميل للبنك، لأن البنك يضمن رد المبلغ كاملاً في أي لحظة ويتصرف فيه، وعليه:\n1. لا يجوز للبنك إعطاء أي زيادة مشروطة أو فائدة لصاحب الحساب الجاري لأن «كل قرض جر نفعاً فهو ربا».\n2. يجوز للبنك تقاضي رسوم إدارية وفعلية فقط مقابل دفاتر الشيكات أو إدارة الحساب.\n3. يجوز فتح الحساب الجاري في البنوك التقليدية لحفظ المال وتسيير المعاملات عند تعذر البنوك الإسلامية بشرط عدم أخذ الفوائد.',
          evidenceLinks: [evQardhManfaa],
          sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي والمعايير الشرعية لأيوفي (AAOIFI)',
        ),
        LessonSection.create(
          sectionId: 'sec_mbk1_2',
          title: 'حسابات الاستثمار وحكم فوائد البنوك الربوية',
          contentType: LearningContentType.scholarlyView,
          content: 'في البنوك الإسلامية، تُكيّف الودائع الاستثمارية على أنها عقد "مضاربة شرعية": يقدم العميل المال (رب المال) والبنك يستثمره (المضارب)، وتوزع الأرباح بنسبة شائعة معلومة (كـ 70% للعميل و 30% للبنك). أما في البنوك التقليدية التي تضمن رأس المال وتمنح فائدة مئوية محددة مقدماً (كـ 10%)، فهذا ربا صريح محرم بإجماع الأمة؛ لأنه ضمان للمال مع زيادة مشروطة.',
          sourceAttribution: 'فتاوى اللجنة الدائمة ومجمع البحوث الإسلامية بالأزهر',
        ),
      ],
      sources: const ['src_knowledge_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 8: صيغ التمويل الإسلامي
    // -------------------------------------------------------------------------
    final evMurabahah = EvidenceLink.create(
      evidenceId: 'ev_bank_murabahah_ayah',
      evidenceKey: '2:275',
      citation: 'سورة البقرة: الآية 275 {وَأَحَلَّ اللَّهُ الْبَيْعَ}',
      sourceId: 'src_quran_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_banking_islamic_financing',
      title: 'صيغ التمويل الإسلامي: المرابحة للآمر بالشراء، المشاركة المتناقصة، والإجارة المنتهية بالتمليك',
      courseId: courseId,
      moduleId: 'mod_banking_contemporary_services',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mbk2_1',
          title: 'بيع المرابحة للآمر بالشراء وضوابطه',
          description: 'معرفة خطوات المرابحة المصرفية وشرط تملك البنك للسلعة وقبضها قبل بيعها للعميل.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk2_2',
          title: 'الإجارة المنتهية بالتمليك',
          description: 'فهم الفصل بين عقد الإجارة ووعد التمليك المستقل وأحكام الصيانة والضمان.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk2_3',
          title: 'المشاركة المتناقصة',
          description: 'استيعاب صيغة تملك الأصل بالتدريج وشراء حصص البنك في مشاريع الإسكان والاستثمار.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mbk2_1',
          title: 'المرابحة للآمر بالشراء والضوابط الشرعية الحاسمة',
          contentType: LearningContentType.explanation,
          content: 'المرابحة هي بيع سلعة بثمنها الأول مع ربح معلوم متفق عليه. وتتم في البنوك بالخطوات الآتية:\n1. طلب العميل من البنك شراء سلعة معينة مع الوعد بشرائها.\n2. يشتري البنك السلعة من البائع الأول لنفسه ويدخلها في ملكه وضمانه ويقبضها حقيقة أو حكماً.\n3. يبيعها البنك للعميل مرابحة بثمن مؤجل ومقسط.\nولا يجوز شرعاً أن يدفع البنك المال للعميل مباشرة، ولا أن يلزمه بالعقد قبل تملك البنك للسلعة؛ لأن ذلك يحول المعاملة إلى قرض ربوي صريح.',
          evidenceLinks: [evMurabahah],
          sourceAttribution: 'المعايير الشرعية لأيوفي (المعيار رقم 8) وبحوث فقه المعاملات للدكتور علي السالوس',
        ),
        LessonSection.create(
          sectionId: 'sec_mbk2_2',
          title: 'الإجارة المنتهية بالتمليك والمشاركة المتناقصة',
          contentType: LearningContentType.scholarlyView,
          content: '1. الإجارة المنتهية بالتمليك: أن يؤجر البنك عيناً (كعقار أو سيارة) للعميل بأجرة دورية، مع وعد منفصل بتمليكها له في نهاية المدة بهبة أو بثمن رمزي، ويشترط أن يتحمل البنك (المؤجر) ضمان الأصل والتلف غير المتعدى فيه، وتكون صيانة التشغيل على العميل.\n2. المشاركة المتناقصة: يشترك البنك والعميل في تملك أصل بنسب محددة، ثم يشتري العميل حصة البنك تدريجياً حتى يصبح الأصل ملكاً خالصاً له بالكامل.',
          sourceAttribution: 'قرارات مجمع الفقه الإسلامي بجدة',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 9: البطاقات الائتمانية والصرف الإلكتروني
    // -------------------------------------------------------------------------
    final evSarfHadith = EvidenceLink.create(
      evidenceId: 'ev_bank_sarf_taqabud',
      evidenceKey: 'bukhari:2061',
      citation: 'صحيح البخاري: «فإذا اختلف الجنسان فبيعوا كيف شئتم يداً بيد»',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_banking_credit_cards',
      title: 'البطاقات الائتمانية: أنواعها، غرامات التأخير، وضوابط الصرف وتحويل العملات',
      courseId: courseId,
      moduleId: 'mod_banking_contemporary_services',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mbk3_1',
          title: 'أنواع البطاقات البنكية المعاصرة',
          description: 'التمييز بين بطاقات الخصم الفوري (Debit)، والبطاقات مسبقة الدفع، والبطاقات الائتمانية (Credit).',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk3_2',
          title: 'حكم غرامات التأخير في البطاقات الائتمانية',
          description: 'معرفة أن فرض غرامة مالية على التأخر في السداد هو عين ربا الجاهلية المحرم.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk3_3',
          title: 'أحكام الصرف والتقابض الحكمي عند الشراء الدولي',
          description: 'استيعاب حكم القيد المصرفي الفوري كتقابض حكمي مجزئ عند اختلاف العملات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mbk3_1',
          title: 'أحكام البطاقات الائتمانية وحرمة غرامة التأخير',
          contentType: LearningContentType.explanation,
          content: 'تنقسم البطاقات إلى ثلاثة أقسام:\n1. بطاقات الخصم المباشر (Debit Card): مباحة بالإجماع لأن السحب من رصيد العميل ذاته.\n2. البطاقات الائتمانية المغطاة مسبقاً (Prepaid): جائزة ولا حرج فيها.\n3. البطاقات الائتمانية غير المغطاة (Credit Card): يجوز إصدارها واستخدامها بشرط خلو العقد من أي اشتراط لفوائد أو غرامات تأخير عند العجز عن السداد؛ فإن تضمن العقد شرط فوائد تأخير فهو عقد ربوي باطل ومحرم شرعاً.',
          sourceAttribution: 'قرار مجمع الفقه الإسلامي الدولي رقم 108',
        ),
        LessonSection.create(
          sectionId: 'sec_mbk3_2',
          title: 'الصرف الإلكتروني والتقابض الحسابي المعاصر',
          contentType: LearningContentType.scholarlyView,
          content: 'عند شراء سلع بعملة أجنبية عبر البطاقات أو إجراء تحويلات دولية، يحصل عقد "صرف" بين عملتين. وقد أفتت المجامع الفقهية بأن القيد الحسابي الإلكتروني الفوري في حساب العميل والتاجر يُعد "تقابضاً حكمياً" يقوم مقام القبض الحسي يداً بيد، مما يرفع الحرج ويحقق الشروط الشرعية لتبادل العملات.',
          evidenceLinks: [evSarfHadith],
          sourceAttribution: 'المعايير الشرعية لأيوفي (معيار الصرف رقم 1)',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 10: الأسهم والصكوك والاستثمار
    // -------------------------------------------------------------------------
    final evSharika = EvidenceLink.create(
      evidenceId: 'ev_bank_sharika_hadith',
      evidenceKey: 'abudawood:3383',
      citation: 'سنن أبي داود: «أنا ثالث الشريكين ما لم يخن أحدهما صاحبه»',
      sourceId: 'src_hadith_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_banking_stocks_sukuk',
      title: 'فقه الأسهم والصناديق الاستثمارية والصكوك الإسلامية وتطهير الأرباح',
      courseId: courseId,
      moduleId: 'mod_banking_investment_contemporary',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mbk4_1',
          title: 'حقيقة السهم والفرق بينه وبين السند',
          description: 'معرفة أن السهم حصة شائعة في شركة حقيقية، بينما السند قرض ربوي بفائدة محرمة.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk4_2',
          title: 'تصنيف الشركات المساهمة والضوابط الشرعية',
          description: 'التمييز بين الشركات النقية والشركات المحرمة والشركات المختلطة وضوابط تطهير أرباحها.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk4_3',
          title: 'حقيقة الصكوك الإسلامية',
          description: 'فهم الصكوك كشهادات تمثل ملكية أعيان أو منافع مؤجرة متوافقة مع الشريعة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mbk4_1',
          title: 'الأسهم والسندات: الأصل والفرق الجوهري',
          contentType: LearningContentType.explanation,
          content: '1. السهم: يمثل حصة شائعة في أصول الشركة ورأس مالها، فيربح المساهم من نمو الشركة وتوزيعاتها ويتحمل خسارتها، وهو مباح في أصله إذا كان نشاط الشركة مباحاً.\n2. السند: يمثل صك قرض بفائدة ثابتة مضمونة، وهو ربا صريح محرم باتفاق كافة المجامع والفقهاء.\n3. الصكوك الإسلامية: وثائق متساوية القيمة تمثل حصصاً شائعة في ملكية أعيان أو منافع أو خدمات استثمارية فعلية، ولا يجوز فيها ضمان رأس المال أو عائد مقطوع من قبل جهة الإصدار.',
          evidenceLinks: [evSharika],
          sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي رقم 63 ورقم 178',
        ),
        LessonSection.create(
          sectionId: 'sec_mbk4_2',
          title: 'ضوابط الاستثمار في الأسهم وقواعد التطهير',
          contentType: LearningContentType.scholarlyView,
          content: 'وضع العلماء المعاصرون ضوابط للشركات التي يكون أصل نشاطها مباحاً ولكن تخالطها معاملات ربوية يسيرة كالاقتراض أو الإيداع بفوائد:\n1. ألا تتجاوز القروض الربوية نسبة معينة (عادة 30% أو 33% من القيمة السوقية أو الأصول).\n2. ألا يتجاوز الإيراد المحرم نسبة 5% من مجمل إيرادات الشركة.\n3. وجوب "تطهير" الأرباح بإخراج النسبة المحرمة والتخلص منها بدفعها في وجوه البر العامة دون نية الأجر والصدقة الخاصة.',
          sourceAttribution: 'المعايير الشرعية لأيوفي (معيار الأسهم رقم 21)',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 11: فقه التأمين التجاري والتكافلي
    // -------------------------------------------------------------------------
    final evTaawun = EvidenceLink.create(
      evidenceId: 'ev_bank_taawun_ayah',
      evidenceKey: '5:2',
      citation: 'سورة المائدة: الآية 2 {وَتَعَاوَنُوا عَلَى الْبِرِّ وَالتَّقْوَىٰ}',
      sourceId: 'src_quran_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_banking_takaful_insurance',
      title: 'فقه التأمين: الفرق الجوهري بين التأمين التجاري القائم على الغرر والتأمين التكافلي التعاوني',
      courseId: courseId,
      moduleId: 'mod_banking_investment_contemporary',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mbk5_1',
          title: 'حقيقة التأمين التجاري وأسباب تحريمه',
          description: 'معرفة علة تحريم التأمين التجاري لاشتماله على الغرر الفاحش والقمار وربا الفضل والنسيئة.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk5_2',
          title: 'حقيقة التأمين التكافلي التعاوني البديل',
          description: 'فهم التأمين التكافلي القائم على التبرع والتعاون وتوزيع الفائض التأميني على المشتركين.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk5_3',
          title: 'حكم التأمين الإلزامي بقوة القانون',
          description: 'استيعاب حكم الاضطرار للتأمين الإلزامي كتأمين المركبات ورخصة ارتكاب ذلك عند الإلزام.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mbk5_1',
          title: 'علل تحريم التأمين التجاري التقليدي',
          contentType: LearningContentType.explanation,
          content: 'صدرت فتاوى مجمع الفقه الإسلامي وهيئة كبار العلماء بتحريم عقود التأمين التجاري بجميع صوره (على الحياة والسيارات والأموال) لاشتماله على علل كبرى:\n1. الغرر الفاحش: فالمستأمن يدفع قسطاً ولا يدري هل يقع الحادث فيأخذ أكثر مما دفع أم لا يقع فيخسر ماله.\n2. القمار والميسر: معاوضة مالية مبنية على المجازفة والمصادفة المحضة.\n3. الربا: مبادلة نقد بنقد مؤجل متفاضل عند تعويض الشركة بأكثر مما دفع العميل.',
          sourceAttribution: 'قرار مجمع الفقه الإسلامي الدولي رقم 9 وهيئة كبار العلماء بالمملكة',
        ),
        LessonSection.create(
          sectionId: 'sec_mbk5_2',
          title: 'التأمين التكافلي التعاوني الإسلامي البديل',
          contentType: LearningContentType.scholarlyView,
          content: 'البديل الشرعي هو "التأمين التعاوني التكافلي"؛ حيث يتفق المشتركون على دفع اشتراكات تبرعية في صندوق مستقل، يُخصص للتعويض عن الكوارث والمصائب التي تصيب أحدهم من باب الإرفاق والتعاون على البر والتقوى، ولا تملك شركة التأمين أموال الصندوق وإنما تديره بأجر معلوم أو مضاربة، وما يتبقى من فوائض يوزع على المشتركين لا على المساهمين.',
          evidenceLinks: [evTaawun],
          sourceAttribution: 'المعايير الشرعية لأيوفي (معيار التأمين الإسلامي رقم 26)',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 12: النوازل النقدية: التضخم والعملات الرقمية
    // -------------------------------------------------------------------------
    final evDinar = EvidenceLink.create(
      evidenceId: 'ev_bank_dinar_hadith',
      evidenceKey: 'bukhari:3643',
      citation: 'صحيح البخاري: حديث عروة بن الجعد في شراء شاة بدينار وتغير الأسعار',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_banking_crypto_inflation',
      title: 'النوازل النقدية الحديثة: التضخم والديون، والعملات المشفرة والتعاملات الرقمية',
      courseId: courseId,
      moduleId: 'mod_banking_investment_contemporary',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mbk6_1',
          title: 'أثر التضخم وانخفاض العملة على الديون المؤجلة',
          description: 'معرفة وجوب قضاء الديون بمثلها عدداً لا بقيمتها ما لم يبلغ الانهيار حداً فاحشاً.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk6_2',
          title: 'التكييف الفقهي للعملات الرقمية المشفرة (Cryptocurrency)',
          description: 'استيعاب موقف المجامع الفقهية المعاصرة من العملات المشفرة وتذبذبها الشديد ومخاطرها.',
        ),
        LearningObjective(
          objectiveId: 'obj_mbk6_3',
          title: 'المحافظ الإلكترونية والوساطة المالية الرقمية',
          description: 'فهم الضوابط الشرعية للمحافظ والتطبيقات والتحويلات اللحظية الحديثة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mbk6_1',
          title: 'التضخم والديون المؤجلة وحكم ربطها بجدول الغلاء',
          contentType: LearningContentType.explanation,
          content: 'أكدت المجامع الفقهية أن الديون الثابتة في الذمة بعملة ورقية يجب قضاؤها بمثلها قدراً لا بقيمتها وقت الاقتراض، ولا يجوز ربط الديون بجدول غلاء المعيشة أو أسعار الذهب لأن ذلك ذريعة للربا والزيادة المشروطة. أما إذا انهارت العملة تماماً وبطل التعامل بها، فيُصار إلى الصلح والتحكيم العادل أو تقويمها بأقرب الأوقات قبل الكساد الفاحش.',
          sourceAttribution: 'قرار مجمع الفقه الإسلامي الدولي رقم 42 ورقم 115',
        ),
        LessonSection.create(
          sectionId: 'sec_mbk6_2',
          title: 'العملات المشفرة (كالبيتكوين) وضوابط النقدية',
          contentType: LearningContentType.scholarlyView,
          content: 'اختلف الفقهاء المعاصرون في العملات المشفرة اللامركزية:\n1. ذهبت دور الإفتاء الرسمية والمجامع الفقهية إلى المنع والتحريم لغياب الرقابة السيادية والتذبذب الشديد والغرر المفرط واستعمالها في غسل الأموال وتضييع الثروات.\n2. فصّل آخرون بجواز تداولها إذا كانت أصولاً رقمية مدعومة بمشاريع حقيقية ومنضبطة دون مضاربات وهمية، مع التحذير البالغ من الميسر والقمار الإلكتروني.',
          evidenceLinks: [evDinar],
          sourceAttribution: 'بحوث مجمع الفقه الإسلامي بجدة ودار الإفتاء المصرية',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_knowledge_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: العمليات المصرفية وصيغ التمويل
    final q1 = QuizQuestion.create(
      questionId: 'q_bank_1',
      lessonId: 'lsn_banking_islamic_financing',
      questionText: 'ما هو الشرط الجوهري لصحة بيع المرابحة للآمر بالشراء في البنك الإسلامي؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qbk1_1', text: 'أن يشتري البنك السلعة ويدخلها في ملكه وضمانه قبل أن يبيعها للعميل'),
        QuizOption(optionId: 'opt_qbk1_2', text: 'أن يعطي البنك المبلغ نقداً للعميل ليشتري السلعة بنفسه مباشرة مع زيادة الفائدة'),
        QuizOption(optionId: 'opt_qbk1_3', text: 'أن يلزم العميل بعقد البيع قبل أن يجد البنك السلعة في السوق'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يشترط لصحة المرابحة المصرفية أن يتملك البنك السلعة ويدخلها في ضمانه، ثم يبيعها للعميل مرابحة منعاً لبيوع الديون الصورية الربوية.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_banking_services_financing',
      lessonId: 'lsn_banking_islamic_financing',
      title: 'اختبار العمليات المصرفية وصيغ التمويل الإسلامي والبطاقات',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: فقه الاستثمار والأسهم والتأمين
    final q2 = QuizQuestion.create(
      questionId: 'q_bank_2',
      lessonId: 'lsn_banking_takaful_insurance',
      questionText: 'ما هو الفارق الجوهري بين التأمين التجاري المحرم والتأمين التكافلي التعاوني الجائز شرعاً؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qbk2_1', text: 'التأمين التكافلي مبني على التبرع والتعاون وإرجاع الفائض التأميني للمشتركين، بينما التجاري معاوضة قائمة على الغرر وربح الشركة'),
        QuizOption(optionId: 'opt_qbk2_2', text: 'التأمين التجاري لا يأخذ أقساطاً مالية بينما التكافلي يأخذ أرباحاً ربوية'),
        QuizOption(optionId: 'opt_qbk2_3', text: 'لا يوجد أي فرق بينهما فكلاهما عقد تجاري بحت'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يقوم التأمين التكافلي على التبرع والتعاون في صندوق تأميني لا تملكه الشركة، ويعود فائضه للمشتركين، بخلاف التجاري القائم على الغرر والمقامرة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_banking_investment_contemporary',
      lessonId: 'lsn_banking_takaful_insurance',
      title: 'اختبار فقه الاستثمار والأسهم والصكوك والتأمين التكافلي والنوازل',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
