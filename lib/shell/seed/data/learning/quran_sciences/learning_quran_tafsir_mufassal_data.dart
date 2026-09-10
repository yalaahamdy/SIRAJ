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

/// بيانات مقرر التفسير المنهجي لسورة الفاتحة وقصار المفصل (6 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningQuranTafsirMufassalData {
  static const String courseId = 'course_quran_mufassal_tafsir';
  static const String pathId = 'path_quran_sciences_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر التفسير المنهجي لسورة الفاتحة وقصار المفصل وجزء عم',
      description: 'دراسة تفسيرية تأصيلية وتدبرية شاملة لأم الكتاب سورة الفاتحة وسور جزء عم وقصار المفصل: بيان المفردات، أسباب النزول، الهدايات الإيمانية، والتطبيقات التربوية المعاصرة.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_tafsir_fatihah_short_surahs', 'mod_tafsir_juz_amma_selected'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_tafsir_fatihah_short_surahs',
        courseId: courseId,
        title: 'الوحدة الأولى: تفسير سورة الفاتحة وقصار السور ومقاصدها',
        description: 'تفسير سورة الفاتحة آية بآية، وتفسير سورتي الإخلاص والمعوذتين، وسور النصر والكافرون والمسد والكوثر مع مقاصدها العقدية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_tafsir_surah_fatihah',
          'lsn_tafsir_surahs_ikhlas_falaq_nas',
          'lsn_tafsir_surahs_nasr_kafirun_kawthar',
        ],
      ),
      CourseModule(
        moduleId: 'mod_tafsir_juz_amma_selected',
        courseId: courseId,
        title: 'الوحدة الثانية: تفسير وتدبر سور جزء عم المختارة والهدايات الإيمانية',
        description: 'تفسير سور العصر والقارعة والتكاثر والهمزة، وسور الضحى والشرح والتين، وسور العلق والقدر والزلزلة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_tafsir_fatihah_short_surahs'],
        lessonIds: const [
          'lsn_tafsir_surahs_asr_qariah_takathur',
          'lsn_tafsir_surahs_duha_sharh_tin',
          'lsn_tafsir_surahs_alaq_qadr_zalzalah',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: تفسير سورة الفاتحة
    // -------------------------------------------------------------------------
    final evFatihahHadith = EvidenceLink.create(
      evidenceId: 'ev_fat_hadith_qudsi',
      evidenceKey: 'hadith_qudsi_salah_fatihah',
      citation: 'صحيح مسلم: رقم 395',
      sourceId: 'src_muslim_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_tafsir_surah_fatihah',
      title: 'تفسير سورة الفاتحة (أم الكتاب والسبع المثاني) آية بآية ومقاصدها العقدية',
      courseId: courseId,
      moduleId: 'mod_tafsir_fatihah_short_surahs',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tm1_1',
          title: 'فهم معاني سورة الفاتحة وأسرارها العقدية والتربوية في الصلاة',
          description: 'تفسير آيات الفاتحة السبع، والحديث القدسي في مناجاة الله، والجمع بين المحبة والخوف والرجاء.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tm1_1',
          title: 'الحديث القدسي الجليل في قسمة الصلاة',
          contentType: LearningContentType.sourceText,
          content: 'عن أبي هريرة رضي الله عنه قال: سمعت رسول الله ﷺ يقول: قال الله تعالى: «قسمتُ الصلاةَ بيني وبين عبدي نصفين ولعبدي ما سأل؛ فإذا قال العبد: {الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ} قال الله: حمدني عبدي، وإذا قال: {الرَّحْمَٰنِ الرَّحِيمِ} قال الله: أثنى عليّ عبدي، وإذا قال: {مَالِكِ يَوْمِ الدِّينِ} قال: مجّدني عبدي، فإذا قال: {إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ} قال: هذا بيني وبين عبدي ولعبدي ما سأل، فإذا قال: {اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ * صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ} قال: هذا لعبدي ولعبدي ما سأل» رواه مسلم.',
          evidenceLinks: [evFatihahHadith],
          sourceAttribution: 'صحيح مسلم رقم 395',
        ),
        LessonSection.create(
          sectionId: 'sec_tm1_2',
          title: 'التفسير التحليلي لآيات الفاتحة السبع',
          contentType: LearningContentType.explanation,
          content: 'سورة الفاتحة هي أعظم سورة في القرآن، حوت مجمل معاني القرآن كله:\n1. {الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ}: استحقاق الله الكامل لجميع المحامد لكمال أسمائه وصفاته، والربوبية الشاملة لجميع المخلوقات وتدبير شؤونهم.\n2. {الرَّحْمَٰنِ الرَّحِيمِ}: اسمان عظيمان؛ الرحمن دال على الصفة الذاتية وسعة الرحمة، والرحيم دال على إيصالها للمؤمنين.\n3. {مَالِكِ يَوْمِ الدِّينِ}: إفراد الله بالملك والعدل يوم الجزاء والحساب.\n4. {إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ}: سر القرآن وخلاصته؛ البراءة من الشرك (إياك نعبد)، والبراءة من الحول والقوة (إياك نستعين).\n5. {اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ}: أعظم دعاء بسؤال الهداية إلى الطريق الواضح وهو الإسلام والسنة، والثبات عليه.\n6. {صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ}: النبيون والصديقون والشهداء والصالحون.\n7. {غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ}: المغضوب عليهم هم من عرفوا الحق وتركوه (كاليهود)، والضالون هم من عبدوا الله على جهل بلا علم (كالنصارى).',
          sourceAttribution: 'مدارج السالكين لابن القيم، وتفسير السعدي ص 39',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_saadi_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: الإخلاص والمعوذتين
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_tafsir_surahs_ikhlas_falaq_nas',
      title: 'تفسير سورتي الإخلاص والمعوذتين (الفلق والناس) ومقاصد التوحيد والاعتصام',
      courseId: courseId,
      moduleId: 'mod_tafsir_fatihah_short_surahs',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tm2_1',
          title: 'فهم معاني قوافل التوحيد والتحصين النبوي',
          description: 'تفسير الصمد والأحد، والاستعاذة برب الفلق من شرور المخلوقات، والاستعاذة برب الناس من الوسواس الخناس.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tm2_1',
          title: 'فضل سورة الإخلاص وتعديلها لثلث القرآن',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «أيعجز أحدكم أن يقرأ في ليلة ثلث القرآن؟ قالوا: وكيف يقرأ ثلث القرآن؟ قال: {قُلْ هُوَ اللَّهُ أَحَدٌ} تعدل ثلث القرآن» رواه مسلم.',
          sourceAttribution: 'صحيح مسلم رقم 811',
        ),
        LessonSection.create(
          sectionId: 'sec_tm2_2',
          title: 'تفسير سورة الإخلاص والمعوذتين',
          contentType: LearningContentType.explanation,
          content: 'سورة الإخلاص تضمنت التوحيد العلمي الخبري ونفي الشريك والولد والوالد؛ فالأحد: المنفرد بالكمال، والصمد: السيد الذي كمل في سؤدده وتصمد إليه الخلائق في حوائجها.\nوسورتا المعوذتين فيهما النجاة من كل الشرور:\n- الفلق: استعاذة برب الصبح {مِن شَرِّ مَا خَلَقَ} من الإنس والجن والهوام، و{غَاسِقٍ إِذَا وَقَبَ} وهو الليل إذا أظلم ودخلت فيه الشياطين، و{النَّفَّاثَاتِ فِي الْعُقَدِ} السواحر اللاتي يعقدن الخيوط وينفثن فيها بالسحر، و{حَاسِدٍ إِذَا حَسَدَ}.\n- الناس: استعاذة برب الناس وملكهم وإلههم من العدو الداخلي: {الْوَسْوَاسِ الْخَنَّاسِ} الذي يوسوس عند الغفلة ويخنس (يختفي ويندحر) عند ذكر الله، سواء كان من شياطين الجن أو شياطين الإنس.',
          sourceAttribution: 'تفسير ابن كثير ج 8 ص 530',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_ibn_kathir_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: سور النصر والكافرون والمسد والكوثر
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_tafsir_surahs_nasr_kafirun_kawthar',
      title: 'تفسير سور النصر، الكافرون، المسد، والكوثر: معاني البراءة والفتح والكوثر',
      courseId: courseId,
      moduleId: 'mod_tafsir_fatihah_short_surahs',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tm3_1',
          title: 'تدبر دلالات البراءة من الكفر وبشائر النصر وأعطيات النبي ﷺ',
          description: 'تفسير سورة الكافرون وبراءتها التامة، وسورة النصر ونعي النبي ﷺ، وحفظ الله لنبيه في الكوثر وإهلاك أعدائه.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tm3_1',
          title: 'فهم ابن عباس لسورة النصر',
          contentType: LearningContentType.sourceText,
          content: 'عن ابن عباس رضي الله عنهما قال: كان عمر يدخلني مع أشياخ بدر... فقال: ما تقولون في قول الله: {إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ}؟ فقال بعضهم: أمرنا أن نحمد الله ونستغفره إذا نصرنا وفتح علينا... فقلت: هو أجل رسول الله ﷺ أعلمه له... فقال عمر: ما أعلم منها إلا ما تعلم! رواه البخاري.',
          sourceAttribution: 'صحيح البخاري رقم 4970',
        ),
        LessonSection.create(
          sectionId: 'sec_tm3_2',
          title: 'المعاني الهادية لسور الكافرون والكوثر والمسد',
          contentType: LearningContentType.explanation,
          content: '- سورة الكافرون: سورة الإخلاص العملي والتوحيد القاطع للبراءة من عبادة غير الله؛ فلا مداهنة ولا مساومة في أصل التوحيد {لَكُمْ دِينُكُمْ وَلِيَ دِينِ}.\n- سورة الكوثر: رد على المشركين الذين قالوا إن محمداً أبتر (مقطوع الأثر بموت أولاده الذكور)، فبين الله أنه أعطاه الكوثر (الخير الكثير العظيم ونهر الجنة)، وأمره بإخلاص الصلاة والذبح لله، وأن مبغضه وشانئه هو الأبتر المقطوع من كل خير وذكر.\n- سورة المسد: وعيد الله الصارم لأبي لهب وامرأته جزاء صدهما عن سبيل الله وإيذائهما لرسول الله ﷺ، وتحقق الوعيد بموتهما على الكفر إعجازاً غيبياً.',
          sourceAttribution: 'تفسير السعدي ص 935',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_saadi_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: سور العصر والقارعة والتكاثر والهمزة
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_tafsir_surahs_asr_qariah_takathur',
      title: 'تفسير سور العصر، القارعة، التكاثر، والهمزة: أصول النجاة وحقيقة الجزاء',
      courseId: courseId,
      moduleId: 'mod_tafsir_juz_amma_selected',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tm4_1',
          title: 'استنباط شروط النجاة الأربعة من سورة العصر والتحذير من التكاثر والهمز',
          description: 'قسم الله بالزمان على خسران جنس الإنسان إلا من حقق: الإيمان، والعمل الصالح، والتواصي بالحق، والتواصي بالصبر.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tm4_1',
          title: 'قول الإمام الشافعي في سورة العصر',
          contentType: LearningContentType.sourceText,
          content: 'قال الإمام الشافعي رحمه الله: «لو ما أنزل الله حجة على خلقه إلا هذه السورة لكفتهم» يعني سورة العصر، لاشتمالها على أسباب النجاة وسعادة الدارين.',
          sourceAttribution: 'تفسير ابن كثير ج 8 ص 500',
        ),
        LessonSection.create(
          sectionId: 'sec_tm4_2',
          title: 'البيان التفسيري لسور العصر والتكاثر والقارعة',
          contentType: LearningContentType.explanation,
          content: '- سورة العصر: أقسم الله بالعصر على أن كل إنسان في خسران وهلاك إلا من اتصف بصفات أربع: الإيمان الصادق، العمل الصالح، التواصي بالحق وثباته، والتواصي بالصبر على طاعة الله ومصائبه.\n- سورة التكاثر: توبيخ للإنسان على انشغاله بالتكاثر في الأموال والأولاد حتى يباغته الموت ويدخل القبر، مع التأكيد على السؤال الحتمي عن النعيم يوم القيامة.\n- سورة القارعة: قرع القلوب بأهوال يوم القيامة حين يكون الناس كالفراش المبثوث وتكون الجبال كالصوف المنفوش، وثقل الموازين بالحسنات أو خفتها بالسيئات ومصيرها الهاوية.\n- سورة الهمزة: وعيد شديد لمن يعيب الناس بلسانه ويلمزهم بحركاته، ظاناً أن ماله الذي جمعه وأحصاه سيخلده، وجزاؤه الحطمة نار الله الموقدة.',
          sourceAttribution: 'في ظلال القرآن لسيد قطب، وتيسير الكريم الرحمن للسعدي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_saadi_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: سور الضحى والشرح والتين
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_tafsir_surahs_duha_sharh_tin',
      title: 'تفسير سور الضحى، الشرح، والتين: مواساة النبي ﷺ ورعاية الله وتكريم الإنسان',
      courseId: courseId,
      moduleId: 'mod_tafsir_juz_amma_selected',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tm5_1',
          title: 'تدبر نعم الله على رسوله ﷺ وانفراج الكرب بعد العسر وخلق الإنسان في أحسن تقويم',
          description: 'بيان نزول سورة الضحى، وانشراح الصدر، وتكريم الله للإنسان بالإيمان ورد الكافر لأسفل سافلين.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tm5_1',
          title: 'بشارة انشراح الصدر واليسر مع العسر',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {أَلَمْ نَشْرَحْ لَكَ صَدْرَكَ * وَوَضَعْنَا عَنكَ وِزْرَكَ * الَّذِي أَنقَضَ ظَهْرَكَ * وَرَفَعْنَا لَكَ ذِكْرَكَ * فَإِنَّ مَعَ الْعُسْرِ يُسْرًا * إِنَّ مَعَ الْعُسْرِ يُسْرًا}.',
          sourceAttribution: 'سورة الشرح: الآيات 1-6',
        ),
        LessonSection.create(
          sectionId: 'sec_tm5_2',
          title: 'الهدايات التربوية للسور الثلاث',
          contentType: LearningContentType.explanation,
          content: '- سورة الضحى: نزلت رداً على المشركين حين أبطأ الوحي فقالوا قلى محمداً ربه، فأقسم الله بالضحى والليل أن ربه ما ودعه وما أبغضه، وذكره برعايته له يتيماً وضالاً وعائلاً، وأمره برعاية اليتيم وعدم قهر السائل والتحدث بنعمة الله.\n- سورة الشرح: منة الله بشرح صدر نبيه ﷺ ووضع حمله ورفع ذكره، والبشارة الربانية بأن مع العسر الواحد يسرين فلا يغلب عسر يسرين أبداً، والأمر بالجد والعبادة عند الفراغ.\n- سورة التين: قسم بالبقاع المباركة (التين والزيتون في فلسطين، طور سينين بمصر، والبلد الأمين مكة) على أن الله خلق الإنسان في أحسن خلقة وتقويم، فإذا انسلخ من الإيمان رُدّ إلى أسفل سافلين في النار، واستثناء الذين آمنوا وعملوا الصالحات فلهم أجر غير ممنون.',
          sourceAttribution: 'أضواء البيان للشنقيطي ج 9 ص 55',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_adhwa_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 6: سور العلق والقدر والزلزلة
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_tafsir_surahs_alaq_qadr_zalzalah',
      title: 'تفسير سور العلق، القدر، والزلزلة: بدء الوحي، فضل ليلة القدر، ودقة الحساب',
      courseId: courseId,
      moduleId: 'mod_tafsir_juz_amma_selected',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tm6_1',
          title: 'معرفة أول ما نزل من القرآن وفضل ليلة القدر والجزاء بمثقال الذرة',
          description: 'أمر القراءة والعلم، ليلة القدر خير من ألف شهر، وزلزلة الأرض وإخراج أثقالها للجزاء الدقيق.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tm6_1',
          title: 'الجزاء المطلق الدقيق بمثاقيل الذر',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {إِذَا زُلْزِلَتِ الْأَرْضُ زِلْزَالَهَا * وَأَخْرَجَتِ الْأَرْضُ أَثْقَالَهَا}... إلى قوله: {فَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْرًا يَرَهُ * وَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ شَرًّا يَرَهُ}. وقال ﷺ: «هي آية فاذة جامعة».',
          sourceAttribution: 'سورة الزلزلة: الآيات 1-8، وصحيح البخاري ومسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_tm6_2',
          title: 'التفسير والتدبر الموضوعي لسور العلق والقدر والزلزلة',
          contentType: LearningContentType.explanation,
          content: '- سورة العلق: أول ما نزل من الوحي في غار حراء {اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ} تعليماً لمقام العلم والقراءة بالقلم، والتحذير من طغيان الإنسان إذا رأى نفسه استغنى بالمال، ووعيد أبي جهل حين نهى النبي عن الصلاة بالسحب بالناصية.\n- سورة القدر: بيان شرف الليلة التي نزل فيها القرآن، وأن العبادة فيها خير من عبادة ألف شهر (أكثر من 83 سنة)، وتنزل الملائكة والروح (جبريل) فيها بالسلام حتى مطلع الفجر.\n- سورة الزلزلة: بيان انقلاب نظام الأرض عند قيام الساعة وزلزلتها وشهادتها على ما عُمل على ظهرها، وانقسام الناس إلى شقي وسعيد بحساب دقيق لا يغادر مثقال ذرة من خير أو شر.',
          sourceAttribution: 'تفسير السعدي، وجامع البيان للطبري',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_tabari_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Surah Al-Fatihah
    final q1 = QuizQuestion.create(
      questionId: 'q_tm_fatihah_1',
      lessonId: 'lsn_tafsir_surah_fatihah',
      questionText: 'من هم «المغضوب عليهم» و «الضالون» المذكورون في ختام سورة الفاتحة كما جاء في التفسير النبوي الصحيح؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qmf1_1', text: 'المغضوب عليهم هم من عرفوا الحق وتركوه (كاليهود)، والضالون هم من عبدوا الله بغير علم (كالنصارى)'),
        QuizOption(optionId: 'opt_qmf1_2', text: 'المغضوب عليهم هم المنافقون فقط، والضالون هم المشركون'),
        QuizOption(optionId: 'opt_qmf1_3', text: 'كلاهما صنف واحد من الكفار بلا فرق'),
      ],
      correctOptionIndices: const [0],
      explanation: 'ثبت عن النبي ﷺ في الحديث الصحيح عند الترمذي وأحمد أن المغضوب عليهم هم اليهود لأنهم علموا ولم يعملوا، والضالون هم النصارى لأنهم عملوا بلا علم.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_tafsir_fatihah_ikhlas',
      lessonId: 'lsn_tafsir_surah_fatihah',
      title: 'اختبار تفسير سورة الفاتحة ومقاصدها العقدية',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Short Surahs (Nasr & Kawthar)
    final q2 = QuizQuestion.create(
      questionId: 'q_tm_short_1',
      lessonId: 'lsn_tafsir_surahs_nasr_kafirun_kawthar',
      questionText: 'ما المعنى العظيم الذي فهمه الصحابي الجليل عبد الله بن عباس رضي الله عنهما من سورة النصر؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qms1_1', text: 'أنها علامة وإشعار بقرب أجل ووفاة رسول الله ﷺ بعد إتمام البلاغ والنصر'),
        QuizOption(optionId: 'opt_qms1_2', text: 'أنها أمر بفتح بلاد الروم وفارس فقط'),
        QuizOption(optionId: 'opt_qms1_3', text: 'أنها إعلام بتخليد النبي ﷺ في الدنيا'),
      ],
      correctOptionIndices: const [0],
      explanation: 'فهم ابن عباس وعمر بن الخطاب رضي الله عنهما أن كمال النصر ودخول الناس في الدين أفواجاً دليل على تمام الرسالة وقرب انتقال النبي ﷺ إلى الرفيق الأعلى.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_tafsir_short_surahs',
      lessonId: 'lsn_tafsir_surahs_nasr_kafirun_kawthar',
      title: 'اختبار تفسير سور النصر والكافرون والكوثر',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Juz Amma (Asr & Qadr & Zalzalah)
    final q3 = QuizQuestion.create(
      questionId: 'q_tm_amma_1',
      lessonId: 'lsn_tafsir_surahs_alaq_qadr_zalzalah',
      questionText: 'كم تعدل ليلة القدر في الفضل والثواب كما نصت صراحة سورة القدر؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qma1_1', text: 'خير من ألف شهر (أي عبادة أكثر من 83 سنة)'),
        QuizOption(optionId: 'opt_qma1_2', text: 'تعدل مئة شهر فقط'),
        QuizOption(optionId: 'opt_qma1_3', text: 'تعدل سنة واحدة كاملة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قال تعالى: {لَيْلَةُ الْقَدْرِ خَيْرٌ مِّنْ أَلْفِ شَهْرٍ}، فالعمل الصالح فيها أفضل من العمل في ألف شهر ليس فيها ليلة القدر.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_tafsir_juz_amma',
      lessonId: 'lsn_tafsir_surahs_alaq_qadr_zalzalah',
      title: 'اختبار تفسير سور جزء عم المختارة وهداياتها',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
