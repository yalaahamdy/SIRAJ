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

/// بيانات مقرر فقه الأولويات والموازنات وتطبيق المقاصد في النوازل والأزمات العالمية (6 دروس تأصيلية + اختباران استيعاب)
class LearningPrioritiesMuwazanatCrisesData {
  static const String courseId = 'course_priorities_muwazanat_crises_applications';
  static const String pathId = 'path_maqasid_shariah_philosophy_priorities_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الأولويات والموازنات وتطبيق المقاصد في النوازل والأزمات العالمية',
      description: 'دراسة تأصيلية معاصرة لقواعد الموازنة بين المصالح المتعارضة والمفاسد المتزاحمة، وقواعد درء المفاسد وأخف الضررين، وفقه الأولويات في حياة المسلم والأمة، مع تطبيقات مقاصدية حية على الأزمات الاقتصادية، والهندسة الوراثية، والتغير المناخي، وحوكمة الذكاء الاصطناعي.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_priorities_muwazanat_rules', 'mod_maqasid_crises_contemporary'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_priorities_muwazanat_rules',
        courseId: courseId,
        title: 'فقه الموازنات والأولويات وقواعد الترجيح المقاصدية الكبرى',
        description: 'تحرير علمي لقواعد الموازنة عند التزاحم، وتطبيق قاعدة درء المفاسد، وارتكاب أخف الضررين، وفقه ترتيب الأعمال الصالحة وتقديم الواجبات العينية والأولويات المجتمعية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_muwazanat_dar_mafasid_jalb',
          'lsn_muwazanat_akhaff_dararain',
          'lsn_priorities_maratib_amal',
        ],
      ),
      CourseModule(
        moduleId: 'mod_maqasid_crises_contemporary',
        courseId: courseId,
        title: 'التطبيقات المقاصدية في النوازل المعاصرة والأزمات العالمية والذكاء الاصطناعي',
        description: 'تنزيل مقاصد الشريعة على مستجدات العصر: المعضلات الحيوية والطبية، التغير المناخي وحماية الأرض، الأزمات المالية العالمية، وحوكمة الذكاء الاصطناعي والأخلاقيات الرقمية.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_priorities_muwazanat_rules'],
        lessonIds: const [
          'lsn_maqasid_biomedical_climate',
          'lsn_maqasid_financial_crises_digital',
          'lsn_maqasid_ai_human_governance',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      Lesson.create(
        lessonId: 'lsn_muwazanat_dar_mafasid_jalb',
        courseId: courseId,
        moduleId: 'mod_priorities_muwazanat_rules',
        title: 'قاعدة «درء المفاسد مقدم على جلب المصالح» وضوابط الموازنة بين المتعارضين',
        orderIndex: 1,
        sources: const ['src_qawaid_al_ahkam_izz', 'src_sahih_bukhari'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_pr1_1',
            title: 'تحرير قاعدة درء المفاسد',
            description: 'فهم شرط استواء المصلحة والمفسدة لتطبيق قاعدة درء المفاسد.',
          ),
          LearningObjective(
            objectiveId: 'obj_pr1_2',
            title: 'إهدار المفسدة اليسيرة للراجحة',
            description: 'إدراك متى تُهدر المفسدة اليسيرة في سبيل تحصيل المصلحة العظمى الراجحة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_pr1_1',
            title: 'تحرير قاعدة درء المفاسد عند الأصوليين',
            contentType: LearningContentType.explanation,
            content: 'قاعدة «درء المفاسد أولى من جلب المصالح» مقيدة بحالة تساوي المصلحة والمفسدة؛ لأن عناية الشارع بالمنهيات أشد من المأمورات بنص حديث: «فإذا أمرتكم بأمر فأتوا منه ما استطعتم وإذا نهيتكم عن شيء فاجتنبوه»؛ أما إذا رجحت المصلحة جلياً على المفسدة اليسيرة فإن تحصيل المصلحة مقدم قطعاً، كالجهاد وتناول الدواء المر والعمليات الجراحية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr1_1',
                evidenceKey: 'qawaid_izz:1:65',
                citation: 'قواعد الأحكام للعز بن عبد السلام (ج1 ص65)',
                sourceId: 'src_qawaid_al_ahkam_izz',
              ),
            ],
            sourceAttribution: 'قواعد الأحكام للعز بن عبد السلام وصحيح البخاري',
          ),
          LessonSection.create(
            sectionId: 'sec_pr1_2',
            title: 'أنواع المفاسد والمصالح عند التعارض',
            contentType: LearningContentType.scholarlyView,
            content: 'بيّن العز بن عبد السلام في «قواعد الأحكام» أن المصالح والمفاسد إذا اجتمعت إما أن ترجح المصلحة فيُعمل بها وتلغى المفسدة، أو ترجح المفسدة فتدرأ وتلغى المصلحة، أو تتساويا فيدرأ الفساد؛ وهذا ميزان دقيق يمنع الغلو والانسداد.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr1_2',
                evidenceKey: 'qawaid_izz:1:70',
                citation: 'قواعد الأحكام للعز بن عبد السلام (التعارض والترجيح)',
                sourceId: 'src_qawaid_al_ahkam_izz',
              ),
            ],
            sourceAttribution: 'قواعد الأحكام في مصالح الأنام والأشباه والنظائر للسيوطي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_muwazanat_akhaff_dararain',
        courseId: courseId,
        moduleId: 'mod_priorities_muwazanat_rules',
        title: 'ارتكاب أخف الضررين لدفع أعلاهما وتحمل الضرر الخاص لمنع الضرر العام',
        orderIndex: 2,
        sources: const ['src_ashbah_nazair_suyuti', 'src_sahih_bukhari'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_pr2_1',
            title: 'تأصيل قاعدة أخف الضررين',
            description: 'استيعاب التطبيقات الفقهية والسياسية لقاعدة ارتكاب أخف الضررين.',
          ),
          LearningObjective(
            objectiveId: 'obj_pr2_2',
            title: 'تحمل الضرر الخاص',
            description: 'معرفة ضوابط تعويض صاحب الضرر الخاص عند نزع الملكية أو فرض التسعير الجبري.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_pr2_1',
            title: 'تأصيل قاعدة أخف الضررين',
            contentType: LearningContentType.explanation,
            content: 'إذا اضطر المكلف أو ولي الأمر بين مفسدتين لا مناص من إحداهما، فإن العقل والشرع يوجبان ارتكاب أخفهما ضرراً لدفع أعظمهما؛ كما أمر النبي ﷺ بترك الأعرابي حتى يكمل بوله في المسجد؛ لئلا يتطاير البول وتتنجس مواضع أخرى وينكشف جسده ويصاب بالأذى الصحي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr2_1',
                evidenceKey: 'bukhari:wudu:aarabi',
                citation: 'صحيح البخاري (حديث الأعرابي في المسجد)',
                sourceId: 'src_sahih_bukhari',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وشرح صحيح مسلم للنووي',
          ),
          LessonSection.create(
            sectionId: 'sec_pr2_2',
            title: 'تقديم الضرر الخاص لدفع الضرر العام',
            contentType: LearningContentType.scholarlyView,
            content: 'مصلحة عموم المسلمين مقدمة على مصلحة الآحاد؛ ولذا شُرع الحجر على المفتي الماجن والطبيب الجاهل والمفلس، وشُرع نزع ملكية الأراضي لتوسعة المسجد النبوي والشارع العام مع دفع تعويض عادل، والتسعير الجبري عند احتكار أقوات الناس.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr2_2',
                evidenceKey: 'ashbah_suyuti:87',
                citation: 'الأشباه والنظائر للسيوطي (القاعدة الرابعة: الضرر يزال، ص87)',
                sourceId: 'src_ashbah_nazair_suyuti',
              ),
            ],
            sourceAttribution: 'الأشباه والنظائر للسيوطي والأشباه والنظائر لابن نجيم',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_priorities_maratib_amal',
        courseId: courseId,
        moduleId: 'mod_priorities_muwazanat_rules',
        title: 'فقه الأولويات وترتيب الواجبات والسنن وفضل العلم على النوافل',
        orderIndex: 3,
        sources: const ['src_tareeq_hijratain_ibn_qayyim', 'src_ihya_ulum_deen_ghazali'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_pr3_1',
            title: 'هرم الأولويات في الأعمال',
            description: 'ترتيب الأعمال الصالحة وفق موازين الشريعة والقرآن الكريم.',
          ),
          LearningObjective(
            objectiveId: 'obj_pr3_2',
            title: 'أولوية النفع المتعدي',
            description: 'التمييز بين العمل ذي النفع المتعدي والعمل القاصر وفضل كل منهما بحسب الحال.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_pr3_1',
            title: 'أولويات الأعمال في الكتاب والسنة',
            contentType: LearningContentType.explanation,
            content: 'ليست الأعمال الصالحة في رتبة واحدة؛ فأعلاها أصول الإيمان، ثم الفرائض والواجبات، ثم النوافل والمستحبات؛ ومن ضيع الفرائض اشتغالاً بالنوافل فهو مغرور مفرط. وقد قرر النبي ﷺ تفاضل الأعمال حين سئل أي العمل أفضل فأجاب بحسب حاجة السائل وحال الأمة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr3_1',
                evidenceKey: 'tareeq_hijratain:315',
                citation: 'طريق الهجرتين وباب السعادتين لابن القيم (ص315)',
                sourceId: 'src_tareeq_hijratain_ibn_qayyim',
              ),
            ],
            sourceAttribution: 'طريق الهجرتين لابن القيم وإحياء علوم الدين للغزالي',
          ),
          LessonSection.create(
            sectionId: 'sec_pr3_2',
            title: 'أولوية النفع المتعدي على النفع القاصر',
            contentType: LearningContentType.scholarlyView,
            content: 'العمل الصالح المتعدي نفعه كبناء العقول بالتعليم، وسد جوعة الفقراء، وإغاثة المنكوبين، وحماية ثغور الأمة؛ مقدم عند المحققين على التوسع في نوافل العبادات القاصرة؛ فمداد العلماء ونفقة المعسرين أعظم أثراً في حفظ الدين ونظام العالم.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr3_2',
                evidenceKey: 'ihya:1:15',
                citation: 'إحياء علوم الدين للغزالي (كتاب العلم، فضل التعلم والتعليم)',
                sourceId: 'src_ihya_ulum_deen_ghazali',
              ),
            ],
            sourceAttribution: 'إحياء علوم الدين للغزالي وجامع بيان العلم وفضله لابن عبد البر',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_biomedical_climate',
        courseId: courseId,
        moduleId: 'mod_maqasid_crises_contemporary',
        title: 'تطبيقات المقاصد في الهندسة الوراثية وتغير المناخ وحماية كوكب الأرض',
        orderIndex: 4,
        sources: const ['src_qararat_majma_fiqh', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_pr4_1',
            title: 'مقصد حماية البيئة والتنوع',
            description: 'تأصيل واجب حماية البيئة والتنوع الحيوي انطلاقاً من مقصد الاستخلاف وعمارة الأرض.',
          ),
          LearningObjective(
            objectiveId: 'obj_pr4_2',
            title: 'ضوابط الهندسة الوراثية',
            description: 'وضع الضوابط المقاصدية لأبحاث الهندسة الوراثية ومنع تغيير خلق الله العابث.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_pr4_1',
            title: 'مقصد حماية المناخ والتوازن البيئي',
            contentType: LearningContentType.explanation,
            content: 'البيئة أمانة استخلف الله فيها الإنسان؛ وتلويث الكوكب وتدمير الغابات واستنزاف المياه خرق صريح لمقصد الشارع في حفظ نظام الكون: ﴿وَلَا تُفْسِدُوا فِي الْأَرْضِ بَعْدَ إِصْلَاحِهَا﴾؛ فتخفيف الانبعاثات والانتقال للطاقة النظيفة وحماية التنوع الحيوي واجبات شرعية مقاصدية ملزمة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr4_1',
                evidenceKey: 'quran:7:56',
                citation: 'سورة الأعراف، الآية 56',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير ابن كثير وقرارات مجمع الفقه الإسلامي الدولي',
          ),
          LessonSection.create(
            sectionId: 'sec_pr4_2',
            title: 'الهندسة الوراثية بين العلاج والعبث الجيني',
            contentType: LearningContentType.scholarlyView,
            content: 'العلاج الجيني للأمراض الوراثية الفتاكة مصلحة مشروعة تخدم حفظ النفس والنسل؛ أما التعديل الجيني لتحسين النسل التجاري وتخليق أجنة بمواصفات معينة فعبث بكرامة الإنسان وتغيير محرم لخلق الله يفتح أبواب المفاسد الاجتماعية والطبقية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr4_2',
                evidenceKey: 'iifa:resolution:215',
                citation: 'قرار مجمع الفقه الإسلامي الدولي بشأن الجينوم البشري والبيئة',
                sourceId: 'src_qararat_majma_fiqh',
              ),
            ],
            sourceAttribution: 'قرارات المجمع الفقهي الإسلامي بمكة ومجمع الفقه الدولي بجدة',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_financial_crises_digital',
        courseId: courseId,
        moduleId: 'mod_maqasid_crises_contemporary',
        title: 'المقاصد الشرعية في معالجة الأزمات الاقتصادية والتضخم والعملات الرقمية',
        orderIndex: 5,
        sources: const ['src_maqasid_muamalat_maliyyah', 'src_qararat_majma_fiqh'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_pr5_1',
            title: 'مقاصد الاقتصاد الإسلامي والأزمات',
            description: 'بيان أن المقاصد المالية الإسلامية كفيلة بمنع الفقاعات والانهيارات الاقتصادية العالمية.',
          ),
          LearningObjective(
            objectiveId: 'obj_pr5_2',
            title: 'تقويم الأصول الرقمية مقاصدياً',
            description: 'تقويم العملات الرقمية والأصول المشفرة من منظور حفظ المال واستقرار المعاملات.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_pr5_1',
            title: 'مقاصد النظام المالي الإسلامي وأسباب الأزمات',
            contentType: LearningContentType.explanation,
            content: 'تقوم الأزمات المالية العالمية على المتاجرة بالديون والمشتقات المالية والمراهنات الصفرية وتوليد الأموال من الهواء عبر الفائدة الربوية؛ بينما يقصد الشارع ربط النقد بالسلع والخدمات الحقيقية، واقتسام الأرباح والخسائر، وتدوير الثروة في الإنتاج الفعلي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr5_1',
                evidenceKey: 'maqasid_maliyyah:88',
                citation: 'مقاصد الشريعة في المعاملات المالية (ص88)',
                sourceId: 'src_maqasid_muamalat_maliyyah',
              ),
            ],
            sourceAttribution: 'مقاصد الشريعة في المعاملات المالية وبحوث هيئة المحاسبة والمراجعة للمؤسسات المالية الإسلامية (AAOIFI)',
          ),
          LessonSection.create(
            sectionId: 'sec_pr5_2',
            title: 'تقييم العملات الرقمية المشفرة مقاصدياً',
            contentType: LearningContentType.scholarlyView,
            content: 'العملة في الفقه وسيلة لقياس القيم وحفظ الحقوق؛ فإذا افتقرت العملة الرقمية إلى الاستقرار والضمان والجهة السيادية المنظمة وصارت أداة للمضاربات المحمومة وغسيل الأموال، فإن مقصد حفظ المال يقتضي التحفظ عليها ومنع التغرير بأموال الناس.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr5_2',
                evidenceKey: 'iifa:crypto:verdict',
                citation: 'بيانات وقرارات المجامع الفقهية حول العملات المشفرة',
                sourceId: 'src_qararat_majma_fiqh',
              ),
            ],
            sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي وهيئات الرقابة الشرعية',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_ai_human_governance',
        courseId: courseId,
        moduleId: 'mod_maqasid_crises_contemporary',
        title: 'حوكمة الذكاء الاصطناعي ومستقبل الكرامة الإنسانية في ضوء مقاصد الشريعة',
        orderIndex: 6,
        sources: const ['src_makkah_ai_charter', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_pr6_1',
            title: 'ميثاق مقاصدي للذكاء الاصطناعي',
            description: 'تأسيس ميثاق مقاصدي أخلاقي لتطوير واستخدام تقنيات الذكاء الاصطناعي.',
          ),
          LearningObjective(
            objectiveId: 'obj_pr6_2',
            title: 'حصرية المسؤولية الأخلاقية للإنسان',
            description: 'تأكيد حصرية المسؤولية الأخلاقية والجنائية على الإنسان وعدم تفويض القرارات المصيرية للآلات.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_pr6_1',
            title: 'الكرامة الإنسانية وحصرية التكليف والعقل',
            contentType: LearningContentType.explanation,
            content: 'الإنسان هو الكائن الوحيد المكلف المستخلف: ﴿وَلَقَدْ كَرَّمْنَا بَنِي آدَمَ﴾؛ والذكاء الاصطناعي مهما تطور يظل أداة حاسوبية مسخرة فاقدة للروح والإرادة الحرة والوعي الأخلاقي؛ فلا يجوز تفويض القرارات القضائية أو الطبية أو السيادية القاتلة (كالأسلحة ذاتية التشغيل) للآلات المستقلة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr6_1',
                evidenceKey: 'quran:17:70',
                citation: 'سورة الإسراء، الآية 70',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير الطبري ووثيقة مكة المكرمة للذكاء الاصطناعي',
          ),
          LessonSection.create(
            sectionId: 'sec_pr6_2',
            title: 'حفظ الخصوصية والعدالة وحوكمة البيانات',
            contentType: LearningContentType.scholarlyView,
            content: 'من المقاصد الشرعية حفظ العرض والخصوصية ومنع التجسس: ﴿وَلَا تَجَسَّسُوا﴾؛ وتوجب المقاصد الشفافية الخوارزمية، ومكافحة الانحياز والتمييز، ومنع احتكار الشركات الكبرى لبيانات البشرية، وتسخير الذكاء الاصطناعي في نشر العدالة والتعليم ومكافحة الفقر والأمراض.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_pr6_2',
                evidenceKey: 'makkah_charter:ai:2024',
                citation: 'وثيقة مكة المكرمة لأخلاقيات الذكاء الاصطناعي (رابطة العالم الإسلامي ومجامع الفقه، 2024)',
                sourceId: 'src_makkah_ai_charter',
              ),
            ],
            sourceAttribution: 'وثيقة مكة المكرمة لأخلاقيات الذكاء الاصطناعي وقرارات المؤتمرات الفقهية',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_priorities_muwazanat_rules',
        lessonId: 'lsn_priorities_maratib_amal',
        title: 'اختبار تقييم استيعاب: فقه الموازنات والأولويات',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_priorities_1',
            lessonId: 'lsn_priorities_maratib_amal',
            questionText: 'متى تقدم المصلحة الراجحة العظيمة على المفسدة الصغرى في الفقه الإسلامي؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qpr1_1', text: 'إذا كانت المصلحة عظيمة قطعية والمفسدة الملازمة يسيرة مغتفرة كالعمليات الجراحية وتناول الدواء'),
              QuizOption(optionId: 'opt_qpr1_2', text: 'لا تقدم المصلحة مطلقاً في أي حال من الأحوال'),
              QuizOption(optionId: 'opt_qpr1_3', text: 'تقدم المصلحة فقط إذا كانت في كسب الأموال'),
              QuizOption(optionId: 'opt_qpr1_4', text: 'إذا وافقت هوى النفس المجرد'),
            ],
            correctOptionIndices: const [0],
            explanation: 'المصالح العظمى الراجحة تقدم قطعاً على المفاسد اليسيرة التابعة التي لا ينفك عنها الفعل عادة.',
          ),
          QuizQuestion.create(
            questionId: 'q_priorities_2',
            lessonId: 'lsn_priorities_maratib_amal',
            questionText: 'ما هو العمل الأفضل عند تزاحم الأوقات بين نفل العبادة القاصر والعمل ذي النفع المتعدي للأمة؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qpr2_1', text: 'يقدم العمل ذو النفع المتعدي كطلب العلم وإغاثة الملهوفين ونشر الهداية'),
              QuizOption(optionId: 'opt_qpr2_2', text: 'يقدم نفل الصيام والاعتكاف الفردي دائماً'),
              QuizOption(optionId: 'opt_qpr2_3', text: 'تسقط جميع الأعمال لتزاحمها'),
              QuizOption(optionId: 'opt_qpr2_4', text: 'يترك المسلم الاختيار للقرعة بلا ترجيح'),
            ],
            correctOptionIndices: const [0],
            explanation: 'النفع المتعدي أعظم أجراً وأوسع أثراً في تحقيق مقاصد الشريعة وحفظ نظام الأمة.',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_maqasid_crises_contemporary',
        lessonId: 'lsn_maqasid_ai_human_governance',
        title: 'اختبار تقييم استيعاب: التطبيقات المقاصدية في النوازل والأزمات والذكاء الاصطناعي',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_priorities_3',
            lessonId: 'lsn_maqasid_ai_human_governance',
            questionText: 'ما هو الموقف المقاصدي الشرعي من حماية المناخ ومكافحة التلوث البيئي؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qpr3_1', text: 'واجب شرعي مقاصدي من صميم عمارة الأرض ومنع الفساد وحفظ النفس والنسل'),
              QuizOption(optionId: 'opt_qpr3_2', text: 'أمر مباح ثانوي لا يتعلق بالدين ولا بالتكليف'),
              QuizOption(optionId: 'opt_qpr3_3', text: 'بدعة دنيوية لا أصل لها في الشريعة'),
              QuizOption(optionId: 'opt_qpr3_4', text: 'مسألة خاصة بالدول غير المسلمة'),
            ],
            correctOptionIndices: const [0],
            explanation: 'حماية كوكب الأرض وعمارته وعدم إفساده بعد إصلاحه واجب مقاصدي استخلافي بنص القرآن الكريم.',
          ),
          QuizQuestion.create(
            questionId: 'q_priorities_4',
            lessonId: 'lsn_maqasid_ai_human_governance',
            questionText: 'ما هو الضابط المقاصدي الأهم في حوكمة وتطوير أنظمة الذكاء الاصطناعي؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qpr4_1', text: 'صيانة الكرامة الإنسانية وحصرية المسؤولية الأخلاقية والقضائية للإنسان وبقاء التقنية في خدمة استخلافه'),
              QuizOption(optionId: 'opt_qpr4_2', text: 'تفويض القرارات القضائية الجنائية والأحكام الشرعية بالكامل للخوارزميات'),
              QuizOption(optionId: 'opt_qpr4_3', text: 'السماح للأسلحة ذاتية التشغيل باتخاذ قرارات القتل دون رقابة بشرية'),
              QuizOption(optionId: 'opt_qpr4_4', text: 'إلغاء الخصوصية الشخصية في الفضاء الرقمي لجميع المستخدمين'),
            ],
            correctOptionIndices: const [0],
            explanation: 'الكرامة الإنسانية ومسؤولية التكليف حصرية للإنسان، وواجب الحوكمة المقاصدية إبقاء التقنية خادمة للإنسان خاضعة لأخلاقه.',
          ),
        ],
      ),
    ];
  }
}
