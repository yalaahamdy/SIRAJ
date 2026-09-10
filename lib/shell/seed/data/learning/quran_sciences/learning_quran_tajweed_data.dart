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

/// بيانات مقرر أحكام التلاوة والتجويد العملي (8 دروس تأصيلية + 3 اختبارات استيعاب)
class LearningQuranTajweedData {
  static const String courseId = 'course_quran_tajweed';
  static const String pathId = 'path_quran_sciences_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر أحكام التلاوة والتجويد العملي لكتاب الله',
      description: 'دراسة تأصيلية تطبيقية شاملة لقواعد تجويد القرآن الكريم: أحكام النون الساكنة والتنوين والميم الساكنة، أحكام المدود بأنواعها، ومخارج وصفات الحروف، والتفخيم والترقيق.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_tajweed_noon_meem', 'mod_tajweed_madd_makharij_sifat'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_tajweed_noon_meem',
        courseId: courseId,
        title: 'الوحدة الأولى: أحكام النون الساكنة والتنوين والميم الساكنة',
        description: 'بيان مبادئ علم التجويد، وأحكام النون والتنوين الأربعة (الإظهار، الإدغام، الإقلاب، الإخفاء)، وأحكام الميم الساكنة، والمشددتين.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_tajweed_intro_istiadhah',
          'lsn_tajweed_noon_izhar_idgham',
          'lsn_tajweed_noon_iqlab_ikhfa',
          'lsn_tajweed_meem_sakinah_mushaddadah',
        ],
      ),
      CourseModule(
        moduleId: 'mod_tajweed_madd_makharij_sifat',
        courseId: courseId,
        title: 'الوحدة الثانية: أحكام المدود ومخارج وصفات الحروف والتفخيم والترقيق',
        description: 'دراسة المد الأصلي وملحقاته، والمد الفرعي بسبب الهمز والسكون، والمخارج الـ 17 للحروف، والصفات اللازمة والعارضة والتفخيم والترقيق.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_tajweed_noon_meem'],
        lessonIds: const [
          'lsn_tajweed_madd_original',
          'lsn_tajweed_madd_secondary',
          'lsn_tajweed_makharij_letters',
          'lsn_tajweed_sifat_letters_tafkheem',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 1: مبادئ التجويد والاستعاذة
    // -------------------------------------------------------------------------
    final evTajweedAyah = EvidenceLink.create(
      evidenceId: 'ev_taj_tartil_ayah',
      evidenceKey: '73:4',
      citation: 'سورة المزمل: الآية 4',
      sourceId: 'src_quran_canonical',
    );
    final lsn1 = Lesson.create(
      lessonId: 'lsn_tajweed_intro_istiadhah',
      title: 'فضل تلاوة القرآن وآدابها ومبادئ علم التجويد والاستعاذة والبسملة',
      courseId: courseId,
      moduleId: 'mod_tajweed_noon_meem',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj1_1',
          title: 'معرفة حد التجويد وأهميته وحكمه الشرعي',
          description: 'أن يتعرف المتعلم على التجويد لغة واصطلاحاً، وفرضيته العينية في تجنب اللحن الجلي، وأحكام الاستعاذة والبسملة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj1_1',
          title: 'الأمر الإلهي بالترتيل المجود',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: {وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا}. وقال علي بن أبي طالب رضي الله عنه في تفسيرها: «الترتيل هو تجويد الحروف ومعرفة الوقوف».',
          evidenceLinks: [evTajweedAyah],
          sourceAttribution: 'سورة المزمل: الآية 4، والإتقان في علوم القرآن للسيوطي',
        ),
        LessonSection.create(
          sectionId: 'sec_tj1_2',
          title: 'حقيقة علم التجويد وحكمه وأحكام البسملة',
          contentType: LearningContentType.explanation,
          content: 'التجويد لغة: التحسين، واصطلاحاً: إخراج كل حرف من مخرجه مع إعطائه حقه من الصفات اللازمة ومستحقه من الصفات العارضة. وحكمه: العلم به فرض كفاية، والعمل به فرض عين على كل قارئ لتجنب اللحن الجلي (الخطأ في الحركات أو تبديل الحروف المحرم إجماعاً). وتجب الاستعاذة عند ابتداء القراءة لقوله تعالى: {فَإِذَا قَرَأْتَ الْقُرْآنَ فَاسْتَعِذْ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ}، وتثبت البسملة في أول كل سورة عدا سورة براءة.',
          sourceAttribution: 'المقدمة الجزرية لابن الجزري، والغاية في تجويد القراءة',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_jazariyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 2: الإظهار الحلقي والإدغام
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_tajweed_noon_izhar_idgham',
      title: 'أحكام النون الساكنة والتنوين: الإظهار الحلقي والإدغام بقسميه',
      courseId: courseId,
      moduleId: 'mod_tajweed_noon_meem',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj2_1',
          title: 'إتقان حُكمي الإظهار الحلقي والإدغام بغنة وبغير غنة',
          description: 'حفظ حروف الإظهار الستة، وحروف الإدغام الستة (يرملون)، وضابط الإدغام في كلمتين واستثناء الإظهار المطلق.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj2_1',
          title: 'منظومة تحفة الأطفال في الإظهار والإدغام',
          contentType: LearningContentType.sourceText,
          content: 'للنونِ إن تسكنْ وللتنوينِ ... أربعُ أحكامٍ فخذْ تبييني\nفالأولُ الإظهارُ قبلَ أحرفِ ... للحلقِ ستٌّ رُتّبتْ فلتعرفِ\nهمزٌ فهاءٌ ثم عينٌ حاءُ ... مهملتانِ ثم غينٌ خاءُ\nوالثانِ إدغامٌ بستةٍ أتتْ ... في يرملونَ عندهم قد ثبتتْ',
          sourceAttribution: 'متن تحفة الأطفال للشيخ الجمزوري',
        ),
        LessonSection.create(
          sectionId: 'sec_tj2_2',
          title: 'التفصيل التطبيقي للإظهار والإدغام',
          contentType: LearningContentType.explanation,
          content: '1. الإظهار الحلقي: إخراج النون الساكنة أو التنوين بغير غنة ظاهرة إذا جاء بعدها أحد حروف الحلق الستة: (الهمزة، الهاء، العين، الحاء، الغين، الخاء) مثل: {مَنْ آمَنَ}، {يَنْهَوْنَ}، {عَلِيمٌ حَكِيمٌ}.\n2. الإدغام: إدخال النون أو التنوين في الحرف التالي، وحروفه مجموعة في كلمة (يَرْمَلُون). وينقسم إلى: إدغام بغنة في أربعة حروف (يَنْمُو) مثل: {مَن يَقُولُ}، وإدغام بغير غنة (إدغام كامل) في حرفي اللام والراء مثل: {مِن لَّدُنك}، {غَفُورٌ رَّحِيمٌ}. ويشترط في الإدغام أن يكون في كلمتين، فإن اجتمعا في كلمة واحدة وجب الإظهار المطلق في أربع كلمات فقط في القرآن: {دُنْيَا}، {بُنْيَانٌ}، {قِنْوَانٌ}، {صِنْوَانٌ}.',
          sourceAttribution: 'غاية المريد في علم التجويد للشيخ عطية نصر ص 45',
        ),
      ],
      sources: const ['src_tuhfah_canonical', 'src_jazariyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 3: الإقلاب والإخفاء الحقيقي
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_tajweed_noon_iqlab_ikhfa',
      title: 'أحكام النون الساكنة والتنوين: الإقلاب والإخفاء الحقيقي ومراتب الغنة',
      courseId: courseId,
      moduleId: 'mod_tajweed_noon_meem',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj3_1',
          title: 'إتقان تطبيقي الإقلاب والإخفاء الحقيقي بحروفه الـ 15',
          description: 'قلب النون ميماً مخفاة مع الباء، وإخفاء النون عند حروف الإخفاء الـ 15 ومراعاة تفخيم وترقيق الغنة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj3_1',
          title: 'المنظومة في الإقلاب والإخفاء الحقيقي',
          contentType: LearningContentType.sourceText,
          content: 'والثالثُ الإقلابُ عند الباءِ ... ميماً بغنةٍ مع الإخفاءِ\nوالرابعُ الإخفاءُ عند الفاضلِ ... من الحروفِ واجبٌ للفاضلِ\nفي خمسةٍ من بعدِ عشرٍ رمزُها ... في كلمِ هذا البيتِ قد ضمّنتُها:\nصِفْ ذَا ثَنَا كَمْ جَادَ شَخْصٌ قَدْ سَمَا ... دُمْ طَيِّبًا زِدْ فِي تُقًى ضَعْ ظَالِمَا',
          sourceAttribution: 'متن تحفة الأطفال للجمزوري',
        ),
        LessonSection.create(
          sectionId: 'sec_tj3_2',
          title: 'البيان التطبيقي لأحكام الإقلاب والإخفاء',
          contentType: LearningContentType.explanation,
          content: '3. الإقلاب: قلب النون الساكنة أو التنوين ميماً خالصة لفظاً لا خطاً مع بقاء الغنة والإخفاء عند حرف واحد هو «الباء»، مثل: {مِن بَعْدِ} وتلفظ [مِمْبَعْد] بتلامس الشفتين برفق دون كزّ.\n4. الإخفاء الحقيقي: نطق الحرف بصفة بين الإظهار والإدغام عارٍ عن التشديد مع بقاء الغنة بمقدار حركتين عند حروفه الـ 15 المجموعة في أوائل بيت: (صف ذا ثنا...). وتفخّم غنة الإخفاء إذا تلاها حرف استعلاء (ص، ض، ط، ظ، ق) مثل: {مِن قَبْلُ}، وترقق إذا تلاها حرف استفال مثل: {مِن ذَكَرٍ}.',
          sourceAttribution: 'العميد في علم التجويد لمحمود بسة ص 70',
        ),
      ],
      sources: const ['src_tuhfah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 4: أحكام الميم الساكنة والمشددتين
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_tajweed_meem_sakinah_mushaddadah',
      title: 'أحكام الميم الساكنة (الإخفاء والإدغام والإظهار) والنون والميم المشددتين',
      courseId: courseId,
      moduleId: 'mod_tajweed_noon_meem',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj4_1',
          title: 'التمييز بين أحكام الميم الساكنة الثلاثة وحكم الحرف المشدد',
          description: 'الإخفاء الشفوي مع الباء، وإدغام المثلين الصغير مع الميم، والإظهار الشفوي عند باقي الحروف، وغنة المشددتين.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj4_1',
          title: 'أحكام الميم الساكنة في التحفة',
          contentType: LearningContentType.sourceText,
          content: 'والميمُ إن تسكنْ تجيءْ قبل الهجا ... لا ألفٍ لينةٍ لذي الحِجَا\nأحكامُها ثلاثةٌ لمن ضبطْ ... إخفاءٌ ادغامٌ وإظهارٌ فقطْ\nفالأولُ الإخفاءُ عند الباءِ ... وسمِّهِ الشفويَّ للقرّاءِ\nوالثانِ إدغامٌ بمثلِها أتى ... وسمِّ إدغاماً صغيراً يا فتى\nوالثالثُ الإظهارُ في البقيةِ ... من أحرفٍ وسمّها شفويةِ',
          sourceAttribution: 'متن تحفة الأطفال للجمزوري',
        ),
        LessonSection.create(
          sectionId: 'sec_tj4_2',
          title: 'الشرح العملي لأحكام الميم الساكنة والمشددتين',
          contentType: LearningContentType.explanation,
          content: 'للميم الساكنة ثلاثة أحكام تخرج كلها من الشفتين: 1. الإخفاء الشفوي: إذا وقعت قبل الباء بغنة مثل: {تَرْمِيهِم بِحِجَارَةٍ}، 2. إدغام المتماثلين الصغير: إذا وقعت قبل ميم مثلها بغنة كاملة مثل: {لَهُم مَّا يَشَاءُونَ}، 3. الإظهار الشفوي: عند باقي الحروف الـ 26، وتكون أشد إظهاراً عند الواو والفاء لقرب المخرج مثل: {هُمْ فِيهَا} خيفة أن تختفي.\nأما النون والميم المشددتان فيجب فيهما الغنة الظاهرة بمقدار حركتين وصلاً ووقفاً مثل: {إِنَّ}، {عَمَّ}.',
          sourceAttribution: 'المنير في أحكام التجويد ص 88',
        ),
      ],
      sources: const ['src_tuhfah_canonical', 'src_jazariyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 5: المد الأصلي وملحقاته
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_tajweed_madd_original',
      title: 'أحكام المدود: المد الأصلي (الطبيعي) وملحقاته (البدل والعوض والصلة الصغرى)',
      courseId: courseId,
      moduleId: 'mod_tajweed_madd_makharij_sifat',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj5_1',
          title: 'معرفة حروف المد الثلاثة ومقدار المد الطبيعي وتوابعه',
          description: 'الألف الساكنة المفتوح ما قبلها، والواو الساكنة المضموم ما قبلها، والياء الساكنة المكسور ما قبلها، ومقدار حركتين.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj5_1',
          title: 'حروف المد الثلاثة وشروطها',
          contentType: LearningContentType.sourceText,
          content: 'حروف المد ثلاثة مجموعة في كلمة «نُوحِيهَا»: الألف الساكنة ولا يكون ما قبلها إلا مفتوحاً، والواو الساكنة المضموم ما قبلها، والياء الساكنة المكسور ما قبلها.',
          sourceAttribution: 'المقدمة الجزرية باب المد والقصر',
        ),
        LessonSection.create(
          sectionId: 'sec_tj5_2',
          title: 'المد الطبيعي وملحقاته',
          contentType: LearningContentType.explanation,
          content: 'المد لغة: الزيادة، واصطلاحاً: إطالة الصوت بحرف من حروف المد. والمد الأصلي هو الطبيعي الذي لا تقوم ذات الحرف إلا به ولا يتوقف على سبب من همز أو سكون، ويمد حركتين حتماً كالوقف والوصل مثل: {قَالَ}، {يَقُولُ}، {قِيلَ}. ويلحق به: 1. مد البدل: تقدم الهمز على حرف المد مثل: {آمَنُوا}، 2. مد العوض: التعويض عن تنوين الفتح ألفاً عند الوقف مثل: {عَلِيمًا}، 3. مد الصلة الصغرى: إشباع هاء الضمير للمفرد الغائب إذا وقعت بين متحركين ولم يأتِ بعدها همز مثل: {إِنَّهُۥ كَانَ}.',
          sourceAttribution: 'غاية المريد ص 115',
        ),
      ],
      sources: const ['src_tuhfah_canonical', 'src_jazariyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 6: المد الفرعي وأقسامه
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_tajweed_madd_secondary',
      title: 'المد الفرعي بسبب الهمز والسكون (المتصل والمنفصل والعارض واللازم)',
      courseId: courseId,
      moduleId: 'mod_tajweed_madd_makharij_sifat',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj6_1',
          title: 'إتقان مقادير المد الفرعي وأحكامه (الواجب والجائز واللازم)',
          description: 'المد المتصل 4-5 حركات، المنفصل 4-5 حركات (أو حركتين)، العارض 2-4-6 حركات، واللازم 6 حركات وجوباً.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj6_1',
          title: 'أقسام المد الفرعي بسبب الهمز',
          contentType: LearningContentType.explanation,
          content: 'المد الفرعي هو ما توقف على سبب من همز أو سكون: أولاً المد بسبب الهمز: 1. المد الواجب المتصل: أن يجتمع حرف المد والهمز في كلمة واحدة، ويمد 4 أو 5 حركات وجوباً مثل: {السَّمَاءِ}، {جِيءَ}، 2. المد الجائز المنفصل: أن يأتي حرف المد في آخر الكلمة والهمز في أول الكلمة التالية مثل: {يَا أَيُّهَا}، {فِي أَنفُسِكُمْ} ويمد 4 أو 5 حركات لحفص من طريق الشاطبية، 3. مد الصلة الكبرى: هاء الضمير الواقعة بين متحركين وبعدها همز مثل: {عِندَهُۥ إِلَّا بِإِذْنِهِ} وتلحق بالمنفصل.',
          sourceAttribution: 'فتح الأقفال بشرح تحفة الأطفال للجمزوري',
        ),
        LessonSection.create(
          sectionId: 'sec_tj6_2',
          title: 'أقسام المد بسبب السكون والمد اللازم',
          contentType: LearningContentType.explanation,
          content: 'ثانياً المد بسبب السكون: 1. المد العارض للسكون: أن يقع بعد حرف المد سكون عارض لأجل الوقف، وفيه القصر (2) والتوسط (4) والإشباع (6) مثل: {الْعَالَمِينَ}، 2. مد اللين: واو أو ياء ساكنتان مفتوح ما قبلهما وبعدهما سكون عارض للوقف مثل: {خَوْفٍ}، {بَيْتٍ} وفيه 2-4-6، 3. المد اللازم: أن يأتي بعد حرف المد سكون أصلي ثابت وصلاً ووقفاً، ويمد 6 حركات لزوماً، وهو كلمي (مثقل مثل: {الصَّاخَّةُ} أو مخفف مثل: {آلْآنَ})، وحرفي في فواتح السور (مثقل مثل اللام في {الم} أو مخفف مثل الميم في {الم} والصاد في {ص}).',
          sourceAttribution: 'حق التلاوة لحسني شيخ عثمان ص 130',
        ),
      ],
      sources: const ['src_tuhfah_canonical', 'src_jazariyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 7: مخارج الحروف
    // -------------------------------------------------------------------------
    final lsn7 = Lesson.create(
      lessonId: 'lsn_tajweed_makharij_letters',
      title: 'مخارج الحروف العامة الخمسة والخاصة الـ 17 وضبط النطق العربي',
      courseId: courseId,
      moduleId: 'mod_tajweed_madd_makharij_sifat',
      orderIndex: 7,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj7_1',
          title: 'حفظ مخارج الحروف العامة والخاصة وتحديد مخرج كل حرف',
          description: 'الجوف، الحلق، اللسان (10 مخارج)، الشفتان، والخيشوم، وطريقة معرفة مخرج الحرف بتسكينه.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj7_1',
          title: 'المخارج العامة والخاصة في الجزرية',
          contentType: LearningContentType.sourceText,
          content: 'مخارجُ الحروفِ سبعةَ عشرْ ... على الذي يختارُهُ من اختبرْ\nللجوفِ: ألفٌ وأختاها وهي ... حروفُ مدٍّ للهواءِ تنتهي\nثم لأقصى الحلقِ همزٌ هاءُ ... ثم لوسطهِ فعينٌ حاءُ\nأدناهُ غينٌ خاؤها والقافُ ... أقصى اللسانِ فوقُ ثم الكافُ',
          sourceAttribution: 'المقدمة الجزرية لابن الجزري',
        ),
        LessonSection.create(
          sectionId: 'sec_tj7_2',
          title: 'حصر المخارج الخمسة العامة',
          contentType: LearningContentType.explanation,
          content: '1. الجوف: مخرج تقديري لحروف المد الثلاثة، 2. الحلق: وفيه 3 مخارج لـ 6 حروف: أقصاه (همز هاء)، وسطه (عين حاء)، أدناه (غين خاء)، 3. اللسان: وفيه 10 مخارج لـ 18 حرفاً: أقصى اللسان (قاف وكاف)، وسطه (جيم شين ياء غير المدية)، حافتاه (الضاد واللام)، طرفه (النون، الراء، الطاء والدال والتاء، الصاد والزاي والسين، الظاء والذال والثاء)، 4. الشفتان: مخرجان لـ 4 حروف: بطن الشفة مع أطراف الثنايا (الفاء)، وبين الشفتين (الباء والميم والواو غير المدية)، 5. الخيشوم: مخرج الغنة.',
          sourceAttribution: 'الرعاية لتجويد القراءة لمكي بن أبي طالب ص 75',
        ),
      ],
      sources: const ['src_jazariyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    // -------------------------------------------------------------------------
    // Lesson 8: صفات الحروف والتفخيم والترقيق
    // -------------------------------------------------------------------------
    final lsn8 = Lesson.create(
      lessonId: 'lsn_tajweed_sifat_letters_tafkheem',
      title: 'صفات الحروف اللازمة والعارضة وأحكام الراء ولام لفظ الجلالة تفخيماً وترقيقاً',
      courseId: courseId,
      moduleId: 'mod_tajweed_madd_makharij_sifat',
      orderIndex: 8,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_tj8_1',
          title: 'التمييز بين الصفات التي لها ضد والتي لا ضد لها وأحكام التفخيم',
          description: 'الهمس، الشدة والرخاوة والبينية، الاستعلاء (خص ضغط قظ)، القلقلة (قطب جد)، وتفخيم وترقيق الراء واللام.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_tj8_1',
          title: 'صفات الحروف اللازمة في الجزرية',
          contentType: LearningContentType.sourceText,
          content: 'صفاتُها جهرٌ ورخوٌ مستفلْ ... منفتحٌ مصمتةٌ والضدَّ قلْ\nمهموسُها: (فحثَّهُ شخصٌ سكتْ) ... شديدُها لفظُ: (أجدْ قطٍ بكتْ)\nوبينَ رخوٍ والشديدِ: (لِنْ عُمَرْ) ... وسبعُ عُلوٍ: (خُصَّ ضغطٍ قِظْ) حَصَرْ',
          sourceAttribution: 'المقدمة الجزرية لابن الجزري',
        ),
        LessonSection.create(
          sectionId: 'sec_tj8_2',
          title: 'قواعد التفخيم والترقيق للراء ولام الجلالة',
          contentType: LearningContentType.explanation,
          content: 'حروف الهجاء من حيث التفخيم ثلاثة أقسام: 1. مفخمة دائماً: حروف الاستعلاء السبعة المجموعة في (خُصَّ ضَغْطٍ قِظْ) وأعلاها المطبق المفتوح بعده ألف، 2. مرققة دائماً: بقية الحروف المستفلة، 3. ما يفخم تارة ويرقق تارة: لام لفظ الجلالة {الله} تفخم بعد فتح أو ضم وترقق بعد كسر، والراء تفخم إذا كانت مفتوحة أو مضمومة أو ساكنة بعد فتح أو ضم، وترقق إذا كانت مكسورة أو ساكنة بعد كسر أصلي وليس بعدها حرف استعلاء مفتوح في كلمتها، والألف تتبع ما قبلها تفخيماً وترقيقاً.',
          sourceAttribution: 'غاية المريد ص 180',
        ),
      ],
      sources: const ['src_jazariyyah_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية بسِراج',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6, lsn7, lsn8];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Noon Sakinah & Tanween
    final q1 = QuizQuestion.create(
      questionId: 'q_tj_noon_1',
      lessonId: 'lsn_tajweed_noon_iqlab_ikhfa',
      questionText: 'كم عدد أحكام النون الساكنة والتنوين عند التقائها بحروف الهجاء؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qtn1_1', text: 'أربعة أحكام: الإظهار الحلقي، الإدغام، الإقلاب، الإخفاء الحقيقي'),
        QuizOption(optionId: 'opt_qtn1_2', text: 'ثلاثة أحكام: الإظهار والإدغام والمد'),
        QuizOption(optionId: 'opt_qtn1_3', text: 'ستة أحكام متفرقة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أحكام النون الساكنة والتنوين أربعة مجمع عليها: الإظهار (6 حروف حلقية)، الإدغام (6 حروف يرملون)، الإقلاب (الباء)، والإخفاء (15 حرفاً).',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_tajweed_noon_rules',
      lessonId: 'lsn_tajweed_noon_iqlab_ikhfa',
      title: 'اختبار أحكام النون الساكنة والتنوين',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Madd Rules
    final q2 = QuizQuestion.create(
      questionId: 'q_tj_madd_1',
      lessonId: 'lsn_tajweed_madd_secondary',
      questionText: 'كم يمد المد اللازم (الكلمي والحرفي) بمقدار حركي واجب الإشباع؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qtm1_1', text: 'ست حركات وجوباً وصلاً ووقفاً لجميع القراء'),
        QuizOption(optionId: 'opt_qtm1_2', text: 'أربع حركات جوازاً'),
        QuizOption(optionId: 'opt_qtm1_3', text: 'حركتان كالمثنى الطبيعي'),
      ],
      correctOptionIndices: const [0],
      explanation: 'المد اللازم سمي لازماً للزوم مده 6 حركات اتفاقاً عند كل القراء ولا يجوز قصره بحال.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_tajweed_madd_rules',
      lessonId: 'lsn_tajweed_madd_secondary',
      title: 'اختبار أحكام المدود وأنواعها ومقاديرها',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Makharij & Sifat
    final q3 = QuizQuestion.create(
      questionId: 'q_tj_makharij_1',
      lessonId: 'lsn_tajweed_sifat_letters_tafkheem',
      questionText: 'ما هي حروف الاستعلاء السبعة التي تكون مفخمة دائماً في جميع أحوالها؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qtms1_1', text: 'خُصَّ ضَغْطٍ قِظْ (الخاء، الصاد، الضاد، الغين، الطاء، القاف، الظاء)'),
        QuizOption(optionId: 'opt_qtms1_2', text: 'فحثه شخص سكت'),
        QuizOption(optionId: 'opt_qtms1_3', text: 'أجد قط بكت'),
      ],
      correctOptionIndices: const [0],
      explanation: 'حروف الاستعلاء السبعة مجموعة في قول ابن الجزري: «وسبع علو: خُصّ ضغطٍ قظ حصر»، وهي مفخمة دائماً وإن تفاوتت في مراتب التفخيم.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_tajweed_makharij_sifat',
      lessonId: 'lsn_tajweed_sifat_letters_tafkheem',
      title: 'اختبار مخارج الحروف وصفاتها وقواعد التفخيم',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
