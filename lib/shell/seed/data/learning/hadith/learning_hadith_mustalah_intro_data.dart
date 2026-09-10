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

/// بيانات مقرر مبادئ علم مصطلح الحديث وتاريخ التدوين والكتب الستة (7 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningHadithMustalahIntroData {
  static const String courseId = 'course_hadith_mustalah_intro';
  static const String pathId = 'path_hadith_sciences_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر مبادئ علم مصطلح الحديث وتاريخ التدوين والكتب الستة',
      description: 'دراسة تأصيلية تاريخية منهجية في حجية السنة النبوية، ومبادئ ومصطلحات علم الحديث، ومراحل التدوين وحفظ الأحاديث، والتعريف بأمهات كتب السنة وتقسيم الأخبار إلى متواتر وآحاد.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_hadith_intro_history', 'mod_hadith_tawatur_ahad'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_hadith_intro_history',
        courseId: courseId,
        title: 'الوحدة الأولى: حجية السنة وتاريخ التدوين وأمهات الكتب',
        description: 'بيان حجية السنة النبوية المطهرة ومنزلتها في التشريع الإسلامي، والتعريف بالسند والمتن، ومراحل كتابة وتدوين الحديث عبر القرون، ومناهج أصحاب الكتب الستة والمسانيد.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_hadith_hujjiyyah_sunnah',
          'lsn_hadith_terms_sanad_matn',
          'lsn_hadith_history_tadween',
          'lsn_hadith_kutub_sittah_masanid',
        ],
      ),
      CourseModule(
        moduleId: 'mod_hadith_tawatur_ahad',
        courseId: courseId,
        title: 'الوحدة الثانية: تقسيم الحديث باعتبار طرقه (المتواتر والآحاد)',
        description: 'دراسة تقسيم الأخبار إلى متواتر لفظي ومعنوي وشروطه وإفادته للعلم القطعي، وتقسيم الآحاد إلى مشهور وعزيز وغريب، ومذاهب أئمة السنة في الاحتجاج بها.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_hadith_intro_history'],
        lessonIds: const [
          'lsn_hadith_mutawatir_types',
          'lsn_hadith_ahad_divisions',
          'lsn_hadith_ghareeb_fard',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: حجية السنة النبوية ومكانتها في التشريع
    // -------------------------------------------------------------------------
    final evSunnahAyah = EvidenceLink.create(
      evidenceId: 'ev_hd_sunnah_ayah',
      evidenceKey: '59:7',
      citation: 'سورة الحشر: الآية 7',
      sourceId: 'src_quran_canonical',
    );
    final evSunnahHadith = EvidenceLink.create(
      evidenceId: 'ev_hd_sunnah_bayan',
      evidenceKey: 'abudawood:4604',
      citation: 'سنن أبي داود: حديث 4604',
      sourceId: 'src_hadith_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_hadith_hujjiyyah_sunnah',
      title: 'حجية السنة النبوية ومنزلتها في التشريع ورد الشبهات',
      courseId: courseId,
      moduleId: 'mod_hadith_intro_history',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd1_1',
          title: 'مكانة السنة النبوية',
          description: 'إدراك مكانة السنة النبوية باعتبارها الوحي الثاني والمبين للقرآن العظيم.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd1_2',
          title: 'أوجه بيان السنة للقرآن',
          description: 'معرفة أوجه بيان السنة لكتاب الله تعالى وحجيتها واستقلالها بالتشريع.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd1_3',
          title: 'دحض شبهات منكري السنة',
          description: 'الرد المنهجي على دعاوى القرآنيين ومنكري حجية السنة النبوية المطهرة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd1_1',
          title: 'الأدلة القرآنية والنبوية على حجية السنة النبوية',
          contentType: LearningContentType.sourceText,
          content: 'قال الله تعالى: {وَمَا آتَاكُمُ الرَّسُولُ فَخُذُوهُ وَمَا نَهَاكُمْ عَنْهُ فَانتَهُوا}، وقال تعالى: {وَأَنزَلْنَا إِلَيْكَ الذِّكْرَ لِتُبَيِّنَ لِلنَّاسِ مَا نُزِّلَ إِلَيْهِمْ}. وعن المقدام بن معدي كرب رضي الله عنه أن رسول الله ﷺ قال: «أَلَا إِنِّي أُوتِيتُ الْكِتَابَ وَمِثْلَهُ مَعَهُ».',
          evidenceLinks: [evSunnahAyah, evSunnahHadith],
          sourceAttribution: 'سورة الحشر وسنن أبي داود',
        ),
        LessonSection.create(
          sectionId: 'sec_hd1_2',
          title: 'البيان الشرعي لوظائف السنة النبوية مع القرآن الكريم',
          contentType: LearningContentType.explanation,
          content: 'تأتي السنة النبوية مع القرآن على ثلاثة أوجه متفق عليها عند الأئمة:\n1. مؤكدة وموافقة لما جاء في القرآن من أصول العبادات والواجبات والمحرمات.\n2. مبينة ومفصلة لمجمل القرآن ومخصصة لعامه ومقيدة لمطلقه.\n3. موجبة لأحكام سكت عنها القرآن ومؤسسة لحكم جديد لم يرد فيه نص صريح كتحريم الحمر الأهلية.',
          sourceAttribution: 'الرسالة للإمام الشافعي',
        ),
        LessonSection.create(
          sectionId: 'sec_hd1_3',
          title: 'إجماع السلف والرد العلمي على منكري السنة',
          contentType: LearningContentType.scholarlyView,
          content: 'أجمع علماء الأمة سلفاً وخلفاً على كفر من أنكر حجية السنة النبوية بالكلية؛ إذ إنكار السنة يستلزم هدم أركان الإسلام العملية التي لا يمكن معرفتها ولا إقامتها إلا عبر السنة والبيان النبوي التطبيقي المتواتر.',
          sourceAttribution: 'مفتاح الجنة في الاعتصام بالسنة للسيوطي',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 2: المصطلحات الأساسية: الحديث والأثر والسند والمتن
    // -------------------------------------------------------------------------
    final l2 = Lesson.create(
      lessonId: 'lsn_hadith_terms_sanad_matn',
      title: 'المصطلحات الأساسية لعلوم الحديث: الحديث والأثر والسند والمتن والطبقات',
      courseId: courseId,
      moduleId: 'mod_hadith_intro_history',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd2_1',
          title: 'التمييز بين مصطلحات الحديث والخبر والأثر',
          description: 'التمييز بين مصطلحات الحديث والخبر والأثر لغة واصطلاحاً.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd2_2',
          title: 'حقيقة السند والمتن',
          description: 'فهم حقيقة السند والإسناد والمتن ومنزلتها في حفظ الدين الإسلامي.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd2_3',
          title: 'مفهوم طبقات الرواة',
          description: 'معرفة مفهوم الطبقة عند المحدثين وأثرها في معرفة الانقطاع والاتصال.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd2_1',
          title: 'التعريفات الاصطلاحية لأركان الرواية',
          contentType: LearningContentType.explanation,
          content: '1. الحديث: ما أضيف إلى النبي ﷺ من قول أو فعل أو تقرير أو صفة خَلقية أو خُلقية.\n2. الخبر: ما أضيف إلى النبي ﷺ أو إلى غيره.\n3. الأثر: ما أضيف إلى الصحابي أو التابعي من أقوال أو أفعال موقوفة.\n4. السند: سلسلة الرجال الموصلة إلى المتن.\n5. المتن: ما ينتهي إليه السند من الكلام النبوي أو الأثري.',
          sourceAttribution: 'نخبة الفكر لابن حجر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd2_2',
          title: 'أهمية الإسناد ومقولات أئمة السلف الخالدة',
          contentType: LearningContentType.scholarlyView,
          content: 'قال الإمام عبد الله بن المبارك رحمه الله: «الإسناد من الدين، ولولا الإسناد لقال من شاء ما شاء». وقال سفيان الثوري: «الإسناد سلاح المؤمن». والإسناد خصيصة كبرى تفردت بها الأمة الإسلامية لحفظ نصوص دينها من التحريف والزيادة والنقصان.',
          sourceAttribution: 'مقدمة صحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_hd2_3',
          title: 'مفهوم طبقات الرواة وأهميتها النقدية',
          contentType: LearningContentType.example,
          content: 'الطبقة في اصطلاح المحدثين: قوم تقاربوا في السن والإسناد أو في الشيوخ، كطبقة كبار الصحابة، وطبقة صغار الصحابة، وكبار التابعين، وأتباع التابعين؛ وتفيد معرفة الطبقات في كشف تدليس الرواة وسقط الأسانيد والانقطاع الخفي.',
          sourceAttribution: 'تدريب الراوي للسيوطي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 3: تاريخ تدوين السنة ومراحله
    // -------------------------------------------------------------------------
    final l3 = Lesson.create(
      lessonId: 'lsn_hadith_history_tadween',
      title: 'تاريخ تدوين السنة النبوية من العهد النبوي إلى عصر التصنيف',
      courseId: courseId,
      moduleId: 'mod_hadith_intro_history',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd3_1',
          title: 'الكتابة في العهد النبوي',
          description: 'الجمع بين أحاديث النهي عن الكتابة وأحاديث الإذن بها في العهد النبوي.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd3_2',
          title: 'الصحف المكتوبة في عصر الصحابة',
          description: 'استيعاب جهود الصحابة في الحفظ والصحف الفردية المكتوبة.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd3_3',
          title: 'التدوين الرسمي في عهد عمر بن عبد العزيز',
          description: 'تتبع حركة التدوين الرسمي في عهد عمر بن عبد العزيز والإمام الزهري.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd3_1',
          title: 'الكتابة في العصر النبوي والجمع بين أحاديث النهي والإذن',
          contentType: LearningContentType.explanation,
          content: 'نهى النبي ﷺ في بداية نزول الوحي عن كتابة غير القرآن مخافة أن يختلط به كلام النبي ﷺ: «لا تكتبوا عني، ومن كتب عني غير القرآن فليمحه»، فلما استقر القرآن أذن النبي ﷺ بالكتابة، فقال لعبد الله بن عمرو: «اكتب، فوالذي نفسي بيده ما يخرج منه إلا حق»، وكانت عنده "الصحيفة الصادقة".',
          sourceAttribution: 'سنن أبي داود ومسند أحمد',
        ),
        LessonSection.create(
          sectionId: 'sec_hd3_2',
          title: 'مرحلة التدوين الرسمي الشامل في القرن الثاني الهجري',
          contentType: LearningContentType.scholarlyView,
          content: 'مع اتساع رقعة الدولة وتفرق الحفاظ وموت الصحابة، أمر الخليفة الراشد العادل عمر بن عبد العزيز رضي الله عنه الإمام محمد بن مسلم بن شهاب الزهري رحمه الله بجمع السنة وتدوينها رسمياً، فكان الزهري أول من دون الحديث النبوي بأمر الدولة حفظاً للدين.',
          sourceAttribution: 'جامع بيان العلم وفضله لابن عبد البر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd3_3',
          title: 'مراحل التدوين المنهجي عبر العصور',
          contentType: LearningContentType.summary,
          content: 'مر تدوين السنة بأربع مراحل تاريخية رئيسية:\n1. التدوين الفردي والصحف المكتوبة في عصر الصحابة وكبار التابعين.\n2. التدوين الرسمي العام في عهد عمر بن عبد العزيز (أوائل القرن الثاني).\n3. التصنيف المبوب الممزوج بأقوال الصحابة وفتاوى التابعين (كموطأ مالك ومصنف عبد الرزاق).\n4. تجريد أحاديث النبي ﷺ وإفرادها بالصحة والتبويب الفقهي الدقيق (القرن الثالث الهجري: عصر الصحاح والسنن).',
          sourceAttribution: 'قواعد التحديث للقاسمي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 4: الكتب الستة والمسانيد والمصنفات
    // -------------------------------------------------------------------------
    final l4 = Lesson.create(
      lessonId: 'lsn_hadith_kutub_sittah_masanid',
      title: 'أمهات كتب السنة ومناهج أصحابها: الكتب الستة والمسانيد والمصنفات',
      courseId: courseId,
      moduleId: 'mod_hadith_intro_history',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd4_1',
          title: 'التعريف بالكتب الستة',
          description: 'التعريف بالكتب الستة وأصحابها ومنزلتها العلمية لدى المسلمين.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd4_2',
          title: 'التمييز بين مناهج التأليف الحديثي',
          description: 'التمييز بين مناهج الجوامع والسنن والمسانيد والمعاجم والمصنفات.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd4_3',
          title: 'منهج الصحيحين للبخاري ومسلم',
          description: 'معرفة الفارق الدقيق بين منهجي البخاري ومسلم في الصنعة الحديثية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd4_1',
          title: 'الصحيحان ومنهج الإمامين البخاري ومسلم',
          contentType: LearningContentType.explanation,
          content: 'الجامع الصحيح للإمام البخاري وصحيح الإمام مسلم هما أصح كتابين بعد كتاب الله بإجماع الأمة؛ تميز البخاري بدقة التبويب الفقهي وعلو شروط اللقاء وثبوت السماع، بينما تميز مسلم بجمع طرق الحديث في مكان واحد وحسن السياق والترتيب ودقة الصياغة.',
          sourceAttribution: 'مقدمة ابن الصلاح وشرح النووي على مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_hd4_2',
          title: 'السنن الأربعة والكتب الستة المعتمدة',
          contentType: LearningContentType.scholarlyView,
          content: 'السنن الأربعة هي: سنن أبي داود السجستاني، وجامع أبي عيسى الترمذي، والسنن الصغرى للنسائي، وسنن ابن ماجه؛ وتعتني السنن بجمع أحاديث الأحكام المرفوعة المعتمدة عند الفقهاء، وتتضمن الصحيح والحسن والضعيف المحتمل مع بيان علته غالباً.',
          sourceAttribution: 'سير أعلام النبلاء للذهبي',
        ),
        LessonSection.create(
          sectionId: 'sec_hd4_3',
          title: 'أنواع المصنفات الحديثية الأخرى والفارق بينها',
          contentType: LearningContentType.summary,
          content: '1. الجوامع: تجمع جميع أبواب الدين (عقائد، أحكام، رقاق، فتن، تفسير).\n2. السنن: مرتبة على الأبواب الفقهية وتقتصر غالباً على أحاديث الأحكام المرفوعة.\n3. المسانيد: مرتبة بحسب أسماء الصحابة رواتها كمسند الإمام أحمد.\n4. المصنفات: كتب تجمع الحديث المرفوع مع آثار الصحابة وفتاوى التابعين كمصنف ابن أبي شيبة.\n5. المعاجم: مرتبة بحسب أسماء الشيوخ كمعاجم الطبراني الثلاثة.',
          sourceAttribution: 'فتح المغيث للسخاوي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 5: الحديث المتواتر: شروطه وأقسامه (اللفظي والمعنوي)
    // -------------------------------------------------------------------------
    final l5 = Lesson.create(
      lessonId: 'lsn_hadith_mutawatir_types',
      title: 'الحديث المتواتر: حقيقته وشروطه وأقسامه (اللفظي والمعنوي) وحجيته',
      courseId: courseId,
      moduleId: 'mod_hadith_tawatur_ahad',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd5_1',
          title: 'تعريف المتواتر وشروطه الأربعة',
          description: 'تعريف الحديث المتواتر وشروطه الأربعة التي تفيد العلم اليقيني الضروري.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd5_2',
          title: 'المتواتر اللفظي والمعنوي',
          description: 'التمييز بين المتواتر اللفظي والمتواتر المعنوي بالأمثلة التوضيحية.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd5_3',
          title: 'حجية المتواتر القطعية',
          description: 'إدراك حجية المتواتر القطعية واستلزامه للعلم اليقيني القطعي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd5_1',
          title: 'تعريف المتواتر وشروطه الأربعة اللازمة',
          contentType: LearningContentType.explanation,
          content: 'المتواتر لغة: المتتابع. واصطلاحاً: ما رواه جمع غفير تحيل العادة تواطؤهم على الكذب، عن مثلهم من ابتداء السند إلى منتهاه، وكان مستند انتهائهم الحس (مشاهدة أو سماع).\nوشروطه أربعة:\n1. كثرة عدد الرواة في كل طبقة.\n2. استحالة تواطؤهم على الكذب.\n3. استمرار هذا الجمع في جميع طبقات السند.\n4. أن يكون خبرهم صادراً عن الحس لا عن التخمين.',
          sourceAttribution: 'نزهة النظر في توضيح نخبة الفكر لابن حجر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd5_2',
          title: 'أقسام المتواتر: اللفظي والمعنوي',
          contentType: LearningContentType.example,
          content: '1. المتواتر اللفظي: ما تواتر لفظه ومعناه، ومثاله حديث: «من كذب عليَّ متعمداً فليتبوأ مقعده من النار» رواه أكثر من سبعين صحابياً.\n2. المتواتر المعنوي: ما تواتر معناه المشترك مع اختلاف ألفاظ الأحاديث ووقائعها، كمثال أحاديث رفع اليدين في الدعاء وأحاديث الشفاعة والحوض.',
          sourceAttribution: 'نظم المتناثر من الحديث المتواتر للكتاني',
        ),
        LessonSection.create(
          sectionId: 'sec_hd5_3',
          title: 'الحكم الشرعي والعقدي للمتواتر',
          contentType: LearningContentType.scholarlyView,
          content: 'يفيد المتواتر العلم النظري الضروري واليقين القطعي الذي يضطر الإنسان للتصديق به كالمشاهدات، وحكمه وجوب التصديق والعمل به قطعاً، وجاحد المتواتر المعلوم من الدين بالضرورة كافر خارج عن الملة بإجماع أئمة المسلمين.',
          sourceAttribution: 'مقدمة ابن الصلاح',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 6: حديث الآحاد: تعريفه وأقسامه وحجيته
    // -------------------------------------------------------------------------
    final l6 = Lesson.create(
      lessonId: 'lsn_hadith_ahad_divisions',
      title: 'حديث الآحاد: تعريفه وأقسامه الثلاثة (المشهور والعزيز والغريب) وحجيته',
      courseId: courseId,
      moduleId: 'mod_hadith_tawatur_ahad',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd6_1',
          title: 'أقسام خبر الآحاد الثلاثة',
          description: 'تعريف خبر الآحاد وأقسامه الثلاثة باعتبار عدد طرقه وأسانيده.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd6_2',
          title: 'المشهور والعزيز والغريب',
          description: 'بيان حقيقة المشهور والعزيز والغريب مع الأمثلة التطبيقية من السنة.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd6_3',
          title: 'حجية خبر الآحاد الصحيح',
          description: 'تقرير مذهب أهل السنة في حجية خبر الآحاد الصحيح في العقائد والأحكام.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd6_1',
          title: 'تعريف الآحاد وأقسامه الثلاثة',
          contentType: LearningContentType.explanation,
          content: 'خبر الآحاد: هو ما لم يجمع شروط المتواتر؛ وينقسم باعتبار عدد طرقه إلى ثلاثة أقسام:\n1. المشهور: ما رواه ثلاثة فأكثر في كل طبقة ما لم يبلغ حد التواتر.\n2. العزيز: ما لا يقل رواته عن اثنين في أي طبقة من طبقات السند.\n3. الغريب: ما تفرد بروايته شخص واحد في أي طبقة من طبقات الإسناد.',
          sourceAttribution: 'نزهة النظر لابن حجر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd6_2',
          title: 'أمثلة تطبيقية على أقسام الآحاد',
          contentType: LearningContentType.example,
          content: '1. مثال المشهور: حديث «المسلم من سلم المسلمون من لسانه ويده».\n2. مثال العزيز: حديث «لا يؤمن أحدكم حتى أكون أحب إليه من والده وولده والناس أجمعين» رواه عن أنس قتادة وعبد العزيز بن صهيب.\n3. مثال الغريب: حديث «إنما الأعمال بالنيات» تفرد به في طبقة الصحابة عمر بن الخطاب رضي الله عنه.',
          sourceAttribution: 'صحيح البخاري وصحيح مسلم',
        ),
        LessonSection.create(
          sectionId: 'sec_hd6_3',
          title: 'حجية خبر الآحاد في العقائد والأحكام عند أهل السنة',
          contentType: LearningContentType.scholarlyView,
          content: 'أجمع سلف الأمة وأئمة الفقه والحديث على وجوب العمل بخبر الآحاد إذا صح إسناده وتوفرت شروطه في الأحكام والعقائد على السواء، والقول بالتفريق بين العقائد والأحكام بدعة حادثة نشأت عند المتكلمين ولا سلف لها من الصحابة والتابعين والقرون المفضلة.',
          sourceAttribution: 'الرسالة للإمام الشافعي ومختصر الصواعق المرسلة',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 7: الغريب المطلق والغريب النسبي
    // -------------------------------------------------------------------------
    final l7 = Lesson.create(
      lessonId: 'lsn_hadith_ghareeb_fard',
      title: 'الغريب المطلق والغريب النسبي وأسباب التفرد في الرواية ومظانها',
      courseId: courseId,
      moduleId: 'mod_hadith_tawatur_ahad',
      orderIndex: 7,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd7_1',
          title: 'الغريب المطلق والنسبي',
          description: 'التمييز بين الغريب المطلق (الفرد المطلق) والغريب النسبي في الإسناد.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd7_2',
          title: 'ضوابط تفرد الثقة',
          description: 'معرفة ضوابط تفرد الثقة وحكم قبول تفرده عند نقاد الحديث.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd7_3',
          title: 'مظان كتب الأفراد والغرائب',
          description: 'التعرف على مظان كتب الغرائب والأفراد في المكتبة الحديثية التخصصية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd7_1',
          title: 'الفرق بين الغرابة المطلقة والغرابة النسبية',
          contentType: LearningContentType.explanation,
          content: '1. الغريب المطلق: ما كانت الغرابة والتفرد في أصل سنده (أي في طبقة الصحابي كحديث إنما الأعمال بالنيات).\n2. الغريب النسبي: ما حصل التفرد فيه أثناء السند كأن يرويه عن الصحابي جماعة ثم يتفرد راوٍ بروايته عن أحد أولئك الرواة، أو يتفرد به أهل بلد معين كقولهم: تفرد به أهل الشام.',
          sourceAttribution: 'مقدمة ابن الصلاح',
        ),
        LessonSection.create(
          sectionId: 'sec_hd7_2',
          title: 'حكم تفرد الراوي وضوابط قبوله عند المحدثين',
          contentType: LearningContentType.scholarlyView,
          content: 'ليس كل غريب ضعيفاً؛ فتفرد الثقة التام الضبط والعدالة مقبول إذا لم يخالف من هو أوثق منه أو الجمع الغفير، وأصح الأحاديث قد يكون غريباً كحديث النيات، أما إن كان المتفرد مستور الحال أو خفيف الضبط فإن تفرده يثير الريبة ويضعف الرواية.',
          sourceAttribution: 'ألفية العراقي في علوم الحديث',
        ),
        LessonSection.create(
          sectionId: 'sec_hd7_3',
          title: 'أشهر مصنفات الغرائب والأفراد',
          contentType: LearningContentType.summary,
          content: 'من أشهر الكتب التي اعتنت بجمع الأحاديث الغريبة وبيان عللها: "مسند البزار" (البحر الزخار)، و"المعجم الأوسط" و"المعجم الصغير" للإمام الطبراني، وكتاب "الأفراد والغرائب" للدارقطني.',
          sourceAttribution: 'كشف الظنون لحاجي خليفة',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6, l7];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: مصطلحات الحديث والإسناد
    final q1 = QuizQuestion.create(
      questionId: 'q_hdi_terms_1',
      lessonId: 'lsn_hadith_terms_sanad_matn',
      questionText: 'ما هو التعريف الدقيق لمصطلح "السند" في علم الحديث؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qhdt1_1', text: 'سلسلة الرجال والرواة الموصلة إلى المتن'),
        QuizOption(optionId: 'opt_qhdt1_2', text: 'نص الكلام الذي ينتهي إليه الكلام'),
        QuizOption(optionId: 'opt_qhdt1_3', text: 'القول الموقوف على الصحابي فقط'),
      ],
      correctOptionIndices: const [0],
      explanation: 'السند هو سلسلة الرواة والرجال الذين نقلوا الحديث واحداً عن الآخر حتى أوصلوه إلى المتن.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_hadith_intro_terms',
      lessonId: 'lsn_hadith_terms_sanad_matn',
      title: 'اختبار مصطلحات علم الحديث ومكانة الإسناد',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: الكتب الستة ومناهجها
    final q2 = QuizQuestion.create(
      questionId: 'q_hdi_kutub_1',
      lessonId: 'lsn_hadith_kutub_sittah_masanid',
      questionText: 'ما هو الترتيب والمصطلح العلمي لكتابي الصحيحين عند جماهير علماء الأمة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qhdk1_1', text: 'صحيح البخاري ثم صحيح مسلم وهما أصح كتابين بعد القرآن الكريم'),
        QuizOption(optionId: 'opt_qhdk1_2', text: 'سنن النسائي ثم صحيح البخاري'),
        QuizOption(optionId: 'opt_qhdk1_3', text: 'مسند الإمام أحمد يتقدم على الصحيحين إطلاقاً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أجمعت الأمة سلفاً وخلفاً على أن صحيح البخاري وصحيح مسلم هما أصح الكتب المصنفة في الحديث على الإطلاق، مع تقديم البخاري لصحة شروطه ودقة تبويبه.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_hadith_kutub_sittah',
      lessonId: 'lsn_hadith_kutub_sittah_masanid',
      title: 'اختبار مناهج أصحاب الكتب الستة والمصنفات',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: المتواتر والآحاد
    final q3 = QuizQuestion.create(
      questionId: 'q_hdi_tawatur_1',
      lessonId: 'lsn_hadith_ahad_divisions',
      questionText: 'ما هو حكم الاحتجاج بخبر الآحاد الصحيح في أصول العقائد وأحكام الشريعة عند أهل السنة والجماعة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qhdta1_1', text: 'واجب القبول والعمل به في العقائد والأحكام على السواء بلا تفريق'),
        QuizOption(optionId: 'opt_qhdta1_2', text: 'يقبل فقط في فروع الفقه ويرد في العقيدة مطلقاً'),
        QuizOption(optionId: 'opt_qhdta1_3', text: 'لا يفيد أي حكم شرعي إلا إذا صار متواتراً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'مذهب سلف الأمة وأئمتها هو وجوب التصديق والعمل بحديث الآحاد الصحيح في أمور الاعتقاد والأحكام الشرعية، دون تفريق مبتدع.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_hadith_tawatur_ahad',
      lessonId: 'lsn_hadith_ahad_divisions',
      title: 'اختبار الحديث المتواتر والآحاد وحجيتهما',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
