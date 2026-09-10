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

/// بيانات مقرر فقه البيوع والعقود المالية ومفسداتها والخيارات (6 دروس تأصيلية + اختباران استيعاب)
class LearningMuamalatBuyuData {
  static const String courseId = 'course_fiqh_buyu_contracts';
  static const String pathId = 'path_fiqh_muamalat_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه البيوع والعقود المالية والخيارات ومفسداتها',
      description: 'دراسة تأصيلية فقهية لأحكام البيوع والمعاملات المالية: أركان العقد وشروطه، ضوابط التراضي، أحكام الخيارات، ومفسدات العقود من الربا والغرر وبيوع الغش والاحتكار.',
      level: lp.LearningLevel.intermediate,
      moduleIds: const ['mod_buyu_pillars_options', 'mod_buyu_prohibitions_corruptions'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_buyu_pillars_options',
        courseId: courseId,
        title: 'الوحدة الأولى: أركان البيع وشروطه والتراضي وأنواع الخيارات الفقهية',
        description: 'بيان مشروعية البيع، وأركانه، وشروط العاقدين والمعقود عليه، والخيارات الفقهية كخيار المجلس والشرط والعيب.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_buyu_pillars_legality',
          'lsn_buyu_subject_conditions',
          'lsn_buyu_options_disputes',
        ],
      ),
      CourseModule(
        moduleId: 'mod_buyu_prohibitions_corruptions',
        courseId: courseId,
        title: 'الوحدة الثانية: مفسدات العقود والبيوع المنهي عنها والربا والغرر',
        description: 'دراسة تفصيلية لقواعد تحريم الربا بنوعيه، والغرر المفسد للعقود، وبيوع الغش والاحتكار والضرر العام.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_buyu_pillars_options'],
        lessonIds: const [
          'lsn_buyu_riba_categories',
          'lsn_buyu_gharar_uncertainty',
          'lsn_buyu_prohibited_sales',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: مشروعية البيع وأركانه والتراضي
    // -------------------------------------------------------------------------
    final evLegality = EvidenceLink.create(
      evidenceId: 'ev_buyu_quran_275',
      evidenceKey: '2:275',
      citation: 'سورة البقرة: الآية 275 {وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا}',
      sourceId: 'src_quran_canonical',
    );
    final evTaradi = EvidenceLink.create(
      evidenceId: 'ev_buyu_taradi',
      evidenceKey: '4:29',
      citation: 'سورة النساء: الآية 29 {إِلَّا أَن تَكُونَ تِجَارَةً عَن تَرَاضٍ مِّنكُمْ}',
      sourceId: 'src_quran_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_buyu_pillars_legality',
      title: 'مشروعية البيع وأركانه وضوابط التراضي وصيغة العقد',
      courseId: courseId,
      moduleId: 'mod_buyu_pillars_options',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mb1_1',
          title: 'مشروعية البيع وحكمته',
          description: 'استيعاب حكمة تشريع البيع في تبادل المنافع وقضاء حاجات العباد بالعدل.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb1_2',
          title: 'أركان عقد البيع الثلاثة',
          description: 'معرفة أركان البيع: العاقدان (البائع والمشتري)، والمعقود عليه (الثمن والمثمن)، والصيغة (الإيجاب والقبول).',
        ),
        LearningObjective(
          objectiveId: 'obj_mb1_3',
          title: 'ضوابط التراضي وأهلية التصرف',
          description: 'معرفة شروط التراضي وانتفاء الإكراه، وشروط الأهلية من البلوغ والعقل والرشد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mb1_1',
          title: 'مشروعية البيع وركن التراضي الأعظم',
          contentType: LearningContentType.sourceText,
          content: 'البيع مباح ومندوب إليه بنص القرآن الكريم والسنة المطهرة وإجماع الأمة؛ قال الله تعالى: {وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا}، وقال سبحانه: {يَا أَيُّهَا الَّذِينَ آمَنُوا لَا تَأْكُلُوا أَمْوَالَكُم بَيْنَكُم بِالْبَاطِلِ إِلَّا أَن تَكُونَ تِجَارَةً عَن تَرَاضٍ مِّنكُمْ}. والركن الجوهري في البيع هو الرضا المتبادل، فلا يصح البيع مع الإكراه بغير حق، ولا مع التلبيس الذي يزيل حقيقة الاختيار.',
          evidenceLinks: [evLegality, evTaradi],
          sourceAttribution: 'تفسير ابن كثير والمغني لابن قدامة',
        ),
        LessonSection.create(
          sectionId: 'sec_mb1_2',
          title: 'صيغة العقد (الإيجاب والقبول) والتعاقد المعاصر',
          contentType: LearningContentType.explanation,
          content: 'ينعقد البيع بصيغتين:\n1. الصيغة القولية: بالإيجاب الصادر من البائع (كقوله: بعتك)، والقبول الصادر من المشتري (كقوله: اشتريت).\n2. الصيغة الفعلية (المعاطاة): بالأخذ والإعطاء الدالين على الرضا عرفاً كالشراء من المتاجر الحديثة.\nوفي المعاملات الإلكترونية المعاصرة، ينعقد العقد بملء النموذج والضغط على زر تأكيد الشراء واستلام الإشعار، حيث يقوم ذلك مقام الإيجاب والقبول المعتبرين شرعاً.',
          sourceAttribution: 'فقه المعاملات المالية للأشقر وقرارات مجمع الفقه الإسلامي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: شروط المعقود عليه (المبيع والثمن)
    // -------------------------------------------------------------------------
    final evMaLaYumlik = EvidenceLink.create(
      evidenceId: 'ev_buyu_tirmidhi_1232',
      evidenceKey: 'tirmidhi:1232',
      citation: 'جامع الترمذي: «لا تبع ما ليس عندك»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_buyu_subject_conditions',
      title: 'شروط المعقود عليه: الملكية والقدرة على التسليم والطهارة والمنفعة',
      courseId: courseId,
      moduleId: 'mod_buyu_pillars_options',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mb2_1',
          title: 'ملكية المبيع التامة',
          description: 'معرفة شرط أن يكون المبيع مملوكاً للبائع وقت العقد أو مأذوناً له فيه شرعاً.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb2_2',
          title: 'القدرة على التسليم وانتفاء الغرر',
          description: 'فهم بطلان بيع ما لا يقدر على تسليمه كالسمك في الماء أو الطير في الهواء.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb2_3',
          title: 'طهارة العين والمنفعة المباحة',
          description: 'إدراك تحريم بيع الأعيان النجسة أو المحرمة كالمسكرات ولحم الخنزير.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mb2_1',
          title: 'شروط المبيع الخمسة المقررة فقهاً',
          contentType: LearningContentType.explanation,
          content: 'يشترط لصحة المعقود عليه خمسة شروط كلية:\n1. أن يكون مالاً متقوماً مباح المنفعة شرعاً: فلا يصح بيع الخمر أو الخنزير أو الميتة أو آلات اللهو المحرمة.\n2. أن يكون مملوكاً للبائع: لحديث حكيم بن حزام: قال رسول الله ﷺ: «لا تبع ما ليس عندك».\n3. القدرة على تسليمه: فلا يصح بيع المغصوب ولا الشارد.\n4. العلم به برؤية أو وصف منضبط: لنفي الجهالة المفضية للنزاع.\n5. العلم بالثمن والمثمن قدراً وجنساً وصفة.',
          evidenceLinks: [evMaLaYumlik],
          sourceAttribution: 'بداية المجتهد لابن رشد والمبدع لابن مفلح',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: الخيارات الفقهية
    // -------------------------------------------------------------------------
    final evKhiyar = EvidenceLink.create(
      evidenceId: 'ev_buyu_bukhari_2110',
      evidenceKey: 'bukhari:2110',
      citation: 'صحيح البخاري: «البيعان بالخيار ما لم يتفرقا»',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_buyu_options_disputes',
      title: 'أحكام الخيارات الفقهية: خيار المجلس والشرط والعيب والتدليس',
      courseId: courseId,
      moduleId: 'mod_buyu_pillars_options',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mb3_1',
          title: 'خيار المجلس وأحكامه',
          description: 'فهم حق العاقدين في الرجوع عن البيع ما داما في مجلس العقد ولم يتفرقا.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb3_2',
          title: 'خيار الشرط وضوابطه',
          description: 'معرفة صحة اشتراط مهلة للتروي والتقليب باتفاق العاقدين.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb3_3',
          title: 'خيار العيب وحكم الغبن والتدليس',
          description: 'استيعاب حق المشتري في رد المبيع إذا وجد به عيباً ينقص قيمته أو كتمه البائع.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mb3_1',
          title: 'مشروعية الخيار وحكمته التشريعية',
          contentType: LearningContentType.sourceText,
          content: 'شرع الإسلام الخيارات رحمة بالمتعاقدين حتى لا يقع أحدهما في ندم أو غبن؛ روى البخاري ومسلم عن ابن عمر رضي الله عنهما عن النبي ﷺ قال: «البَيِّعَانِ بالخِيَارِ ما لَمْ يَتَفَرَّقَا، أَوْ يَقُولَ أَحَدُهُمَا لِصَاحِبِهِ: اخْتَرْ... فَإِنْ صَدَقَا وَبَيَّنَا بُورِكَ لَهُمَا فِي بَيْعِهِمَا، وَإِنْ كَتَمَا وَكَذَبَا مُحِقَتْ بَرَكَةُ بَيْعِهِمَا».',
          evidenceLinks: [evKhiyar],
          sourceAttribution: 'صحيح البخاري: كتاب البيوع',
        ),
        LessonSection.create(
          sectionId: 'sec_mb3_2',
          title: 'تفصيل أنواع الخيارات الأربعة',
          contentType: LearningContentType.explanation,
          content: '1. خيار المجلس: يثبت للمتعاقدين حق الفسخ منذ صدور الإيجاب حتى يتفرقا بأبدانهما من مكان التبايع.\n2. خيار الشرط: أن يشترط أحد المتعاقدين أو كلاهما مدة معلومة (كيوم أو أسبوع) لإمضاء العقد أو فسخه.\n3. خيار العيب: يثبت للمشتري إذا ظهر في المبيع عيب قديم ينقص القيمة عادة ولم يعلمه وقت العقد، فله الخيار بين الرد واسترداد كامل الثمن، أو الإمساك مع أخذ الأرش (فارق القيمة).\n4. خيار التدليس: إذا أظهر البائع المبيع بصفة حسنة كاذبة تزيد الثمن، فيحق للمشتري فسخ العقد.',
          sourceAttribution: 'زاد المستقنع والشرح الممتع لابن عثيمين',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: الربا وأقسامه
    // -------------------------------------------------------------------------
    final evRibaHadith = EvidenceLink.create(
      evidenceId: 'ev_buyu_muslim_1587',
      evidenceKey: 'muslim:1587',
      citation: 'صحيح مسلم: «الذهب بالذهب، والفضة بالفضة... يداً بيد مثلاً بمثل»',
      sourceId: 'src_hadith_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_buyu_riba_categories',
      title: 'الربا: حقيقته وتحريمه القطعي والفرق بين ربا الفضل وربا النسيئة',
      courseId: courseId,
      moduleId: 'mod_buyu_prohibitions_corruptions',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mb4_1',
          title: 'حرمة الربا ومخاطره الاقتصادية',
          description: 'إدراك شناعة الربا وإعلانه حرباً من الله ورسوله، وتدميره للعدالة الاقتصادية والإنتاج.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb4_2',
          title: 'ربا الفضل وضوابط الأصناف الستة',
          description: 'معرفة ربا الفضل وهو الزيادة في أحد البدلين الربويين المتحدي الجنس.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb4_3',
          title: 'ربا النسيئة وربا الديون المعاصر',
          description: 'فهم ربا النسيئة (التأخير في التقابض أو الزيادة مقابل الأجل) وهو أساس الفوائد المصرفية المحرمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mb4_1',
          title: 'الحديث التأسيسي في أحكام الربا والأموال الربوية الستة',
          contentType: LearningContentType.sourceText,
          content: 'روى مسلم عن عبادة بن الصامت رضي الله عنه قال: قال رسول الله ﷺ: «الذَّهَبُ بالذَّهَبِ، والْفِضَّةُ بالفِضَّةِ، والْبُرُّ بالبُرِّ، والشَّعِيرُ بالشَّعِيرِ، والتَّمْرُ بالتَّمْرِ، والْمِلْحُ بالمِلْحِ، مِثْلًا بمِثْلٍ، سَوَاءً بسَوَاءٍ، يَدًا بيَدٍ، فإذا اخْتَلَفَتْ هذِه الأجْنَاسُ، فَبِيعُوا كيفَ شِئْتُمْ، إذَا كانَ يَدًا بيَدٍ».',
          evidenceLinks: [evRibaHadith],
          sourceAttribution: 'صحيح مسلم: كتاب المساقاة',
        ),
        LessonSection.create(
          sectionId: 'sec_mb4_2',
          title: 'قواعد التبادل الفقهية في الأموال الربوية',
          contentType: LearningContentType.scholarlyView,
          content: 'استنبط الفقهاء قاعدتين ذهبيتين في التبادل:\n1. إذا بيع مال ربوي بجنسه (كذهب بذهب، أو تمر بتمر، أو ريال بريال): وجب التماثل التام (حلولاً وقدراً) والتقابض الفوري في مجلس العقد، فإن وجد تفاضل فهو "ربا فضل"، وإن وجد تأخير فهو "ربا نسيئة".\n2. إذا بيع مال ربوي بغير جنسه مع اتحاد العلة (كالذهب بالفضة، أو الريال بالدولار - علة الثمنية): جاز التفاضل، ووجب التقابض الفوري منعاً لربا النسيئة.\n3. إذا اختلفت العلة (كبيع الذهب بالقمح، أو التمر بالنقود): جاز التفاضل وجاز التأخير إجماعاً.',
          sourceAttribution: 'شرح النووي على مسلم وفقه المعاملات للدكتور وهبة الزحيلي',
        ),
      ],
      sources: const ['src_hadith_canonical', 'src_quran_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: بيوع الغرر والجهالة
    // -------------------------------------------------------------------------
    final evGhararHadith = EvidenceLink.create(
      evidenceId: 'ev_buyu_muslim_1513',
      evidenceKey: 'muslim:1513',
      citation: 'صحيح مسلم: «نهى رسول الله ﷺ عن بيع الحصاة، وعن بيع الغرر»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_buyu_gharar_uncertainty',
      title: 'الغرر والجهالة: ضابط الغرر المفسد للعقود وتطبيقاته المعاصرة',
      courseId: courseId,
      moduleId: 'mod_buyu_prohibitions_corruptions',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mb5_1',
          title: 'تعريف الغرر وحكمة النهي عنه',
          description: 'معرفة الغرر بأنه ما كان مستور العاقبة ومجهول النتيجة مفضياً للنزاع وأكل أموال الناس بالباطل.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb5_2',
          title: 'شروط الغرر المفسد للعقد',
          description: 'التمييز بين الغرر الكثير المؤثر في العقد وبين الغرر اليسير المغتفر الذي يشق الاحتراز منه.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb5_3',
          title: 'نماذج وتطبيقات الغرر المعاصرة',
          description: 'إدراك صور الغرر الحديثة كالميسر والمقامرة في اليانصيب وتداول عقود الخيارات (Options) المحرمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mb5_1',
          title: 'النهي النبوي الصريح عن الغرر',
          contentType: LearningContentType.sourceText,
          content: 'روى مسلم عن أبي هريرة رضي الله عنه قال: «نَهَى رَسُولُ اللهِ ﷺ عَنْ بَيْعِ الحَصَاةِ، وَعَنْ بَيْعِ الغَرَرِ». والغرر هو الخطر والجهالة التي لا يُعلم هل يحصل المبيع أم لا، وهل يُسلّم أم يتعذر، مما يجعل العقد شبيهاً بالمقامرة وأكل المال بغير عوض حقيقي.',
          evidenceLinks: [evGhararHadith],
          sourceAttribution: 'صحيح مسلم: كتاب البيوع',
        ),
        LessonSection.create(
          sectionId: 'sec_mb5_2',
          title: 'ضوابط الغرر المؤثر في المعاملات',
          contentType: LearningContentType.explanation,
          content: 'وضع العلماء 4 ضوابط ليكون الغرر مفسداً للعقد:\n1. أن يكون الغرر كثيراً في صلب العقد.\n2. أن يكون في عقد معاوضة مالية (كالبيع والإجارة)، أما في عقود التبرعات (كالهبة والوصية) فيُغتفر.\n3. أن يقع الغرر في المعقود عليه أصالة لا تبعاً (فيجوز بيع الحامل وإن جُهل الجنين لأنه تابع لأمه).\n4. ألا تدعو للعقد حاجة عامة ملحة، فإن دعت إليه حاجة تعم بها البلوى جاز كدخول الحمام بأجر أو ركوب وسائل النقل دون تحديد دقيق لوزن الراكب.',
          sourceAttribution: 'الفروق للقرافي والقواعد النورانية لابن تيمية',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: البيوع المنهي عنها للضرر العام
    // -------------------------------------------------------------------------
    final evIhtikar = EvidenceLink.create(
      evidenceId: 'ev_buyu_muslim_1605',
      evidenceKey: 'muslim:1605',
      citation: 'صحيح مسلم: «لا يحتكر إلا خاطئ»',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_buyu_prohibited_sales',
      title: 'البيوع المنهي عنها للضرر العام: الاحتكار، بيع العينة، والنجش وتلقي الركبان',
      courseId: courseId,
      moduleId: 'mod_buyu_prohibitions_corruptions',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_mb6_1',
          title: 'جريمة الاحتكار وأثرها الاقتصادي',
          description: 'معرفة حكم الاحتكار بحبس السلع الضرورية عن الأسواق لرفع أسعارها وإضرار المجتمع.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb6_2',
          title: 'حيلة بيع العينة والتورق المنظم',
          description: 'استيعاب حيلة بيع العينة للوصول إلى القرض الربوي بفائدة مستترة.',
        ),
        LearningObjective(
          objectiveId: 'obj_mb6_3',
          title: 'النجش والغش في المزايدات وتلقي السلع',
          description: 'معرفة تحريم المزايدة الكاذبة وخداع المشترين وتلقي القادمين للبيع قبل معرفة سعر السوق.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_mb6_1',
          title: 'حرمة الاحتكار والتضييق على الناس',
          contentType: LearningContentType.sourceText,
          content: 'حرّم الإسلام كل معاملة تفضي إلى ظلم المجتمع والتحكم في ضروريات معيشته؛ روى مسلم عن معمر بن عبد الله رضي الله عنه عن رسول الله ﷺ قال: «لَا يَحْتَكِرُ إِلَّا خَاطِئٌ» (أي آثم عاصٍ). وضابط الاحتكار المحرم: هو حبس ما يحتاجه الناس من أقوات وسلع أساسية ينتج عنه غلاء الأسعار والإضرار بالجمهور.',
          evidenceLinks: [evIhtikar],
          sourceAttribution: 'صحيح مسلم والمنتقى للباجي',
        ),
        LessonSection.create(
          sectionId: 'sec_mb6_2',
          title: 'النجش والغش وبيع العينة',
          contentType: LearningContentType.explanation,
          content: '1. النجش: هو الزيادة في ثمن السلعة في المزاد ممن لا يريد شراءها وإنما ليغر غيره ويرفع السعر، وهو محرم بالإجماع.\n2. بيع العينة: أن يبيع شخص سلعة بثمن مؤجل (كـ 12 ألفاً) ثم يشتريها نقداً بثمن أقل (كـ 10 آلاف)، وهي حيلة صريحة لأخذ دراهم بدراهم مع زيادة مؤجلة، وثبت النهي الشديد عنها.\n3. تلقي الركبان: منع البائعين القادمين من خارج المدينة من دخول السوق وشراء سلعهم ببخس قبل أن يعرفوا سعر السوق العادل.',
          sourceAttribution: 'نيل الأوطار للشوكاني والإنصاف للمرداوي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: أركان البيع وشروطه والخيارات
    final q1 = QuizQuestion.create(
      questionId: 'q_buyu_1',
      lessonId: 'lsn_buyu_options_disputes',
      questionText: 'إذا اشترى رجل سلعة ثم وجد بها عيباً قديماً ينقص قيمتها لم يخبره به البائع، فما الحكم الشرعي؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qb1_1', text: 'يثبت له خيار العيب: فله رد السلعة وأخذ كامل الثمن أو إمساكها وأخذ الأرش'),
        QuizOption(optionId: 'opt_qb1_2', text: 'يلزمه البيع ولا خيار له مطلقاً بمجرد مغادرة المحل'),
        QuizOption(optionId: 'opt_qb1_3', text: 'يبطل العقد تلقائياً ويأثم المشتري إذا أمسكها'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يثبت للمشتري خيار العيب شرعاً إذا وجد عيباً قديماً ينقص القيمة عادة، فله حق الرد أو الإمساك مع أخذ الأرش.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_buyu_pillars_options',
      lessonId: 'lsn_buyu_options_disputes',
      title: 'اختبار أركان البيع وشروطه والتراضي وأنواع الخيارات الشرعية',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: مفسدات العقود والربا والغرر
    final q2 = QuizQuestion.create(
      questionId: 'q_buyu_2',
      lessonId: 'lsn_buyu_riba_categories',
      questionText: 'ما هما الشرطان الواجب توافرهما عند مبادلة الذهب بالذهب أو الفضة بالفضة لمنع الوقوع في الربا؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qb2_1', text: 'التماثل التام في الوزن والتقابض الفوري في مجلس العقد (يداً بيد مثلاً بمثل)'),
        QuizOption(optionId: 'opt_qb2_2', text: 'جواز التفاضل في الوزن بشرط أن يكون التقابض فورياً'),
        QuizOption(optionId: 'opt_qb2_3', text: 'تأجيل دفع أحد البدلين بشرط التماثل في الوزن'),
      ],
      correctOptionIndices: const [0],
      explanation: 'عند مبادلة المال الربوي بجنسه (ذهب بذهب) يجب شرطان قطعيان: التماثل التام منعاً لربا الفضل، والتقابض الفوري منعاً لربا النسيئة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_buyu_prohibitions',
      lessonId: 'lsn_buyu_riba_categories',
      title: 'اختبار مفسدات العقود وقواعد الربا والغرر والبيوع المنهي عنها',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
