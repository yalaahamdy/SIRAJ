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

/// بيانات مقرر فقه اللغة واللسانيات الشرعية ودلالات الألفاظ الاستنباطية (6 دروس تأصيلية + اختباران استيعاب)
class LearningDalalatAlfazSemanticsData {
  static const String courseId = 'course_dalalat_alfaz_semantics';
  static const String pathId = 'path_arabic_language_bayan_semantics_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه اللغة واللسانيات الشرعية ودلالات الألفاظ الاستنباطية',
      description: 'دراسة تأصيلية لفقه اللغة العربية وخصائصها الفريدة (الاشتقاق بأنواعه، الترادف، المشترك اللفظي، التضاد، واتساع لسان العرب)، ودراسة منظومة دلالات الألفاظ وطرق الاستنباط الأصولية (المنطوق والمفهوم، دلالة الإشارة والاقتضاء والإيماء)، مع نقد علمي للقراءات الحداثية المنحرفة لنصوص الشريعة.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_fiqh_al_lughah_khasais', 'mod_dalalat_usuliyyah_istinbat'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_fiqh_al_lughah_khasais',
        courseId: courseId,
        title: 'فقه اللغة العربية وخصائص اللسان القرآني واتساع معانيه',
        description: 'نشأة وتدوين فقه اللغة، عبقرية اللسان العربي في المعاجم، الاشتقاق الأكبر والأصغر، الترادف والمشترك والتضاد، وأسرار الفروق اللغوية الدقيقة بين الألفاظ القرآنية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_dalalat_fiqh_lughah_origins',
          'lsn_dalalat_ishtiqaaq_taraduf_ishtirak',
          'lsn_dalalat_ittisa_taarib_asaleeb',
        ],
      ),
      CourseModule(
        moduleId: 'mod_dalalat_usuliyyah_istinbat',
        courseId: courseId,
        title: 'دلالات الألفاظ عند الأصوليين ومناهج الاستنباط وصيانة النص',
        description: 'تقسيمات الألفاظ ودلالاتها عند الأصوليين: المنطوق والمفهوم بنوعيه، دلالات الإشارة والاقتضاء والإيماء، وقواعد صيانة النص الشرعي من التأويلات المعاصرة المنحرفة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_fiqh_al_lughah_khasais'],
        lessonIds: const [
          'lsn_dalalat_mantuq_mafhum_usul',
          'lsn_dalalat_isharah_iqtida_ima',
          'lsn_dalalat_contemporary_hermeneutics_critique',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 1: نشأة فقه اللغة وعبقرية اللسان
      Lesson.create(
        lessonId: 'lsn_dalalat_fiqh_lughah_origins',
        title: 'نشأة فقه اللغة ومعاجم المعاني وعبقرية اللسان العربي (ابن جني وابن فارس والثعالبي)',
        courseId: courseId,
        moduleId: 'mod_fiqh_al_lughah_khasais',
        orderIndex: 1,
        sources: const ['src_al_khasais_ibn_jinni', 'src_as_sahibi_ibn_faris', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_dalalat_1_1',
            title: 'حقيقة فقه اللغة ومصادره الكبرى',
            description: 'التمييز بين علم متن اللغة (المعاجم الألفاظية) وفقه اللغة (دراسة فلسفة اللغة وأسرار نموها وطبائع العرب في كلامهم).',
          ),
          LearningObjective(
            objectiveId: 'obj_dalalat_1_2',
            title: 'معالم التأليف في فقه اللغة',
            description: 'استيعاب إسهامات «الخصائص» لابن جني، و«الصاحبي في فقه اللغة» لابن فارس، و«فقه اللغة وسر العربية» للثعالبي، و«المزهر» للسيوطي.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_dalalat_1_1',
            title: 'الفرق بين علم متن اللغة وفقه اللغة',
            contentType: LearningContentType.sourceText,
            content: 'علم متن اللغة يُعنى بجمع الألفاظ وضبط معانيها الوضعية وتوثيق شواردها في المعاجم كـ«العين» للخليل و«تهذيب اللغة» للأزهري و«لسان العرب» لابن منظور. أما "فقه اللغة" فهو العلم الذي يبحث في أسرار بنية اللسان العربي، وحكمة أوضاعه، وخصائصه في الاشتقاق والقياس، والتعليل اللغوي، ونواميس التطور الدلالي، ومناسبات الحروف للمعاني. قال أحمد بن فارس في كتابه الصاحبي: «فقه اللغة هو معرفة سنن العرب في كلامها، ومذاهبها في البيان، وافتنانها في الخطاب».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_1_1',
                evidenceKey: 'as_sahibi:ibn_faris:bab_1',
                citation: 'الصاحبي في فقه اللغة وسنن العرب في كلامها لابن فارس',
                sourceId: 'src_as_sahibi_ibn_faris',
              ),
            ],
            sourceAttribution: 'الصاحبي لابن فارس والخصائص لابن جني والمزهر للسيوطي',
          ),
          LessonSection.create(
            sectionId: 'sec_dalalat_1_2',
            title: 'أثر فقه اللغة في سلامة الاستنباط الفقهي والعقدي',
            contentType: LearningContentType.explanation,
            content: 'بيّن أئمة الإسلام كالشافعي وأحمد وابن تيمية والشاطبي أن الجهل بفقه اللغة العربية ومذاهب العرب في خطابها هو أس البلاء ومنشأ البدع والضلالات التأويلية؛ فالنصوص الشرعية نزلت بلسان عربي مبين، فلا يحل لأحد تفسيرها بمصطلحات محدثة أو بلوازم لغات أعجمية. قال الإمام الشافعي في «الرسالة»: «وإنما بدأت بما وضعت من أن القرآن نزل بلسان العرب دون غيره؛ لأنه لا يعلم إيضاح جمل علم الكتاب أحدٌ جهل سعة لسان العرب وكثرة وجوهه، وجماع معانيه وتفرقها، ومن علمه انتفت عنه الشبه التي دخلت على من جهل لسانها».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_1_2',
                evidenceKey: 'shafii:risalah:bayan_arabi',
                citation: 'الرسالة للإمام الشافعي (جماع علم البيان ونزول القرآن بلسان العرب)',
                sourceId: 'src_as_sahibi_ibn_faris',
              ),
            ],
            sourceAttribution: 'الرسالة للإمام الشافعي والموافقات للشاطبي',
          ),
        ],
      ),

      // Lesson 2: الاشتقاق والترادف والمشترك
      Lesson.create(
        lessonId: 'lsn_dalalat_ishtiqaaq_taraduf_ishtirak',
        title: 'الاشتقاق الأكبر والأصغر، الترادف والاشتراك والتضاد وأثرها في فهم النصوص',
        courseId: courseId,
        moduleId: 'mod_fiqh_al_lughah_khasais',
        orderIndex: 2,
        sources: const ['src_al_khasais_ibn_jinni', 'src_maqayis_al_lughah', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_dalalat_2_1',
            title: 'أنواع الاشتقاق (الصغير، الكبير، والأكبر)',
            description: 'فهم الاشتقاق الصغير (التصريف)، والكبير (القلب المكاني)، والأكبر (إبدال حرف بآخر مقارب)، والاشتقاق المعنوي عند ابن فارس في «مقاييس اللغة».',
          ),
          LearningObjective(
            objectiveId: 'obj_dalalat_2_2',
            title: 'الترادف والمشترك والتضاد في نصوص الوحي',
            description: 'نفي الترادف التام في القرآن الكريم، وتوجيه المشترك اللفظي كـ(القرء في الطهر والحيض، وعسعس في أقبل وأدبر).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_dalalat_2_1',
            title: 'الاشتقاق العربي وعبقرية «مقاييس اللغة» لابن فارس',
            contentType: LearningContentType.sourceText,
            content: 'الاشتقاق هو توليد الكلمات من أصل واحد يدل على معنى كلي جامع. وأبدع ابن فارس في «معجم مقاييس اللغة» بنظرية الأصول؛ حيث يرد كل مواد اللغة إلى أصلين أو ثلاثة أصول معنوية متقاربة تدور حولها مشتقات المادة كلها. فمادة (ف ل ق) أصلها الشق والصدع، ومنه فلق الصبح ﴿فَالِقُ الإِصْبَاحِ﴾، وفلق الحبة ﴿فَالِقُ الْحَبِّ وَالنَّوَى﴾، وفلق البحر ﴿فَانفَلَقَ فَكَانَ كُلُّ فِرْقٍ كَالطَّوْدِ الْعَظِيمِ﴾. وبذا يربط علم الاشتقاق كل كلمة في القرآن بجذرها الفطري الحسي ليفيض بالمعنى الغيبي والتكليفي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_2_1',
                evidenceKey: 'maqayis_lughah:bab_falaqa',
                citation: 'معجم مقاييس اللغة لأحمد بن فارس (مادة فلق)',
                sourceId: 'src_maqayis_al_lughah',
              ),
            ],
            sourceAttribution: 'مقاييس اللغة لابن فارس والخصائص لابن جني',
          ),
          LessonSection.create(
            sectionId: 'sec_dalalat_2_2',
            title: 'نفي الترادف التام وأثر المشترك اللفظي في الخلاف الفقهي',
            contentType: LearningContentType.explanation,
            content: 'ذهب المحققون من علماء اللغة والتفسير كأبي هلال العسكري وابن تيمية وابن القيم إلى امتناع الترادف التام في القرآن؛ فلا توجد كلمتان تدلان على معنى واحد من كل وجه دون فارق دقيق في الصفة أو الشدة؛ فالجلسة غير القعدة، والرؤية غير النظر والشهود، والخوف غير الخشية، والغيث غير المطر. أما المشترك اللفظي فهو لفظ واحد وُضع لمعنيين مختلفين كـ(القَرْء)؛ وضع في لسان العرب للحيض وللطهر معاً، فكان منشأ الخلاف التاريخي العظيم في عدة المطلقة ﴿وَالْمُطَلَّقَاتُ يَتَرَبَّصْنَ بِأَنفُسِهِنَّ ثَلاثَةَ قُرُوءٍ﴾: هل هي ثلاثة أطهار (مذهب مالك والشافعي) أم ثلاث حيضات (مذهب أبي حنيفة وأحمد)؟',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_2_2',
                evidenceKey: 'quran:2:228',
                citation: 'سورة البقرة: الآية 228',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الفروق اللغوية لأبي هلال العسكري ومجموع الفتاوى وبداية المجتهد',
          ),
        ],
      ),

      // Lesson 3: اتساع لسان العرب والتعريب
      Lesson.create(
        lessonId: 'lsn_dalalat_ittisa_taarib_asaleeb',
        title: 'اتساع لسان العرب، التعريب، والنحت وخصائص الإعجاز المعجمي',
        courseId: courseId,
        moduleId: 'mod_fiqh_al_lughah_khasais',
        orderIndex: 3,
        sources: const ['src_al_muzhar_suyuti', 'src_as_sahibi_ibn_faris', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_dalalat_3_1',
            title: 'حقيقة التعريب وموقف الأئمة من الألفاظ المعربة في القرآن',
            description: 'الجمع بين نزول القرآن عربياً كاملاً ووجود ألفاظ أعجمية الأصل عرّبتها العرب وتصرفت فيها قبل نزول الوحي.',
          ),
          LearningObjective(
            objectiveId: 'obj_dalalat_3_2',
            title: 'النحت والتضمين والاتساع الصوتي',
            description: 'فهم أسلوب النحت العربي، وتضمين الأفعال معاني حروف الجر وتعديتها بما يثري المعنى دون حاجة للتقدير والحذف.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_dalalat_3_1',
            title: 'قضية المعرب في القرآن وتوجيه المحققين للجمع بين الأقوال',
            contentType: LearningContentType.sourceText,
            content: 'اختلف العلماء في وقوع المعرب في القرآن: فأنكر الإمام الشافعي وابن فارس وأبو عبيدة ذلك تمسكاً بقوله تعالى ﴿قُرْآناً عَرَبِيّاً غَيْرَ ذِي عِوَجٍ﴾. وذهب ابن عباس وعكرمة والسيوطي في «المهذب» إلى وقوع ألفاظ يسيرة أصلها أعجمي كـ(القسطاس، الإستبرق، السجيل، المشكاة). والتحقيق الجامع الذي قرره الطبري وابن عطية والنووي أن هذه الألفاظ كانت أعجمية الأصول، لكن العرب الفصحاء تلقتها ونطقتها وعدلتها على أوزان كلامها وصارت جارية على ألسنتهم قبل نزول القرآن بزمن طويل، فلما نزل القرآن نزل بها وهي من لسان العرب المتداول، فلم تخرج عن عربية النظم واللسان.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_3_1',
                evidenceKey: 'muzhar:suyuti:nau_muarrab',
                citation: 'المزهر في علوم اللغة وأنواعها لجلال الدين السيوطي (النوع 19: المعرب)',
                sourceId: 'src_al_muzhar_suyuti',
              ),
            ],
            sourceAttribution: 'المزهر للسيوطي وتفسير الطبري والمحرر الوجيز لابن عطية',
          ),
          LessonSection.create(
            sectionId: 'sec_dalalat_3_2',
            title: 'أسلوب التضمين في اللسان العربي والقرآن الكريم',
            contentType: LearningContentType.explanation,
            content: 'التضمين هو إشراف فعل على فعل آخر فيعطى حكمه ويتعدى بتعديته، وهو من أبلغ أساليب الاتساع في العربية لأنه يجمع معنيين في لفظ واحد: كقوله تعالى: ﴿عَيْناً يَشْرَبُ بِهَا عِبَادُ اللَّهِ﴾؛ عدّى الفعل (يشرب) بالباء، لأن المعنى يشرب منها ويروى بها؛ فضمن الشرب معنى الري الكامل. وكذا ﴿وَنَصَرْنَاهُ مِنَ الْقَوْمِ الَّذِينَ كَذَّبُواْ﴾ عداه بـ(مِن) لتضمين النصر معنى النجاة والحماية؛ أي نصرناه ونجيناه منهم. وهذا يدفع تكلف النحاة في دعوى تناوب حروف الجر بغير فائدة بلاغية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_3_2',
                evidenceKey: 'quran:76:6',
                citation: 'سورة الإنسان: الآية 6',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الخصائص لابن جني ومجموع الفتاوى لابن تيمية والكشاف للزمخشري',
          ),
        ],
      ),

      // Lesson 4: المنطوق والمفهوم
      Lesson.create(
        lessonId: 'lsn_dalalat_mantuq_mafhum_usul',
        title: 'دلالة المنطوق (الصريح وغير الصريح) ودلالة المفهوم (الموافقة والمخالفة) وشروط الاحتجاج',
        courseId: courseId,
        moduleId: 'mod_dalalat_usuliyyah_istinbat',
        orderIndex: 4,
        sources: const ['src_al_mustasfa_ghazali', 'src_sharh_al_kawkab_al_munir', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_dalalat_4_1',
            title: 'أقسام المنطوق الصريح وغير الصريح',
            description: 'استيعاب المنطوق الصريح (النص والظاهر) وغير الصريح (دلالة الاقتضاء والإشارة والإيماء).',
          ),
          LearningObjective(
            objectiveId: 'obj_dalalat_4_2',
            title: 'مفهوم الموافقة ومفهوم المخالفة وشروطه',
            description: 'التمييز بين مفهوم الموافقة (لحن الخطاب وفحوى الخطاب) ومفاهيم المخالفة (الوصف، الشرط، الغاية، العدد، واللقب) وشروط الاحتجاج بها.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_dalalat_4_1',
            title: 'دلالة المنطوق ومفهوم الموافقة بنوعيه',
            contentType: LearningContentType.sourceText,
            content: 'المنطوق هو ما دل عليه اللفظ في محل النطق؛ فإن كان اللفظ لا يحتمل إلا معنى واحداً فهو "النص" كالأعداد ﴿فَصِيَامُ ثَلاثَةِ أَيَّامٍ﴾، وإن احتمل معنيين أحدهما أظهر فهو "الظاهر". أما "مفهوم الموافقة" فهو دلالة اللفظ على ثبوت حكم المنطوق للمسكوت عنه لموافقته له في علة الحكم: فإن كان المسكوت عنه أولى بالحكم من المنطوق سمي "فحوى الخطاب" كتحريم الضرب والشتم المفهوم من تحريم التأفيف ﴿فَلا تَقُل لَّهُمَا أُفٍّ﴾، وإن كان مساوياً سمي "لحن الخطاب" كإحراق مال اليتيم المفهوم من تحريم أكله ﴿إِنَّ الَّذِينَ يَأْكُلُونَ أَمْوَالَ الْيَتَامَى ظُلْماً﴾.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_4_1',
                evidenceKey: 'quran:17:23',
                citation: 'سورة الإسراء: الآية 23',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'المستصفى للغزالي وشرح الكوكب المنير والبرهان لإمام الحرمين الجويني',
          ),
          LessonSection.create(
            sectionId: 'sec_dalalat_4_2',
            title: 'مفهوم المخالفة وشروط اعتباره عند الأصوليين',
            contentType: LearningContentType.explanation,
            content: 'مفهوم المخالفة (دليل الخطاب) هو دلالة اللفظ على ثبوت نقيض حكم المنطوق للمسكوت عنه لانتفاء قيده المعتبر. وأقسامه خمسة معتبرة عند الجمهور (المالكية والشافعية والحنابلة وخالف الحنفية): 1. مفهوم الوصف (في سائمة الغنم زكاة، فيدل على نفي الزكاة عن المعلوفة). 2. مفهوم الشرط ﴿وَإِن كُنَّ أُولاتِ حَمْلٍ فَأَنفِقُوا عَلَيْهِنَّ﴾. 3. مفهوم الغاية ﴿ثُمَّ أَتِمُّواْ الصِّيَامَ إِلَى الَّليْلِ﴾. 4. مفهوم العدد ﴿فَاجْلِدُوهُمْ ثَمَانِينَ جَلْدَةً﴾. 5. مفهوم الحصر. ويشترط للاحتجاج به ألا يكون القيد خرج مخرج الغالب، ولا لموافقة الواقع، ولا جواباً عن سؤال خاص، ولا لبيان الامتنان أو التهويل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_4_2',
                evidenceKey: 'quran:65:6',
                citation: 'سورة الطلاق: الآية 6',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الإحكام للآمدي وروضة الناظر لابن قدامة وشرح الكوكب المنير',
          ),
        ],
      ),

      // Lesson 5: دلالات الإشارة والاقتضاء والإيماء
      Lesson.create(
        lessonId: 'lsn_dalalat_isharah_iqtida_ima',
        title: 'دلالات الإشارة والاقتضاء والإيماء والتنبيه وفحوى الخطاب في فقه الاستدلال',
        courseId: courseId,
        moduleId: 'mod_dalalat_usuliyyah_istinbat',
        orderIndex: 5,
        sources: const ['src_usul_al_sarakhsi', 'src_al_mustasfa_ghazali', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_dalalat_5_1',
            title: 'دلالة الاقتضاء وإضمار المقدر الشرعي',
            description: 'فهم توقف صدق الكلام أو صحته العقلية والشرعية على تقدير محذوف كحديث «رُفع عن أمتي الخطأ والنسيان».',
          ),
          LearningObjective(
            objectiveId: 'obj_dalalat_5_2',
            title: 'دلالة الإشارة واستنباطات الصحابة العبقرية',
            description: 'تحليل دلالة اللفظ على لازم غير مقصود أصالة كاستنباط علي وابن عباس رضي الله عنهما أقل مدة الحمل (ستة أشهر).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_dalalat_5_1',
            title: 'دلالة الاقتضاء وضرورة التقدير لصحة الكلام',
            contentType: LearningContentType.sourceText,
            content: 'دلالة الاقتضاء هي دلالة اللفظ على معنى لا يستقل الكلام بدونه، ويتوقف صدق الكلام عقلاً أو صحته شرعاً على إضماره وتقديره. ففي قوله ﷺ: «رُفع عن أمتي الخطأُ والنسيانُ وما استُكرهوا عليه»؛ من المعلوم بالضرورة والواقع أن ذات الخطأ والنسيان يقعان من البشر، فيتعين عقلاً وشرعاً تقدير محذوف هو: (رُفع حكم الخطأ والإثم المترتب عليه). وكذا قوله تعالى: ﴿حُرِّمَتْ عَلَيْكُمْ أُمَّهَاتُكُمْ﴾ الذوات لا توصف بالتحريم، فيقتضي التقدير: (حرم عليكم نكاح أمهاتكم)، و﴿وَاسْأَلِ الْقَرْيَةَ﴾ أي أهل القرية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_5_1',
                evidenceKey: 'ibn_majah:2045',
                citation: 'سنن ابن ماجه: حديث رقم 2045 ومستدرك الحاكم',
                sourceId: 'src_al_mustasfa_ghazali',
              ),
            ],
            sourceAttribution: 'المستصفى للغزالي وأصول السرخسي والمنخول للجويني',
          ),
          LessonSection.create(
            sectionId: 'sec_dalalat_5_2',
            title: 'دلالة الإشارة واستنباط أقل مدة الحمل عند الصحابة',
            contentType: LearningContentType.scholarlyView,
            content: 'دلالة الإشارة هي دلالة اللفظ على حكم لازم غير مقصود بسياق الكلام أصالة، وإنما يثبت بتأمل والتزام المعنى. وأعظم تطبيق تأصيلي لها استنباط أمير المؤمنين علي بن أبي طالب وابن عباس رضي الله عنهما أن أقل مدة الحمل ستة أشهر؛ بجمع قوله تعالى في سورة الأحقاف: ﴿وَحَمْلُهُ وَفِصَالُهُ ثَلاثُونَ شَهْراً﴾ مع قوله تعالى في سورة البقرة: ﴿وَالْوَالِدَاتُ يُرْضِعْنَ أَوْلادَهُنَّ حَوْلَيْنِ كَامِلَيْنِ﴾؛ فالحولان أربعة وعشرون شهراً، فإذا طرحت من ثلاثين شهراً بقي للحمل ستة أشهر؛ فدرأ علي رضي الله عنه الحد عن المرأة التي ولدت لستة أشهر وأقرّه الصحابة وعثمان بن عفان رضي الله عنه.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_5_2',
                evidenceKey: 'quran:46:15',
                citation: 'سورة الأحقاف: الآية 15 وسورة البقرة: الآية 233',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير الطبري والمستدرك للحاكم والتلخيص للحبير لابن حجر',
          ),
        ],
      ),

      // Lesson 6: نقد التأويلات الحداثية المنحرفة
      Lesson.create(
        lessonId: 'lsn_dalalat_contemporary_hermeneutics_critique',
        title: 'ضوابط فهم لغة التشريع ونقد القراءات المعاصرة الحداثية المنحرفة',
        courseId: courseId,
        moduleId: 'mod_dalalat_usuliyyah_istinbat',
        orderIndex: 6,
        sources: const ['src_al_muwafaqat_shatibi', 'src_sarim_al_maslul', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_dalalat_6_1',
            title: 'ضوابط التأويل الشرعي المقبول ومحاذير التحريف',
            description: 'التمييز بين التأويل الصحيح المستند لدليل والتحريف الباطل (اللعب بالدلالات والافتئات على اللسان العربي).',
          ),
          LearningObjective(
            objectiveId: 'obj_dalalat_6_2',
            title: 'تفكيك القراءات الحداثية المنحرفة للنص القرآني',
            description: 'الرد العلمي التأصيلي على دعاوى التأويليات الغربية المترجمة (الهيرمينوطيقا)، والقول بتاريخية النصوص وتبديل قطيعات الأحكام.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_dalalat_6_1',
            title: 'شروط التأويل الشرعي المعتبر وضوابط حمل اللفظ على خلاف ظاهره',
            contentType: LearningContentType.sourceText,
            content: 'التأويل في اصطلاح الأصوليين هو صرف اللفظ عن معناه الظاهر الراجح إلى معنى مرجوح يحتمله لدليل يقترن به. وشروطه ثلاثة لا محيد عنها: 1. أن يكون المعنى المصروف إليه مما تحتمله لغة العرب وضعاً واستعمالاً. 2. أن يقوم دليل شرعي صحيح معتبر يوجب صرف اللفظ عن ظاهره. 3. أن يكون الدليل الصارف أقوى أو مكافئاً لظاهر اللفظ. فإن تجرد التأويل عن الدليل الصالح كان تأويلاً فاسداً وتلاعباً بحدود الله يُسقط حجية الشرع ويلحق بالتحريف المذموم الذي عابه الله على أهل الكتاب.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_6_1',
                evidenceKey: 'shatibi:muwafaqat:bab_adillah',
                citation: 'الموافقات للإمام الشاطبي ومجموع الفتاوى لشيخ الإسلام ابن تيمية',
                sourceId: 'src_al_muwafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي وإلجام العوام عن علم الكلام للغزالي والصواعق المرسلة لابن القيم',
          ),
          LessonSection.create(
            sectionId: 'sec_dalalat_6_2',
            title: 'تفكيك دعاوى تاريخية النص واللسانيات الحداثية المستوردة',
            contentType: LearningContentType.explanation,
            content: 'حاولت التيارات الحداثية المعاصرة إسقاط نظريات الألسنية الغربية الحديثة (كالتفكيكية والموت الدلالي للمؤلف والهرمنيوطيقا النسبية) على القرآن الكريم بدعوى إعادة قراءة النصوص وفق الوعي المعاصر؛ فزعموا "تاريخية النص" وأن أحكام المواريث والحدود وقوامة الأسرة كانت خاصة بالبيئة البدوية في القرن السابع الميلادي ولا تلزم عصرنا. والرد التأصيلي الراسخ أن القرآن نزل بلسان عربي مبين ذي قواعد استدلالية محكمة وصانه الله إلى قيام الساعة؛ وعلماء الإسلام صاغوا أصول الفقه ودلالات الألفاظ لحفظ النص من التحريف والعبث بالدلالات، ورسالة الإسلام شريعة عامة خالدة خاتمة صالحة لكل زمان ومكان بحكم الله العليم الخبير.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_dalalat_6_2',
                evidenceKey: 'quran:15:9',
                citation: 'سورة الحجر: الآية 9 ﴿إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ﴾',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'نقض مطاعن في القرآن لإبراهيم عوض وتهافت القراءة المعاصرة ومجموع الفتاوى',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_fiqh_al_lughah_khasais',
        lessonId: 'lsn_dalalat_ittisa_taarib_asaleeb',
        title: 'اختبار تقييم استيعاب: فقه اللغة العربية والاشتقاق ونفي الترادف والمعرب',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_dalalat_1',
            lessonId: 'lsn_dalalat_ittisa_taarib_asaleeb',
            questionText: 'ما الموقف التحقيقي الجمعي للمفسرين في شأن الألفاظ المعربة الواردة في القرآن الكريم كـ(الإستبرق والقسطاس)؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qdl1_1', text: 'أنها ألفاظ أعجمية الأصل عرّبتها العرب وجرت على ألسنتهم وأوزان كلامهم قبل نزول القرآن فنزل القرآن بها وهي من كلامهم العربي'),
              QuizOption(optionId: 'opt_qdl1_2', text: 'أن القرآن نزل بلغات أعجمية متعددة غير لسان العرب'),
              QuizOption(optionId: 'opt_qdl1_3', text: 'أن وجود هذه الألفاظ يطعن في عربية القرآن الكريم'),
              QuizOption(optionId: 'opt_qdl1_4', text: 'أنها ألفاظ عربية محضة لا علاقة لها بأي لغة أخرى على الإطلاق'),
            ],
            correctOptionIndices: const [0],
            explanation: 'قرر المحققون كالطبري والنووي وابن عطية أن العرب عرّبتها قبل البعثة وصارت من لسانهم المتداول، فنزل القرآن بها وهي عربية مستعملة.',
          ),
          QuizQuestion.create(
            questionId: 'q_dalalat_2',
            lessonId: 'lsn_dalalat_ittisa_taarib_asaleeb',
            questionText: 'ما فائدة أسلوب "التضمين" في قوله تعالى: ﴿عَيْناً يَشْرَبُ بِهَا عِبَادُ اللَّهِ﴾ حيث عدي بالباء؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qdl2_1', text: 'تضمين الفعل (يشرب) معنى (يروى) ليفيد الشرب والري التام الكامل معاً بحرف واحد'),
              QuizOption(optionId: 'opt_qdl2_2', text: 'خطأ نحوي في استخدام حروف الجر'),
              QuizOption(optionId: 'opt_qdl2_3', text: 'حذف مفعول به لا مبرر له'),
              QuizOption(optionId: 'opt_qdl2_4', text: 'مجرد تناوب عشوائي بين الباء ومن دون فائدة دلالية'),
            ],
            correctOptionIndices: const [0],
            explanation: 'التضمين يمنح الفعل معنى فعل آخر، فتعديته بالباء أفادت معنى الري والارتواء التام مع الشرب، وهو من أسرار البلاغة المعجزة.',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_dalalat_usuliyyah_istinbat',
        lessonId: 'lsn_dalalat_contemporary_hermeneutics_critique',
        title: 'اختبار تقييم استيعاب: دلالات الألفاظ عند الأصوليين وضوابط التأويل الشرعي',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_dalalat_3',
            lessonId: 'lsn_dalalat_contemporary_hermeneutics_critique',
            questionText: 'بأي طريق استنبط أمير المؤمنين علي بن أبي طالب رضي الله عنه أن أقل مدة الحمل ستة أشهر؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qdl3_1', text: 'عن طريق دلالة الإشارة بجمع آية ﴿وَحَمْلُهُ وَفِصَالُهُ ثَلاثُونَ شَهْراً﴾ مع آية الفصال في عامين ﴿حَوْلَيْنِ كَامِلَيْنِ﴾'),
              QuizOption(optionId: 'opt_qdl3_2', text: 'عن طريق القياس على مدة الرضاع عند أهل مكة'),
              QuizOption(optionId: 'opt_qdl3_3', text: 'عن طريق دلالة المنطوق الصريح المباشر لآية واحدة'),
              QuizOption(optionId: 'opt_qdl3_4', text: 'بمقتضى العرف الطبي السائد فقط دون استناد لآيات القرآن'),
            ],
            correctOptionIndices: const [0],
            explanation: 'استنبطه علي رضي الله عنه بدلالة الإشارة بجمع الآيتين الكريمتين وطرح الـ 24 شهراً من الـ 30 شهراً فبقي 6 أشهر، وأقرّه عليه الصحابة.',
          ),
          QuizQuestion.create(
            questionId: 'q_dalalat_4',
            lessonId: 'lsn_dalalat_contemporary_hermeneutics_critique',
            questionText: 'ما شرط التأويل الشرعي المقبول الذي يميزه عن التحريف الحداثي الباطل لنصوص الشريعة؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qdl4_1', text: 'أن يحتمله لسان العرب وأن يقوم عليه دليل شرعي صحيح معتبر يصرف اللفظ عن ظاهره'),
              QuizOption(optionId: 'opt_qdl4_2', text: 'أن يوافق رغبة المفسر المعاصر وما تمليه الفلسفات الغربية فقط'),
              QuizOption(optionId: 'opt_qdl4_3', text: 'أن يلغي الأحكام القطعية الثابتة في الشريعة بدعوى تغير العصر'),
              QuizOption(optionId: 'opt_qdl4_4', text: 'ألا يشترط أي دليل بل يكفي التفكير الحر المجرد'),
            ],
            correctOptionIndices: const [0],
            explanation: 'التأويل الشرعي المعتبر يشترط احتمال اللغة للمعنى المرجوح وقيام دليل شرعي قطعي أو راجح يوجب صرف اللفظ عن ظاهره.',
          ),
        ],
      ),
    ];
  }
}
