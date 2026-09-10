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

/// بيانات مقرر تاريخ التدوين الفقهي ومدارس الإفتاء والموسوعات الفقهية (6 دروس تأصيلية + اختباران استيعاب)
class LearningFiqhCodificationEncyclopediasData {
  static const String courseId = 'course_fiqh_codification_encyclopedias';
  static const String pathId = 'path_madhahib_history_ijtihad_imams_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر تاريخ التدوين الفقهي ومدارس الإفتاء والموسوعات الفقهية',
      description: 'دراسة تأصيلية لمراحل تدوين الفقه الإسلامي وتطور المصنفات من المتون والشروح إلى كتب النوازل والفتاوى التاريخية، وحركة التقنين في العصر الحديث ونشأة «مجلة الأحكام العدلية»، والموسوعات الفقهية المعاصرة، ودور المجامع الفقهية والاجتهاد الجماعي.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_fiqh_codification_stages', 'mod_contemporary_codification_councils'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_fiqh_codification_stages',
        courseId: courseId,
        title: 'الوحدة الأولى: مراحل تدوين الفقه الإسلامي وتطور المصنفات التراثية',
        description: 'نشأة التدوين الفقهي وتطور المتون المختصرة، فن الشروح والحواشي والتقريرات والمصطلحات المذهبية، وكتب الفتاوى والنوازل التاريخية الكبرى كالفتاوى الهندية والمعيار المعرب.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_codification_historical_stages_mutun',
          'lsn_codification_commentaries_terminologies',
          'lsn_codification_fatwa_collections_nawazil',
        ],
      ),
      CourseModule(
        moduleId: 'mod_contemporary_codification_councils',
        courseId: courseId,
        title: 'الوحدة الثانية: حركة تقنين الفقه والموسوعات الفقهية والمجامع المعاصرة',
        description: 'حركة تقنين الشريعة وصدور «مجلة الأحكام العدلية» وقواعدها الكلية، الموسوعات الفقهية المعاصرة كالموسوعة الكويتية والتبويب الهجائي، وفقه المجامع والاجتهاد الجماعي المعاصر.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_fiqh_codification_stages'],
        lessonIds: const [
          'lsn_codification_majallat_ahkam_adliyyah',
          'lsn_codification_contemporary_encyclopedias',
          'lsn_codification_fiqh_academies_collective_ijtihad',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 19: مراحل تدوين الفقه والمتون
      Lesson.create(
        lessonId: 'lsn_codification_historical_stages_mutun',
        title: 'مراحل تدوين الفقه الإسلامي وتطور المصنفات من الروايات إلى المتون الجامعة',
        courseId: courseId,
        moduleId: 'mod_fiqh_codification_stages',
        orderIndex: 1,
        sources: const ['src_madkhal_fiqh_zarqa', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_cod_1_1',
            title: 'أطوار التدوين الفقهي التاريخية',
            description: 'معرفة مراحل التدوين: عصر الرواية والمجموعات، عصر التفريع والتأسيس، وعصر المتون المحررة الجامعة.',
          ),
          LearningObjective(
            objectiveId: 'obj_cod_1_2',
            title: 'خصائص المتون الفقهية المعتمدة',
            description: 'استيعاب القيمة التعليمية للمتون المختصرة ودورها في حفظ أصول الفروع وضبط مسائل كل مذهب.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_cod_1_1',
            title: 'المراحل التاريخية الكبرى لتدوين الفقه الإسلامي',
            contentType: LearningContentType.sourceText,
            content: 'مر تدوين الفقه الإسلامي بأربعة أطوار رئيسة: 1) طور التأسيس والجمع (القرن 1 و 2هـ): تدوين الأحاديث والآثار ممزوجة بفتاوى الصحابة والتابعين؛ كـ «موطأ مالك» و«جامع معمر بن راشد». 2) طور التفريع واستنباط الأصول (القرن 2 و 3هـ): تدوين الأئمة وتلاميذهم لفروع المذاهب وكتب ظاهر الرواية والأم والرسالة. 3) طور التأصيل والاستقرار والتهذيب (القرن 4 إلى 7هـ): تنقيح الروايات وصياغة القواعد وتصنيف الأمهات الفقهية. 4) طور المتون المختصرة والشروح (القرن 7هـ وما بعده): صياغة الفقه في عبارات موجزة جامعة تيسر الحفظ والضبط لطالب العلم.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_1_1',
                evidenceKey: 'zarqa:madkhal:1:85',
                citation: 'المدخل الفقهي العام للشيخ مصطفى أحمد الزرقا (تاريخ الفقه وأطواره)',
                sourceId: 'src_madkhal_fiqh_zarqa',
              ),
            ],
            sourceAttribution: 'المدخل الفقهي العام للزرقا والفكر السامي للحجوي الثعالبي',
          ),
          LessonSection.create(
            sectionId: 'sec_cod_1_2',
            title: 'عبقرية المتون الفقهية ودورها التعليمي والمنهجي',
            contentType: LearningContentType.explanation,
            content: 'المتن هو النص المكثف الموجز الذي يجمع القواعد والأبواب الفقهية بألفاظ دقيقة محكمة خالية من الحشو والأدلة المطولة؛ ليكون هيكلاً عظمياً يستحضره الفقيه في حافظته؛ كـ «مختصر القدوري» و«كنز الدقائق» عند الحنفية، و«مختصر خليل» عند المالكية، و«منهاج الطالبين» للنووي عند الشافعية، و«زاد المستقنع» للحجاوي عند الحنابلة. وهذه المتون شكلت حلقة الوصل التربوية في معاهد التعليم العريقة كالأزهر والزيتونة والقرويين والمسجد النبوي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_1_2',
                evidenceKey: 'hujwi:fikr_sami:2:240',
                citation: 'الفكر السامي في تاريخ الفقه الإسلامي للحجوي الثعالبي',
                sourceId: 'src_madkhal_fiqh_zarqa',
              ),
            ],
            sourceAttribution: 'الفكر السامي للحجوي والمدخل إلى مذهب الشافعي وأحمد',
          ),
        ],
      ),

      // Lesson 20: الشروح والحواشي والمصطلحات
      Lesson.create(
        lessonId: 'lsn_codification_commentaries_terminologies',
        title: 'فن الشروح والحواشي والتقريرات الفقهية وضبط المصطلحات المذهبية',
        courseId: courseId,
        moduleId: 'mod_fiqh_codification_stages',
        orderIndex: 2,
        sources: const ['src_madkhal_fiqh_zarqa', 'src_qawaid_fiqhiyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_cod_2_1',
            title: 'منهجية الشروح والحواشي التراثية',
            description: 'معرفة الفرق بين المتن، الشرح، الحاشية، والتقرير الفقهي، ودورها في فك الإبهام وتدقيق المسائل.',
          ),
          LearningObjective(
            objectiveId: 'obj_cod_2_2',
            title: 'المصطلحات والرموز المذهبية المعتمدة',
            description: 'استيعاب مصطلحات كل مذهب: كالشيخين، الإمام، الصاحبين، الروايتين، الوجهين، والمعتمد والأظهر.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_cod_2_1',
            title: 'منظومة الشروح والحواشي في خدمة الفقه التراثي',
            contentType: LearningContentType.sourceText,
            content: 'قام علماء الأمة بجهد عبقري متراكم في خدمة المتون؛ فالشرح يحل ألفاظ المتن ويدلل عليها ويوجه عللها، والحاشية تدقق مواضع الإشكال في الشرح وتناقش استدراكات العلماء، والتقرير يضبط الفروق الدقيقة بين المسائل المتشابهة. ومن النماذج الرائدة: شرح «فتح القدير» لابن الهمام على الهداية، وشرح «منح الجليل» لعليش على مختصر خليل، وشرح «تحفة المحتاج» لابن حجر الهيتمي على المنهاج، وشرح «كشاف القناع» للبهوتي على الإقناع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_2_1',
                evidenceKey: 'abidin:rasm_mufti:p15',
                citation: 'شرح منظومة رسم المفتي للعلامة محمد أمين ابن عابدين',
                sourceId: 'src_madkhal_fiqh_zarqa',
              ),
            ],
            sourceAttribution: 'رسم المفتي لابن عابدين والمدخل المفصل لبكر أبو زيد',
          ),
          LessonSection.create(
            sectionId: 'sec_cod_2_2',
            title: 'فك شفرات المصطلحات والرموز المذهبية الدقيقة',
            contentType: LearningContentType.explanation,
            content: 'اصطلح فقهاء كل مذهب على مصطلحات ورموز لضبط تراتبية الأقوال: فـ «الشيخان» عند الحنفية هما أبو حنيفة وأبو يوسف، وعند الشافعية هما الرافعي والنووي، وعند المالكية هما ابن أبي زيد القيرواني والقابسي. وكلمة «الأظهر» عند الشافعية تقابل قولاً ضعيفاً دليله قوي، و«المشهور» يقابل قولاً غريباً. وعند الحنابلة: «الرواية» قول الإمام أحمد، و«الوجه» تخريج أصحابه، و«الاحتمال» تردد الفقيه بدليلين متكافئين. فمعرفة هذه المصطلحات شرط أساسي للإفتاء الصحيح.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_2_2',
                evidenceKey: 'nawawi:minhaj:intro',
                citation: 'مقدمة منهاج الطالبين وعمدة المفتين للإمام النووي في مصطلحات المذهب',
                sourceId: 'src_qawaid_fiqhiyyah',
              ),
            ],
            sourceAttribution: 'مقدمة منهاج الطالبين للنووي والمطلع على ألفاظ المقنع لابن مفلح',
          ),
        ],
      ),

      // Lesson 21: كتب الفتاوى والنوازل الكبرى
      Lesson.create(
        lessonId: 'lsn_codification_fatwa_collections_nawazil',
        title: 'كتب الفتاوى والنوازل التاريخية الكبرى ودورها في إدارة المجتمع الإسلامي',
        courseId: courseId,
        moduleId: 'mod_fiqh_codification_stages',
        orderIndex: 3,
        sources: const ['src_miyar_murb_wansharisi', 'src_fatawa_hindiyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_cod_3_1',
            title: 'أهمية فقه النوازل والفتاوى الواقعية',
            description: 'معرفة كيف عالجت كتب النوازل المستجدات الحياتية المتغيرة في المجتمع الإسلامي التاريخي.',
          ),
          LearningObjective(
            objectiveId: 'obj_cod_3_2',
            title: 'المصنفات الفتوائية الجامعة الكبرى',
            description: 'التعرف على كبريات موسوعات الفتاوى التاريخية: كالفتاوى الهندية، المعيار المعرب للونشريسي، وفتاوى ابن تيمية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_cod_3_1',
            title: 'فقه النوازل: تفاعل الشريعة الحي مع حركة التاريخ والمجتمع',
            contentType: LearningContentType.sourceText,
            content: 'لم يكن الفقه الإسلامي نصوصاً نظرية مجردة، بل كان نابضاً بالحياة من خلال فقه «النوازل والواقعات»؛ وهي الأسئلة والمشكلات اليومية التي تنزل بالناس في الاقتصاد والزراعة والقضاء والأسرة والعلاقات الاجتماعية فيستفتون فيها كبار العلماء. ومثلت كتب النوازل سجلاً وثائقياً واجتماعياً وقانونياً هائلاً يعكس مرونة الشريعة وقدرتها على تنزيل الأحكام الشرعية الكلية على الوقائع الجزئية المتجددة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_3_1',
                evidenceKey: 'wansharisi:miyar:1:10',
                citation: 'المعيار المعرب والجامع المغرب عن فتاوى علماء إفريقية والأندلس والمغرب لأحمد الونشريسي',
                sourceId: 'src_miyar_murb_wansharisi',
              ),
            ],
            sourceAttribution: 'المعيار المعرب للونشريسي وفقه النوازل للدكتور بكر أبو زيد',
          ),
          LessonSection.create(
            sectionId: 'sec_cod_3_2',
            title: 'أبرز الموسوعات الفتوائية التاريخية الكبرى',
            contentType: LearningContentType.explanation,
            content: 'من أعظم مصنفات الفتاوى في التاريخ: 1) «الفتاوى الهندية» (العالمكيرية): موسوعة حنفية ضخمة أمر بجمعها السلطان أورنك زيب وشارك فيها مئات العلماء بالهند لتوحيد الفتوى والقضاء. 2) «المعيار المعرب» للونشريسي: موسوعة النوازل الكبرى في الغرب الإسلامي والأندلس في 13 مجلداً. 3) «الفتاوى الكبرى» وفتاوى السبكي وابن حجر الهيتمي والرملي في المذهب الشافعي. فهذه الأعمال مهدت الطريق لاحقاً لفكرة الموسوعات والتقنين.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_3_2',
                evidenceKey: 'hindiyyah:intro',
                citation: 'مقدمة الفتاوى العالمكيرية الهندية في فقه المذهب الحنفي',
                sourceId: 'src_fatawa_hindiyyah',
              ),
            ],
            sourceAttribution: 'الفتاوى الهندية وتاريخ الفقه الإسلامي الحديث',
          ),
        ],
      ),

      // Lesson 22: مجلة الأحكام العدلية وحركة التقنين
      Lesson.create(
        lessonId: 'lsn_codification_majallat_ahkam_adliyyah',
        title: 'حركة تقنين الشريعة في العصر الحديث: صدور «مجلة الأحكام العدلية» وقواعدها المئة',
        courseId: courseId,
        moduleId: 'mod_contemporary_codification_councils',
        orderIndex: 4,
        sources: const ['src_majallat_ahkam_adliyyah', 'src_sharh_qawaid_zarqa'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_cod_4_1',
            title: 'نشأة مجلة الأحكام العدلية وظروفها',
            description: 'استيعاب كيف نشأت أول صياغة قانونية مقننة للفقه الإسلامي في صورة مواد قانونية مرقمة عام 1293هـ / 1876م.',
          ),
          LearningObjective(
            objectiveId: 'obj_cod_4_2',
            title: 'القواعد الكلية المئة في المجلة',
            description: 'معرفة القواعد الفقهية الكلية التسع والتسعين التي صدرت بها المجلة وأثرها العميق في القوانين المدنية المعاصرة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_cod_4_1',
            title: 'السبق التاريخي لـ «مجلة الأحكام العدلية» في تقنين الفقه',
            contentType: LearningContentType.sourceText,
            content: 'صدرت «مجلة الأحكام العدلية» في الدولة العثمانية بين عامي (1286 - 1293هـ / 1869 - 1876م) برئاسة العلامة أحمد جودت باشا ونخبة من فقهاء الحنفية. وتعتبر المجلة أول مدونة قانونية مدنية حديثة مصوغة في مواد مرقمة (1851 مادة) مستمدة بالكامل من الفقه الإسلامي لتوحيد الأحكام القضائية في المحاكم النظامية والشرعية، وتغطي المعاملات المالية والعقود والدعاوى والبينات.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_4_1',
                evidenceKey: 'majalla:intro:art1',
                citation: 'مجلة الأحكام العدلية (المقدمة في تعريف علم الفقه وتقسيمه والقواعد الفقهية)',
                sourceId: 'src_majallat_ahkam_adliyyah',
              ),
            ],
            sourceAttribution: 'مجلة الأحكام العدلية ودرر الحكام شرح مجلة الأحكام لعلي حيدر',
          ),
          LessonSection.create(
            sectionId: 'sec_cod_4_2',
            title: 'القواعد الفقهية الكلية التسع والتسعون وأثرها القانوني',
            contentType: LearningContentType.explanation,
            content: 'افتتحت المجلة بمقدمة عبقرية تضم 99 قاعدة فقهية أصولية كلية أضحت دستوراً تشريعياً؛ كقاعدة: «الأمور بمقاصدها»، «اليقين لا يزول بالشك»، «الضرر يزال»، «المشقة تجلب التيسير»، و«العادة محكمة». وشكلت المجلة الأساس المتين لصياغة القوانين المدنية الحديثة في معظم الدول العربية والإسلامية؛ كالقانون المدني المصري والعراقي والأردني والسوري، وظلت نموذجاً عالمياً لقدرة الشريعة على التقنين الحديث الرصين.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_4_2',
                evidenceKey: 'zarqa:sharh_qawaid:p25',
                citation: 'شرح القواعد الفقهية للشيخ أحمد الزرقا',
                sourceId: 'src_sharh_qawaid_zarqa',
              ),
            ],
            sourceAttribution: 'شرح القواعد الفقهية لأحمد الزرقا والمدخل الفقهي العام لمصطفى الزرقا',
          ),
        ],
      ),

      // Lesson 23: الموسوعات الفقهية المعاصرة
      Lesson.create(
        lessonId: 'lsn_codification_contemporary_encyclopedias',
        title: 'الموسوعات الفقهية المعاصرة: «الموسوعة الفقهية الكويتية» والتبويب الألفبائي',
        courseId: courseId,
        moduleId: 'mod_contemporary_codification_councils',
        orderIndex: 5,
        sources: const ['src_mawsoah_fiqhiyyah_kuwait', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_cod_5_1',
            title: 'المشروع الحضاري للموسوعة الفقهية الكويتية',
            description: 'معرفة مراحل إنجاز أضخم موسوعة فقهية مقارنة في العصر الحديث (45 مجلداً) ومنهج إعدادها.',
          ),
          LearningObjective(
            objectiveId: 'obj_cod_5_2',
            title: 'منهج التبويب الهجائي الموضوعي المقارن',
            description: 'استيعاب كيفية ترتيب المصطلحات الفقهية ألفبائياً وعرض أقوال المذاهب الأربعة بأدلتها بأسلوب ميسر.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_cod_5_1',
            title: 'الموسوعة الفقهية الكويتية: أعظم إنجاز فقهي موسوعي معاصر',
            contentType: LearningContentType.sourceText,
            content: 'تعد «الموسوعة الفقهية» الصادرة عن وزارة الأوقاف والشؤون الإسلامية بدولة الكويت (في 45 مجلداً ضخماً وملحقين) أكبر عمل موسوعي فقهي في التاريخ الإسلامي المعاصر. استغرق إنجازها قرابة أربعين عاماً بمشاركة نخبة من كبار فقهاء العالم الإسلامي من شتى المذاهب، وهدفت إلى صياغة الفقه الإسلامي الموروث وعرضه بأسلوب علمي منهجي معاصر ميسر للقضاة والباحثين وطلاب العلم.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_5_1',
                evidenceKey: 'kuwait_mawsoah:intro:1:15',
                citation: 'الموسوعة الفقهية الكويتية (المقدمة العامة وخطة العمل والتبويب)',
                sourceId: 'src_mawsoah_fiqhiyyah_kuwait',
              ),
            ],
            sourceAttribution: 'مقدمة الموسوعة الفقهية الكويتية والندوات التحضيرية للموسوعة',
          ),
          LessonSection.create(
            sectionId: 'sec_cod_5_2',
            title: 'خصائص المنهج الموسوعي: التبويب الألفبائي والحياد المذهبي',
            contentType: LearningContentType.explanation,
            content: 'تميزت الموسوعة بخصائص منهجية فريدة: 1) الترتيب الهجائي (المعجمي الألفبائي) للمصطلحات والموضوعات الفقهية مما سهل الوصول إلى أي مسألة فوراً. 2) الشمولية والمقارنة؛ إذ تورد آراء المذاهب الأربعة المتبوعة دون تحيز، وتذكر أدلة كل مذهب بحياد تام ودون ترجيح متعسف. 3) توثيق النقولات من أمهات الكتب المعتمدة في كل مذهب، مما جعلها المرجع الأول عالمياً في الفقه الإسلامي المقارن.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_5_2',
                evidenceKey: 'quran:16:89',
                citation: 'قوله تعالى: ﴿وَنَزَّلْنَا عَلَيْكَ الْكِتَابَ تِبْيَانًا لِّكُلِّ شَيْءٍ وَهُدًى وَرَحْمَةً وَبُشْرَىٰ لِلْمُسْلِمِينَ﴾ [النحل: 89]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'دليل الباحث في الموسوعة الفقهية ودراسات التوثيق الفقهي',
          ),
        ],
      ),

      // Lesson 24: المجامع الفقهية والاجتهاد الجماعي
      Lesson.create(
        lessonId: 'lsn_codification_fiqh_academies_collective_ijtihad',
        title: 'المجامع الفقهية المعاصرة ومأسسة الاجتهاد الجماعي في مواجهة النوازل العالمية',
        courseId: courseId,
        moduleId: 'mod_contemporary_codification_councils',
        orderIndex: 6,
        sources: const ['src_majma_fiqhi_resolutions', 'src_hayat_kibar_ulama'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_cod_6_1',
            title: 'مفهوم الاجتهاد الجماعي المؤسسي وضرورته',
            description: 'إدراك ضرورة الاجتهاد الجماعي في العصر الحاضر لتشابك النوازل الطبية والاقتصادية والقانونية الدولية.',
          ),
          LearningObjective(
            objectiveId: 'obj_cod_6_2',
            title: 'المجامع الفقهية الرائدة وآليات اتخاذ القرارات',
            description: 'معرفة دور مجمع الفقه الإسلامي الدولي، هيئة كبار العلماء، ومجمع البحوث بالأزهر، ومراحل دراسة النوازل مع الخبراء.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_cod_6_1',
            title: 'ضرورة الاجتهاد الجماعي ومأسسة الفتوى في عصر النوازل المركبة',
            contentType: LearningContentType.sourceText,
            content: 'نظراً لتعقد الحياة المعاصرة وظهور قضايا مركبة تجمع بين الطب المتقدم والاقتصاد الرقمي والهندسة الوراثية والقانون الدولي، أصبح الاجتهاد الفردي عاجزاً عن الإحاطة بمفردات الواقع؛ فبرز «الاجتهاد الجماعي» كضرورة شرعية وحضارية تمثل امتداداً لسنة الشورى النبوية ومنهج الخلفاء الراشدين حين كانوا يجمعون كبار الصحابة في النوازل العامة كما قال علي رضي الله عنه: «اجعلوا شورى بين العابدين من المؤمنين».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_6_1',
                evidenceKey: 'quran:42:38',
                citation: 'قوله تعالى: ﴿وَأَمْرُهُمْ شُورَىٰ بَيْنَهُمْ﴾ [الشورى: 38] وأثر علي بن أبي طالب في سنن الدارمي',
                sourceId: 'src_majma_fiqhi_resolutions',
              ),
            ],
            sourceAttribution: 'الاجتهاد الجماعي في الفقه الإسلامي للدكتور شعبان إسماعيل وقرارات مجمع الفقه',
          ),
          LessonSection.create(
            sectionId: 'sec_cod_6_2',
            title: 'المجامع الفقهية الكبرى وآلية الاستعانة بأهل الاختصاص',
            contentType: LearningContentType.explanation,
            content: 'تقوم المجامع الفقهية الرائدة (مجمع الفقه الإسلامي الدولي التابع لمنظمة التعاون الإسلامي، مجمع الفقه برابطة العالم الإسلامي، هيئة كبار العلماء بالمملكة، ومجمع البحوث الإسلامية بالأزهر) بدراسة النوازل عبر مسار علمي دقيق: 1) إعداد بحوث فقهية مقارنة من علماء شتى المذاهب. 2) استكتاب الأطباء وخبراء الاقتصاد والفلك والقانون لتصوير الواقعة تصويراً دقيقاً عملاً بقاعدة «الحكم على الشيء فرع عن تصوره». 3) المداولة والمناقشة المستفيضة في دورات علنية ثم إصدار القرار بالإجماع أو الأغلبية، مما منح قرارات المجامع قوة تشريعية وأدبية هائلة في سائر أنحاء العالم الإسلامي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_cod_6_2',
                evidenceKey: 'quran:21:7',
                citation: 'قوله تعالى: ﴿فَاسْأَلُوا أَهْلَ الذِّكْرِ إِن كُنتُمْ لَا تَعْلَمُونَ﴾ [الأنبياء: 7]',
                sourceId: 'src_majma_fiqhi_resolutions',
              ),
            ],
            sourceAttribution: 'مجلة مجمع الفقه الإسلامي الدولي ومنهجية إصدار الفتاوى في المجامع',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: مراحل التدوين والمتون
    final q1 = QuizQuestion.create(
      questionId: 'q_cod_1',
      lessonId: 'lsn_codification_historical_stages_mutun',
      questionText: 'ما هي الوظيفة التعليمية والمنهجية الأساسية لـ «المتون الفقهية المختصرة» التي اشتهرت في المعاهد الإسلامية العريقة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qc1_1', text: 'جمع قواعد المذهب ومسائله وفروعه بألفاظ دقيقة موجزة تيسر الحفظ والضبط والاستحضار الفوري للفقيه'),
        QuizOption(optionId: 'opt_qc1_2', text: 'إلغاء أدلة الكتاب والسنة والاعتماد على أقوال الشيوخ بغير دليل'),
        QuizOption(optionId: 'opt_qc1_3', text: 'الاقتصار على سرد المسائل النادرة التي لا يحتاج إليها الناس في حياتهم'),
      ],
      correctOptionIndices: const [0],
      explanation: 'المتون المختصرة وضعت لتكون هيكلاً تعليمياً محكماً يضبط مسائل المذهب وفروعه ليسهل حفظها واستحضارها في الفتوى والقضاء.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_fiqh_codification_stages',
      lessonId: 'lsn_codification_historical_stages_mutun',
      title: 'اختبار تقييم استيعاب مراحل تدوين الفقه الإسلامي وتطور المتون والشروح وفقه النوازل',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: التقنين والموسوعات والمجامع
    final q2 = QuizQuestion.create(
      questionId: 'q_cod_2',
      lessonId: 'lsn_codification_majallat_ahkam_adliyyah',
      questionText: 'ما هو العمل التشريعي الإسلامي الذي صدر عام 1876م ويعد أول تقنين مدني حديث للفقه في مواد قانونية مرقمة ومفتتح بـ 99 قاعدة كلية؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qc2_1', text: '«مجلة الأحكام العدلية» الصادرة في الدولة العثمانية والمستمدة من الفقه الحنفي'),
        QuizOption(optionId: 'opt_qc2_2', text: '«الموسوعة الفقهية الكويتية»'),
        QuizOption(optionId: 'opt_qc2_3', text: '«القانون المدني الفرنسي» (كود نابليون)'),
      ],
      correctOptionIndices: const [0],
      explanation: 'مجلة الأحكام العدلية هي أول تقنين مدني حديث للشريعة الإسلامية في مواد مرقمة، وافتتحت بـ 99 قاعدة فقهية كلية دستورية.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_contemporary_codification_councils',
      lessonId: 'lsn_codification_majallat_ahkam_adliyyah',
      title: 'اختبار تقييم استيعاب تقنين الشريعة والموسوعات الفقهية المعاصرة والاجتهاد الجماعي في المجامع',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
