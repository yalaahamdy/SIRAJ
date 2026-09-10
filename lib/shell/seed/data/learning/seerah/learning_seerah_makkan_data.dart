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

/// بيانات مقرر دراسة العهد المكي والبعثة النبوية والابتلاءات (6 دروس تأصيلية + اختباران استيعاب)
/// يربط تأصيلياً بالأحداث التاريخية الموثقة في موديول السيرة النبوية بسِراج
class LearningSeerahMakkanData {
  static const String courseId = 'course_seerah_makkan_study';
  static const String pathId = 'path_seerah_history_curriculum';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر دراسة العهد المكي والبعثة النبوية والابتلاءات',
      description: 'دراسة تأصيلية منهجية في سيرة المصطفى ﷺ خلال العهد المكي: من المولد والنشأة الشريفة وبدء نزول الوحي بغار حراء، إلى الجهر بالدعوة والابتلاءات والهجرتين وعام الحزن والإسراء والمعراج وبيعة العقبة، مرتبطاً بأحداث موسوعة السيرة النبوية بسِراج.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_seerah_makkan_early', 'mod_seerah_makkan_late'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_seerah_makkan_early',
        courseId: courseId,
        title: 'الوحدة الأولى: المولد النبوي الشريف والنشأة وبدء الوحي والجهر بالدعوة',
        description: 'دراسة مراحل النشأة الشريفة، الرضاعة في بني سعد، حادثة شق الصدر، بناء الكعبة، التعبد في غار حراء، الدعوة السرية وتأسيس دار الأرقم، والصدع بالحق على جبل الصفا.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_seerah_mowlid_youth',
          'lsn_seerah_wahy_hira',
          'lsn_seerah_safa_call_dawah',
        ],
      ),
      CourseModule(
        moduleId: 'mod_seerah_makkan_late',
        courseId: courseId,
        title: 'الوحدة الثانية: الابتلاءات والهجرتان وعام الحزن والإسراء والمعراج وبيعة العقبة',
        description: 'دراسة ثبات المستضعفين، الهجرة إلى الحبشة، الحصار في الشِعب، وفاة خديجة وأبي طالب، رحلة الطائف، معجزة الإسراء والمعراج، وبيعتي العقبة الأولى والثانية.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_seerah_makkan_early'],
        lessonIds: const [
          'lsn_seerah_trials_abyssinia',
          'lsn_seerah_sorrow_isra_miraj',
          'lsn_seerah_aqabah_pledges_prep',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: المولد النبوي الشريف والنشأة الكريمة
    // -------------------------------------------------------------------------
    final evMowlid = EvidenceLink.create(
      evidenceId: 'ev_srh_mowlid',
      evidenceKey: 'evt_mowlid_childhood',
      citation: 'موسوعة السيرة بسِراج: المولد النبوي والرضاعة وحادثة شق الصدر',
      sourceId: 'src_seerah_canonical',
      context: 'توثيق الحدث الأول من العهد المكي الشريف',
    );
    final evKaba = EvidenceLink.create(
      evidenceId: 'ev_srh_kaba',
      evidenceKey: 'evt_kaaba_rebuilding',
      citation: 'موسوعة السيرة بسِراج: إعادة بناء الكعبة والتحكيم الشريف',
      sourceId: 'src_seerah_canonical',
      context: 'حكمة النبي ﷺ في وضع الحجر الأسود',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_seerah_mowlid_youth',
      title: 'المولد النبوي الشريف والنشأة الكريمة وبناء الكعبة وحلف الفضول',
      courseId: courseId,
      moduleId: 'mod_seerah_makkan_early',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_sm1_1',
          title: 'النسب الشريف والمولد المبارك',
          description: 'معرفة نسب النبي ﷺ ومولده الشريف في عام الفيل ورعايته الإلهية في يتمه.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm1_2',
          title: 'الرضاعة في بني سعد وحادثة شق الصدر',
          description: 'استيعاب حكمة الرضاعة في البادية والتطهير الرباني لقلب المصطفى ﷺ.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm1_3',
          title: 'حلف الفضول والتحكيم في الكعبة',
          description: 'إدراك مكانة النبي ﷺ الأخلاقية وشهرته بالصادق الأمين وحكمته في وضع الحجر الأسود.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_sm1_1',
          title: 'المولد النبوي الشريف والنشأة في حفظ الله',
          contentType: LearningContentType.explanation,
          content: 'ولد النبي محمد ﷺ صبيحة يوم الإثنين في ربيع الأول من عام الفيل بمكة المكرمة يتيماً بعد وفاة والده عبد الله، فرعاه جده عبد المطلب ثم عمه أبو طالب. وأحاطته العناية الإلهية بحفظ معصوم، فنشأ بعيداً عن دنس الأوثان ورذائل الجاهلية، جامعاً لمكارم الأخلاق حتى لقبه قومه بـ "الصادق الأمين".',
          evidenceLinks: [evMowlid],
          sourceAttribution: 'السيرة النبوية لابن هشام والرحيق المختوم',
        ),
        LessonSection.create(
          sectionId: 'sec_sm1_2',
          title: 'حلف الفضول ونصرة المظلوم وبناء الكعبة',
          contentType: LearningContentType.scholarlyView,
          content: 'شهد النبي ﷺ في شبابه "حلف الفضول" لنصرة المظلوم وإغاثة الملهوف، وقال فيه بعد البعثة: «لقد شهدت في دار عبد الله بن جدعان حلفاً ما أحب أن لي به حمر النعم، ولو أُدعى به في الإسلام لأجبت». وفي سن الخامسة والثلاثين أجمعت قريش على تحكيمه عند تنازعهم في وضع الحجر الأسود، فبسط رداءه الشريف ووضعه فيه ودعا رؤساء القبائل ليأخذوا بأطرافه، فحقن دماءهم بحكمته الفذة.',
          evidenceLinks: [evKaba],
          sourceAttribution: 'زاد المعاد لابن القيم ومسند أحمد',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: بدء نزول الوحي والدعوة السرية
    // -------------------------------------------------------------------------
    final evHira = EvidenceLink.create(
      evidenceId: 'ev_srh_hira',
      evidenceKey: 'evt_first_revelation',
      citation: 'موسوعة السيرة بسِراج: التعبد بغار حراء وبدء نزول الوحي',
      sourceId: 'src_seerah_canonical',
    );
    final evSecret = EvidenceLink.create(
      evidenceId: 'ev_srh_secret',
      evidenceKey: 'evt_dar_al_arqam',
      citation: 'موسوعة السيرة بسِراج: مرحلة الدعوة السرية وتأسيس دار الأرقم',
      sourceId: 'src_seerah_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_seerah_wahy_hira',
      title: 'التعبد في غار حراء وبدء نزول الوحي ومرحلة الدعوة السرية',
      courseId: courseId,
      moduleId: 'mod_seerah_makkan_early',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_sm2_1',
          title: 'بدء الوحي والتحنث في غار حراء',
          description: 'استيعاب كيفية بدء نزول جبريل عليه السلام بقوله «اقرأ» وفضل خديجة رضي الله عنها.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm2_2',
          title: 'مرحلة الدعوة السرية وتأسيس دار الأرقم',
          description: 'معرفة حكمة التدرج النبوي في الدعوة الفردية وتأسيس النواة الأولى للإسلام.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_sm2_1',
          title: 'فجر النبوة وبدء نزول الوحي في غار حراء',
          contentType: LearningContentType.sourceText,
          content: 'حبب إلى النبي ﷺ الخلاء، فكان يتحنث في غار حراء الليالي ذوات العدد، حتى فجأه الحق ونزل عليه جبريل عليه السلام وقال له: «اقرأ»، فقال: «ما أنا بقارئ»، فغطه ثلاثاً حتى بلغ منه الجهد ثم قال: {اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ * خَلَقَ الْإِنسَانَ مِنْ عَلَقٍ * اقْرَأْ وَرَبُّكَ الْأَكْرَمُ}. فرجع بها ترجف بوادره إلى زوجه خديجة رضي الله عنها فثبتته بمقولتها الخالدة: «كلا والله ما يخزيك الله أبداً؛ إنك لتصل الرحم، وتحمل الكل، وتكسب المعدوم، وتقري الضيف، وتعين على نوائب الحق».',
          evidenceLinks: [evHira],
          sourceAttribution: 'صحيح البخاري ومسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_sm2_2',
          title: 'الدعوة السرية والتربية الإيمانية في دار الأرقم',
          contentType: LearningContentType.explanation,
          content: 'استمرت الدعوة سراً نحو ثلاث سنوات، استجاب فيها السابقون الأولون: خديجة بنت خويلد، علي بن أبي طالب، زيد بن حارثة، وأبو بكر الصديق الذي كان سبباً في إسلام عثمان وطلحة والزبير وسعد بن أبي وقاص وعبد الرحمن بن عوف. واتخذ النبي ﷺ من "دار الأرقم بن أبي الأرقم" محضناً تربوياً سرياً لغرس التوحيد والصلاة وتزكية النفوس.',
          evidenceLinks: [evSecret],
          sourceAttribution: 'فقه السيرة للغزالي والرحيق المختوم',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: الجهر بالدعوة والصدع بالحق
    // -------------------------------------------------------------------------
    final evSafa = EvidenceLink.create(
      evidenceId: 'ev_srh_safa',
      evidenceKey: 'evt_safaa_proclamation',
      citation: 'موسوعة السيرة بسِراج: الجهر بالدعوة والنداء على جبل الصفا',
      sourceId: 'src_seerah_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_seerah_safa_call_dawah',
      title: 'الجهر بالدعوة والصدع بالحق على الصفا واشتداد الأذى',
      courseId: courseId,
      moduleId: 'mod_seerah_makkan_early',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_sm3_1',
          title: 'الصدع بالدعوة على جبل الصفا',
          description: 'معرفة نداء النبي ﷺ لقريش وبطونها على جبل الصفا وامتثاله لأمر الله.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm3_2',
          title: 'أساليب قريش في مقاومة الدعوة',
          description: 'تتبع أساليب المشركين من السخرية والتشويه والاتهام بالسحر والكهانة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_sm3_1',
          title: 'النداء التاريخي على جبل الصفا',
          contentType: LearningContentType.sourceText,
          content: 'لما نزل قوله تعالى: {وَأَنذِرْ عَشِيرَتَكَ الْأَقْرَبِينَ}، صعد النبي ﷺ جبل الصفا فجعل ينادي: «يَا صَبَاحَاهْ! يَا بَنِي فِهْرٍ، يَا بَنِي عَدِيٍّ... أَرَأَيْتَكُمْ لَوْ أَخْبَرْتُكُمْ أَنَّ خَيْلًا بِالوَادِي تُرِيدُ أَنْ تُغِيرَ عَلَيْكُمْ، أَكُنْتُمْ مُصَدِّقِيَّ؟» قَالُوا: نَعَمْ، مَا جَرَّبْنَا عَلَيْكَ إِلَّا صِدْقًا، قَالَ: «فَإِنِّي نَذِيرٌ لَكُمْ بَيْنَ يَدَيْ عَذَابٍ شَدِيدٍ». فقال أبو لهب: تباً لك سائر اليوم ألهذا جمعتنا؟ فنزل قوله تعالى: {تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ}.',
          evidenceLinks: [evSafa],
          sourceAttribution: 'صحيح البخاري: كتاب التفسير',
        ),
        LessonSection.create(
          sectionId: 'sec_sm3_2',
          title: 'مواجهة الباطل ووسائل الصد عن سبيل الله',
          contentType: LearningContentType.scholarlyView,
          content: 'لجأت قريش لمواجهة الدعوة بشتى الوسائل: الشبهات والاتهام بالسحر والشعر والجنون، محاولة مساومة أبي طالب، والدعاية المضادة للحجاج في مواسم العرب، ولكن الصدق القرآني والنور النبوي انتشر في الآفاق.',
          sourceAttribution: 'زاد المعاد لابن القيم',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: ثبات المستضعفين والهجرة إلى الحبشة
    // -------------------------------------------------------------------------
    final evTorture = EvidenceLink.create(
      evidenceId: 'ev_srh_torture',
      evidenceKey: 'evt_persecution_torture',
      citation: 'موسوعة السيرة بسِراج: اشتداد اضطهاد قريش وصبر آل ياسر وبلال',
      sourceId: 'src_seerah_canonical',
    );
    final evAbyssinia = EvidenceLink.create(
      evidenceId: 'ev_srh_abyssinia',
      evidenceKey: 'evt_abyssinia_first',
      citation: 'موسوعة السيرة بسِراج: الهجرة الأولى والثانية إلى أرض الحبشة',
      sourceId: 'src_seerah_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_seerah_trials_abyssinia',
      title: 'ثبات المستضعفين والهجرتان إلى الحبشة والحصار في شِعب أبي طالب',
      courseId: courseId,
      moduleId: 'mod_seerah_makkan_late',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_sm4_1',
          title: 'صبر وثبات الرعيل الأول',
          description: 'استلهام دروس الصبر العظيم لبلال بن رباح وآل ياسر وخباب في رمضاء مكة.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm4_2',
          title: 'الهجرة إلى الحبشة وخطاب جعفر',
          description: 'فهم حكمة اختيار الحبشة وموقف النجاشي العادل وخطاب جعفر بن أبي طالب الرائع.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm4_3',
          title: 'الحصار الجائر في شِعب أبي طالب',
          description: 'تتبع حصار قريش الظالم لبني هاشم في الشِعب وصبرهم ونقض الصحيفة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_sm4_1',
          title: 'ملحمة الثبات والصبر في رمضاء مكة',
          contentType: LearningContentType.explanation,
          content: 'أذاقت قريش المستضعفين أصناف العذاب؛ فكان بلال يهتف تحت الصخرة: «أحَدٌ... أحَدْ»، واستشهدت سمية وزوجها ياسر تحت سياط أبي جهل، فقال لهم النبي ﷺ: «صبراً آل ياسر فإن موعدكم الجنة». وعذب خباب برضف الجمر فبشره النبي ﷺ بتمام هذا الدين وأمنه.',
          evidenceLinks: [evTorture],
          sourceAttribution: 'صحيح البخاري ومسند أحمد',
        ),
        LessonSection.create(
          sectionId: 'sec_sm4_2',
          title: 'الهجرة إلى الحبشة وخطاب جعفر بن أبي طالب الخالد',
          contentType: LearningContentType.scholarlyView,
          content: 'أشار النبي ﷺ على أصحابه بالهجرة إلى الحبشة فقال: «إن بها مَلِكاً لا يُظلم عنده أحد»، فهاجر الفوج الأول ثم الفوج الثاني وفيه جعفر بن أبي طالب رضي الله عنه. وهناك ألقى جعفر خطابه البليغ أمام النجاشي واصفاً تحولهم من ظلمات الجاهلية إلى نور الإسلام، وقرأ عليه صدراً من سورة مريم فبكى النجاشي وقال: «إن هذا والذي جاء به عيسى ليخرج من مشكاة واحدة».',
          evidenceLinks: [evAbyssinia],
          sourceAttribution: 'سيرة ابن هشام ومسند أحمد',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: عام الحزن ورحلة الطائف والإسراء والمعراج
    // -------------------------------------------------------------------------
    final evSorrow = EvidenceLink.create(
      evidenceId: 'ev_srh_sorrow',
      evidenceKey: 'evt_year_of_sorrow',
      citation: 'موسوعة السيرة بسِراج: عام الحزن ووفاة خديجة وأبي طالب',
      sourceId: 'src_seerah_canonical',
    );
    final evTaif = EvidenceLink.create(
      evidenceId: 'ev_srh_taif',
      evidenceKey: 'evt_taif_supplication',
      citation: 'موسوعة السيرة بسِراج: رحلة الطائف والدعاء المشهور وإسلام عداس',
      sourceId: 'src_seerah_canonical',
    );
    final evIsra = EvidenceLink.create(
      evidenceId: 'ev_srh_isra',
      evidenceKey: 'evt_isra_miraj',
      citation: 'موسوعة السيرة بسِراج: معجزة الإسراء والمعراج وفرض الصلوات الخمس',
      sourceId: 'src_seerah_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_seerah_sorrow_isra_miraj',
      title: 'عام الحزن ورحلة الطائف ومعجزة الإسراء والمعراج وفرض الصلوات',
      courseId: courseId,
      moduleId: 'mod_seerah_makkan_late',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_sm5_1',
          title: 'عام الحزن ورحلة الطائف',
          description: 'استيعاب ألم وفاة خديجة وأبي طالب وخروج النبي ﷺ إلى الطائف صابراً محتسباً.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm5_2',
          title: 'معجزة الإسراء والمعراج',
          description: 'معرفة الإسراء من المسجد الحرام إلى المسجد الأقصى والمعراج للسموات العلا وفرض الصلاة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_sm5_1',
          title: 'عام الحزن وابتلاء الطائف ودعاء الاستكانة النبوي',
          contentType: LearningContentType.explanation,
          content: 'في السنة العاشرة من البعثة توفي أبو طالب وتوفيت أم المؤمنين خديجة رضي الله عنها، فاشتد أذى قريش، فتوجه النبي ﷺ ماشياً إلى الطائف ليدعو ثقيفاً، فقابلوه بالسفهاء والحجارة حتى أدموا قدميه الشريفتين، فالتجأ إلى بستان ودعا بدعائه الخالد: «اللهم إني أشكو إليك ضعف قوتي وقلة حيلتي وهواني على الناس... إن لم يكن بك عليَّ غضبٌ فلا أبالي»، ورفض إهلاكهم آملاً أن يخرج الله من أصلابهم من يعبده.',
          evidenceLinks: [evSorrow, evTaif],
          sourceAttribution: 'زاد المعاد والرحيق المختوم',
        ),
        LessonSection.create(
          sectionId: 'sec_sm5_2',
          title: 'الإسراء والمعراج: التكريم الإلهي وفرض الصلاة',
          contentType: LearningContentType.scholarlyView,
          content: 'جاءت رحلة الإسراء والمعراج تسلية وتكريماً إلهياً لرسول الله ﷺ؛ فأُسري به ليلاً من المسجد الحرام إلى المسجد الأقصى وصلى بالأنبياء إماماً، ثم عُرج به إلى سدرة المنتهى، وكلّمه ربه وفرض عليه وعلى أمته الصلوات الخمس التي هي عمود الدين.',
          evidenceLinks: [evIsra],
          sourceAttribution: 'صحيح البخاري وصحيح مسلم',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: بيعتا العقبة والتمهيد للهجرة
    // -------------------------------------------------------------------------
    final evAqabah = EvidenceLink.create(
      evidenceId: 'ev_srh_aqabah',
      evidenceKey: 'evt_aqabah_pledges',
      citation: 'موسوعة السيرة بسِراج: بيعتا العقبة الأولى والثانية وإسلام الأنصار',
      sourceId: 'src_seerah_canonical',
    );
    final evHijrah = EvidenceLink.create(
      evidenceId: 'ev_srh_hijrah_prep',
      evidenceKey: 'evt_hijrah_thawr_quba',
      citation: 'موسوعة السيرة بسِراج: الهجرة النبوية المباركة وغار ثور',
      sourceId: 'src_seerah_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_seerah_aqabah_pledges_prep',
      title: 'عرض الدعوة على القبائل وبيعتي العقبة الأولى والثانية والتمهيد للهجرة',
      courseId: courseId,
      moduleId: 'mod_seerah_makkan_late',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_sm6_1',
          title: 'عرض الدعوة على وفود الحجيج',
          description: 'معرفة منهج النبي ﷺ في لقاء القبائل بمواسم منى ولقائه بوفد يثرب المبارك.',
        ),
        LearningObjective(
          objectiveId: 'obj_sm6_2',
          title: 'بيعتا العقبة الأولى والثانية',
          description: 'استيعاب بنود بيعة النساء وبيعة الحرب ودور مصعب بن عمير في فتح المدينة بالقرآن.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_sm6_1',
          title: 'لقاء وفد يثرب وبيعة العقبة الأولى وإرسال مصعب',
          contentType: LearningContentType.explanation,
          content: 'التقى النبي ﷺ بستة نفر من الخزرج عند العقبة بمنى فدعاهم للإسلام فأسلموا، وفي العام التالي جاء اثنا عشر رجلاً فبايعوا بيعة العقبة الأولى على التوحيد ومكارم الأخلاق، وأرسل معهم مصعب بن عمير رضي الله عنه معلماً ومقرئاً، فدخل الإسلام كل دار في يثرب بفضل الله ثم بحكمة مصعب ورفقه.',
          evidenceLinks: [evAqabah],
          sourceAttribution: 'سيرة ابن هشام والرحيق المختوم',
        ),
        LessonSection.create(
          sectionId: 'sec_sm6_2',
          title: 'بيعة العقبة الكبرى والقرار التاريخي بالهجرة',
          contentType: LearningContentType.scholarlyView,
          content: 'في موسم الحج التالي، جاء ثلاثة وسبعون رجلاً وامرأتان من الأنصار وبايعوا النبي ﷺ في ظلام الليل بيعة العقبة الكبرى على نصرته وحمايته مما يحمون منه نساءهم وأبناءهم، فكانت تلك البيعة الميثاق التأسيسي لانتقال الدعوة من مرحلة الاستضعاف إلى مرحلة الدولة والتمكين المبارك.',
          evidenceLinks: [evHijrah],
          sourceAttribution: 'زاد المعاد ومسند أحمد',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: معالم العهد المكي وبدء الوحي
    final q1 = QuizQuestion.create(
      questionId: 'q_srh_makkan_1',
      lessonId: 'lsn_seerah_wahy_hira',
      questionText: 'بماذا أجابت أم المؤمنين خديجة رضي الله عنها رسول الله ﷺ حين رجع يرجف فؤاده من غار حراء؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qsm1_1', text: '«كلا والله ما يخزيك الله أبداً؛ إنك لتصل الرحم، وتحمل الكل، وتكسب المعدوم، وتقري الضيف، وتعين على نوائب الحق»'),
        QuizOption(optionId: 'opt_qsm1_2', text: 'أشارت عليه بالذهاب إلى الحبشة فوراً'),
        QuizOption(optionId: 'opt_qsm1_3', text: 'طلبت منه كتمان الأمر عن الجميع دون تصديق'),
      ],
      correctOptionIndices: const [0],
      explanation: 'استدلت خديجة رضي الله عنها بفطرتها ويقينها على أن صاحب مكارم الأخلاق والإحسان إلى الناس لا يخزيه الله ولا يضيعه أبداً.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_seerah_makkan_early',
      lessonId: 'lsn_seerah_wahy_hira',
      title: 'اختبار النشأة النبوية وبدء نزول الوحي والدعوة المكية',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: الابتلاءات والهجرة والإسراء
    final q2 = QuizQuestion.create(
      questionId: 'q_srh_makkan_2',
      lessonId: 'lsn_seerah_sorrow_isra_miraj',
      questionText: 'ما هي الفريضة العظيمة التي فرضها الله تعالى مباشرة في السماء العلا ليلة الإسراء والمعراج؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qsm2_1', text: 'الصلوات الخمس المفروضة'),
        QuizOption(optionId: 'opt_qsm2_2', text: 'صيام شهر رمضان'),
        QuizOption(optionId: 'opt_qsm2_3', text: 'حج البيت الحرام'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الصلوات الخمس هي العبادة الوحيدة التي فرضت في السماوات العلا ليلة الإسراء والمعراج لعظم قدرها ومكانتها عند الله.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_seerah_makkan_late',
      lessonId: 'lsn_seerah_sorrow_isra_miraj',
      title: 'اختبار الابتلاءات الكبرى والهجرة والإسراء والمعراج',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
