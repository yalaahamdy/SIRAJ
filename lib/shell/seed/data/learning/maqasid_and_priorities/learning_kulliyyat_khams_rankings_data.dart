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

/// بيانات مقرر الكليات الخمس وحفظ نظام العمران وتصنيف المقاصد الشرعية (6 دروس تأصيلية + اختباران استيعاب)
class LearningKulliyyatKhamsRankingsData {
  static const String courseId = 'course_kulliyyat_khams_rankings_omran';
  static const String pathId = 'path_maqasid_shariah_philosophy_priorities_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الكليات الخمس وحفظ نظام العمران وتصنيف المقاصد الشرعية',
      description: 'دراسة تأصيلية معمقة للكليات الضرورية الخمس (الدين، النفس، العقل، النسل، المال) وكيفية حفظها من جانبي الوجود والعدم، مع بيان مراتب المقاصد (الضروري، الحاجي، التحسيني ومكملاتها)، وتصنيف المقاصد إلى عامة وخاصة وجزئية وقواعد فض النزاع والتزاحم بينها.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_kulliyyat_khams_preservation', 'mod_maqasid_rankings_classification'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_kulliyyat_khams_preservation',
        courseId: courseId,
        title: 'الكليات الخمس الضرورية: أصول حفظها من جانبي الوجود والعدم',
        description: 'تحليل دقيق لأصول حفظ الدين والنفس والعقل والنسل والمال، وكيف شرع الإسلام أحكام البناء والتثبيت (الوجود) وأحكام الحماية والردع (العدم) لحفظ نظام العمران البشري.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_kulliyyat_deen_nafs',
          'lsn_kulliyyat_aql_nasl',
          'lsn_kulliyyat_mal_omran',
        ],
      ),
      CourseModule(
        moduleId: 'mod_maqasid_rankings_classification',
        courseId: courseId,
        title: 'مراتب المقاصد وتصنيفاتها وقواعد الموازنة عند التزاحم',
        description: 'دراسة هرمية المقاصد الثلاث: الضروريات والحاجيات والتحسينيات ومكملات كل رتبة، وتصنيف المقاصد من حيث العموم والخصوص والجزئية، وقواعد الترجيح عند تزاحم الكليات.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_kulliyyat_khams_preservation'],
        lessonIds: const [
          'lsn_maqasid_daruri_haji_tahsini',
          'lsn_maqasid_aammah_khassah_juziyyah',
          'lsn_maqasid_tazahum_kulliyyat_rules',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      Lesson.create(
        lessonId: 'lsn_kulliyyat_deen_nafs',
        courseId: courseId,
        moduleId: 'mod_kulliyyat_khams_preservation',
        title: 'حفظ الدين وحفظ النفس من جانبي الوجود والعدم وضوابطهما',
        orderIndex: 1,
        sources: const ['src_mustasfa_ghazali', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_kl1_1',
            title: 'حفظ الكلية وجوداً وعدماً',
            description: 'التمييز المنهجي بين حفظ الكلية المقاصدية من جانب الوجود وحفظها من جانب العدم.',
          ),
          LearningObjective(
            objectiveId: 'obj_kl1_2',
            title: 'مركزية حفظ الدين والنفس',
            description: 'إدراك مركزية حفظ الدين وحفظ النفس في المنظومة التشريعية الإسلامية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_kl1_1',
            title: 'حفظ الدين: تثبيت العقيدة وحمايتها',
            contentType: LearningContentType.explanation,
            content: 'حفظ الدين من جانب الوجود يكون بتشريع الإيمان والأركان والدعوة ونشر العلم وطلب التفقه في الدين؛ ومن جانب العدم يكون بمحاربة البدع والضلالات، والرد على الشبهات، وتحريم الردة وخيانة الأمة، والجهاد لحماية بيضة الإسلام وحرية التعبد.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl1_1',
                evidenceKey: 'mustasfa:1:287',
                citation: 'المستصفى للإمام الغزالي (ج1 ص287)',
                sourceId: 'src_mustasfa_ghazali',
              ),
            ],
            sourceAttribution: 'المستصفى للغزالي وقواعد الأحكام للعز بن عبد السلام',
          ),
          LessonSection.create(
            sectionId: 'sec_kl1_2',
            title: 'حفظ النفس: تقديس الحق في الحياة',
            contentType: LearningContentType.scholarlyView,
            content: 'شرع الله لحفظ النفس من جانب الوجود تناول الطيبات والتداوي والتغذي والوقاية الصحية؛ ومن جانب العدم جرّم قتل النفس بغير حق وجعله كقتل الناس جميعاً: ﴿مَنْ قَتَلَ نَفْساً بِغَيْرِ نَفْسٍ أَوْ فَسَادٍ فِي الْأَرْضِ فَكَأَنَّمَا قَتَلَ النَّاسَ جَمِيعاً﴾، وشرع القصاص حياةً للألباب، وحرّم الانتحار والإيذاء الجسدي بكل صوره.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl1_2',
                evidenceKey: 'quran:5:32',
                citation: 'سورة المائدة، الآية 32',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الجامع لأحكام القرآن للقرطبي والموافقات للشاطبي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_kulliyyat_aql_nasl',
        courseId: courseId,
        moduleId: 'mod_kulliyyat_khams_preservation',
        title: 'حفظ العقل وحفظ النسل والعرض ومواجهة المهددات المعاصرة',
        orderIndex: 2,
        sources: const ['src_qawaid_al_ahkam_izz', 'src_mowafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_kl2_1',
            title: 'حفظ العقل مناط التكليف',
            description: 'معرفة تشريعات حفظ العقل كأداة التكليف والتدبر والمسؤولية الإنسانية.',
          ),
          LearningObjective(
            objectiveId: 'obj_kl2_2',
            title: 'صيانة النسل والعرض',
            description: 'بيان منظومة حفظ النسل والعرض ودور الأسرة والستر والأخلاق في الاستقرار الاجتماعي.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_kl2_1',
            title: 'حفظ العقل مناط التكليف والاستخلاف',
            contentType: LearningContentType.explanation,
            content: 'العقل مناط التكليف وعماد التمييز الإنساني؛ حفظه الشارع إيجاباً بالأمر بالتفكر وطلب العلم وتحرير الفكر من الخرافة والتقليد الأعمى؛ وسلباً بتحريم كل ما يفسد إدراكه كالمسكرات والمخدرات وسائر المغيبات، وتغليظ العقوبة على ترويجها لما فيها من تعطيل للملكة التي كُرّم بها ابن آدم.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl2_1',
                evidenceKey: 'qawaid_izz:1:12',
                citation: 'قواعد الأحكام للعز بن عبد السلام (ج1 ص12)',
                sourceId: 'src_qawaid_al_ahkam_izz',
              ),
            ],
            sourceAttribution: 'قواعد الأحكام في مصالح الأنام للعز بن عبد السلام',
          ),
          LessonSection.create(
            sectionId: 'sec_kl2_2',
            title: 'حفظ النسل والعرض وصيانة المجتمع',
            contentType: LearningContentType.scholarlyView,
            content: 'حفظ النسل من جانب الوجود شرع الله له عقد النكاح ورعاية الطفولة والنفقة والتربية؛ ومن جانب العدم سد ذرائع الفساد بتحريم الزنا والشذوذ والخلوة المحرمة، وصان الأعراض بتشريع حد القذف والنهي الصارم عن الغيبة والبهتان والتشهير.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl2_2',
                evidenceKey: 'mowafaqat:2:15',
                citation: 'الموافقات للشاطبي (ج2 ص15)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي والمستصفى للغزالي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_kulliyyat_mal_omran',
        courseId: courseId,
        moduleId: 'mod_kulliyyat_khams_preservation',
        title: 'حفظ المال وعمارة الأرض وتدوير الثروة وحفظ النظام العام للأمة',
        orderIndex: 3,
        sources: const ['src_mowafaqat_shatibi', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_kl3_1',
            title: 'المال قوام المعاش والعمران',
            description: 'استيعاب دلالة قوله تعالى ﴿وَلَا تُؤْتُوا السُّفَهَاءَ أَمْوَالَكُمُ الَّتِي جَعَلَ اللَّهُ لَكُمْ قِيَاماً﴾.',
          ),
          LearningObjective(
            objectiveId: 'obj_kl3_2',
            title: 'حماية المال العام والخاص',
            description: 'ربط حفظ المال بعمارة الأرض والاستقرار الاقتصادي والعدالة الاجتماعية وحرمة المال العام.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_kl3_1',
            title: 'حفظ المال وتنميته ورواجه',
            contentType: LearningContentType.explanation,
            content: 'المال عصب الحياة وقوام العمران؛ شرع الله لكسبه وتنميته السعي في مناكب الأرض، والتجارة الرابحة، والعقود الاستثمارية، والتوثيق والشهادة والرهن؛ وأوجب دورانه في شرايين المجتمع ومنع كنزه واحتكاره لتحقيق التوازن بين مختلف الطبقات.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl3_1',
                evidenceKey: 'quran:4:5',
                citation: 'سورة النساء، الآية 5',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير القرطبي والموافقات للشاطبي',
          ),
          LessonSection.create(
            sectionId: 'sec_kl3_2',
            title: 'حماية المال من التعدي والضياع',
            contentType: LearningContentType.scholarlyView,
            content: 'حمى الشارع المال سلباً بتجريم السرقة والحرابة والغصب والرشوة وأكل أموال اليتامى والربا والغرر الفاحش، وشرع الحجر على السفيه والمبذر لحماية ماله، وجعل حماية المال العام أعظم حرمة من المال الخاص لعلو مصلحة مجموع الأمة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl3_2',
                evidenceKey: 'mowafaqat:2:17',
                citation: 'الموافقات للشاطبي (ج2 ص17)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي وبداية المجتهد لابن رشد',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_daruri_haji_tahsini',
        courseId: courseId,
        moduleId: 'mod_maqasid_rankings_classification',
        title: 'المراتب الثلاث: الضروريات والحاجيات والتحسينيات ومكملاتها',
        orderIndex: 4,
        sources: const ['src_mowafaqat_shatibi', 'src_mustasfa_ghazali'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_kl4_1',
            title: 'التمييز بين المراتب الثلاث',
            description: 'التمييز الدقيق بين الضروري والحاجي والتحسيني في كافة أبواب الفقه الإسلامي.',
          ),
          LearningObjective(
            objectiveId: 'obj_kl4_2',
            title: 'ضابط مكملات الرتب',
            description: 'فهم قاعدة أن المكمل للرتبة إذا عاد عليها بالإبطال سقط اعتباره شرعاً.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_kl4_1',
            title: 'تحديد المراتب المقاصدية الثلاث',
            contentType: LearningContentType.explanation,
            content: 'الضروريات هي التي لا بد منها في قيام مصالح الدين والدنيا بحيث إذا فقدت اختل نظام الحياة وعم الفساد واستحقاق العذاب؛ والحاجيات هي المفتقر إليها للتوسعة ورفع الضيق كأنواع الرخص والإجارات؛ والتحسينيات هي الأخذ بما يليق من محاسن العادات والآداب كالطهارات وستر العورات وخصال الفطرة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl4_1',
                evidenceKey: 'mowafaqat:2:8',
                citation: 'الموافقات للشاطبي (كتاب المقاصد، ج2 ص8)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي والبرهان لإمام الحرمين',
          ),
          LessonSection.create(
            sectionId: 'sec_kl4_2',
            title: 'المكملات وضوابطها التشريعية',
            contentType: LearningContentType.scholarlyView,
            content: 'كل رتبة من هذه الرتب لها مكمل يخدمها ويتممها؛ كمشروعية الجماعة والأذان مكمل لإقامة الصلاة، وتضمين الصناع مكمل للإجارة. وقاعدة الشاطبي الكبرى: «كل تكملة أفضت إلى إبطال أصلها فلا تصح تكملة»، فالأصل مقدم على الفرع والمكمل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl4_2',
                evidenceKey: 'mowafaqat:2:12',
                citation: 'الموافقات للشاطبي (ج2 ص12)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات في أصول الشريعة للشاطبي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_aammah_khassah_juziyyah',
        courseId: courseId,
        moduleId: 'mod_maqasid_rankings_classification',
        title: 'المقاصد العامة والخاصة والجزئية وحفظ تماسك المنظومة',
        orderIndex: 5,
        sources: const ['src_maqasid_ashoor', 'src_mowafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_kl5_1',
            title: 'تصنيف المقاصد وفق نطاق الشمول',
            description: 'تصنيف المقاصد الشرعية وفق نطاق شمولها وتطبيقها التشريعي.',
          ),
          LearningObjective(
            objectiveId: 'obj_kl5_2',
            title: 'انسجام الجزئي مع الكلي',
            description: 'إدراك انسجام المقصد الجزئي مع المقصد الخاص والعام وتفادي التناقض الفقهي.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_kl5_1',
            title: 'المقاصد العامة للشريعة',
            contentType: LearningContentType.explanation,
            content: 'المقاصد العامة هي المعاني والحكم والغايات التي راعاها الشارع في جميع أو معظم أحوال التشريع؛ مثل إقامة العدل، ونشر الرحمة، وموافقة الفطرة، والتيسير ورفع الحرج، وحفظ النظام والأمن والاستقرار الاجتماعي، وحرية الاختيار والمسؤولية الفردية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl5_1',
                evidenceKey: 'ashoor_maqasid:145',
                citation: 'مقاصد الشريعة الإسلامية لابن عاشور (ص145)',
                sourceId: 'src_maqasid_ashoor',
              ),
            ],
            sourceAttribution: 'مقاصد الشريعة الإسلامية لابن عاشور',
          ),
          LessonSection.create(
            sectionId: 'sec_kl5_2',
            title: 'المقاصد الخاصة والجزئية',
            contentType: LearningContentType.scholarlyView,
            content: 'المقاصد الخاصة هي الغايات المرادة للشارع في مجال مخصوص؛ كمقاصد المعاملات المالية أو مقاصد الأسرة أو مقاصد الجنايات والعقوبات. أما المقاصد الجزئية فهي الحكمة المخصوصة من كل حكم مفرد كحكمة مشروعية الاستئذان أو حكمة مشروعية الأشهاد في النكاح.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl5_2',
                evidenceKey: 'ashoor_maqasid:150',
                citation: 'مقاصد الشريعة الإسلامية لابن عاشور (المقاصد الخاصة)',
                sourceId: 'src_maqasid_ashoor',
              ),
            ],
            sourceAttribution: 'مقاصد الشريعة لابن عاشور والموافقات للشاطبي',
          ),
        ],
      ),
      Lesson.create(
        lessonId: 'lsn_maqasid_tazahum_kulliyyat_rules',
        courseId: courseId,
        moduleId: 'mod_maqasid_rankings_classification',
        title: 'قواعد التزاحم وترتيب الضروريات الخمس عند التعارض',
        orderIndex: 6,
        sources: const ['src_mustasfa_ghazali', 'src_mowafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_kl6_1',
            title: 'الترتيب الأصولي للكليات',
            description: 'إتقان الترتيب الأصولي للكليات الخمس عند التعارض والتزاحم الحقيقي.',
          ),
          LearningObjective(
            objectiveId: 'obj_kl6_2',
            title: 'موازنة كلي الضرورة وجزئيها',
            description: 'تطبيق قواعد التزاحم والموازنة بين كلي الضرورة وجزئيتها في النوازل المعاصرة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_kl6_1',
            title: 'ترتيب الكليات الخمس عند التزاحم',
            contentType: LearningContentType.explanation,
            content: 'جمهور الأصوليين يرتبون الضروريات: الدين مقدماً على النفس، والنفس مقدمة على العقل والنسل، وهما مقدمان على المال. فلأجل حفظ الدين كلياً تُبذل النفوس في الجهاد والشهادة، ولأجل حفظ النفس يُباح أكل الميتة وشرب الخمر للغصة وإتلاف مال الغير للمضطر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl6_1',
                evidenceKey: 'mustasfa:1:290',
                citation: 'المستصفى للغزالي (ج1 ص290)',
                sourceId: 'src_mustasfa_ghazali',
              ),
            ],
            sourceAttribution: 'المستصفى لحجة الإسلام الغزالي',
          ),
          LessonSection.create(
            sectionId: 'sec_kl6_2',
            title: 'تحقيق الموازنة بين كلي الضرورة وجزئيها',
            contentType: LearningContentType.scholarlyView,
            content: 'من دقائق فقه التزاحم مراعاة الكلي والجزئي؛ فحفظ نفس عامة المسلمين (كلية النفس العامة) مقدم على مصلحة دين فردي جزئي؛ وحفظ استقرار الدولة المسلمة ورعيتها مقدم على حفظ أموال أفراد قلائل عند الأزمات الخانقة والجوائح العامة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_kl6_2',
                evidenceKey: 'mowafaqat:2:25',
                citation: 'الموافقات للشاطبي (ج2 ص25)',
                sourceId: 'src_mowafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات للشاطبي وقواعد الأحكام للعز بن عبد السلام',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_kulliyyat_khams_preservation',
        lessonId: 'lsn_kulliyyat_mal_omran',
        title: 'اختبار تقييم استيعاب: أصول حفظ الكليات الخمس',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_kulliyyat_1',
            lessonId: 'lsn_kulliyyat_mal_omran',
            questionText: 'ما هو المقصود بحفظ الكلية المقاصدية من «جانب الوجود»؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qkl1_1', text: 'تشريع الأحكام التي تبني الكلية وتثبت أركانها وتنميها كتشريع الإيمان والنكاح والعمل'),
              QuizOption(optionId: 'opt_qkl1_2', text: 'فرض العقوبات الزاجرة على من اعتدى عليها فقط دون بناء إيجابي'),
              QuizOption(optionId: 'opt_qkl1_3', text: 'إلغاء المعاملات الدنيوية والتركيز على العبادات الفردية'),
              QuizOption(optionId: 'opt_qkl1_4', text: 'تأخير التكاليف الشرعية إلى حين الحاجة إليها'),
            ],
            correctOptionIndices: const [0],
            explanation: 'حفظ الكلية من جانب الوجود يعني تشريع كل ما يقيم أصلها ويثبت أركانها في الوجود والواقع.',
          ),
          QuizQuestion.create(
            questionId: 'q_kulliyyat_2',
            lessonId: 'lsn_kulliyyat_mal_omran',
            questionText: 'لماذا جعل الشارع الاعتداء على المال العام أعظم حرمة وغلظة من الاعتداء على المال الخاص؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qkl2_1', text: 'لأن حق عموم الأمة متعلق به، وحفظ مصلحة المجموع مقدم على مصلحة الفرد'),
              QuizOption(optionId: 'opt_qkl2_2', text: 'لأن المال العام لا صاحب له ولا رقيب عليه'),
              QuizOption(optionId: 'opt_qkl2_3', text: 'لأنه من التحسينيات والكماليات التابعة'),
              QuizOption(optionId: 'opt_qkl2_4', text: 'لعدم وجود نصوص صريحة في المال الخاص'),
            ],
            correctOptionIndices: const [0],
            explanation: 'المال العام عصب المجتمع ودولة الأمة، فالاعتداء عليه اعتداء على حقوق جميع المسلمين وحفظه ضرورة كلية.',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_maqasid_rankings_classification',
        lessonId: 'lsn_maqasid_tazahum_kulliyyat_rules',
        title: 'اختبار تقييم استيعاب: مراتب المقاصد وقواعد التزاحم',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_kulliyyat_3',
            lessonId: 'lsn_maqasid_tazahum_kulliyyat_rules',
            questionText: 'ما هي القاعدة الأصولية المقاصدية في المكملات التابعة لأصل الرتبة؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qkl3_1', text: 'كل تكملة أفضت إلى إبطال أصلها فلا تصح تكملة ويسقط اعتبارها'),
              QuizOption(optionId: 'opt_qkl3_2', text: 'المكمل يقدم دائماً على أصله الضروري في كل حال'),
              QuizOption(optionId: 'opt_qkl3_3', text: 'التحسيني يلغي الضروري عند التعارض'),
              QuizOption(optionId: 'opt_qkl3_4', text: 'لا علاقة بين المكمل والأصل في الرتب المقاصدية'),
            ],
            correctOptionIndices: const [0],
            explanation: 'قرر الشاطبي أن المكمل إنما شُرع لخدمة الأصل، فإذا أدى اعتباره إلى نقض الأصل وإبطاله رُد المكمل ورُعي الأصل.',
          ),
          QuizQuestion.create(
            questionId: 'q_kulliyyat_4',
            lessonId: 'lsn_maqasid_tazahum_kulliyyat_rules',
            questionText: 'عند تعارض حفظ النفس مع حفظ المال لمضطر أشرف على الهلاك، ماذا يقدم الشرع؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qkl4_1', text: 'يقدم حفظ النفس ويُباح له أكل طعام غيره لدفع الهلاك وتضمن قيمته لاحقاً'),
              QuizOption(optionId: 'opt_qkl4_2', text: 'يقدم حفظ المال ويترك نفسه للهلاك صيانة للأموال'),
              QuizOption(optionId: 'opt_qkl4_3', text: 'يسقط حفظ النفس وحفظ المال معاً بلا ترجيح'),
              QuizOption(optionId: 'opt_qkl4_4', text: 'يخير المضطر بين الهلاك وأكل مال الغير'),
            ],
            correctOptionIndices: const [0],
            explanation: 'حفظ النفس مقدم قطعاً على حفظ المال، والضرورات تبيح المحظورات مع حفظ حق المالك بالضمان.',
          ),
        ],
      ),
    ];
  }
}
