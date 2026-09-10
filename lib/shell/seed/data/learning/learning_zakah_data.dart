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

/// بيانات مقرر فقه الزكاة والصدقات والأنصبة المعاصرة (5 دروس تأصيلية + اختبارات استيعاب)
class LearningZakahData {
  static const String courseId = 'course_fiqh_zakah_adv';
  static const String pathId = 'path_fiqh_worship_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الزكاة والصدقات والأنصبة المعاصرة',
      description: 'دراسة فقهية تأصيلية شاملة لشروط وجوب الزكاة، وحساب أنصبة الأموال النقدية والذهب والفضة والأسهم، وعروض التجارة، ومصارف الزكاة الثمانية، وزكاة الفطر وصدقة التطوع.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_zakah_pillars_assets', 'mod_zakah_recipients_fitr'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_zakah_pillars_assets',
        courseId: courseId,
        title: 'الوحدة الأولى: شروط الوجوب وأنصبة الأموال والمعاملات المعاصرة',
        description: 'بيان شروط وجوب الزكاة، وكيفية حساب زكاة الأموال النقدية والذهب وعروض التجارة والأسهم والصناديق الاستثمارية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_zakah_conditions_nisab',
          'lsn_zakah_money_gold_stocks',
          'lsn_zakah_business_livestock',
        ],
      ),
      CourseModule(
        moduleId: 'mod_zakah_recipients_fitr',
        courseId: courseId,
        title: 'الوحدة الثانية: مصارف الزكاة الثمانية وزكاة الفطر والصدقات',
        description: 'تحديد الأصناف الثمانية المستحقة للزكاة بنص القرآن، ومن لا تجزئ الزكاة إليهم، وأحكام زكاة الفطر وصدقة التطوع.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_zakah_pillars_assets'],
        lessonIds: const [
          'lsn_zakah_eight_categories',
          'lsn_zakah_fitr_voluntary',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 19: شروط وجوب الزكاة وحولان الحول وبلوغ النصاب
    // -------------------------------------------------------------------------
    final lsn1 = Lesson.create(
      lessonId: 'lsn_zakah_conditions_nisab',
      title: 'شروط وجوب الزكاة: بلوغ النصاب، وحولان الحول، والملك التام',
      courseId: courseId,
      moduleId: 'mod_zakah_pillars_assets',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_z1_1',
          title: 'معرفة شروط وجوب الزكاة الخمسة في الشريعة الإسلامية',
          description: 'الإسلام، الحرية، الملك التام، بلوغ النصاب، وحولان الحول القمري الكامل.',
        ),
        LearningObjective(
          objectiveId: 'obj_z1_2',
          title: 'استحضار مكانة الزكاة في القرآن والسنة والوعيد الشديد لمانعها',
          description: 'فهم قوله تعالى: ﴿وَالَّذِينَ يَكْنِزُونَ الذَّهَبَ وَالْفِضَّةَ﴾ وتطبيقات أبي بكر في قتال المرتدين.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_z1_1',
          title: 'ركنية الزكاة وشروط وجوبها الخمسة',
          contentType: LearningContentType.sourceText,
          content: 'الزكاة هي الركن الثالث من أركان الإسلام، قرنها الله بالصلاة في نيف وثمانين موضعاً في القرآن الكريم، قال تعالى: ﴿وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ﴾. وتشترط لوجوبها خمسة شروط: 1. الإسلام (فلا تجب على كافر تكليفاً في الدنيا)، 2. الحرية، 3. الملك التام (بأن يكون المال تحت يد صاحبه وتصرفه فلا تجب في المال الضائع أو المغصوب حتى يقبض)، 4. بلوغ النصاب (وهو المقدار المحدد شرعاً الذي لا تجب الزكاة في أقل منه)، 5. مضي حول قمري كامل (12 شهراً هجرياً) على ملك النصاب عدا المعشرات (الحبوب والثمار والركاز فتزكّى يوم حصادها).',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z1_quran',
              evidenceKey: '9:103',
              citation: 'سورة التوبة: الآية 103 ﴿خُذْ مِنْ أَمْوَالِهِمْ صَدَقَةً تُطَهِّرُهُمْ وَتُزَكِّيهِم بِهَا﴾',
              sourceId: 'src_quran_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 2 ص 430',
        ),
        LessonSection.create(
          sectionId: 'sec_z1_2',
          title: 'الأموال التي تجب فيها الزكاة والوعيد لمانعها',
          contentType: LearningContentType.explanation,
          content: 'تجب الزكاة في أربعة أصناف من الأموال: 1. النقدان (الذهب والفضة والأوراق النقدية المعاصرة ورصيد الحسابات)، 2. عروض التجارة (كل ما أُعد للبيع والربح)، 3. بهيمة الأنعام السائمة (الإبل والبقر والغنم)، 4. الخارج من الأرض من الحبوب والثمار والمعادن. ومانع الزكاة بخلاً مع الإقرار بوجوبها يرتكب كبيرة عظمى تؤخذ منه قهراً ويعزر، وتوعده الله يوم القيامة بأن يُصفح له ماله صفائح من نار يكوى بها جبينه وجنبه وظهره، لقول النبي ﷺ في صحيح مسلم: «ما من صاحب كنز لا يؤدي حقه إلا جُعل له يوم القيامة صفائح من نار...».',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z1_muslim_kanz',
              evidenceKey: 'hadith_muslim_kanz',
              citation: 'صحيح مسلم رقم 987 من حديث أبي هريرة رضي الله عنه',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'المجموع شرح المهذب ج 5 ص 310',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_muslim_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 20: زكاة النقدين والذهب والأسهم والصناديق
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_zakah_money_gold_stocks',
      title: 'زكاة النقدين والعملات الورقية والذهب والحلي والأسهم المعاصرة',
      courseId: courseId,
      moduleId: 'mod_zakah_pillars_assets',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_z2_1',
          title: 'معرفة نصاب الذهب (85 جراماً) والفضة (595 جراماً) ونسبة الإخراج (2.5%)',
          description: 'كيفية تقويم العملات الورقية المعاصرة بالأقل من نصابي الذهب والفضة حظاً للفقراء.',
        ),
        LearningObjective(
          objectiveId: 'obj_z2_2',
          title: 'إتقان حساب زكاة الأسهم الاستثمارية والشركات والصناديق',
          description: 'التمييز بين الأسهم المعدة للمضاربة فتزكى بالقيمة السوقية، والأسهم الاستثمارية الاستغلالية.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_z2_1',
          title: 'نصاب الذهب والفضة والأوراق النقدية المعاصرة',
          contentType: LearningContentType.sourceText,
          content: 'نصاب الذهب الشرعي عشرون مثقالاً ويعادل بالوزن المعاصر (85 جراماً من الذهب الخالص عيار 24). ونصاب الفضة مائتا درهم ويعادل (595 جراماً من الفضة النقية). والقدر الواجب إخراجه ربع العشر، أي (2.5%). والعملات الورقية المعاصرة (كالريال والدينار والجنيه والدولار) ملحقة بالنقدين في جريان الربا ووجوب الزكاة فيها، ويُقدر نصابها بما يعادل قيمة 85 جراماً من الذهب أو 595 جراماً من الفضة، فإذا بلغ مجموع أموال المسلم النقدية والودائع البنكية النصاب وحال عليها الحول وجب إخراج 2.5% منها للفقراء.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z2_bukhari_rubu',
              evidenceKey: 'hadith_bukhari_zakah_rubu',
              citation: 'صحيح البخاري رقم 1454 في كتاب الصدقة لرسول الله ﷺ',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي رقم 42 (5/5)',
        ),
        LessonSection.create(
          sectionId: 'sec_z2_2',
          title: 'زكاة الحلي والأسهم والصناديق الاستثمارية',
          contentType: LearningContentType.example,
          content: '1. حلي المرأة من الذهب والفضة: إذا كان معداً للادخار أو التجارة وجبت فيه الزكاة إجماعاً، وإذا كان معداً للاستعمال المعتاد المباح فالراجح عند الجمهور عدم وجوب الزكاة فيه، والأحوط إخراج زكاته خروجاً من الخلاف.\n2. الأسهم والصناديق: أ) إذا اشتراها بقصد التجارة والمضاربة اليومية أو الشهرية فيزكي قيمتها السوقية كاملة يوم حولان الحول بنسبة 2.5%. ب) إذا اشتراها بقصد الاستثمار طويل الأجل والاستفادة من الأرباح السنوية: فإن كانت الشركة تزكي أجزأته، وإن لم تزك زكى الأصول الزكوية للشركة (النقد والسيولة والبضائع المعدة للبيع) دون الأصول الثابتة (المباني والمعدات والآلات).',
          sourceAttribution: 'فقه الزكاة المعاصر للدكتور القرضاوي ج 1 ص 480',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_mughni_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 21: زكاة عروض التجارة والديون والأنصبة
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_zakah_business_livestock',
      title: 'زكاة عروض التجارة والديون والزروع وبهيمة الأنعام',
      courseId: courseId,
      moduleId: 'mod_zakah_pillars_assets',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_z3_1',
          title: 'معرفة كيفية تقويم عروض التجارة في نهاية الحول',
          description: 'تقويم البضائع المعدة للبيع بسعر الجملة وقت الحول وضم السيولة النقدية إليها.',
        ),
        LearningObjective(
          objectiveId: 'obj_z3_2',
          title: 'التمييز بين الدين المرجو والدين الميؤوس منه وزكاة الزروع',
          description: 'الدين المرجو السداد يزكى كل عام، وغير المرجو يزكى لعام واحد عند قبضه، والزروع عند الحصاد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_t3_1',
          title: 'فقه زكاة عروض التجارة والديون',
          contentType: LearningContentType.explanation,
          content: 'عروض التجارة هي كل ما أعده المسلم للبيع والشراء بقصد الربح والتجارة، سواء كانت عقارات، أو سيارات، أو بضائع استهلاكية، أو أقمشة. وطريقة حسابها: يقوم التاجر البضائع الموجودة في متجره ومستودعاته في نهاية الحول بسعرها الحالي في السوق (سعر الجملة لا سعر التكلفة القديم)، ويجمع إليها السيولة النقدية الموجودة في الخزينة والحسابات والديون المرجوة السداد على الناس، ثم يطرح الديون العاجلة الحالة عليه، فإن بلغ الباقي النصاب أخرج 2.5%. أما الديون: فما كان مرجو الأداء زكاه كل عام، وما كان على معسر أو مماطل زكاه لعام واحد فقط إذا قبضه.',
          sourceAttribution: 'المغني لابن قدامة ج 2 ص 500',
        ),
        LessonSection.create(
          sectionId: 'sec_t3_2',
          title: 'زكاة الزروع والثمار وبهيمة الأنعام',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: ﴿وَآتُوا حَقَّهُ يَوْمَ حَصَادِهِ﴾ [الأنعام: 141]. تجب الزكاة في الحبوب والثمار المدخرة كالحنطة والشعير والتمر والزبيب إذا بلغت خمسة أوسق (نحو 612 كجم)، وقدر الواجب: العُشر (10%) فيما سُقي بلا كلفة كالأمطار والعيون، ونصف العشر (5%) فيما سُقي بالآلات والمضخات ومكائن الري المكلفة. وتجب الزكاة في بهيمة الأنعام السائمة التي ترعى في المرعى الطبيعي المباح أكثر الحول، ولها أنصبة مفصلة في السنة النبوية المطهرة.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z3_bukhari_ushr',
              evidenceKey: 'hadith_bukhari_ushr',
              citation: 'صحيح البخاري رقم 1483: «فيما سقت السماء والعيون أو كان عثرياً العشر، وفيما سقي بالنضح نصف العشر»',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'بداية المجتهد ج 1 ص 248',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 22: مصارف الزكاة الثمانية وضوابطها الشرعية
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_zakah_eight_categories',
      title: 'مصارف الزكاة الثمانية المنصوص عليها في القرآن ومن تحرم عليهم',
      courseId: courseId,
      moduleId: 'mod_zakah_recipients_fitr',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_z4_1',
          title: 'حفظ مصارف الزكاة الثمانية المذكورة في سورة التوبة',
          description: 'الفقراء، المساكين، العاملون عليها، المؤلفة قلوبهم، في الرقاب، الغارمون، في سبيل الله، وابن السبيل.',
        ),
        LearningObjective(
          objectiveId: 'obj_z4_2',
          title: 'معرفة من تحرم عليهم الزكاة كالأصول والفروع وآل النبي ﷺ والغني المكتسب',
          description: 'تحريم صرف الزكاة للوالدين والأولاد لمن تلزمه نفقتهم، وشرف آل محمد عن أوساخ الناس.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_z4_1',
          title: 'المصارف الثمانية بنص القرآن الكريم',
          contentType: LearningContentType.sourceText,
          content: 'حدد الله تعالى مصارف الزكاة الثمانية حصراً في كتابه العزيز لقطع أطماع الخلق، فقال سبحانه: ﴿إِنَّمَا الصَّدَقَاتُ لِلْفُقَرَاءِ وَالْمَسَاكِينِ وَالْعَامِلِينَ عَلَيْهَا وَالْمُؤَلَّفَةِ قُلُوبُهُمْ وَفِي الرِّقَابِ وَالْغَارِمِينَ وَفِي سَبِيلِ اللَّهِ وَابْنِ السَّبِيلِ ۖ فَرِيضَةً مِّنَ اللَّهِ ۗ وَاللَّهُ عَلِيمٌ حَكِيمٌ﴾ [التوبة: 60]. \n1. الفقراء: من لا يجدون شيئاً أو يجدون أقل من نصف كفايتهم.\n2. المساكين: من يجدون نصف كفايتهم ولا يجدون تمامها.\n3. العاملون عليها: الجباة والسعاة القائمون على جمعها وحفظها.\n4. المؤلفة قلوبهم: سادة القوم ومن يرجى إسلامهم أو كف شرهم وتثبيت إيمانهم.\n5. في الرقاب: إعانة المكاتبين وأسرى المسلمين.\n6. الغارمون: أصحاب الديون لعجز في معايشهم أو لإصلاح ذات البين.\n7. في سبيل الله: الغزاة والمجاهدون والدعوة إلى الله وما يعين عليها.\n8. ابن السبيل: المسافر المنقطع به في غير بلده فيعطى ما يبلغه وطنه.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z4_tawbah_60',
              evidenceKey: '9:60',
              citation: 'سورة التوبة: الآية 60',
              sourceId: 'src_quran_canonical',
            ),
          ],
          sourceAttribution: 'تفسير ابن كثير ج 4 ص 165',
        ),
        LessonSection.create(
          sectionId: 'sec_z4_2',
          title: 'من تحرم عليهم الزكاة ولا يجوز دفعها إليهم',
          contentType: LearningContentType.scholarlyView,
          content: 'تحرم الزكاة على أصناف محددة: 1. الغني بماله أو كسبه المعتدل لقوله ﷺ: «لا تحل الصدقة لغني ولا لذي مِرّة سَوِيّ»، 2. آل النبي ﷺ (بنو هاشم ومواليهم) إكراماً لهم لحديث: «إن هذه الصدقات إنما هي أوساخ الناس، وإنها لا تحل لمحمد ولا لآل محمد»، 3. الأصول (الآباء والأمهات والأجداد) والفروع (الأولاد وأولادهم) الذين تلزم المزكي نفقتهم، فلا يدفع زكاته ليسقط عن نفسه واجباً، وتجوز للإخوة والأخوات والأعمام والفقراء من الأقارب إن لم تلزمه نفقتهم بل هي أفضل: صدقة وصلة.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z4_muslim_al_muhammad',
              evidenceKey: 'hadith_muslim_al_muhammad',
              citation: 'صحيح مسلم رقم 1072 من حديث عبد المطلب بن ربيعة رضي الله عنه',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'المجموع للنووي ج 6 ص 220',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 23: زكاة الفطر وفضل صدقة التطوع
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_zakah_fitr_voluntary',
      title: 'زكاة الفطر: حكمها، ومقدارها، ووقتها، ومقاصدها وفضل صدقة التطوع',
      courseId: courseId,
      moduleId: 'mod_zakah_recipients_fitr',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_z5_1',
          title: 'معرفة حكم زكاة الفطر وعلى من تجب ومقدار الصاع النبوي',
          description: 'فرض على كل مسلم صغيراً أو كبيراً يملك قوت يومه وليلته، ومقدارها صاع (نحو 2.5 - 3 كجم).',
        ),
        LearningObjective(
          objectiveId: 'obj_z5_2',
          title: 'إتقان أوقات إخراجها (وقت الجواز والوجوب والاستحباب وقضاء)',
          description: 'قبل صلاة العيد أفضل، ويوم أو يومين قبل العيد جائز، وبعد الصلاة قضاء مع الإثم.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_z5_1',
          title: 'مشروعية زكاة الفطر وحكمتها ومقدارها',
          contentType: LearningContentType.sourceText,
          content: 'فرض رسول الله ﷺ زكاة الفطر صاعاً من تمر أو صاعاً من شعير على العبد والحر والذكر والأنثى والصغير والكبير من المسلمين، وأمر بها أن تؤدى قبل خروج الناس إلى الصلاة [متفق عليه]. وحكمتها طهرة للصائم من اللغو والرفث وطعمة للمساكين وإغناء لهم عن السؤال في يوم الفرح والسرور. وتجب على كل مسلم يفضل عن قوته وقوت عياله يوم العيد وليلته صاع، ويخرجها عن نفسه وعمن تلزمه نفقته كالزوجة والأولاد. ومقدار الصاع النبوي أربعة أمداد باليدين المعتدلتين، ويعادل بالوزن نحو (2.5 إلى 3 كجم) من غالب قوت البلد كالأرز أو القمح أو التمر.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z5_bukhari_fitr',
              evidenceKey: 'hadith_bukhari_fitr',
              citation: 'صحيح البخاري رقم 1503 وصحيح مسلم رقم 984 من حديث ابن عمر رضي الله عنهما',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'فتح الباري لابن حجر ج 3 ص 367',
        ),
        LessonSection.create(
          sectionId: 'sec_z5_2',
          title: 'أوقات إخراج زكاة الفطر وفضائل صدقة التطوع',
          contentType: LearningContentType.example,
          content: 'أوقات زكاة الفطر: \n1. وقت الجواز: قبل العيد بيوم أو يومين (يوم 28 أو 29 رمضان) لفعل ابن عمر والصحابة.\n2. وقت الفضيلة والاستحباب: صباح يوم العيد قبل الخروج إلى صلاة العيد.\n3. وقت التحريم والإثم: تأخيرها حتى تغرب شمس يوم العيد بلا عذر، فإن صلاها بعد الصلاة كانت صدقة من الصدقات مع الإثم.\nوأما صدقة التطوع: فمستحبة في كل وقت، وتطفئ غضب الرب، وتدفع ميتة السوء، وتظل صاحبها يوم القيامة في ظل عرش الرحمن حتى يقضى بين الناس.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_z5_abu_dawood',
              evidenceKey: 'hadith_abu_dawood_fitr',
              citation: 'سنن أبي داود رقم 1609: «من أداها قبل الصلاة فهي زكاة مقبولة، ومن أداها بعد الصلاة فهي صدقة من الصدقات»',
              sourceId: 'src_hadith_sunan',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 2 ص 650',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Zakah conditions
    final q1 = QuizQuestion.create(
      questionId: 'q_zakah_cond_1',
      lessonId: 'lsn_zakah_conditions_nisab',
      questionText: 'كم يعادل نصاب الذهب الشرعي بالجرام المعاصر عيار 24؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_zk1_1', text: '85 جراماً من الذهب الخالص (عشرون مثقالاً)'),
        QuizOption(optionId: 'opt_zk1_2', text: '50 جراماً'),
        QuizOption(optionId: 'opt_zk1_3', text: '120 جراماً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'النصاب الشرعي للذهب عشرون ديناراً ذهبياً، والدينار مثقال يعادل 4.25 جراماً، فيكون 20 × 4.25 = 85 جراماً خالصاً.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_zakah_conditions',
      lessonId: 'lsn_zakah_conditions_nisab',
      title: 'اختبار شروط وجوب الزكاة والأنصبة',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Recipients
    final q2 = QuizQuestion.create(
      questionId: 'q_zakah_recip_1',
      lessonId: 'lsn_zakah_eight_categories',
      questionText: 'هل يجوز للمسلم إعطاء زكاة ماله الواجبة لوالديه الفقيرين اللذين تلزمه نفقتهما؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_zr1_1', text: 'لا يجوز إجماعاً لأن نفقتهما واجبة عليه بماله الخاص'),
        QuizOption(optionId: 'opt_zr1_2', text: 'يجوز ومستحب مطلقاً'),
        QuizOption(optionId: 'opt_zr1_3', text: 'يجوز في زكاة الفطر دون زكاة المال'),
      ],
      correctOptionIndices: const [0],
      explanation: 'أجمع الفقهاء على أنه لا يجوز دفع الزكاة للوالدين ولا للأولاد إن كان إنفاقه عليهم واجباً، حتى لا يسقط واجباً بمال الزكاة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_zakah_recipients',
      lessonId: 'lsn_zakah_eight_categories',
      title: 'اختبار مصارف الزكاة الثمانية',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Zakat al-Fitr
    final q3 = QuizQuestion.create(
      questionId: 'q_zakah_fitr_1',
      lessonId: 'lsn_zakah_fitr_voluntary',
      questionText: 'ما أفضل وقت مستحب لإخراج زكاة الفطر؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_zf1_1', text: 'صباح يوم العيد قبل الخروج إلى صلاة العيد'),
        QuizOption(optionId: 'opt_zf1_2', text: 'في أول ليلة من شهر رمضان'),
        QuizOption(optionId: 'opt_zf1_3', text: 'بعد صلاة العيد بأيام في أيام التشريق'),
      ],
      correctOptionIndices: const [0],
      explanation: 'السنة الثابتة عن النبي ﷺ وأصحابه إخراجها صباح يوم الفطر قبل الخروج إلى المصلى لإغناء الفقراء عن السؤال يوم العيد.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_zakah_fitr',
      lessonId: 'lsn_zakah_fitr_voluntary',
      title: 'اختبار زكاة الفطر وصدقة التطوع',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
