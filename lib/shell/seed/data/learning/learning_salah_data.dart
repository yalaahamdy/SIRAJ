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

/// بيانات مقرر فقه الصلاة وسجود السهو والجماعة والجنائز (9 دروس تأصيلية + اختبارات استيعاب)
class LearningSalahData {
  static const String courseId = 'course_fiqh_salah_adv';
  static const String pathId = 'path_fiqh_worship_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الصلاة وسجود السهو وصلاة الجماعة والجنائز',
      description: 'دراسة تأصيلية شاملة لشروط وأركان وواجبات الصلاة، وهيئتها النبوية، وسجود السهو، وصلاة الجماعة، وصلوات أهل الأعذار، وسنن التطوع، وأحكام الجنائز.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_salah_conditions_pillars', 'mod_salah_sahw_jamaah_excuses'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_salah_conditions_pillars',
        courseId: courseId,
        title: 'الوحدة الأولى: الشروط والأركان والواجبات والصفة النبوية',
        description: 'بيان شروط الصلاة التسعة، وأركانها الـ 14، وواجباتها الـ 8، ومكروهاتها ومبطلاتها وصفة صلاة النبي ﷺ.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_salah_conditions_adv',
          'lsn_salah_pillars_duties_adv',
          'lsn_salah_prophetic_manner',
          'lsn_salah_disliked_invalidators',
        ],
      ),
      CourseModule(
        moduleId: 'mod_salah_sahw_jamaah_excuses',
        courseId: courseId,
        title: 'الوحدة الثانية: سجود السهو والجماعة وصلوات الأعذار والجنائز',
        description: 'الأحكام التطبيقية لقواعد السهو في الصلاة، وفقه الإمامة والمسبوق، وصلاة المريض والمسافر والجمعة والجنائز.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_salah_conditions_pillars'],
        lessonIds: const [
          'lsn_salah_sahw_prostrations',
          'lsn_salah_jamaah_imamah',
          'lsn_salah_excuses_travel_illness',
          'lsn_salah_friday_eids_voluntary',
          'lsn_salah_funeral_janazah',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 10: شروط صحة الصلاة ومواقيتها واستقبال القبلة
    // -------------------------------------------------------------------------
    final lsn1 = Lesson.create(
      lessonId: 'lsn_salah_conditions_adv',
      title: 'شروط صحة الصلاة ومواقيتها الشرعية واستقبال القبلة',
      courseId: courseId,
      moduleId: 'mod_salah_conditions_pillars',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s1_1',
          title: 'حفظ شروط صحة الصلاة التسعة والفرق بين الشرط والركن',
          description: 'الإسلام، العقل، التمييز، رفع الحدث، إزالة النجاسة، ستر العورة، دخول الوقت، استقبال القبلة، النية.',
        ),
        LearningObjective(
          objectiveId: 'obj_s1_2',
          title: 'معرفة حدود عورة الرجل والمرأة في الصلاة ومواقيتها المحددة',
          description: 'عورة الرجل من السرة إلى الركبة، والمرأة كلها عورة في الصلاة عدا الوجه والكفين.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s1_1',
          title: 'الشروط التسعة ومواقيت الصلاة',
          contentType: LearningContentType.sourceText,
          content: 'الشرط في الفقه: ما يلزم من عدمه العدم ولا يلزم من وجوده وجود ولا عدم لذاته، ويسبق العبادة ويستمر معها. وشروط الصلاة تسعة: 1. الإسلام، 2. العقل، 3. التمييز (ببلوغ 7 سنوات)، 4. رفع الحدث الأصغر والأكبر، 5. إزالة النجاسة عن البدن والثوب ومكان الصلاة، 6. ستر العورة بلباس مباح لا يصف البشرة (عورة الرجل من السرة للركبة، والمرأة كلها عورة عدا وجهها وكفيها)، 7. دخول الوقت بيقين أو غلبة ظن لقوله تعالى: ﴿إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا﴾ [النساء: 103]، 8. استقبال عين القبلة للقريب وجهتها للبعيد، 9. النية الجازمة ومحلها القلب.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s1_quran',
              evidenceKey: '4:103',
              citation: 'سورة النساء: الآية 103',
              sourceId: 'src_quran_canonical',
            ),
          ],
          sourceAttribution: 'شروط الصلاة وأركانها وواجباتها للشيخ محمد بن عبد الوهاب ص 5',
        ),
        LessonSection.create(
          sectionId: 'sec_s1_2',
          title: 'أحكام ستر العورة والاشتباه في القبلة',
          contentType: LearningContentType.explanation,
          content: 'إذا انكشفت العورة في الصلاة يسيرة بلا قصد أو انكشفت كثيراً فسترها في الحال من غير عمل كثير صحت صلاته، وإن تعمد كشفها بطلت. وفي استقبال القبلة: يجب على من عاين الكعبة استقبال عينها، ومن غاب عنها استقبل جهتها. وإذا كان في بر أو سفر واشتبهت عليه القبلة تحرى واجتهد وصلى، ولا تلزمه الإعادة إذا تبين خطؤه بعد ذلك لقوله تعالى: ﴿فَأَيْنَمَا تُوَلُّوا فَثَمَّ وَجْهُ اللَّهِ﴾.',
          sourceAttribution: 'المجموع شرح المهذب ج 3 ص 180',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 11: أركان الصلاة الـ 14 وواجباتها وسننها
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_salah_pillars_duties_adv',
      title: 'أركان الصلاة الأربعة عشر وواجباتها الثمانية والسنن',
      courseId: courseId,
      moduleId: 'mod_salah_conditions_pillars',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s2_1',
          title: 'التمييز الدقيق بين الركن والواجب والسنة',
          description: 'الركن لا يسقط سهواً ولا عمداً، والواجب يسقط سهواً ويجبر بسجود السهو، والسنة لا تبطل الصلاة بتركها.',
        ),
        LearningObjective(
          objectiveId: 'obj_s2_2',
          title: 'حفظ أركان الصلاة الـ 14 وواجباتها الـ 8 بالتفصيل',
          description: 'الطمأنينة ركن أساسي، والتشهد الأول واجب، والتسبيحات واجبات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s2_1',
          title: 'أركان الصلاة الأربعة عشر بالتفصيل',
          contentType: LearningContentType.explanation,
          content: 'أركان الصلاة 14 ركناً: 1. القيام مع القدرة في الفرض، 2. تكبيرة الإحرام (الله أكبر)، 3. قراءة الفاتحة في كل ركعة، 4. الركوع، 5. الرفع من الركوع، 6. الاعتدال قائماً، 7. السجود على الأعضاء السبعة (الجبهة مع الأنف، والكفين، والركبتين، وأطراف القدمين)، 8. الرفع من السجود، 9. الجلوس بين السجدتين، 10. الطمأنينة (وهي السكون بقدر الذكر الواجب في كل ركن فعلي)، 11. التشهد الأخير، 12. الجلوس للتشهد الأخير، 13. التسليمتان (والأولى فرض باتفاق)، 14. الترتيب بين الأركان.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s2_bukhari_musii',
              evidenceKey: 'hadith_bukhari_musii',
              citation: 'صحيح البخاري رقم 757 في حديث المسيء صلاته',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 520',
        ),
        LessonSection.create(
          sectionId: 'sec_s2_2',
          title: 'الواجبات الثمانية والفرق بينها وبين السنن',
          contentType: LearningContentType.scholarlyView,
          content: 'واجبات الصلاة 8: 1. جميع التكبيرات غير تكبيرة الإحرام (تكبيرات الانتقال)، 2. قول: «سمع الله لمن حمده» للإمام والمنفرد، 3. قول: «ربنا ولك الحمد» للكل، 4. قول: «سبحان ربي العظيم» مرة في الركوع، 5. قول: «سبحان ربي الأعلى» مرة في السجود، 6. قول: «رب اغفر لي» بين السجدتين، 7. التشهد الأول، 8. الجلوس للتشهد الأول. إذا ترك المصلي واجباً عمداً بطلت صلاته، وإن تركه سهواً سجد للسهو قبل السلام أو بعده وصحت صلاته. أما السنن القولية (كدعاء الاستفتاح والتعوذ والسورة بعد الفاتحة) والفعلية (كرفع اليدين ووضع اليمنى على اليسرى والافتراش والتورك) فلا تبطل الصلاة بتركها عمداً ولا سهواً.',
          sourceAttribution: 'كشاف القناع ج 1 ص 385',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_mughni_canonical', 'src_kashaf_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 12: صفة الصلاة النبوية الكاملة
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_salah_prophetic_manner',
      title: 'صفة صلاة النبي ﷺ الكاملة من التكبير إلى التسليم',
      courseId: courseId,
      moduleId: 'mod_salah_conditions_pillars',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s3_1',
          title: 'تطبيق هدي النبي ﷺ في هيئة الركوع والاعتدال والسجود والجلوس',
          description: 'تحقيق قوله ﷺ: «صلوا كما رأيتموني أصلي».',
        ),
        LearningObjective(
          objectiveId: 'obj_s3_2',
          title: 'معرفة صيغ الأدعية والأذكار المأثورة في الصلاة',
          description: 'دعاء الاستفتاح، التشهد بصيغة ابن مسعود، والصلاة الإبراهيمية، والتعوذ من الأربع.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s3_1',
          title: 'الصفة النبوية من تكبيرة الإحرام حتى الرفع من الركوع',
          contentType: LearningContentType.sourceText,
          content: 'قال ﷺ: «صَلُّوا كما رَأَيْتُمُونِي أُصَلِّي» [رواه البخاري]. يقف المصلي مستقبلاً القبلة ناوياً بقلبه، ثم يكبر رافعاً يديه حذو منكبيه أو فروع أذنيه، ويضع يده اليمنى على ظهر كفه اليسرى والرسغ والساعد على صدره، ويقرأ دعاء الاستفتاح: «سبحانك اللهم وبحمدك وتبارك اسمك وتعالى جدك ولا إله غيرك»، ثم يتعوذ ويبسمل ويقرأ الفاتحة، ثم يقرأ ما تيسر من القرآن، ثم يكبر للركوع رافعاً يديه، ويضع كفيه مفرجتي الأصابع على ركبتيه قابضاً عليهما مادا ظهره مستوياً لا يشخص رأسه ولا يصوبه، ويقول: «سبحان ربي العظيم» ثلاثاً، ثم يرفع رأسه قائلاً: «سمع الله لمن حمده» رافعاً يديه، فإذا استوى قائماً قال: «ربنا ولك الحمد حمداً كثيراً طيباً مباركاً فيه ملء السماوات وملء الأرض وملء ما شئت من شيء بعد».',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s3_bukhari_sallu',
              evidenceKey: 'hadith_bukhari_sallu',
              citation: 'صحيح البخاري رقم 631 من حديث مالك بن الحويرث رضي الله عنه',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'صفة صلاة النبي ﷺ للألباني ص 85',
        ),
        LessonSection.create(
          sectionId: 'sec_s3_2',
          title: 'الصفة النبوية في السجود والتشهد والتسليم',
          contentType: LearningContentType.example,
          content: 'يهوي المصلي ساجداً مكبراً على أعضائه السبعة مكنّاً جبهته وأنفه من الأرض، مجافياً عضديه عن جنبيه وبطنه عن فخذيه، ويقول: «سبحان ربي الأعلى» ثلاثاً ويجتهد في الدعاء، ثم يرفع رأسه مكبراً ويجلس مفترشاً رجله اليسرى وناصباً اليمنى قائلاً: «رب اغفر لي، رب اغفر لي»، ثم يسجد الثانية كذلك. وفي التشهد الأخير: يجلس متوركاً في الصلاة الثلاثية والرباعية، ويقرأ تشهد ابن مسعود: «التحيات لله والصلوات والطيبات، السلام عليك أيها النبي ورحمة الله وبركاته...»، ثم يصلي الصلاة الإبراهيمية، ويتعوذ بالله من أربع: «اللهم إني أعوذ بك من عذاب جهنم، ومن عذاب القبر، ومن فتنة المحيا والممات، ومن شر فتنة المسيح الدجال»، ثم يسلم عن يمينه: «السلام عليكم ورحمة الله» وعن يساره كذلك.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s3_muslim_four',
              evidenceKey: 'hadith_muslim_four_refuges',
              citation: 'صحيح مسلم رقم 588 من حديث أبي هريرة رضي الله عنه',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'زاد المعاد في هدي خير العباد ج 1 ص 215',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_zad_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 13: مكروهات الصلاة ومبطلاتها ومسائل الخشوع
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_salah_disliked_invalidators',
      title: 'مكروهات الصلاة ومبطلاتها وأسباب تحصيل الخشوع',
      courseId: courseId,
      moduleId: 'mod_salah_conditions_pillars',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s4_1',
          title: 'معرفة مبطلات الصلاة المتفق عليها لاجتنابها',
          description: 'الكلام العمد، الأكل والشرب، الحركة الكثيرة المتوالية، انتقاض الطهارة، الضحك والقهقهة.',
        ),
        LearningObjective(
          objectiveId: 'obj_s4_2',
          title: 'تجنب المكروهات كالالتفات والافتراش كالسّبع ومدافعة الأخبثين',
          description: 'معرفة هدي النبي ﷺ في الخشوع وتفريغ القلب للصلاة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s4_1',
          title: 'مبطلات الصلاة التي تفسدها وتوجب إعادتها',
          contentType: LearningContentType.explanation,
          content: 'تبطل الصلاة بأحد الأمور الآتية: 1. ترك شرط من شروط الصلاة بلا عذر (كانتقاض الوضوء، أو انكشاف العورة عمداً، أو الانحراف عن القبلة بالبدن كله)، 2. ترك ركن من الأركان عمداً أو سهواً إذا لم يأتِ به، 3. الكلام العمد لغير مصلحة الصلاة، لحديث زيد بن أرقم: «كنا نتكلم في الصلاة حتى نزلت: ﴿وَقُومُوا لِلَّهِ قَانِتِينَ﴾ فأُمرنا بالسكوت ونُهينا عن الكلام»، 4. القهقهة والضحك بصوت، 5. الأكل والشرب عمداً، 6. الحركة الكثيرة المتوالية لغير ضرورة، 7. زيادة ركن فعلي عمداً كالركوع مرتين عمداً في ركعة.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s4_bukhari_kalam',
              evidenceKey: 'hadith_bukhari_kalam',
              citation: 'صحيح البخاري رقم 1200 وصحيح مسلم رقم 539',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المجموع للنووي ج 4 ص 90',
        ),
        LessonSection.create(
          sectionId: 'sec_s4_2',
          title: 'مكروهات الصلاة وأعظم وسائل تحصيل الخشوع',
          contentType: LearningContentType.example,
          content: 'يكره في الصلاة: الالتفات بالوجه أو البصر لغير حاجة لقوله ﷺ: «هو اختلاس يختلسه الشيطان من صلاة العبد»، وافتراش الذراعين في السجود كالكلب، وتغميض العينين لغير حاجة، ومدافعة الأخبثين (البول والغائط) أو بحضرة طعام يشتهيه لقوله ﷺ: «لا صلاة بحضرة الطعام ولا وهو يدافعه الأخبثان»، والعبث بالثياب وشبك الأصابع. ومن وسائل الخشوع: تدبر معاني الآيات والأذكار، واستشعار الوقوف بين يدي الله ملك الملوك، وتذكر الموت وأنها صلاة مودع، والنظر إلى موضع السجود.',
          sourceAttribution: 'الخشوع في الصلاة لابن رجب الحنبلي ص 22',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 14: سجود السهو: أسبابه الثلاثة ومواضعه وقواعده
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_salah_sahw_prostrations',
      title: 'سجود السهو: أسبابه الثلاثة، وقواعده، ومواضعه قبل السلام وبعده',
      courseId: courseId,
      moduleId: 'mod_salah_sahw_jamaah_excuses',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s5_1',
          title: 'حصر أسباب سجود السهو الثلاثة (الزيادة، النقص، الشك)',
          description: 'فهم كيفية جبر الخلل العارض في الصلاة بركعتين خفيفتين.',
        ),
        LearningObjective(
          objectiveId: 'obj_s5_2',
          title: 'التمييز الدقيق بين مواضع السجود قبل السلام وبعد السلام',
          description: 'السجود قبل السلام في النقص والشك مع التردد، وبعد السلام في الزيادة والشك مع غلبة الظن.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s5_1',
          title: 'أسباب سجود السهو وقواعده الشرعية',
          contentType: LearningContentType.sourceText,
          content: 'سجود السهو سجدتان يسجدهما المصلي جبراً للخلل الحاصل في صلاته. وأسبابه ثلاثة محصورة: 1. الزيادة: كأن يزيد ركوعاً أو سجوداً أو ركعة سهواً، 2. النقص: كأن ينقص واجباً من واجبات الصلاة كالجلوس للتشهد الأول أو تسبيح الركوع، أو ينقص ركناً فيتذكره ويأتي به ثم يجبر السهو، 3. الشك: بأن يتردد هل صلى ثلاثاً أم أربعاً، فإن بنى على اليقين وهو الأقل سجد، وإن غلب على ظنه أحد الأمرين عمل به وسجد.',
          sourceAttribution: 'رسالة في سجود السهو للشيخ ابن عثيمين ص 8',
        ),
        LessonSection.create(
          sectionId: 'sec_s5_2',
          title: 'ضابط السجود قبل السلام وبعد السلام',
          contentType: LearningContentType.example,
          content: 'القاعدة الضابطة لموضع سجود السهو: \n1. يسجد قبل السلام في موضعين: أ) إذا كان السهو عن نقص (كنسيان التشهد الأول لحديث عبد الله بن بحينة)، ب) إذا كان السهو عن شك لم يترجح فيه أحد الأمرين وبنى على اليقين وهو الأقل لحديث أبي سعيد الخدري.\n2. يسجد بعد السلام في موضعين: أ) إذا كان السهو عن زيادة (كصلاة خمس ركعات في الظهر لحديث ابن مسعود، أو السلام من ركعتين في الصلاة الرباعية لحديث ذي اليدين)، ب) إذا كان السهو عن شك وترجح عنده أحد الأمرين بغلبة الظن فيتم عليه ويسلم ثم يسجد سجدتي السهو ويسلم ثانية.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s5_dhul_yadayn',
              evidenceKey: 'hadith_bukhari_dhul_yadayn',
              citation: 'صحيح البخاري رقم 482 وصحيح مسلم رقم 573 في حديث ذي اليدين',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'الشرح الممتع لابن عثيمين ج 3 ص 375',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_mumti_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 15: صلاة الجماعة وأحكام الإمامة والمسبوق
    // -------------------------------------------------------------------------
    final lsn6 = Lesson.create(
      lessonId: 'lsn_salah_jamaah_imamah',
      title: 'صلاة الجماعة: حكمها، وأحكام الإمامة، ومسائل المسبوق والاستخلاف',
      courseId: courseId,
      moduleId: 'mod_salah_sahw_jamaah_excuses',
      orderIndex: 6,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s6_1',
          title: 'معرفة حكم صلاة الجماعة للرجال وفضلها وموقف المأمومين',
          description: 'تفضيل صلاة الجماعة بسبع وعشرين درجة، واصطفاف المأمومين خلف الإمام وتسوية الصفوف.',
        ),
        LearningObjective(
          objectiveId: 'obj_s6_2',
          title: 'إتقان أحكام المسبوق وكيفية إدراك الركعة بالركوع',
          description: 'قاعدة إدراك الركعة، وما يفعله المسبوق إذا دخل والإمام في هيئة من الهيئات.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s6_1',
          title: 'فضل صلاة الجماعة وحكمها وترتيب الصفوف',
          contentType: LearningContentType.sourceText,
          content: 'صلاة الجماعة واجبة على الرجال القادرين في المساجد على الصحيح من أقوال أهل العلم لقوله تعالى: ﴿وَارْكَعُوا مَعَ الرَّاكِعِينَ﴾ وقوله ﷺ للأعمى: «هل تسمع النداء بالصلاة؟ قال: نعم، قال: فأجب» [رواه مسلم]. وفضلها عظيم لحديث: «صلاة الجماعة تفضل صلاة الفذ بسبع وعشرين درجة» [متفق عليه]. ويقف الإمام في الوسط، ويقف الرجال خلفه وخير صفوفهم أولها، وتشرع تسوية الصفوف وإتمام الأول فالأول وسد الفرج والتراص بلا فرجة للشيطان.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s6_bukhari_27',
              evidenceKey: 'hadith_bukhari_jamaah_27',
              citation: 'صحيح البخاري رقم 645 وصحيح مسلم رقم 650',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 2 ص 5',
        ),
        LessonSection.create(
          sectionId: 'sec_s6_2',
          title: 'أحكام المسبوق ومتابعة الإمام',
          contentType: LearningContentType.example,
          content: 'يجب على المأموم متابعة إمامه في أفعال الصلاة وتحرم مسابقته وتكره موافقته. وإذا دخل المسبوق المسجد دخل مع الإمام على أي حال كان عليه (قائماً أو راكعاً أو ساجداً أو جالساً)، وتدرك الركعة بإدراك الركوع مع الإمام بطمأنينة قبل أن يرفع الإمام صلبه لقوله ﷺ: «من أدرك ركعة من الصلاة فقد أدرك الصلاة». وإذا سلم الإمام قام المسبوق مكبراً لإتمام ما فاته جاعلاً ما أدركه مع الإمام أول صلاته وما يقضيه آخرها على الراجح.',
          sourceAttribution: 'المجموع شرح المهذب ج 4 ص 215',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 16: صلوات أهل الأعذار (المريض، المسافر، الخوف)
    // -------------------------------------------------------------------------
    final lsn7 = Lesson.create(
      lessonId: 'lsn_salah_excuses_travel_illness',
      title: 'صلوات أهل الأعذار: صلاة المريض، والمسافر والجمع والقصر، وصلاة الخوف',
      courseId: courseId,
      moduleId: 'mod_salah_sahw_jamaah_excuses',
      orderIndex: 7,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s7_1',
          title: 'معرفة كيفية صلاة المريض بحسب قدرته واستطاعته',
          description: 'تطبيق حديث عمران بن حصين: صَلِّ قائماً فإن لم تستطع فقاعداً فإن لم تستطع فعلى جنب.',
        ),
        LearningObjective(
          objectiveId: 'obj_s7_2',
          title: 'إتقان أحكام قصر الصلاة الرباعية والجمع في السفر والمطر',
          description: 'مسافة القصر (نحو 80 كم)، والفرق بين القصر وهو سنة والجمع وهو رخصة عند الحاجة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s7_1',
          title: 'صلاة المريض والتيسير الشرعي',
          contentType: LearningContentType.sourceText,
          content: 'الشريعة الإسلامية مبنية على اليسر ورفع الحرج لقوله تعالى: ﴿وَمَا جَعَلَ عَلَيْكُمْ فِي الدِّينِ مِنْ حَرَجٍ﴾. ويصلي المريض الفريضة قائماً، فإن عجز عن القيام أو شق عليه مشقة شديدة صلى قاعداً متربعاً أو على هيئة الجلوس، فإن عجز صلى على جنبه الأيمن مستقبلاً القبلة، فإن عجز استلقى على ظهره ورجلاه إلى القبلة، ويومئ بركوعه وسجوده برأسه ويجعل سجوده أخفض من ركوعه، ولا تسقط الصلاة عن المريض ما دام عقله ثابتاً.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s7_imran',
              evidenceKey: 'hadith_bukhari_imran_illness',
              citation: 'صحيح البخاري رقم 1117 من حديث عمران بن حصين رضي الله عنه',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'فتح الباري لابن حجر ج 2 ص 588',
        ),
        LessonSection.create(
          sectionId: 'sec_s7_2',
          title: 'أحكام قصر الصلاة والجمع للمسافر',
          contentType: LearningContentType.explanation,
          content: 'يسن للمسافر سفراً مباحاً يبلغ مسافة القصر (نحو 80 كم فأكثر) أن يقصر الصلاة الرباعية (الظهر والعصر والعشاء) ركعتين، ويبدأ القصر بمفارقة بيوت بلدته العامرة. وأما الجمع: فيجوز الجمع بين الظهر والعصر، وبين المغرب والعشاء في وقت إحداهما (جمع تقديم أو تأخير) للمسافر، وللمريض الذي يشق عليه أداء كل صلاة في وقتها، وفي الحضر عند المطر الشديد أو الوحل والريح الباردة الشديدة التي تشق على الناس الخروج إلى المساجد.',
          sourceAttribution: 'المغني لابن قدامة ج 2 ص 188',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 17: صلاة الجمعة والعيدين وسنن التطوع وقيام الليل
    // -------------------------------------------------------------------------
    final lsn8 = Lesson.create(
      lessonId: 'lsn_salah_friday_eids_voluntary',
      title: 'صلاة الجمعة والعيدين وسنن الرواتب والوتر وقيام الليل والكسوف',
      courseId: courseId,
      moduleId: 'mod_salah_sahw_jamaah_excuses',
      orderIndex: 8,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s8_1',
          title: 'معرفة شروط وجوب الجمعة وصفتها وآداب الاستماع للخطبة',
          description: 'تحريم الكلام والإمام يخطب، وحضور الخطبتين، وأداء الركعتين جهراً.',
        ),
        LearningObjective(
          objectiveId: 'obj_s8_2',
          title: 'حفظ سنن الرواتب الاثنتي عشرة وفضل صلاة الوتر وقيام الليل',
          description: 'حديث أم حبيبة في بناء بيت في الجنة، وركعات الوتر والتهجد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s8_1',
          title: 'صلاة الجمعة وأحكامها وآدابها',
          contentType: LearningContentType.sourceText,
          content: 'صلاة الجمعة فرض عين على كل مسلم ذكر حر مكلف مقيم مستوطن لقوله تعالى: ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا نُودِيَ لِلصَّلَاةِ مِن يَوْمِ الْجُمُعَةِ فَاسْعَوْا إِلَىٰ ذِكْرِ اللَّهِ وَذَرُوا الْبَيْعَ﴾ [الجمعة: 9]. ويسن فيها: الغسل، والتطيب، ولبس أحسن الثياب، والتبكير إلى المسجد، وقراءة سورة الكهف، والإكثار من الصلاة على النبي ﷺ. ويحرم الكلام أثناء خطبة الجمعة حتى قول «صه» أو «أنصت» لقوله ﷺ: «إذا قلت لصاحبك يوم الجمعة: أَنْصِتْ، والإمام يخطب، فقد لَغَوْتَ» [متفق عليه].',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s8_bukhari_laghw',
              evidenceKey: 'hadith_bukhari_laghw',
              citation: 'صحيح البخاري رقم 934 وصحيح مسلم رقم 851',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المجموع شرح المهذب ج 4 ص 500',
        ),
        LessonSection.create(
          sectionId: 'sec_s8_2',
          title: 'سنن الرواتب الاثنتا عشرة والوتر وصلاة العيد والكسوف',
          contentType: LearningContentType.example,
          content: 'السنن الرواتب المؤكدة التابعة للفرائض اثنتا عشرة ركعة: 4 ركعات قبل الظهر بسلامين وركعتان بعدها، وركعتان بعد المغرب، وركعتان بعد العشاء، وركعتان قبل الفجر (وهي آكدها)، لقوله ﷺ: «من صلى في يوم وليلة ثنتي عشرة ركعة بُني له بيت في الجنة» [رواه مسلم]. وصلاة الوتر سنة مؤكدة وقتها من بعد صلاة العشاء إلى طلوع الفجر وأقلها ركعة وأكملها إحدى عشرة ركعة. وصلاة العيدين ركعتان بسبع تكبيرات في الأولى وخمس في الثانية سنة مؤكدة أو فرض كفاية، وصلاة الكسوف ركعتان بركوعين وسجودين في كل ركعة عند انكساف الشمس أو القمر.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s8_muslim_rawatib',
              evidenceKey: 'hadith_muslim_rawatib',
              citation: 'صحيح مسلم رقم 728 عن أم المؤمنين أم حبيبة رضي الله عنها',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 1 ص 780',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 18: أحكام الجنائز والتكفين والصلاة على الميت
    // -------------------------------------------------------------------------
    final lsn9 = Lesson.create(
      lessonId: 'lsn_salah_funeral_janazah',
      title: 'فقه الجنائز: غسل الميت، وتكفينه، وصفة صلاة الجنازة، والدفن الشرعي',
      courseId: courseId,
      moduleId: 'mod_salah_sahw_jamaah_excuses',
      orderIndex: 9,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_s9_1',
          title: 'معرفة الحقوق الواجبة للميت المسلم (الغسل، الكفن، الصلاة، الدفن)',
          description: 'حكمها فرض كفاية إذا قام به من يكفي سقط الإثم عن الباقين.',
        ),
        LearningObjective(
          objectiveId: 'obj_s9_2',
          title: 'إتقان صفة صلاة الجنازة بأربع تكبيرات وأدعيتها المأثورة',
          description: 'الفاتحة بعد الأولى، الصلاة الإبراهيمية بعد الثانية، الدعاء للميت بعد الثالثة، والسلام بعد الرابعة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_s9_1',
          title: 'غسل الميت وتكفينه وتشييعه',
          contentType: LearningContentType.explanation,
          content: 'تجهيز الميت المسلم فرض كفاية، ويشمل: 1. غسله بماء وسدر وترا وأفضله ثلاث غسلات ويجعل في الأخيرة كافوراً، ويبدأ بميامنه ومواضع الوضوء منه، والشهيد في المعركة لا يغسل ولا يكفن بل يدفن في ثيابه بدمائه، 2. تكفينه في ثياب بيض نظيفة ساترة (ويستحب ثلاثة أثواب للرجل وخمسة للمرأة)، 3. حمل الجنازة وتشييعها واتباعها حتى تدفن، لقوله ﷺ: «من شهد الجنازة حتى يصلى عليها فله قيراط، ومن شهدها حتى تدفن فله قيراطان، قيل: وما القيراطان؟ قال: مثل الجبلين العظيمين» [متفق عليه].',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s9_qiratayn',
              evidenceKey: 'hadith_bukhari_qirat',
              citation: 'صحيح البخاري رقم 1325 وصحيح مسلم رقم 945',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'أحكام الجنائز وبدعها للألباني ص 45',
        ),
        LessonSection.create(
          sectionId: 'sec_s9_2',
          title: 'صفة صلاة الجنازة وأدعيتها والدفن الشرعي',
          contentType: LearningContentType.example,
          content: 'صلاة الجنازة أربع تكبيرات قائماً بلا ركوع ولا سجود: \n1. بعد التكبيرة الأولى: يتعوذ ويبسمل ويقرأ سورة الفاتحة سراً.\n2. بعد التكبيرة الثانية: يصلي على النبي ﷺ الصلاة الإبراهيمية.\n3. بعد التكبيرة الثالثة: يدعو للميت بإخلاص بالأدعية المأثورة: «اللهم اغفر له وارحمه وعافه واعف عنه وأكرم نزله ووسع مدخله واغسله بالماء والثلج والبرد ونقه من الخطايا كما ينقى الثوب الأبيض من الدنس...».\n4. بعد التكبيرة الرابعة: يسكت قليلاً ويسلم تسليمة واحدة عن يمينه (أو تسليمتين).\nثم يدفن في لحد موجه الوجه إلى القبلة، ويحثى التراب ثلاثاً، ويستغفر له عند القبر لحديث: «استغفروا لأخيكم وسلوا له التثبيت فإنه الآن يسأل».',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_s9_awf_dua',
              evidenceKey: 'hadith_muslim_funeral_dua',
              citation: 'صحيح مسلم رقم 963 من حديث عوف بن مالك رضي الله عنه',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'كشاف القناع عن متن الإقناع ج 2 ص 95',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_kashaf_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5, lsn6, lsn7, lsn8, lsn9];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Conditions & Pillars
    final q1 = QuizQuestion.create(
      questionId: 'q_salah_cond_1',
      lessonId: 'lsn_salah_conditions_adv',
      questionText: 'ما حكم من صلى وهو يعلم بانكشاف عورته المغلظة ولم يسترها في الحال بلا عذر؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_sc1_1', text: 'تبطل صلاته وتلزمه الإعادة لفوات شرط ستر العورة'),
        QuizOption(optionId: 'opt_sc1_2', text: 'تصح صلاته مع الكراهة التنزيهية'),
        QuizOption(optionId: 'opt_sc1_3', text: 'يسجد للسهو بعد السلام وتجزئه الصلاة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'ستر العورة شرط لصحة الصلاة، وإذا فرط المصلي فكشفها عمداً بطلت صلاته باتفاق أئمة الفقه.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_salah_conditions',
      lessonId: 'lsn_salah_conditions_adv',
      title: 'اختبار شروط الصلاة ومواقيتها',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Sahw Prostrations
    final q2 = QuizQuestion.create(
      questionId: 'q_salah_sahw_1',
      lessonId: 'lsn_salah_sahw_prostrations',
      questionText: 'إذا نسي المصلي التشهد الأول وقام إلى الركعة الثالثة واستتم قائماً، فما الحكم الشرعي الصحيح؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_ss1_1', text: 'يمضي في صلاته ولا يرجع، ويسجد للسهو سجدتين قبل السلام'),
        QuizOption(optionId: 'opt_ss1_2', text: 'يرجع للجلوس فوراً وتبطل صلاته إن لم يرجع'),
        QuizOption(optionId: 'opt_ss1_3', text: 'تبطل صلاته بالكلية وتلزمه إعادة الصلاة من أولها'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لحديث عبد الله بن بحينة رضي الله عنه أن النبي ﷺ قام من الركعتين ولم يجلس، فلما قضى الصلاة سجد سجدتين قبل أن يسلم ثم سلم.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_salah_sahw',
      lessonId: 'lsn_salah_sahw_prostrations',
      title: 'اختبار أحكام سجود السهو وقواعده',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Jama'ah & Masbuq
    final q3 = QuizQuestion.create(
      questionId: 'q_salah_jamaah_1',
      lessonId: 'lsn_salah_jamaah_imamah',
      questionText: 'بماذا يدرك المسبوق الركعة الكاملة مع الإمام في صلاة الجماعة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_sj1_1', text: 'بإدراك الركوع مع الإمام بطمأنينة قبل أن يرفع الإمام صلبه'),
        QuizOption(optionId: 'opt_sj1_2', text: 'بإدراك سورة الفاتحة فقط مع الإمام'),
        QuizOption(optionId: 'opt_sj1_3', text: 'بإدراك السجود الثاني في الركعة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقوله ﷺ: «إذا جئتم إلى الصلاة ونحن سجود فاسجدوا ولا تعدوها شيئاً، ومن أدرك الركعة فقد أدرك الصلاة» رواه أبو داود، وإدراك الركوع إدراك للركعة عند جماهير العلماء.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_salah_jamaah',
      lessonId: 'lsn_salah_jamaah_imamah',
      title: 'اختبار صلاة الجماعة وفقه المسبوق',
      questions: [q3],
      passingScorePercentage: 75,
    );

    // Quiz 4: Funeral Prayer
    final q4 = QuizQuestion.create(
      questionId: 'q_salah_janazah_1',
      lessonId: 'lsn_salah_funeral_janazah',
      questionText: 'ماذا يقرأ المصلي في صلاة الجنازة بعد التكبيرة الأولى مباشرة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_sjn1_1', text: 'يتعوذ ويبسمل ويقرأ سورة الفاتحة سراً'),
        QuizOption(optionId: 'opt_sjn1_2', text: 'يصلي الصلاة الإبراهيمية'),
        QuizOption(optionId: 'opt_sjn1_3', text: 'يدعو للميت بالمغفرة والرحمة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'السنة الثابتة عن ابن عباس والصحابة رضي الله عنهم قراءة الفاتحة بعد التكبيرة الأولى في صلاة الجنازة.',
    );

    final quiz4 = Quiz.create(
      quizId: 'quiz_salah_janazah',
      lessonId: 'lsn_salah_funeral_janazah',
      title: 'اختبار أحكام صلاة الجنازة والدفن',
      questions: [q4],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3, quiz4];
  }
}
