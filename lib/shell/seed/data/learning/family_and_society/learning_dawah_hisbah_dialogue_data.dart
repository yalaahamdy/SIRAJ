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

/// بيانات مقرر فقه الدعوة إلى الله والاحتساب والحوار الحضاري (6 دروس تأصيلية + اختباران استيعاب)
class LearningDawahHisbahDialogueData {
  static const String courseId = 'course_dawah_hisbah_dialogue';
  static const String pathId = 'path_family_ethics_society_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الدعوة إلى الله والاحتساب والحوار الحضاري',
      description: 'دراسة تأصيلية منهجية لأصول الدعوة إلى الله ومناهج الأنبياء: الحكمة والموعظة الحسنة، فقه الأمر بالمعروف والنهي عن المنكر وضوابط الاحتساب، أدب الحوار والمجادلة بالتي هي أحسن، واستثمار الوسائط الرقمية المعاصرة ودعوة غير المسلمين.',
      level: lp.LearningLevel.intermediate,
      moduleIds: const ['mod_dawah_principles_hisbah', 'mod_dawah_dialogue_media'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_dawah_principles_hisbah',
        courseId: courseId,
        title: 'الوحدة الأولى: أصول الدعوة ومناهج الأنبياء وفقه الأمر بالمعروف',
        description: 'بيان فضل الدعوة ومنطلقاتها، الحكمة والتدرج ومراعاة أحوال المخاطبين، وأركان وشروط الأمر بالمعروف والنهي عن المنكر ومراتب التغيير الشرعية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_dawah_prophetic_methods',
          'lsn_dawah_wisdom_gradualness',
          'lsn_dawah_hisbah_commanding_good',
        ],
      ),
      CourseModule(
        moduleId: 'mod_dawah_dialogue_media',
        courseId: courseId,
        title: 'الوحدة الثانية: مهارات التواصل والحوار والمجادلة بالتي هي أحسن والخطاب العالمي',
        description: 'قواعد الحوار والمناظرة في الإسلام، استثمار المنصات والوسائل الرقمية الحديثة في نشر الدين، وفقه التعارف والتعايش الإنساني ودعوة غير المسلمين.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_dawah_principles_hisbah'],
        lessonIds: const [
          'lsn_dawah_dialogue_debate_ethics',
          'lsn_dawah_digital_media_modern_tools',
          'lsn_dawah_non_muslims_coexistence',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: مفهوم الدعوة وفضلها ومناهج الأنبياء في البلاغ
    // -------------------------------------------------------------------------
    final evDawahQuran = EvidenceLink.create(
      evidenceId: 'ev_dawah_quran_fussilat',
      evidenceKey: '41:33',
      citation: 'سورة فصلت: الآية 33 {وَمَنْ أَحْسَنُ قَوْلًا مِّمَّن دَعَا إِلَى اللَّهِ وَعَمِلَ صَالِحًا وَقَالَ إِنَّنِي مِنَ الْمُسْلِمِينَ}',
      sourceId: 'src_quran_canonical',
    );
    final evDawahHadith = EvidenceLink.create(
      evidenceId: 'ev_dawah_hadith_bukhari',
      evidenceKey: 'bukhari:3701',
      citation: 'صحيح البخاري: «فَوَاللَّهِ لَأَنْ يَهْدِيَ اللَّهُ بِكَ رَجُلًا وَاحِدًا، خَيْرٌ لَكَ مِنْ أَنْ يَكُونَ لَكَ حُمْرُ النَّعَمِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_dawah_prophetic_methods',
      title: 'مفهوم الدعوة إلى الله وفضلها ومناهج الرسل الكرام في البلاغ والبيان',
      courseId: courseId,
      moduleId: 'mod_dawah_principles_hisbah',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_daw1_1',
          title: 'شرف مقام الدعوة إلى الله',
          description: 'استيعاب مكانة الدعوة إلى الله وأنها وظيفة الأنبياء والمرسلين وأشرف مقامات العبودية.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw1_2',
          title: 'عظيم فضل هداية الخلق',
          description: 'معرفة فضل هداية الخلق وعظيم الأجر المترتب على إرشاد الضالين.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw1_3',
          title: 'معالم منهج الأنبياء في الدعوة',
          description: 'استخلاص الدروس من صبر الرسل وثباتهم وإخلاصهم وبذلهم في سبيل الله.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_daw1_1',
          title: 'شرف مقام الدعوة إلى الله ووظيفة الرسل',
          contentType: LearningContentType.sourceText,
          content: 'الدعوة إلى الله هي أشرف المقامات الإنسانية؛ فهي وظيفة الأنبياء والمرسلين وورثتهم من العلماء والمصلحين. وقد أثنى الله تعالى عليها في محكم التنزيل فقال ﴿وَمَنْ أَحْسَنُ قَوْلًا مِّمَّن دَعَا إِلَى اللَّهِ وَعَمِلَ صَالِحًا وَقَالَ إِنَّنِي مِنَ الْمُسْلِمِينَ﴾. والداعية حريص على نجاة البشرية وإخراجها من ظلمات الجهل والشرك إلى نور التوحيد والهدى.',
          evidenceLinks: [evDawahQuran, evDawahHadith],
          sourceAttribution: 'تفسير ابن كثير وأصول الدعوة لعبد الكريم زيدان',
        ),
        LessonSection.create(
          sectionId: 'sec_daw1_2',
          title: 'عظيم الأجر والثواب في هداية القلوب',
          contentType: LearningContentType.explanation,
          content: 'بيّن النبي ﷺ لعلي بن أبي طالب رضي الله عنه يوم خيبر عظيم فضل الدعوة فقال «فوالله لأن يهدي الله بك رجلاً واحداً خير لك من أن يكون لك حمر النعم»، كما قال ﷺ «من دعا إلى هدى كان له من الأجر مثل أجور من تبعه لا ينقص ذلك من أجورهم شيئاً».',
          sourceAttribution: 'فتح الباري لشرح صحيح البخاري',
        ),
        LessonSection.create(
          sectionId: 'sec_daw1_3',
          title: 'معالم المنهج النبوي: الصدق والتجرد والصبر',
          contentType: LearningContentType.explanation,
          content: 'تميز منهج الأنبياء بالإخلاص الكامل والتجرد عن أي مطمع دنيوي، فكان شعار كل نبي ﴿إِنْ أَجْرِيَ إِلَّا عَلَى اللَّهِ﴾، مقروناً بالصبر الجميل على استهزاء المعاندين، والرحمة بالمخالفين، وتلمس المعاذير لهم، ومقابلتهم بالدعاء لهم بالهداية كما قال المصطفى ﷺ «اللهم اهد قومي فإنهم لا يعلمون».',
          sourceAttribution: 'الرحيق المختوم وفقه السيرة للغزالي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: الحكمة والموعظة الحسنة والتدرج ومراعاة الأحوال
    // -------------------------------------------------------------------------
    final evWisdomQuran = EvidenceLink.create(
      evidenceId: 'ev_dawah_wisdom_quran_nahl',
      evidenceKey: '16:125',
      citation: 'سورة النحل: الآية 125 {ادْعُ إِلَىٰ سَبِيلِ رَبِّكَ بِالْحِكْمَةِ وَالْمَوْعِظَةِ الْحَسَنَةِ ۖ وَجَادِلْهُم بِالَّتِي هِيَ أَحْسَنُ}',
      sourceId: 'src_quran_canonical',
    );
    final evTaysirHadith = EvidenceLink.create(
      evidenceId: 'ev_dawah_taysir_hadith_bukhari',
      evidenceKey: 'bukhari:69',
      citation: 'صحيح البخاري: «يَسِّرُوا وَلَا تُعَسِّرُوا، وَبَشِّرُوا وَلَا تُنَفِّرُوا»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_dawah_wisdom_gradualness',
      title: 'الحكمة، الموعظة الحسنة، فقه التدرج، ومراعاة أحوال المخاطبين',
      courseId: courseId,
      moduleId: 'mod_dawah_principles_hisbah',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_daw2_1',
          title: 'معنى الحكمة في الدعوة',
          description: 'استيعاب المعنى الشامل لـ "الحكمة" بوضع الشيء في موضعه وخطاب كل فئة بما يناسبها.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw2_2',
          title: 'فقه التدرج في البلاغ',
          description: 'تطبيق فقه التدرج في البلاغ والتعليم كما تدرج التشريع القرآني والنبوي.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw2_3',
          title: 'منهج التيسير والتبشير',
          description: 'الالتزام بمنهج التيسير والتبشير ونبذ الغلظة والتنفير في الخطاب الدعوي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_daw2_1',
          title: 'الحكمة في الدعوة: أبعادها ومقتضياتها',
          contentType: LearningContentType.sourceText,
          content: 'الحكمة هي إصابة الحق بالعلم والعمل، ووضع القول والفعل في محله المناسب في الوقت المناسب مع الشخص المناسب. والناس أصناف: فمنهم طالب الحق المنصف فيكفيه البرهان العلمي والحكمة، ومنهم الغافل الساهي فيحتاج إلى الموعظة الحسنة التي تلامس الوجدان وترقق القلب، ومنهم المعاند فيحتاج إلى الجدال بالتي هي أحسن بالحجة والإنصاف.',
          evidenceLinks: [evWisdomQuran, evTaysirHadith],
          sourceAttribution: 'مفتاح دار السعادة لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_daw2_2',
          title: 'فقه التدرج ومراعاة أولويات البلاغ',
          contentType: LearningContentType.explanation,
          content: 'التدرج سنة إلهية في الكون والتشريع؛ وقد أوصى النبي ﷺ معاذ بن جبل حين بعثه إلى اليمن بالبدء بالأهم فالأهم: التوحيد أولاً، ثم الصلاة، ثم الزكاة. والداعية الحكيم لا يطالب الناس بالكمالات دفعة واحدة، بل يثبت أصول الإيمان ويرسخ أركان الإسلام خطوة بخطوة.',
          sourceAttribution: 'منهاج القاصدين وفقه الأولويات للقرضاوي',
        ),
        LessonSection.create(
          sectionId: 'sec_daw2_3',
          title: 'منهج التيسير والتبشير ومراعاة طاقات الناس',
          contentType: LearningContentType.explanation,
          content: 'القاعدة النبوية الكبرى في التعامل الدعوي هي: «يسروا ولا تعسروا وبشروا ولا تنفروا». والرفق زينة العمل الدعوي وما دخل في شيء إلا زانه، ولا نزع من شيء إلا شانه. والواجب مراعاة ظروف المخاطبين النفسية والاجتماعية والثقافية وعدم إحراجهم أو إلزامهم بما لا يطيقون.',
          sourceAttribution: 'رياض الصالحين',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: فقه الأمر بالمعروف والنهي عن المنكر وضوابط الاحتساب
    // -------------------------------------------------------------------------
    final evHisbahQuran = EvidenceLink.create(
      evidenceId: 'ev_dawah_hisbah_quran_imran',
      evidenceKey: '3:110',
      citation: 'سورة آل عمران: الآية 110 {كُنتُمْ خَيْرَ أُمَّةٍ أُخْرِجَتْ لِلنَّاسِ تَأْمُرُونَ بِالْمَعْرُوفِ وَتَنْهَوْنَ عَنِ الْمُنكَرِ}',
      sourceId: 'src_quran_canonical',
    );
    final evMunkarHadith = EvidenceLink.create(
      evidenceId: 'ev_dawah_munkar_hadith_muslim',
      evidenceKey: 'muslim:49',
      citation: 'صحيح مسلم: «مَنْ رَأَى مِنْكُمْ مُنْكَرًا فَلْيُغَيِّرْهُ بِيَدِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِلِسَانِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِقَلْبِهِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_dawah_hisbah_commanding_good',
      title: 'فقه الأمر بالمعروف والنهي عن المنكر: أركانه، مراتبه، وضوابطه الشرعية',
      courseId: courseId,
      moduleId: 'mod_dawah_principles_hisbah',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_daw3_1',
          title: 'مكانة شعيرة الاحتساب',
          description: 'إدراك كون الأمر بالمعروف والنهي عن المنكر صمام أمان المجتمع وعلة خيرية الأمة.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw3_2',
          title: 'مراتب التغيير وضوابطها',
          description: 'فهم مراتب التغيير الثلاثة (اليد، اللسان، القلب) وشروط كل مرتبة ومن خوطب بها.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw3_3',
          title: 'قاعدة درء المفاسد الراجحة',
          description: 'استيعاب ضابط الموازنة بين المصالح والمفاسد: ألا يؤدي إنكار المنكر إلى منكر أعظم منه.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_daw3_1',
          title: 'مكانة شعيرة الاحتساب وكونها صمام أمان المجتمع',
          contentType: LearningContentType.sourceText,
          content: 'الأمر بالمعروف والنهي عن المنكر هو القطب الأعظم في الدين وصمام أمان الأمة وحصنها المنيع من الهلاك والفساد المجتمعي؛ وبه استوجبت الأمة الخيرية على سائر الأمم كما في قوله تعالى ﴿كُنتُمْ خَيْرَ أُمَّةٍ أُخْرِجَتْ لِلنَّاسِ تَأْمُرُونَ بِالْمَعْرُوفِ وَتَنْهَوْنَ عَنِ الْمُنكَرِ وَتُؤْمِنُونَ بِاللَّهِ﴾.',
          evidenceLinks: [evHisbahQuran, evMunkarHadith],
          sourceAttribution: 'إحياء علوم الدين للغزالي',
        ),
        LessonSection.create(
          sectionId: 'sec_daw3_2',
          title: 'مراتب التغيير الثلاث وضوابط توزيع الصلاحيات',
          contentType: LearningContentType.explanation,
          content: 'قسم النبي ﷺ التغيير لمراتب: 1- باليد: لمن كانت له ولاية شرعية كالحاكم والقاضي في دائرته، ورب الأسرة في بيته، بما لا يفضي لفتنة. 2- باللسان: وهو شأن العلماء والدعاة وأهل النصح بالحكمة والبيان دون تشهير. 3- بالقلب: وهو فرض عين على كل مسلم ببغض المنكر ومفارقته وعزله شعورياً إن عجز عن القول واليد.',
          sourceAttribution: 'الحسبة في الإسلام لابن تيمية',
        ),
        LessonSection.create(
          sectionId: 'sec_daw3_3',
          title: 'شروط الإنكار وقاعدة «درء المفاسد الراجحة»',
          contentType: LearningContentType.explanation,
          content: 'يشترط لإنكار المنكر: أن يكون مجمعاً على تحريمه لا مسألة اجتهادية يسوغ فيها الخلاف، وأن يكون ظاهراً دون تجسس، وأن يكون الآمر عالماً بالحكم الشرعي رفيقاً صبوراً. والأصل الأصولي الحاكم: ألا يؤدي إنكار المنكر إلى منكر أكبر منه أو مساوٍ له؛ فإن غلب على الظن ترتب مفسدة أعظم وجب الكف صيانة للمصالح العامة.',
          sourceAttribution: 'الأمر بالمعروف والنهي عن المنكر لابن تيمية',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: آداب الحوار وقواعد المناظرة والمجادلة بالتي هي أحسن
    // -------------------------------------------------------------------------
    final evDialogueQuran = EvidenceLink.create(
      evidenceId: 'ev_dawah_dialogue_quran_ankabut',
      evidenceKey: '29:46',
      citation: 'سورة العنكبوت: الآية 46 {وَلَا تُجَادِلُوا أَهْلَ الْكِتَابِ إِلَّا بِالَّتِي هِيَ أَحْسَنُ}',
      sourceId: 'src_quran_canonical',
    );
    final evQawlHadith = EvidenceLink.create(
      evidenceId: 'ev_dawah_qawl_hadith_tirmidhi',
      evidenceKey: 'tirmidhi:1977',
      citation: 'سنن الترمذي: «لَيْسَ المُؤْمِنُ بِالطَّعَّانِ وَلَا اللَّعَّانِ وَلَا الفَاحِشِ وَلَا البَذِيءِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_dawah_dialogue_debate_ethics',
      title: 'آداب الحوار، قواعد المناظرة العلمية، والمجادلة بالتي هي أحسن',
      courseId: courseId,
      moduleId: 'mod_dawah_dialogue_media',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_daw4_1',
          title: 'قواعد المناظرة القرآنية',
          description: 'إتقان قواعد المناظرة القرآنية والبحث عن الحق وتجريد القصد لله تعالى.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw4_2',
          title: 'أدب الاستماع وتفنيد الشبهات',
          description: 'التحلي بآداب الاستماع وتجنب شخصنة النقاش وتفنيد الشبهات بالحجة والبرهان.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw4_3',
          title: 'النهي عن المراء والجدال العقيم',
          description: 'تجنب الجدال العقيم والمراء المذموم والحرص على كسب القلوب قبل إفحام العقول.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_daw4_1',
          title: 'الغاية من الحوار والبحث المشترك عن الحقيقة',
          contentType: LearningContentType.sourceText,
          content: 'الحوار في الإسلام ليس معركة لإثبات الذات وقهر الخصم، بل هو وسيلة نبيلة لإبانة الحق وإزاحة الشبهات وهداية الحائرين. ومن أعظم القواعد القرآنية في الإنصاف قوله تعالى: ﴿وَإِنَّا أَوْ إِيَّاكُمْ لَعَلَىٰ هُدًى أَوْ فِي ضَلَالٍ مُّبِينٍ﴾؛ وهو غاية التواضع المنهجي والإنصاف العلمي لإلزام المخالف بالحجة العقلية.',
          evidenceLinks: [evDialogueQuran, evQawlHadith],
          sourceAttribution: 'آداب البحث والمناظرة للشنقيطي',
        ),
        LessonSection.create(
          sectionId: 'sec_daw4_2',
          title: 'قواعد المناظرة العلمية الرصينة',
          contentType: LearningContentType.explanation,
          content: 'يقوم الحوار الرصين على قواعد علمية أصيلة: 1- صحة النقل وإثبات صحة النصوص والدعاوى (إن كنت ناقلاً فالصحة، وإن كنت مدعياً فالدليل). 2- سلامة الاستدلال وموافقة العقل الصريح للنقل الصحيح. 3- تحرير مواضع النزاع وحصر المسألة بدقة دون تشتيت. 4- احترام شخص المحاور وعدم السخرية من عقله أو معتقده.',
          sourceAttribution: 'درء تعارض العقل والنقل لابن تيمية',
        ),
        LessonSection.create(
          sectionId: 'sec_daw4_3',
          title: 'النهي عن المراء والجدال العقيم وكسب القلوب',
          contentType: LearningContentType.explanation,
          content: 'حذر النبي ﷺ من المراء والخصومات العقيمة التي توغر الصدور وتفسد العلاقات فقال «أنا زعيم ببيت في ربض الجنة لمن ترك المراء وإن كان محقاً». والداعية اللبق يدرك أن كسب قلب المحاور واحترامه مقدم على مجرد إفحامه وإحراجه أمام الجماهير.',
          sourceAttribution: 'جامع بيان العلم وفضله لابن عبد البر',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: استثمار التقنيات والوسائط الرقمية في خدمة الدعوة
    // -------------------------------------------------------------------------
    final evMediaQuran = EvidenceLink.create(
      evidenceId: 'ev_dawah_media_quran_nur',
      evidenceKey: '24:35',
      citation: 'سورة النور: الآية 35 {نُّورٌ عَلَىٰ نُورٍ ۗ يَهْدِي اللَّهُ لِنُورِهِ مَن يَشَاءُ}',
      sourceId: 'src_quran_canonical',
    );
    final evBallighuHadith = EvidenceLink.create(
      evidenceId: 'ev_dawah_ballighu_hadith_bukhari',
      evidenceKey: 'bukhari:3461',
      citation: 'صحيح البخاري: «بَلِّغُوا عَنِّي وَلَوْ آيَةً»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_dawah_digital_media_modern_tools',
      title: 'استثمار الوسائط الرقمية والمنصات الحديثة في خدمة الدعوة والبلاغ',
      courseId: courseId,
      moduleId: 'mod_dawah_dialogue_media',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_daw5_1',
          title: 'مسؤولية البلاغ الفردي',
          description: 'استشعار المسؤولية الفردية في البلاغ لحديث «بلغوا عني ولو آية».',
        ),
        LearningObjective(
          objectiveId: 'obj_daw5_2',
          title: 'توظيف المنصات الرقمية',
          description: 'توظيف شبكات التواصل والمنصات الرقمية وتطبيقات الهواتف الذكية في نشر العلم النافع.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw5_3',
          title: 'معايير صناعة المحتوى الهادف',
          description: 'مراعاة الجودة الفنية والمصداقية العلمية وصناعة المحتوى القيمي الجذاب.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_daw5_1',
          title: 'الواجب الدعوي في الفضاء الرقمي العالمي',
          contentType: LearningContentType.sourceText,
          content: 'مع الانفجار المعلوماتي وثورة الاتصالات، أضحى الفضاء الرقمي الميدان الأوسع لنشر الأفكار والتأثير في عقول الملايين. وأصبح استثمار هذه المنصات لنشر هدي الإسلام وقيمه السامية فرض كفاية وواجباً حتمياً على المتخصصين والتقنيين والمهتمين لملء هذا الفراغ بالحق والخير.',
          evidenceLinks: [evMediaQuran, evBallighuHadith],
          sourceAttribution: 'فقه الدعوة في العصر الرقمي',
        ),
        LessonSection.create(
          sectionId: 'sec_daw5_2',
          title: 'صناعة المحتوى الهادف ومعايير التأثير الإيجابي',
          contentType: LearningContentType.explanation,
          content: 'يتطلب الخطاب الرقمي الفعال: الإيجاز غير المخل، الجاذبية البصرية، استخدام اللغة المعاصرة السهلة دون تسطيح للمفاهيم الشرعية، التحقق الصارم من صحة الأحاديث والمعلومات قبل نشرها، والابتعاد التام عن العناوين المضللة والإثارة الرخيصة بحثاً عن المشاهدات.',
          sourceAttribution: 'أخلاقيات الإعلام الجديد والاتصال الرقمي',
        ),
        LessonSection.create(
          sectionId: 'sec_daw5_3',
          title: 'أخلاقيات الداعية الرقمي وصيانة الأثر',
          contentType: LearningContentType.explanation,
          content: 'يجب على صانع المحتوى الدعوي التزام التواضع وتجنب فتنة الشهرة وتصدر غير المؤهلين للإفتاء؛ والحرص على توجيه المتابعين لمصادر العلم الموثوقة والعلماء المعتمدين، والرد على التعليقات بأدب ورفق وعدم الانجرار إلى معارك التراشق والسباب الإلكتروني.',
          sourceAttribution: 'آداب المعاملات والاتصال في الإسلام',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: دعوة غير المسلمين وفقه التعارف والتعايش الإنساني
    // -------------------------------------------------------------------------
    final evCoexistQuran = EvidenceLink.create(
      evidenceId: 'ev_dawah_coexist_quran_mumtahanah',
      evidenceKey: '60:8',
      citation: 'سورة الممتحنة: الآية 8 {لَّا يَنْهَاكُمُ اللَّهُ عَنِ الَّذِينَ لَمْ يُقَاتِلُوكُمْ فِي الدِّينِ ... أَن تَبَرُّوهُمْ وَتُقْسِطُوا إِلَيْهِمْ}',
      sourceId: 'src_quran_canonical',
    );
    final evMercyHadith = EvidenceLink.create(
      evidenceId: 'ev_dawah_mercy_hadith_tirmidhi',
      evidenceKey: 'tirmidhi:1924',
      citation: 'سنن الترمذي: «الرَّاحِمُونَ يَرْحَمُهُمُ الرَّحْمَنُ، ارْحَمُوا مَنْ فِي الأَرْضِ يَرْحَمْكُمْ مَنْ فِي السَّمَاءِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_dawah_non_muslims_coexistence',
      title: 'دعوة غير المسلمين، فقه التعارف، والتعايش الإنساني القائم على القسط والبر',
      courseId: courseId,
      moduleId: 'mod_dawah_dialogue_media',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_daw6_1',
          title: 'الأساس القرآني في التعايش الإنساني',
          description: 'استيعاب المبدأ القرآني في التعايش القائم على البر والقسط مع المسالمين.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw6_2',
          title: 'أساليب دعوة غير المسلمين بالقدوة',
          description: 'معرفة أساليب دعوة غير المسلمين بعرض محاسن الإسلام والقدوة العملية الصالحة.',
        ),
        LearningObjective(
          objectiveId: 'obj_daw6_3',
          title: 'التمايز العقدي مع كمال الإحسان',
          description: 'التفريق الدقيق بين البر والإحسان الإنساني المشروع وبين الموالاة العقدية المنهي عنها.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_daw6_1',
          title: 'الأساس القرآني في العلاقة الإنسانية مع غير المسلمين المسالمين',
          contentType: LearningContentType.sourceText,
          content: 'أرسى القرآن قاعدة محكمة واضحة في سورة الممتحنة: ﴿لَّا يَنْهَاكُمُ اللَّهُ عَنِ الَّذِينَ لَمْ يُقَاتِلُوكُمْ فِي الدِّينِ وَلَمْ يُخْرِجُوكُم مِّن دِيَارِكُمْ أَن تَبَرُّوهُمْ وَتُقْسِطُوا إِلَيْهِمْ ۚ إِنَّ اللَّهَ يُحِبُّ الْمُقْسِطِينَ﴾. والبر هو الإحسان، والقسط هو العدل التام، والإسلام يحفظ دماء غير المحاربين وأموالهم وأعراضهم وعهودهم.',
          evidenceLinks: [evCoexistQuran, evMercyHadith],
          sourceAttribution: 'أحكام أهل الذمة لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_daw6_2',
          title: 'الدعوة بالقدوة وحسن المعاملة والأمانة',
          contentType: LearningContentType.explanation,
          content: 'دخل الإسلام إلى كبريات بلاد آسيا وإفريقيا (كإندونيسيا وماليزيا وبلاد السواحل) دون جيوش، بل من خلال أمانة التجار المسلمين وصدقهم وأخلاقهم الرفيعة. فالقدوة العملية الصادقة والتطابق بين القول والفعل أعظم بلاغ وأبلغ رسالة تأسر القلوب قبل الأسماع.',
          sourceAttribution: 'تاريخ انتشار الإسلام وتراجم الدعاة',
        ),
        LessonSection.create(
          sectionId: 'sec_daw6_3',
          title: 'التمايز العقدي مع كمال الإحسان الإنساني',
          contentType: LearningContentType.explanation,
          content: 'يفرق الفقه الإسلامي الرشيد بين التمايز العقدي والاعتزاز بالدين وعدم الرضا بالكفر، وبين التعامل الإنساني النبيل في المعاملات اليومية والزيارة والمواساة وإعانة المحتاج؛ فالإسلام دين الرحمة العالمية للعالمين جميعاً ﴿وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ﴾.',
          sourceAttribution: 'فقه المعاملات مع غير المسلمين للبوطي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: أصول الدعوة والاحتساب
    final q1 = QuizQuestion.create(
      questionId: 'q_daw_1',
      lessonId: 'lsn_dawah_wisdom_gradualness',
      questionText: 'ما هي المرتبة الأولى في فقه الأولويات والتدرج التي بدأ بها النبي ﷺ حين وجّه الرسل لتعليم الناس ودعوتهم؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qd1_1', text: 'توحيد الله تعالى والإيمان به شهادة أن لا إله إلا الله وأن محمداً رسول الله'),
        QuizOption(optionId: 'opt_qd1_2', text: 'شرح أحكام المواريث والفرائض وتفاصيل القضاء'),
        QuizOption(optionId: 'opt_qd1_3', text: 'فرض قيام الليل والنوافل المشددة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قال النبي ﷺ لمعاذ بن جبل لما بعثه لليمن: «فليكن أول ما تدعوهم إليه شهادة أن لا إله إلا الله وأن محمداً رسول الله، فإن هم أطاعوك لذلك فأعلمهم أن الله افترض عليهم خمس صلوات...».',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_dawah_principles_hisbah',
      lessonId: 'lsn_dawah_wisdom_gradualness',
      title: 'اختبار أصول الدعوة وفقه الأمر بالمعروف والاحتساب',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: أدب الحوار والدعوة الإنسانية
    final q2 = QuizQuestion.create(
      questionId: 'q_daw_2',
      lessonId: 'lsn_dawah_dialogue_debate_ethics',
      questionText: 'ما هو المعنى المقصود بترك "المِراء" الذي ضمن النبي ﷺ لصاحبه بيتاً في ربض الجنة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qd2_1', text: 'ترك الجدال العقيم والخصومة اللفظية لطلب الغلبة والانتصار للنفس حتى لو كان محقاً'),
        QuizOption(optionId: 'opt_qd2_2', text: 'ترك تعليم الناس ونصحهم تماماً'),
        QuizOption(optionId: 'opt_qd2_3', text: 'التنازل عن ثوابت العقيدة إرضاءً للمخالف'),
      ],
      correctOptionIndices: const [0],
      explanation: 'المراء المذموم هو المجادلة بالباطل أو الجدال الذي لا طائل تحته سوى المباهاة وإثارة الشحناء، ويثاب تاركه ببيت في ربض الجنة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_dawah_dialogue_media',
      lessonId: 'lsn_dawah_dialogue_debate_ethics',
      title: 'اختبار أدب الحوار ووسائل الدعوة الرقمية والتعايش',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
