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

/// بيانات مقرر فقه المآلات وسد الذرائع وتصرفات المكلفين والحيل الشرعية (6 دروس تأصيلية + اختباران استيعاب)
class LearningFiqhMaalZaraeeData {
  static const String courseId = 'course_fiqh_maal_zaraee_heeyal';
  static const String pathId = 'path_maqasid_shariah_philosophy_priorities_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه المآلات وسد الذرائع وتصرفات المكلفين والحيل الشرعية',
      description: 'دراسة تأصيلية عميقة لأصل اعتبار مآلات الأفعال ونتائجها في الفتوى والقضاء والاجتهاد، وأحكام سد الذرائع وفتحها، مع دراسة قصد المكلف ومطابقته لقصد الشارع، وتفكيك نظرية الحيل الفقهية والتفريق بين المخارج المشروعة والحيل المحرمة الباطلة.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_maal_zaraee_sad_fath', 'mod_mukallaf_qasd_heeyal_fiqhiyyah'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_maal_zaraee_sad_fath',
        courseId: courseId,
        title: 'اعتبار المآل وسد الذرائع وفتحها في الفتوى والاجتهاد',
        description: 'تحرير قاعدة اعتبار مآل التصرفات، وبيان أن النظر في مآلات الأفعال معتبر مقصود شرعاً، وأقسام الذرائع من حيث قطعية الإفضاء إلى المفسدة وضوابط سدها وفتحها.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_maal_asl_iatibar_qawaid',
          'lsn_zaraee_sad_aqsam_dawabit',
          'lsn_zaraee_fath_masalih_tatbiq',
        ],
      ),
      CourseModule(
        moduleId: 'mod_mukallaf_qasd_heeyal_fiqhiyyah',
        courseId: courseId,
        title: 'قصد المكلف ونظرية الحيل الفقهية وموافقة قصد الشارع',
        description: 'دراسة كتاب قصد المكلف عند الشاطبي وابن تيمية وابن القيم، إبطال الحيل المحرمة للتخلص من الواجبات أو استباحة الربا، وإيضاح المخارج الشرعية العادلة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_maal_zaraee_sad_fath'],
        lessonIds: const [
          'lsn_mukallaf_qasd_shatibi_mutabaqah',
          'lsn_heeyal_riba_aqd_butlan',
          'lsn_istihsan_istislah_takhsis',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      Lesson.create(
        lessonId: 'lsn_maal_asl_iatibar_qawaid',
        courseId: courseId,
        moduleId: 'mod_maal_zaraee_sad_fath',
        title: 'أصل اعتبار المآل في الشريعة الإسلامية وأثره في الفتوى وتغير الأحكام',
        orderIndex: 1,
        sources: const ['src_mowafaqat_shatibi', 'src_sahih_bukhari'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ml1_1',
            title: 'قاعدة اعتبار المآل',
            description: 'استيعاب قاعدة «النظر في مآلات الأفعال معتبر مقصود شرعاً».',
          ),
          LearningObjective(
            objectiveId: 'obj_ml1_2',
            title: 'التطبيقات النبوية الكبرى',
            description: 'الاستدلال بالتطبيقات النبوية الكبرى لاعتبار المآل في القرارات السيادية والفردية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ml1_1',
            title: 'حقيقة اعتبار المآل في التشريع',
            contentType: LearningContentType.explanation,
            content: 'اعتبار المآل يعني ألا يقتصر المجتهد والمفتي على النظر في الفعل في ذاته، بل ينظر إلى عواقبه ونتائجه ومآله في الواقع؛ فالفعل قد يكون مشروعاً في أصله لكنه يؤول إلى مفسدة راجحة فيُمنع، أو يكون ممنوعاً فيؤول إلى مصلحة ضرورية راجحة فيُرخّص فيه كالمضطر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml1_1',
                evidenceKey: 'mowafaqat:5:177',
                citation: 'الموافقات للشاطبي (كتاب المقاصد، ج5 ص177)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للإمام الشاطبي وقواعد الأحكام للعز بن عبد السلام',
          ),
          LessonSection.create(
            sectionId: 'sec_ml1_2',
            title: 'الشواهد النبوية الكبرى على اعتبار المآل',
            contentType: LearningContentType.scholarlyView,
            content: 'من أعظم الأدلة امتناع النبي ﷺ عن قتل رأس النفاق عبد الله بن أبي بن سلول مع استحقاقه القتل معللاً: «لا يتحدث الناس أن محمداً يقتل أصحابه»، وكذلك تركه بناء الكعبة على قواعد إبراهيم: «لولا أن قومك حديثو عهد بجاهلية لبنيتها على قواعد إبراهيم»، فرجح درء المفسدة المآلية على تحصيل المصلحة في الحال.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml1_2',
                evidenceKey: 'bukhari:hajj:kaaba',
                citation: 'صحيح البخاري (حديث بناء الكعبة وترك قتل المنافقين)',
                sourceId: 'src_sahih_bukhari',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وصحيح مسلم وشرح النووي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_zaraee_sad_aqsam_dawabit',
        courseId: courseId,
        moduleId: 'mod_maal_zaraee_sad_fath',
        title: 'سد الذرائع: أقسامه الأربعة وضوابط منع الوسائل المفضية إلى المفاسد',
        orderIndex: 2,
        sources: const ['src_ اعلام_الموقعين_ابن_القيم', 'src_mowafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ml2_1',
            title: 'تصنيف أقسام الذرائع',
            description: 'تصنيف الذرائع إلى قطعية وغالبة ونادرة ومتساوية الاحتمال.',
          ),
          LearningObjective(
            objectiveId: 'obj_ml2_2',
            title: 'ضوابط المنع والتحرز',
            description: 'إتقان ضوابط سد الذرائع دون التضييق على الناس في المباحات والمصالح الراجحة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ml2_1',
            title: 'أقسام الذرائع من حيث الإفضاء إلى المفسدة',
            contentType: LearningContentType.explanation,
            content: 'قسّم العلماء الوسائل المفضية إلى المفاسد إلى أربعة: ما يفضي قطعاً كحفر بئر في طريق عام مظلم فيحرم إجماعاً؛ وما يفضي نادراً كبيع العنب لمن لا يظن به عصر الخمر فيجوز إجماعاً؛ وما يغلب إفضاؤه كسب آلهة المشركين بمحضرهم فيفضي لسب الله فحرم بالنص: ﴿وَلَا تَسُبُّوا الَّذِينَ يَدْعُونَ مِنْ دُونِ اللَّهِ فَيَسُبُّوا اللَّهَ عَدْواً بِغَيْرِ عِلْمٍ﴾؛ وما يكثر إفضاؤه ولا يصل للغلبة كبيوع الآجال، وهو موضع اجتهاد وترجيح.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml2_1',
                evidenceKey: 'ilam_muwaqqiin:3:147',
                citation: 'إعلام الموقعين لابن قيم الجوزية (ج3 ص147)',
                sourceId: 'src_اعلام_الموقعين_ابن_القيم',
              ),
            ],
            sourceAttribution: 'إعلام الموقعين لابن القيم والموافقات للشاطبي',
          ),
          LessonSection.create(
            sectionId: 'sec_ml2_2',
            title: 'ضوابط التحري وتفادي الغلو في سد الذرائع',
            contentType: LearningContentType.scholarlyView,
            content: 'حذر المحققون من الغلو في سد الذرائع بحيث يؤدي إلى تعطيل المصالح العامة والمباحات؛ فالأصل في الأشياء الإباحة، وسد الذريعة لا يصار إليه إلا إذا كانت المفسدة المترتبة محققة أو راجحة ومستندة إلى قرائن وقواعد بينة لا إلى أوهام وشكوك متوهمة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml2_2',
                evidenceKey: 'mowafaqat:5:190',
                citation: 'الموافقات للشاطبي (ج5 ص190)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي والفروق للقرافي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_zaraee_fath_masalih_tatbiq',
        courseId: courseId,
        moduleId: 'mod_maal_zaraee_sad_fath',
        title: 'فتح الذرائع وتوسيع الوسائل الجالبة للمصالح الشرعية',
        orderIndex: 3,
        sources: const ['src_furooq_qarafi', 'src_mowafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ml3_1',
            title: 'تأصيل فتح الذرائع',
            description: 'فهم مفهوم «فتح الذرائع» كقاعدة مقاصدية تكميلية لسد الذرائع.',
          ),
          LearningObjective(
            objectiveId: 'obj_ml3_2',
            title: 'تطبيقات فتح الذرائع المعاصرة',
            description: 'تطبيق قاعدة «ما لا يتم الواجب إلا به فهو واجب» في الواقع المعاصر.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ml3_1',
            title: 'تأصيل قاعدة فتح الذرائع عند القرافي',
            contentType: LearningContentType.explanation,
            content: 'بيّن الإمام القرافي في «الفروق» أن الذريعة كما تسد إذا أفضت إلى مفسدة، فإنها تفتح وتشرع وتوجب إذا أفضت إلى مصلحة؛ فالوسيلة تأخذ حكم المقصد خيراً وشراً؛ والمشي إلى الجمعة وبناء المدارس والمستشفيات وتأسيس التقنيات لخدمة الدين والأمة فتح للذرائع المشروعة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml3_1',
                evidenceKey: 'furooq:2:32',
                citation: 'الفروق للقرافي (الفرق الرابع والأربعون، ج2 ص32)',
                sourceId: 'src_furooq_qarafi',
              ),
            ],
            sourceAttribution: 'الفروق للقرافي وتهذيب الفروق لابن الشاط',
          ),
          LessonSection.create(
            sectionId: 'sec_ml3_2',
            title: 'تطبيقات فتح الذرائع في النوازل المعاصرة',
            contentType: LearningContentType.scholarlyView,
            content: 'تشمل تطبيقات فتح الذرائع المعاصرة: تقنين المعاملات لضبط الحقوق، وإنشاء الهيئات الرقابية المالية، واعتماد التوقيع الرقمي والوسائل الإلكترونية لتيسير المعاملات وإيصال الزكوات، وتطوير العلوم والتقنيات الطبية والصناعية التي تحفظ استقلال الأمة وعزتها.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml3_2',
                evidenceKey: 'furooq:2:38',
                citation: 'الفروق للقرافي (تطبيقات الذرائع المشروعة)',
                sourceId: 'src_furooq_qarafi',
              ),
            ],
            sourceAttribution: 'الفروق للقرافي ومقاصد الشريعة لابن عاشور',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_mukallaf_qasd_shatibi_mutabaqah',
        courseId: courseId,
        moduleId: 'mod_mukallaf_qasd_heeyal_fiqhiyyah',
        title: 'قصد المكلف في الشريعة وقاعدة «الأعمال بالنيات» وموافقة قصد الشارع',
        orderIndex: 4,
        sources: const ['src_mowafaqat_shatibi', 'src_sahih_bukhari'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ml4_1',
            title: 'الرابطة بين النية وقصد الشارع',
            description: 'إدراك الرابطة المحكمة بين النية وقصد الشارع في صحة التصرفات.',
          ),
          LearningObjective(
            objectiveId: 'obj_ml4_2',
            title: 'بطلان العمل المناقض للقصد',
            description: 'بيان أن مناقضة قصد الشارع تبطل العمل ولو وافق ظاهره ألفاظ العقود.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ml4_1',
            title: 'قاعدة موافقة قصد المكلف لقصد الشارع',
            contentType: LearningContentType.explanation,
            content: 'قرر الإمام الشاطبي أصلاً عظيماً: «قصد الشارع من المكلف أن يكون قصده في العمل موافقاً لقصده في التشريع»؛ فمن ابتغى بعمله غير ما شُرع له فقد ضادّ الشارع وحاول قلب نظام التشريع، فكان عمله باطلاً مردوداً بنص قوله ﷺ: «إنما الأعمال بالنيات وإنما لكل امرئ ما نوى».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml4_1',
                evidenceKey: 'mowafaqat:3:285',
                citation: 'الموافقات للشاطبي (كتاب قصد المكلف، ج3 ص285)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي وصحيح البخاري',
          ),
          LessonSection.create(
            sectionId: 'sec_ml4_2',
            title: 'أثر التواطؤ ومناقضة المقاصد في العقود',
            contentType: LearningContentType.scholarlyView,
            content: 'إذا تعارض ظاهر اللفظ مع القصد الباطن المتواطأ عليه المخالف للشرع، فإن الشريعة تقدم الحقائق والمعاني على الألفاظ والمباني؛ كنكاح التحليل بقصد حل المطلقة ثلاثاً وهو ملعون في السنة، والبيع الصوري بقصد إخفاء الربا كبيعة العينة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml4_2',
                evidenceKey: 'mowafaqat:3:290',
                citation: 'الموافقات للشاطبي (إبطال التواطؤ المخالف للشريعة)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي وإعلام الموقعين لابن القيم',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_heeyal_riba_aqd_butlan',
        courseId: courseId,
        moduleId: 'mod_mukallaf_qasd_heeyal_fiqhiyyah',
        title: 'نظرية الحيل الشرعية: التمييز الحاسم بين الحيل الجائزة والحيل الباطلة',
        orderIndex: 5,
        sources: const ['src_ighatha_lahfan_ibn_qayyim', 'src_bayan_dalil_tahleel_taymiyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ml5_1',
            title: 'التمييز بين المخرج والحيلة',
            description: 'التمييز القطعي بين المخرج الفقهي الشرعي والحيلة المحرمة الباطلة.',
          ),
          LearningObjective(
            objectiveId: 'obj_ml5_2',
            title: 'موقف الأئمة من الحيل',
            description: 'تحليل موقف أصحاب السنن ومدرستي الحيل والمخارج في الفقه الإسلامي.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ml5_1',
            title: 'حقيقة الحيلة المحرمة وبطلانها',
            contentType: LearningContentType.explanation,
            content: 'الحيلة المحرمة هي: تقديم عمل مشروع ظاهراً للتوصل به إلى إسقاط واجب شرعي (كالتهرب من الزكاة بتغيير النصاب قبيل الحول)، أو التوصل به إلى فعل محرم (كعقود التورق الصورية أو بيع العينة لاستحلال ربا الفضل والنسيئة). وهذه الحيل باطلة باتفاق المحققين، وجاء فيها الوعيد الشديد كأصحاب السبت.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml5_1',
                evidenceKey: 'ighatha_lahfan:2:15',
                citation: 'إغاثة اللهفان من مصائد الشيطان لابن القيم (باب الحيل، ج2 ص15)',
                sourceId: 'src_ighatha_lahfan_ibn_qayyim',
              ),
            ],
            sourceAttribution: 'إغاثة اللهفان لابن القيم وبيان الدليل لابن تيمية',
          ),
          LessonSection.create(
            sectionId: 'sec_ml5_2',
            title: 'المخارج الشرعية الجائزة',
            contentType: LearningContentType.scholarlyView,
            content: 'المخارج المشروعة هي استخدام الوسائل المباحة للتخلص من الحرام والوقوع فيه، كما أرشد النبي ﷺ بلالاً لما جاء بتمر جنيب فقال: «أوه عين الربا! بع التمر الجمع بالدراهم ثم اشتر بالدراهم جنيباً»؛ فهذا مخرج مباح يحقق المصلحة بلا ربا ولا خديعة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml5_2',
                evidenceKey: 'bukhari:buyu:riba',
                citation: 'صحيح البخاري (كتاب البيوع، باب بيع التمر بالتمر)',
                sourceId: 'src_sahih_bukhari',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وفتح الباري لابن حجر',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_istihsan_istislah_takhsis',
        courseId: courseId,
        moduleId: 'mod_mukallaf_qasd_heeyal_fiqhiyyah',
        title: 'الاستحسان والاستصلاح كآليات مقاصدية للعدول عن مقتضى القياس رعاية للمآل',
        orderIndex: 6,
        sources: const ['src_sharh_al_lumah_shirazi', 'src_mustasfa_ghazali'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_ml6_1',
            title: 'حقيقة الاستحسان والمصالح',
            description: 'فهم حقيقة الاستحسان والمصالح المرسلة كأدوات مقاصدية مرنة.',
          ),
          LearningObjective(
            objectiveId: 'obj_ml6_2',
            title: 'ضبط الاستحسان عن الهوى',
            description: 'التمييز بين الاستحسان المنهجي المنضبط والتحكم بالهوى والاستحسان المذموم.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_ml6_1',
            title: 'حقيقة الاستحسان وضوابطه المقاصدية',
            contentType: LearningContentType.explanation,
            content: 'الاستحسان هو إيثار ترك مقتضى قياس ظاهر رعاية لمصلحة راجحة أو لدفع حرج شديد؛ كجواز عقد الاستصناع ودخول الحمام بالأجر دون تقدير الماء؛ فالقياس يقتضي بطلانهما للجهالة والغرر، لكن استحسن الفقهاء جوازهما لعموم البلوى وجريان العرف وعدم النزاع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml6_1',
                evidenceKey: 'shirazi_luma:2:962',
                citation: 'شرح اللمع للشيرازي (ج2 ص962)',
                sourceId: 'src_sharh_al_lumah_shirazi',
              ),
            ],
            sourceAttribution: 'شرح اللمع للشيرازي والمبسوط للسرخسي',
          ),
          LessonSection.create(
            sectionId: 'sec_ml6_2',
            title: 'المصالح المرسلة ودورها في التطوير التشريعي',
            contentType: LearningContentType.scholarlyView,
            content: 'المصلحة المرسلة هي التي لم يشهد لها الشارع باعتبار معين ولا بإلغاء معين، ولكنها ملائمة لمقاصد الشريعة؛ كجمع القرآن في المصحف، وتدوين الدواوين، وسك العملة، وأنظمة المرور المعاصرة، وهي أصل راسخ لبناء الأنظمة المدنية والإدارية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_ml6_2',
                evidenceKey: 'mustasfa:1:295',
                citation: 'المستصفى للغزالي (المصالح المرسلة والاستصلاح)',
                sourceId: 'src_mustasfa_ghazali',
              ),
            ],
            sourceAttribution: 'المستصفى للغزالي والإحكام للآمدي',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_maal_zaraee_sad_fath',
        lessonId: 'lsn_zaraee_fath_masalih_tatbiq',
        title: 'اختبار تقييم استيعاب: فقه المآلات وسد وفتح الذرائع',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_maal_1',
            lessonId: 'lsn_zaraee_fath_masalih_tatbiq',
            questionText: 'لماذا امتنع النبي ﷺ عن هدم الكعبة وإعادة بنائها على قواعد إبراهيم عليه السلام؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qml1_1', text: 'اعتباراً للمآل؛ لئلا يفتتن الناس لقرب عهدهم بالجاهلية فتقع مفسدة أعظم'),
              QuizOption(optionId: 'opt_qml1_2', text: 'لعجزه المالي عن إعادة البناء'),
              QuizOption(optionId: 'opt_qml1_3', text: 'لأن قواعد إبراهيم لم تكن مشروعة أصلاً'),
              QuizOption(optionId: 'opt_qml1_4', text: 'لعدم وجود بنائين ماهرين في مكة'),
            ],
            correctOptionIndices: const [0],
            explanation: 'ترك النبي ﷺ بناء الكعبة على قواعد إبراهيم مراعاة للمآل ودرءاً لمفسدة ارتداد ضعاف الإيمان.',
          ),
          QuizQuestion.create(
            questionId: 'q_maal_2',
            lessonId: 'lsn_zaraee_fath_masalih_tatbiq',
            questionText: 'ما هو حكم الوسيلة التي تفضي نادراً جداً إلى المفسدة في الشريعة الإسلامية؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qml2_1', text: 'تبقى على أصل الجواز والإباحة كزراعة العنب وبيعه؛ ولا يُلتفت إلى الندرة'),
              QuizOption(optionId: 'opt_qml2_2', text: 'تحرم تحريماً قطعياً سداً للذريعة المتوهمة'),
              QuizOption(optionId: 'opt_qml2_3', text: 'تكون مكروهة تحريماً في كل حال'),
              QuizOption(optionId: 'opt_qml2_4', text: 'يبطل كل بيع أو تصرف يتصل بها'),
            ],
            correctOptionIndices: const [0],
            explanation: 'الوسيلة التي تفضي نادراً إلى الحرام لا تسد؛ لأن في سدها تفويتاً لمصالح غالبة لا يرضاها الشارع.',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_mukallaf_qasd_heeyal_fiqhiyyah',
        lessonId: 'lsn_istihsan_istislah_takhsis',
        title: 'اختبار تقييم استيعاب: قصد المكلف والحيل الفقهية والاستحسان',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_maal_3',
            lessonId: 'lsn_istihsan_istislah_takhsis',
            questionText: 'ما هو الضابط الحاسم في إبطال الحيل المحرمة في الفقه الإسلامي؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qml3_1', text: 'التوصل بظاهر مشروع إلى إسقاط واجب شرعي أو استباحة محرم ومناقضة قصد الشارع'),
              QuizOption(optionId: 'opt_qml3_2', text: 'استخدام الكتابة والشهود في العقود والوثائق'),
              QuizOption(optionId: 'opt_qml3_3', text: 'إقالة النادم في البيع والتجارة'),
              QuizOption(optionId: 'opt_qml3_4', text: 'الأخذ بالرخص الشرعية المنصوص عليها كقصر الصلاة'),
            ],
            correctOptionIndices: const [0],
            explanation: 'الحيلة الباطلة هي التي تتوسل بعقد مشروع ظاهراً لهدم أصل مقاصدي أو ارتكاب محرم والتملص من الواجبات.',
          ),
          QuizQuestion.create(
            questionId: 'q_maal_4',
            lessonId: 'lsn_istihsan_istislah_takhsis',
            questionText: 'ما هو التوجيه النبوي الصحيح لبلال رضي الله عنه حين أراد استبدال التمر الرديء بالتمر الجيد؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qml4_1', text: 'أمره ببيع الرديء بالدراهم ثم شراء الجيد بها، وهو مخرج شرعي خالٍ من ربا الفضل'),
              QuizOption(optionId: 'opt_qml4_2', text: 'أجاز له مبادلة صاعين بصاع دون شروط'),
              QuizOption(optionId: 'opt_qml4_3', text: 'حرّم عليه بيع التمر أو الانتفاع به مطلقاً'),
              QuizOption(optionId: 'opt_qml4_4', text: 'أمره بالاستدانة بالربا لحين ميسرة'),
            ],
            correctOptionIndices: const [0],
            explanation: 'أرشده النبي ﷺ للمخرج الشرعي النظيف: «بع التمر بالدراهم ثم اشتر بالدراهم جنيباً» دون الوقوع في الربا.',
          ),
        ],
      ),
    ];
  }
}
