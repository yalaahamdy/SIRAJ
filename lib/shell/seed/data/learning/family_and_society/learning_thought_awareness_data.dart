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

/// بيانات مقرر الفكر الإسلامي المعاصر وبناء الوعي وتفنيد الشبهات (6 دروس تأصيلية + اختباران استيعاب)
class LearningThoughtAwarenessData {
  static const String courseId = 'course_thought_awareness';
  static const String pathId = 'path_family_ethics_society_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الفكر الإسلامي المعاصر وبناء الوعي وتفنيد الشبهات',
      description: 'دراسة تأصيلية فكرية معاصرة لبناء المناعة العقدية والوعي الحضاري: مقومات الهوية الإسلامية، ترسيخ منهج الوسطية والاعتدال ونبذ الغلو، ضوابط التجديد المنضبط، براهين الإيمان ومواجهة الإلحاد والنزعات المادية، والرد العلمي على الشبهات المعاصرة.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_thought_identity_wasatiyyah', 'mod_thought_shubuhat_response'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_thought_identity_wasatiyyah',
        courseId: courseId,
        title: 'الوحدة الأولى: مقومات الهوية الإسلامية والوسطية وتجديد الفكر',
        description: 'بيان معالم التصور الإسلامي للكون والحياة والإنسان، ترسيخ الوسطية وتفكيك الغلو والتطرف، وضوابط التجديد الفقهي والفكري بين الثوابت والمتغيرات.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_thought_islamic_worldview_identity',
          'lsn_thought_moderation_combating_extremism',
          'lsn_thought_renewal_constants_variables',
        ],
      ),
      CourseModule(
        moduleId: 'mod_thought_shubuhat_response',
        courseId: courseId,
        title: 'الوحدة الثانية: المناعة الفكرية وبناء الوعي وتفنيد الشبهات المعاصرة',
        description: 'تأصيل قواعد التفكير النقدي في الإسلام، أدلة الإيمان والعقل في مواجهة النزعات المادية والإلحاد، والرد التأصيلي على الشبهات المثارة حول التشريع وحقوق الإنسان.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_thought_identity_wasatiyyah'],
        lessonIds: const [
          'lsn_thought_critical_thinking_fallacies',
          'lsn_thought_atheism_materialism_countering',
          'lsn_thought_contemporary_shubuhat_rebuttal',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: معالم التصور الإسلامي للكون والحياة والإنسان ومقومات الهوية
    // -------------------------------------------------------------------------
    final evIdentityQuran = EvidenceLink.create(
      evidenceId: 'ev_thought_identity_quran_baqarah',
      evidenceKey: '2:138',
      citation: 'سورة البقرة: الآية 138 {صِبْغَةَ اللَّهِ ۖ وَمَنْ أَحْسَنُ مِنَ اللَّهِ صِبْغَةً ۖ وَنَحْنُ لَهُ عَابِدُونَ}',
      sourceId: 'src_quran_canonical',
    );
    final evGhurabaHadith = EvidenceLink.create(
      evidenceId: 'ev_thought_ghuraba_hadith_muslim',
      evidenceKey: 'muslim:145',
      citation: 'صحيح مسلم: «بَدَأَ الإِسْلَامُ غَرِيبًا، وَسَيَعُودُ كَمَا بَدَأَ غَرِيبًا، فَطُوبَى لِلْغُرَبَاءِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_thought_islamic_worldview_identity',
      title: 'معالم التصور الإسلامي للكون والحياة والإنسان ومقومات الهوية الحضارية',
      courseId: courseId,
      moduleId: 'mod_thought_identity_wasatiyyah',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_th1_1',
          title: 'الرؤية الكلية للوجود',
          description: 'استيعاب شمولية النظرة الإسلامية للوجود القائمة على التوحيد والاستخلاف الإنساني وعمارة الأرض.',
        ),
        LearningObjective(
          objectiveId: 'obj_th1_2',
          title: 'مقومات الهوية الإسلامية',
          description: 'معرفة مقومات الهوية الإسلامية والاعتزاز بالانتماء للأمة وقيمها الراسخة.',
        ),
        LearningObjective(
          objectiveId: 'obj_th1_3',
          title: 'مواجهة التبعية والاستلاب الفكري',
          description: 'تحصين الذات من التبعية الفكرية والاستلاب الحضاري دون انكفاء ولا انعزال.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_th1_1',
          title: 'الرؤية الكلية للوجود في التصور الإسلامي',
          contentType: LearningContentType.sourceText,
          content: 'ينفرد التصور الإسلامي بنظرة شاملة متوازنة تربط الغيب بالشهادة؛ فالخالق سبحانه هو الواحد الأحد، والكون مسخر بأمره وفق سنن إلهية ثابتة تدعو للنظر والتفكر، والإنسان مخلوق مكرم مستخلف في الأرض ومكلف بأمانة العبودية وعمارة الأرض بالعدل والصلاح، والآخرة هي دار الجزاء والخلود.',
          evidenceLinks: [evIdentityQuran, evGhurabaHadith],
          sourceAttribution: 'خصائص التصور الإسلامي لسيد قطب',
        ),
        LessonSection.create(
          sectionId: 'sec_th1_2',
          title: 'مقومات الهوية الإسلامية ومصادر قوتها',
          contentType: LearningContentType.explanation,
          content: 'تقوم الهوية الإسلامية على: العقيدة التوحيدية الصافية، والارتباط بالوحيين المعصومين (الكتاب والسنة)، واللغة العربية لغة التنزيل، والذاكرة التاريخية المشتركة للأمة. والاعتزاز بهذه الهوية لا يعني الانغلاق، بل يمنح المسلم بوصلة واثقة تمكنه من الانفتاح الراشد على الحكمة النافعة أينما كانت.',
          sourceAttribution: 'الهوية الإسلامية في مواجهة العولمة',
        ),
        LessonSection.create(
          sectionId: 'sec_th1_3',
          title: 'مواجهة الاستلاب الفكري والتبعية الثقافية',
          contentType: LearningContentType.explanation,
          content: 'أخطر ما يهدد الأمة في عصر العولمة هو فقدان الثقة بنموذجها الحضاري واستيراد المفاهيم الغريبة وتطبيقها دون تمحيص. والمطلوب هو التمييز بين التقدم التقني والعلمي المشترك بين البشر، وبين المنظومات الأخلاقية والفلسفية التي تصادم ثوابت الوحي والكرامة الإنسانية.',
          sourceAttribution: 'أزمة العقل المسلم لعماد الدين خليل',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: منهج الوسطية والاعتدال وتفكيك الغلو والتطرف
    // -------------------------------------------------------------------------
    final evWasatiyyahQuran = EvidenceLink.create(
      evidenceId: 'ev_thought_wasat_quran_baqarah',
      evidenceKey: '2:143',
      citation: 'سورة البقرة: الآية 143 {وَكَذَٰلِكَ جَعَلْنَاكُمْ أُمَّةً وَسَطًا لِّتَكُونُوا شُهَدَاءَ عَلَى النَّاسِ}',
      sourceId: 'src_quran_canonical',
    );
    final evGhuluwHadith = EvidenceLink.create(
      evidenceId: 'ev_thought_ghuluw_hadith_nasai',
      evidenceKey: 'nasai:3057',
      citation: 'سنن النسائي: «إِيَّاكُمْ وَالغُلُوَّ فِي الدِّينِ، فَإِنَّمَا أَهْلَكَ مَنْ كَانَ قَبْلَكُمُ الغُلُوُّ فِي الدِّينِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_thought_moderation_combating_extremism',
      title: 'منهج الوسطية والاعتدال: تفكيك الغلو والتطرف ومخاطر التكفير والتفريط',
      courseId: courseId,
      moduleId: 'mod_thought_identity_wasatiyyah',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_th2_1',
          title: 'حقيقة الوسطية الإسلامية',
          description: 'إدراك حقيقة الوسطية الإسلامية وأنها العدل والخيرية بين الإفراط والتفريط.',
        ),
        LearningObjective(
          objectiveId: 'obj_th2_2',
          title: 'تفكيك جذور الغلو والتطرف',
          description: 'تفكيك جذور الغلو والتطرف وأسباب الانحراف الفكري في فهم النصوص.',
        ),
        LearningObjective(
          objectiveId: 'obj_th2_3',
          title: 'ضوابط التكفير وتحذيرات الشرع',
          description: 'معرفة ضوابط التكفير الخطيرة وتحذير النبي ﷺ من استباحة دماء المسلمين وأعراضهم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_th2_1',
          title: 'الوسطية: جوهر الإسلام وميزان الاعتدال',
          contentType: LearningContentType.sourceText,
          content: 'الوسطية في الإسلام ليست تلفيقاً بين المتناقضات ولا تمييعاً للثوابت، بل هي العدل، والخيرية، والتوازن بين الروح والجسد، والدنيا والآخرة، والعقل والنقل، والفرد والمجتمع. وقد جعل الله أمة الإسلام أمة وسطاً لتشهد على سائر الأمم بفضل هذا الاتزان الرباني.',
          evidenceLinks: [evWasatiyyahQuran, evGhuluwHadith],
          sourceAttribution: 'الوسطية في القرآن الكريم للصلابي',
        ),
        LessonSection.create(
          sectionId: 'sec_th2_2',
          title: 'جذور الغلو والتطرف وسبل تفكيكها',
          contentType: LearningContentType.explanation,
          content: 'الغلو هو مجاوزة الحد المشروع اعتقاداً أو عملاً؛ وينشأ من الجهل بمقاصد الشريعة، واقتطاع النصوص من سياقاتها، وأخذ الفتوى عن غير المؤهلين، والاندفاع العاطفي غير المنضبط بالحكمة. وقد حذر النبي ﷺ منه بشدة مكرراً: «هلك المتنطعون» أي المتعمقون المغالون.',
          sourceAttribution: 'ظاهرة الغلو في التكفير',
        ),
        LessonSection.create(
          sectionId: 'sec_th2_3',
          title: 'خطورة فتنة التكفير وضوابط أهل السنة والجماعة',
          contentType: LearningContentType.explanation,
          content: 'التكفير حكم شرعي محض لا يملكه إلا الله ورسوله، ولا يجوز إطلاقه إلا على من ثبت كفره بدليل قطعي لا شبهة فيه. وقاعدة أهل السنة: «لا نكفر أحداً من أهل القبلة بذنب ما لم يستحله»، مع التفريق الحاسم بين كفر النوع (القول أو الفعل الكفري) وكفر العين لوجوب توفر الشروط وانتفاء الموانع.',
          sourceAttribution: 'مجموع الفتاوى لابن تيمية',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: التجديد المنضبط في الفكر الإسلامي بين الثوابت والمتغيرات
    // -------------------------------------------------------------------------
    final evRenewalHadith = EvidenceLink.create(
      evidenceId: 'ev_thought_renewal_hadith_abudawood',
      evidenceKey: 'abudawood:4291',
      citation: 'سنن أبي داود: «إِنَّ اللَّهَ يَبْعَثُ لِهَذِهِ الأُمَّةِ عَلَى رَأْسِ كُلِّ مِائَةِ سَنَةٍ مَنْ يُجَدِّدُ لَهَا دِينَهَا»',
      sourceId: 'src_hadith_canonical',
    );
    final evSunnahHadith = EvidenceLink.create(
      evidenceId: 'ev_thought_sunnah_hadith_irbad',
      evidenceKey: 'tirmidhi:2676',
      citation: 'سنن الترمذي: «فَعَلَيْكُمْ بِسُنَّتِي وَسُنَّةِ الخُلَفَاءِ الرَّاشِدِينَ المَهْدِيِّينَ، عَضُّوا عَلَيْهَا بِالنَّوَاجِذِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_thought_renewal_constants_variables',
      title: 'التجديد المنضبط في الفكر الإسلامي: التفريق بين الثوابت والمتغيرات',
      courseId: courseId,
      moduleId: 'mod_thought_identity_wasatiyyah',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_th3_1',
          title: 'المعنى الصحيح للتجديد الشرعي',
          description: 'استيعاب المعنى الصحيح للتجديد: إحياء ما اندرس من معالم الدين لا تبديل أصوله.',
        ),
        LearningObjective(
          objectiveId: 'obj_th3_2',
          title: 'التمييز بين الثوابت والمتغيرات',
          description: 'التمييز الدقيق بين الثوابت القطعية غير القابلة للتغيير والمتغيرات الاجتهادية الخاضعة لتغير الزمان والمكان.',
        ),
        LearningObjective(
          objectiveId: 'obj_th3_3',
          title: 'فقه الواقع والاجتهاد الجماعي',
          description: 'فهم فقه الواقع واستشراف المستقبل والاجتهاد الجماعي لمواجهة النوازل المستجدة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_th3_1',
          title: 'حقيقة التجديد الشرعي ومفهومه النبوي',
          contentType: LearningContentType.sourceText,
          content: 'التجديد سنة نبوية مؤكدة؛ ومقصوده إزالة ما علق بأفهام الناس من بدع وأوهام وخرافات، وإعادة الناس إلى نبع الإسلام الصافي في الكتاب والسنة، وتنزيل الأحكام على الواقع المعاش بأدوات الاجتهاد الرصين، وليس نسف الشريعة ومسايرة الأهواء المعاصرة تحت ستار التحديث.',
          evidenceLinks: [evRenewalHadith, evSunnahHadith],
          sourceAttribution: 'معالم التجديد في الفكر الإسلامي',
        ),
        LessonSection.create(
          sectionId: 'sec_th3_2',
          title: 'دائرة الثوابت ودائرة المتغيرات في الشريعة',
          contentType: LearningContentType.explanation,
          content: 'تنقسم الشريعة إلى: 1- الثوابت: وهي أصول العقائد، وأركان الإسلام، والفرائض القطعية، والمحرمات المجمع عليها، ومقاصد الشريعة الكبرى، وأصول الأخلاق؛ وهذه محكمة أبدية لا تبديل لها. 2- المتغيرات: وهي الفروع الفقهية المبنية على العرف والمصالح المرسلة وأدلة الظن، وتطبيقات السياسة الشرعية والمعاملات؛ وهذه تتسع للتطوير والتجديد بحسب تغير الزمان والمكان والحال.',
          sourceAttribution: 'الثوابت والمتغيرات في مسيرة العمل الإسلامي',
        ),
        LessonSection.create(
          sectionId: 'sec_th3_3',
          title: 'أهمية الاجتهاد الجماعي والمجامع الفقهية المعاصرة',
          contentType: LearningContentType.explanation,
          content: 'مع تعقد الحياة وتشابك الأنظمة الاقتصادية والطبية والتقنية، لم يعد الاجتهاد الفردي كافياً للنوازل الكبرى؛ وظهرت المجامع الفقهية وهيئات كبار العلماء التي تجمع بين الفقهاء والخبراء التقنيين والطبيين والاقتصاديين لإصدار قرارات اجتهادية جماعية تتسم بالنضج والدقة.',
          sourceAttribution: 'الاجتهاد الجماعي وتطبيقاته المعاصرة',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: التفكير النقدي في الرؤية الإسلامية وتفكيك المغالطات
    // -------------------------------------------------------------------------
    final evReasonQuran = EvidenceLink.create(
      evidenceId: 'ev_thought_reason_quran_isra',
      evidenceKey: '17:36',
      citation: 'سورة الإسراء: الآية 36 {وَلَا تَقْفُ مَا لَيْسَ لَكَ بِهِ عِلْمٌ ۚ إِنَّ السَّمْعَ وَالْبَصَرَ وَالْفُؤَادَ كُلُّ أُولَٰئِكَ كَانَ عَنْهُ مَسْئُولًا}',
      sourceId: 'src_quran_canonical',
    );
    final evBurhanQuran = EvidenceLink.create(
      evidenceId: 'ev_thought_burhan_quran_baqarah',
      evidenceKey: '2:111',
      citation: 'سورة البقرة: الآية 111 {قُلْ هَاتُوا بُرْهَانَكُمْ إِن كُنتُمْ صَادِقِينَ}',
      sourceId: 'src_quran_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_thought_critical_thinking_fallacies',
      title: 'التفكير النقدي في الرؤية الإسلامية: قواعد الاستدلال وتفكيك المغالطات الفكرية',
      courseId: courseId,
      moduleId: 'mod_thought_shubuhat_response',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_th4_1',
          title: 'المنهج البرهاني القرآني',
          description: 'إدراك دعوة القرآن للتفكير البرهاني والتدبر ونبذ التقليد الأعمى واتباع الظن والهوى.',
        ),
        LearningObjective(
          objectiveId: 'obj_th4_2',
          title: 'تفكيك المغالطات المنطقية',
          description: 'التعرف على أشهر المغالطات المنطقية المعاصرة كـ (الاحتكام للجهل، رجل القش، والمصادرة على المطلوب).',
        ),
        LearningObjective(
          objectiveId: 'obj_th4_3',
          title: 'معايير التثبت المعرفي',
          description: 'امتلاك أدوات التفكير المنطقي السليم لفرز الأخبار والشائعات ونقد الأفكار بموضوعية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_th4_1',
          title: 'المنهج البرهاني القرآني ونبذ التقليد الأعمى',
          contentType: LearningContentType.sourceText,
          content: 'يمجد القرآن الكريم العقل ويأمر بالبرهان فيقول: ﴿قُلْ هَاتُوا بُرْهَانَكُمْ إِن كُنتُمْ صَادِقِينَ﴾، وينهى عن التخمين والخرص فقال ﴿إِن يَتَّبِعُونَ إِلَّا الظَّنَّ وَمَا تَهْوَى الْأَنفُسُ﴾. وشن القرآن حملة كبرى على التقليد المذموم للآباء والكبراء دون بينة، وجعل التفكير والتحري والمسؤولية الفردية فريضة شرعية.',
          evidenceLinks: [evReasonQuran, evBurhanQuran],
          sourceAttribution: 'مناهج الأدلة في عقائد الملة لابن رشد',
        ),
        LessonSection.create(
          sectionId: 'sec_th4_2',
          title: 'تفكيك المغالطات المنطقية في النقاشات المعاصرة',
          contentType: LearningContentType.explanation,
          content: 'كثيراً ما تبنى الشبهات على مغالطات منطقية: كمغالطة «رجل القش» بتشويه الفكرة الأصلية ومهاجمة الصورة المشوهة، أو مغالطة «شخصنة النقاش» بالطعن في القائل بدلاً من نقد قوله، أو «الاحتكام للأكثرية» بجعل الشائع دليلاً على الصواب، أو مغالطة «التعميم المتسرع» بإسقاط تصرف فردي على الشريعة كلها.',
          sourceAttribution: 'المغالطات المنطقية للدكتور عادل مصطفى',
        ),
        LessonSection.create(
          sectionId: 'sec_th4_3',
          title: 'معايير التثبت المعرفي والتحصين من الشائعات',
          contentType: LearningContentType.explanation,
          content: 'أرسى الإسلام قاعدة التثبت والتحقق: ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا إِن جَاءَكُمْ فَاسِقٌ بِنَبَإٍ فَتَبَيَّنُوا﴾، والتحذير من نقل كل ما يُسمع «كفى بالمرء كذباً أن يحدث بكل ما سمع». والتحصين الفكري يبدأ بفحص المصادر، وعدم الاستسلام للإثارة الإعلامية، وإرجاع المسائل الشائكة إلى المتخصصين الراسخين.',
          sourceAttribution: 'قواعد التثبت عند المحدثين والفقهاء',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: براهين الإيمان ومواجهة الإلحاد والنزعات المادية
    // -------------------------------------------------------------------------
    final evCreationQuran = EvidenceLink.create(
      evidenceId: 'ev_thought_creation_quran_tur',
      evidenceKey: '52:35-36',
      citation: 'سورة الطور: الآيتان 35-36 {أَمْ خُلِقُوا مِنْ غَيْرِ شَيْءٍ أَمْ هُمُ الْخَالِقُونَ ۝ أَمْ خَلَقُوا السَّمَاوَاتِ وَالْأَرْضَ ۚ بَل لَّا يُوقِنُونَ}',
      sourceId: 'src_quran_canonical',
    );
    final evFitrahHadith = EvidenceLink.create(
      evidenceId: 'ev_thought_fitrah_hadith_bukhari',
      evidenceKey: 'bukhari:1385',
      citation: 'صحيح البخاري: «مَا مِنْ مَوْلُودٍ إِلَّا يُولَدُ عَلَى الفِطْرَةِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_thought_atheism_materialism_countering',
      title: 'براهين الإيمان ومواجهة الإلحاد والنزعات المادية العبثية',
      courseId: courseId,
      moduleId: 'mod_thought_shubuhat_response',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_th5_1',
          title: 'الأدلة العقلية لإثبات وجود الخالق',
          description: 'استيعاب الأدلة العقلية الكبرى لإثبات وجود الخالق: دليل الخلق والحدوث، دليل الإتقان والضبط الدقيق، ودليل الفطرة.',
        ),
        LearningObjective(
          objectiveId: 'obj_th5_2',
          title: 'تفنيد مزاعم الصدفة العمياء',
          description: 'تفنيد مزاعم الصدفة العمياء والنشوء الذاتي والعبثية الوجودية من منظور عقلي وعلمي.',
        ),
        LearningObjective(
          objectiveId: 'obj_th5_3',
          title: 'انسجام العلم والإيمان',
          description: 'بيان التكامل بين العلم التجريبي الصحيح والإيمان وعدم وجود أي تصادم بين الوحي والعلم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_th5_1',
          title: 'الأدلة العقلية القطعية على وجود الخالق سبحانه',
          contentType: LearningContentType.sourceText,
          content: 'يقدم القرآن براهين عقلية حاسمة لا تدحض: 1- برهان السببية والحدوث: ﴿أَمْ خُلِقُوا مِنْ غَيْرِ شَيْءٍ أَمْ هُمُ الْخَالِقُونَ﴾؛ فالعدم المحض لا ينشئ شيئاً، والكون الحادث لابد له من موجد واجب الوجود. 2- برهان الإتقان والعناية (الضبط الدقيق): تناسق قوانين الكون والفيزياء بدقة متناهية لا تحتمل أدنى خلل يدل قطعاً على حكمة وقصد وقدرة عليم قدير. 3- برهان الفطرة: الميل الفطري الأصيل في كل نفس للاعتراف بالخالق واللجوء إليه عند الشدائد.',
          evidenceLinks: [evCreationQuran, evFitrahHadith],
          sourceAttribution: 'دلائل التوحيد وبراهين الإيمان',
        ),
        LessonSection.create(
          sectionId: 'sec_th5_2',
          title: 'تهافت أطروحات الصدفة والعدمية المادية',
          contentType: LearningContentType.explanation,
          content: 'دعوى أن الكون وجد بالصدفة العشوائية باطلة علمياً وعقلياً؛ فالصدفة لا تصنع نظاماً محكماً ولا قانوناً مستقراً. وإنكار الخالق يوقع الإنسان في العبثية والعدمية وفقدان المعنى والهدف الأخلاقي للوجود، وتحويل الإنسان لمجرد تفاعلات كيميائية بلا قيمة روحية ولا كرامة ذاتية.',
          sourceAttribution: 'تهافت الفلسفة المادية وبراهين النبوة',
        ),
        LessonSection.create(
          sectionId: 'sec_th5_3',
          title: 'انسجام العلم التجريبي مع الإيمان بالله',
          contentType: LearningContentType.explanation,
          content: 'الإسلام لا يخشى العلم بل يحث عليه، وكلما تعمق العلم التجريبي في اكتشاف أسرار الكون والخلية والحمض النووي والفيزياء الكونية، كلما ازداد البرهان على عظمة الصانع سبحانه. والتصادم المزعوم نشأ في التاريخ الغربي بين الكنيسة وعلماء الفلك، أما في الحضارة الإسلامية فكان كبار العلماء علماء شريعة وباحثين تجريبيين في آن واحد.',
          sourceAttribution: 'العلم يدعو للإيمان لكريسي موريسون',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: الرد التأصيلي على الشبهات المعاصرة
    // -------------------------------------------------------------------------
    final evJusticeQuran = EvidenceLink.create(
      evidenceId: 'ev_thought_justice_quran_nahl',
      evidenceKey: '16:90',
      citation: 'سورة النحل: الآية 90 {إِنَّ اللَّهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ وَإِيتَاءِ ذِي الْقُرْبَىٰ}',
      sourceId: 'src_quran_canonical',
    );
    final evHikmahQuran = EvidenceLink.create(
      evidenceId: 'ev_thought_hikmah_quran_tin',
      evidenceKey: '95:8',
      citation: 'سورة التين: الآية 8 {أَلَيْسَ اللَّهُ بِأَحْكَمِ الْحَاكِمِينَ}',
      sourceId: 'src_quran_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_thought_contemporary_shubuhat_rebuttal',
      title: 'الرد التأصيلي على الشبهات المثارة حول المرأة والعقوبات وحقوق الإنسان',
      courseId: courseId,
      moduleId: 'mod_thought_shubuhat_response',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_th6_1',
          title: 'شبهات المرأة وحقيقة الإنصاف',
          description: 'الرد المنهجي على شبهات تكريم ومكانة المرأة في الإسلام وأنوار العدل والكرامة التي نالتها.',
        ),
        LearningObjective(
          objectiveId: 'obj_th6_2',
          title: 'فلسفة العقوبات والقصاص',
          description: 'فهم حكمة الحدود والقصاص في الشريعة الإسلامية وأنها لحفظ أمن المجتمع وحياة البشرية ﴿وَلَكُمْ فِي الْقِصَاصِ حَيَاةٌ﴾.',
        ),
        LearningObjective(
          objectiveId: 'obj_th6_3',
          title: 'ريادة الإسلام في حقوق الإنسان',
          description: 'إظهار ريادة الإسلام في تقرير الحقوق الإنسانية الأصيلة قبل المواثيق الدولية بقرون.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_th6_1',
          title: 'شبهات المرأة في الإسلام وحقيقة الإنصاف القرآني',
          contentType: LearningContentType.sourceText,
          content: 'أنقذ الإسلام المرأة من وأد الجاهلية وضياع الميراث وجعلها شقيقة الرجل في التكليف والكرامة والأجر الأخروي. وأما تمايز بعض الأدوار والأنصبة كالميراث والشهادة والقوامة فمبني على التوازن الشامل للحقوق والواجبات؛ فالرجل ملزم شرعاً بالنفقة والمهر وتكاليف الأسرة، بينما مال المرأة خالص لها لا تلزم بالإنفاق منه، وفي أكثر من ثلاثين حالة ترث المرأة مثل الرجل أو أكثر منه أو ترث دونه.',
          evidenceLinks: [evJusticeQuran, evHikmahQuran],
          sourceAttribution: 'شبهات حول الإسلام لمحمد قطب',
        ),
        LessonSection.create(
          sectionId: 'sec_th6_2',
          title: 'فلسفة العقوبات الجنائية والقصاص في الشريعة',
          contentType: LearningContentType.explanation,
          content: 'العقوبات في الإسلام شُرعت لحماية الكليات الخمس وصيانة أمن الأمة. والقصاص هو العدل الذي يحقن الدماء لقوله تعالى ﴿وَلَكُمْ فِي الْقِصَاصِ حَيَاةٌ يَا أُولِي الْأَلْبَابِ﴾. والحدود موضوعة بدرجة شديدة من التعقيد في الإثبات وتدرأ بالشبهات لقوله ﷺ «ادرؤوا الحدود بالشبهات»، فالغاية منها الردع العام وصيانة السلم وليس التشفي والتعذيب.',
          sourceAttribution: 'التشريع الجنائي الإسلامي لعبد القادر عودة',
        ),
        LessonSection.create(
          sectionId: 'sec_th6_3',
          title: 'ريادة الإسلام في حقوق الإنسان والحرية والكرامة',
          contentType: LearningContentType.explanation,
          content: 'قرر الإسلام حقوق الإنسان كمنحة إلهية واجبة الاحترام وليست منة من حاكم: حق الحياة، حق الكرامة، حق التدين ونفي الإكراه ﴿لَا إِكْرَاهَ فِي الدِّينِ﴾، حق التملك، والمساواة الإنسانية المطلقة التي أعلنها النبي ﷺ في حجة الوداع: «لا فضل لعربي على أعجمي ولا لأعجمي على عربي ولا لأحمر على أسود ولا لأسود على أحمر إلا بالتقوى».',
          sourceAttribution: 'حقوق الإنسان في الإسلام للدكتور وهبة الزحيلي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: الهوية والوسطية والتجديد
    final q1 = QuizQuestion.create(
      questionId: 'q_th_1',
      lessonId: 'lsn_thought_moderation_combating_extremism',
      questionText: 'ما هو المفهوم الشرعي الصحيح لـ "الوسطية" التي وصف الله بها أمة الإسلام في سورة البقرة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qt1_1', text: 'العدل والخيرية والتوازن الشامل بين الإفراط (الغلو) والتفريط (التمييع والتهاون)'),
        QuizOption(optionId: 'opt_qt1_2', text: 'التنازل عن ثوابت العقيدة لإرضاء الآخرين ومسايرة الأهواء'),
        QuizOption(optionId: 'opt_qt1_3', text: 'الوقوف في المنتصف الحسابي بين الحق الصريح والباطل الصريح'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الوسطية هي العدالة والخيرية والتوازن القائم على التمسك بالحق دون غلو متنطع ودون تفريط مفرط.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_thought_identity_wasatiyyah',
      lessonId: 'lsn_thought_moderation_combating_extremism',
      title: 'اختبار الهوية والوسطية والتجديد المنضبط',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: التفكير النقدي وتفنيد الشبهات
    final q2 = QuizQuestion.create(
      questionId: 'q_th_2',
      lessonId: 'lsn_thought_atheism_materialism_countering',
      questionText: 'ما هو "برهان الإتقان والضبط الدقيق (Fine-Tuning)" في الاستدلال العقلي على وجود الخالق؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qt2_1', text: 'توافق قوانين وثوابت الكون الفيزيائية بدقة متناهية تجعل الحياة ممكنة، مما يستحيل معه الصدفة العشوائية ويثبت قصد الخالق الحكيم'),
        QuizOption(optionId: 'opt_qt2_2', text: 'اعتقاد أن كل الأشياء ظهرت من تلقاء نفسها بلا أي نظام أو قصد'),
        QuizOption(optionId: 'opt_qt2_3', text: 'الاعتماد على الحظ والتجربة العشوائية في تفسير نشأة الكون'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الضبط الدقيق للقوانين الكونية (كالجاذبية والكتل الذرية وتمدد الكون) برهان فيزيائي وعقلي قاطع على وجود حكمة وقصد وعلم صانع قدير سبحانه.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_thought_shubuhat_response',
      lessonId: 'lsn_thought_atheism_materialism_countering',
      title: 'اختبار التفكير النقدي وبراهين الإيمان وتفنيد الشبهات',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
