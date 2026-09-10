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

/// بيانات مقرر فقه القضاء وطرق الإثبات الشرعية والقرائن المعاصرة (6 دروس تأصيلية + اختباران استيعاب)
class LearningJudiciaryEvidenceData {
  static const String courseId = 'course_fiqh_judiciary_evidence';
  static const String pathId = 'path_governance_judiciary_rights_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه القضاء وطرق الإثبات الشرعية والقرائن المعاصرة',
      description: 'دراسة تأصيلية فقهية لأصول القضاء الإسلامي، شروط القاضي وآدابه، أركان الدعوى القضائية، وطرق الإثبات الشرعية من الشهادة والإقرار واليمين، مع التطبيقات والقرائن المعاصرة كالطب الشرعي والبصمة الوراثية.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_judiciary_principles_court', 'mod_judiciary_evidence_methods'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_judiciary_principles_court',
        courseId: courseId,
        title: 'الوحدة الأولى: أصول القضاء وآداب القاضي وشروط ولاية الحكم',
        description: 'بيان مشروعية القضاء، عظم أمانته، شروط القاضي، آداب مجلس القضاء، التسوية التامة بين الخصوم، والفرق بين القضاء والفتوى والتحكيم.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_judiciary_pillars_court_office',
          'lsn_judiciary_ethics_independence_equality',
          'lsn_judiciary_lawsuit_arbitration_settlement',
        ],
      ),
      CourseModule(
        moduleId: 'mod_judiciary_evidence_methods',
        courseId: courseId,
        title: 'الوحدة الثانية: طرق الإثبات الشرعية والبينات والقرائن المعاصرة',
        description: 'تأصيل الشهادة وضوابط عدالتها، الإقرار واليمين والنكول، وحجية القرائن المعاصرة كالبصمة الوراثية والطب الشرعي والتقارير الجنائية.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_judiciary_principles_court'],
        lessonIds: const [
          'lsn_judiciary_testimony_conditions_retraction',
          'lsn_judiciary_confession_oath_refusal',
          'lsn_judiciary_contemporary_forensics_dna',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: مشروعية القضاء وشروط تولي ولاية الحكم
    // -------------------------------------------------------------------------
    final evJudiciaryQuran = EvidenceLink.create(
      evidenceId: 'ev_judiciary_quran_sad',
      evidenceKey: '38:26',
      citation: 'سورة ص: الآية 26 {يَا دَاوُودُ إِنَّا جَعَلْنَاكَ خَلِيفَةً فِي الْأَرْضِ فَاحْكُم بَيْنَ النَّاسِ بِالْحَقِّ وَلَا تَتَّبِعِ الْهَوَىٰ}',
      sourceId: 'src_quran_canonical',
    );
    final evJudgesHadith = EvidenceLink.create(
      evidenceId: 'ev_judiciary_hadith_qudah_thalathah',
      evidenceKey: 'abudawood:3573',
      citation: 'سنن أبي داود: «القُضَاةُ ثَلَاثَةٌ: وَاحِدٌ فِي الجَنَّةِ، وَاثْنَانِ فِي النَّارِ...»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_judiciary_pillars_court_office',
      title: 'مشروعية القضاء في الإسلام وفضله وخطورته وشروط تولي ولاية الحكم',
      courseId: courseId,
      moduleId: 'mod_judiciary_principles_court',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_jud1_1',
          title: 'مشروعية القضاء وأهميته المجتمعية',
          description: 'استيعاب مشروعية القضاء وفرضيته الكفائية لحفظ الحقوق ورد المظالم واستقرار المجتمعات.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud1_2',
          title: 'عظم المسؤولية والتحذير من الجور',
          description: 'معرفة فضل القضاء العادل والتحذير النبوي الشديد للقضاة من الجور أو القضاء بغير علم.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud1_3',
          title: 'شروط ولاية القضاء',
          description: 'تحديد الشروط الفقهية الواجب توفرها في القاضي كالعلم والعدالة والأهلية وسلامة الحواس.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_jud1_1',
          title: 'مشروعية القضاء وفرضيته الكفائية',
          contentType: LearningContentType.sourceText,
          content: 'القضاء هو الفصل بين الخصوم بحكم الله تعالى؛ وهو فرض كفاية تتوقف عليه مصالح العباد وإقامة العدل وحماية الأموال والدماء والأعراض. وقد باشره النبي ﷺ بنفسه، ثم ولاه لخلفائه وأكابر صحابته كعلي بن أبي طالب ومعاذ بن جبل رضي الله عنهم.',
          evidenceLinks: [evJudiciaryQuran, evJudgesHadith],
          sourceAttribution: 'أدب القاضي للماوردي وتبصرة الحكام لابن فرحون',
        ),
        LessonSection.create(
          sectionId: 'sec_jud1_2',
          title: 'عظم أمانة القضاء والتحذير النبوي من المزالق',
          contentType: LearningContentType.explanation,
          content: 'حذر الإسلام من خطورة القضاء لما فيه من الفتنة؛ فبين النبي ﷺ أن القضاة ثلاثة: «رجل عرف الحق فقضى به فهو في الجنة، ورجل عرف الحق فجار في الحكم فهو في النار، ورجل قضى للناس على جهل فهو في النار». لذا كان سلف الأمة يتهيبون تولي القضاء خوفاً من الزلل.',
          sourceAttribution: 'شرح معاني الآثار للطحاوي والمغني',
        ),
        LessonSection.create(
          sectionId: 'sec_jud1_3',
          title: 'شروط القاضي الشرعي وأهليته',
          contentType: LearningContentType.explanation,
          content: 'يشترط في القاضي: 1- الإسلام والتكليف. 2- العدالة التامة باجتناب الكبائر وعدم الإصرار على الصغائر وحسن السيرة. 3- العلم بالأحكام الشرعية ومصادر الاستنباط (الاجتهاد). 4- سلامة السمع والبصر والنطق ليتسنى له سماع الدعوى والشهود ورؤية الخصوم والنطق بالحكم.',
          sourceAttribution: 'الأحكام السلطانية لأبي يعلى الفراء',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: آداب القاضي وسلوكه واستقلال القضاء والتسوية بين الخصوم
    // -------------------------------------------------------------------------
    final evJusticeQuran = EvidenceLink.create(
      evidenceId: 'ev_judiciary_justice_quran_nisaa',
      evidenceKey: '4:58',
      citation: 'سورة النساء: الآية 58 {وَإِذَا حَكَمْتُم بَيْنَ النَّاسِ أَن تَحْكُمُوا بِالْعَدْلِ}',
      sourceId: 'src_quran_canonical',
    );
    final evOmarLetterHadith = EvidenceLink.create(
      evidenceId: 'ev_judiciary_omar_letter',
      evidenceKey: 'bayhaqi:judiciary:letter',
      citation: 'رسالة عمر بن الخطاب لأبي موسى الأشعري: «آسِ بَيْنَ النَّاسِ فِي وَجْهِكَ وَمَجْلِسِكَ وَعَدْلِكَ...»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_judiciary_ethics_independence_equality',
      title: 'آداب القاضي وسلوكه المهني: التسوية بين الخصمين واستقلال ونزاهة القضاء',
      courseId: courseId,
      moduleId: 'mod_judiciary_principles_court',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_jud2_1',
          title: 'مبدأ التسوية المطلقة بين الخصوم',
          description: 'إتقان مبدأ التسوية بين الخصمين في المجلس واللحظ والكلام والنظر بصرف النظر عن مكانتهما.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud2_2',
          title: 'موانع القضاء النفسية والجسدية',
          description: 'معرفة الأحوال التي يمتنع فيها القاضي عن الحكم كالغضب الشديد والجوع والنعاس المفرط.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud2_3',
          title: 'استقلال القضاء وحرمة الرشوة وهدايا العمال',
          description: 'استيعاب استقلال القضاء التام عن السلطان والتحذير من قبول الهدايا أو المحاباة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_jud2_1',
          title: 'دستور القضاء في رسالة عمر بن الخطاب الخالدة',
          contentType: LearningContentType.sourceText,
          content: 'تعد رسالة أمير المؤمنين عمر بن الخطاب رضي الله عنه إلى أبي موسى الأشعري الدستور الأساس للقضاء في الإسلام؛ حيث جاء فيها: «آسِ بين الناس في وجهك ومجلسك وعدلك، حتى لا ييأس الضعيف من عدلك، ولا يطمع الشريف في حيفك، البينة على من ادعى واليمين على من أنكر، والصلح جائز بين المسلمين إلا صلحاً أحل حراماً أو حرم حلالاً».',
          evidenceLinks: [evJusticeQuran, evOmarLetterHadith],
          sourceAttribution: 'إعلام الموقعين عن رب العالمين لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_jud2_2',
          title: 'موانع القضاء النفسية واستقرار ذهن القاضي',
          contentType: LearningContentType.explanation,
          content: 'نهى النبي ﷺ القاضي أن يقضي وهو غضبان فقال: «لا يقضي الحاكم بين اثنين وهو غضبان». وقاس العلماء على الغضب كل ما يشوش الفكر ويمنع استيفاء النظر كشدة الجوع أو العطش أو النعاس أو المرض أو الحزن الشديد، ضماناً لدقة التصور والعدالة في الحكم.',
          sourceAttribution: 'بدائع الصنائع للكاساني',
        ),
        LessonSection.create(
          sectionId: 'sec_jud2_3',
          title: 'نزاهة القضاء وحرمة هدايا الخصوم',
          contentType: LearningContentType.explanation,
          content: 'يتمتع القضاء في الإسلام باستقلال مطلق لا سلطان عليه لغير شرع الله؛ ويحرم على القاضي قبول الهدايا لقوله ﷺ: «هدايا العمال غلول»، كما لعن النبي ﷺ الراشي والمرتشي والرائش (الوسيط). ولا يجوز للقاضي أن يحكم لنفسه أو لوالديه أو لولده دفعاً للتهمة.',
          sourceAttribution: 'المغني لابن قدامة والسياسة الشرعية لابن تيمية',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: أركان الدعوى القضائية والفرق بين القضاء والفتوى والتحكيم
    // -------------------------------------------------------------------------
    final evLawsuitHadith = EvidenceLink.create(
      evidenceId: 'ev_judiciary_bayyinah_hadith',
      evidenceKey: 'bukhari:4552',
      citation: 'صحيح البخاري: «لَوْ يُعْطَى النَّاسُ بِدَعْوَاهُمْ، لَادَّعَى نَاسٌ دِمَاءَ رِجَالٍ وَأَمْوَالَهُمْ، وَلَكِنَّ البَيِّنَةَ عَلَى المُدَّعِي...»',
      sourceId: 'src_hadith_canonical',
    );
    final evSulhQuran = EvidenceLink.create(
      evidenceId: 'ev_judiciary_sulh_quran_nisaa',
      evidenceKey: '4:128',
      citation: 'سورة النساء: الآية 128 {وَالصُّلْحُ خَيْرٌ}',
      sourceId: 'src_quran_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_judiciary_lawsuit_arbitration_settlement',
      title: 'أركان الدعوى القضائية، شروط صحتها، والفرق بين القضاء والفتوى والتحكيم والصلح',
      courseId: courseId,
      moduleId: 'mod_judiciary_principles_court',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_jud3_1',
          title: 'أركان الدعوى القضائية وضوابط المدعي والمدعى عليه',
          description: 'التمييز الدقيق بين المدعي (من إذا سكت تُرِك) والمدعى عليه (من إذا سكت طُولِب).',
        ),
        LearningObjective(
          objectiveId: 'obj_jud3_2',
          title: 'الفرق بين القضاء والفتوى',
          description: 'بيان الفروق الجوهرية بين حكم القاضي الإلزامي وفتوى المفتي الإخبارية غير الإلزامية.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud3_3',
          title: 'التحكيم والصلح وأثرهما في فض المنازعات',
          description: 'معرفة مشروعية التحكيم والصلح كبدائل شرعية فعالة لتسوية النزاعات وحقن الخصومات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_jud3_1',
          title: 'تعريف الدعوى وضابط التمييز بين الخصمين',
          contentType: LearningContentType.sourceText,
          content: 'الدعوى هي إخبار شخص بحق له على غيره عند القاضي. وضابط التمييز بين الخصمين: المدعي هو من يترك إذا سكت ولم يطالب، ودعواه تخالف الأصل والظاهر؛ والمدعى عليه هو من لا يترك إذا سكت، وقوله يوافق الأصل وهو براءة الذمة. لذا كانت البينة مطلوبة من المدعي لأن حجته خفية، واليمين على من أنكر لأن الأصل معه.',
          evidenceLinks: [evLawsuitHadith, evSulhQuran],
          sourceAttribution: 'قواعد الأحكام في مصالح الأنام للعز بن عبد السلام',
        ),
        LessonSection.create(
          sectionId: 'sec_jud3_2',
          title: 'الفروق الدقيقة بين القضاء والفتوى',
          contentType: LearningContentType.explanation,
          content: 'الفتوى إخبار عن حكم الله في مسألة عامة أو خاصة دون إلزام؛ والمفتي موقع عن رب العالمين. أما القضاء فهو إنشاء حكم ملزم في واقعة قضائية معينة يحسم النزاع ويرفع الخلاف الفقهي؛ فحكم القاضي يرفع الخلاف في المسائل الاجتهادية وينفذ جبراً بقوة السلطان.',
          sourceAttribution: 'الفروق للقرافي ومجمع الضمانات',
        ),
        LessonSection.create(
          sectionId: 'sec_jud3_3',
          title: 'التحكيم والصلح ودورهما في العدالة الناجزة',
          contentType: LearningContentType.explanation,
          content: 'التحكيم هو تولية الخصمين برضاهما حكماً يفصل بينهما؛ وهو جائز ومشروع وحكم المحكَّم ملزم للطرفين كالصلح. والصلح من أعظم مقاصد الشريعة لإنهاء الشقاق وجمع الكلمة، ويشترط فيه ألا يحل حراماً كإسقاط حد شرعي أو يحرم حلالاً.',
          sourceAttribution: 'معين الحكام فيما يتردد بين الخصمين من الأحكام',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: الشهادة الشرعية وشروطها والرجوع عنها
    // -------------------------------------------------------------------------
    final evTestimonyQuran = EvidenceLink.create(
      evidenceId: 'ev_judiciary_testimony_quran_baqarah',
      evidenceKey: '2:282',
      citation: 'سورة البقرة: الآية 282 {وَاسْتَشْهِدُوا شَهِيدَيْنِ مِن رِّجَالِكُمْ ۖ فَإِن لَّمْ يَكُونَا رَجُلَيْنِ فَرَجُلٌ وَامْرَأَتَانِ مِمَّن تَرْضَوْنَ مِنَ الشُّهَدَاءِ}',
      sourceId: 'src_quran_canonical',
    );
    final evZurHadith = EvidenceLink.create(
      evidenceId: 'ev_judiciary_zur_hadith_bukhari',
      evidenceKey: 'bukhari:2654',
      citation: 'صحيح البخاري: «أَلَا أُنَبِّئُكُمْ بِأَكْبَرِ الكَبَائِرِ؟ ... أَلَا وَقَوْلُ الزُّورِ، وَشَهَادَةُ الزُّورِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_judiciary_testimony_conditions_retraction',
      title: 'الشهادة الشرعية: شروط الشاهد، ضوابط العدالة، عزل شهادة الزور، والرجوع عنها',
      courseId: courseId,
      moduleId: 'mod_judiciary_evidence_methods',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_jud4_1',
          title: 'مكانة الشهادة وحرمة كتمانها وشهادة الزور',
          description: 'إدراك كون الشهادة أمانة لله تعالى وحرمة كتمانها وتجريم شهادة الزور كأكبر الكبائر.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud4_2',
          title: 'شروط الشاهد وتحري العدالة والتزكية',
          description: 'معرفة شروط قبول الشهادة: العقل، البلوغ، العدالة، انتفاء التهمة وقرابة العصب المباشر.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud4_3',
          title: 'أحكام رجوع الشاهد عن شهادته',
          description: 'فهم الآثار المترتبة على رجوع الشهود قبل الحكم أو بعده والضمان المالي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_jud4_1',
          title: 'أهمية الشهادة وتجريم شهادة الزور',
          contentType: LearningContentType.sourceText,
          content: 'الشهادة إخبار بحق للغير على الغير في مجلس القضاء لإحقاق الحق؛ وأداؤها فرض كفاية وقد يتعين، لقوله تعالى: ﴿وَلَا تَكْتُمُوا الشَّهَادَةَ ۚ وَمَن يَكْتُمْهَا فَإِنَّهُ آثِمٌ قَلْبُهُ﴾. وحذر النبي ﷺ من شهادة الزور وكررها حتى قال الصحابة ليته سكت تعظيماً لجرمها وهدمها للعدالة.',
          evidenceLinks: [evTestimonyQuran, evZurHadith],
          sourceAttribution: 'تفسير الطبري والمغني لابن قدامة',
        ),
        LessonSection.create(
          sectionId: 'sec_jud4_2',
          title: 'شروط الشاهد وموانع قبول الشهادة',
          contentType: LearningContentType.explanation,
          content: 'يشترط لقبول الشهادة: التكليف، والإسلام (إلا في الوصية بالسفر للضرورة)، والعدالة (وتثبت بالتزكية وسؤال أهل الخبرة)، والضبط، وانتفاء التهمة؛ فلا تقبل شهادة الوالد لولده ولا الولد لوالده للمحاباة، ولا شهادة العدو على عدوه للضغينة، ولا شهادة من يجر لنفسه نفعاً أو يدفع عنها ضراً.',
          sourceAttribution: 'بداية المجتهد وكتاب الشهادات',
        ),
        LessonSection.create(
          sectionId: 'sec_jud4_3',
          title: 'أحكام الرجوع عن الشهادة والمسؤولية المدنية',
          contentType: LearningContentType.explanation,
          content: 'إذا رجع الشهود عن شهادتهم قبل صدور الحكم بطلت شهادتهم ولم يقض بها القاضي؛ أما إن رجعوا بعد الحكم واستيفاء الحق، لم ينقض الحكم المالي ونفذ، وضمن الشهود الراجعون للمحكوم عليه ما غرمه بسبيل شهادتهم الزائفة أو المرجوع عنها ضماناً للحقوق.',
          sourceAttribution: 'رد المحتار على الدر المختار لابن عابدين',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الإقرار واليمين والنكول وأثرها في الأحكام
    // -------------------------------------------------------------------------
    final evIqrarQuran = EvidenceLink.create(
      evidenceId: 'ev_judiciary_iqrar_quran_nisaa',
      evidenceKey: '4:135',
      citation: 'سورة النساء: الآية 135 {كُونُوا قَوَّامِينَ بِالْقِسْطِ شُهَدَاءَ لِلَّهِ وَلَوْ عَلَىٰ أَنفُسِكُمْ}',
      sourceId: 'src_quran_canonical',
    );
    final evYameenHadith = EvidenceLink.create(
      evidenceId: 'ev_judiciary_yameen_hadith_bukhari',
      evidenceKey: 'bukhari:6668',
      citation: 'صحيح البخاري: «اليَمِينُ عَلَى نِيَّةِ المُسْتَحْلِفِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_judiciary_confession_oath_refusal',
      title: 'الإقرار القضائي، أحكام اليمين وتوجيهها، والنكول وأثره في حسم الخصومات',
      courseId: courseId,
      moduleId: 'mod_judiciary_evidence_methods',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_jud5_1',
          title: 'حجية الإقرار القضائي (سيد الأدلة)',
          description: 'استيعاب حجية الإقرار القضائي وشروطه ونفاذه على المقر دون غيره.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud5_2',
          title: 'اليمين القضائية ومشروعيتها وتغليظها',
          description: 'معرفة أحكام اليمين القضائية وصيغها الشرعية وتغليظها بالزمان والمكان.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud5_3',
          title: 'النكول ورد اليمين وأثرهما في الحكم',
          description: 'فهم أثر نكول المدعى عليه عن اليمين وكيفية رد اليمين على المدعي للفصل في النزاع.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_jud5_1',
          title: 'الإقرار القضائي: أركانه وحجيته القاطعة',
          contentType: LearningContentType.sourceText,
          content: 'الإقرار هو اعتراف الشخص بحق عليه لغيره؛ وهو أقوى البينات وحجة قاصرة على المقر لا تتعداه إلى غيره لقوله تعالى: ﴿وَلَوْ عَلَىٰ أَنفُسِكُمْ﴾. ويشترط في المقر العقل والبلوغ والاختيار؛ فالإقرار تحت الإكراه أو التعذيب باطل شرعاً وقانوناً ولا أثر له بالإجماع لقوله ﷺ: «عفي لأمتي عن الخطأ والنسيان وما استكرهوا عليه».',
          evidenceLinks: [evIqrarQuran, evYameenHadith],
          sourceAttribution: 'قواعد الأحكام للعز بن عبد السلام والمغني',
        ),
        LessonSection.create(
          sectionId: 'sec_jud5_2',
          title: 'أحكام اليمين وتغليظها في مجلس القضاء',
          contentType: LearningContentType.explanation,
          content: 'اليمين شرعت في جانب المنكر تأكيداً لبراءة ذمته الأصلية؛ وتكون بالله تعالى وحده أو بأسمائه وصفاته. ويشرع للقاضي تغليظ اليمين بصيغة الحلف (كالقول: والله الذي لا إله إلا هو عالم الغيب والشهادة)، وتغليظها بالزمان (بعد العصر)، وتغليظها بالمكان (بين الركن والمقام بمكة، أو عند المنبر بالمدينة، أو في المسجد الجامع).',
          sourceAttribution: 'إعلام الموقعين والإنصاف',
        ),
        LessonSection.create(
          sectionId: 'sec_jud5_3',
          title: 'النكول ورد اليمين والقضاء بالنكول',
          contentType: LearningContentType.explanation,
          content: 'النكول هو امتناع المدعى عليه عن حلف اليمين المشروعة بعد أن توجهت إليه بطلب المدعي. وعند الجمهور: إذا نكل المدعى عليه، يرد القاضي اليمين على المدعي (اليمين المردودة)، فإذا حلف المدعي استحق حقه، فإن نكل سقطت دعواه؛ وبذلك تنحسم الخصومات بالعدل.',
          sourceAttribution: 'الشرح الكبير للدردير وحاشية الدسوقي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: القرائن القضائية المعاصرة والطب الشرعي والبصمة الوراثية
    // -------------------------------------------------------------------------
    final evQarinahQuran = EvidenceLink.create(
      evidenceId: 'ev_judiciary_qarinah_quran_yusuf',
      evidenceKey: '12:26-27',
      citation: 'سورة يوسف: الآيتان 26-27 {إِن كَانَ قَمِيصُهُ قُدَّ مِن قُبُلٍ فَصَدَقَتْ ... وَإِن كَانَ قَمِيصُهُ قُدَّ مِن دُبُرٍ فَكَذَبَتْ}',
      sourceId: 'src_quran_canonical',
    );
    final evFirasahHadith = EvidenceLink.create(
      evidenceId: 'ev_judiciary_firasah_hadith_tirmidhi',
      evidenceKey: 'tirmidhi:3127',
      citation: 'سنن الترمذي: «اتَّقُوا فِرَاسَةَ المُؤْمِنِ، فَإِنَّهُ يَنْظُرُ بِنُورِ اللَّهِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_judiciary_contemporary_forensics_dna',
      title: 'القرائن القضائية المعاصرة: حجية البصمة الوراثية (DNA)، الطب الشرعي، والأدلة الرقمية',
      courseId: courseId,
      moduleId: 'mod_judiciary_evidence_methods',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_jud6_1',
          title: 'تأصيل حجية القرائن في الشريعة',
          description: 'معرفة مشروعية القضاء بالقرائن القاطعة استناداً لقصة قميص يوسف وحكم سليمان عليهما السلام.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud6_2',
          title: 'حجية البصمة الوراثية (DNA) ومجالات إعمالها',
          description: 'استيعاب قرارات المجامع الفقهية في حجية البصمة الوراثية في إثبات ونفي الأنساب والجرائم الجنائية.',
        ),
        LearningObjective(
          objectiveId: 'obj_jud6_3',
          title: 'الأدلة الرقمية والطب الشرعي الجنائي',
          description: 'بيان شروط اعتماد تقارير الطب الشرعي، البصمة الرقمية، والتسجيلات الموثقة كبينات قطعية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_jud6_1',
          title: 'القرينة ودورها في كشف الحقيقة القضائية',
          contentType: LearningContentType.sourceText,
          content: 'القرينة هي أمارة ودلالة ظاهرة تقترن بالواقعة وتدل على ثبوتها بيقين أو غلبة ظن قوية؛ وقد اعتد بها القرآن في قصة يوسف ﴿إِن كَانَ قَمِيصُهُ قُدَّ مِن دُبُرٍ﴾؛ واعتمدها الصحابة في إقامة حد الخمر بقرينة الرائحة والقيء، وحد السرقة بوجود المسروق بحوزة السارق دون شبهة.',
          evidenceLinks: [evQarinahQuran, evFirasahHadith],
          sourceAttribution: 'الطرق الحكمية في السياسة الشرعية لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_jud6_2',
          title: 'البصمة الوراثية (DNA) في ميزان الفقه والمجامع',
          contentType: LearningContentType.explanation,
          content: 'أكد مجمع الفقه الإسلامي الدولي أن البصمة الوراثية قطعية الدلالة في إثبات الجرائم الجنائية وحسم تنازع مجهولي النسب وضحايا الكوارث. إلا أن الفقه قرر ضابطاً قطعياً: لا يجوز الاعتماد على البصمة الوراثية لنفي نسب الولد الثابت بفراش الزوجية الصحيح إلا باللعان، صيانة للأنساب واستقراراً للأسر.',
          sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي ورابطة العالم الإسلامي',
        ),
        LessonSection.create(
          sectionId: 'sec_jud6_3',
          title: 'تقارير الطب الشرعي والأدلة الجنائية الرقمية',
          contentType: LearningContentType.explanation,
          content: 'تعتبر تقارير الخبراء الموثوقين والطب الشرعي (كتحديد وقت وسبب الوفاة ونوع السلاح وآثار المقاومة)، بالإضافة إلى الأدلة الرقمية المفحوصة جنائياً (كاميرات المراقبة، التوقيع الرقمي، السجلات البنكية)، من أقوى القرائن المعاصرة المعتبرة شرعاً إذا سلمت من العبث والشبهات.',
          sourceAttribution: 'الخبرة والقرائن في القضاء الإسلامي المعاصر',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: أصول القضاء وآداب القاضي
    final q1 = QuizQuestion.create(
      questionId: 'q_jud_1',
      lessonId: 'lsn_judiciary_ethics_independence_equality',
      questionText: 'ما هو التوجيه النبوي الصحيح للقاضي عندما يكون في حالة غضب شديد أو مشوش الذهن؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qj1_1', text: 'يحرم أو يمتنع عليه القضاء في تلك الحالة لقوله ﷺ «لا يقضي الحاكم بين اثنين وهو غضبان»'),
        QuizOption(optionId: 'opt_qj1_2', text: 'يستحب له الإسراع في الحكم لردع الخصوم وإنهاء النزاع فوراً'),
        QuizOption(optionId: 'opt_qj1_3', text: 'لا يؤثر الغضب مطلقاً ما دام القاضي حافظاً لنصوص القانون'),
      ],
      correctOptionIndices: const [0],
      explanation: 'نهى النبي ﷺ القاضي عن القضاء حال الغضب ضماناً لعدم تأثر أحكامه واستيفائه الكامل للنظر والعدالة بين الخصوم.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_judiciary_principles_court',
      lessonId: 'lsn_judiciary_ethics_independence_equality',
      title: 'اختبار أصول القضاء وآداب القاضي واستقلال العدالة',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: طرق الإثبات والقرائن المعاصرة
    final q2 = QuizQuestion.create(
      questionId: 'q_jud_2',
      lessonId: 'lsn_judiciary_contemporary_forensics_dna',
      questionText: 'ما هو الضابط الشرعي المجمع عليه في المجامع الفقهية لاستخدام البصمة الوراثية (DNA) في شأن الأنساب؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qj2_1', text: 'لا يجوز استخدامها لنفي النسب الثابت بفراش الزوجية الصحيح والمستقر إلا باللعان الشرعي'),
        QuizOption(optionId: 'opt_qj2_2', text: 'يجوز إلغاء فراش الزوجية ونفي النسب بمجرد فحص مخبري خاص دون لعان'),
        QuizOption(optionId: 'opt_qj2_3', text: 'البصمة الوراثية محرمة شرعاً في جميع الأحوال ولا يعتد بها مطلقاً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أقرت المجامع الفقهية حجية البصمة الوراثية مع استثناء قاطع: حفظ فراش الزوجية وعدم نفي النسب الثابت به إلا باللعان صيانة للأسر من التفكك.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_judiciary_evidence_methods',
      lessonId: 'lsn_judiciary_contemporary_forensics_dna',
      title: 'اختبار طرق الإثبات والشهادة والإقرار والقرائن الجنائية المعاصرة',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
