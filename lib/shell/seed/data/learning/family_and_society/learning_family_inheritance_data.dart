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

/// بيانات مقرر فقه الأسرة المسلمة والأحوال الشخصية والمواريث (6 دروس تأصيلية + اختباران استيعاب)
class LearningFamilyInheritanceData {
  static const String courseId = 'course_fiqh_family_inheritance';
  static const String pathId = 'path_family_ethics_society_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الأسرة المسلمة والأحوال الشخصية والمواريث',
      description: 'دراسة فقهية تأصيلية شاملة لأحكام الأسرة: الخطبة والزواج وحقوق الزوجين، فقه الفرقة والطلاق والخلع والحضانة، وأحكام علم الفرائض والمواريث والوصايا في الشريعة الإسلامية.',
      level: lp.LearningLevel.intermediate,
      moduleIds: const ['mod_family_marriage_divorce', 'mod_family_inheritance_faraid'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_family_marriage_divorce',
        courseId: courseId,
        title: 'الوحدة الأولى: فقه النكاح والعلاقات الأسرية وحقوق الزوجين والفرقة',
        description: 'بيان أحكام الخطبة وأركان عقد النكاح وشروطه، الحقوق والواجبات الزوجية، علاج الخلافات الأسرية والنشوز، وفقه الطلاق والخلع والعدة والحضانة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_family_marriage_pillars',
          'lsn_family_marital_rights_disputes',
          'lsn_family_divorce_iddah_custody',
        ],
      ),
      CourseModule(
        moduleId: 'mod_family_inheritance_faraid',
        courseId: courseId,
        title: 'الوحدة الثانية: علم الفرائض والمواريث والوصايا في الشريعة الإسلامية',
        description: 'تأصيل علم المواريث، الحقوق المتعلقة بالتركة، أصحاب الفروض والعصبات والحجب، وأحكام الوصايا وقسمة التركات والمسائل المستجدة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_family_marriage_divorce'],
        lessonIds: const [
          'lsn_family_faraid_principles',
          'lsn_family_heirs_shares_asabah',
          'lsn_family_wills_distribution',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: الخطبة وعقد النكاح وأركانه وشروطه
    // -------------------------------------------------------------------------
    final evMarriageQuran = EvidenceLink.create(
      evidenceId: 'ev_family_marriage_quran_rum',
      evidenceKey: '30:21',
      citation: 'سورة الروم: الآية 21 {وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُم مَّوَدَّةً وَرَحْمَةً}',
      sourceId: 'src_quran_canonical',
    );
    final evMarriageSunnah = EvidenceLink.create(
      evidenceId: 'ev_family_marriage_hadith_tazawwaju',
      evidenceKey: 'bukhari:5066',
      citation: 'صحيح البخاري: «يَا مَعْشَرَ الشَّبَابِ مَنِ اسْتَطَاعَ مِنْكُمُ البَاءَةَ فَلْيَتَزَوَّجْ»',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_family_marriage_pillars',
      title: 'الخطبة وأركان عقد النكاح وشروط صحته والمحرمات من النساء',
      courseId: courseId,
      moduleId: 'mod_family_marriage_divorce',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_fam1_1',
          title: 'مشروعية النكاح ومقاصده وضوابط الخطبة',
          description: 'استيعاب مشروعية الزواج ومقاصده وضوابط الخطبة الشرعية والنظر إلى المخطوبة.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam1_2',
          title: 'أركان عقد النكاح وشروط صحته',
          description: 'معرفة أركان عقد النكاح وشروطه كالإيجاب والقبول والولي والشهود والصداق.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam1_3',
          title: 'المحرمات من النساء تأبيداً وتأقيتاً',
          description: 'التمييز بين المحرمات من النساء على التأبيد بالقرابة والمصاهرة والرضاع والمحرمات مؤقتاً.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_fam1_1',
          title: 'مشروعية النكاح ومقاصده وضوابط الخطبة الشرعية',
          contentType: LearningContentType.sourceText,
          content: 'النكاح ميثاق غليظ وسنة نبوية جليلة غايتها الإعفاف وحفظ النسل وبناء الأسرة المستقرة على المودة والرحمة. وتبدأ بمرحلة الخطبة؛ وهي وعد بالزواج يشرع فيها النظر إلى المخطوبة بضوابط العفة دون خلوة محرمة أو تبرج.',
          evidenceLinks: [evMarriageQuran, evMarriageSunnah],
          sourceAttribution: 'تفسير القرطبي والمغني لابن قدامة',
        ),
        LessonSection.create(
          sectionId: 'sec_fam1_2',
          title: 'أركان عقد النكاح وشروط صحته ونفاذه',
          contentType: LearningContentType.explanation,
          content: 'أركان عقد النكاح هي: العاقدان الخاليان من الموانع، والإيجاب والقبول اللذان يدلان على الرضا الصريح. وشروط صحته: تعيين الزوجين، رضا الزوجين، الولاية في النكاح لقوله ﷺ «لا نكاح إلا بولي»، والشهادة بعقد النكاح بحضور شاهدين عدلين، وتسمية الصداق (المهر) كحق خالص للمرأة.',
          sourceAttribution: 'الفقه الإسلامي وأدلته للزحيلي',
        ),
        LessonSection.create(
          sectionId: 'sec_fam1_3',
          title: 'المحرمات من النساء تأبيداً وتأقيتاً',
          contentType: LearningContentType.explanation,
          content: 'المحرمات على التأبيد ينقسمن إلى ثلاثة أسباب: القرابة (الأمهات، البنات، الأخوات، العمات، الخالات، وبنات الأخ والأخت)، المصاهرة (أم الزوجة، زوجات الآباء، زوجات الأبناء، والربائب بشرط الدخول بالأم)، والرضاع؛ حيث يحرم من الرضاع ما يحرم من النسب بخمس رضعات مشبعات في الحولين. أما المحرمات مؤقتاً فيشملن: الجمع بين الأختين أو المرأة وعمتها أو خالتها، والمرأة المتزوجة أو المعتدة حتى تنقضي عدتها.',
          sourceAttribution: 'بداية المجتهد ونهاية المقتصد لابن رشد',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: الحقوق والواجبات الزوجية وعلاج النشوز
    // -------------------------------------------------------------------------
    final evRightsQuran = EvidenceLink.create(
      evidenceId: 'ev_family_rights_quran_ashiru',
      evidenceKey: '4:19',
      citation: 'سورة النساء: الآية 19 {وَعَاشِرُوهُنَّ بِالْمَعْرُوفِ}',
      sourceId: 'src_quran_canonical',
    );
    final evRightsHadith = EvidenceLink.create(
      evidenceId: 'ev_family_rights_hadith_khayrukum',
      evidenceKey: 'tirmidhi:3895',
      citation: 'سنن الترمذي: «خَيْرُكُمْ خَيْرُكُمْ لِأَهْلِهِ، وَأَنَا خَيْرُكُمْ لِأَهْلِي»',
      sourceId: 'src_hadith_canonical',
    );

    final l2 = Lesson.create(
      lessonId: 'lsn_family_marital_rights_disputes',
      title: 'الحقوق والواجبات الزوجية المشتركة، المعاشرة بالمعروف، وعلاج النشوز',
      courseId: courseId,
      moduleId: 'mod_family_marriage_divorce',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_fam2_1',
          title: 'الحقوق الزوجية المشتركة والخاصة',
          description: 'تحديد الحقوق المشتركة بين الزوجين وحق الاستمتاع المشروع وحسن المعاشرة.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam2_2',
          title: 'حقوق الزوجة وقوامة الزوج الرعائية',
          description: 'بيان حقوق الزوجة المالية وغير المالية ومفهوم القوامة الرعائية للرجل.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam2_3',
          title: 'منهج علاج النشوز والخلافات',
          description: 'إدراك خطوات علاج النشوز والخلافات الأسرية بالتدرج الشرعي والتحكيم العائلي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_fam2_1',
          title: 'الحقوق الزوجية المشتركة وحق كل من الزوجين على الآخر',
          contentType: LearningContentType.sourceText,
          content: 'شرع الإسلام ميزاناً عادلاً يضمن كرامة واستقرار الطرفين؛ فللزوجة حقوق مالية واجبة تشمل النفقة بالطعام والكسوة والسكنى بالمعروف بحسب سعة الزوج، وحقوقاً غير مالية كالعدل بين الزوجات في التعدد، وحسن الصحبة والمعاشرة، وصيانة خصوصيتها.',
          evidenceLinks: [evRightsQuran, evRightsHadith],
          sourceAttribution: 'تفسير ابن كثير',
        ),
        LessonSection.create(
          sectionId: 'sec_fam2_2',
          title: 'حقوق الزوج والقوامة ومفهومها الرعائي',
          contentType: LearningContentType.explanation,
          content: 'قوامة الرجل في الأسرة قوامة رعاية ومسؤولية وإشراف وتضحية وليست استبداداً ولا قهراً، ويلزم فيها التشاور والتراحم. ومن حقوق الزوج: طاعته بالمعروف فيما لا معصية فيه لله، وحفظ غيبته في ماله وعرضه، والإذن في دخول بيته.',
          sourceAttribution: 'إحياء علوم الدين للغزالي',
        ),
        LessonSection.create(
          sectionId: 'sec_fam2_3',
          title: 'منهج القرآن في احتواء النشوز وتسوية الخلافات الأسرية',
          contentType: LearningContentType.explanation,
          content: 'رسم القرآن الكريم خطوات متدرجة لحل النزاعات الزوجية تبدأ بالموعظة الحسنة الرقيقة بالحوار وتذكير الطرفين بعهد الله، ثم الهجر في الفراش داخل البيت دون مقاطعة كلامية منفرة، ثم التدخل الأسري الحكيم ببعث حكم من أهله وحكم من أهلها لتحقيق الصلح والإصلاح.',
          sourceAttribution: 'زاد المعاد لابن القيم',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: فقه الفرقة والطلاق والخلع والعدة والحضانة
    // -------------------------------------------------------------------------
    final evTalaqQuran = EvidenceLink.create(
      evidenceId: 'ev_family_talaq_quran_marratan',
      evidenceKey: '2:229',
      citation: 'سورة البقرة: الآية 229 {الطَّلَاقُ مَرَّتَانِ ۖ فَإِمْسَاكٌ بِمَعْرُوفٍ أَوْ تَسْرِيحٌ بِإِحْسَانٍ}',
      sourceId: 'src_quran_canonical',
    );
    final evIddahQuran = EvidenceLink.create(
      evidenceId: 'ev_family_iddah_quran_talaq',
      evidenceKey: '65:1',
      citation: 'سورة الطلاق: الآية 1 {يَا أَيُّهَا النَّبِيُّ إِذَا طَلَّقْتُمُ النِّسَاءَ فَطَلِّقُوهُنَّ لِعِدَّتِهِنَّ وَأَحْصُوا الْعِدَّةَ}',
      sourceId: 'src_quran_canonical',
    );

    final l3 = Lesson.create(
      lessonId: 'lsn_family_divorce_iddah_custody',
      title: 'فقه الفرقة والطلاق السني والبدعي والخلع وأحكام العدة والحضانة',
      courseId: courseId,
      moduleId: 'mod_family_marriage_divorce',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_fam3_1',
          title: 'أنواع الطلاق السني والبدعي والرجعي والبائن',
          description: 'التمييز الدقيق بين الطلاق السني المشروع والطلاق البدعي المحرم وأحكام الطلاق الرجعي والبائن.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam3_2',
          title: 'أحكام الخلع والفسخ القضائي',
          description: 'معرفة أحكام الخلع والفسخ القضائي للضرر وحقوق الزوجين عند الفرقة.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam3_3',
          title: 'مدد العدة وضوابط الحضانة',
          description: 'استيعاب مدد العدة للمطلقة والمتوفى عنها زوجها وضوابط الحضانة ومصلحة المحضون.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_fam3_1',
          title: 'أحكام الطلاق وأقسامه بين السني والبدعي والرجعي والبائن',
          contentType: LearningContentType.sourceText,
          content: 'الطلاق أبغض الحلال ولا يلجأ إليه إلا عند تعذر الإصلاح. والطلاق السني هو أن يطلق الزوج زوجته طلقة واحدة في طهر لم يجامعها فيه ويتركها حتى تنقضي عدتها. أما البدعي فهو التطليق في الحيض أو في طهر جامعها فيه أو بالثلاث دفعة واحدة وهو محرم شرعاً. والطلاق الرجعي يتيح للزوج مراجعة زوجته في العدة دون عقد جديد، أما البائن بينونة صغرى فيتطلب عقداً ومهر جديدين، والبائن كبرى يحرمها عليه حتى تنكح زوجاً غيره.',
          evidenceLinks: [evTalaqQuran, evIddahQuran],
          sourceAttribution: 'المغني لابن قدامة',
        ),
        LessonSection.create(
          sectionId: 'sec_fam3_2',
          title: 'الخلع والفسخ القضائي وأسبابهما الشرعية',
          contentType: LearningContentType.explanation,
          content: 'الخلع هو فراق الزوجة لزوجها ببذل عوض مالي تقدمه للزوج إذا خشيت ألا تقيم حدود الله لعدم رغبتها فيه. أما الفسخ القضائي فيقع بحكم القاضي لعلل موجبة كالعيب المانع من المعاشرة، أو الإعسار بالنفقة، أو غيبة الزوج وانقطاع أخباره، أو ثبوت الضرر الجسيم.',
          sourceAttribution: 'الفقه المقارن وقوانين الأحوال الشخصية',
        ),
        LessonSection.create(
          sectionId: 'sec_fam3_3',
          title: 'مقاصد العدة ومددها وأحكام الحضانة والرعاية',
          contentType: LearningContentType.explanation,
          content: 'تجب العدة لحفظ الأنساب ورعاية حق الزوج؛ فذات الأقراء عدتها ثلاثة قروء، والآيسة والصغيرة ثلاثة أشهر، والحامل بوضع حملها، والمتوفى عنها زوجها أربعة أشهر وعشراً. والحضانة حفظ الصغير ورعايته وتربيته وتقديم مصلحته الفضلى، والأم أولى الناس بحضانة ولدها ما لم تنكح أجنبياً أو يوجد مانع يسقط أهليتها.',
          sourceAttribution: 'نيل الأوطار للشوكاني',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: علم الفرائض وأركان الإرث وموانعه والحقوق المتعلقة بالتركة
    // -------------------------------------------------------------------------
    final evFaraidQuran = EvidenceLink.create(
      evidenceId: 'ev_family_faraid_quran_nisaa_11',
      evidenceKey: '4:11',
      citation: 'سورة النساء: الآية 11 {يُوصِيكُمُ اللَّهُ فِي أَوْلَادِكُمْ ۖ لِلذَّكَرِ مِثْلُ حَظِّ الْأُنثَيَيْنِ}',
      sourceId: 'src_quran_canonical',
    );
    final evFaraidHadith = EvidenceLink.create(
      evidenceId: 'ev_family_faraid_hadith_ilqoo',
      evidenceKey: 'bukhari:6732',
      citation: 'صحيح البخاري: «أَلْحِقُوا الفَرَائِضَ بِأَهْلِهَا، فَمَا بَقِيَ فَهْوَ لِأَوْلَى رَجُلٍ ذَكَرٍ»',
      sourceId: 'src_hadith_canonical',
    );

    final l4 = Lesson.create(
      lessonId: 'lsn_family_faraid_principles',
      title: 'مدخل إلى علم الفرائض: أركان الإرث، أسبابه، موانعه، وتصفية التركة',
      courseId: courseId,
      moduleId: 'mod_family_inheritance_faraid',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_fam4_1',
          title: 'فلسفة التوزيع العادل في المواريث',
          description: 'إدراك عظمة التشريع الإسلامي في توزيع التركات وعدالة النظام المالي الإسلامي.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam4_2',
          title: 'ترتيب الحقوق المتعلقة بالتركة',
          description: 'ترتيب الحقوق المتعلقة بالتركة الخمسة قبل توزيع الأنصبة على الورثة.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam4_3',
          title: 'أركان الإرث وشروطه وأسبابه وموانعه',
          description: 'معرفة أسباب الإرث الثلاثة وموانعه الثلاثة (الرق، القتل، واختلاف الدين).',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_fam4_1',
          title: 'مكانة علم الفرائض وفلسفة التوزيع العادل في الإسلام',
          contentType: LearningContentType.sourceText,
          content: 'تولى الله سبحانه بنفسه تفصيل أنصبة المواريث في كتابه المحكم ولم يكلها لملك مقرب ولا نبي مرسل درءاً للنزاع وحفظاً للأواصر الأسرية وتفتيتاً للثروة ومنعاً لتركيزها في يد فئة واحدة، وضماناً لكفالة الأجيال.',
          evidenceLinks: [evFaraidQuran, evFaraidHadith],
          sourceAttribution: 'الرحبية وشروحها في علم الفرائض',
        ),
        LessonSection.create(
          sectionId: 'sec_fam4_2',
          title: 'ترتيب الحقوق الخمسة المتعلقة بالتركة',
          contentType: LearningContentType.explanation,
          content: 'قبل توزيع أي نصيب على الورثة، يتم التعامل مع تركة المتوفى وفق الترتيب الإلزامي الآتي: أولاً: مؤن تجهيز الميت ودفنه بالمعروف دون إسراف، ثانياً: الديون المتعلقة بعين التركة كالرهن، ثالثاً: الديون المطلقة في ذمة الميت (لله كالزكاة والنذور وللعباد كالقروض)، رابعاً: الوصية لغير وارث في حدود ثلث ما تبقى، خامساً: توزيع الباقي على الورثة الشرعيين.',
          sourceAttribution: 'بداية المجتهد وكتاب الفرائض',
        ),
        LessonSection.create(
          sectionId: 'sec_fam4_3',
          title: 'أركان الإرث وشروطه وأسبابه وموانعه الشرعية',
          contentType: LearningContentType.explanation,
          content: 'أركان الإرث ثلاثة: مُورِّث (الميت)، ووارث (الحي بعده)، وتَرِكَة. وشروطه: تحقق موت المورِّث، وتحقق حياة الوارث، والعلم بجهة الإرث. وأسباب الإرث المتفق عليها ثلاثة: النكاح الصحيح، والنسب والقرابة، والولاء. وموانع الإرث ثلاثة: (رقٌّ وقتلٌ واختلافُ دينِ)؛ فلا يرث القاتل من تركة مقتوله عمداً لقوله ﷺ «ليس للقاتل من الميراث شيء»، ولا توارث بين مسلم وكافر.',
          sourceAttribution: 'متن الرحبية وحاشية البقري',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: أصحاب الفروض المقدرة والعصبات والحجب
    // -------------------------------------------------------------------------
    final evSharesQuran = EvidenceLink.create(
      evidenceId: 'ev_family_shares_quran_kalalah',
      evidenceKey: '4:176',
      citation: 'سورة النساء: الآية 176 {يَسْتَفْتُونَكَ قُلِ اللَّهُ يُفْتِيكُمْ فِي الْكَلَالَةِ}',
      sourceId: 'src_quran_canonical',
    );
    final evAsabahHadith = EvidenceLink.create(
      evidenceId: 'ev_family_asabah_hadith_aqrab',
      evidenceKey: 'muslim:1615',
      citation: 'صحيح مسلم: «اقْسِمُوا المَالَ بَيْنَ أَهْلِ الفَرَائِضِ عَلَى كِتَابِ اللهِ»',
      sourceId: 'src_hadith_canonical',
    );

    final l5 = Lesson.create(
      lessonId: 'lsn_family_heirs_shares_asabah',
      title: 'أصحاب الفروض المقدرة وأحكام العصبات وقواعد الحجب الشرعي',
      courseId: courseId,
      moduleId: 'mod_family_inheritance_faraid',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_fam5_1',
          title: 'الفروض المقدرة الستة ومستحقوها',
          description: 'حفظ وفهم الفروض المقدرة الستة في كتاب الله (النصف، الربع، الثمن، الثلثان، الثلث، السدس) ومستحقي كل منها.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam5_2',
          title: 'أقسام العصبات وأحكامها',
          description: 'التمييز بين العصبة بالنفس والعصبة بالغير والعصبة مع الغير وأحكام استحقاق ما تبقى من التركة.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam5_3',
          title: 'قواعد الحجب بنوعيه',
          description: 'إتقان قواعد الحجب والتمييز بين حجب الوصف وحجب الحرمان وحجب النقصان.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_fam5_1',
          title: 'الفروض الستة المقدرة في القرآن وأصحابها',
          contentType: LearningContentType.sourceText,
          content: 'الفروض المقدرة نوعان: النصف وفروعه (النصف، الربع، الثمن)، والثلثان وفروعهما (الثلثان، الثلث، السدس). فالنصف لخمسة (الزوج عند عدم الفرع الوارث، والبنت، وبنت الابن، والأخت الشقيقة، والأخت لأب). والربع للزوج مع الفرع، وللزوجة عند عدمه. والثمن للزوجة مع الفرع. والثلثان لأربع (البنتان فأكثر، بنتا الابن، الشقيقتان، والأختان لأب). والثلث للأم عند عدم الفرع والجمع من الإخوة، وللإخوة لأم. والسدس لسبعة (الأب، الجد، الأم، الجدة، بنت الابن مع البنت، الأخت لأب مع الشقيقة، والواحد من ولد الأم).',
          evidenceLinks: [evSharesQuran, evAsabahHadith],
          sourceAttribution: 'المعاملات والفرائض في الشريعة الإسلامية',
        ),
        LessonSection.create(
          sectionId: 'sec_fam5_2',
          title: 'أنواع العصبات وأحكام حيازة المال أو الباقي',
          contentType: LearningContentType.explanation,
          content: 'العاصب هو من يأخذ جميع المال إذا انفرد، أو يأخذ ما بقي بعد أصحاب الفروض. والعصبة ثلاثة أنواع: 1- عصبة بالنفس: وهم ذكور النسب عدا ولد الأم (الابن وابنه، الأب والجد، الإخوة وبنوهم، الأعمام وبنوهم). 2- عصبة بالغير: وهن الإناث صاحبات النصف والثلثين إذا وجد معهن أخوهن المساوي لهن. 3- عصبة مع الغير: وهن الأخوات الشقيقات أو لأب مع البنات أو بنات الابن.',
          sourceAttribution: 'حاشية ابن عابدين والرحبية',
        ),
        LessonSection.create(
          sectionId: 'sec_fam5_3',
          title: 'قواعد الحجب وأثره في توزيع المواريث',
          contentType: LearningContentType.explanation,
          content: 'الحجب نوعان: حجب بالأوصاف وهو سقوط الإرث بالكلية لوجود مانع كالقتل، وحجب بالأشخاص وهو نوعان: حجب نقصان وهو نقل الوارث من فرض أعلى لأدنى أو من عصوبة لفرض، وحجب حرمان وهو إسقاط الوارث بوجود وارث أقرب كحجب الجد بالأب. وستة لا يحجبون حجب حرمان أبداً: الأب، الأم، الابن، البنت، الزوج، والزوجة.',
          sourceAttribution: 'شرح الرحبية لسبط المارديني',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: أحكام الوصية والعول والرد وقسمة التركات
    // -------------------------------------------------------------------------
    final evWasiyyahQuran = EvidenceLink.create(
      evidenceId: 'ev_family_wasiyyah_quran_baadi',
      evidenceKey: '4:12',
      citation: 'سورة النساء: الآية 12 {مِن بَعْدِ وَصِيَّةٍ يُوصَىٰ بِهَا أَوْ دَيْنٍ غَيْرَ مُضَارٍّ}',
      sourceId: 'src_quran_canonical',
    );
    final evWasiyyahHadith = EvidenceLink.create(
      evidenceId: 'ev_family_wasiyyah_hadith_thuluth',
      evidenceKey: 'bukhari:2742',
      citation: 'صحيح البخاري: «الثُّلُثُ وَالثُّلُثُ كَثِيرٌ، إِنَّكَ أَنْ تَذَرَ وَرَثَتَكَ أَغْنِيَاءَ خَيْرٌ مِنْ أَنْ تَذَرَهُمْ عَالَةً»',
      sourceId: 'src_hadith_canonical',
    );

    final l6 = Lesson.create(
      lessonId: 'lsn_family_wills_distribution',
      title: 'أحكام الوصية الشرعية، مسائل العول والرد، وضوابط قسمة التركات',
      courseId: courseId,
      moduleId: 'mod_family_inheritance_faraid',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_fam6_1',
          title: 'أحكام الوصية الشرعية وسقفها',
          description: 'استيعاب ضوابط الوصية الشرعية وسقفها الأقصى (الثلث) وقاعدة «لا وصية لوارث».',
        ),
        LearningObjective(
          objectiveId: 'obj_fam6_2',
          title: 'مسائل العول والرد',
          description: 'معرفة مفهوم العول عند تزاحم الفروض وزيادتها عن أصل المسألة، ومفهوم الرد عند بقاء فائض.',
        ),
        LearningObjective(
          objectiveId: 'obj_fam6_3',
          title: 'قسمة التركات المعاصرة والمناسخات',
          description: 'التعرف على خطوات تصفية التركة المعاصرة وحل المناسخات وتوزيع الحقوق بالتراضي أو القضاء.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_fam6_1',
          title: 'الوصية الشرعية وأركانها وضوابط صحتها',
          contentType: LearningContentType.sourceText,
          content: 'الوصية تبرع مضاف لما بعد الموت؛ وهي مشروعة في وجوه الخير والبر وصلة غير الوارثين من الأقارب. ولها ضابطان قطعيان: الأول: ألا تزيد عن ثلث التركة بعد سداد الديون، لحديث «الثلث والثلث كثير»، الثاني: ألا تكون لوارث، لقول النبي ﷺ «إن الله قد أعطى كل ذي حق حقه فلا وصية لوارث» إلا أن يجيزها بقية الورثة الراشدين برضاهم.',
          evidenceLinks: [evWasiyyahQuran, evWasiyyahHadith],
          sourceAttribution: 'المغني لابن قدامة',
        ),
        LessonSection.create(
          sectionId: 'sec_fam6_2',
          title: 'مسائل العول والرد والتصحيح الحسابي',
          contentType: LearningContentType.explanation,
          content: 'العول هو زيادة في مجموع سهام الفروض المقدرة عن أصل المسألة، فيدخل النقص على جميع أصحاب الفروض بنسبة حصصهم بالعدل (وأول من قضى به في الإسلام أمير المؤمنين عمر بن الخطاب رضي الله عنه بمشورة الصحابة). أما الرد فهو عكس العول؛ فإذا استغرق أصحاب الفروض حصصهم وبقي فائض ولم يوجد عاصب، يُرد الباقي على أصحاب الفروض بنسبة فروضهم عدا الزوجين عند الجمهور.',
          sourceAttribution: 'الفرائض للشيخ ابن عثيمين',
        ),
        LessonSection.create(
          sectionId: 'sec_fam6_3',
          title: 'التصفية العملية للتركات المعاصرة والمناسخات',
          contentType: LearningContentType.explanation,
          content: 'يشمل واقع قسمة التركات المعاصرة العقارات، الأسهم والشركات، والأموال السائلة ومستحقات التقاعد ونهاية الخدمة؛ فيجب حصر الورثة رسمياً وشرعياً وسداد ديون المتوفى قبل التصرف، ومراعاة موت بعض الورثة قبل القسمة وهو ما يعرف بالمناسخات، وتجنب تعطيل التركات والإضرار بالضعفاء واليتامى.',
          sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: فقه النكاح والفرقة
    final q1 = QuizQuestion.create(
      questionId: 'q_fam_1',
      lessonId: 'lsn_family_marriage_pillars',
      questionText: 'ما هو حكم عقد النكاح الذي تم دون حضور ولي المرأة ورضاه لغير الثيب المعضولة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qf1_1', text: 'باطل وغير صحيح عند جمهور فقهاء المسلمين لقوله ﷺ «لا نكاح إلا بولي»'),
        QuizOption(optionId: 'opt_qf1_2', text: 'صحيح مطلقاً ولا تشترط الولاية في أي حال'),
        QuizOption(optionId: 'opt_qf1_3', text: 'مكروه فقط وينعقد بمجرد دفع المهر'),
      ],
      correctOptionIndices: const [0],
      explanation: 'جمهور الفقهاء على اشتراط الولي لصحة عقد النكاح استناداً لحديث رسول الله ﷺ «لا نكاح إلا بولي وشاهدي عدل».',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_family_marriage_divorce',
      lessonId: 'lsn_family_marriage_pillars',
      title: 'اختبار فقه النكاح والفرقة وحقوق الزوجين',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: علم الفرائض والمواريث
    final q2 = QuizQuestion.create(
      questionId: 'q_fam_2',
      lessonId: 'lsn_family_heirs_shares_asabah',
      questionText: 'توفي رجل وترك: زوجة، وابناً، وأباً. كم تستحق الزوجة في هذه المسألة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qf2_1', text: 'الثُّمن لوجود الفرع الوارث (الابن) لقوله تعالى ﴿فَإِن كَانَ لَكُمْ وَلَدٌ فَلَهُنَّ الثُّمُنُ﴾'),
        QuizOption(optionId: 'opt_qf2_2', text: 'الرُّبع لعدم وجود بنات معه'),
        QuizOption(optionId: 'opt_qf2_3', text: 'النصف كفرض مقدر أساسي'),
      ],
      correctOptionIndices: const [0],
      explanation: 'تستحق الزوجة الثمن عند وجود الفرع الوارث (ذكراً كان أو أنثى) لقوله تعالى: ﴿فَإِن كَانَ لَكُمْ وَلَدٌ فَلَهُنَّ الثُّمُنُ مِمَّا تَرَكْتُم﴾.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_family_inheritance_faraid',
      lessonId: 'lsn_family_heirs_shares_asabah',
      title: 'اختبار علم الفرائض والمواريث والوصايا',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
