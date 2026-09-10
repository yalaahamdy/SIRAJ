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

/// بيانات مقرر الشرح التأصيلي للأربعين النووية (الجزء الأول: الأحاديث 1 إلى 21) (8 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningHadithNawawiPart1Data {
  static const String courseId = 'course_hadith_nawawi_part1';
  static const String pathId = 'path_hadith_sciences_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الشرح التأصيلي والتربوي للأربعين النووية (الجزء الأول: الأحاديث 1 إلى 21)',
      description: 'شرح تحليلي تأصيلي فقهي وتربوي للأحاديث من 1 إلى 21 من متن الأربعين النووية للإمام النووي: أصول النيات، أركان الدين ومراتب الإيمان والإحسان، رد البدع، الورع، حسن الخلق، وصية ابن عباس، والاستقامة.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_nawawi_core_principles', 'mod_nawawi_ethics_piety'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_nawawi_core_principles',
        courseId: courseId,
        title: 'الوحدة الأولى: كليات الإسلام وأصول الإيمان والتشريع (الأحاديث 1 إلى 10)',
        description: 'شرح تأصيلي لأحاديث النيات، حديث جبريل العظيم، دعائم الإسلام، أطوار الجنين والقدر، حماية الشريعة من البدع، الشبهات والقلب، النصيحة، وطيب الكسب.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_nawawi_h1_h2',
          'lsn_nawawi_h3_h4',
          'lsn_nawawi_h5_h6',
          'lsn_nawawi_h7_h10',
        ],
      ),
      CourseModule(
        moduleId: 'mod_nawawi_ethics_piety',
        courseId: courseId,
        title: 'الوحدة الثانية: قواعد الورع ومحاسن الأخلاق وحرمات المسلم (الأحاديث 11 إلى 21)',
        description: 'شرح أحاديث الورع وترك الشبهات، سلامة النفس، الإيثار، حرمة الدماء والأموال، كظم الغيظ، الإحسان المطلق، تقوى الله، وصية الحفظ والتوكل، والحياء والاستقامة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_nawawi_core_principles'],
        lessonIds: const [
          'lsn_nawawi_h11_h13',
          'lsn_nawawi_h14_h15',
          'lsn_nawawi_h16_h18',
          'lsn_nawawi_h19_h21',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 16: حديث 1 (النيات) وحديث 2 (حديث جبريل)
    // -------------------------------------------------------------------------
    final evNiyyahHadith = EvidenceLink.create(
      evidenceId: 'ev_nawawi_h1',
      evidenceKey: 'bukhari:1',
      citation: 'صحيح البخاري: حديث 1 (عمر بن الخطاب)',
      sourceId: 'src_hadith_canonical',
    );
    final evJibreelHadith = EvidenceLink.create(
      evidenceId: 'ev_nawawi_h2',
      evidenceKey: 'muslim:8',
      citation: 'صحيح مسلم: حديث 8 (عمر بن الخطاب)',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_nawawi_h1_h2',
      title: 'حديث النيات وقاعدة الإخلاص وحديث جبريل في مراتب الدين',
      courseId: courseId,
      moduleId: 'mod_nawawi_core_principles',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw1_1',
          title: 'قاعدة النيات والإخلاص',
          description: 'استيعاب معنى «إنما الأعمال بالنيات» ومنزلتها في قبول العبادات وتمييزها.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw1_2',
          title: 'مراتب الدين الثلاث',
          description: 'إتقان مراتب الدين الثلاث: الإسلام، الإيمان، والإحسان من حديث جبريل.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw1_3',
          title: 'أشراط الساعة الصغرى',
          description: 'معرفة علامات وأشراط الساعة الصغرى المذكورة في الحديث الشريف.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw1_1',
          title: 'الحديث الأول: إنما الأعمال بالنيات ومحور الدين',
          contentType: LearningContentType.sourceText,
          content: 'عن أمير المؤمنين أبي حفص عمر بن الخطاب رضي الله عنه قال: سمعت رسول الله ﷺ يقول: «إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ فَهِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ، وَمَنْ كَانَتْ هِجْرَتُهُ لِدُنْيَا يُصِيبُهَا أَوِ امْرَأَةٍ يَنْكِحُهَا فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ» (متفق عليه).',
          evidenceLinks: [evNiyyahHadith],
          sourceAttribution: 'صحيح البخاري ومسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw1_2',
          title: 'الفقه والبيان التحليلي لحديث النيات',
          contentType: LearningContentType.explanation,
          content: 'النية لها وظيفتان جليلتان:\n1. تمييز العبادات عن العادات (كالغسل للتبرد مقابل الغسل لرفع الجنابة).\n2. تمييز رتب العبادات بعضها عن بعض (كالصلاة نفلاً أو فرضاً).\nوالحديث أصل عظيم؛ قال الشافعي وأحمد: «يدخل حديث النيات في سبعين باباً من الفقه، وهو ثلث العلم».',
          sourceAttribution: 'جامع العلوم والحكم لابن رجب',
        ),
        LessonSection.create(
          sectionId: 'sec_nw1_3',
          title: 'الحديث الثاني: حديث جبريل عليه السلام وأم السنة',
          contentType: LearningContentType.sourceText,
          content: 'عن عمر رضي الله عنه: بينما نحن عند رسول الله ﷺ ذات يوم إذ طلع علينا رجل شديد بياض الثياب شديد سواد الشعر... وفيه سؤال جبريل عن الإسلام والإيمان والإحسان والساعة وأماراتها، وقول النبي ﷺ: «هذا جبريل أتاكم يعلمكم دينكم» (رواه مسلم).',
          evidenceLinks: [evJibreelHadith],
          sourceAttribution: 'صحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw1_4',
          title: 'مراتب الدين وأشراط الساعة',
          contentType: LearningContentType.scholarlyView,
          content: 'بين الحديث مراتب الدين الثلاث:\n1. الإسلام: الأعمال الظاهرة من الشهادتين والصلاة والزكاة والصوم والحج.\n2. الإيمان: أعمال القلوب واليقين بالأركان الستة الغيبية.\n3. الإحسان: أعلى المقامات؛ «أن تعبد الله كأنك تراه فإن لم تكن تراه فإنه يراك».\nوأمارتا الساعة: ولادة الأمة ربتها، وتطاول الحفاة العراة رعاء الشاء في البنيان.',
          sourceAttribution: 'شرح الأربعين النووية لابن دقيق العيد',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 17: حديث 3 (دعائم الإسلام) وحديث 4 (خلق الجنين والقدر)
    // -------------------------------------------------------------------------
    final l2 = Lesson.create(
      lessonId: 'lsn_nawawi_h3_h4',
      title: 'أركان الإسلام الخمسة ومراحل خلق الجنين والقدر والخواتيم',
      courseId: courseId,
      moduleId: 'mod_nawawi_core_principles',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw2_1',
          title: 'أركان الإسلام الخمسة',
          description: 'بيان تشبيه الإسلام بالبنيان القائم على أركانه وقواعده الخمسة.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw2_2',
          title: 'أطوار خلق الجنين ونفخ الروح',
          description: 'تتبع أطوار تخلق الجنين في بطن أمه ونفخ الروح بعد 120 يوماً.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw2_3',
          title: 'كتابة المقادير والاعتبار بالخواتيم',
          description: 'فهم كتابة المقادير الأربعة وأثر الأعمال بالخواتيم والوجل من سوء الخاتمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw2_1',
          title: 'الحديث الثالث: بني الإسلام على خمس',
          contentType: LearningContentType.sourceText,
          content: 'عن ابن عمر رضي الله عنهما قال: قال رسول الله ﷺ: «بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَحَجِّ البَيْتِ، وَصَوْمِ رَمَضَانَ» (رواه البخاري ومسلم).',
          sourceAttribution: 'صحيح البخاري وصحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw2_2',
          title: 'الحديث الرابع: أطوار خلق الإنسان والقدر الأزلي',
          contentType: LearningContentType.sourceText,
          content: 'عن عبد الله بن مسعود رضي الله عنه قال: حدثنا رسول الله ﷺ وهو الصادق المصدوق: «إِنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْمًا، ثُمَّ يَكُونُ عَلَقَةً مِثْلَ ذَلِكَ، ثُمَّ يَكُونُ مُضْغَةً مِثْلَ ذَلِكَ، ثُمَّ يُرْسَلُ المَلَكُ فَيَنْفُخُ فِيهِ الرُّوحَ، وَيُؤْمَرُ بِأَرْبَعِ كَلِمَاتٍ: بِكَتْبِ رِزْقِهِ، وَأَجَلِهِ، وَعَمَلِهِ، وَشَقِيٌّ أَوْ سَعِيدٌ...» (رواه البخاري ومسلم).',
          sourceAttribution: 'صحيح البخاري ومسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw2_3',
          title: 'الهدايات العقدية والتربوية والاعتبار بالخواتيم',
          contentType: LearningContentType.scholarlyView,
          content: '1. نفخ الروح يكون بعد تمام 120 يوماً وتترتب عليه أحكام الجنين الشرعية والدية والغسل.\n2. الرزق والأجل مقدران لا يزيدان بالحرص ولا ينقصان بالبخل.\n3. قوله ﷺ: «فَيَسْبِقُ عَلَيْهِ الْكِتَابُ فَيَعْمَلُ بِعَمَلِ أَهْلِ النَّارِ فَيَدْخُلُهَا» يربي في المؤمن دوام الانكسار لله وسؤال الثبات وخوف الرياء الدخيل الذي يفسد الخاتمة.',
          sourceAttribution: 'فتح الباري وشرح النووي على مسلم',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 18: حديث 5 (رد البدع) وحديث 6 (الحلال والحرام ومضغة القلب)
    // -------------------------------------------------------------------------
    final l3 = Lesson.create(
      lessonId: 'lsn_nawawi_h5_h6',
      title: 'حماية الشريعة من البدع وقواعد الحلال والحرام والورع وصلاح القلب',
      courseId: courseId,
      moduleId: 'mod_nawawi_core_principles',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw3_1',
          title: 'ميزان الأعمال الظاهرة ورد البدع',
          description: 'استيعاب ميزان الأعمال الظاهرة في رد البدع والمحدثات.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw3_2',
          title: 'الحلال والحرام والمشتبهات',
          description: 'التمييز بين الحلال البين والحرام البين والمشتبهات المتقاة.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw3_3',
          title: 'مركزية صلاح القلب',
          description: 'إدراك مركزية القلب وأثره الحاسم على استقامة الجوارح كلها.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw3_1',
          title: 'الحديث الخامس: رد المحدثات في الدين',
          contentType: LearningContentType.sourceText,
          content: 'عن أم المؤمنين أم عبد الله عائشة رضي الله عنها قالت: قال رسول الله ﷺ: «مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ مِنْهُ فَهُوَ رَدٌّ» (رواه البخاري ومسلم)، وفي رواية لمسلم: «مَنْ عَمِلَ عَمَلًا لَيْسَ عَلَيْهِ أَمْرُنَا فَهُوَ رَدٌّ».',
          sourceAttribution: 'صحيح البخاري وصحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw3_2',
          title: 'الحديث السادس: الحلال بين والحرام بين ومضغة القلب',
          contentType: LearningContentType.sourceText,
          content: 'عن النعمان بن بشير رضي الله عنهما قال: سمعت رسول الله ﷺ يقول: «إِنَّ الحَلاَلَ بَيِّنٌ، وَإِنَّ الحَرَامَ بَيِّنٌ، وَبَيْنَهُمَا أُمُورٌ مُشْتَبِهَاتٌ لاَ يَعْلَمُهُنَّ كَثِيرٌ مِنَ النَّاسِ، فَمَنِ اتَّقَى الشُّبُهَاتِ اسْتَبْرَأَ لِدِينِهِ وَعِرْضِهِ، وَمَنْ وَقَعَ فِي الشُّبُهَاتِ وَقَعَ فِي الحَرَامِ... أَلاَ وَإِنَّ فِي الجَسَدِ مُضْغَةً إِذَا صَلَحَتْ صَلَحَ الجَسَدُ كُلُّهُ، وَإِذَا فَسَدَتْ فَسَدَ الجَسَدُ كُلُّهُ، أَلاَ وَهِيَ القَلْبُ» (متفق عليه).',
          sourceAttribution: 'صحيح البخاري وصحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw3_3',
          title: 'تكامل ميزان الظاهر والباطن',
          contentType: LearningContentType.scholarlyView,
          content: 'قال العلماء: حديث النيات ميزان الأعمال الباطنة، وحديث عائشة ميزان الأعمال الظاهرة؛ فلا يقبل عمل حتى يكون خالصاً لله وعلى سنة رسول الله ﷺ. وحديث النعمان يرسي حماية حمى الشريعة بالابتعاد عن المشتبهات، وأن صلاح الجوارح فرع عن طهارة القلب.',
          sourceAttribution: 'الاعتصام للشاطبي وجامع العلوم والحكم',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 19: الأحاديث 7 و 8 و 9 و 10
    // -------------------------------------------------------------------------
    final l4 = Lesson.create(
      lessonId: 'lsn_nawawi_h7_h10',
      title: 'النصيحة وحرمة المسلم ويسر الشريعة وطيب الكسب وإجابة الدعاء',
      courseId: courseId,
      moduleId: 'mod_nawawi_core_principles',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw4_1',
          title: 'وجوه النصيحة الخمسة',
          description: 'معرفة وجوه النصيحة الخمسة لله ولكتابه ولرسوله ولأئمة المسلمين وعامتهم.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw4_2',
          title: 'حرمة الدماء واليسر بالاستطاعة',
          description: 'فهم حرمة الدماء والأموال وضوابط الأمر والنهي النبوي بالاستطاعة.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw4_3',
          title: 'أكل الحلال وشروط إجابة الدعاء',
          description: 'إدراك شروط إجابة الدعاء وأثر أكل الحلال في استجابة العبادة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw4_1',
          title: 'الأحاديث الشريفة 7 و 8 و 9 و 10',
          contentType: LearningContentType.sourceText,
          content: '• حديث 7: «الدِّينُ النَّصِيحَةُ» قلنا: لمن؟ قال: «لِلَّهِ، وَلِكِتَابِهِ، وَلِرَسُولِهِ، وَلِأَئِمَّةِ الْمُسْلِمِينَ، وَعَامَّتِهِمْ» (مسلم).\n• حديث 8: «أُمِرْتُ أَنْ أُقَاتِلَ النَّاسَ حَتَّى يَشْهَدُوا أَنْ لَا إِلَهَ إِلَّا اللَّهُ... فَإِذَا فَعَلُوا ذَلِكَ عَصَمُوا مِنِّي دِمَاءَهُمْ وَأَمْوَالَهُمْ».\n• حديث 9: «مَا نَهَيْتُكُمْ عَنْهُ فَاجْتَنِبُوهُ، وَمَا أَمَرْتُكُمْ بِهِ فَأْتُوا مِنْهُ مَا اسْتَطَعْتُمْ».\n• حديث 10: «إِنَّ اللَّهَ طَيِّبٌ لَا يَقْبَلُ إِلَّا طَيِّبًا... يَمُدُّ يَدَيْهِ إِلَى السَّمَاءِ يَا رَبِّ يَا رَبِّ، وَمَطْعَمُهُ حَرَامٌ، وَمَشْرَبُهُ حَرَامٌ، وَمَلْبَسُهُ حَرَامٌ... فَأَنَّى يُسْتَجَابُ لِذَلِكَ؟» (مسلم).',
          sourceAttribution: 'صحيح مسلم وصحيح البخاري',
        ),
        LessonSection.create(
          sectionId: 'sec_nw4_2',
          title: 'الفقه الشامل والقواعد المقاصدية المستنبطة',
          contentType: LearningContentType.explanation,
          content: '1. النصيحة إرادة الخير للمنصوح له؛ والنصيحة للعامة بإرشادهم لمصالحهم وستر عوراتهم.\n2. المنهي عنه يجب اجتنابه بالكلية فوراً لأنه كف مقدور، أما المأمور به فمقيد بالاستطاعة لقوله تعالى: {فَاتَّقُوا اللَّهَ مَا اسْتَطَعْتُمْ}.\n3. أكل الحلال شرط لقبول الدعاء وصلاح الأعمال، والمعاصي تمنع الإجابة ولو توفرت أسبابها كالسفر.',
          sourceAttribution: 'جامع العلوم والحكم وشرح مسلم للنووي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 20: الأحاديث 11 و 12 و 13
    // -------------------------------------------------------------------------
    final l5 = Lesson.create(
      lessonId: 'lsn_nawawi_h11_h13',
      title: 'قواعد الورع ومجانبة الفضول وكمال الإيمان بالأخوة والمحبة',
      courseId: courseId,
      moduleId: 'mod_nawawi_ethics_piety',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw5_1',
          title: 'قاعدة الورع النبوي',
          description: 'تطبيق قاعدة الورع النبوي: «دع ما يريبك إلى ما لا يريبك».',
        ),
        LearningObjective(
          objectiveId: 'obj_nw5_2',
          title: 'ترشيد الوقت والاهتمام',
          description: 'إدراك قاعدة ترشيد الوقت والجهد: ترك ما لا يعني العبد المسلم.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw5_3',
          title: 'محبة الخير للمؤمنين',
          description: 'فهم شرط كمال الإيمان في محبة الخير لأخيه المسلم وزوال الحسد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw5_1',
          title: 'الأحاديث الشريفة 11 و 12 و 13',
          contentType: LearningContentType.sourceText,
          content: '• حديث 11: عن الحسن بن علي: «دَعْ مَا يَرِيبُكَ إِلَى مَا لاَ يَرِيبُكَ، فَإِنَّ الصِّدْقَ طُمَأْنِينَةٌ، وَإِنَّ الكَذِبَ رِيبَةٌ» (الترمذي وقال حسن صحيح).\n• حديث 12: عن أبي هريرة: «مِنْ حُسْنِ إِسْلَامِ المَرْءِ تَرْكُهُ مَا لَا يَعْنِيهِ» (حديث حسن رواه الترمذي).\n• حديث 13: عن أنس بن مالك: «لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ» (متفق عليه).',
          sourceAttribution: 'جامع الترمذي وصحيح البخاري ومسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw5_2',
          title: 'البيان التربوي والسلوكي للورع وطهارة النفس',
          contentType: LearningContentType.explanation,
          content: 'هذه الأحاديث تؤسس ركائز سلامة النفس المسلمة:\n1. الورع الصادق: الخروج من الشك والريبة إلى اليقين الحلال.\n2. حفظ الجوارح والأوقات: الاشتغال بما ينفع في المعاش والمعاد، وترك التدخل في شؤون الآخرين وتتبع العورات.\n3. تجريد القلب من الأنانية والحسد: فيفرح لنعمة الله على أخيه كما يفرح بها لنفسه.',
          sourceAttribution: 'جامع العلوم والحكم وبهجة الناظرين',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 21: الأحاديث 14 و 15
    // -------------------------------------------------------------------------
    final l6 = Lesson.create(
      lessonId: 'lsn_nawawi_h14_h15',
      title: 'حرمة دم المسلم وحفظ اللسان وحقوق الجار والضيف',
      courseId: courseId,
      moduleId: 'mod_nawawi_ethics_piety',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw6_1',
          title: 'عصمة دم المسلم واستثناءاتها',
          description: 'معرفة الحالات الثلاث الاستثنائية التي يباح فيها دم المسلم بحكم القضاء الشرعي.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw6_2',
          title: 'أدب حفظ اللسان والصمت',
          description: 'استيعاب أدب اللسان: الصمت إلا عن خير وذكر.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw6_3',
          title: 'إكرام الجار والضيف',
          description: 'إدراك الرابطة بين الإيمان بالله واليوم الآخر وإكرام الجار والضيف.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw6_1',
          title: 'الأحاديث الشريفة 14 و 15',
          contentType: LearningContentType.sourceText,
          content: '• حديث 14: عن ابن مسعود: «لَا يَحِلُّ دَمُ امْرِئٍ مُسْلِمٍ يَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَنِّي رَسُولُ اللَّهِ إِلَّا بِإِحْدَى ثَلَاثٍ: الثَّيِّبُ الزَّانِي، وَالنَّفْسُ بِالنَّفْسِ، وَالتَّارِكُ لِدِينِهِ الْمُفَارِقُ لِلْجَمَاعَةِ» (متفق عليه).\n• حديث 15: عن أبي هريرة: «مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيُكْرِمْ جَارَهُ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيُكْرِمْ ضَيْفَهُ» (متفق عليه).',
          sourceAttribution: 'صحيح البخاري وصحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw6_2',
          title: 'الفقه والآداب الاجتماعية السامية',
          contentType: LearningContentType.explanation,
          content: '1. عصمة دم المسلم أصل قطعي لا يجوز استباحته، والحدود الثلاثة لا يقيمها إلا ولي الأمر والقضاء الشرعي منعاً للفتن.\n2. حفظ المنطق والكلام: إذا أراد المسلم أن يتكلم فليتفكر، فإن كان خيراً نطق به وإلا أمسك.\n3. كرم الضيافة وحسن الجوار علامة كمال الإيمان وصدق التقوى.',
          sourceAttribution: 'شرح الأربعين للنووي وطرح التثريب للعراقي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 22: الأحاديث 16 و 17 و 18
    // -------------------------------------------------------------------------
    final l7 = Lesson.create(
      lessonId: 'lsn_nawawi_h16_h18',
      title: 'النهي عن الغضب والإحسان الشامل وتقوى الله وحسن الخلق ومحو السيئات',
      courseId: courseId,
      moduleId: 'mod_nawawi_ethics_piety',
      orderIndex: 7,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw7_1',
          title: 'علاج الغضب النبوي',
          description: 'إدراك حكمة النهي النبوي عن الغضب ووسائل معالجته الشرعية.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw7_2',
          title: 'عموم كتابة الإحسان',
          description: 'تطبيق قاعدة الإحسان العامة في جميع المعاملات وحتى في الذبح والقتل.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw7_3',
          title: 'الوصية الجامعة للتقوى وحسن الخلق',
          description: 'الجمع بين حق الله بالتقوى وحق النفس بالتوبة ومحو السيئات وحق الخلق بالإحسان.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw7_1',
          title: 'الأحاديث الشريفة 16 و 17 و 18',
          contentType: LearningContentType.sourceText,
          content: '• حديث 16: عن أبي هريرة: أن رجلاً قال للنبي ﷺ: أوصني، قال: «لَا تَغْضَبْ» فردد مراراً، قال: «لَا تَغْضَبْ» (البخاري).\n• حديث 17: عن شداد بن أوس: «إِنَّ اللَّهَ كَتَبَ الإِحْسَانَ عَلَى كُلِّ شَيْءٍ، فَإِذَا قَتَلْتُمْ فَأَحْسِنُوا القِتْلَةَ، وَإِذَا ذَبَحْتُمْ فَأَحْسِنُوا الذِّبْحَةَ، وَلْيُحِدَّ أَحَدُكُمْ شَفْرَتَهُ، وَلْيُرِحْ ذَبِيحَتَهُ» (مسلم).\n• حديث 18: عن أبي ذر ومعاذ بن جبل: «اتَّقِ اللَّهِ حَيْثُمَا كُنْتَ، وَأَتْبِعِ السَّيِّئَةَ الحَسَنَةَ تَمْحُهَا، وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ» (رواه الترمذي وقال حديث حسن).',
          sourceAttribution: 'صحيح البخاري وصحيح مسلم وجامع الترمذي',
        ),
        LessonSection.create(
          sectionId: 'sec_nw7_2',
          title: 'التحليل المنهجي للوصايا النبوية الثلاث',
          contentType: LearningContentType.scholarlyView,
          content: '1. الغضب جمرة يلقيها الشيطان في القلب، والنهي عنه يقتضي اجتناب أسبابه وكظم الغيظ والوضوء.\n2. الإحسان شريعة شاملة حتى مع البهائم الذبيحة بإراحتها وسرعة ذبحها.\n3. وصية معاذ وأبي ذر ثلاثية: علاقة العبد بربه (التقوى في السر والعلن)، علاقته بنفسه (الاستغفار وإتباع السيئة بالحسنة)، وعلاقته بالناس (بذل المعروف وكف الأذى).',
          sourceAttribution: 'جامع العلوم والحكم وإحياء علوم الدين',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 23: الأحاديث 19 و 20 و 21
    // -------------------------------------------------------------------------
    final l8 = Lesson.create(
      lessonId: 'lsn_nawawi_h19_h21',
      title: 'وصية ابن عباس في التوكل والحفظ الإلهي وخلق الحياء والاستقامة',
      courseId: courseId,
      moduleId: 'mod_nawawi_ethics_piety',
      orderIndex: 8,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_nw8_1',
          title: 'وصية ابن عباس الجامعة',
          description: 'حفظ واستيعاب وصية النبي ﷺ الجامعة لابن عباس رضي الله عنهما.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw8_2',
          title: 'حفظ حدود الله وثمراته',
          description: 'معرفة مفهوم حفظ حدود الله وجزاء الحفظ الإلهي للعبد.',
        ),
        LearningObjective(
          objectiveId: 'obj_nw8_3',
          title: 'الحياء والاستقامة',
          description: 'بيان منزلة الحياء من الإيمان، والجامع بين التوحيد والاستقامة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_nw8_1',
          title: 'الحديث التاسع عشر: وصية النبي ﷺ لابن عباس',
          contentType: LearningContentType.sourceText,
          content: 'عن ابن عباس رضي الله عنهما قال: كنت خلف النبي ﷺ يوماً فقال: «يَا غُلَامُ، إِنِّي أُعَلِّمُكَ كَلِمَاتٍ: احْفَظِ اللَّهَ يَحْفَظْكَ، احْفَظِ اللَّهَ تَجِدْهُ تُجَاهَكَ، إِذَا سَأَلْتَ فَاسْأَلِ اللَّهَ، وَإِذَا اسْتَعَنْتَ فَاسْتَعِنْ بِاللَّهِ، وَاعْلَمْ أَنَّ الأُمَّةَ لَوِ اجْتَمَعَتْ عَلَى أَنْ يَنْفَعُوكَ بِشَيْءٍ لَمْ يَنْفَعُوكَ إِلَّا بِشَيْءٍ قَدْ كَتَبَهُ اللَّهُ لَكَ، وَلَوِ اجْتَمَعُوا عَلَى أَنْ يَضُرُّوكَ بِشَيْءٍ لَمْ يَضُرُّوكَ إِلَّا بِشَيْءٍ قَدْ كَتَبَهُ اللَّهُ عَلَيْكَ، رُفِعَتِ الأَقْلَامُ وَجَفَّتِ الصُّحُفُ» (رواه الترمذي وقال حديث حسن صحيح).',
          sourceAttribution: 'جامع الترمذي ومسند أحمد',
        ),
        LessonSection.create(
          sectionId: 'sec_nw8_2',
          title: 'الحديث العشرون والحادي والعشرون: الحياء والاستقامة',
          contentType: LearningContentType.sourceText,
          content: '• حديث 20: عن أبي مسعود الأنصاري: «إِنَّ مِمَّا أَدْرَكَ النَّاسُ مِنْ كَلَامِ النُّبُوَّةِ الأُولَى: إِذَا لَمْ تَسْتَحِ فَاصْنَعْ مَا شِئْتَ» (البخاري).\n• حديث 21: عن سفيان بن عبد الله الثقفي: قلت: يا رسول الله، قل لي في الإسلام قولاً لا أسأل عنه أحداً غيرك، قال: «قُلْ: آمَنْتُ بِاللَّهِ، ثُمَّ اسْتَقِمْ» (مسلم).',
          sourceAttribution: 'صحيح البخاري وصحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_nw8_3',
          title: 'خلاصة المقاصد التربوية الكبرى',
          contentType: LearningContentType.scholarlyView,
          content: '1. حفظ الله بحفظ أوامره واجتناب نواهيه، والجزاء حفظ الله لدين العبد وعقله.\n2. التوكل واليقين بأنه لا نفع ولا ضر إلا بإذن الله يحرر المؤمن من الخوف والذل للخلق.\n3. الحياء سياج الأخلاق، والاستقامة هي لزوم الصراط المستقيم عقيدة وعملاً بعد الإقرار بالتوحيد.',
          sourceAttribution: 'مدارج السالكين لابن القيم وشرح الأربعين للنووي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6, l7, l8];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: النيات وحديث جبريل
    final q1 = QuizQuestion.create(
      questionId: 'q_nawawi_h1_1',
      lessonId: 'lsn_nawawi_h1_h2',
      questionText: 'ما هو أعلى مراتب الدين التي بينها جبريل عليه السلام في حديثه العظيم؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qnh1_1', text: 'مقام الإحسان (أن تعبد الله كأنك تراه فإن لم تكن تراه فإنه يراك)'),
        QuizOption(optionId: 'opt_qnh1_2', text: 'الإسلام بالأعمال الظاهرة فقط'),
        QuizOption(optionId: 'opt_qnh1_3', text: 'كثرة الصوم والصلاة نفلاً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الإحسان هو أعلى مراتب الدين الثلاث، ويتحقق بمراقبة الله الدائمة واستحضار عظمته كأنه يراه.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_nawawi_core_foundations',
      lessonId: 'lsn_nawawi_h1_h2',
      title: 'اختبار كليات أصول الدين والإخلاص والحديث النبوي',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: البدع والشبهات
    final q2 = QuizQuestion.create(
      questionId: 'q_nawawi_h5_1',
      lessonId: 'lsn_nawawi_h5_h6',
      questionText: 'ما هي القاعدة النبوية المعتمدة في رد العبادات والطقوس المحدثة التي لم يشرعها الله ورسوله؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qnh5_1', text: '«من أحدث في أمرنا هذا ما ليس منه فهو رد»'),
        QuizOption(optionId: 'opt_qnh5_2', text: 'كل ما استحسنه العقل فهو مشروع ومقبول'),
        QuizOption(optionId: 'opt_qnh5_3', text: 'البدعة الحسنة تقبل في العقائد فقط'),
      ],
      correctOptionIndices: const [0],
      explanation: 'حديث عائشة رضي الله عنها يقرر أصلاً قطعياً: كل عمل وعبادة محدثة في الدين ليست على أمر النبي ﷺ فهي مردودة على صاحبها كائنة من كان.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_nawawi_halal_bidah',
      lessonId: 'lsn_nawawi_h5_h6',
      title: 'اختبار حماية الشريعة من البدع وضوابط الحلال والشبهات',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: وصية ابن عباس والأخلاق
    final q3 = QuizQuestion.create(
      questionId: 'q_nawawi_h19_1',
      lessonId: 'lsn_nawawi_h19_h21',
      questionText: 'ماذا يثمر حفظ العبد لأوامر الله ونواهيه كما جاء في وصية النبي ﷺ لابن عباس؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qnh19_1', text: 'حفظ الله تعالى للعبد وتوفيقه وتأييده: «احفظ الله يحفظك، احفظ الله تجده تجاهك»'),
        QuizOption(optionId: 'opt_qnh19_2', text: 'الغنى الدنيوي الفوري المطلق دون ابتلاء'),
        QuizOption(optionId: 'opt_qnh19_3', text: 'رفع التكاليف والعبادات عنه'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الجزاء من جنس العمل؛ من حفظ حدود الله وأوامره حفظه الله في دينه وبدنه ورزقه وتولاه برعايته.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_nawawi_morals_piety',
      lessonId: 'lsn_nawawi_h19_h21',
      title: 'اختبار وصايا الإيمان والتوكل ومحاسن الأخلاق والاستقامة',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
