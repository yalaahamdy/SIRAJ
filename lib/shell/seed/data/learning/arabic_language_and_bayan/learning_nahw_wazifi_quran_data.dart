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

/// بيانات مقرر النحو التطبيقي والوظيفي وإعراب القرآن والحديث النبوي (6 دروس تأصيلية + اختباران استيعاب)
class LearningNahwWazifiQuranData {
  static const String courseId = 'course_nahw_wazifi_quran';
  static const String pathId = 'path_arabic_language_bayan_semantics_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر النحو التطبيقي والوظيفي وإعراب القرآن والحديث النبوي',
      description: 'دراسة تأصيلية وظيفية لقواعد النحو العربي ونظام الإعراب بوصفه مفتاح فهم كلام الله وسنة رسوله ﷺ، دراسة المرفوعات والمنصوبات والمجرورات، ونواصب وجوازم الأفعال، مع تطبيقات إعرابية موسعة وأثر التوجيه النحوي في الخلاف الفقهي وتوجيه التفسير.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_nahw_syntax_marfuat', 'mod_nahw_mansubat_majroorat_tawjih'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_nahw_syntax_marfuat',
        courseId: courseId,
        title: 'أصول الإعراب والبناء ومرفوعات الأسماء في القرآن والسنة',
        description: 'حقيقة الإعراب والبناء، علامات الإعراب الأصلية والفرعية، ودراسة تفصيلية لمرفوعات الأسماء (الفاعل، نائب الفاعل، المبتدأ والخبر، كان وأخواتها، وإن وأخواتها) مع الشواهد الشرعية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_nahw_irab_bina_foundations',
          'lsn_nahw_marfuat_fail_mubtada',
          'lsn_nahw_marfuat_quranic_applications',
        ],
      ),
      CourseModule(
        moduleId: 'mod_nahw_mansubat_majroorat_tawjih',
        courseId: courseId,
        title: 'المنصوبات والمجرورات وأثر التوجيه الإعرابي في الفقه والتفسير',
        description: 'دراسة منصوبات الأسماء ومجروراتها، إعراب الفعل المضارع، وتطبيقات عملية ممتدة تبرز كيف يبنى الحكم الفقهي والوجه التفسيري على الموقع الإعرابي.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_nahw_syntax_marfuat'],
        lessonIds: const [
          'lsn_nahw_mansubat_mafail_ahwal',
          'lsn_nahw_majroorat_tawabi_afal',
          'lsn_nahw_fiqhi_tafsir_implications',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 1: الإعراب والبناء
      Lesson.create(
        lessonId: 'lsn_nahw_irab_bina_foundations',
        title: 'الإعراب والبناء وعلامات الإعراب الأصلية والفرعية في لسان العرب',
        courseId: courseId,
        moduleId: 'mod_nahw_syntax_marfuat',
        orderIndex: 1,
        sources: const ['src_al_kitab_sibawayh', 'src_sharh_ibn_aqil', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_nahw_1_1',
            title: 'حقيقة الإعراب ودوره الدلالي',
            description: 'استيعاب مفهوم الإعراب بوصفه أثراً ظاهراً أو مقدراً يجلبه العامل ليدل على المعاني الوظيفية في التركيب.',
          ),
          LearningObjective(
            objectiveId: 'obj_nahw_1_2',
            title: 'التمييز بين العلامات الأصلية والفرعية',
            description: 'معرفة أبواب الإعراب بالعلامات الفرعية (الأسماء الستة، المثنى، جمع المذكر والمؤنث السالمين، الممنوع من الصرف، والأفعال الخمسة).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_nahw_1_1',
            title: 'منزلة الإعراب في صيانة المعنى القرآني',
            contentType: LearningContentType.sourceText,
            content: 'الإعراب في كلام العرب ميزان المعاني؛ به يتميز الفاعل من المفعول، والمبتدأ من الخبر، والصفة من التوكيد. قال ابن جني: «الإعراب إنما جيء به للإبانة عن المعاني المعتورة على الأسماء كالفاصل بين الفاعلية والمفعولية والإضافة». ولذا كان اللحن مدخلاً للتحريف والضلال، وامتناع اللحن في تلاوة القرآن الكريم وفهم آياته فريضة شرعية ومقصد إسلامي أصيل صانه علماء النحو منذ عصر أبي الأسود الدؤلي وعلي بن أبي طالب رضي الله عنه.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_1_1',
                evidenceKey: 'khasais:1:35',
                citation: 'الخصائص لابن جني (باب القول على الإعراب)',
                sourceId: 'src_al_kitab_sibawayh',
              ),
            ],
            sourceAttribution: 'الكتاب لسيبويه وشرح ابن عقيل ومقدمة الخصائص لابن جني',
          ),
          LessonSection.create(
            sectionId: 'sec_nahw_1_2',
            title: 'العلامات الأصلية والأبواب السبعة المعربة بالحركات والحروف الفرعية',
            contentType: LearningContentType.explanation,
            content: 'الأصل في الإعراب أن تكون الضمة للرفع، والفتحة للنصب، والكسرة للجر، والسكون للجزم. وتخرج عن هذا الأصل سبعة أبواب تنوب فيها حركات أو حروف: 1. الأسماء الستة (ترفع بالواو وتنصب بالألف وتجر بالياء). 2. المثنى وكلا وكلتا المضافتان لمضمر (يرفع بالألف وينصب ويجر بالياء). 3. جمع المذكر السالم وملحقاته (يرفع بالواو وينصب ويجر بالياء). 4. جمع المؤنث السالم (ينصب بالكسرة نيابة عن الفتحة). 5. الممنوع من الصرف (يجر بالفتحة ما لم يضف أو يقترن بأل). 6. الأفعال الخمسة (ترفع بثبوت النون وتجزم وتنصب بحذفها). 7. المضارع المعتل الآخر (يجزم بحذف حرف العلة).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_1_2',
                evidenceKey: 'alfiyyah:ibn_malik:bab_irab',
                citation: 'ألفية ابن مالك في النحو والصرف',
                sourceId: 'src_sharh_ibn_aqil',
              ),
            ],
            sourceAttribution: 'شرح ابن عقيل على ألفية ابن مالك وأوضح المسالك لابن هشام',
          ),
        ],
      ),

      // Lesson 2: مرفوعات الأسماء
      Lesson.create(
        lessonId: 'lsn_nahw_marfuat_fail_mubtada',
        title: 'مرفوعات الأسماء: الفاعل ونائبه والمبتدأ والخبر ونواسخ الابتداء',
        courseId: courseId,
        moduleId: 'mod_nahw_syntax_marfuat',
        orderIndex: 2,
        sources: const ['src_mughni_labib', 'src_sharh_ibn_aqil', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_nahw_2_1',
            title: 'إتقان أحكام العمدة في الجملة العربية',
            description: 'فهم أركان الإسناد: الفاعل ونائب الفاعل في الجملة الفعلية، والمبتدأ والخبر وأنواعه في الجملة الاسمية.',
          ),
          LearningObjective(
            objectiveId: 'obj_nahw_2_2',
            title: 'النواسخ ودورها الوظيفي والدلالي',
            description: 'استيعاب عمل ومعاني كان وأخواتها وكاد وأخواتها وإن وأخواتها ولا النافية للجنس وظن وأخواتها.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_nahw_2_1',
            title: 'الفاعل ونائب الفاعل وأحكام التأنيث والتقديم والتأخير',
            contentType: LearningContentType.sourceText,
            content: 'الفاعل اسم مرفوع تقدمه فعل تام مبني للمعلوم أو شبهه ودل على من فعل الفعل أو قام به. ونائب الفاعل هو المفعول به الذي أقيم مقام الفاعل بعد حذفه وبني الفعل للمجهول (مجهول الفاعل لأسباب بلاغية كالتعظيم أو العلم به أو الستر). وتتأكد بلاغة النظم في وجوب تقديم الفاعل أو المفعول عند خوف اللبس، وجواز تقديمه لحصر أو تخصيص كما في قوله تعالى: ﴿إِنَّمَا يَخْشَى اللَّهَ مِنْ عِبَادِهِ الْعُلَمَاءُ﴾ حيث تأخر الفاعل (العلماء) لفظاً وتقدم المفعول به المعظم ليفيد قصر الخشية التامة على العلماء.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_2_1',
                evidenceKey: 'quran:35:28',
                citation: 'سورة فاطر: الآية 28',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'مغني اللبيب عن كتب الأعاريب لابن هشام والكشاف للزمخشري',
          ),
          LessonSection.create(
            sectionId: 'sec_nahw_2_2',
            title: 'المبتدأ والخبر ونواسخ الابتداء القرآنية',
            contentType: LearningContentType.explanation,
            content: 'المبتدأ هو الاسم المجرد عن العوامل اللفظية مسنداً إليه، والخبر هو الجزء المتم للفائدة به. وتدخل على المبتدأ والخبر النواسخ فتغير حكمهما الإعرابي وتضيف معاني زمنية وتأكيدية: كان وأخواتها ترفع المبتدأ وتنصب الخبر وتفيد توقيت النسبة (الاتصاف بالخبر في الماضي أو الدوام كقوله تعالى ﴿وَكَانَ اللَّهُ غَفُوراً رَحِيماً﴾ للدلالة على أزلية الصفة وأبديتها)، وإن وأخواتها تنصب المبتدأ وترفع الخبر وتفيد التوكيد ونفي الشك والاستدراك والتمني والترجي والتشبيه.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_2_2',
                evidenceKey: 'quran:4:96',
                citation: 'سورة النساء: الآية 96',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'شرح التصريح على التوضيح والإنصاف في مسائل الخلاف للأنباري',
          ),
        ],
      ),

      // Lesson 3: تطبيقات قرآنية ونماذج إعرابية للمرفوعات
      Lesson.create(
        lessonId: 'lsn_nahw_marfuat_quranic_applications',
        title: 'تطبيقات قرآنية ونماذج إعرابية للمرفوعات ودورها في تعيين المعنى',
        courseId: courseId,
        moduleId: 'mod_nahw_syntax_marfuat',
        orderIndex: 3,
        sources: const ['src_irab_al_quran_nahhas', 'src_durr_al_masun', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_nahw_3_1',
            title: 'إعراب سورة الفاتحة ومفاتيح الآيات',
            description: 'التطبيق العملي المفصل لإعراب أركان الجمل في أم الكتاب وسور المفصل واستجلاء أسرار البناء.',
          ),
          LearningObjective(
            objectiveId: 'obj_nahw_3_2',
            title: 'تطبيقات على نواسخ الابتداء وتعدد الأوجه',
            description: 'القدرة على تحليل النماذج الإعرابية المشكلة في القرآن الكريم وتوجيه القراءات المتواترة وفق المرفوعات.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_nahw_3_1',
            title: 'الإعراب التحليلي لسورة الفاتحة: أركان الإسناد ونظم المعاني',
            contentType: LearningContentType.sourceText,
            content: 'في قوله تعالى ﴿الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ﴾: «الحمدُ» مبتدأ مرفوع بالضمة الظاهرة، «لله» جار ومجرور متعلقان بمحذوف خبر المبتدأ تقديره كائن أو مستقر، وفائدة الابتداء بالاسم الدلالة على ثبوت الحمد واستقراره لله أزلاً وأبداً بخلاف الجملة الفعلية الدالة على الحدوث والتجدد. وفي قوله ﴿إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ﴾: «إياك» ضمير منفصل في محل نصب مفعول به مقدم وجوباً لإفادة الحصر والقصر (لا نعبد إلا أنت ولا نستعين بسواك)، و«نعبد» فعل مضارع مرفوع بالضمة وفاعله ضمير مستتر وجوباً تقديره نحن.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_3_1',
                evidenceKey: 'quran:1:2-5',
                citation: 'سورة الفاتحة: الآيات 2 إلى 5',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'إعراب القرآن للنحاس والدر المصون للسمين الحلبي',
          ),
          LessonSection.create(
            sectionId: 'sec_nahw_3_2',
            title: 'أوجه الرفع في القراءات وأثرها الدلالي: ﴿لَيْسَ الْبِرَّ / الْبِرُّ﴾',
            contentType: LearningContentType.scholarlyView,
            content: 'في قوله تعالى: ﴿لَيْسَ الْبِرَّ أَن تُوَلُّوا وُجُوهَكُمْ﴾ قرأ حمزة وحفص بنصب «البرَّ» على أنه خبر «ليس» مقدم، والمصدر المؤول «أن تولوا» في محل رفع اسمها المؤخر؛ أي: ليس توليتكم وجوهكم هو البر الحقيقي. وقرأ الباقون برفع «البرُّ» على أنه اسم «ليس»، والمصدر المؤول في محل نصب خبرها؛ وكلا التوجيهين يلتقيان في نفي انحصار البر في مجرد الهيئة الظاهرة دون الإيمان الراسخ والعمل الصالح، مما يبرز كيف يثري الإعراب المعاني الإيمانية دون تناقض.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_3_2',
                evidenceKey: 'quran:2:177',
                citation: 'سورة البقرة: الآية 177',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'معاني القرآن للفراء والحجة للقراء السبعة لأبي علي الفارسي',
          ),
        ],
      ),

      // Lesson 4: المنصوبات والمفاعيل
      Lesson.create(
        lessonId: 'lsn_nahw_mansubat_mafail_ahwal',
        title: 'منصوبات الأسماء: المفاعيل الخمسة، الحال، التمييز، والاستثناء في النظم القرآني',
        courseId: courseId,
        moduleId: 'mod_nahw_mansubat_majroorat_tawjih',
        orderIndex: 4,
        sources: const ['src_al_kitab_sibawayh', 'src_sharh_ibn_aqil', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_nahw_4_1',
            title: 'إتقان المفاعيل الخمسة واستعمالاتها',
            description: 'معرفة الفروق الدقيقة بين المفعول به، المطلق، لأجله، فيه (الظرف)، ومعه، وأسرار ورودها في الذكر الحكيم.',
          ),
          LearningObjective(
            objectiveId: 'obj_nahw_4_2',
            title: 'فقه الحال والتمييز والاستثناء',
            description: 'التمييز بين الحال الدالة على الهيئة المتنقلة والتمييز المفسر للمبهم، وأحكام المستثنى بإلا وغير وسوى.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_nahw_4_1',
            title: 'المفاعيل الخمسة في التراكيب القرآنية ودقة الدلالة',
            contentType: LearningContentType.sourceText,
            content: 'المنصوبات فضلة تدل على ملابسات الفعل وتفاصيل وقوعه: فالمفعول المطلق يؤكد الفعل أو يبين نوعه أو عدده ﴿وَكَلَّمَ اللَّهُ مُوسَى تَكْلِيماً﴾ لنفي المجاز وإثبات الحقيقة، والمفعول لأجله يبين علة وقوع الفعل وداعجه القلبي ﴿يَجْعَلُونَ أَصَابِعَهُمْ فِي آذَانِهِم مِّنَ الصَّوَاعِقِ حَذَرَ الْمَوْتِ﴾، والمفعول فيه يعين وعاء الزمان أو المكان، والمفعول معه يعين المصاحبة بعد واو المعية، والمفعول به يقع عليه أثر الفاعل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_4_1',
                evidenceKey: 'quran:4:164',
                citation: 'سورة النساء: الآية 164',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الكتاب لسيبويه وشرح المفصل لابن يعيش',
          ),
          LessonSection.create(
            sectionId: 'sec_nahw_4_2',
            title: 'الحال والتمييز وأحكام الاستثناء في نصوص التشريع',
            contentType: LearningContentType.explanation,
            content: 'الحال وصف فضلة يبين هيئة الفاعل أو المفعول حين وقوع الفعل (كقوله ﴿وَخُلِقَ الإِنسَانُ ضَعِيفاً﴾)، والتمييز اسم فضلة نكرة يرفع الإبهام عن اسم مفرد أو عن نسبة جملة (كقوله ﴿فَتَمَّ مِيقَاتُ رَبِّهِ أَرْبَعِينَ لَيْلَةً﴾ و﴿وَاشْتَعَلَ الرَّأْسُ شَيْباً﴾). أما الاستثناء فهو إخراج ما لولاه لدخل في الكلام، وتتفرع عنه أحكام تشريعية عظمى؛ فالاستثناء المتصل يرفع الحكم عما بعد أداة الاستثناء كقوله تعالى في كفارة اليمين والقصاص، والاستثناء المنقطع يفيد معنى الاستدراك.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_4_2',
                evidenceKey: 'quran:4:28',
                citation: 'سورة النساء: الآية 28',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'البرهان في علوم القرآن للزركشي وتسهيل الفوائد لابن مالك',
          ),
        ],
      ),

      // Lesson 5: المجرورات والتوابع والأفعال
      Lesson.create(
        lessonId: 'lsn_nahw_majroorat_tawabi_afal',
        title: 'مجرورات الأسماء والتوابع، ونواصب وجوازم الفعل المضارع',
        courseId: courseId,
        moduleId: 'mod_nahw_mansubat_majroorat_tawjih',
        orderIndex: 5,
        sources: const ['src_sharh_ibn_aqil', 'src_mughni_labib', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_nahw_5_1',
            title: 'معاني حروف الجر والإضافة',
            description: 'استيعاب معاني حروف الجر ودلالات الإضافة المحضة وغير المحضة وأسرارها في نصوص الوحيين.',
          ),
          LearningObjective(
            objectiveId: 'obj_nahw_5_2',
            title: 'التوابع وإعراب الفعل المضارع',
            description: 'فهم النعت والتوكيد والعطف والبدل، وأدوات نصب وجزم المضارع وأسلوب الشرط وجوابه الجزائي.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_nahw_5_1',
            title: 'مجرورات الأسماء ومعاني حروف الجر ونظام الإضافة',
            contentType: LearningContentType.sourceText,
            content: 'الجر خاص بالأسماء؛ ويكون بالحرف أو بالإضافة أو بالتبعية. وحروف الجر أوعية للمعاني الدقيقة: فـ«مِن» تكون للابتداء والتبعيض وبيان الجنس، و«إلى» لانتهاء الغاية، و«الباء» للإلصاق والاستعانة والسببية والتبعيض (وهي من مثارات الخلاف الفقهي الكبرى في آية الوضوء ﴿وَامْسَحُواْ بِرُؤُوسِكُمْ﴾)، و«في» للظرفية المكانية والمجازية والسببية كقوله ﷺ: «دخلت امرأة النار في هرة»، والإضافة تكون على معنى اللام للملك، أو مِن للبيان، أو في للظرفية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_5_1',
                evidenceKey: 'bukhari:3318',
                citation: 'صحيح البخاري: حديث رقم 3318',
                sourceId: 'src_mughni_labib',
              ),
            ],
            sourceAttribution: 'مغني اللبيب لابن هشام وجنى الداني في حروف المعاني للمرادي',
          ),
          LessonSection.create(
            sectionId: 'sec_nahw_5_2',
            title: 'التوابع الأربعة وجوازم ونواصب الفعل المضارع وأدوات الشرط',
            contentType: LearningContentType.explanation,
            content: 'التوابع تشارك ما قبلها في إعرابه: النعت (للتوضيح أو التخصيص أو المدح)، التوكيد (لفظي ومعنوي لدفع توهم السهو والشك)، العطف (بالحروف لإفادة الجمع أو الترتيب والتعقيب أو التراخي أو التخيير)، والبدل (التابع المقصود بالحكم بلا واسطة). أما الفعل المضارع فيرفع إذا تجرد من الناصب والجازم، وينصب بـ(أن، لن، إذن، كي) وبأن مضمرة بعد فاء السببية ولام الجحود وحتى، ويجزم بحرف يجزم فعلاً واحداً كـ(لم، لما، لام الأمر، لا الناهية) أو بأدوات الشرط الجازمة لفعلين التي تبنى عليها أحكام الجزاء والوعود في القرآن.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_5_2',
                evidenceKey: 'alfiyyah:ibn_malik:tawabi',
                citation: 'ألفية ابن مالك في النحو (باب التوابع والجوازم)',
                sourceId: 'src_sharh_ibn_aqil',
              ),
            ],
            sourceAttribution: 'شرح الأشموني على ألفية ابن مالك وشرح قطر الندى وبل الصدى',
          ),
        ],
      ),

      // Lesson 6: أثر التوجيه النحوي في الفقه والتفسير
      Lesson.create(
        lessonId: 'lsn_nahw_fiqhi_tafsir_implications',
        title: 'أثر التوجيه الإعرابي في استنباط الأحكام الفقهية وتعدد أوجه التفسير',
        courseId: courseId,
        moduleId: 'mod_nahw_mansubat_majroorat_tawjih',
        orderIndex: 6,
        sources: const ['src_al_burhan_zarkashi', 'src_durr_al_masun', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_nahw_6_1',
            title: 'الربط بين الموقع الإعرابي والحكم الشرعي',
            description: 'تحليل مسائل فقهية خلافية كبرى متولدة مباشرة من اختلاف التوجيه الإعرابي وحروف المعاني.',
          ),
          LearningObjective(
            objectiveId: 'obj_nahw_6_2',
            title: 'التطبيقات في آيات الأحكام (الوضوء، الطهارة، الإشهاد)',
            description: 'دراسة تطبيقية لإعراب آية الوضوء (وأرجلَكم/وأرجلِكم)، وآية الصيد واليمين والإشهاد على العقود.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_nahw_6_1',
            title: 'أثر الإعراب في مسألة غسل الرجلين ومسحهما في آية الوضوء',
            contentType: LearningContentType.scholarlyView,
            content: 'في قوله تعالى: ﴿يَا أَيُّهَا الَّذِينَ آمَنُواْ إِذَا قُمْتُمْ إِلَى الصَّلاةِ فاغْسِلُواْ وُجُوهَكُمْ وَأَيْدِيَكُمْ إِلَى الْمَرَافِقِ وَامْسَحُواْ بِرُؤُوسِكُمْ وَأَرْجُلَكُمْ إِلَى الْكَعْبَينِ﴾ قرأ نافع وابن عامر والكسائي وحفص بنصب «وأرجلَكم»، وقرأ ابن كثير وأبو عمرو وحمزة وشعبة بجر «وأرجلِكم». وجه النصب هو العطف على المنصوب ﴿وُجُوهَكُمْ وَأَيْدِيَكُمْ﴾ المغسولتين؛ فوجب غسل الرجلين وهو مذهب جماهير فقهاء الأمة. وأما وجه الجر فعند المحققين هو مجرور على الجوار للرأس لفظاً ومغسول حكماً، أو محمول على المسح على الخفين بالسنة الصحيحة، فبين التوجيه النحوي اتفاق القرآن والسنة على فرض الغسل واستحباب أو رخصة المسح على الخف.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_6_1',
                evidenceKey: 'quran:5:6',
                citation: 'سورة المائدة: الآية 6',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير القرطبي والمغني لابن قدامة والدر المصون للسمين الحلبي',
          ),
          LessonSection.create(
            sectionId: 'sec_nahw_6_2',
            title: 'تطبيقات إعرابية أخرى: عطف التوهم، الاستثناء بعد جمل متعاطفة، وحروف المعاني',
            contentType: LearningContentType.sourceText,
            content: 'من القضايا الأصولية الفقهية النحوية: عود الاستثناء بعد الجمل المتعاطفة كقوله تعالى في حد القذف: ﴿وَالَّذِينَ يَرْمُونَ الْمُحْصَنَاتِ ثُمَّ لَمْ يَأْتُوا بِأَرْبَعَةِ شُهَدَاءَ فَاجْلِدُوهُمْ ثَمَانِينَ جَلْدَةً وَلا تَقْبَلُوا لَهُمْ شَهَادَةً أَبَداً وَأُوْلَئِكَ هُمُ الْفَاسِقُونَ * إِلاَّ الَّذِينَ تَابُوا﴾، هل يعود الاستثناء للجملة الأخيرة فقط (سقوط الفسق دون قبول الشهادة عند الحنفية) أم يعود لجميع الجمل المتعاطفة بالواو فيسقط الفسق وتقبل الشهادة بعد التوبة (عند المالكية والشافعية والحنابلة)؟ هذا الخلاف مبني تماماً على قواعد عطف الجمل والتعليق النحوي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_nahw_6_2',
                evidenceKey: 'quran:24:4-5',
                citation: 'سورة النور: الآيتان 4 و 5',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الإحكام في أصول الأحكام للآمدي ومفاتيح الغيب للرازي والبرهان للزركشي',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_nahw_syntax_marfuat',
        lessonId: 'lsn_nahw_marfuat_quranic_applications',
        title: 'اختبار تقييم استيعاب: أصول الإعراب والبناء ومرفوعات الأسماء',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_nahw_1',
            lessonId: 'lsn_nahw_marfuat_quranic_applications',
            questionText: 'ما المعنى البلاغي والنحوي لتقديم المفعول به في قوله تعالى: ﴿إِنَّمَا يَخْشَى اللَّهَ مِنْ عِبَادِهِ الْعُلَمَاءُ﴾؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qnh1_1', text: 'قصر الخشية الحقيقية الكاملة وإثباتها للعلماء دون غيرهم من الجهال'),
              QuizOption(optionId: 'opt_qnh1_2', text: 'الدلالة على أن الله هو الذي يخشى العلماء حاشا وكلا'),
              QuizOption(optionId: 'opt_qnh1_3', text: 'مجرد ترتيب عشوائي لا يترتب عليه أي معنى دلالي'),
              QuizOption(optionId: 'opt_qnh1_4', text: 'وجوب تقديم المفعول به دائماً في كل جملة فعلية'),
            ],
            correctOptionIndices: const [0],
            explanation: 'تقدم لفظ الجلالة مفعولاً به بهدف قصر الخشية التامة على الفاعل المؤخر وهم العلماء، لأنهم الأعلم بجلال الله وعظمته.',
          ),
          QuizQuestion.create(
            questionId: 'q_nahw_2',
            lessonId: 'lsn_nahw_marfuat_quranic_applications',
            questionText: 'أي من الأسماء التالية يرفع بالواو نيابة عن الضمة باتفاق النحاة إذا استوفى الشروط؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qnh2_1', text: 'جمع المؤنث السالم والاسم المفرد'),
              QuizOption(optionId: 'opt_qnh2_2', text: 'جمع المذكر السالم والأسماء الستة (المضافة لغير ياء المتكلم)'),
              QuizOption(optionId: 'opt_qnh2_3', text: 'المثنى وكلا وكلتا المضافتان لاسم ظاهر'),
              QuizOption(optionId: 'opt_qnh2_4', text: 'الممنوع من الصرف والاسم المقصور'),
            ],
            correctOptionIndices: const [1],
            explanation: 'يرفع بالواو نيابة عن الضمة جمع المذكر السالم وملحقاته والأسماء الستة حال إضافتها لغير ياء المتكلم.',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_nahw_mansubat_majroorat_tawjih',
        lessonId: 'lsn_nahw_fiqhi_tafsir_implications',
        title: 'اختبار تقييم استيعاب: المنصوبات والمجرورات وأثر التوجيه النحوي الفقهي',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_nahw_3',
            lessonId: 'lsn_nahw_fiqhi_tafsir_implications',
            questionText: 'ما توجيه قراءة نصب «وأرجلَكم» في آية الوضوء ﴿وَامْسَحُواْ بِرُؤُوسِكُمْ وَأَرْجُلَكُمْ﴾ عند جمهور المفسرين والفقهاء؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qnh3_1', text: 'معطوفة على المنصوب في ﴿فَاغْسِلُواْ وُجُوهَكُمْ وَأَيْدِيَكُمْ﴾ فتوجب غسل الرجلين'),
              QuizOption(optionId: 'opt_qnh3_2', text: 'معطوفة على المجرور بالباء ﴿بِرُؤُوسِكُمْ﴾ فتوجب مسح الرجلين دائماً'),
              QuizOption(optionId: 'opt_qnh3_3', text: 'مفعول مطلق منصوب يؤكد عملية المسح على الرأس'),
              QuizOption(optionId: 'opt_qnh3_4', text: 'حال منصوبة تبين هيئة الوضوء'),
            ],
            correctOptionIndices: const [0],
            explanation: 'قراءة النصب تعطف الرجلين على المغسولين (الوجوه والأيدي)، فتوجب غسل الرجلين إلى الكعبين وهو مذهب جماهير علماء الأمة.',
          ),
          QuizQuestion.create(
            questionId: 'q_nahw_4',
            lessonId: 'lsn_nahw_fiqhi_tafsir_implications',
            questionText: 'ما وظيفة المفعول المطلق في قوله تعالى: ﴿وَكَلَّمَ اللَّهُ مُوسَى تَكْلِيماً﴾؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qnh4_1', text: 'تأكيد حقيقة التكليم ونفي توهم المجاز والاستعارة'),
              QuizOption(optionId: 'opt_qnh4_2', text: 'بيان ظرف الزمان الذي وقع فيه التكليم'),
              QuizOption(optionId: 'opt_qnh4_3', text: 'تبيين علة الكلام وسببه القلبي'),
              QuizOption(optionId: 'opt_qnh4_4', text: 'بيان هيئة موسى عليه السلام حين التكليم'),
            ],
            correctOptionIndices: const [0],
            explanation: 'المصدر (تكليماً) مفعول مطلق مؤكد لعامله، وفائدته التأصيلية عند أهل السنة واللغة تأكيد الحقيقة ونفي المجاز.',
          ),
        ],
      ),
    ];
  }
}
