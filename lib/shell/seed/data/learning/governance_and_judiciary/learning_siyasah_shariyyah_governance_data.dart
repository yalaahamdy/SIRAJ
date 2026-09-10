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

/// بيانات مقرر السياسة الشرعية وأنظمة الحكم الرشيد وإدارة الشأن العام (6 دروس تأصيلية + اختباران استيعاب)
class LearningSiyasahShariyyahGovernanceData {
  static const String courseId = 'course_siyasah_shariyyah_governance';
  static const String pathId = 'path_governance_judiciary_rights_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر السياسة الشرعية وأنظمة الحكم الرشيد وإدارة الشأن العام',
      description: 'دراسة تأصيلية فقهية لأصول السياسة الشرعية، معالم الحكم الرشيد في الإسلام، نظام الشورى وفصل وتكامل السلطات، إدارة وحماية المال العام، الرقابة الإدارية والمجتمعية، وتجريم الفساد والرشوة وحماية النزاهة العامة.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_governance_siyasah_shura', 'mod_governance_public_funds_integrity'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_governance_siyasah_shura',
        courseId: courseId,
        title: 'الوحدة الأولى: قواعد السياسة الشرعية وإمامة المسلمين ونظام الشورى',
        description: 'بيان حقيقة السياسة الشرعية، تصرفات الحاكم بالمصلحة، مقاصد عقد الإمامة، مبدأ الشورى القرآني، والتكامل المؤسسي وفصل السلطات.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_governance_siyasah_principles_maslahah',
          'lsn_governance_imamah_allegiance_responsibility',
          'lsn_governance_shura_institutional_balance',
        ],
      ),
      CourseModule(
        moduleId: 'mod_governance_public_funds_integrity',
        courseId: courseId,
        title: 'الوحدة الثانية: إدارة المال العام، حماية المصالح، ومكافحة الفساد',
        description: 'تأصيل حرمة المال العام، ديوان المظالم والرقابة الإدارية والمجتمعية، ومكافحة الرشوة واستغلال النفوذ وحماية النزاهة والشفافية.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_governance_siyasah_shura'],
        lessonIds: const [
          'lsn_governance_public_wealth_stewardship',
          'lsn_governance_administrative_audit_mazalim',
          'lsn_governance_anti_corruption_bribery_prevention',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: مفهوم السياسة الشرعية وضوابط التصرف بالمصلحة
    // -------------------------------------------------------------------------
    final evSiyasahQuran = EvidenceLink.create(
      evidenceId: 'ev_siyasah_quran_amr',
      evidenceKey: '4:59',
      citation: 'سورة النساء: الآية 59 {يَا أَيُّهَا الَّذِينَ آمَنُوا أَطِيعُوا اللَّهَ وَأَطِيعُوا الرَّسُولَ وَأُولِي الْأَمْرِ مِنكُمْ}',
      sourceId: 'src_quran_canonical',
    );
    final evMaslahahRuleHadith = EvidenceLink.create(
      evidenceId: 'ev_siyasah_maslahah_rule',
      evidenceKey: 'shafii:rule:tassarruf',
      citation: 'القاعدة الفقهية: «تَصَرُّفُ الإِمَامِ عَلَى الرَّعِيَّةِ مَنُوطٌ بِالمَصْلَحَةِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_governance_siyasah_principles_maslahah',
      title: 'مفهوم السياسة الشرعية ونطاقها وضابط تصرف الحاكم بالمصلحة المرسلة',
      courseId: courseId,
      moduleId: 'mod_governance_siyasah_shura',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_gov1_1',
          title: 'تعريف السياسة الشرعية وحقيقتها',
          description: 'استيعاب تعريف ابن عقيل وابن القيم للسياسة الشرعية: كل ما كان فعلاً يكون معه الناس أقرب إلى الصلاح وأبعد عن الفساد.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov1_2',
          title: 'قاعدة تصرف الإمام منوط بالمصلحة',
          description: 'فهم القاعدة الأصولية الكبرى الحاكمة لسلطات الحاكم والدولة بأنها مقيدة بجلب المصالح ودرء المفاسد العامة.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov1_3',
          title: 'التفريق بين السياسة العادلة والسياسة الظالمة',
          description: 'التمييز الدقيق بين السياسة الشرعية القائمة على العدل والمقاصد وبين الاستبداد والهوى باسم المصلحة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_gov1_1',
          title: 'التعريف الجامع للسياسة الشرعية ومجالها',
          contentType: LearningContentType.sourceText,
          content: 'السياسة الشرعية هي تدبير الشؤون العامة للدولة الإسلامية بما يحقق مصلحة الأمة ويدرأ عنها المفاسد بما لا يخالف نصوص الشريعة وقواعدها الكلية. ونقل ابن القيم تعريف ابن عقيل الحنبلي الرائع: «السياسة ما كان فعلاً يكون معه الناس أقرب إلى الصلاح وأبعد عن الفساد، وإن لم يضعه الرسول ولا نزل به وحي»، خلافاً لمن قصر تدبير الدولة على النصوص الحرفية الضيقة.',
          evidenceLinks: [evSiyasahQuran, evMaslahahRuleHadith],
          sourceAttribution: 'الطرق الحكمية في السياسة الشرعية لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_gov1_2',
          title: 'قاعدة: «تصرف الإمام على الرعية منوط بالمصلحة»',
          contentType: LearningContentType.explanation,
          content: 'قرر أئمة الفقه (كالشافعي والقرافي والسيوطي) أن تصرفات ولي الأمر والسلطة الحاكمة ليست مطلقة في الأهواء والتشهي، بل هي ولاية أمانة ونظر؛ فلا ينفذ تصرف الحاكم ولا يصح إلا إذا كان محققاً لمصلحة عامة حقيقية أو راجحة للرعية؛ فإن تعرى عن المصلحة أو خص به أقرباءه ومحاسيبه كان تصرفاً باطلاً ومحاسباً عليه شرعاً.',
          sourceAttribution: 'الأشباه والنظائر للسيوطي وقواعد الأحكام للعز بن عبد السلام',
        ),
        LessonSection.create(
          sectionId: 'sec_gov1_3',
          title: 'مرونة السياسة الشرعية في المتغيرات التنظيمية',
          contentType: LearningContentType.explanation,
          content: 'تتسع السياسة الشرعية لسن الأنظمة والقوانين المعاصرة (كاللوائح المرورية، الضوابط البيئية، قوانين التجارة والجمارك، وأنظمة البناء)، فهذه كلها من المباحات والمصالح المرسلة التي يجوز لولي الأمر تنظيمها وإلزام الناس بها تحقيقاً للنظام العام وصيانة للأرواح والأموال.',
          sourceAttribution: 'السياسة الشرعية في إصلاح الراعي والرعية لابن تيمية',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: عقد الإمامة وولاية الأمر والبيعة وميثاق المسؤولية
    // -------------------------------------------------------------------------
    final evImamahQuran = EvidenceLink.create(
      evidenceId: 'ev_siyasah_imamah_quran_nisaa',
      evidenceKey: '4:58',
      citation: 'سورة النساء: الآية 58 {إِنَّ اللَّهَ يَأْمُرُكُمْ أَن تُؤَدُّوا الْأَمَانَاتِ إِلَىٰ أَهْلِهَا}',
      sourceId: 'src_quran_canonical',
    );
    final evRaiyyahHadith = EvidenceLink.create(
      evidenceId: 'ev_siyasah_raiyyah_hadith_bukhari',
      evidenceKey: 'bukhari:893',
      citation: 'صحيح البخاري: «كُلُّكُمْ رَاعٍ وَكُلُّكُمْ مَسْئُولٌ عَنْ رَعِيَّتِهِ، الإِمَامُ رَاعٍ وَمَسْئُولٌ عَنْ رَعِيَّتِهِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_governance_imamah_allegiance_responsibility',
      title: 'عقد الإمامة وولاية الأمر: شروطها، واجبات الحاكم وحقوقه، والبيعة ميثاق مسؤولية',
      courseId: courseId,
      moduleId: 'mod_governance_siyasah_shura',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_gov2_1',
          title: 'مقاصد عقد الإمامة الكبرى',
          description: 'إدراك غاية نصب الحاكم: حراسة الدين وسياسة الدنيا به وحفظ ثغور الأمة.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov2_2',
          title: 'مفهوم البيعة الشرعية وميثاقها',
          description: 'فهم البيعة باعتبارها عقداً وميثاقاً تبادلياً بين الأمة والحاكم على السمع والطاعة في المعروف والعدل.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov2_3',
          title: 'قاعدة «لا طاعة لمخلوق في معصية الخالق»',
          description: 'معرفة حدود طاعة الحاكم وأنها مقيدة بالمعروف والتحذير من الطاعة العمياء في المحرمات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_gov2_1',
          title: 'مقاصد الإمامة العظمى وموقعها في الفقه الإسلامي',
          contentType: LearningContentType.sourceText,
          content: 'نصب الإمام فرض كفاية عند جماهير المسلمين؛ والغاية من ولاية الحكم لخصها الماوردي في قوله: «الإمامة موضوعة لخلافة النبوة في حراسة الدين وسياسة الدنيا به». فواجبات الحاكم: إقامة الصلاة وإيتاء الزكاة، تحصين الثغور، نصرة المظلوم، قسمة الأموال بالعدل، وتعيين الأكفاء الأمناء.',
          evidenceLinks: [evImamahQuran, evRaiyyahHadith],
          sourceAttribution: 'الأحكام السلطانية للماوردي وأبي يعلى',
        ),
        LessonSection.create(
          sectionId: 'sec_gov2_2',
          title: 'البيعة الشرعية: عقد وكالة وميثاق متبادل',
          contentType: LearningContentType.explanation,
          content: 'البيعة في الفقه الإسلامي الرشيد هي عقد رضائي وميثاق شرعي ملزم بين الأمة (أو ممثليها من أهل الحل والعقد) وبين الحاكم؛ يلتزم فيه الحاكم بالحكم بكتاب الله وسنة نبيه والعدل ورعاية المصالح، وتلتزم فيه الأمة بالسمع والطاعة في المعروف والنصرة والنصيحة الصادقة.',
          sourceAttribution: 'مقدمة ابن خلدون ونظام الحكم في الشريعة والتاريخ',
        ),
        LessonSection.create(
          sectionId: 'sec_gov2_3',
          title: 'ضوابط الطاعة الشرعية وحدودها القطعية',
          contentType: LearningContentType.explanation,
          content: 'طاعة ولي الأمر فريضة شرعية لجمع الكلمة وحقن الدماء ومنع الفوضى؛ ولكنها ليست طاعة مطلقة، بل هي مقيدة بقيد قطعي أعلنه رسول الله ﷺ: «إنما الطاعة في المعروف»، وقوله: «لا طاعة لمخلوق في معصية الخالق». فإذا أمر الحاكم بمعصية صريحة كأكل مال حرام أو سفك دم معصوم، لم تجز طاعته في تلك المعصية مع بقاء أصل الجماعة.',
          sourceAttribution: 'منهاج السنة النبوية وشرح العقيدة الطحاوية',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: الشورى في الإسلام والتكامل بين السلطات
    // -------------------------------------------------------------------------
    final evShuraQuran1 = EvidenceLink.create(
      evidenceId: 'ev_siyasah_shura_quran_shura',
      evidenceKey: '42:38',
      citation: 'سورة الشورى: الآية 38 {وَأَمْرُهُمْ شُورَىٰ بَيْنَهُمْ}',
      sourceId: 'src_quran_canonical',
    );
    final evShuraQuran2 = EvidenceLink.create(
      evidenceId: 'ev_siyasah_shura_quran_imran',
      evidenceKey: '3:159',
      citation: 'سورة آل عمران: الآية 159 {وَشَاوِرْهُمْ فِي الْأَمْرِ ۖ فَإِذَا عَزَمْتَ فَتَوَكَّلْ عَلَى اللَّهِ}',
      sourceId: 'src_quran_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_governance_shura_institutional_balance',
      title: 'الشورى في الإسلام: أصلها القرآني والنبوي، أدواتها وتطبيقاتها المعاصرة، والفصل والتكامل بين السلطات',
      courseId: courseId,
      moduleId: 'mod_governance_siyasah_shura',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_gov3_1',
          title: 'أصل الشورى ومكانتها الإلزامية',
          description: 'إدراك كون الشورى مبدأ دستورياً أصيلاً وصفة لازمة للمؤمنين وأسلوب حياة ومنهاج حكم.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov3_2',
          title: 'نماذج الشورى النبوية وفي العهد الراشدي',
          description: 'استخلاص الدروس من مشاورة النبي ﷺ لأصحابه في بدر وأحد والخندق ومشاورة الخلفاء لأهل الرأي.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov3_3',
          title: 'مؤسسات الشورى المعاصرة والفصل المتوازن بين السلطات',
          description: 'بيان كيفية ترجمة الشورى إلى مجالس نيابية وبرلمانية وهيئات رقابية تكفل الشفافية والتوازن المؤسسي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_gov3_1',
          title: 'مبدأ الشورى الدستوري في القرآن والسنة',
          contentType: LearningContentType.sourceText,
          content: 'أعلى القرآن شأن الشورى فقرنها بالصلاة والإنفاق في قوله تعالى: ﴿وَالَّذِينَ اسْتَجَابُوا لِرَبِّهِمْ وَأَقَامُوا الصَّلَاةَ وَأَمْرُهُمْ شُورَىٰ بَيْنَهُمْ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ﴾، وأمر نبيه المعصوم بها فقال: ﴿وَشَاوِرْهُمْ فِي الْأَمْرِ﴾. وكان النبي ﷺ أكثر الناس مشورة لأصحابه في الحرب والسلم والمفاوضات وشؤون المجتمع تدريباً للأمة على المشاركة وتحمل المسؤولية.',
          evidenceLinks: [evShuraQuran1, evShuraQuran2],
          sourceAttribution: 'جامع البيان للطبري وتفسير القرطبي',
        ),
        LessonSection.create(
          sectionId: 'sec_gov3_2',
          title: 'أهل الشورى (أهل الحل والعقد) وشروطهم',
          contentType: LearningContentType.explanation,
          content: 'أهل الشورى هم أهل الحل والعقد وذوو الخبرة في كل تخصص من العلماء، والخبراء الاقتصاديين، والقادة العسكريين، ووجهاء المجتمع والأمناء. ويشترط فيهم: العدالة، العلم والخبرة التخصصية، والغيرة على مصالح الأمة، والصدق في إبداء الرأي دون نفاق ولا خوف.',
          sourceAttribution: 'الفقه السياسي الإسلامي والسياسة الشرعية',
        ),
        LessonSection.create(
          sectionId: 'sec_gov3_3',
          title: 'الفصل والتكامل بين السلطات ومنع الاستبداد',
          contentType: LearningContentType.explanation,
          content: 'عرفت الدولة الإسلامية تاريخياً تمايزاً وتكاملاً بين السلطات: السلطة القضائية المستقلة (القضاء والمظالم)، السلطة التنفيذية (الولاة والوزراء)، وسلطة التشريع والفتوى (العلماء المجتهدون وأهل الشورى). وتطوير هذه الآليات إلى مؤسسات برلمانية ودستورية رقابية معاصرة يحقق المقصد الشرعي في درء الاستبداد وصيانة الحقوق.',
          sourceAttribution: 'معالم الخلافة في الفكر الإسلامي للدكتور وهبة الزحيلي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: إدارة المال العام وأموال الدولة في الإسلام
    // -------------------------------------------------------------------------
    final evMalQuran = EvidenceLink.create(
      evidenceId: 'ev_siyasah_mal_quran_hashr',
      evidenceKey: '59:7',
      citation: 'سورة الحشر: الآية 7 {كَيْ لَا يَكُونَ دُولَةً بَيْنَ الْأَغْنِيَاءِ مِنكُمْ}',
      sourceId: 'src_quran_canonical',
    );
    final evGhululHadith = EvidenceLink.create(
      evidenceId: 'ev_siyasah_ghulul_hadith_bukhari',
      evidenceKey: 'bukhari:3073',
      citation: 'صحيح البخاري: «إِنَّ رِجَالًا يَتَخَوَّضُونَ فِي مَالِ اللَّهِ بِغَيْرِ حَقٍّ، فَلَهُمُ النَّارُ يَوْمَ القِيَامَةِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_governance_public_wealth_stewardship',
      title: 'إدارة المال العام وأموال الدولة في الإسلام وحرمة التعدي عليه ورعاية المرافق',
      courseId: courseId,
      moduleId: 'mod_governance_public_funds_integrity',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_gov4_1',
          title: 'حرمة وقداسة المال العام',
          description: 'إدراك أن حرمة المال العام أشد من حرمة المال الخاص لتعلقه بحقوق الأمة بأسرها.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov4_2',
          title: 'موارد بيت المال وضوابط الإنفاق الحكومي',
          description: 'معرفة موارد الخزانة العامة للدولة وضوابط صرفها في المشاريع التنموية والخدمية والمرافق العامة.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov4_3',
          title: 'وعيد التخوض في مال الأمة والغلول',
          description: 'استيعاب الوعيد النبوي الشديد لمن يختلس أو يهدر أموال الدولة بغير حق.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_gov4_1',
          title: 'قداسة المال العام وكونه ملكاً للأمة',
          contentType: LearningContentType.sourceText,
          content: 'المال في الرؤية الإسلامية مال الله، والإنسان مستخلف فيه؛ والمال العام للدولة هو حق مشترك لكافة أفراد الأمة وأجيالها القادمة. وقد حذر النبي ﷺ تحذيراً قاطعاً من العبث به فقال: «إن رجالاً يتخوضون في مال الله بغير حق فلهم النار يوم القيامة». والتعدي على المال العام غلول وسرقة من المجتمع بأسره.',
          evidenceLinks: [evMalQuran, evGhululHadith],
          sourceAttribution: 'الأموال لأبي عبيد القاسم بن سلام',
        ),
        LessonSection.create(
          sectionId: 'sec_gov4_2',
          title: 'ضوابط الإنفاق العام والأولويات التنموية',
          contentType: LearningContentType.explanation,
          content: 'يخضع الإنفاق العام لقواعد شرعية صارمة: 1- الأسبقية للضروريات والحاجيات العامة على التحسينيات الترفية. 2- العدالة في توزيع الخدمات والمشاريع بين الأقاليم والفئات. 3- منع الإسراف والبذخ في المنشآت الحكومية. 4- تحريم توجيه المال العام لمصالح شخصية للحكام وأعوانهم.',
          sourceAttribution: 'الخراج لأبي يوسف والسياسة الشرعية',
        ),
        LessonSection.create(
          sectionId: 'sec_gov4_3',
          title: 'حماية المرافق والممتلكات العامة والمحميات',
          contentType: LearningContentType.explanation,
          content: 'أصل النبي ﷺ حماية الموارد العامة حين قال: «المسلمون شركاء في ثلاث: في الماء والكلأ والنار». وحرم الاعتداء على الطرق والمرافق والمياه والبيئة أو تلويثها أو احتكارها. والمحافظة على ممتلكات الدولة واجب ديني ووطني يسأل عنه كل مواطن.',
          sourceAttribution: 'الأموال لابن زنجويه وقواعد المصلحة العامة',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الرقابة الإدارية والمجتمعية وديوان المظالم
    // -------------------------------------------------------------------------
    final evHisbahQuran = EvidenceLink.create(
      evidenceId: 'ev_siyasah_hisbah_quran_tawbah',
      evidenceKey: '9:71',
      citation: 'سورة التوبة: الآية 71 {وَالْمُؤْمِنُونَ وَالْمُؤْمِنَاتُ بَعْضُهُمْ أَوْلِيَاءُ بَعْضٍ ۚ يَأْمُرُونَ بِالْمَعْرُوفِ وَيَنْهَوْنَ عَنِ الْمُنكَرِ}',
      sourceId: 'src_quran_canonical',
    );
    final evMinAynaHadith = EvidenceLink.create(
      evidenceId: 'ev_siyasah_min_ayna_hadith_bukhari',
      evidenceKey: 'bukhari:7174',
      citation: 'صحيح البخاري: «هَلَّا جَلَسْتَ فِي بَيْتِ أَبِيكَ وَأُمِّكَ حَتَّى تَأْتِيَكَ هَدِيَّتُكَ إِنْ كُنْتَ صَادِقًا!»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_governance_administrative_audit_mazalim',
      title: 'الرقابة الإدارية والمجتمعية، ديوان المظالم، ومبدأ «من أين لك هذا» في محاسبة المسؤولين',
      courseId: courseId,
      moduleId: 'mod_governance_public_funds_integrity',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_gov5_1',
          title: 'نشأة ولاية المظالم واختصاصاتها',
          description: 'معرفة مكانة ديوان المظالم (القضاء الإداري الأعلى) في رد عسف الولاة وتجاوزات الإدارة.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov5_2',
          title: 'تأصيل مبدأ «من أين لك هذا» النبوي والعمري',
          description: 'استيعاب التطبيق العملي لمساءلة الموظفين في تضخم أموالهم استناداً لحديث ابن اللتبية ومحاسبة عمر للولاة.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov5_3',
          title: 'الرقابة المجتمعية وحرية إبداء النصيحة',
          description: 'إدراك دور الأمة والمواطنين والإعلام الهادف في الرقابة والمناصحة وتصويب الأخطاء الإدارية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_gov5_1',
          title: 'ولاية المظالم: حارس العدالة ضد تعسف السلطة',
          contentType: LearningContentType.sourceText,
          content: 'ولاية المظالم هي أرقى صور القضاء الإداري؛ وهي ولاية تمتزج فيها هيبة السلطان وعدالة القضاء، وتختص بالفصل في مظالم الرعية ضد الحكام والولاة وأجهزة الدولة، واسترداد الأموال المغصوبة بغير حق من قبل المتنفذين. وقد مارسها الخلفاء الراشدون بأنفسهم، ثم أسس لها ديوان مستقل في عهد بني أمية والعباسيين.',
          evidenceLinks: [evHisbahQuran, evMinAynaHadith],
          sourceAttribution: 'الأحكام السلطانية للماوردي',
        ),
        LessonSection.create(
          sectionId: 'sec_gov5_2',
          title: 'التأصيل النبوي الصارم لمبدأ «من أين لك هذا؟»',
          contentType: LearningContentType.explanation,
          content: 'أرسى النبي ﷺ مبدأ الشفافية وإبراء الذمة المالية عندما استعمل ابن اللتبية على الصدقة فجاء وقال: هذا لكم وهذا أهدي إلي! فصعد ﷺ المنبر مغضباً وخطب: «ما بال العامل نبعثه فيقول هذا لكم وهذا أهدي إلي، فهلا جلس في بيت أبيه وأمه حتى تأتيه هديته إن كان صادقاً؟!». وطبق عمر بن الخطاب إقرار الذمة المالية وقاسم الولاة أموالهم التي تضخمت أثناء الولاية.',
          sourceAttribution: 'صحيح البخاري وفتوح البلدان للبلاذري',
        ),
        LessonSection.create(
          sectionId: 'sec_gov5_3',
          title: 'الرقابة الشعبية وفريضة النصيحة لولاة الأمور',
          contentType: LearningContentType.explanation,
          content: 'جعل الإسلام الرقابة المجتمعية أصلاً دينياً؛ لقوله ﷺ: «الدين النصيحة، قلنا: لمن يا رسول الله؟ قال: لله ولكتابه ولرسوله ولأئمة المسلمين وعامتهم». وللأمة حق مساءلة مسؤوليها وتقويم سياساتهم بالحق والحكمة دون إثارة فتن أو شغب، لضمان استقامة مسار الإدارة العامة.',
          sourceAttribution: 'جامع العلوم والحكم لابن رجب الحنبلي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: مكافحة الفساد وتجريم الرشوة واستغلال النفوذ
    // -------------------------------------------------------------------------
    final evCorruptionQuran = EvidenceLink.create(
      evidenceId: 'ev_siyasah_corruption_quran_baqarah',
      evidenceKey: '2:188',
      citation: 'سورة البقرة: الآية 188 {وَلَا تَأْكُلُوا أَمْوَالَكُم بَيْنَكُم بِالْبَاطِلِ وَتُدْلُوا بِهَا إِلَى الْحُكَّامِ لِتَأْكُلُوا فَرِيقًا مِّنْ أَمْوَالِ النَّاسِ بِالْإِثْمِ}',
      sourceId: 'src_quran_canonical',
    );
    final evBriberyHadith = EvidenceLink.create(
      evidenceId: 'ev_siyasah_bribery_hadith_tirmidhi',
      evidenceKey: 'tirmidhi:1337',
      citation: 'سنن الترمذي: «لَعَنَ رَسُولُ اللَّهِ ﷺ الرَّاشِيَ وَالمُرْتَشِيَ»',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_governance_anti_corruption_bribery_prevention',
      title: 'مكافحة الفساد الإداري والمالي: تجريم الرشوة، المحسوبية، واستغلال النفوذ وحماية النزاهة',
      courseId: courseId,
      moduleId: 'mod_governance_public_funds_integrity',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_gov6_1',
          title: 'تجريم الرشوة وأبعادها التدميرية',
          description: 'إدراك اللعن النبوي للراشي والمرتشي والرائش لما تسببه الرشوة من هدم العدالة وتفشي الظلم.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov6_2',
          title: 'تحريم المحسوبية والوساطة الظالمة والولاءات الشخصية',
          description: 'معرفة حكم إسناد الوظائف والمناصب لغير الأكفاء وخيانة الأمانة العامة لقرابة أو مصلحة.',
        ),
        LearningObjective(
          objectiveId: 'obj_gov6_3',
          title: 'منظومة حماية النزاهة والوقاية من الفساد',
          description: 'استيعاب آليات الإسلام في الوقاية من الفساد بوضع معايير الكفاءة، التكافل الوظيفي، والرقابة الصارمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_gov6_1',
          title: 'تجريم الرشوة وهدم منظومة العدالة',
          contentType: LearningContentType.sourceText,
          content: 'الرشوة هي بذل المال أو المنفعة لإبطال حق أو إحقاق باطل؛ وهي من أشنع الكبائر وجرائم الفساد. وقد جاء التغليظ القرآني الصريح ﴿وَلَا تَأْكُلُوا أَمْوَالَكُم بَيْنَكُم بِالْبَاطِلِ وَتُدْلُوا بِهَا إِلَى الْحُكَّامِ﴾ ولعن النبي ﷺ أطرافها الثلاثة: الراشي والمرتشي والرائش؛ لأنها تدمر الثقة المجتمعية وتحرم المستحقين.',
          evidenceLinks: [evCorruptionQuran, evBriberyHadith],
          sourceAttribution: 'تفسير ابن كثير والكبائر للذهبي',
        ),
        LessonSection.create(
          sectionId: 'sec_gov6_2',
          title: 'تحريم المحسوبية وإسناد الأمر لغير أهله',
          contentType: LearningContentType.explanation,
          content: 'اعتبر النبي ﷺ محاباة الأقارب في الوظائف العامة خيانة لله ولرسوله؛ فقال ﷺ: «من استعمل رجلاً من عصابة وفي تلك العصابة من هو أرضى لله منه فقد خان الله وخان رسوله وخان المؤمنين». وجعل ﷺ تقديم غير الأكفاء علامة على فساد العمران وخراب الدنيا فقال: «إذا وُسِّد الأمر إلى غير أهله فانتظر الساعة».',
          sourceAttribution: 'المستدرك على الصحيحين للحاكم وتاريخ الخلفاء',
        ),
        LessonSection.create(
          sectionId: 'sec_gov6_3',
          title: 'الاستراتيجية الإسلامية المتكاملة لمكافحة الفساد',
          contentType: LearningContentType.explanation,
          content: 'تقوم المنظومة الإسلامية للنزاهة على ثلاثة محاور: 1- المحور الإيماني والتربوي: استشعار مراقبة الله وخوف الحساب الأخروي. 2- المحور الاقتصادي والكفاية: إعطاء الموظفين كفايتهم من الرواتب ليغنوا عن التطلع لأموال الناس لقوله ﷺ: «من ولي لنا عملاً وليس له منزل فليتخذ منزلاً». 3- المحور الرقابي والعقابي: تفعيل أجهزة التفتيش وإيقاع العقوبات التعزيرية الصارمة والمصادرة الفورية للأموال المختلسة.',
          sourceAttribution: 'التشريع الجنائي الإسلامي ومكافحة الفساد',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: السياسة الشرعية والشورى
    final q1 = QuizQuestion.create(
      questionId: 'q_gov_1',
      lessonId: 'lsn_governance_siyasah_principles_maslahah',
      questionText: 'ما هي القاعدة الفقهية الأصولية الكبرى الحاكمة لقرارات وتصرفات ولي الأمر والدولة في الشأن العام؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qg1_1', text: '«تَصَرُّفُ الإِمَامِ عَلَى الرَّعِيَّةِ مَنُوطٌ بِالمَصْلَحَةِ» العامة الحقيقية أو الراجحة'),
        QuizOption(optionId: 'opt_qg1_2', text: 'للحاكم التصرف المطلق بحسب ما يراه له ولمعاونيه دون تقيد بمصلحة الأمة'),
        QuizOption(optionId: 'opt_qg1_3', text: 'منع سن أي نظام مروري أو إداري جديد لم يرد بنصه الحرفي في العهد النبوي'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قاعدة فقهية كبرى تضبط سلطة الحاكم بأن ولايته ولاية نظر وأمانة مقيدة بتحقيق مصالح الرعية ودرء المفاسد عنهم.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_governance_siyasah_shura',
      lessonId: 'lsn_governance_siyasah_principles_maslahah',
      title: 'اختبار السياسة الشرعية وإمامة المسلمين ونظام الشورى والعدالة',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: المال العام ومكافحة الفساد
    final q2 = QuizQuestion.create(
      questionId: 'q_gov_2',
      lessonId: 'lsn_governance_administrative_audit_mazalim',
      questionText: 'ماذا قال النبي ﷺ لعامل الصدقة (ابن اللُّتْبِيَّة) حين جاء وقال: «هذا لكم وهذا أُهْدِيَ إليّ»؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qg2_1', text: '«فَهَلَّا جَلَسْتَ فِي بَيْتِ أَبِيكَ وَأُمِّكَ حَتَّى تَأْتِيَكَ هَدِيَّتُكَ إِنْ كُنْتَ صَادِقًا!» تأصيلاً لمنع استغلال المنصب'),
        QuizOption(optionId: 'opt_qg2_2', text: 'أقره على أخذ الهدية واعتبرها حقه الخاص الكامل دون مساءلة'),
        QuizOption(optionId: 'opt_qg2_3', text: 'طلب منه التبرع بنصف الهدية فقط لبيت المال'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أنكر النبي ﷺ على العامل قبول الهدايا بحكم وظيفته واعتبرها غلولاً وفساداً، وهو الأصل التاريخي لمبدأ «من أين لك هذا؟».',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_governance_public_funds_integrity',
      lessonId: 'lsn_governance_administrative_audit_mazalim',
      title: 'اختبار إدارة المال العام وديوان المظالم ومكافحة الفساد والرشوة',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
