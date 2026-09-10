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

/// بيانات مقرر قواعد تصنيف الحديث وقبوله ورده وعلم الجرح والتعديل (8 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningHadithGradingRulesData {
  static const String courseId = 'course_hadith_grading_rules';
  static const String pathId = 'path_hadith_sciences_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر قواعد تصنيف الحديث وقبوله ورده وعلم الجرح والتعديل',
      description: 'دراسة تأصيلية نقدية في شروط قبول الحديث ورده: الصحيح لذاته ولغيره، الحسن بقسميه، أنواع السقط في الإسناد، والطعن في الراوي، والحديث الموضوع، ومبادئ وقواعد الجرح والتعديل.',
      level: lp.LearningLevel.intermediate,
      moduleIds: const ['mod_hadith_acceptable_rules', 'mod_hadith_rejected_rules'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_hadith_acceptable_rules',
        courseId: courseId,
        title: 'الوحدة الأولى: الحديث المقبول (الصحيح والحسن وضوابطهما)',
        description: 'بيان الشروط الخمسة لصحة الحديث لذاته، وحقيقة الصحيح لغيره، والحسن لذاته ولغيره، وأحكام زيادة الثقة والمتابعات والشواهد.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_hadith_sahih_shurut',
          'lsn_hadith_sahih_lighairihi',
          'lsn_hadith_hasan_types',
          'lsn_hadith_ziyadat_thiqat',
        ],
      ),
      CourseModule(
        moduleId: 'mod_hadith_rejected_rules',
        courseId: courseId,
        title: 'الوحدة الثانية: الحديث المردود وأقسامه وعلم الجرح والتعديل',
        description: 'دراسة أنواع الضعف الناتج عن انقطاع الإسناد أو الطعن في الراوي، وكشف الأحاديث الموضوعة، وضوابط ومراتب الجرح والتعديل.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_hadith_acceptable_rules'],
        lessonIds: const [
          'lsn_hadith_saqt_isnaad',
          'lsn_hadith_tan_rawi',
          'lsn_hadith_mawdoo_signs',
          'lsn_hadith_jarh_tadeel',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 8: شروط الحديث الصحيح لذاته الخمسة
    // -------------------------------------------------------------------------
    final evSahihAyah = EvidenceLink.create(
      evidenceId: 'ev_hd_tabayyan_ayah',
      evidenceKey: '49:6',
      citation: 'سورة الحجرات: الآية 6',
      sourceId: 'src_quran_canonical',
    );

    final l1 = Lesson.create(
      lessonId: 'lsn_hadith_sahih_shurut',
      title: 'شروط الحديث الصحيح لذاته الخمسة التأسيسية',
      courseId: courseId,
      moduleId: 'mod_hadith_acceptable_rules',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd8_1',
          title: 'الشروط الخمسة للصحيح لذاته',
          description: 'حفظ واستيعاب الشروط الخمسة التي لا يصح الحديث إلا بها.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd8_2',
          title: 'العدالة والضبط',
          description: 'التمييز بين عدالة الراوي وضبطه (ضبط الصدر وضبط الكتاب).',
        ),
        LearningObjective(
          objectiveId: 'obj_hd8_3',
          title: 'انتفاء الشذوذ والعلة',
          description: 'فهم حقيقة انتفاء الشذوذ وانتفاء العلة القادحة الخفية في الحديث.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd8_1',
          title: 'التعريف الاصطلاحي للحديث الصحيح لذاته',
          contentType: LearningContentType.explanation,
          content: 'الحديث الصحيح لذاته هو: ما اتصل سنده بنقل العدل الضابط عن مثله إلى منتهاه، من غير شذوذ ولا علة قادحة. وهو المعتمد في استنباط الأحكام والعقائد.',
          evidenceLinks: [evSahihAyah],
          sourceAttribution: 'مقدمة ابن الصلاح ونزهة النظر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd8_2',
          title: 'تفصيل الشروط الخمسة التي لا يصح الحديث إلا بها',
          contentType: LearningContentType.scholarlyView,
          content: '1. اتصال السند: بسماع كل راوٍ ممن فوقه دون انقطاع.\n2. عدالة الرواة: السلامة من الفسق وخوارم المروءة.\n3. تمام الضبط: إتقان الحفظ في الصدر أو سلامة الكتاب.\n4. عدم الشذوذ: ألا يخالف الراوي الثقة من هو أوثق منه.\n5. عدم العلة القادحة: انتفاء السبب الخفي القادح في صحة الحديث.',
          sourceAttribution: 'نخبة الفكر لابن حجر العسقلاني',
        ),
        LessonSection.create(
          sectionId: 'sec_hd8_3',
          title: 'مراتب الحديث الصحيح',
          contentType: LearningContentType.summary,
          content: 'أعلى مراتب الصحيح:\n1. ما اتفق عليه البخاري ومسلم.\n2. ما انفرد به البخاري.\n3. ما انفرد به مسلم.\n4. ما كان على شرطهما.\n5. ما كان على شرط البخاري.\n6. ما كان على شرط مسلم.\n7. ما صح عند غيرهما.',
          sourceAttribution: 'علوم الحديث لابن الصلاح',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 9: الحديث الصحيح لغيره
    // -------------------------------------------------------------------------
    final l2 = Lesson.create(
      lessonId: 'lsn_hadith_sahih_lighairihi',
      title: 'الحديث الصحيح لغيره: حقيقته وكيفية ارتقائه بالشواهد والمتابعات',
      courseId: courseId,
      moduleId: 'mod_hadith_acceptable_rules',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd9_1',
          title: 'حقيقة الصحيح لغيره',
          description: 'تعريف الحديث الصحيح لغيره والفرق بينه وبين الصحيح لذاته.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd9_2',
          title: 'ارتقاء الحديث الحسن',
          description: 'معرفة كيفية ارتقاء الحديث الحسن لذاته إلى رتبة الصحيح لغيره بالمتابعات.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd9_3',
          title: 'تطبيق من السنة المطهرة',
          description: 'دراسة مثال تطبيقي من السنة النبوية المطهرة على الصحيح لغيره.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd9_1',
          title: 'حقيقة الصحيح لغيره وضابط ارتقائه',
          contentType: LearningContentType.explanation,
          content: 'الصحيح لغيره هو: الحديث الحسن لذاته إذا روي من وجه آخر مثله أو أقوى منه، فسمي صحيحاً لغيره لأن الصحة لم تأتِ من ذات الإسناد الأول فقط، وإنما جاءت من انضمام الطريق الآخر الذي جبر خفة الضبط اليسيرة.',
          sourceAttribution: 'نزهة النظر لابن حجر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd9_2',
          title: 'مثال تطبيقي على الصحيح لغيره',
          contentType: LearningContentType.example,
          content: 'حديث محمد بن عمرو بن علقمة عن أبي سلمة عن أبي هريرة رضي الله عنه: «لَوْلَا أَنْ أَشُقَّ عَلَى أُمَّتِي لَأَمَرْتُهُمْ بِالسِّوَاكِ عِنْدَ كُلِّ صَلَاةٍ»؛ فمحمد بن عمرو خف ضبطه قليلاً فحديثه حسن، فلما توبع ورُوي من طرق صحيحة أخرى ارتقى إلى الصحيح لغيره.',
          sourceAttribution: 'جامع الترمذي وسنن أبي داود',
        ),
        LessonSection.create(
          sectionId: 'sec_hd9_3',
          title: 'حكم الاحتجاج بالصحيح لغيره',
          contentType: LearningContentType.scholarlyView,
          content: 'الصحيح لغيره حجة شرعية معتبرة وواجبة العمل والتصديق بالإجماع، ويلتحق بالصحيح لذاته في القوة والحجية وإن كان دونه بدرجة طفيفة عند التعارض والترجيح.',
          sourceAttribution: 'فتح المغيث للسخاوي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 10: الحديث الحسن لذاته ولغيره
    // -------------------------------------------------------------------------
    final l3 = Lesson.create(
      lessonId: 'lsn_hadith_hasan_types',
      title: 'الحديث الحسن لذاته والحسن لغيره: الفروق الدقيقة وشروط الترقي',
      courseId: courseId,
      moduleId: 'mod_hadith_acceptable_rules',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd10_1',
          title: 'تعريف الحسن لذاته',
          description: 'تعريف الحديث الحسن لذاته عند الإمام الترمذي وابن حجر.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd10_2',
          title: 'شروط ارتقاء الضعيف',
          description: 'بيان شروط ارتقاء الحديث الضعيف ضعفا يسيراً إلى حسن لغيره.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd10_3',
          title: 'الضعف غير المنجبر',
          description: 'التمييز بين الضعف المنجبر بالمتابعات والضعف الشديد كالكذب والفسق.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd10_1',
          title: 'تعريف الحسن لذاته',
          contentType: LearningContentType.explanation,
          content: 'الحسن لذاته هو: ما اتصل سنده بنقل عدل خفيف الضبط عن مثله إلى منتهاه، من غير شذوذ ولا علة قادحة؛ فهو يشارك الصحيح في أربعة شروط ويفارقه في شرط واحد وهو تمام الضبط، حيث خف ضبط راويه قليلاً ولم ينزل إلى درجة النكارة.',
          sourceAttribution: 'نخبة الفكر وشرحها',
        ),
        LessonSection.create(
          sectionId: 'sec_hd10_2',
          title: 'الحسن لغيره وضوابط انجبار الضعف',
          contentType: LearningContentType.scholarlyView,
          content: 'الحسن لغيره هو: حديث ضعيف جاء من طرق متعددة، بشرط ألا يكون سبب ضعفه فسق الراوي أو كذبه، بل كان ناشئاً عن سوء حفظ يسير، أو انقطاع خفيف، أو جهالة حال الراوي المستور، فإذا تعاضدت طرقه ارتقى إلى الحسن لغيره وجاز الاحتجاج به.',
          sourceAttribution: 'جامع الترمذي ومقدمة ابن الصلاح',
        ),
        LessonSection.create(
          sectionId: 'sec_hd10_3',
          title: 'أنواع الضعف التي لا تنجبر بحال',
          contentType: LearningContentType.summary,
          content: 'لا ينجبر الحديث ولا يرتقي إلى الحسن لغيره إذا كان الضعف شديداً، وذلك في:\n1. الحديث الموضوع والمكذوب.\n2. الحديث المتروك لراوٍ متهم بالكذب.\n3. الحديث المنكر الشديد المخالفة للثقات.\n4. الراوي الفاسق أو المجهول عيناً.',
          sourceAttribution: 'الباعث الحثيث لأحمد شاكر',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 11: زيادات الثقات والاعتبار
    // -------------------------------------------------------------------------
    final l4 = Lesson.create(
      lessonId: 'lsn_hadith_ziyadat_thiqat',
      title: 'زيادات الثقات وقواعد الاعتبار والمتابعات والشواهد عند النقاد',
      courseId: courseId,
      moduleId: 'mod_hadith_acceptable_rules',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd11_1',
          title: 'مفهوم زيادة الثقة',
          description: 'تعريف زيادة الثقة في السند والمتن ومذاهب العلماء في قبولها.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd11_2',
          title: 'المتابعات والشواهد والاعتبار',
          description: 'التمييز بين المتابعة التامة والمتابعة القاصرة والشاهد والاعتبار.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd11_3',
          title: 'منهج نقاد الحديث المتقدمين',
          description: 'تطبيق منهج أئمة الحديث المتقدمين في القرائن والترجيح بين الروايات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd11_1',
          title: 'مفهوم زيادة الثقة وحكمها',
          contentType: LearningContentType.explanation,
          content: 'زيادة الثقة: هي أن يروي راوٍ ثقة حديثاً فيزيد فيه لفظة في المتن أو رجلاً في الإسناد لم يذكرها باقي الرواة الثقات لنفس الحديث. ومذهب المحققين أن الزيادة تقبل إذا لم تعارض وتناقض رواية من هو أوثق، وتخضع للقرائن الدقيقة ولا تقبل مطلقا ولا ترد مطلقا.',
          sourceAttribution: 'شرح علل الترمذي لابن رجب',
        ),
        LessonSection.create(
          sectionId: 'sec_hd11_2',
          title: 'المتابعة التامة والقاصرة والشاهد',
          contentType: LearningContentType.example,
          content: '1. المتابعة التامة: مشاركة راوٍ لراوٍ آخر في رواية الحديث عن شيخه عينه.\n2. المتابعة القاصرة: مشاركته له في الرواية عن شيخ شيخه فما فوقه.\n3. الشاهد: أن يروي صحابي آخر حديثاً يوافق حديث الصحابي الأول في المعنى فيعضده.\nوالاعتبار هو: عملية التتبع والبحث في كتب السنة لكشف هذه الطرق.',
          sourceAttribution: 'مقدمة ابن الصلاح',
        ),
        LessonSection.create(
          sectionId: 'sec_hd11_3',
          title: 'أثر المتابعات والشواهد في تقوية الحديث',
          contentType: LearningContentType.scholarlyView,
          content: 'يكشف الاعتبار دقة حفظ الراوي أو وهمه، ويجبر القصور المحتمل في الأسانيد، ويحول الحديث من غريب إلى عزيز أو مشهور، ومن حسن إلى صحيح لغيره.',
          sourceAttribution: 'النكت على كتاب ابن الصلاح لابن حجر',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 12: السقط في الإسناد
    // -------------------------------------------------------------------------
    final l5 = Lesson.create(
      lessonId: 'lsn_hadith_saqt_isnaad',
      title: 'أسباب الرد لسقط في الإسناد: المعلق والمرسل والمعضل والمنقطع والمدلس',
      courseId: courseId,
      moduleId: 'mod_hadith_rejected_rules',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd12_1',
          title: 'أنواع السقط الظاهر',
          description: 'التمييز الدقيق بين المعلق والمرسل والمعضل والمنقطع في الإسناد.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd12_2',
          title: 'التدليس وأنواعه',
          description: 'معرفة حقيقة التدليس وأنواعه كتدليس الإسناد والتسوية وحكم رواية المدلس.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd12_3',
          title: 'المرسل الخفي',
          description: 'فهم حقيقة المرسل الخفي والفرق الدقيق بينه وبين التدليس.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd12_1',
          title: 'أنواع السقط الظاهر في الإسناد',
          contentType: LearningContentType.explanation,
          content: '1. المعلق: ما حُذف من مبتدأ إسناده راوٍ أو أكثر ولو إلى آخره.\n2. المرسل: ما رفعه التابعي إلى النبي ﷺ مباشرة بإسقاط الصحابي.\n3. المعضل: ما سقط من إسناده راويان متتاليان فأكثر في أي موضع.\n4. المنقطع: ما سقط من إسناده راوٍ واحد قبل الصحابي، أو سقط راويان غير متتاليين.',
          sourceAttribution: 'الكفاية في علم الرواية للخطيب البغدادي',
        ),
        LessonSection.create(
          sectionId: 'sec_hd12_2',
          title: 'السقط الخفي: التدليس والمرسل الخفي',
          contentType: LearningContentType.scholarlyView,
          content: '1. تدليس الإسناد: أن يروي الراوي عمن سمع منه ما لم يسمعه منه بصيغة موهمة للسماع كـ "قال" أو "عن".\n2. تدليس التسوية: إسقاط راوٍ ضعيف بين ثقتين لقيا بعضهما لتحسين الإسناد.\n3. المرسل الخفي: رواية الراوي عمن عاصره ولم يثبت لقاؤه به بصيغة تحتمل الاتصال.\nوحكم المدلس: لا يقبل حديثه إلا إذا صرح بالتحديث والسماع فقال: "سمعت" أو "حدثنا".',
          sourceAttribution: 'طبقات المدلسين لابن حجر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd12_3',
          title: 'حكم الحديث المرسل عند الفقهاء والمحدثين',
          contentType: LearningContentType.summary,
          content: 'المرسل ضعيف عند جمهور المحدثين لجهالة الساقط، بينما يقبله الإمام أبو حنيفة ومالك وأحمد إذا كان المرسل ثقة، وفصّل الإمام الشافعي فاشترط شروطاً دقيقة لقبوله كمجيئه من وجه آخر يعضده.',
          sourceAttribution: 'الرسالة للإمام الشافعي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 13: الطعن في الراوي
    // -------------------------------------------------------------------------
    final l6 = Lesson.create(
      lessonId: 'lsn_hadith_tan_rawi',
      title: 'أسباب الرد لطعن في الراوي: المتروك والمنكر والشاذ والمعلل',
      courseId: courseId,
      moduleId: 'mod_hadith_rejected_rules',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd13_1',
          title: 'أسباب الطعن العشرة',
          description: 'استيعاب أسباب الطعن في عدالة الراوي أو ضبطه العشرة المعتمدة عند النقاد.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd13_2',
          title: 'المتروك والمنكر والشاذ',
          description: 'التمييز الاصطلاحي بين الحديث المتروك والمنكر والشاذ والمحفوظ.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd13_3',
          title: 'علم علل الحديث',
          description: 'معرفة علم علل الحديث وكيفية كشف العلة الخفية الغامضة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd13_1',
          title: 'أسباب الطعن العشرة في الراوي',
          contentType: LearningContentType.explanation,
          content: 'أسباب الطعن في الراوي عشرة؛ خمسة في العدالة: (الكذب، التهمة بالكذب، الفسق، البدعة، الجهالة)، وخمسة في الضبط: (فحش الغلط، فرط الغفلة، الوهم، مخالفة الثقات، سوء الحفظ).',
          sourceAttribution: 'نخبة الفكر ونزهة النظر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd13_2',
          title: 'التعريف الاصطلاحي للمتروك والمنكر والشاذ',
          contentType: LearningContentType.scholarlyView,
          content: '1. المتروك: الحديث الذي في إسناده راوٍ متهم بالكذب أو كثير الغفلة والفسق.\n2. المنكر: ما رواه الضعيف مخالفاً لما رواه الثقة.\n3. الشاذ: ما رواه المقبول مخالفاً لمن هو أولى منه ثقة أو أكثر عدداً.\n4. المحفوظ: هو مقابل الشاذ (رواية الأوثق)، والمعروف: هو مقابل المنكر.',
          sourceAttribution: 'مقدمة ابن الصلاح',
        ),
        LessonSection.create(
          sectionId: 'sec_hd13_3',
          title: 'الحديث المعلل وعلم العلل الدقيق',
          contentType: LearningContentType.example,
          content: 'المعلل: هو حديث ظاهره الصحة والسلامة، ولكن اطلع فيه الناقد الحاذق على علة قادحة خفية (كإرسال موصول، أو وقف مرفوع، أو إدخال حديث في حديث)؛ ولا يهتدي للعلل إلا جهابذة النقاد كعلي بن المديني، وأحمد، والبخاري، وأبي حاتم، والدارقطني.',
          sourceAttribution: 'علل الحديث لابن أبي حاتم',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 14: الحديث الموضوع والمكذوب
    // -------------------------------------------------------------------------
    final l7 = Lesson.create(
      lessonId: 'lsn_hadith_mawdoo_signs',
      title: 'الحديث الموضوع والمكذوب: دوافعه وعلاماته وحكم روايته وتناقله',
      courseId: courseId,
      moduleId: 'mod_hadith_rejected_rules',
      orderIndex: 7,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd14_1',
          title: 'تعريف الحديث الموضوع',
          description: 'تعريف الحديث الموضوع وإدراك خطورته الشديدة على العقيدة والشريعة.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd14_2',
          title: 'علامات الوضع في السند والمتن',
          description: 'معرفة علامات وضوابط كشف الحديث الموضوع في السند وفي المتن.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd14_3',
          title: 'تحريم رواية الموضوع',
          description: 'بيان الحكم الشرعي الصارم في تحريم رواية الموضوع إلا للتحذير منه.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd14_1',
          title: 'تعريف الموضوع ودوافع الوضاعين التاريخية',
          contentType: LearningContentType.explanation,
          content: 'الموضوع هو الحديث المكذوب المختلق المصنوع المنسوب زوراً إلى رسول الله ﷺ؛ وهو شر الأحاديث الضعيفة وأقبحها. ودوافعه تاريخياً:\n1. الزندقة وإفساد الدين وتشويهه.\n2. التعصب المذهبي أو الحزبي أو السياسي.\n3. التكسب وطلب الشهرة.\n4. الاحتساب والجهل بالترغيب والترهيب.',
          sourceAttribution: 'الموضوعات لابن الجوزي',
        ),
        LessonSection.create(
          sectionId: 'sec_hd14_2',
          title: 'علامات وضوابط كشف الحديث الموضوع في السند والمتن',
          contentType: LearningContentType.scholarlyView,
          content: '1. في السند: إقرار الواضع بالكذب، أو ثبوت ولادة الراوي بعد موت الشيخ المروي عنه، أو اشتهار الراوي بصناعة الأحاديث.\n2. في المتن: ركاكة اللفظ واضطراب المعنى، أو مخالفته الصريحة لمحكم القرآن والسنة المتواترة، أو اشتماله على وعيد هائل أو أجر عظيم جداً لعمل تافه ويسير.',
          sourceAttribution: 'الفوائد المجموعة للشوكاني',
        ),
        LessonSection.create(
          sectionId: 'sec_hd14_3',
          title: 'حكم رواية الحديث الموضوع والتحذير النبوي',
          contentType: LearningContentType.sourceText,
          content: 'تحرم رواية الحديث الموضوع في وسائل الإعلام أو المواعظ أو الكتب إلا مقروناً بالبيان الصريح لوضعه والتحذير منه، لقول رسول الله ﷺ: «مَنْ حَدَّثَ عَنِّي بِحَدِيثٍ يُرَى أَنَّهُ كَذِبٌ فَهُوَ أَحَدُ الْكَاذِبِينَ» (رواه مسلم في مقدمة صحيحه).',
          sourceAttribution: 'مقدمة صحيح مسلم',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    // -------------------------------------------------------------------------
    // Lesson 15: علم الجرح والتعديل
    // -------------------------------------------------------------------------
    final l8 = Lesson.create(
      lessonId: 'lsn_hadith_jarh_tadeel',
      title: 'مبادئ علم الجرح والتعديل: شروطه ومراتبه وقواعد تعارض الجرح والتعديل',
      courseId: courseId,
      moduleId: 'mod_hadith_rejected_rules',
      orderIndex: 8,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_hd15_1',
          title: 'مشروعية الجرح والتعديل',
          description: 'معرفة مشروعية الجرح والتعديل وصيانة الدين من الغيبة المحرمة.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd15_2',
          title: 'مراتب التعديل والتجريح الست',
          description: 'حفظ مراتب التعديل والتجريح الست وألفاظها الاصطلاحية الدقيقة.',
        ),
        LearningObjective(
          objectiveId: 'obj_hd15_3',
          title: 'قواعد التعارض بين الجرح والتعديل',
          description: 'إتقان قواعد الترجيح عند تعارض الجرح مع التعديل وتقديم الجرح المفسر.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_hd15_1',
          title: 'مشروعية علم الجرح والتعديل وحكمه',
          contentType: LearningContentType.explanation,
          content: 'علم الجرح والتعديل هو ميزان نقد الرواة لبيان من تقبل روايته ومن ترد؛ وهو فرض كفاية وصيانة للشريعة باتفاق العلماء، وليس من الغيبة المحرمة بل هو نصيحة واجبة للدين لقول النبي ﷺ لفاطمة بنت قيس: «أما معاوية فصعلوك، وأما أبو جهم فلا يضع عصاه عن عاتقه».',
          sourceAttribution: 'صحيح مسلم والجامع للترمذي',
        ),
        LessonSection.create(
          sectionId: 'sec_hd15_2',
          title: 'مراتب التعديل والتجريح الست المشهورة',
          contentType: LearningContentType.scholarlyView,
          content: '1. مراتب التعديل: (1) ما دل على المبالغة كـ "أوثق الناس"، (2) توكيد الصفة كـ "ثقة ثقة"، (3) الإفراد كـ "ثقة"، (4) ما دل على التعديل دون الضبط كـ "صدوق"، (5) "محله الصدق"، (6) "صالح الحديث".\n2. مراتب التجريح: (1) "لين الحديث"، (2) "ضعيف"، (3) "متروك"، (4) "متهم بالكذب"، (5) "كذاب"، (6) "أكذب الناس".',
          sourceAttribution: 'تهذيب التهذيب لابن حجر',
        ),
        LessonSection.create(
          sectionId: 'sec_hd15_3',
          title: 'قواعد التعارض بين الجرح والتعديل',
          contentType: LearningContentType.summary,
          content: '1. إذا تعارض جرح مبهم غير مفسر مع تعديل صريح، قُدّم التعديل لأن الأصل في المسلم العدالة.\n2. إذا تعارض جرح مفسر مبين السبب مع التعديل، قُدّم الجرح المفسر لأن الجارح معه زيادة علم خفيت على المعدّل.\n3. يُشترط في الناقد: العلم والورع والإنصاف وتجنب الهوى.',
          sourceAttribution: 'قواعد التحديث للقاسمي',
        ),
      ],
      sources: const ['src_hadith_canonical'],
      authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );

    return [l1, l2, l3, l4, l5, l6, l7, l8];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: شروط الصحيح والحسن
    final q1 = QuizQuestion.create(
      questionId: 'q_hdr_sahih_1',
      lessonId: 'lsn_hadith_sahih_shurut',
      questionText: 'ما هي الشروط الخمسة التي يجب توفرها مجتمعة ليكون الحديث صحيحاً لذاته؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qhs1_1', text: 'اتصال السند، عدالة الرواة، تمام الضبط، انتفاء الشذوذ، وانتفاء العلة القادحة'),
        QuizOption(optionId: 'opt_qhs1_2', text: 'شهرة الحديث في كتب الفقه وسلامته من الكذب فقط'),
        QuizOption(optionId: 'opt_qhs1_3', text: 'أن يرويه ثلاثة رواة على الأقل في كل طبقة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الصحيح لذاته يشترط فيه اتصال السند، وعدالة الرواة، وتمام ضبطهم، مع السلامة التامة من الشذوذ والعلة القادحة.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_hadith_sahih_rules',
      lessonId: 'lsn_hadith_sahih_shurut',
      title: 'اختبار شروط الحديث الصحيح والحسن',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: السقط في الإسناد
    final q2 = QuizQuestion.create(
      questionId: 'q_hdr_saqt_1',
      lessonId: 'lsn_hadith_saqt_isnaad',
      questionText: 'ما هو مصطلح الحديث الذي سقط من إسناده راويان متتاليان فأكثر في أي موضع؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qhss1_1', text: 'الحديث المعضل'),
        QuizOption(optionId: 'opt_qhss1_2', text: 'الحديث المرسل'),
        QuizOption(optionId: 'opt_qhss1_3', text: 'الحديث المنقطع المفرد'),
      ],
      correctOptionIndices: const [0],
      explanation: 'المعضل في اصطلاح المحدثين هو ما سقط من إسناده راويان فأكثر على التوالي في أي موضع من السند.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_hadith_saqt_rules',
      lessonId: 'lsn_hadith_saqt_isnaad',
      title: 'اختبار أنواع السقط والانقطاع في الإسناد',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: الحديث الموضوع وعلم الجرح والتعديل
    final q3 = QuizQuestion.create(
      questionId: 'q_hdr_mawdoo_1',
      lessonId: 'lsn_hadith_mawdoo_signs',
      questionText: 'ما هو الحكم الشرعي لرواية أو نشر الحديث الموضوع والمكذوب؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qhdm1_1', text: 'حرام قطعاً ولا تجوز روايته إلا مع بيان وضعه وتزييفه والتحذير منه'),
        QuizOption(optionId: 'opt_qhdm1_2', text: 'يجوز نشره في فضائل الأعمال والترغيب والترهيب'),
        QuizOption(optionId: 'opt_qhdm1_3', text: 'مكروه كراهة تنزيه فقط'),
      ],
      correctOptionIndices: const [0],
      explanation: 'تحرم رواية الحديث الموضوع ونشره باتفاق الأمة، إلا مقروناً بالبيان الصريح لوضعه لقول النبي ﷺ: «من حدث عني بحديث يُرى أنه كذب فهو أحد الكاذبين».',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_hadith_jarh_mawdoo',
      lessonId: 'lsn_hadith_mawdoo_signs',
      title: 'اختبار الحديث الموضوع وقواعد الجرح والتعديل',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
