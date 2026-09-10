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

/// بيانات مقرر أسباب اختلاف الفقهاء وأدب الخلاف الفقهي والإنصاف (6 دروس تأصيلية + اختباران استيعاب)
class LearningIkhtilafCausesAdabData {
  static const String courseId = 'course_ikhtilaf_causes_adab_khilaf';
  static const String pathId = 'path_madhahib_history_ijtihad_imams_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر أسباب اختلاف الفقهاء وأدب الخلاف الفقهي والإنصاف',
      description: 'دراسة تأصيلية عميقة للأسباب اللغوية والحديثية والأصولية لاختلاف أئمة الفقه، مدارسة كتاب «رفع الملام عن الأئمة الأعلام»، ضوابط الخلاف السائغ والمردود، أدب الخلاف عند السلف، وقواعد الترجيح والتيسير المعاصر.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_ikhtilaf_linguistic_hadith_causes', 'mod_adab_ikhtilaf_inssaf'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_ikhtilaf_linguistic_hadith_causes',
        courseId: courseId,
        title: 'الوحدة الأولى: الأسباب العلمية والأصولية والحديثية لاختلاف الفقهاء',
        description: 'الأسباب العائدة لدلالات الألفاظ والاشتراك اللغوي، أسباب الاختلاف في ثبوت السنة وقبول الأخبار، وأثر التفاوت في القواعد الأصولية ومصادر الاستنباط.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_ikhtilaf_linguistic_textual_causes',
          'lsn_ikhtilaf_hadith_transmission_raf_malam',
          'lsn_ikhtilaf_secondary_usul_sources',
        ],
      ),
      CourseModule(
        moduleId: 'mod_adab_ikhtilaf_inssaf',
        courseId: courseId,
        title: 'الوحدة الثانية: ضوابط الخلاف السائغ وأدب الموازنة والإنصاف',
        description: 'التمييز بين الخلاف المعتبر والخلاف الشاذ، قاعدة «لا إنكار في مسائل الاجتهاد»، أدب الخلاف والمناظرة عند السلف، وضوابط التخيّر والترجيح المعاصر.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_ikhtilaf_linguistic_hadith_causes'],
        lessonIds: const [
          'lsn_ikhtilaf_valid_vs_deviant_boundaries',
          'lsn_ikhtilaf_salaf_etiquette_tolerance',
          'lsn_ikhtilaf_contemporary_tarjih_concession',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 7: الأسباب اللغوية والنصية
      Lesson.create(
        lessonId: 'lsn_ikhtilaf_linguistic_textual_causes',
        title: 'أسباب الاختلاف العائدة إلى دلالات الألفاظ وطبيعة اللغة العربية',
        courseId: courseId,
        moduleId: 'mod_ikhtilaf_linguistic_hadith_causes',
        orderIndex: 1,
        sources: const ['src_raf_malam', 'src_quran_canonical', 'src_bukhari_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ikh_1_1',
            title: 'المشترك اللفظي والحقيقة والمجاز',
            description: 'فهم أثر الاشتراك اللغوي وتنازع الحقيقة والمجاز في اختلاف فهم الفقهاء للنصوص الشرعية.',
          ),
          LearningObjective(
            objectiveId: 'obj_ikh_1_2',
            title: 'العام والخاص والمطلق والمقيد',
            description: 'معرفة كيفية تسبب قواعد حمل المطلق على المقيد وتخصيص العام في تباين استنباط الأحكام.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ikh_1_1',
            title: 'المشترك اللفظي وتنازع الحقيقة والمجاز',
            contentType: LearningContentType.sourceText,
            content: 'نزل القرآن الكريم بلسان عربي مبين يحمل اتساع اللغة وظواهرها البلاغية؛ فكان الاشتراك اللغوي من أوائل أسباب الخلاف، كلفظ «القُرْء» في قوله تعالى: ﴿وَالْمُطَلَّقَاتُ يَتَرَبَّصْنَ بِأَنفُسِهِنَّ ثَلَاثَةَ قُرُوءٍ﴾؛ حيث يطلق القرء في لسان العرب على الحيض وعلى الطهر، فذهب الحنفية والحنابلة إلى أنه الحيض، بينما ذهب المالكية والشافعية إلى أنه الطهر. ومثل ذلك تنازع الحقيقة والمجاز في قوله تعالى: ﴿أَوْ لَامَسْتُمُ النِّسَاءَ﴾، ففسره ابن مسعود والشافعي بمجرد مس البشرة، وفسره ابن عباس وأبو حنيفة بالجماع كناية ومجازاً.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_1_1',
                evidenceKey: '2:228',
                citation: 'قوله تعالى: ﴿وَالْمُطَلَّقَاتُ يَتَرَبَّصْنَ بِأَنفُسِهِنَّ ثَلَاثَةَ قُرُوءٍ﴾ [البقرة: 228]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير القرطبي وبداية المجتهد ونهاية المقتصد لابن رشد',
          ),
          LessonSection.create(
            sectionId: 'sec_ikh_1_2',
            title: 'العموم والخصوص والإطلاق والتقييد',
            contentType: LearningContentType.explanation,
            content: 'اختلف الأئمة في دلالة اللفظ العام؛ فذهب الجمهور إلى أن العام ظني الدلالة في أفراده ويجوز تخصيصه بخبر الواحد والقياس، في حين رأى الحنفية أن العام قطعي الدلالة كالمعنى الخاص ولا ينسخ أو يخصص بخبر الواحد الظني. وكذا في مسألة حمل المطلق على المقيد؛ كاشتراط الإيمان في الرقبة المحررة في كفارة الظهار قياساً على كفارة القتل الخطأ المقيدة بالمؤمنة، حيث اختلفوا باختلاف اتحاد السبب والحكم أو افتراقهما.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_1_2',
                evidenceKey: 'qawaid:usul_am_khas',
                citation: 'قواعد الأصول في تخصيص العام وتقييد المطلق من المستصفى للغزالي',
                sourceId: 'src_raf_malam',
              ),
            ],
            sourceAttribution: 'المستصفى للغزالي وشرح اللمع للشيرازي وإحكام الفصول للباجي',
          ),
        ],
      ),

      // Lesson 8: أسباب الاختلاف الحديثية ورفع الملام
      Lesson.create(
        lessonId: 'lsn_ikhtilaf_hadith_transmission_raf_malam',
        title: 'أسباب الاختلاف العائدة إلى السنة: مدارسة «رفع الملام عن الأئمة الأعلام»',
        courseId: courseId,
        moduleId: 'mod_ikhtilaf_linguistic_hadith_causes',
        orderIndex: 2,
        sources: const ['src_raf_malam', 'src_bukhari_canonical', 'src_muslim_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ikh_2_1',
            title: 'أعذار الأئمة في ترك الحديث',
            description: 'استيعاب الأسباب العشرة التي قررها شيخ الإسلام ابن تيمية في عذر الأئمة عند ترك العمل بحديث ما.',
          ),
          LearningObjective(
            objectiveId: 'obj_ikh_2_2',
            title: 'تفاوت ثبوت السنة وشروط الرواة',
            description: 'إدراك شروط كل إمام في توثيق الرواة وقبول المراسيل والزيادات وحكم معارضة القياس للخبر.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ikh_2_1',
            title: 'منهج ابن تيمية في كتاب «رفع الملام عن الأئمة الأعلام»',
            contentType: LearningContentType.sourceText,
            content: 'قرر شيخ الإسلام ابن تيمية أن أحداً من أئمة الإسلام المتبوعين لا يتعمد مخالفة رسول الله ﷺ في أمر من أموره، وإنما يرجع ترك أحدهم للحديث إلى ثلاثة أصول جامعة تتفرع إلى عشرة أسباب: 1) عدم علمه بالحديث أصلاً (إذ لا يحيط بالسنة كلها إلا معصوم). 2) عدم ثبوت الحديث عنده (كأن يكون الراوي ضعيفاً عنده أو مجهولاً، أو اشترط شروطاً لم تتحقق). 3) اعتقاده عدم دلالة الحديث على المسألة (لتأويل سائغ أو معارض راجح كناسخ أو إجماع أو نص أقوى منه).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_2_1',
                evidenceKey: 'raf_malam:p9',
                citation: 'كتاب رفع الملام عن الأئمة الأعلام للإمام ابن تيمية',
                sourceId: 'src_raf_malam',
              ),
            ],
            sourceAttribution: 'رفع الملام عن الأئمة الأعلام لابن تيمية ومجموع الفتاوى',
          ),
          LessonSection.create(
            sectionId: 'sec_ikh_2_2',
            title: 'أمثلة تطبيقية لتفاوت الأئمة في شروط قبول السنة',
            contentType: LearningContentType.explanation,
            content: 'من التطبيقات العملية: 1) الحديث المرسل: احتج به أبو حنيفة ومالك وأحمد مطلقاً إذا كان المرسل ثقة، بينما اشترط الشافعي عضده بمجيئه من وجه آخر أو موافقة قول صحابي. 2) خبر الواحد المخالف للقياس أو الأصول: قدم الحنفية القياس الجلي عليه في بعض المواضع، واشترط المالكية ألا يخالف عمل أهل المدينة القطعي، بينما قدم الشافعي وأحمد الحديث الصحيح على كل قياس وعمل. فهذه فروق منهجية شريفة مبنية على تعظيم الوحي وحفظ الدين.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_2_2',
                evidenceKey: 'bukhari:7352',
                citation: 'حديث النبي ﷺ: «إِذَا حَكَمَ الحَاكِمُ فَاجْتَهَدَ ثُمَّ أَصَابَ فَلَهُ أَجْرَانِ، وَإِذَا حَكَمَ فَاجْتَهَدَ ثُمَّ أَخْطَأَ فَلَهُ أَجْرٌ»',
                sourceId: 'src_bukhari_canonical',
              ),
            ],
            sourceAttribution: 'مقدمة ابن الصلاح وإعلام الموقعين لابن القيم',
          ),
        ],
      ),

      // Lesson 9: الاختلاف في القواعد الأصولية
      Lesson.create(
        lessonId: 'lsn_ikhtilaf_secondary_usul_sources',
        title: 'أسباب الاختلاف العائدة إلى القواعد الأصولية ومصادر الاستنباط التبعية',
        courseId: courseId,
        moduleId: 'mod_ikhtilaf_linguistic_hadith_causes',
        orderIndex: 3,
        sources: const ['src_ihkam_amidi', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ikh_3_1',
            title: 'الأدلة المختلف فيها بين الأصوليين',
            description: 'معرفة الأدلة التبعية المختلف في حجيتها: الاستحسان، الاستصلاح (المصالح المرسلة)، الاستصحاب، وسد الذرائع.',
          ),
          LearningObjective(
            objectiveId: 'obj_ikh_3_2',
            title: 'قول الصحابي وشرع من قبلنا',
            description: 'فهم أثر الاختلاف في حجية فتوى الصحابي وإلزاميتها وشرع من قبلنا في فروع المذاهب.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ikh_3_1',
            title: 'الاستحسان والمصالح المرسلة وسد الذرائع',
            contentType: LearningContentType.sourceText,
            content: 'تعددت مناهج الأئمة في اعتماد الأدلة التبعية الاجتهادية: 1) الاستحسان: عده الحنفية والمالكية دليلاً رئيساً لترك القياس الجلي لدليل أرجح منه، بينما شدد الشافعي في إنكاره وقال: «من استحسن فقد شرّع» (قاصداً الاستحسان بالهوى والتشهي لا الاستحسان المستند لدليل). 2) المصالح المرسلة: توسع فيها الإمام مالك في الوقائع التي لا يشهد لها أصل معين بالإلغاء ولا بالاعتبار الخاص وتتفق مع مقاصد الشريعة، بينما ضيق الشافعية والحنفية نطاقها واشترطوا اندراجها تحت أصل كلي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_3_1',
                evidenceKey: 'amidi:ihkam:4:160',
                citation: 'الإحكام في أصول الأحكام للآمدي (الكلام في الأدلة المختلف فيها)',
                sourceId: 'src_ihkam_amidi',
              ),
            ],
            sourceAttribution: 'الإحكام للآمدي وقواطع الأدلة لابن السمعاني ونهاية السول للإسنوي',
          ),
          LessonSection.create(
            sectionId: 'sec_ikh_3_2',
            title: 'حجية قول الصحابي وشرع من قبلنا والعرف',
            contentType: LearningContentType.explanation,
            content: 'من القواعد المؤثرة في الفروع: مذهب الصحابي إذا لم يخالف نصاً ولم ينتشر؛ فقدمه أبو حنيفة ومالك وأحمد في الراجح على القياس لكون الصحابة شهود التنزيل وأعلم بالمقاصد، في حين رأى الشافعي في الجديد أن قول الصحابي ليس حجة ملزمة لمن بعده لجواز الخطأ على غير المعصوم. وكذا في قاعدة «شرع من قبلنا شرع لنا ما لم ينسخ»، ومراعاة العرف الصحيح المطرد، فكانت هذه القواعد مصدراً لثراء الفقه وتنوع الفتاوى وتعدد المدارس.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_3_2',
                evidenceKey: 'quran:59:2',
                citation: 'قوله تعالى: ﴿فَاعْتَبِرُوا يَا أُولِي الْأَلْبَابِ﴾ [الحشر: 2]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'التبصرة في أصول الفقه للشيرازي وشرح الكوكب المنير لابن النجار',
          ),
        ],
      ),

      // Lesson 10: ضوابط الخلاف السائغ
      Lesson.create(
        lessonId: 'lsn_ikhtilaf_valid_vs_deviant_boundaries',
        title: 'ضوابط التمييز بين الخلاف السائغ المعتبر والخلاف الشاذ المردود',
        courseId: courseId,
        moduleId: 'mod_adab_ikhtilaf_inssaf',
        orderIndex: 4,
        sources: const ['src_muwafaqat_shatibi', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ikh_4_1',
            title: 'معايير الخلاف السائغ',
            description: 'إدراك شروط الخلاف السائغ المعتبر ومناط قاعدة «لا إنكار في مسائل الاجتهاد».',
          ),
          LearningObjective(
            objectiveId: 'obj_ikh_4_2',
            title: 'محاذير الأقوال الشاذة والبدعية',
            description: 'معرفة علامات القول الشاذ ومصادمته للنصوص القطعية أو الإجماع المستقر وحكم تتبعه.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ikh_4_1',
            title: 'حقيقة الخلاف السائغ وقاعدة «لا إنكار في المختلف فيه»',
            contentType: LearningContentType.sourceText,
            content: 'الخلاف السائغ المعتبر هو ما كان ناشئاً عن اجتهاد صادر من أهل الأهلية العلمية في مسألة ليس فيها نص قطعي الثبوت والدلالة ولا إجماع قطعي، بل تردد الأمر فيها بين أدلة ظنية متقابلة أو علل محتملة. وفي هذا النوع استقرت قاعدة أئمة الإسلام: «لا يُنْكَرُ المُخْتَلَفُ فِيهِ، وَإِنَّمَا يُنْكَرُ المُجْمَعُ عَلَيْهِ». والإنكار المنفي هو الإنكار باليد أو التبديع والتفسيق والتشهير، أما التناصح والمناظرة العلمية بالتي هي أحسن وبيان الراجح فباقٍ ومشروع بالاتفاق.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_4_1',
                evidenceKey: 'shatibi:muwafaqat:4:120',
                citation: 'الموافقات في أصول الشريعة لأبي إسحاق الشاطبي (كتاب الاجتهاد)',
                sourceId: 'src_muwafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي وقواعد الأحكام للعز بن عبد السلام',
          ),
          LessonSection.create(
            sectionId: 'sec_ikh_4_2',
            title: 'الخلاف الشاذ المردود وخطره على الشريعة',
            contentType: LearningContentType.explanation,
            content: 'ليس كل خلاف جاء معتبراً، كما قال ابن الشحنة: «وليس كل خلاف جاء معتبراً ... إلا خلاف له حظ من النظر». فالخلاف الشاذ هو القول الذي يصادم نصاً صريحاً صحيحاً لا معارض له، أو يخالف إجماعاً متيقناً، أو يترتب عليه تفويت مقصد قطعي من مقاصد الدين؛ كنكاح المتعة، أو تحليل ربا الفضل، أو بيع العينة المحرم. وهذا النوع من الأقوال لا يجوز الفتوى به ولا اعتماده، ويجب الإنكار على منتحله ورد قوله بالحجة والبرهان صيانة لقطعية الشريعة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_4_2',
                evidenceKey: 'quran:4:59',
                citation: 'قوله تعالى: ﴿فَإِن تَنَازَعْتُمْ فِي شَيْءٍ فَرُدُّوهُ إِلَى اللَّهِ وَالرَّسُولِ﴾ [النساء: 59]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'جامع بيان العلم وفضله لابن عبد البر والاعتصام للشاطبي',
          ),
        ],
      ),

      // Lesson 11: آداب الخلاف عند السلف
      Lesson.create(
        lessonId: 'lsn_ikhtilaf_salaf_etiquette_tolerance',
        title: 'آداب الخلاف والإنصاف عند السلف الصالح ونبذ التعصب المذهبي',
        courseId: courseId,
        moduleId: 'mod_adab_ikhtilaf_inssaf',
        orderIndex: 5,
        sources: const ['src_siyar_alam_nubala', 'src_bukhari_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ikh_5_1',
            title: 'أخلاق الأئمة في الخلاف والمناظرة',
            description: 'استلهام نماذج التسامح والمحبة وحسن الظن بين كبار أئمة الفقه رغم تباين اجتهاداتهم.',
          ),
          LearningObjective(
            objectiveId: 'obj_ikh_5_2',
            title: 'التحذير من التعصب والفرقة',
            description: 'بيان الآثار الهدامة للتعصب المذهبي والتراشق الكلامي على جسد الأمة ووحدتها.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ikh_5_1',
            title: 'نماذج مضيئة لأدب الخلاف بين أئمة الفقه',
            contentType: LearningContentType.sourceText,
            content: 'ضرب الأئمة أروع الأمثلة في الإنصاف؛ قال الشافعي وهو يناظر يونس بن عبد الأعلى الصدفي ثم لقيه وأخذ بيده: «يا أبا موسى، ألا يستقيم أن نكون إخواناً وإن لم نتفق في مسألة؟». وكان الإمام أحمد يثني على الشافعي ويقول: «كان كالشمس للدنيا وكالعافية للناس». وكان الشافعي يقول: «ما ناظرت أحداً قط إلا أحببت أن يوفق ويسدد ويعان، وما ناظرت أحداً فباليت أظهر الحق على لساني أو لسانه». وكانوا يصلون خلف بعضهم مع اختلافهم في مس القبلة والبسملة والقنوت دون تحرج.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_5_1',
                evidenceKey: 'dhahabi:siyar:10:16',
                citation: 'سير أعلام النبلاء للإمام الذهبي (ترجمة الإمام الشافعي والإمام أحمد)',
                sourceId: 'src_siyar_alam_nubala',
              ),
            ],
            sourceAttribution: 'سير أعلام النبلاء للذهبي وحلية الأولياء لأبي نعيم الأصفهاني',
          ),
          LessonSection.create(
            sectionId: 'sec_ikh_5_2',
            title: 'جناية التعصب المذهبي ونقض رابطة الأخوة',
            contentType: LearningContentType.explanation,
            content: 'حذر المحققون من داء التعصب المذهبي الذي أصاب بعض المتأخرين حين جعلوا قول إمامهم بمثابة النص المعصوم، وأولوا نصوص الوحيين لتوافق مذهبهم، وامتنع بعضهم من الصلاة خلف المخالف أو مصاهرته. وقرر العلماء أن الأئمة الأربعة برآء من هذا التعصب؛ فكلهم قال: «إذا صح الحديث فهو مذهبي»، و«كل أحد يؤخذ من قوله ويترك إلا صاحب هذا القبر ﷺ». والواجب على طالب العلم تعظيم الدليل مع حفظ قدر الأئمة ومحبتهم والاستفادة من تراثهم العظيم.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_5_2',
                evidenceKey: 'quran:3:103',
                citation: 'قوله تعالى: ﴿وَاعْتَصِمُوا بِحَبْلِ اللَّهِ جَمِيعًا وَلَا تَفَرَّقُوا﴾ [آل عمران: 103]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'جامع بيان العلم وفضله لابن عبد البر والرد على من أخلد إلى الأرض للسيوطي',
          ),
        ],
      ),

      // Lesson 12: فقه الترجيح والتيسير المعاصر
      Lesson.create(
        lessonId: 'lsn_ikhtilaf_contemporary_tarjih_concession',
        title: 'فقه الموازنة والترجيح المعاصر: ضوابط التيسير وتجنب تتبع الرخص المذموم',
        courseId: courseId,
        moduleId: 'mod_adab_ikhtilaf_inssaf',
        orderIndex: 6,
        sources: const ['src_majma_fiqhi_resolutions', 'src_qawaid_fiqhiyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ikh_6_1',
            title: 'ضوابط التخيّر الفقهي المعاصر',
            description: 'معرفة آليات الإفتاء المعاصر والمجامع الفقهية في اختيار الأرفق بالأمة وفق ضوابط الدليل والمصلحة.',
          ),
          LearningObjective(
            objectiveId: 'obj_ikh_6_2',
            title: 'التفريق بين التيسير وتتبع الرخص',
            description: 'التمييز بين التيسير المشروع المستند للدليل وبين التلفيق الباطل وتتبع زلات العلماء بالهوى.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ikh_6_1',
            title: 'منهج التخيّر الفقهي المنضبط في النوازل المعاصرة',
            contentType: LearningContentType.sourceText,
            content: 'اعتمدت المجامع الفقهية وهيئات الفتوى المعاصرة منهج «التخيّر الفقهي المقارن»؛ وهو عدم الجمود على مذهب فقهي واحد في معالجة قضايا العصر ونوازله المعقدة، بل الرجوع إلى سائر المذاهب المعتبرة واختيار القول الذي يحقق مقاصد الشريعة في التيسير ورفع الحرج وجلب المصلحة ودرء المفسدة، ما دام مسنوداً بأصل شرعي أو دليل معتبر. ومن أمثلة ذلك: الأخذ بقول ابن تيمية في قضايا الطلاق المعلق، والتوسع في إجازة الشركات المساهمة وعقود الاستصناع والإجارة المنتهية بالتمليك.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_6_1',
                evidenceKey: 'majma:manhaj:fatwa',
                citation: 'المعايير المنهجية للفتوى والاجتهاد الجماعي الصادرة عن مجمع الفقه الإسلامي الدولي',
                sourceId: 'src_majma_fiqhi_resolutions',
              ),
            ],
            sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي والمدخل لدراسة الفقه للزرقا',
          ),
          LessonSection.create(
            sectionId: 'sec_ikh_6_2',
            title: 'تحريم تتبع الرخص والتلفيق المؤدي لإسقاط التكليف',
            contentType: LearningContentType.explanation,
            content: 'فرق الفقهاء بوضوح بين «التيسير الشرعي» الذي دلت عليه نصوص الكتاب والسنة: ﴿يُرِيدُ اللَّهُ بِكُمُ الْيُسْرَ وَلَا يُرِيدُ بِكُمُ الْعُسْرَ﴾، وبين «تتبع الرخص المذموم»؛ وهو تتبع أسهل الأقوال في كل مذهب طلباً للهوى والتشهي وإسقاطاً للتكاليف، حتى قال الأوزاعي: «من أخذ بنوادر العلماء خرج من الإسلام» وقال سليمان التيمي: «لو أخذت برخصة كل عالم اجتمع فيك الشر كله». وكذا حظر العلماء «التلفيق الباطل» الذي يولد صورة مركبة يجمع أصحاب المذاهب المنقول عنهم على بطلانها.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ikh_6_2',
                evidenceKey: '2:185',
                citation: 'قوله تعالى: ﴿يُرِيدُ اللَّهُ بِكُمُ الْيُسْرَ وَلَا يُرِيدُ بِكُمُ الْعُسْرَ﴾ [البقرة: 185]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الأشباه والنظائر للسيوطي وفتاوى ابن الصلاح وشرح القواعد الفقهية للزرقا',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: أسباب الاختلاف العلمية
    final q1 = QuizQuestion.create(
      questionId: 'q_ikh_1',
      lessonId: 'lsn_ikhtilaf_hadith_transmission_raf_malam',
      questionText: 'ما هي الأصول الثلاثة الجامعة لأعذار الأئمة في ترك العمل ببعض الأحاديث كما قرر ابن تيمية في «رفع الملام»؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qi1_1', text: 'عدم علمه بالحديث، أو عدم ثبوته عنده، أو اعتقاد عدم دلالته على المسألة لمعارض راجح'),
        QuizOption(optionId: 'opt_qi1_2', text: 'تعمد مخالفة السنة تقديماً لأقوال الشيوخ والآباء في كل مسألة'),
        QuizOption(optionId: 'opt_qi1_3', text: 'إنكار حجية الأحاديث النبوية والاكتفاء بالقرآن الكريم وحده'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قرر ابن تيمية أن أئمة الإسلام لا يتعمدون مخالفة الرسول ﷺ، وأعذارهم تدور بين عدم البلوغ، أو عدم الثبوت، أو عدم الدلالة.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_ikhtilaf_linguistic_hadith_causes',
      lessonId: 'lsn_ikhtilaf_hadith_transmission_raf_malam',
      title: 'اختبار تقييم استيعاب الأسباب اللغوية والحديثية والأصولية لاختلاف الفقهاء',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: ضوابط الخلاف والإنصاف
    final q2 = QuizQuestion.create(
      questionId: 'q_ikh_2',
      lessonId: 'lsn_ikhtilaf_valid_vs_deviant_boundaries',
      questionText: 'ما هو الضابط الفقهي الأصيل لقاعدة: «لا يُنْكَرُ المُخْتَلَفُ فِيهِ، وَإِنَّمَا يُنْكَرُ المُجْمَعُ عَلَيْهِ»؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qi2_1', text: 'أن الخلاف السائغ المبني على اجتهاد معتبر لا إنكار فيه باليد أو التبديع مع جواز المناصحة والمناظرة بالتي هي أحسن'),
        QuizOption(optionId: 'opt_qi2_2', text: 'جواز إقرار الأقوال الشاذة المصادمة للنصوص الصريحة القطعية بلا رد أو إنكار'),
        QuizOption(optionId: 'opt_qi2_3', text: 'منع العلماء من كتابة أدلة الترجيح والموازنة بين المذاهب'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الإنكار المنفي هو إنكار التفسيق والتبديع واليد في المسائل الاجتهادية السائغة، مع بقاء مشروعية المباحثة والمناصحة العلمية.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_adab_ikhtilaf_inssaf',
      lessonId: 'lsn_ikhtilaf_valid_vs_deviant_boundaries',
      title: 'اختبار تقييم استيعاب ضوابط الخلاف السائغ وأدب الخلاف والإنصاف وفقه التيسير المعاصر',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
