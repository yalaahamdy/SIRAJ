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

/// بيانات مقرر أصول التوحيد والإيمان بالله تعالى (8 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningAqidahTawheedData {
  static const String courseId = 'course_aqidah_tawheed';
  static const String pathId = 'path_aqidah_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر أصول التوحيد والإيمان بالله تعالى',
      description: 'دراسة عقدية تأصيلية شاملة لأقسام التوحيد الثلاثة: الربوبية والألوهية والأسماء والصفات، وحقيقة لا إله إلا الله وشروطها، ونواقض الإسلام والتحذير من الشرك والبدع.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_aqidah_tawheed_pillars', 'mod_aqidah_shirk_nullifiers'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_aqidah_tawheed_pillars',
        courseId: courseId,
        title: 'الوحدة الأولى: حقيقة التوحيد وأقسامه وقواعد الأسماء والصفات',
        description: 'بيان معنى التوحيد، وتوحيد الربوبية ودلائل الفطرة، وتوحيد الألوهية وشروط كلمة الإخلاص، وقواعد إثبات الأسماء والصفات بلا تحريف ولا تعطيل.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_aqidah_tawheed_divisions',
          'lsn_aqidah_rububiyyah_fitrah',
          'lsn_aqidah_uluhiyyah_shurut',
          'lsn_aqidah_asma_wa_sifat',
        ],
      ),
      CourseModule(
        moduleId: 'mod_aqidah_shirk_nullifiers',
        courseId: courseId,
        title: 'الوحدة الثانية: مقتضيات التوحيد ونواقض الإسلام والتحذير من الشرك',
        description: 'بيان الشرك الأكبر والأصغر، وصور الرياء والتطير، ونواقض الإسلام العشرة، والضوابط الشرعية للرقى والتمائم.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_aqidah_tawheed_pillars'],
        lessonIds: const [
          'lsn_aqidah_shirk_major',
          'lsn_aqidah_shirk_minor',
          'lsn_aqidah_islam_nullifiers',
          'lsn_aqidah_ruqyah_amulets',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: معنى التوحيد وأقسامه الثلاثة
    // -------------------------------------------------------------------------
    final evTawheedAyah = EvidenceLink.create(
      evidenceId: 'ev_taw_maryam_65',
      evidenceKey: '19:65',
      citation: 'سورة مريم: الآية 65',
      sourceId: 'src_quran_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_aqidah_tawheed_divisions',
      title: 'معنى التوحيد وأقسامه الثلاثة والاستقراء القرآني',
      courseId: courseId,
      moduleId: 'mod_aqidah_tawheed_pillars',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at1_1',
          title: 'معرفة الحد الشرعي للتوحيد وأقسامه',
          description: 'أن يدرك المتعلم أقسام التوحيد الثلاثة: الربوبية والألوهية والأسماء والصفات وأدلتها القرآنية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at1_1',
          title: 'الآية الجامعة لأقسام التوحيد الثلاثة',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {رَبُّ السَّمَاوَاتِ وَالْأَرْضِ وَمَا بَيْنَهُمَا فَاعْبُدْهُ وَاصْطَبِرْ لِعِبَادَتِهِ ۚ هَلْ تَعْلَمُ لَهُ سَمِيًّا}.',
          evidenceLinks: [evTawheedAyah],
          sourceAttribution: 'سورة مريم: الآية 65',
        ),
        LessonSection.create(
          sectionId: 'sec_at1_2',
          title: 'بيان الاستقراء القرآني لأقسام التوحيد',
          contentType: LearningContentType.explanation,
          content: 'التوحيد في لغة العرب هو إفراد الشيء وجعله واحداً. وفي الاصطلاح الشرعي: إفراد الله سبحانه بما يختص به من الربوبية والألوهية والأسماء والصفات. وقد دل الاستقراء التام لنصوص الكتاب والسنة أن التوحيد ينقسم إلى ثلاثة أقسام متلازمة لا يصح إيمان عبد إلا باجتماعها جميعاً.',
          sourceAttribution: 'شرح العقيدة الواسطية لابن عثيمين ج 1 ص 45',
        ),
        LessonSection.create(
          sectionId: 'sec_at1_3',
          title: 'تطبيق منهجي: تلازم أقسام التوحيد الثلاثة',
          contentType: LearningContentType.example,
          content: 'توحيد الربوبية مستلزم لتوحيد الألوهية؛ فمن أقر بأن الله هو الخالق الرازق المدبر وجب عليه عقلاً وشرعاً ألا يصرف شيئاً من العبادة والدعاء لغيره، وتوحيد الألوهية متضمن لتوحيد الربوبية.',
          sourceAttribution: 'معارج القبول لحافظ الحكمي ج 1 ص 80',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_wasitiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: توحيد الربوبية ودلائل الفطرة
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_aqidah_rububiyyah_fitrah',
      title: 'توحيد الربوبية ودلائل الفطرة والكون وإبطال الإلحاد',
      courseId: courseId,
      moduleId: 'mod_aqidah_tawheed_pillars',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at2_1',
          title: 'فهم توحيد الربوبية ودلائل الفطرة والعقل',
          description: 'التعرف على إفراد الله بالخلق والملك والتدبير والرد المنهجي على منكري الخالق.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at2_1',
          title: 'الدليل العقلي القرآني القاطع على وجود الخالق',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {أَمْ خُلِقُوا مِنْ غَيْرِ شَيْءٍ أَمْ هُمُ الْخَالِقُونَ * أَمْ خَلَقُوا السَّمَاوَاتِ وَالْأَرْضَ ۚ بَل لَّا يُوقِنُونَ}.',
          sourceAttribution: 'سورة الطور: الآيتان 35-36',
        ),
        LessonSection.create(
          sectionId: 'sec_at2_2',
          title: 'حقيقة توحيد الربوبية وإقرار الأمم السابقة به',
          contentType: LearningContentType.explanation,
          content: 'توحيد الربوبية هو اعتقاد جازم بأن الله وحده رب كل شيء ومليكه، لا شريك له في خلقه وملكه وتدبيره ورزقه وإحيائه وإماتته. وهذا التوحيد أقر به كفار قريش والمشركون قديماً، ولم يدخلهم في الإسلام بمجرده، لأنهم أشركوا مع الله غيره في العبادة والدعاء.',
          sourceAttribution: 'تيسير العزيز الحميد ص 22',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_kitab_tawheed_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: توحيد الألوهية وشروط لا إله إلا الله
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_aqidah_uluhiyyah_shurut',
      title: 'توحيد الألوهية ومعنى كلمة الإخلاص وشروطها السبعة',
      courseId: courseId,
      moduleId: 'mod_aqidah_tawheed_pillars',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at3_1',
          title: 'حفظ وفهم شروط لا إله إلا الله السبعة',
          description: 'إدراك معنى كلمة التوحيد (نفي العبودية عن سوى الله وإثباتها له وحده) مع الشروط السبعة المعتبرة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at3_1',
          title: 'النص الأصيل في غاية خلق الثقلين',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {وَمَا خَلَقْتُ الْجِنَّ وَالْإِنسَ إِلَّا لِيَعْبُدُونِ}. وقال ﷺ: «من قال لا إله إلا الله مخلصاً من قلبه دخل الجنة».',
          sourceAttribution: 'سورة الذاريات: الآية 56، وصحيح البخاري',
        ),
        LessonSection.create(
          sectionId: 'sec_at3_2',
          title: 'شروط لا إله إلا الله السبعة المأثورة',
          contentType: LearningContentType.explanation,
          content: 'معنى «لا إله إلا الله»: لا معبود بحق إلا الله، ولها ركنان: النفي (لا إله) والإثبات (إلا الله). وشروطها سبعة مجموعة في قول الناظم: «علمٌ يقينٌ وإخلاصٌ وصدقُك معْ محبةٍ وانقيادٍ والقبولِ لها».',
          sourceAttribution: 'سلم الوصول إلى علم الأصول لحافظ الحكمي',
        ),
        LessonSection.create(
          sectionId: 'sec_at3_3',
          title: 'تطبيق عملي: تفصيل الشروط السبعة في واقع المسلم',
          contentType: LearningContentType.example,
          content: '1. العلم المنافي للجهل، 2. اليقين المنافي للشك، 3. الإخلاص المنافي للشرك والرياء، 4. الصدق المنافي للنفاق، 5. المحبة المنافية للبغض، 6. الانقياد المنافي للترك، 7. القبول المنافي للرد.',
          sourceAttribution: 'شرح ثلاثة الأصول للشيخ ابن عثيمين',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: قواعد الأسماء والصفات
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_aqidah_asma_wa_sifat',
      title: 'قواعد أهل السنة والجماعة في أسماء الله الحسنى وصفاته العلا',
      courseId: courseId,
      moduleId: 'mod_aqidah_tawheed_pillars',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at4_1',
          title: 'إتقان قواعد الإثبات والتنزيه في الأسماء والصفات',
          description: 'إثبات ما أثبته الله لنفسه وما أثبته له رسوله ﷺ من غير تحريف ولا تعطيل ومن غير تكييف ولا تمثيل.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at4_1',
          title: 'الآية الأصلية في التنزيه والإثبات معاً',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {لَيْسَ كَمِثْلِهِ شَيْءٌ ۖ وَهُوَ السَّمِيعُ الْبَصِيرُ}.',
          sourceAttribution: 'سورة الشورى: الآية 11',
        ),
        LessonSection.create(
          sectionId: 'sec_at4_2',
          title: 'القواعد الكبرى في الأسماء والصفات عند السلف',
          contentType: LearningContentType.explanation,
          content: 'أسماء الله حسنى بالغة في الحسن غايته، وكل اسم يتضمن صفة كاملة لا نقص فيها بوجه من الوجوه. وصفاته تعالى كلها صفات كمال، والقول في الصفات كالقول في الذات؛ فكما أن لله ذاتاً حقيقية لا تشبه الذوات، فله صفات تليق بجلاله لا تشبه صفات المخلوقين.',
          sourceAttribution: 'القواعد المثلى في صفات الله وأسمائه الحسنى ص 15',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_wasitiyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الشرك الأكبر
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_aqidah_shirk_major',
      title: 'الشرك الأكبر: خطورته وصوره ومحبطاته للتطهر منه',
      courseId: courseId,
      moduleId: 'mod_aqidah_shirk_nullifiers',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at5_1',
          title: 'معرفة حقيقة الشرك الأكبر وصوره لحذره واجتنابه',
          description: 'صرف العبادة (دعاء، ذبح، نذر، استعانة غيبية) لغير الله تعالى وعاقبته.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at5_1',
          title: 'حكم الشرك الأكبر في القرآن الكريم',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {إِنَّ اللَّهَ لَا يَغْفِرُ أَن يُشْرَكَ بِهِ وَيَغْفِرُ مَا دُونَ ذَٰلِكَ لِمَن يَشَاءُ}. وقال: {إِنَّهُ مَن يُشْرِكْ بِاللَّهِ فَقَدْ حَرَّمَ اللَّهُ عَلَيْهِ الْجَنَّةَ وَمَأْوَاهُ النَّارُ}.',
          sourceAttribution: 'سورة النساء: الآية 48، وسورة المائدة: الآية 72',
        ),
        LessonSection.create(
          sectionId: 'sec_at5_2',
          title: 'أنواع الشرك الأكبر الأربعة',
          contentType: LearningContentType.explanation,
          content: 'الشرك الأكبر يحبط جميع الأعمال ويوجب الخلود في النار إن مات عليه صاحبه. وصوره الكبرى: 1. شرك الدعاء والمسألة، 2. شرك النية والإرادة والقصد، 3. شرك الطاعة في تحريم الحلال وتحليل الحرام، 4. شرك المحبة بتسوية غير الله بالله في المحبة والتعظيم.',
          sourceAttribution: 'كتاب التوحيد للشيخ محمد بن عبد الوهاب باب الشرك',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_kitab_tawheed_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 6: الشرك الأصغر وخفاياه
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_aqidah_shirk_minor',
      title: 'الشرك الأصغر: الرياء، الحلف بغير الله، والتطير والتمائم',
      courseId: courseId,
      moduleId: 'mod_aqidah_shirk_nullifiers',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at6_1',
          title: 'التمييز بين الشرك الأكبر والأصغر والحذر من محبطات الثواب',
          description: 'معرفة الشرك الأصغر كيسير الرياء وقول لولا الله وأنت، والتطير، والتمائم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at6_1',
          title: 'التحذير النبوي من الشرك الخفي',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «إن أخوف ما أخاف عليكم الشرك الأصغر: الرياء، يقول الله يوم القيامة: اذهبوا إلى الذين كنتم تراؤون في الدنيا فانظروا هل تجدون عندهم جزاءً؟» رواه أحمد.',
          sourceAttribution: 'مسند الإمام أحمد وصحيح الجامع للألباني رقم 1555',
        ),
        LessonSection.create(
          sectionId: 'sec_at6_2',
          title: 'أحكام الشرك الأصغر والفوارق الجوهرية',
          contentType: LearningContentType.explanation,
          content: 'الشرك الأصغر لا يخرج من الملة ولا يوجب الخلود في النار، لكنه أعظم من كبائر الذنوب ويحبط العمل الذي قارنه. ومن صوره: يسير الرياء، الحلف بغير الله (كالحلف بالأمانة أو بالنبي أو بالآباء)، وقول «ما شاء الله وشئت» بل يقال «ثم شئت»، وتعليق الخرز والتمائم لدفع العين.',
          sourceAttribution: 'فتح المجيد شرح كتاب التوحيد ص 180',
        ),
      ],
      sources: const ['src_ahmad_canonical', 'src_kitab_tawheed_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 7: نواقض الإسلام العشرة
    // -------------------------------------------------------------------------
    final lsn7 = Lesson.create(
      lessonId: 'lsn_aqidah_islam_nullifiers',
      title: 'نواقض الإسلام العشرة الكبرى وضوابط الفهم والاحتراز',
      courseId: courseId,
      moduleId: 'mod_aqidah_shirk_nullifiers',
      orderIndex: 7,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at7_1',
          title: 'معرفة النواقض العقدية الكبرى لسلامة دين المسلم',
          description: 'دراسة النواقض العشرة المعتمدة عند أئمة الدعوة والتأصيل مع مراعاة ضوابط التكفير المانعة من الغلو.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at7_1',
          title: 'بيان النواقض العشرة المجمع على خطورتها',
          contentType: LearningContentType.explanation,
          content: 'أبرز نواقض الإسلام: 1. الشرك في عبادة الله، 2. جعل وسائط بينه وبين الله يدعوهم ويتوكل عليهم، 3. من لم يكفر المشركين أو شك في كفرهم أو صحح مذهبهم، 4. من اعتقد أن هدي غير النبي ﷺ أكمل من هديه، 5. من أبغض شيئاً مما جاء به الرسول ﷺ ولو عمل به، 6. من استهزأ بشيء من دين الله أو ثوابه أو عقابه، 7. السحر والصرف والعطف، 8. مظاهرة المشركين ومعاونتهم على المسلمين بقصد علو الكفر، 9. من اعتقد أن بعض الناس يسعه الخروج عن شريعة محمد ﷺ، 10. الإعراض التام عن دين الله لا يتعلمه ولا يعمل به.',
          sourceAttribution: 'رسالة نواقض الإسلام للشيخ محمد بن عبد الوهاب',
        ),
        LessonSection.create(
          sectionId: 'sec_at7_2',
          title: 'ضوابط فقهية: الفرق بين الحكم المطلق والتكفير المعين',
          contentType: LearningContentType.scholarlyView,
          content: 'أهل السنة يفرقون بحزم بين الحكم على الفعل بأنه كفر أو ناقض، وبين الحكم على الشخص المعين؛ فلا يكفّر مسلم معين وقع في مكفر حتى تتوفر فيه الشروط (العلم، العمد، الاختيار) وتنتفي الموانع (كالجهل المعتبر، الإكراه، الخطأ، والتأويل السائغ)، وهذا اختصاص القضاء الشرعي والعلماء الراسخين.',
          sourceAttribution: 'مجموع فتاوى شيخ الإسلام ابن تيمية ج 12 ص 487',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_nawaqid_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 8: فقه الرقى والتمائم والاستشفاء
    // -------------------------------------------------------------------------
    final lsn8 = Lesson.create(
      lessonId: 'lsn_aqidah_ruqyah_amulets',
      title: 'فقه الرقى والتمائم المشروعة والاستشفاء بالقرآن والأدعية النبوية',
      courseId: courseId,
      moduleId: 'mod_aqidah_shirk_nullifiers',
      orderIndex: 8,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_at8_1',
          title: 'التمييز بين الرقية الشرعية والطلاسم الشركية والتمائم',
          description: 'معرفة شروط الرقية الشرعية الثلاثة وما يباح من الأسباب وما يحرم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_at8_1',
          title: 'النص النبوي في ضابط الرقى',
          contentType: LearningContentType.sourceText,
          content: 'قال رسول الله ﷺ: «اعرضوا عليّ رقاكم، لا بأس بالرقى ما لم يكن فيه شرك» رواه مسلم. وقال: «من تعلق تميمة فلا أتم الله له» رواه أحمد.',
          sourceAttribution: 'صحيح مسلم رقم 2200، ومسند أحمد',
        ),
        LessonSection.create(
          sectionId: 'sec_at8_2',
          title: 'شروط الرقية الشرعية المجمع عليها',
          contentType: LearningContentType.explanation,
          content: 'أجمع العلماء على جواز الرقية بثلاثة شروط: 1. أن تكون بكلام الله تعالى وأسمائه وصفاته أو المأثور عن النبي ﷺ، 2. أن تكون باللسان العربي وبما يعرف معناه ولا طلاسم أو تمتمات مجهولة فيه، 3. أن يعتقد أن الرقية لا تؤثر بذاتها بل بتقدير الله سبحانه.',
          sourceAttribution: 'فتح الباري لابن حجر ج 10 ص 195',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_fath_bari_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6, lsn7, lsn8];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Tawheed Divisions
    final q1 = QuizQuestion.create(
      questionId: 'q_aq_taw_1',
      lessonId: 'lsn_aqidah_tawheed_divisions',
      questionText: 'ما هي أقسام التوحيد الثلاثة التي دل عليها الاستقراء التام لنصوص القرآن والسنة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qt1_1', text: 'توحيد الربوبية، وتوحيد الألوهية، وتوحيد الأسماء والصفات'),
        QuizOption(optionId: 'opt_qt1_2', text: 'توحيد الذات، وتوحيد الوجود، وتوحيد العقل'),
        QuizOption(optionId: 'opt_qt1_3', text: 'توحيد الأفعال، وتوحيد الكون، وتوحيد الحاكمية فقط'),
      ],
      correctOptionIndices: const [0],
      explanation: 'استقرأ أئمة الإسلام نصوص الوحي فوجدوا التوحيد ينحصر في ثلاثة أقسام متلازمة: إفراد الله بأفعاله (الربوبية)، وإفراده بأفعال العباد (الألوهية)، وإفراده بأسمائه وصفاته.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_aqidah_tawheed_types',
      lessonId: 'lsn_aqidah_tawheed_divisions',
      title: 'اختبار أقسام التوحيد الثلاثة والاستقراء القرآني',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Conditions of La Ilaha Illa Allah
    final q2 = QuizQuestion.create(
      questionId: 'q_aq_shurut_1',
      lessonId: 'lsn_aqidah_uluhiyyah_shurut',
      questionText: 'كم عدد شروط كلمة التوحيد «لا إله إلا الله» التي لا تنفع قائلها إلا بتحققها؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qs1_1', text: 'سبعة شروط (العلم، واليقين، والقبول، والانقياد، والصدق، والإخلاص، والمحبة)'),
        QuizOption(optionId: 'opt_qs1_2', text: 'ثلاثة شروط فقط (النطق باللسان والمعرفة بالقلب والحفظ)'),
        QuizOption(optionId: 'opt_qs1_3', text: 'عشرة شروط غير محددة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'شروط لا إله إلا الله سبعة قررها أهل العلم بالاستقراء، ومفتاح الجنة لا يفتح إلا بأسنان وهي هذه الشروط.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_aqidah_shurut_la_ilaha',
      lessonId: 'lsn_aqidah_uluhiyyah_shurut',
      title: 'اختبار شروط كلمة الإخلاص لا إله إلا الله',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Major Shirk vs Minor Shirk
    final q3 = QuizQuestion.create(
      questionId: 'q_aq_shirk_1',
      lessonId: 'lsn_aqidah_islam_nullifiers',
      questionText: 'ما الفرق الجوهري بين الشرك الأكبر والشرك الأصغر في الحكم الأخروي؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qsh1_1', text: 'الشرك الأكبر يخرج من الملة ويحبط جميع الأعمال ويوجب الخلود في النار، بينما الأصغر لا يخرج من الملة ولا يخلد في النار'),
        QuizOption(optionId: 'opt_qsh1_2', text: 'لا فرق بينهما فكلاهما يوجب الخلود الأبدي في النار'),
        QuizOption(optionId: 'opt_qsh1_3', text: 'الشرك الأصغر مباح ومعفو عنه بلا مؤاخذة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الشرك الأكبر مخرج من الملة ومحبط لسائر العمل وموجب للخلود في النار لمن مات عليه، أما الأصغر فلا يخرج من الملة ولا يحبط إلا العمل الذي قارنه وتحت المشيئة.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_aqidah_shirk_nullifiers',
      lessonId: 'lsn_aqidah_islam_nullifiers',
      title: 'اختبار نواقض الإسلام والفروق بين الشرك الأكبر والأصغر',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
