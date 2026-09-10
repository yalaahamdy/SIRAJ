import '../../../../modules/learning/domain/course.dart';
import '../../../../modules/learning/domain/course_module.dart';
import '../../../../modules/learning/domain/evidence_link.dart';
import '../../../../modules/learning/domain/learning_content_type.dart';
import '../../../../modules/learning/domain/learning_objective.dart';
import '../../../../modules/learning/domain/learning_path.dart' as lp;
import '../../../../modules/learning/domain/lesson.dart';
import '../../../../modules/learning/domain/lesson_section.dart';
import '../../../../modules/learning/domain/quiz.dart';
import '../../../../modules/learning/domain/quiz_question.dart';

/// بيانات مقرر فقه الطهارة والمياه والتطهير الموسع (9 دروس تأصيلية + اختبارات استيعاب)
class LearningTaharahData {
  static const String courseId = 'course_fiqh_taharah_adv';
  static const String pathId = 'path_fiqh_worship_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الطهارة والمياه وأحكام التطهير',
      description: 'دراسة فقهية تأصيلية شاملة لأقسام المياه، وإزالة النجاسات، وفقه الوضوء والغسل والمسح على الخفين والتيمم وأحكام الدماء الطبيعية.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_taharah_waters', 'mod_taharah_wudu_ghusl'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_taharah_waters',
        courseId: courseId,
        title: 'الوحدة الأولى: أحكام المياه وإزالة النجاسات وسنن الفطرة',
        description: 'بيان الطهارة الحدثية والخبثية وأقسام المياه وقواعد التطهير وسنن الفطرة المأثورة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_taharah_water_types',
          'lsn_taharah_impurities',
          'lsn_taharah_fitrah_toilet',
        ],
      ),
      CourseModule(
        moduleId: 'mod_taharah_wudu_ghusl',
        courseId: courseId,
        title: 'الوحدة الثانية: فقه الوضوء والغسل والبدائل الشرعية',
        description: 'الأحكام العملية المفصلة للوضوء ونواقضه، والمسح على الخفين والجبائر، والغسل والتيمم وأحكام الحيض والنفاس.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_taharah_waters'],
        lessonIds: const [
          'lsn_taharah_wudu_practice',
          'lsn_taharah_wudu_nullifiers',
          'lsn_taharah_khuffayn_splints',
          'lsn_taharah_ghusl',
          'lsn_taharah_tayammum',
          'lsn_taharah_female_blood',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: أقسام المياه وضوابط التغير
    // -------------------------------------------------------------------------
    final lsn1 = Lesson.create(
      lessonId: 'lsn_taharah_water_types',
      title: 'أقسام المياه وضوابط التغير والطهورية',
      courseId: courseId,
      moduleId: 'mod_taharah_waters',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t1_1',
          title: 'التمييز بين الماء الطهور والماء النجس',
          description: 'معرفة علامات التغير بالنجاسة وحكم الماء المتغير بطاهر معفو عنه.',
        ),
        LearningObjective(
          objectiveId: 'obj_t1_2',
          title: 'استحضار الأدلة الشرعية في طهورية ماء البحر والأمطار',
          description: 'فهم قوله تعالى: ﴿وَأَنزَلْنَا مِنَ السَّمَاءِ مَاءً طَهُورًا﴾ وحديث «هو الطهور ماؤه».',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t1_1',
          title: 'الأصل في المياه والماء الطهور',
          contentType: LearningContentType.sourceText,
          content: 'الأصل في جميع المياه النازلة من السماء أو النابعة من الأرض أنها طاهرة مطهرة رافعة للحدث ومزيلة للخبث، ما لم يتغير أحد أوصافه الثلاثة (لونه أو طعمه أو ريحه) بنجاسة تحدث فيه. ويشمل ذلك ماء المطر، والبحار، والأنهار، والعيون، والآبار، وذوبان الثلوج والبرد.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t1_quran',
              evidenceKey: '25:48',
              citation: 'سورة الفرقان: الآية 48',
              sourceId: 'src_quran_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 10',
        ),
        LessonSection.create(
          sectionId: 'sec_t1_2',
          title: 'الماء المتغير بنجاسة والماء المستعمل',
          contentType: LearningContentType.explanation,
          content: 'أجمع المسلمون على أن الماء إذا وقعت فيه نجاسة فغيرت لونه أو طعمه أو ريحه صار نجساً لا يجوز استعماله في طهارة ولا شرب. أما إذا لم يتغير الماء بالنجاسة: فإن كان كثيراً (قلتين فأكثر، وهو ما يعادل تقريباً 190-200 لتر) فالصحيح من قولي العلماء أنه طهور لا ينجس إلا بالتغير. أما الماء المستعمل في رفع الحدث فالراجح طهارته وطهوريته ما لم يتغير لونه أو ريحه أو طعمه، تيسيراً على الأمة.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t1_qullatayn',
              evidenceKey: 'hadith_qullatayn',
              citation: 'سنن أبي داود والترمذي: «إذا بلغ الماء قلتين لم يحمل الخبث»',
              sourceId: 'src_hadith_sunan',
            ),
          ],
          sourceAttribution: 'مجموع الفتاوى لشيخ الإسلام ابن تيمية ج 21 ص 25',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_mughni_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: الأعيان النجسة وطرق التطهير الشرعية
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_taharah_impurities',
      title: 'الأعيان النجسة وكيفية تطهيرها وقواعد إزالة الخبث',
      courseId: courseId,
      moduleId: 'mod_taharah_waters',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t2_1',
          title: 'حصر الأعيان النجسة المتفق عليها والمختلف فيها',
          description: 'التمييز بين النجاسة العينية التي لا تطهر كالميتة، والنجاسة الحكمية الطارئة.',
        ),
        LearningObjective(
          objectiveId: 'obj_t2_2',
          title: 'معرفة كيفية تطهير البدن والثياب والأرضيات',
          description: 'تطبيق التطهير بالماء، والمكاثرة في الأرض، وتطهير سؤر الكلب بالغسل سبعاً إحداهن بالتراب.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t2_1',
          title: 'أنواع النجاسات المتفق عليها',
          contentType: LearningContentType.explanation,
          content: 'النجاسات العينية المتفق على نجاستها: بول الآدمي وعذرته، والدم المسفوح المهراق، ولحم الخنزير، والميتة (ما مات حتف أنفه بغير ذكاة شرعية، ويستثنى ميتة البحر والجراد والآدمي وما لا نفس له سائلة كالنحل والذباب)، وروث وبول ما لا يؤكل لحمه كالحمار الأهلي والسباع.',
          sourceAttribution: 'بداية المجتهد ونهاية المقتصد ج 1 ص 82',
        ),
        LessonSection.create(
          sectionId: 'sec_t2_2',
          title: 'كيفية تطهير الثياب والأرض وسؤر الكلب',
          contentType: LearningContentType.example,
          content: '1. الثياب والأبدان: تطهر بغسلها بالماء حتى تزول عين النجاسة وأثرها ورائحتها، ولا يضر بقاء لون شق زواله كالدم المتعسر.\n2. الأرضيات الصخرية والترابية: تطهر بمكاثرة الماء عليها وصب دلو كبير عليها، لحديث الأعرابي الذي بال في المسجد: «صبوا على بوله ذنوباً من ماء».\n3. ولوغ الكلب: يطهر الإناء بغسله سبع مرات أولاهن أو إحداهن بالتراب أو المنظف المعاصر المزيل للميكروبات.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t2_kalb',
              evidenceKey: 'hadith_bukhari_dog',
              citation: 'صحيح البخاري: «طهور إناء أحدكم إذا ولغ فيه الكلب أن يغسله سبع مرات أولاهن بالتراب»',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المجموع شرح المهذب للنووي ج 2 ص 580',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: سنن الفطرة وآداب قضاء الحاجة والاستنجاء
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_taharah_fitrah_toilet',
      title: 'سنن الفطرة وآداب قضاء الحاجة والاستنجاء والاستجمار',
      courseId: courseId,
      moduleId: 'mod_taharah_waters',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t3_1',
          title: 'حفظ سنن الفطرة الخمس المذكورة في الحديث الصحيح',
          description: 'الختان، والاستحداد، وقص الشارب، وتقليم الأظفار، ونتف الإبط، والسواك.',
        ),
        LearningObjective(
          objectiveId: 'obj_t3_2',
          title: 'إتقان آداب التخلي والاستنجاء والاستجمار بالمناديل',
          description: 'الاستتار، والذكر المأثور، والنهي عن استقبال القبلة واستدبارها في الفضاء، وشروط الإجزاء بثلاث مسحات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t3_1',
          title: 'سنن الفطرة العشر ومقاصد النظافة في الإسلام',
          contentType: LearningContentType.sourceText,
          content: 'عن أبي هريرة رضي الله عنه عن النبي ﷺ قال: «الفِطْرَةُ خَمْسٌ: الخِتانُ، والاسْتِحْدادُ، وقَصُّ الشَّارِبِ، وتَقْلِيمُ الأظْفارِ، ونَتْفُ الآباطِ» متفق عليه. وجاء في صحيح مسلم ذكر عشر من الفطرة تشمل السواك وغسل البراجم والمضمضة والاستنشاق وانتقاص الماء، مما يرسخ عناية الإسلام الفائقة بنظافة الظاهر والباطن وكرامة الإنسان المسلم.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t3_fitrah',
              evidenceKey: 'hadith_fitrah_five',
              citation: 'صحيح البخاري رقم 5889 وصحيح مسلم رقم 257',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'فتح الباري شرح صحيح البخاري ج 10 ص 334',
        ),
        LessonSection.create(
          sectionId: 'sec_t3_2',
          title: 'آداب قضاء الحاجة وأحكام الاستجمار المعاصر',
          contentType: LearningContentType.explanation,
          content: 'يسن عند دخول الخلاء تقديم الرجل اليسرى وقول: «بسم الله، اللهم إني أعوذ بك من الخبث والخبائث»، وعند الخروج تقديم اليمنى وقول: «غفرانك». ويحرم التخلي في طرق الناس وظلهم النافع ومواردهم المائية. ويجزئ الاستجمار بالمناديل الورقية الطاهرة النظيفة إذا أنقت المحل بثلاث مسحات منقية فأكثر، والجمع بين الاستجمار بالمناديل ثم الاستنجاء بالماء أكمل الطهارة وأنقاها.',
          sourceAttribution: 'كشاف القناع عن متن الإقناع للبهوتي ج 1 ص 65',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_kashaf_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: فرائض الوضوء وسننه وهيئته النبوية
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_taharah_wudu_practice',
      title: 'فرائض الوضوء وسننه المستحبة والصفة النبوية المعتمدة',
      courseId: courseId,
      moduleId: 'mod_taharah_wudu_ghusl',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t4_1',
          title: 'إتقان أركان الوضوء الستة المتفق عليها بين الجمهور',
          description: 'النية، وغسل الوجه مع المضمضة والاستنشاق، واليدين للمرفقين، ومسح الرأس، وغسل الرجلين، والترتيب والموالاة.',
        ),
        LearningObjective(
          objectiveId: 'obj_t4_2',
          title: 'تطبيق صفة وضوء عثمان وعبد الله بن زيد رضي الله عنهما',
          description: 'التسمية، وتثليث الغسل، وتخليل اللحية وأصابع اليدين والرجلين، والدعاء المأثور.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t4_1',
          title: 'الفرائض القرآنية وأركان الوضوء',
          contentType: LearningContentType.sourceText,
          content: 'قال الله تعالى: ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا قُمْتُمْ إِلَى الصَّلَاةِ فَاغْسِلُوا وُجُوهَكُمْ وَأَيْدِيَكُمْ إِلَى الْمَرَافِقِ وَامْسَحُوا بِرُءُوسِكُمْ وَأَرْجُلَكُمْ إِلَى الْكَعْبَيْنِ﴾ [المائدة: 6]. وأركان الوضوء: 1. النية ومحلها القلب، 2. غسل الوجه كاملاً من منابت شعر الرأس المعتاد إلى الذقن طولاً ومن الأذن إلى الأذن عرضاً وتدخل فيه المضمضة والاستنشاق، 3. غسل اليدين مع المرفقين، 4. مسح الرأس كله مع الأذنين، 5. غسل الرجلين مع الكعبين، 6. الترتيب والموالاة بألا يؤخر غسل عضو حتى يجف الذي قبله في الزمن المعتدل.',
          sourceAttribution: 'المجموع للنووي ج 1 ص 210',
        ),
        LessonSection.create(
          sectionId: 'sec_t4_2',
          title: 'السنن المأثورة والدعاء النبوي بعد الوضوء',
          contentType: LearningContentType.example,
          content: 'من السنن: التسمية، وغسل الكفين ثلاثاً قبل البدء، والسواك، والمبالغة في المضمضة والاستنشاق لغير الصائم، وتخليل الأصابع واللحية الكثة، والتيامن، وتثليث الغسل (غسل العضو ثلاثاً وتكره الزيادة)، والاقتصاد في صب الماء وتجنب الإسراف ولو كان على نهر جارٍ. ويستحب عقب الفراغ قول: «أشهد أن لا إله إلا الله وحده لا شريك له، وأشهد أن محمداً عبده ورسوله، اللهم اجعلني من التوابين واجعلني من المتطهرين» لتفتح له أبواب الجنة الثمانية.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t4_dua',
              evidenceKey: 'hadith_muslim_wudu_dua',
              citation: 'صحيح مسلم رقم 234 من حديث عمر بن الخطاب رضي الله عنه',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'رياض الصالحين للإمام النووي ص 320',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: نواقض الوضوء الحقيقية ومسائل الشك وسلس البول
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_taharah_wudu_nullifiers',
      title: 'نواقض الوضوء المجمع عليها ومسائل الشك وسلس البول',
      courseId: courseId,
      moduleId: 'mod_taharah_wudu_ghusl',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t5_1',
          title: 'معرفة النواقض اليقينية المتفق عليها بين الفقهاء',
          description: 'الخارج من السبيلين، وزوال العقل بنوم مستغرق أو سكر أو إغماء، ومس الفرج بشهوة.',
        ),
        LearningObjective(
          objectiveId: 'obj_t5_2',
          title: 'تطبيق قاعدة اليقين لا يزول بالشك في الطهارة ودفع الوسواس',
          description: 'فهم حديث «لا ينصرف حتى يسمع صوتاً أو يجد ريحاً» وأحكام طهارة صاحب السلس الدائم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t5_1',
          title: 'النواقض المتفق عليها',
          contentType: LearningContentType.explanation,
          content: 'ينقض الوضوء بأمور: 1. الخارج من السبيلين المعتادين (القبل والدبر) من بول، أو غائط، أو ريح، أو مني، أو مذي، أو ودي. 2. زوال العقل أو تغطيته بإغماء، أو جنون، أو سكر، أو نوم مستغرق لا يشعر فيه النائم بأحداثه، أما النعاس اليسير الذي يسمع فيه الصوت فلا ينقض. 3. أكل لحم الإبل على الصحيح لورود الحديث الصريح فيه في صحيح مسلم. 4. مس الفرج بباطن الكف بشهوة عند جمهور أهل العلم.',
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 230',
        ),
        LessonSection.create(
          sectionId: 'sec_t5_2',
          title: 'قاعدة اليقين وأحكام أصحاب الأعذار وسلس البول',
          contentType: LearningContentType.example,
          content: 'إذا تيقن المسلم الطهارة وشك في الحدث فهو على طهارته ولا يلتفت للوساوس، لقول النبي ﷺ: «لا ينصرف حتى يسمع صوتاً أو يجد ريحاً». وأما من به عذر دائم كسلس البول أو الاستحاضة أو الريح المستمر: فإنه يستنجي ويتحفظ بخرقة أو عازل بعد دخول وقت كل صلاة، ثم يتوضأ ويصلي الفرض وما شاء من النوافل، ولا يضره ما خرج منه أثناء الصلاة مع وجود المشقة والضرورة.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t5_shakk',
              evidenceKey: 'hadith_bukhari_doubt',
              citation: 'صحيح البخاري رقم 137 وصحيح مسلم رقم 361',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'فتاوى اللجنة الدائمة للبحوث العلمية والإفتاء ج 5 ص 411',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 6: أحكام المسح على الخفين والجوربين والجبائر
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_taharah_khuffayn_splints',
      title: 'أحكام المسح على الخفين والجوربين والجبائر والضمادات الطبية',
      courseId: courseId,
      moduleId: 'mod_taharah_wudu_ghusl',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t6_1',
          title: 'معرفة شروط المسح على الخفين والجوربين ومدته الشرعية',
          description: 'لبسهما على طهارة كاملة، ومسح يوم وليلة للمقيم وثلاثة أيام بلياليها للمسافر.',
        ),
        LearningObjective(
          objectiveId: 'obj_t6_2',
          title: 'التمييز بين المسح على الخف والمسح على الجبيرة الطبية المعاصرة',
          description: 'المسح في الجبيرة لا يشترط فيه تقدم الطهارة ويمسح عليها كلها حتى الشفاء في الحدثين الأصغر والأكبر.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t6_1',
          title: 'المسح على الخفين والجوربين وشروطهما',
          contentType: LearningContentType.sourceText,
          content: 'المسح على الخفين رخصة ثابتة بالتواتر عن النبي ﷺ عن أكثر من أربعين صحابياً. ويشترط لجواز المسح: 1. أن يلبسهما على طهارة مائية كاملة بعد غسل الرجلين، 2. أن يكونا طاهرين صفيقين ساترين لمحل الفرض، 3. أن يكون المسح في الحدث الأصغر لا في الجنابة والحدث الأكبر. ومدة المسح: يوم وليلة (24 ساعة) للمقيم، وثلاثة أيام بلياليها (72 ساعة) للمسافر، ويبدأ حساب المدة من أول مسحة بعد أول حدث على الراجح.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t6_khuff',
              evidenceKey: 'hadith_muslim_khuff_duration',
              citation: 'صحيح مسلم رقم 276 من حديث علي بن أبي طالب رضي الله عنه',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'الشرح الممتع على زاد المستقنع للشيخ ابن عثيمين ج 1 ص 245',
        ),
        LessonSection.create(
          sectionId: 'sec_t6_2',
          title: 'كيفية المسح وأحكام الجبائر واللصوق الطبية',
          contentType: LearningContentType.example,
          content: 'صفة المسح على الخف: يبلل يديه بالماء ثم يمرر أصابع يديه مفرجتين من أطراف أصابع القدم إلى ساقه على ظاهر الخف، ولا يمسح أسفله ولا عقبه، لقول علي رضي الله عنه: «لو كان الدين بالرأي لكان أسفل الخف أولى بالمسح من أعلاه». وأما الجبائر واللفائف الطبية واللاصقات العلاجية: فيمسح على ظاهرها كله بالماء، ولا يشترط وضعها على طهارة سابقة للضرورة والمشقة، ويمسح عليها في الحدثين الأصغر والأكبر حتى يتم الشفاء ونزعها.',
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 340',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_mughni_canonical', 'src_mumti_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 7: الغسل الشرعي وموجباته وصفته الكاملة
    // -------------------------------------------------------------------------
    final lsn7 = Lesson.create(
      lessonId: 'lsn_taharah_ghusl',
      title: 'الغسل من الجنابة: موجباته، وأركانه، والصفة النبوية الكاملة',
      courseId: courseId,
      moduleId: 'mod_taharah_wudu_ghusl',
      orderIndex: 7,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t7_1',
          title: 'معرفة موجبات الغسل الشرعية الستة',
          description: 'خروج المني بلذة، والتقاء الختانين، وانقطاع الحيض والنفاس، والموت، ودخول الكافر في الإسلام.',
        ),
        LearningObjective(
          objectiveId: 'obj_t7_2',
          title: 'التمييز بين الغسل المجزئ والغسل النبوي الكامل المستحب',
          description: 'تعميم الجسد بالماء والمضمضة والاستنشاق في المجزئ، والوضوء قبله وتثليث الرأس في الكامل.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t7_1',
          title: 'موجبات الغسل وأركانه المجزئة',
          contentType: LearningContentType.explanation,
          content: 'يجب الغسل بأمور: 1. خروج المني دفقاً بلذة يقظة أو من غير لذة في الاحتلام إذا وجد بللاً، 2. التقاء الختانين بتغييب الحشفة في الفرج وإن لم يحصل إنزال لقوله ﷺ: «إذا جلس بين شعبها الأربع ثم مس الختان الختان فقد وجب الغسل»، 3. انقطاع دم الحيض والنفاس، 4. موت غير الشهيد، 5. إسلام الكافر. وأركان الغسل المجزئ: النية، وتعميم سائر البدن بالماء الطهور ومنه المضمضة والاستنشاق وتخليل أصول شعر الرأس والجسد.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t7_ghusl_hadith',
              evidenceKey: 'hadith_muslim_ghusl',
              citation: 'صحيح مسلم رقم 349 وصحيح البخاري رقم 291',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'المجموع شرح المهذب للنووي ج 2 ص 150',
        ),
        LessonSection.create(
          sectionId: 'sec_t7_2',
          title: 'صفة غسل النبي ﷺ المستحبة الكاملة',
          contentType: LearningContentType.example,
          content: 'الصفة الكاملة المأثورة عن عائشة وميمونة رضي الله عنهما: 1. ينوي الطهارة، 2. يغسل يديه ثلاثاً، 3. يغسل فرجه ويزيل الأذى بشماله، 4. يتوضأ وضوءه للصلاة كاملاً، 5. يحثي الماء على رأسه ثلاث حثيات يروي بها أصول شعره، 6. يفيض الماء على شقه الأيمن ثم الأيسر ثم يعمم سائر جسده بالماء، 7. يغسل قدميه، وبذلك يرتفع الحدث الأصغر والأكبر معاً في الغسل الشرعي الواحد بنيتهما.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t7_aisha',
              evidenceKey: 'hadith_bukhari_aisha_ghusl',
              citation: 'صحيح البخاري رقم 248 وصحيح مسلم رقم 316',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'فتح الباري لابن حجر ج 1 ص 360',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 8: التيمم وأحكامه وأسبابه وشروطه وصفته
    // -------------------------------------------------------------------------
    final lsn8 = Lesson.create(
      lessonId: 'lsn_taharah_tayammum',
      title: 'التيمم: مشروعيته، وأسبابه، وشروطه، وصفته الشرعية',
      courseId: courseId,
      moduleId: 'mod_taharah_wudu_ghusl',
      orderIndex: 8,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t8_1',
          title: 'معرفة الحالات المبيحة للتيمم بدلاً من الماء',
          description: 'فقد الماء بعد طلبه، أو تعذر استعماله لمرض شديد، أو برودة مهلكة يخشى معها الضرر.',
        ),
        LearningObjective(
          objectiveId: 'obj_t8_2',
          title: 'إتقان صفة التيمم الصحيحة بضربة واحدة للوجه والكفين',
          description: 'تطبيق حديث عمار بن ياسر رضي الله عنه الوارد في الصحيحين بدقة تامة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t8_1',
          title: 'مشروعية التيمم وأسبابه وشروطه',
          contentType: LearningContentType.sourceText,
          content: 'التيمم رخصة وتوسعة كريمة خص الله بها أمة الإسلام عند تعذر استعمال الماء، لقوله تعالى: ﴿وَإِن كُنتُم مَّرْضَىٰ أَوْ عَلَىٰ سَفَرٍ أَوْ جَاءَ أَحَدٌ مِّنكُم مِّنَ الْغَائِطِ أَوْ لَامَسْتُمُ النِّسَاءَ فَلَمْ تَجِدُوا مَاءً فَتَيَمَّمُوا صَعِيدًا طَيِّبًا فَامْسَحُوا بِوُجُوهِكُمْ وَأَيْدِيكُم مِّنْهُ﴾ [المائدة: 6]. ويشترط للتيمم: تعذر استعمال الماء لفقدانه حقيقة أو حكماً (كالمرض أو الجرح المخوف أو البرد القارس الذي يتعذر معه تسخين الماء ويخشى منه التلف)، وكون التيمم بصعيد طاهر من تراب أو رمل أو غبار الأرض الطبيعي.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t8_quran',
              evidenceKey: '5:6',
              citation: 'سورة المائدة: الآية 6',
              sourceId: 'src_quran_canonical',
            ),
          ],
          sourceAttribution: 'تفسير القرآن العظيم لابن كثير ج 3 ص 50',
        ),
        LessonSection.create(
          sectionId: 'sec_t8_2',
          title: 'صفة التيمم النبوية ونواقضه',
          contentType: LearningContentType.example,
          content: 'الصفة النبوية الصحيحة للتيمم ضربة واحدة: يضرب بيديه الصعيد الطاهر ضربة واحدة برفق، ثم ينفخهما لتخفيف التراب، ثم يمسح بهما وجهه وظاهري كفيه؛ يمسح ظاهر كفه اليمنى بباطن كفه اليسرى، وظاهر كفه اليسرى بباطن كفه اليمنى، لحديث عمار في الصحيحين: «إنما كان يكفيك أن تصنع هكذا: فضرب بكفيه ضربة على الأرض ثم نفخهما، ثم مسح بهما وجهه وكفيه». وينقض التيمم كل ما ينقض الوضوء، إضافة إلى وجود الماء والقدرة على استعماله قبل الشروع في الصلاة أو أثنائها.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t8_ammar',
              evidenceKey: 'hadith_bukhari_ammar_tayammum',
              citation: 'صحيح البخاري رقم 338 وصحيح مسلم رقم 368',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'زاد المعاد في هدي خير العباد لابن القيم ج 1 ص 198',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_zad_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 9: أحكام الدماء الطبيعية للنساء (حيض، نفاس، استحاضة)
    // -------------------------------------------------------------------------
    final lsn9 = Lesson.create(
      lessonId: 'lsn_taharah_female_blood',
      title: 'فقه الدماء الطبيعية للنساء: الحيض، والنفاس، والاستحاضة',
      courseId: courseId,
      moduleId: 'mod_taharah_wudu_ghusl',
      orderIndex: 9,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_t9_1',
          title: 'التمييز الفقهي الدقيق بين دم الحيض ودم الاستحاضة',
          description: 'معرفة صفات الدم وأحكام الصلاة والصيام والجماع لكل منهما.',
        ),
        LearningObjective(
          objectiveId: 'obj_t9_2',
          title: 'معرفة علامات الطهر من الحيض وأحكام النفاس وأكثره',
          description: 'القصة البيضاء، والجفوف التام، والحد الأقصى للنفاس أربعون يوماً.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t9_1',
          title: 'الحيض والنفاس وما يحرم بهما وما يترتب عليهما',
          contentType: LearningContentType.explanation,
          content: 'الحيض دم جبلة وطبيعة يعتري المرأة في أوقات معلومة. والنفاس هو الدم الخارج بسبب الولادة وأكثره أربعون يوماً. يحرم بالحيض والنفاس: الصلاة، والصيام، والطواف بالكعبة، ومس المصحف، والوطء في الفرج. ولا تقضي الحائض الصلاة إجماعاً وتيسيراً، ولكن تقضي ما فاتها من صيام رمضان بعد طهرها لحديث عائشة: «كان يصيبنا ذلك فنؤمر بقضاء الصوم ولا نؤمر بقضاء الصلاة». وعلامة الطهر: القصة البيضاء (ماء أبيض يدفعه الرحم عند انقطاع الحيض) أو الجفوف التام بحيث لو وضعت قطنة خرجت نقية جافة.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t9_aisha_fasting',
              evidenceKey: 'hadith_muslim_menstruation',
              citation: 'صحيح مسلم رقم 335 عن أم المؤمنين عائشة رضي الله عنها',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 380',
        ),
        LessonSection.create(
          sectionId: 'sec_t9_2',
          title: 'الاستحاضة والفرق بينها وبين الحيض وأحكام عبادتها',
          contentType: LearningContentType.scholarlyView,
          content: 'الاستحاضة سيلان الدم في غير وقته المعتاد من عِرق يسمى «العاذل». والفرق بينهما: دم الحيض أسود ثخين منتن الرائحة لا يتجلط غالباً، ودم الاستحاضة أحمر رقيق لا رائحة له ويتجلط كدم الجرح. المستحاضة حكمها حكم الطاهرات؛ فتصلي وتصوم وتطوف ويجوز وطؤها، ولكن تغسل فرجها عند كل صلاة وتتحفظ وتتوضأ لوقت كل صلاة مكتوبة بعد دخول وقته، ولا يضرها ما نزل منها أثناء الصلاة.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_t9_fatimah',
              evidenceKey: 'hadith_bukhari_istihadah',
              citation: 'صحيح البخاري رقم 228 وصحيح مسلم رقم 333 في حديث فاطمة بنت أبي حبيش',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'بداية المجتهد ج 1 ص 120 وسبل السلام للصنعاني ج 1 ص 142',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6, lsn7, lsn8, lsn9];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Water types
    final q1 = QuizQuestion.create(
      questionId: 'q_taharah_water_1',
      lessonId: 'lsn_taharah_water_types',
      questionText: 'ما الحكم إذا وقعت نجاسة في ماء كثير (أكثر من قلتين) ولم تغير لونه ولا طعمه ولا ريحه؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_tw1_1', text: 'يبقى ماءً طهوراً يرفع الحدث ويزيل الخبث على الراجح'),
        QuizOption(optionId: 'opt_tw1_2', text: 'يصير نجساً مطلقاً لمجرد الملاقاة'),
        QuizOption(optionId: 'opt_tw1_3', text: 'يصير طاهراً غير مطهر ولا يصح الوضوء به'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقول النبي ﷺ: «إذا بلغ الماء قلتين لم يحمل الخبث»، فما لم يتغير أحد أوصافه الثلاثة بالنجاسة فهو طهور معفو عنه.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_taharah_water',
      lessonId: 'lsn_taharah_water_types',
      title: 'اختبار أقسام المياه وضوابط التغير',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Wudu Practice
    final q2 = QuizQuestion.create(
      questionId: 'q_taharah_wudu_1',
      lessonId: 'lsn_taharah_wudu_practice',
      questionText: 'ما حكم الموالاة والترتيب في غسل أعضاء الوضوء عند جمهور الفقهاء؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_tw2_1', text: 'ركنان من أركان الوضوء لا يصح الوضوء بتركهما عمداً'),
        QuizOption(optionId: 'opt_tw2_2', text: 'سنة مستحبة ويجوز تنكيس الوضوء وتأخيره بلا عذر'),
        QuizOption(optionId: 'opt_tw2_3', text: 'مكروهان في مذهب الجمهور'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الترتيب والموالاة ركنان؛ للآية الكريمة التي رتبت المغسولات والممسوحات، ولأنه ﷺ لم يتوضأ إلا مرتباً وموالياً.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_taharah_wudu',
      lessonId: 'lsn_taharah_wudu_practice',
      title: 'اختبار أركان الوضوء وهيئته النبوية',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Khuffayn & Splints
    final q3 = QuizQuestion.create(
      questionId: 'q_taharah_khuff_1',
      lessonId: 'lsn_taharah_khuffayn_splints',
      questionText: 'متى تبدأ مدة المسح على الخفين والجوربين على القول الراجح المعتمد؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_tk1_1', text: 'من أول مسحة بعد أول حدث بعد اللبس'),
        QuizOption(optionId: 'opt_tk1_2', text: 'من وقت لبس الخفين مباشرة'),
        QuizOption(optionId: 'opt_tk1_3', text: 'من وقت الحدث الأول بعد اللبس'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لأن النصوص علقت الحكم بالمسح: «يمسح المسافر... ويمسح المقيم»، ولا يقال مسح إلا إذا باشر المسح بالفعل.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_taharah_khuff',
      lessonId: 'lsn_taharah_khuffayn_splints',
      title: 'اختبار أحكام المسح على الخفين والجبائر',
      questions: [q3],
      passingScorePercentage: 75,
    );

    // Quiz 4: Tayammum
    final q4 = QuizQuestion.create(
      questionId: 'q_taharah_tayammum_1',
      lessonId: 'lsn_taharah_tayammum',
      questionText: 'ما هي الصفة النبوية الصحيحة الثابتة للتيمم في حديث عمار في الصحيحين؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_tt1_1', text: 'ضربة واحدة يمسح بها وجهه وظاهري كفيه'),
        QuizOption(optionId: 'opt_tt1_2', text: 'ضربتان: ضربة للوجه وضربة لليدين إلى المرفقين'),
        QuizOption(optionId: 'opt_tt1_3', text: 'ثلاث ضربات مع مسح الذراعين والرأس'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقوله ﷺ لعمار: «إنما كان يكفيك أن تصنع هكذا: فضرب بكفيه ضربة على الأرض ثم نفخهما، ثم مسح بهما وجهه وكفيه».',
    );

    final quiz4 = Quiz.create(
      quizId: 'quiz_taharah_tayammum',
      lessonId: 'lsn_taharah_tayammum',
      title: 'اختبار صفة التيمم وأحكامه',
      questions: [q4],
      passingScorePercentage: 75,
    );

    // Quiz 5: Female Blood
    final q5 = QuizQuestion.create(
      questionId: 'q_taharah_blood_1',
      lessonId: 'lsn_taharah_female_blood',
      questionText: 'ما الواجب على المرأة الحائض فيما فاتها من صلاة وصيام أثناء الحيض؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_tb1_1', text: 'تقضي الصوم ولا تقضي الصلاة إجماعاً'),
        QuizOption(optionId: 'opt_tb1_2', text: 'تقضي الصلاة والصوم معاً'),
        QuizOption(optionId: 'opt_tb1_3', text: 'لا تقضي شيئاً منهما مطلقاً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لحديث عائشة رضي الله عنها في الصحيحين: «كان يصيبنا ذلك فنؤمر بقضاء الصوم ولا نؤمر بقضاء الصلاة».',
    );

    final quiz5 = Quiz.create(
      quizId: 'quiz_taharah_blood',
      lessonId: 'lsn_taharah_female_blood',
      title: 'اختبار فقه الدماء الطبيعية للنساء',
      questions: [q5],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3, quiz4, quiz5];
  }
}
