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

/// بيانات مقرر نظرية مقاصد الشريعة: النشأة والأعلام ومسالك الكشف عن المقاصد (6 دروس تأصيلية + اختباران استيعاب)
class LearningMaqasidTheoryHistoryData {
  static const String courseId = 'course_maqasid_theory_history_detection';
  static const String pathId = 'path_maqasid_shariah_philosophy_priorities_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر نظرية مقاصد الشريعة: النشأة والأعلام ومسالك الكشف عن المقاصد',
      description: 'دراسة تأصيلية تاريخية ومنهجية لنشأة التفكير المقاصدي وتطوره من عصر الصحابة إلى أئمة المقاصد الكبار كإمام الحرمين والغزالي والعز بن عبد السلام والشاطبي وصولاً إلى ابن عاشور، مع تحليل دقيق لمسالك الكشف عن قصد الشارع من الاستقراء والعلل ومراتب القطع والظن.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_maqasid_origins_imams', 'mod_maqasid_detection_methods'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_maqasid_origins_imams',
        courseId: courseId,
        title: 'نشأة وتطور علم المقاصد وتراجم أئمته ومصنفاته',
        description: 'تتبع تاريخي لفكرة المقاصد منذ فقه الصحابة وتطبيقات عمر بن الخطاب، ثم تأسيس الجويني والغزالي، وريادة العز بن عبد السلام، ونضج العلم في موافقات الشاطبي وتجديد ابن عاشور.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_maqasid_history_origins_sahaba',
          'lsn_maqasid_izz_shatibi_mowafaqat',
          'lsn_maqasid_modern_tahir_ashoor',
        ],
      ),
      CourseModule(
        moduleId: 'mod_maqasid_detection_methods',
        courseId: courseId,
        title: 'مسالك وطرق الكشف عن مقاصد الشارع ومراتب حجيتها',
        description: 'قواعد منهجية لمعرفة مراد الشارع عبر الاستقراء الكلي والجزئي، دلالات الأوامر والنواهي المعقولة المعنى، سكوت الشارع، ومستويات القطع والظن في المقاصد.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_maqasid_origins_imams'],
        lessonIds: const [
          'lsn_maqasid_istiqra_tam_naqis',
          'lsn_maqasid_skoot_sharee_tasreeh',
          'lsn_maqasid_qat_dhann_hujjiyah',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      Lesson.create(
        lessonId: 'lsn_maqasid_history_origins_sahaba',
        courseId: courseId,
        moduleId: 'mod_maqasid_origins_imams',
        title: 'الجذور المقاصدية في القرآن والسنة وفقه الصحابة وبواكير التأصيل',
        orderIndex: 1,
        sources: const ['src_al_burhan_juwayni', 'src_mustasfa_ghazali', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_mq1_1',
            title: 'اقتران الأحكام بالحكم والمصالح',
            description: 'إدراك اقتران أحكام الشريعة بحكمها ومصالحها في النصوص النبوية والقرآنية.',
          ),
          LearningObjective(
            objectiveId: 'obj_mq1_2',
            title: 'فهم اجتهادات الصحابة المقاصدية',
            description: 'تحليل اجتهادات الصحابة المقاصدية ودفع وهم مخالفتها للنصوص الصريحة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_mq1_1',
            title: 'تعليل الأحكام في القرآن والسنة وفقه الصحابة',
            contentType: LearningContentType.explanation,
            content: 'قامت نصوص الشريعة على التعليل الصريح كقوله تعالى: ﴿مَا يُرِيدُ اللَّهُ لِيَجْعَلَ عَلَيْكُمْ مِنْ حَرَجٍ وَلَكِنْ يُرِيدُ لِيُطَهِّرَكُمْ﴾ وقوله: ﴿كَيْ لَا يَكُونَ دُولَةً بَيْنَ الْأَغْنِيَاءِ مِنْكُمْ﴾. وقد استقر لدى الصحابة رضي الله عنهم أن أحكام الله معللة بجلب المصالح ودرء المفاسد، وكان عمر بن الخطاب رضي الله عنه إماماً في استصحاب هذه المقاصد في القضايا المستجدة دون تعطيل للنص.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq1_1',
                evidenceKey: 'quran:5:6',
                citation: 'سورة المائدة، الآية 6',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير ابن كثير وأصول الفقه للسرخسي',
          ),
          LessonSection.create(
            sectionId: 'sec_mq1_2',
            title: 'إسهامات إمام الحرمين الجويني والغزالي',
            contentType: LearningContentType.scholarlyView,
            content: 'يعد إمام الحرمين الجويني في كتابيه «البرهان» و«غياث الأمم» أول من قسّم المقاصد إلى أصول ومراتب الضرورة والحاجة والتتمات، ثم طوّر تلميذه حجة الإسلام الغزالي في «المستصفى» نظرية حفظ الكليات الخمس بدقة متناهية شكلت معالم الدرس الأصولي المقاصدي اللاحق.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq1_2',
                evidenceKey: 'mustasfa:1:287',
                citation: 'المستصفى في علم الأصول للإمام الغزالي (ج1 ص287)',
                sourceId: 'src_mustasfa_ghazali',
              ),
            ],
            sourceAttribution: 'البرهان للجويني والمستصفى للغزالي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_izz_shatibi_mowafaqat',
        courseId: courseId,
        moduleId: 'mod_maqasid_origins_imams',
        title: 'سلطان العلماء العز بن عبد السلام والإمام الشاطبي وثورة «الموافقات»',
        orderIndex: 2,
        sources: const ['src_qawaid_al_ahkam_izz', 'src_mowafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_mq2_1',
            title: 'منهج العز في رد الشريعة إلى المصالح',
            description: 'معرفة منهج العز بن عبد السلام في رد الشريعة كلها إلى جلب المصالح ودرء المفاسد.',
          ),
          LearningObjective(
            objectiveId: 'obj_mq2_2',
            title: 'أركان كتاب المقاصد للشاطبي',
            description: 'فهم الأقسام التأسيسية الأربعة لكتاب المقاصد في الموافقات للإمام الشاطبي.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_mq2_1',
            title: 'العز بن عبد السلام ونظرية المصالح',
            contentType: LearningContentType.explanation,
            content: 'قرر الإمام العز بن عبد السلام أن التكاليف كلها راجعة إلى مصالح العباد في دنياهم وأخراهم، وأن الشريعة عدل كلها، ورحمة كلها، ومصالح كلها، وحكمة كلها؛ فكل مسألة خرجت عن العدل إلى الجور، وعن الرحمة إلى ضدها، وعن المصلحة إلى المفسدة فليست من الشريعة وإن أدخلت فيها بالتأويل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq2_1',
                evidenceKey: 'qawaid_izz:1:10',
                citation: 'قواعد الأحكام في مصالح الأنام للعز بن عبد السلام (ج1 ص10)',
                sourceId: 'src_qawaid_al_ahkam_izz',
              ),
            ],
            sourceAttribution: 'قواعد الأحكام في مصالح الأنام لسلطان العلماء',
          ),
          LessonSection.create(
            sectionId: 'sec_mq2_2',
            title: 'الإمام الشاطبي وبناء علم المقاصد المستقل',
            contentType: LearningContentType.scholarlyView,
            content: 'يعد الإمام أبو إسحاق الشاطبي في سفره العظيم «الموافقات» المؤسس الحقيقي لعلم المقاصد كعلم مستقل ذي ضوابط قطعية، حيث قسّم المقاصد إلى قصد الشارع في وضع الشريعة ابتداءً، وقصده في وضعها للإفهام، وقصده في وضعها للتكليف بمقتضاها، وقصده في دخول المكلف تحت حكمها، وحذر من التلاعب بالمقاصد لخرق النصوص.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq2_2',
                evidenceKey: 'mowafaqat:2:5',
                citation: 'الموافقات للإمام الشاطبي (كتاب المقاصد، ج2 ص5)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات في أصول الشريعة للإمام الشاطبي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_modern_tahir_ashoor',
        courseId: courseId,
        moduleId: 'mod_maqasid_origins_imams',
        title: 'الشيخ محمد الطاهر بن عاشور وإعادة بعث علم المقاصد في العصر الحديث',
        orderIndex: 3,
        sources: const ['src_maqasid_ashoor', 'src_allal_fasi_maqasid'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_mq3_1',
            title: 'استقلال علم المقاصد عند ابن عاشور',
            description: 'فهم إسهام ابن عاشور في استقلال علم المقاصد عن علم الأصول لتجاوز الاختلاف الجزئي.',
          ),
          LearningObjective(
            objectiveId: 'obj_mq3_2',
            title: 'المقاصد العامة للأمة',
            description: 'استيعاب المقاصد العامة كالفطرة والحرية وحفظ نظام الأمة وصلاح المجتمع.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_mq3_1',
            title: 'ابن عاشور وتجديد الفكر المقاصدي',
            contentType: LearningContentType.explanation,
            content: 'انطلق الشيخ محمد الطاهر بن عاشور من ضرورة تجريد علم المقاصد ليكون مرجعاً قطيعاً للمجتهدين يرفع الاختلاف المذهبي العقيم؛ وعرّف المقصد العام للشريعة بأنه: «المحافظة على نظام الأمة، واستدامة صلاحه بصلاح المهيمن عليه وهو الإنسان» وركّز على مقاصد الفطرة والسماحة والحرية وحفظ النظام.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq3_1',
                evidenceKey: 'ashoor_maqasid:63',
                citation: 'مقاصد الشريعة الإسلامية لابن عاشور (تحقيق الحليوي، ص63)',
                sourceId: 'src_maqasid_ashoor',
              ),
            ],
            sourceAttribution: 'مقاصد الشريعة الإسلامية للشيخ محمد الطاهر بن عاشور',
          ),
          LessonSection.create(
            sectionId: 'sec_mq3_2',
            title: 'المقاصد الخاصة بأبواب المعاملات والأسرة',
            contentType: LearningContentType.scholarlyView,
            content: 'ابتكر ابن عاشور منهجية استقراء المقاصد الخاصة في كل باب تشريعي؛ ففي المعاملات قصد الشارع رواج الأموال، ووضوحها، وحفظها، وثباتها، والعدل فيها؛ وفي الأسرة قصد سكون النفس ودوام العصمة وضبط الأنساب وحفظ النسل من الضياع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq3_2',
                evidenceKey: 'ashoor_maqasid:180',
                citation: 'مقاصد الشريعة الإسلامية لابن عاشور (مقاصد المعاملات والأسرة)',
                sourceId: 'src_maqasid_ashoor',
              ),
            ],
            sourceAttribution: 'مقاصد الشريعة الإسلامية لابن عاشور ومقاصد الشريعة لعلال الفاسي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_istiqra_tam_naqis',
        courseId: courseId,
        moduleId: 'mod_maqasid_detection_methods',
        title: 'الاستقراء التشريعي التام والناقص ودلالة النصوص وعلل الأحكام',
        orderIndex: 4,
        sources: const ['src_mowafaqat_shatibi', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_mq4_1',
            title: 'منهج الاستقراء المعنوي',
            description: 'إتقان منهج الاستقراء المعنوي التراكمي في إثبات القواعد المقاصدية القطعية.',
          ),
          LearningObjective(
            objectiveId: 'obj_mq4_2',
            title: 'الفرق بين العلة والمقصد',
            description: 'التمييز بين العلة المنضبطة والحكمة المقاصدية في تعليل الأحكام والقياس.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_mq4_1',
            title: 'حقيقة الاستقراء المعنوي عند الأصوليين',
            contentType: LearningContentType.explanation,
            content: 'أكد الشاطبي أن القطع بالكلية المقاصدية (مثل حفظ النفس أو المشقة تجلب التيسير) لم يأتِ من دليل واحد مفرد بل من تظافر مئات الأدلة الجزئية من الكتاب والسنة حتى أفادت القطع كالتواتر المعنوي؛ وهو الاستقراء الذي لا يقبل النقض بالجزئيات الشاذة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq4_1',
                evidenceKey: 'mowafaqat:1:35',
                citation: 'الموافقات للشاطبي (مبحث الاستقراء القطعي، ج1 ص35)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي وإحكام الفصول للباجي',
          ),
          LessonSection.create(
            sectionId: 'sec_mq4_2',
            title: 'علاقة الاستقراء بعلل الأحكام والقياس',
            contentType: LearningContentType.scholarlyView,
            content: 'العلة هي الوصف الظاهر المنضبط الذي عُلق عليه الحكم، والمقصد هو الحكمة والمصلحة المقصودة من وراء تشريع الحكم؛ فالشارع أناط الحكم بالعلة المنضبطة لحفظ المقصد والحكمة ودفع المشقة والاضطراب.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq4_2',
                evidenceKey: 'mowafaqat:1:40',
                citation: 'الموافقات للشاطبي (العلل والحكم المقاصدية)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي والبرهان لإمام الحرمين',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_skoot_sharee_tasreeh',
        courseId: courseId,
        moduleId: 'mod_maqasid_detection_methods',
        title: 'مسلك التصريح بالعلة وسكوت الشارع عما وُجد سببه في عهد النبوة',
        orderIndex: 5,
        sources: const ['src_itisaam_shatibi', 'src_sahih_bukhari'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_mq5_1',
            title: 'ألفاظ التصريح بالحكمة والعلة',
            description: 'معرفة ألفاظ وأدوات التصريح بالحكمة والعلة في القرآن الكريم والحديث النبوي.',
          ),
          LearningObjective(
            objectiveId: 'obj_mq5_2',
            title: 'دلالة سكوت الشارع',
            description: 'إدراك الدلالة المقاصدية لسكوت الشارع وضبط مفهوم الابتداع في الدين.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_mq5_1',
            title: 'التصريح بالفعل والعلة وحروف التعليل',
            contentType: LearningContentType.explanation,
            content: 'من أوضح مسالك معرفة قصد الشارع تصريحه بالعلة بأدوات التعليل كـ (كي، لعل، لئلا، من أجل، إنما جعل)، كقوله ﷺ: «إنما جعل الاستئذان من أجل البصر»، وقوله في القبلة للصائم: «أرأيت لو تمضمضت»، فذلك نص جلي في مقصد التشريع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq5_1',
                evidenceKey: 'bukhari:istizan:1',
                citation: 'صحيح البخاري (كتاب الاستئذان)',
                sourceId: 'src_sahih_bukhari',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وفتح الباري لابن حجر',
          ),
          LessonSection.create(
            sectionId: 'sec_mq5_2',
            title: 'دلالة سكوت الشارع مع قيام المقتضي',
            contentType: LearningContentType.scholarlyView,
            content: 'قرر المحققون أن ما قام سببه وداعيه ومقتضاه في عهد النبي ﷺ ولم يفعله مع قدرته عليه ولم يشرعه لأمته، فالسنة تركه، وفعله بعده بدعة تناقض مقصد الشارع؛ أما ما حدث سببه بعد عصر الرسالة فيدخل في المصالح المرسلة والنوازل المستجدة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq5_2',
                evidenceKey: 'itisaam:1:360',
                citation: 'الاعتصام للشاطبي (ج1 ص360)',
                sourceId: 'src_itisaam_shatibi',
              ),
            ],
            sourceAttribution: 'الاعتصام للإمام الشاطبي وقواعد ابن رجب',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_qat_dhann_hujjiyah',
        courseId: courseId,
        moduleId: 'mod_maqasid_detection_methods',
        title: 'مراتب القطع والظن في مقاصد الشريعة وحجيتها في الترجيح والاجتهاد',
        orderIndex: 6,
        sources: const ['src_maqasid_ashoor', 'src_mowafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_mq6_1',
            title: 'تصنيف المقاصد ثبوتاً ودلالة',
            description: 'تصنيف المقاصد إلى قطعية وظنية ووهمية متخيلة.',
          ),
          LearningObjective(
            objectiveId: 'obj_mq6_2',
            title: 'ضوابط إعمال المقاصد في الترجيح',
            description: 'ضوابط إعمال المقاصد في ترجيح الآراء الفقهية المعاصرة وتفادي إهدار النصوص الصريحة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_mq6_1',
            title: 'مراتب الثبوت المقاصدي',
            contentType: LearningContentType.explanation,
            content: 'تنقسم المقاصد من حيث ثبوتها إلى: مقاصد قطعية وهي ما دلت عليه نصوص متواترة أو استقراء تام كحفظ الضروريات الخمس والعدل ورفع الحرج؛ ومقاصد ظنية يغلب على ظن المجتهد قصد الشارع لها دون قطع؛ ومقاصد وهمية يدعيها أصحاب الأهواء لتبرير مخالفة النصوص الصريحة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq6_1',
                evidenceKey: 'ashoor_maqasid:110',
                citation: 'مقاصد الشريعة الإسلامية لابن عاشور (ص110)',
                sourceId: 'src_maqasid_ashoor',
              ),
            ],
            sourceAttribution: 'مقاصد الشريعة الإسلامية لابن عاشور والموافقات للشاطبي',
          ),
          LessonSection.create(
            sectionId: 'sec_mq6_2',
            title: 'حجية المقاصد عند التعارض وضوابط الاستنباط',
            contentType: LearningContentType.scholarlyView,
            content: 'المقاصد الشرعية الصحيحة خادمة للنصوص ومفسرة لها وليست ناسخة لها ولا معطلة. وعند تعارض دليلين ظنيين يُرجح ما كان موافقاً للقواعد المقاصدية الكبرى، أما النص القطعي الصريح فلا يتصور معارضته لمقصد قطعي شرعي ألبتة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_mq6_2',
                evidenceKey: 'mowafaqat:3:22',
                citation: 'الموافقات للشاطبي (التعارض والترجيح المقاصدي)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي والمستصفى للغزالي',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_maqasid_origins_imams',
        lessonId: 'lsn_maqasid_modern_tahir_ashoor',
        title: 'اختبار تقييم استيعاب: نشأة وتاريخ علم المقاصد وأعلامه',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_maqasid_1',
            lessonId: 'lsn_maqasid_modern_tahir_ashoor',
            questionText: 'من هو العالم الأصولي الذي يعد المؤسس الفعلي لعلم المقاصد كعلم مستقل في كتابه «الموافقات»؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qmq1_1', text: 'الإمام أبو إسحاق الشاطبي'),
              QuizOption(optionId: 'opt_qmq1_2', text: 'الإمام فخر الدين الرازي'),
              QuizOption(optionId: 'opt_qmq1_3', text: 'الإمام سيف الدين الآمدي'),
              QuizOption(optionId: 'opt_qmq1_4', text: 'الإمام ابن حزم الظاهري'),
            ],
            correctOptionIndices: const [0],
            explanation: 'يعد الإمام الشاطبي في كتابه الفذ «الموافقات» المؤسس الحقيقي لعلم المقاصد وضوابطه الاستقرائية.',
          ),
          QuizQuestion.create(
            questionId: 'q_maqasid_2',
            lessonId: 'lsn_maqasid_modern_tahir_ashoor',
            questionText: 'ما هو المقصد العام للشريعة الإسلامية وفق تحرير الشيخ محمد الطاهر بن عاشور؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qmq2_1', text: 'المحافظة على نظام الأمة واستدامة صلاحه بصلاح الإنسان المهيمن عليه'),
              QuizOption(optionId: 'opt_qmq2_2', text: 'إلغاء الجزئيات الفقهية والاكتفاء بالمعاني المجردة'),
              QuizOption(optionId: 'opt_qmq2_3', text: 'تحصيل المكاسب المادية الدنيوية المجردة'),
              QuizOption(optionId: 'opt_qmq2_4', text: 'تضييق دائرة التكليف إلى أضيق حد ممكن'),
            ],
            correctOptionIndices: const [0],
            explanation: 'عرف ابن عاشور المقصد العام بأنه المحافظة على نظام الأمة واستدامة صلاحه بصلاح الإنسان في فطرته وعقله وسلوكه.',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_maqasid_detection_methods',
        lessonId: 'lsn_maqasid_qat_dhann_hujjiyah',
        title: 'اختبار تقييم استيعاب: مسالك الكشف عن المقاصد وحجيتها',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_maqasid_3',
            lessonId: 'lsn_maqasid_qat_dhann_hujjiyah',
            questionText: 'كيف تثبت الكليات المقاصدية الكبرى قطعية الثبوت في الشريعة الإسلامية؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qmq3_1', text: 'بالاستقراء المعنوي التام لتظافر مئات الأدلة الجزئية من القرآن والسنة'),
              QuizOption(optionId: 'opt_qmq3_2', text: 'بمجرد الاستحسان العقلي المجرد دون سند نقلي'),
              QuizOption(optionId: 'opt_qmq3_3', text: 'بحديث آحاد ظني الثبوت والدلالة بمفرده'),
              QuizOption(optionId: 'opt_qmq3_4', text: 'بالعرف الحادث المخالف للشرع'),
            ],
            correctOptionIndices: const [0],
            explanation: 'تثبت الكليات المقاصدية بالاستقراء المعنوي التراكمي للأدلة الجزئية المتكاثرة التي تفيد اليقين والقطع.',
          ),
          QuizQuestion.create(
            questionId: 'q_maqasid_4',
            lessonId: 'lsn_maqasid_qat_dhann_hujjiyah',
            questionText: 'ما حكم فعل عبادة وُجد سببها ومقتضاها في عهد النبي ﷺ وسكت عنها ولم يفعلها مع قدرته على ذلك؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qmq4_1', text: 'يعد فعلها بدعة محدثة؛ لأن قصد الشارع دل عليه الترك مع قيام المقتضي'),
              QuizOption(optionId: 'opt_qmq4_2', text: 'يعد سنة مستحبة مطلقاً بكل حال'),
              QuizOption(optionId: 'opt_qmq4_3', text: 'مصلحة مرسلة واجبة النفاذ'),
              QuizOption(optionId: 'opt_qmq4_4', text: 'أمر مباح يخير فيه العبد بلا كراهة'),
            ],
            correctOptionIndices: const [0],
            explanation: 'سكوت الشارع وتركه للفعل مع قيام المقتضي وانتفاء المانع في عصره سنة مقصودة، وإحداثه بعده بدعة مناقضة لقصد الشارع.',
          ),
        ],
      ),
    ];
  }
}
