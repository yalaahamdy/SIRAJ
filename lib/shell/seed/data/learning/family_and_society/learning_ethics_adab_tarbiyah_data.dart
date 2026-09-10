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

/// بيانات مقرر مكارم الأخلاق والتربية والآداب الإسلامية وتزكية النفس (6 دروس تأصيلية + اختباران استيعاب)
class LearningEthicsAdabTarbiyahData {
  static const String courseId = 'course_ethics_adab_tarbiyah';
  static const String pathId = 'path_family_ethics_society_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر مكارم الأخلاق والتربية والآداب الإسلامية وتزكية النفس',
      description: 'دراسة تأصيلية تربوية شاملة لمنظومة الأخلاق والآداب الإسلامية: مكانة الأخلاق وأمهات الفضائل، تطهير القلوب من المهلكات، بر الوالدين وصلة الأرحام، وآداب المعاشرة اليومية وحفظ اللسان والجوارح.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_ethics_purification_virtues', 'mod_ethics_social_adab'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_ethics_purification_virtues',
        courseId: courseId,
        title: 'الوحدة الأولى: أمهات الأخلاق وتزكية النفس وعلاج آفات القلوب',
        description: 'بيان مكانة الأخلاق وصلتها بالإيمان، أمهات الفضائل (الصدق، الأمانة، الحياء، الصبر، التواضع)، وتطهير النفس من الكبر والرياء والحسد والغضب.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_ethics_core_virtues_faith',
          'lsn_ethics_patience_humility_gratitude',
          'lsn_ethics_heart_diseases_purification',
        ],
      ),
      CourseModule(
        moduleId: 'mod_ethics_social_adab',
        courseId: courseId,
        title: 'الوحدة الثانية: آداب السلوك والمعاشرة وحقوق الوالدين والأرحام والمجتمع',
        description: 'تأصيل بر الوالدين وصلة الأرحام، حقوق الجوار والضيافة، آداب الأخوة والصحبة، حفظ اللسان من آفات الغيبة والنميمة، وآداب المجالس والسلام.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_ethics_purification_virtues'],
        lessonIds: const [
          'lsn_ethics_parents_kinship_children',
          'lsn_ethics_neighbors_guests_brotherhood',
          'lsn_ethics_tongue_guardianship_gatherings',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: مكانة الأخلاق وأمهات الفضائل وعلاقتها بالإيمان
    // -------------------------------------------------------------------------
    final evEthicsQuran = EvidenceLink.create(
      evidenceId: 'ev_ethics_quran_khuluq',
      evidenceKey: '68:4',
      citation: 'سورة القلم: الآية 4 {وَإِنَّكَ لَعَلَىٰ خُلُقٍ عَظِيمٍ}',
      sourceId: 'src_quran_canonical',
    );
    final evEthicsHadith = EvidenceLink.create(
      evidenceId: 'ev_ethics_hadith_makarim',
      evidenceKey: 'ahmad:8952',
      citation: 'مسند الإمام أحمد: «إِنَّمَا بُعِثْتُ لِأُتَمِّمَ صَالِحَ الأَخْلَاقِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_ethics_core_virtues_faith',
      title: 'مكانة الأخلاق في الإسلام وعلاقتها بصدق الإيمان وأمهات الفضائل',
      courseId: courseId,
      moduleId: 'mod_ethics_purification_virtues',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_eth1_1',
          title: 'المنزلة المركزية للأخلاق',
          description: 'إدراك المنزلة المركزية لمكارم الأخلاق وأنها ثمرة الإيمان والعبادات في الإسلام.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth1_2',
          title: 'أمهات الفضائل الأخلاقية',
          description: 'معرفة فضائل الصدق والأمانة والحياء والعفة كأركان مكينة للشخصية المسلمة.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth1_3',
          title: 'ثواب حسن الخلق في الميزان',
          description: 'استيعاب ثواب حسن الخلق في الميزان وأنه أقرب الناس مجلساً من النبي ﷺ يوم القيامة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_eth1_1',
          title: 'الغاية العظمى للرسالة المحمدية وربط الأخلاق بالإيمان',
          contentType: LearningContentType.sourceText,
          content: 'جعل النبي ﷺ الغاية الكبرى من بعثته هي تتميم مكارم الأخلاق فقال «إنما بعثت لأتمم صالح الأخلاق». والأخلاق في الإسلام ليست أعرافاً نفعية ولا مجاملات متغيرة، بل هي عبادة وقربة وشرط لكمال الإيمان لقوله ﷺ «أكمل المؤمنين إيماناً أحسنهم خلقاً»، وما من شيء أثقل في ميزان المؤمن يوم القيامة من حسن الخلق.',
          evidenceLinks: [evEthicsQuran, evEthicsHadith],
          sourceAttribution: 'إحياء علوم الدين وشعب الإيمان للبيهقي',
        ),
        LessonSection.create(
          sectionId: 'sec_eth1_2',
          title: 'الصدق والأمانة: أساس الثقة وصلاح العمران',
          contentType: LearningContentType.explanation,
          content: 'الصدق رأس الفضائل، يهدي إلى البر، والبر يهدي إلى الجنة؛ ويكون باللسان في القول، وبالقلب في الإخلاص، وبالجوارح في مطابقة الظاهر للباطن. وتقترن بالصدق الأمانةُ العظمى في حفظ الودائع، والوفاء بالتكاليف والمسؤوليات المهنية والاجتماعية دون خيانة ولا تفريط.',
          sourceAttribution: 'مدارج السالكين لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_eth1_3',
          title: 'الحياء والعفة: سياج الفضيلة وصيانة الكرامة',
          contentType: LearningContentType.explanation,
          content: 'الحياء خلق يبعث على فعل الجميل وترك القبيح، وهو شعبة أصيلة من شعب الإيمان لقوله ﷺ «الحياء لا يأتي إلا بخير». وتتفرع عنه العفة في صيانة النفس عن المحارم والشبهات، والتعفف عن أموال الناس وسؤالهم، وحفظ الفروج وصيانة الأعراض.',
          sourceAttribution: 'جامع العلوم والحكم لابن رجب',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: الصبر والشكر والتوكل والرضا والتواضع
    // -------------------------------------------------------------------------
    final evPatienceQuran = EvidenceLink.create(
      evidenceId: 'ev_ethics_patience_quran_zumar',
      evidenceKey: '39:10',
      citation: 'سورة الزمر: الآية 10 {إِنَّمَا يُوَفَّى الصَّابِرُونَ أَجْرَهُم بِغَيْرِ حِسَابٍ}',
      sourceId: 'src_quran_canonical',
    );
    final evHumilityHadith = EvidenceLink.create(
      evidenceId: 'ev_ethics_humility_hadith_muslim',
      evidenceKey: 'muslim:2588',
      citation: 'صحيح مسلم: «وَمَا تَوَاضَعَ أَحَدٌ لِلَّهِ إِلَّا رَفَعَهُ اللهُ»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_ethics_patience_humility_gratitude',
      title: 'الصبر والاحتساب، الشكر، التوكل على الله، والتواضع ولين الجانب',
      courseId: courseId,
      moduleId: 'mod_ethics_purification_virtues',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_eth2_1',
          title: 'مراتب الصبر الثلاث',
          description: 'التمييز بين مراتب الصبر الثلاث: الصبر على الطاعة، الصبر عن المعصية، والصبر على أقدار الله المؤلمة.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth2_2',
          title: 'حقيقة الشكر والتوكل الصادق',
          description: 'إدراك حقيقة الشكر بالقلب واللسان والجوارح وربطه بالتوكل والرضا.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth2_3',
          title: 'ثمار التواضع ولين الجانب',
          description: 'معرفة ثمار التواضع وخفض الجناح للمؤمنين ونبذ التعالي والغطرسة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_eth2_1',
          title: 'مراتب الصبر الثلاث وجزاء الصابرين',
          contentType: LearningContentType.sourceText,
          content: 'الصبر ضياء وحبس للنفس عن الجزع؛ ومراتبه ثلاثة: أعلاها الصبر على أداء الطاعات والمداومة عليها برغم المشاق، ثم الصبر عن مقارفة المعاصي والشهوات ومجاهدة هوى النفس، ثم الصبر عند الصدمة الأولى لأقدار الله المؤلمة بالاحتساب واليقين بحكمة الله ورحمته.',
          evidenceLinks: [evPatienceQuran, evHumilityHadith],
          sourceAttribution: 'عدة الصابرين وذخيرة الشاكرين لابن القيم',
        ),
        LessonSection.create(
          sectionId: 'sec_eth2_2',
          title: 'حقيقة الشكر والتوكل الصادق والرضا بالقضاء',
          contentType: LearningContentType.explanation,
          content: 'الشكر قيد النعم القائمة وجالب النعم المفقودة؛ ويتحقق باعتراف القلب بأن كل نعمة من الله، ولهج اللسان بالحمد والثناء، واستعمال الجوارح في طاعة المنعم لا في معصيته. ويقترن به التوكل الصادق بالأخذ الكامل بالأسباب مع قطع القلب عن الالتفات إليها والاعتماد التام على مسبب الأسباب سبحانه.',
          sourceAttribution: 'إحياء علوم الدين للغزالي',
        ),
        LessonSection.create(
          sectionId: 'sec_eth2_3',
          title: 'التواضع ولين الجانب وسماحة النفس',
          contentType: LearningContentType.explanation,
          content: 'التواضع قبول الحق ممن جاء به، وخفض الجناح للخلق، والبعد عن التكبر والاستعلاء بنسب أو مال أو علم أو جاه. وقد وعد الله المتواضعين بالرفعة في الدنيا والآخرة كما قال ﷺ «وما تواضع أحد لله إلا رفعه الله».',
          sourceAttribution: 'الترغيب والترهيب للمنذري',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: تزكية القلوب من المهلكات وعلاج الآفات
    // -------------------------------------------------------------------------
    final evPurifyQuran = EvidenceLink.create(
      evidenceId: 'ev_ethics_purify_quran_shams',
      evidenceKey: '91:9-10',
      citation: 'سورة الشمس: الآيتان 9-10 {قَدْ أَفْلَحَ مَن زَكَّاهَا ۝ وَقَدْ خَابَ مَن دَسَّاهَا}',
      sourceId: 'src_quran_canonical',
    );
    final evKibrHadith = EvidenceLink.create(
      evidenceId: 'ev_ethics_kibr_hadith_muslim',
      evidenceKey: 'muslim:91',
      citation: 'صحيح مسلم: «الكِبْرُ بَطَرُ الحَقِّ وَغَمْطُ النَّاسِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_ethics_heart_diseases_purification',
      title: 'تزكية القلوب من أمراض النفوس: الكبر، الرياء، الحسد، والغضب',
      courseId: courseId,
      moduleId: 'mod_ethics_purification_virtues',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_eth3_1',
          title: 'حقيقة الكبر واقتلاعه',
          description: 'إدراك حقيقة الكبر وضوابطه النبوية (بطر الحق وغمط الناس) وخطورته العقدية.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth3_2',
          title: 'علاج الرياء بالإخلاص',
          description: 'معرفة حقيقة الرياء (الشرك الأصغر) وسبل تحقيق الإخلاص التام لله رب العالمين.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth3_3',
          title: 'إخماد الحسد ونيران الغضب',
          description: 'التعرف على سبل علاج الحسد والبغضاء وإخماد نيران الغضب بالهدي النبوي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_eth3_1',
          title: 'مرض الكبر والعجب وسبل اقتلاعهما من القلب',
          contentType: LearningContentType.sourceText,
          content: 'الكبر داء مهلك أول من عصى الله به إبليس؛ وحقيقته النبوية الدقيقة هي: «بطر الحق» أي رده وعدم قبوله استكباراً، و«غمط الناس» أي احتقارهم وازدراؤهم. وعلاجه بتذكر أصل خلقة الإنسان من تراب ونطفة مذرة، واستشعار عظمة الله الجبار المتكبر وحده.',
          evidenceLinks: [evPurifyQuran, evKibrHadith],
          sourceAttribution: 'مختصر منهاج القاصدين لابن قدامة',
        ),
        LessonSection.create(
          sectionId: 'sec_eth3_2',
          title: 'الرياء وطلب المنزلة في قلوب الخلق وعلاجه بالإخلاص',
          contentType: LearningContentType.explanation,
          content: 'الرياء هو العمل الصالح ليراه الناس فيثنوا عليه، وهو الشرك الخفي الذي يبطل العمل ويسقط ثوابه. وعلاجه بدوام مراقبة الله، وإخفاء الأعمال الصالحة والنوافل كصدقة السر وقيام الليل، واستحضار أن مدح الناس لا ينفع وذمهم لا يضر إلا بأمر الله.',
          sourceAttribution: 'مدارج السالكين ومنهاج القاصدين',
        ),
        LessonSection.create(
          sectionId: 'sec_eth3_3',
          title: 'الحسد والغضب ووسائل تفريغ الأحقاد النبوية',
          contentType: LearningContentType.explanation,
          content: 'الحسد تمني زوال النعمة عن الغير والاعتراض الضمني على قسمة الله وحكمته. وعلاجه بالدعاء بالبركة للغير والمنافسة في الغبطة المحمودة. أما الغضب فجمرة من الشيطان؛ وعلاجه النبوي بالاستعاذة بالله من الشيطان، والسكوت، وتغيير الهيئة بالجلوس أو الاضطجاع، والوضوء بالماء البارد.',
          sourceAttribution: 'إحياء علوم الدين ورياض الصالحين',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: بر الوالدين وصلة الأرحام وحقوق الأبناء
    // -------------------------------------------------------------------------
    final evParentsQuran = EvidenceLink.create(
      evidenceId: 'ev_ethics_parents_quran_isra',
      evidenceKey: '17:23',
      citation: 'سورة الإسراء: الآية 23 {وَقَضَىٰ رَبُّكَ أَلَّا تَعْبُدُوا إِلَّا إِيَّاهُ وَبِالْوَالِدَيْنِ إِحْسَانًا}',
      sourceId: 'src_quran_canonical',
    );
    final evKinshipHadith = EvidenceLink.create(
      evidenceId: 'ev_ethics_kinship_hadith_bukhari',
      evidenceKey: 'bukhari:5986',
      citation: 'صحيح البخاري: «مَنْ أَحَبَّ أَنْ يُبْسَطَ لَهُ فِي رِزْقِهِ، وَيُنْسَأَ لَهُ فِي أَثَرِهِ، فَلْيَصِلْ رَحِمَهُ»',
      sourceId: 'src_hadith_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_ethics_parents_kinship_children',
      title: 'بر الوالدين والإحسان إليهما، صلة الأرحام، وتربية الأبناء على الإيمان',
      courseId: courseId,
      moduleId: 'mod_ethics_social_adab',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_eth4_1',
          title: 'بر الوالدين وحرمة العقوق',
          description: 'إدراك عظمة اقتران حق الوالدين بتوحيد الله في القرآن وحرمة العقوق.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth4_2',
          title: 'فضائل صلة الرحم وبركتها',
          description: 'معرفة فضائل صلة الرحم وأثرها في بركة الرزق والعمر والتحذير من القطيعة.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth4_3',
          title: 'مسؤولية تربية الأبناء',
          description: 'بيان حقوق الأبناء من التسمية الحسنة، النفقة، والتربية العقدية والقيمية السليمة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_eth4_1',
          title: 'بر الوالدين وحرمة العقوق في الحياة وبعد الممات',
          contentType: LearningContentType.sourceText,
          content: 'قرن الله عز وجل حقه في العبادة ببر الوالدين في مواضع عدة تعظيماً لحقهما. والبر بهما يكون بطاعتهما في غير معصية، والتأدب التام معهما فلا يقال لهما «أف»، والإنفاق عليهما، والاستغفار لهما وإنفاذ عهدهما وصلة الرحم التي لا توصل إلا بهما بعد وفاتهما.',
          evidenceLinks: [evParentsQuran, evKinshipHadith],
          sourceAttribution: 'الأدب المفرد للبخاري',
        ),
        LessonSection.create(
          sectionId: 'sec_eth4_2',
          title: 'صلة الأرحام وفضائلها الدنيوية والأخروية',
          contentType: LearningContentType.explanation,
          content: 'الرحم شجنة معلقة بالعرش تقول: من وصلني وصله الله ومن قطعني قطعه الله. وصلة الرحم تكون بالزيارة، وتفقد الأحوال، والمواساة بالمال، وإسداء النصح، وتحمل الأذى، والواصل الحقيقي ليس المكافئ، بل الذي إذا قطعت رحمه وصلها.',
          sourceAttribution: 'صحيح الترغيب والترهيب للألباني',
        ),
        LessonSection.create(
          sectionId: 'sec_eth4_3',
          title: 'مسؤولية تربية الأبناء وبناء جيل الإيمان والفضيلة',
          contentType: LearningContentType.explanation,
          content: 'الأولاد أمانة في أعناق الوالدين؛ ومسؤوليتهما تبدأ باختيار الاسم الحسن، وحسن الرعاية والتغذية الحلال، ثم الغرس العقدي بغرس حب الله ورسوله والقرآن، وتعليمهم الصلاة لسبع سنين، والعدل بينهم في الهبات والعطايا دون تفضيل.',
          sourceAttribution: 'تحفة المودود بأحكام المولود لابن القيم',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: حقوق الجار والضيف وآداب الأخوة وعيادة المريض
    // -------------------------------------------------------------------------
    final evNeighborQuran = EvidenceLink.create(
      evidenceId: 'ev_ethics_neighbor_quran_nisaa',
      evidenceKey: '4:36',
      citation: 'سورة النساء: الآية 36 {وَاعْبُدُوا اللَّهَ وَلَا تُشْرِكُوا بِهِ شَيْئًا ۖ وَبِالْوَالِدَيْنِ إِحْسَانًا ... وَالْجَارِ ذِي الْقُرْبَىٰ وَالْجَارِ الْجُنُبِ}',
      sourceId: 'src_quran_canonical',
    );
    final evNeighborHadith = EvidenceLink.create(
      evidenceId: 'ev_ethics_neighbor_hadith_jibril',
      evidenceKey: 'bukhari:6014',
      citation: 'صحيح البخاري: «مَا زَالَ جِبْرِيلُ يُوصِينِي بِالجَارِ، حَتَّى ظَنَنْتُ أَنَّهُ سَيُوَرِّثُهُ»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_ethics_neighbors_guests_brotherhood',
      title: 'حقوق الجار، إكرام الضيف، آداب الأخوة في الله، وعيادة المريض',
      courseId: courseId,
      moduleId: 'mod_ethics_social_adab',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_eth5_1',
          title: 'مراتب الجيران وحقوقهم',
          description: 'استيعاب مراتب الجيران الثلاثة وحقوق كل منهم وكف الأذى عنهم.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth5_2',
          title: 'آداب الضيافة وإكرام الضيف',
          description: 'معرفة آداب الضيافة وإكرام الضيف كأمارة من أمارات صدق الإيمان بالله واليوم الآخر.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth5_3',
          title: 'حقوق الأخوة وعيادة المرضى',
          description: 'إدراك حقوق الأخوة الإيمانية وآداب عيادة المريض وتشييع الجنائز ومواساة المبتلين.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_eth5_1',
          title: 'حقوق الجوار في الإسلام ومراتب الجيران الثلاث',
          contentType: LearningContentType.sourceText,
          content: 'عظّم الإسلام حق الجار حتى قال النبي ﷺ «ما زال جبريل يوصيني بالجار حتى ظننت أنه سيورثه». والجيران ثلاثة: جار له ثلاثة حقوق (الجار المسلم ذو القرابة)، وجار له حقان (الجار المسلم)، وجار له حق واحد (الجار غير المسلم: حق الجوار بكف الأذى والإحسان إليه).',
          evidenceLinks: [evNeighborQuran, evNeighborHadith],
          sourceAttribution: 'رياض الصالحين للنووي',
        ),
        LessonSection.create(
          sectionId: 'sec_eth5_2',
          title: 'إكرام الضيف وآداب الضيافة الشرعية',
          contentType: LearningContentType.explanation,
          content: 'إكرام الضيف من أمارات الإيمان؛ لقوله ﷺ «من كان يؤمن بالله واليوم الآخر فليكرم ضيفه». وضيافته الواجبة يوم وليلة، وجائزته ثلاثة أيام، وما زاد فهو صدقة، وعلى الضيف ألا يثقل على مضيفه حتى يحرجه.',
          sourceAttribution: 'الجامع لأحكام القرآن للقرطبي',
        ),
        LessonSection.create(
          sectionId: 'sec_eth5_3',
          title: 'حقوق المسلم الست وعيادة المرضى ومواساة المنكوبين',
          contentType: LearningContentType.explanation,
          content: 'للمسلم على أخيه ستة حقوق ثابتة: إذا لقيه سلم عليه، وإذا دعاه أجابه، وإذا استنصحه نصح له، وإذا عطس فحمد الله شمته، وإذا مرض عاده، وإذا مات شيعه؛ مما يرسخ بنيان الأمة كالبنيان المرصوص يشد بعضه بعضاً.',
          sourceAttribution: 'شرح صحيح مسلم للنووي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: حفظ اللسان وآداب المجالس والاستئذان وإفشاء السلام
    // -------------------------------------------------------------------------
    final evTongueQuran = EvidenceLink.create(
      evidenceId: 'ev_ethics_tongue_quran_qaf',
      evidenceKey: '50:18',
      citation: 'سورة ق: الآية 18 {مَّا يَلْفِظُ مِن قَوْلٍ إِلَّا لَدَيْهِ رَقِيبٌ عَتِيدٌ}',
      sourceId: 'src_quran_canonical',
    );
    final evSalamHadith = EvidenceLink.create(
      evidenceId: 'ev_ethics_salam_hadith_muslim',
      evidenceKey: 'muslim:54',
      citation: 'صحيح مسلم: «أَفْشُوا السَّلَامَ بَيْنَكُمْ تَحَابُّوا»',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_ethics_tongue_guardianship_gatherings',
      title: 'آداب اللسان وحفظ الجوارح، آداب المجالس والاستئذان، وإفشاء السلام',
      courseId: courseId,
      moduleId: 'mod_ethics_social_adab',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_eth6_1',
          title: 'خطورة آفات اللسان',
          description: 'إدراك خطورة آفات اللسان كالغيبة والنميمة والبهتان والكذب والسباب.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth6_2',
          title: 'آداب المجالس وكفارتها',
          description: 'معرفة آداب المجالس ومراعاة مشاعر الحاضرين ودعاء كفارة المجلس.',
        ),
        LearningObjective(
          objectiveId: 'obj_eth6_3',
          title: 'أحكام الاستئذان وإفشاء السلام',
          description: 'تطبيق أحكام الاستئذان الشرعي وإفشاء السلام بين الخاص والعام لنشر المحبة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_eth6_1',
          title: 'آفات اللسان ومزالق القول وسبل حفظه',
          contentType: LearningContentType.sourceText,
          content: 'اللسان أصغر الأعضاء حجماً وأعظمها خطراً وجرماً؛ وقد قال ﷺ لمعاذ بن جبل رضي الله عنه: «وهل يكب الناس في النار على وجوههم إلا حصائد ألسنتهم». ومن أعظم آفاته: الغيبة (ذكرك أخاك بما يكره)، النميمة (نقل الكلام للإفساد)، السخرية، الكذب، وقول الزور.',
          evidenceLinks: [evTongueQuran, evSalamHadith],
          sourceAttribution: 'الأذكار للإمام النووي',
        ),
        LessonSection.create(
          sectionId: 'sec_eth6_2',
          title: 'آداب المجالس وصيانة حرماتها وكفارتها النبوية',
          contentType: LearningContentType.explanation,
          content: 'للمجالس آداب كريمة: ألا يقام أحد من مجلسه ليجلس مكانه، والتوسع والتفسح في المجلس، وعدم تناجي اثنين دون الثالث مراعاة لمشاعره، وخفض الصوت، وختم المجلس بكفارته المأثورة: «سبحانك اللهم وبحمدك، أشهد أن لا إله إلا أنت، أستغفرك وأتوب إليك».',
          sourceAttribution: 'رياض الصالحين',
        ),
        LessonSection.create(
          sectionId: 'sec_eth6_3',
          title: 'آداب الاستئذان وإفشاء تحية الإسلام العطرة',
          contentType: LearningContentType.explanation,
          content: 'الاستئذان شرع من أجل البصر وصيانة العورات؛ حده ثلاث مرات، مع الوقوف عن يمين الباب أو يساره دون مواجهة المدخل. والسلام تحية أهل الجنة؛ وسنة مؤكدة في البدء وفرض كفاية في الرد، وإفشاؤه سبب لزرع المحبة وولوج الجنان.',
          sourceAttribution: 'الآداب الشرعية لابن مفلح',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: أمهات الأخلاق وتزكية النفس
    final q1 = QuizQuestion.create(
      questionId: 'q_eth_1',
      lessonId: 'lsn_ethics_heart_diseases_purification',
      questionText: 'ما هو التفسير النبوي الصحيح والدقيق لخلق "الكِبر" المانع من دخول الجنة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qe1_1', text: 'بطر الحق (رده وعدم قبوله) وغمط الناس (احتقارهم وازدراؤهم)'),
        QuizOption(optionId: 'opt_qe1_2', text: 'لبس الثياب النظيفة الفاخرة والنعل الحسن'),
        QuizOption(optionId: 'opt_qe1_3', text: 'التفوق في العلم والمهارة الدنيوية مع شكر الله'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قال ﷺ لما سُئل عن الرجل يحب أن يكون ثوبه حسناً: «إن الله جميل يحب الجمال، الكبر بطر الحق وغمط الناس».',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_ethics_purification_virtues',
      lessonId: 'lsn_ethics_heart_diseases_purification',
      title: 'اختبار أمهات الأخلاق وتزكية النفوس وعلاج الآفات',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: آداب السلوك والمعاشرة
    final q2 = QuizQuestion.create(
      questionId: 'q_eth_2',
      lessonId: 'lsn_ethics_neighbors_guests_brotherhood',
      questionText: 'كم عدد حقوق الجار غير المسلم الذي ليس بينك وبينه قرابة في الشريعة الإسلامية؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qe2_1', text: 'حق واحد وهو حق الجوار بالإحسان وكف الأذى عنه'),
        QuizOption(optionId: 'opt_qe2_2', text: 'ليس له أي حق لكونه غير مسلم'),
        QuizOption(optionId: 'opt_qe2_3', text: 'ثلاثة حقوق كاملة بالتساوي مع الجار المسلم القريب'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الجار غير المسلم غير القريب له حق واحد هو حق الجوار، تأكيداً على سماحة الإسلام وحسن المعاشرة الإنسانية.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_ethics_social_adab',
      lessonId: 'lsn_ethics_neighbors_guests_brotherhood',
      title: 'اختبار آداب المعاشرة وحفظ اللسان وحقوق المجتمع',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
