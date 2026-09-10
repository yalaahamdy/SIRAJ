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

/// بيانات مقرر دراسة العهد المدني وتأسيس الدولة والمغازي الكبرى (6 دروس تأصيلية + اختباران استيعاب)
/// يربط تأصيلياً بالأحداث التاريخية الموثقة في موديول السيرة النبوية بسِراج
class LearningSeerahMedinanData {
  static const String courseId = 'course_seerah_medinan_study';
  static const String pathId = 'path_seerah_history_curriculum';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر دراسة العهد المدني وتأسيس الدولة والمغازي الكبرى',
      description: 'دراسة تأصيلية تاريخية في العهد المدني النبوي: الهجرة الشريفة، بناء المسجد، وثيقة المدينة، المؤاخاة، تحويل القبلة، معارك بدر وأحد والأحزاب، صلح الحديبية، فتح مكة الأعظم، حجة الوداع والوفاة الشريفة، مرتبطاً بموسوعة السيرة بسِراج.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_seerah_medinan_foundations', 'mod_seerah_medinan_conquests'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_seerah_medinan_foundations',
        courseId: courseId,
        title: 'الوحدة الأولى: الهجرة النبوية وتأسيس الدولة ومغازي الفرقان',
        description: 'الهجرة النبوية المباركة، بناء مسجد قباء والمسجد النبوي، وثيقة المدينة الدستورية، المؤاخاة، تحويل القبلة، وغزوات بدر وأحد والخندق.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_seerah_hijrah_foundation',
          'lsn_seerah_charter_qiblah',
          'lsn_seerah_badr_uhud_ahzab',
        ],
      ),
      CourseModule(
        moduleId: 'mod_seerah_medinan_conquests',
        courseId: courseId,
        title: 'الوحدة الثانية: صلح الحديبية والفتوحات الكبرى وحجة الوداع والوفاة',
        description: 'صلح الحديبية ورسائل الملوك، فتح خيبر وفتح مكة الأعظم، غزوة حنين وتبوك، عام الوفود، حجة الوداع والخطبة الجامعة، وانتقال النبي ﷺ إلى الرفيق الأعلى.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_seerah_medinan_foundations'],
        lessonIds: const [
          'lsn_seerah_hudaybiyyah_letters',
          'lsn_seerah_khaybar_fath_makkah',
          'lsn_seerah_wada_passing',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 7: الهجرة وبناء المسجد والمؤاخاة
    // -------------------------------------------------------------------------
    final evHijrah = EvidenceLink.create(
      evidenceId: 'ev_srh_hijrah',
      evidenceKey: 'evt_hijrah_thawr_quba',
      citation: 'موسوعة السيرة بسِراج: الهجرة النبوية وغار ثور وسراقة بن مالك',
      sourceId: 'src_seerah_canonical',
    );
    final evMasjid = EvidenceLink.create(
      evidenceId: 'ev_srh_masjid',
      evidenceKey: 'evt_medina_entry_prophet_mosque',
      citation: 'موسوعة السيرة بسِراج: دخول المدينة المنورة وبناء المسجد النبوي',
      sourceId: 'src_seerah_canonical',
    );
    final evMuakhah = EvidenceLink.create(
      evidenceId: 'ev_srh_muakhah',
      evidenceKey: 'evt_muakhah_brotherhood',
      citation: 'موسوعة السيرة بسِراج: المؤاخاة الكبرى بين المهاجرين والأنصار',
      sourceId: 'src_seerah_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_seerah_hijrah_foundation',
      title: 'الهجرة النبوية المباركة وتأسيس المسجد والمؤاخاة بين المهاجرين والأنصار',
      courseId: courseId,
      moduleId: 'mod_seerah_medinan_foundations',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_smd1_1',
          title: 'معالم الهجرة النبوية المباركة',
          description: 'معرفة التخطيط النبوي المحكم في الهجرة واليقين التام بالله في الغار.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd1_2',
          title: 'بناء المسجد النبوي ومركزيته',
          description: 'إدراك مركزية المسجد في الإسلام كمركز للعبادة والتعليم والقيادة.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd1_3',
          title: 'عقد المؤاخاة الفريد في التاريخ',
          description: 'استيعاب عظمة المؤاخاة بين المهاجرين والأنصار كأعظم نموذج تكافل اجتماعي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_smd1_1',
          title: 'الهجرة النبوية: كمال التوكل والتخطيط البشري',
          contentType: LearningContentType.explanation,
          content: 'خرج النبي ﷺ وصاحبه أبو بكر الصديق في رحلة الهجرة النبوية الشريفة بعد أن خططا بدقة متناهية: مبيت علي في فراشه، الاختباء في غار ثور، دور عبد الله وأسماء وعامر ودليل الطريق. وتجلى التوكل المطلق حين قال أبو بكر: لو نظر أحدهم تحت قدميه لرآنا، فأجابه النبي ﷺ بيقين النبوة: «يا أبا بكر، ما ظنك باثنين الله ثالثهما؟».',
          evidenceLinks: [evHijrah],
          sourceAttribution: 'صحيح البخاري: كتاب مناقب الأنصار',
        ),
        LessonSection.create(
          sectionId: 'sec_smd1_2',
          title: 'بناء المسجد النبوي والمؤاخاة التاريخية',
          contentType: LearningContentType.scholarlyView,
          content: 'أول ما بدأ به النبي ﷺ في المدينة كان تأسيس مسجد قباء ثم بناء المسجد النبوي الشريف ليكون منارة الصلاة والتعلم والقضاء، ثم آخى بين المهاجرين والأنصار مؤاخاة قامت على الإيثار والتوارث (قبل أن ينسخ)، فتنازل الأنصاري عن شطر ماله وداره لأخيه المهاجر في أعظم مشهد تلاحم في تاريخ البشرية.',
          evidenceLinks: [evMasjid, evMuakhah],
          sourceAttribution: 'زاد المعاد لابن القيم وفقه السيرة للغزالي',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 8: وثيقة المدينة وتحويل القبلة
    // -------------------------------------------------------------------------
    final evCharter = EvidenceLink.create(
      evidenceId: 'ev_srh_charter',
      evidenceKey: 'evt_medina_charter_constitution',
      citation: 'موسوعة السيرة بسِراج: وثيقة المدينة الدستورية وأول عقد مواطنة',
      sourceId: 'src_seerah_canonical',
    );
    final evQiblah = EvidenceLink.create(
      evidenceId: 'ev_srh_qiblah',
      evidenceKey: 'evt_qibla_ramadan_zakat',
      citation: 'موسوعة السيرة بسِراج: تحويل القبلة إلى الكعبة المشرفة',
      sourceId: 'src_seerah_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_seerah_charter_qiblah',
      title: 'وثيقة المدينة الدستورية وتحويل القبلة وتشريع الأذان',
      courseId: courseId,
      moduleId: 'mod_seerah_medinan_foundations',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_smd2_1',
          title: 'بنود وثيقة المدينة الدستورية',
          description: 'معرفة أول دستور مكتوب أسس للمواطنة والعدل وحقوق غير المسلمين.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd2_2',
          title: 'تحويل القبلة إلى المسجد الحرام',
          description: 'فهم حكمة تحويل القبلة والرد على المنافقين وتحقيق استقلالية الأمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_smd2_1',
          title: 'وثيقة المدينة: أول دستور مدني جامع للحقوق',
          contentType: LearningContentType.explanation,
          content: 'أبرم النبي ﷺ وثيقة المدينة بين المهاجرين والأنصار واليهود وسائر سكان المدينة؛ فقررت أن المؤمنين أمة واحدة، وضمنت حرية الاعتقاد، وحرمت الظلم، وأوجبت الدفاع المشترك عن المدينة، مما يعد أول دستور مدني يؤصل للحقوق والواجبات والمواطنة العادلة.',
          evidenceLinks: [evCharter],
          sourceAttribution: 'سيرة ابن هشام ومصنف ابن أبي شيبة',
        ),
        LessonSection.create(
          sectionId: 'sec_smd2_2',
          title: 'تحويل القبلة واستقلالية الأمة الإسلامية',
          contentType: LearningContentType.scholarlyView,
          content: 'في رجب أو شعبان من السنة الثانية للهجرة، نزل قوله تعالى: {قَدْ نَرَىٰ تَقَلُّبَ وَجْهِكَ فِي السَّمَاءِ ۖ فَلَنُوَلِّيَنَّكَ قِبْلَةً تَرْضَاهَا ۚ فَوَلِّ وَجْهَكَ شَطْرَ الْمَسْجِدِ الْحَرَامِ}، فتحول المسلمون من بيت المقدس إلى الكعبة المشرفة، في اختبار عظيم للإيمان واستقلالية الأمة وشخصيتها الإيمانية.',
          evidenceLinks: [evQiblah],
          sourceAttribution: 'صحيح البخاري: كتاب التفسير',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_quran_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 9: غزوات الفرقان: بدر وأحد والخندق
    // -------------------------------------------------------------------------
    final evBadr = EvidenceLink.create(
      evidenceId: 'ev_srh_badr',
      evidenceKey: 'evt_badr_great_battle',
      citation: 'موسوعة السيرة بسِراج: غزوة بدر الكبرى ويوم الفرقان الأعظم',
      sourceId: 'src_seerah_canonical',
    );
    final evUhud = EvidenceLink.create(
      evidenceId: 'ev_srh_uhud',
      evidenceKey: 'evt_uhud_archers_sacrifice',
      citation: 'موسوعة السيرة بسِراج: غزوة أحد ودرس طاعة القيادة النبوية',
      sourceId: 'src_seerah_canonical',
    );
    final evKhandaq = EvidenceLink.create(
      evidenceId: 'ev_srh_khandaq',
      evidenceKey: 'evt_ahzab_trench_battle',
      citation: 'موسوعة السيرة بسِراج: غزوة الخندق والأحزاب وحفر الخندق',
      sourceId: 'src_seerah_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_seerah_badr_uhud_ahzab',
      title: 'مغازي الفرقان والتمكين: غزوات بدر الكبرى وأحد والخندق والأحزاب',
      courseId: courseId,
      moduleId: 'mod_seerah_medinan_foundations',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_smd3_1',
          title: 'غزوة بدر الكبرى ويوم الفرقان',
          description: 'معرفة تفاصيل وأسباب انتصار 313 مؤمناً على ألف مشرك وتأييد الملائكة.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd3_2',
          title: 'غزوة أحد والدرس القيادي الخالد',
          description: 'استيعاب درس أحد في خطورة مخالفة أمر القيادة النبوية وأثر الشهادة.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd3_3',
          title: 'غزوة الخندق وحصار الأحزاب',
          description: 'تتبع مشورة سلمان الفارسي في حفر الخندق وابتلاء الزلزال والرياح المرسلة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_smd3_1',
          title: 'يوم الفرقان الأعظم: غزوة بدر الكبرى (17 رمضان 2 هـ)',
          contentType: LearningContentType.explanation,
          content: 'التقى المسلمون (نحو 314 رجلاً) بجيش قريش (نحو 1000 مقاتل) ببدر؛ فاستغاث النبي ﷺ ربه طوال الليل ونزل المدد بالملائكة، فانتصر المسلمون وقُتل صناديد قريش كأبي جهل وعتبة بن ربيعة، فكانت فرقاناً بين الحق والباطل وإعلاناً لمكانة الدولة الإسلامية في جزيرة العرب.',
          evidenceLinks: [evBadr],
          sourceAttribution: 'صحيح البخاري وسورة الأنفال',
        ),
        LessonSection.create(
          sectionId: 'sec_smd3_2',
          title: 'غزوة أحد وغزوة الخندق: تمحيص وثبات',
          contentType: LearningContentType.scholarlyView,
          content: 'في أحد (شوال 3 هـ) لقن الله المسلمين درساً في أثر الرغبة في الغنائم ومخالفة الرماة لأمر النبي ﷺ، فاستشهد حمزة وسبعون صحابياً. وفي الخندق (شوال 5 هـ) تحالف المشركون واليهود في 10 آلاف مقاتل، فأشار سلمان بحفر الخندق، وزُلزل المؤمنون حتى هزم الله الأحزاب بالريح وجنود الغيب.',
          evidenceLinks: [evUhud, evKhandaq],
          sourceAttribution: 'سورة آل عمران وسورة الأحزاب والرحيق المختوم',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_quran_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 10: صلح الحديبية ورسائل الملوك
    // -------------------------------------------------------------------------
    final evHudaybiyyah = EvidenceLink.create(
      evidenceId: 'ev_srh_hudaybiyyah',
      evidenceKey: 'evt_hudaybiyyah_bayat_ridwan',
      citation: 'موسوعة السيرة بسِراج: صلح الحديبية وبيعة الرضوان والفتح المبين',
      sourceId: 'src_seerah_canonical',
    );
    final evLetters = EvidenceLink.create(
      evidenceId: 'ev_srh_letters',
      evidenceKey: 'evt_letters_to_kings',
      citation: 'موسوعة السيرة بسِراج: رسائل النبي ﷺ إلى ملوك وأمراء العالم',
      sourceId: 'src_seerah_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_seerah_hudaybiyyah_letters',
      title: 'صلح الحديبية وبيعة الرضوان والفتح المبين ورسائل النبي ﷺ إلى ملوك العالم',
      courseId: courseId,
      moduleId: 'mod_seerah_medinan_conquests',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_smd4_1',
          title: 'صلح الحديبية وحكمته السياسية والدعوية',
          description: 'فهم حكمة النبي ﷺ في بنود صلح الحديبية ونزول سورة الفتح.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd4_2',
          title: 'عالمية الرسالة ورسائل الملوك والأمراء',
          description: 'تتبع كتب النبي ﷺ إلى كسرى وقيصر والمقوقس والنجاشي لنشر التوحيد عالمياً.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_smd4_1',
          title: 'صلح الحديبية: الفتح المبين وسياسة النبوة الرشيدة',
          contentType: LearningContentType.sourceText,
          content: 'خرج النبي ﷺ في 1400 من أصحابه معتمرين، فصدتهم قريش عند الحديبية، وبايع الصحابة بيعة الرضوان تحت الشجرة، ثم تم الاتفاق على صلح الحديبية بوضع الحرب 10 سنوات. وقد وصف الله هذا الصلح بالفتح المبين: {إِنَّا فَتَحْنَا لَكَ فَتْحًا مُّبِينًا}؛ إذ أتاح الأمن واختلاط الناس فأسلم في سنتين بعد الصلح أضعاف من أسلم في كل السنوات السابقة.',
          evidenceLinks: [evHudaybiyyah],
          sourceAttribution: 'صحيح البخاري: كتاب الشروط',
        ),
        LessonSection.create(
          sectionId: 'sec_smd4_2',
          title: 'رسائل النبي ﷺ إلى أباطرة وملوك الأرض',
          contentType: LearningContentType.scholarlyView,
          content: 'أرسل النبي ﷺ كتبه الممهورة بخاتمه الشريف إلى ملوك الأرض يدعوهم للإسلام: قيصر الروم (هرقل)، كسرى فارس، النجاشي ملك الحبشة، المقوقس حاكم مصر، فكان إعلاناً رسمياً لعالمية الرسالة المحمدية وأنها للناس كافة.',
          evidenceLinks: [evLetters],
          sourceAttribution: 'صحيح البخاري: كتاب بدء الوحي',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 11: فتح مكة وغزوات حنين وتبوك
    // -------------------------------------------------------------------------
    final evKhaybar = EvidenceLink.create(
      evidenceId: 'ev_srh_khaybar',
      evidenceKey: 'evt_khaybar_conquest',
      citation: 'موسوعة السيرة بسِراج: فتح خيبر وراية علي بن أبي طالب',
      sourceId: 'src_seerah_canonical',
    );
    final evFath = EvidenceLink.create(
      evidenceId: 'ev_srh_fath',
      evidenceKey: 'evt_fath_makkah_conquest',
      citation: 'موسوعة السيرة بسِراج: فتح مكة الأعظم وتطهير الكعبة الشريفة والعفو العام',
      sourceId: 'src_seerah_canonical',
    );
    final evTabuk = EvidenceLink.create(
      evidenceId: 'ev_srh_tabuk',
      evidenceKey: 'evt_tabuk_army_of_hardship',
      citation: 'موسوعة السيرة بسِراج: غزوة تبوك وجيش العسرة وتوبة الثلاثة',
      sourceId: 'src_seerah_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_seerah_khaybar_fath_makkah',
      title: 'فتح خيبر وفتح مكة الأعظم وغزوتي حنين وتبوك وجيش العسرة',
      courseId: courseId,
      moduleId: 'mod_seerah_medinan_conquests',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_smd5_1',
          title: 'فتح مكة الأعظم ودخول الناس في دين الله',
          description: 'معرفة أسباب فتح مكة وتطهير البيت الحرام من 360 صنماً وموقف العفو النبوي.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd5_2',
          title: 'غزوة حنين وثبات النبي ﷺ وغزوة تبوك',
          description: 'استيعاب درس عدم الاغترار بالكثرة في حنين وبذل جيش العسرة في تبوك.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_smd5_1',
          title: 'فتح مكة الأعظم (رمضان 8 هـ): قمة التواضع والعفو',
          contentType: LearningContentType.sourceText,
          content: 'دخل النبي ﷺ مكة فاتحاً في 10 آلاف مقاتل، مطأطئاً رأسه على راحلته تواضعاً لله حتى كادت لحيته تلامس واسطة رحله، فكسر 360 صنماً حول الكعبة وهو يتلو: {جَاءَ الْحَقُّ وَزَهَقَ الْبَاطِلُ}، ثم خاطب أهل مكة الذين ناصبوه العداء: «ما ترون أني فاعل بكم؟» قالوا: خيراً أخ كريم وابن أخ كريم، فقال كلمته الخالدة: «اذهبوا فأنتم الطلقاء!».',
          evidenceLinks: [evFath],
          sourceAttribution: 'صحيح البخاري ومسلم وسيرة ابن هشام',
        ),
        LessonSection.create(
          sectionId: 'sec_smd5_2',
          title: 'غزوة حنين وتبوك: استكمال السيادة الإيمانية',
          contentType: LearningContentType.scholarlyView,
          content: 'في حنين كادت الكثرة تعجب المسلمين، فثبت النبي ﷺ كالجبل ونادى: «أنا النبي لا كذب، أنا ابن عبد المطلب»، وتحول الانكسار إلى نصر مؤزر. وفي تبوك (رجب 9 هـ) جهز عثمان جيش العسرة، وسار المسلمون في حر الصيف لملاقاة الروم، ففر أعداؤهم وأقر الله التمكين التام في الجزيرة كلها.',
          evidenceLinks: [evKhaybar, evTabuk],
          sourceAttribution: 'سورة التوبة وزاد المعاد',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_bukhari_canonical', 'src_quran_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 12: حجة الوداع ووفاة النبي ﷺ
    // -------------------------------------------------------------------------
    final evWada = EvidenceLink.create(
      evidenceId: 'ev_srh_wada',
      evidenceKey: 'evt_farewell_hajj_khutbah',
      citation: 'موسوعة السيرة بسِراج: حجة الوداع والخطبة الجامعة وإكمال الدين',
      sourceId: 'src_seerah_canonical',
    );
    final evPassing = EvidenceLink.create(
      evidenceId: 'ev_srh_passing',
      evidenceKey: 'evt_last_days_and_passing',
      citation: 'موسوعة السيرة بسِراج: انتقال النبي ﷺ إلى الرفيق الأعلى وثبات الصديق',
      sourceId: 'src_seerah_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_seerah_wada_passing',
      title: 'عام الوفود وحجة الوداع والخطبة الجامعة والوفاة الشريفة بالمدينة',
      courseId: courseId,
      moduleId: 'mod_seerah_medinan_conquests',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_smd6_1',
          title: 'حجة الوداع والخطبة الجامعة وحقوق الإنسان',
          description: 'استيعاب إعلان حقوق الإنسان وحرمة الدماء والأموال والأعراض وإكمال الشريعة.',
        ),
        LearningObjective(
          objectiveId: 'obj_smd6_2',
          title: 'الوفاة النبوية الشريفة وثبات الصديق',
          description: 'معرفة يوم الفاجعة الكبرى وثبات أبي بكر الصديق وميراث النبوة الخالد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_smd6_1',
          title: 'حجة الوداع والخطبة التاريخية الجامعة (10 هـ)',
          contentType: LearningContentType.sourceText,
          content: 'حج النبي ﷺ حجة الوداع وخطب في عرفات خطبته الجامعة الخالدة: «إن دماءكم وأموالكم وأعراضكم عليكم حرام كحرمة يومكم هذا في شهركم هذا في بلدكم هذا... ألا هل بلغت؟ اللهم فاشهد»، ونزل قوله تعالى: {الْيَوْمَ أَكْمَلْتُ لَكُمْ دِينَكُمْ وَأَتْمَمْتُ عَلَيْكُمْ نِعْمَتِي وَرَضِيتُ لَكُمُ الْإِسْلَامَ دِينًا}.',
          evidenceLinks: [evWada],
          sourceAttribution: 'صحيح مسلم: كتاب الحج',
        ),
        LessonSection.create(
          sectionId: 'sec_smd6_2',
          title: 'وفاة النبي ﷺ وثبات الصديق أبي بكر (12 ربيع الأول 11 هـ)',
          contentType: LearningContentType.scholarlyView,
          content: 'فاضت روح النبي ﷺ الطاهرة وهو في حجر عائشة رضي الله عنها قائلاً: «بل الرفيق الأعلى من الجنة». وذهل الصحابة حتى أقبل أبو بكر الصديق رضي الله عنه وخطب خطبته الفارقة: «أما بعد، فمن كان يعبد محمداً فإن محمداً قد مات، ومن كان يعبد الله فإن الله حي لا يموت»، وتلا قوله تعالى: {وَمَا مُحَمَّدٌ إِلَّا رَسُولٌ قَدْ خَلَتْ مِن قَبْلِهِ الرُّسُلُ}، فثبت الله به الأمة.',
          evidenceLinks: [evPassing],
          sourceAttribution: 'صحيح البخاري: كتاب الجنائز',
        ),
      ],
      sources: const ['src_seerah_canonical', 'src_bukhari_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: تأسيس الدولة وغزوات الفرقان
    final q1 = QuizQuestion.create(
      questionId: 'q_srh_med_1',
      lessonId: 'lsn_seerah_charter_qiblah',
      questionText: 'ما هي الوثيقة التاريخية التي أبرمها النبي ﷺ في المدينة وتعد أول دستور مدني يؤصل للمواطنة والتعايش؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qsmd1_1', text: 'وثيقة المدينة الدستورية بين المهاجرين والأنصار واليهود وسكان المدينة'),
        QuizOption(optionId: 'opt_qsmd1_2', text: 'صلح الحديبية'),
        QuizOption(optionId: 'opt_qsmd1_3', text: 'بيعة العقبة الثانية'),
      ],
      correctOptionIndices: const [0],
      explanation: 'وثيقة المدينة هي أول دستور مكتوب في الإسلام نظم العلاقة بين أطياف المجتمع وحفظ حقوق الجميع وأوجب الدفاع المشترك.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_seerah_medinan_foundations',
      lessonId: 'lsn_seerah_charter_qiblah',
      title: 'اختبار تأسيس الدولة النبوية وغزوات الفرقان',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: الفتوحات وصلح الحديبية وحجة الوداع
    final q2 = QuizQuestion.create(
      questionId: 'q_srh_med_2',
      lessonId: 'lsn_seerah_khaybar_fath_makkah',
      questionText: 'ماذا قال النبي ﷺ لأهل مكة يوم فتحها الأعظم بعد أن مكنه الله منهم؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qsmd2_1', text: '«اذهبوا فأنتم الطلقاء!» عفواً وصفحاً وإحساناً'),
        QuizOption(optionId: 'opt_qsmd2_2', text: 'أمر بقتلهم جميعاً قصاصاً'),
        QuizOption(optionId: 'opt_qsmd2_3', text: 'أمر بمصادرة كل دورهم وأموالهم'),
      ],
      correctOptionIndices: const [0],
      explanation: 'ضرب النبي ﷺ أروع أمثلة العفو عند المقدرة يوم فتح مكة حين عفا عن قريش وقال لهم: «اذهبوا فأنتم الطلقاء».',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_seerah_medinan_conquests',
      lessonId: 'lsn_seerah_khaybar_fath_makkah',
      title: 'اختبار الفتوحات الكبرى وصلح الحديبية وحجة الوداع',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
