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

/// بيانات مقرر علم الصرف وبناء الكلمة واشتقاق المعاني الشرعية (6 دروس تأصيلية + اختباران استيعاب)
class LearningSarfMorphologyLexiconData {
  static const String courseId = 'course_sarf_morphology_lexicon';
  static const String pathId = 'path_arabic_language_bayan_semantics_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر علم الصرف وبناء الكلمة واشتقاق المعاني الشرعية',
      description: 'دراسة تأصيلية عميقة لبنية الكلمة العربية وقواعد الميزان الصرفي، المجرد والمزيد، معاني صيغ الزيادة في الأفعال وأثرها البلاغي في القرآن، أحكام المشتقات ودلالاتها التشريعية والأصولية، وقوانين الإعلال والإبدال والتناسب الصوتي والإعجاز الصرفي.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_sarf_mizan_awzan_ziyadah', 'mod_sarf_mushtaqqat_ilal_ibdal'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_sarf_mizan_awzan_ziyadah',
        courseId: courseId,
        title: 'الميزان الصرفي وأوزان الأفعال ودلالات معاني الزيادة القرآنية',
        description: 'قواعد وزن الكلمات، أصول التجرد والزيادة، معاني صيغ الزيادة في الأفعال الثلاثية والرباعية، وتطبيقات قرآنية على دقائق الفروق الصرفية كـ(نزّل وأنزل، واسطاعوا واستطاعوا).',
        orderIndex: 1,
        lessonIds: const [
          'lsn_sarf_mizan_mujarrad_mazeed',
          'lsn_sarf_abniyah_afal_meanings',
          'lsn_sarf_quranic_ziyadah_nuances',
        ],
      ),
      CourseModule(
        moduleId: 'mod_sarf_mushtaqqat_ilal_ibdal',
        courseId: courseId,
        title: 'المشتقات وأثرها التشريعي وأسرار الإعلال والإبدال في النظم',
        description: 'دراسة المشتقات العاملة وغير العاملة ودورها في تعيين الأحكام الشرعية، أسماء الزمان والمكان والمصادر، وقوانين الإعلال والإبدال والتجاور الصوتي في القرآن.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_sarf_mizan_awzan_ziyadah'],
        lessonIds: const [
          'lsn_sarf_mushtaqqat_shariah_impact',
          'lsn_sarf_zaman_makan_masadir',
          'lsn_sarf_ilal_ibdal_aesthetic_balance',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 1: الميزان الصرفي
      Lesson.create(
        lessonId: 'lsn_sarf_mizan_mujarrad_mazeed',
        title: 'الميزان الصرفي والفعل المجرد والمزيد وأصول الأبنية',
        courseId: courseId,
        moduleId: 'mod_sarf_mizan_awzan_ziyadah',
        orderIndex: 1,
        sources: const ['src_shadha_al_arf', 'src_al_munsif_ibn_jinni', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_sarf_1_1',
            title: 'إتقان الميزان الصرفي (فعل)',
            description: 'فهم معيار الوزن بفاء الكلمة وعينها ولامها، وقواعد وزن الحركات وسكنات الكلمات وما يحذف منها أو يزاد.',
          ),
          LearningObjective(
            objectiveId: 'obj_sarf_1_2',
            title: 'أقسام الفعل من حيث التجرد والزيادة',
            description: 'التمييز بين الثلاثي المجرد (أبوابه الستة) والرباعي المجرد، ومزيدات الثلاثي بحرف وحرفين وثلاثة أحرف.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_sarf_1_1',
            title: 'حقيقة علم الصرف والميزان العربي المعياري',
            contentType: LearningContentType.sourceText,
            content: 'علم الصرف هو العلم بالقواعد التي يعرف بها أحوال أبنية الكلم التي ليست بإعراب ولا بناء. اختار علماء العربية ميزاناً ثلاثياً هو أحرف (ف ع ل) لعموم دلالة الفعل وخفة أحرفه؛ فالحرف الأصلي الأول يقابل الفاء، والثاني العين، والثالث اللام. وإذا كانت الزيادة ناشئة عن تكرير أصل كرر ما يقابله في الميزان (قَدَّمَ: فَعَّلَ)، وإن كانت ناشئة عن حرف زائد من حروف (سألتمونيها) وزن بلفظه (أَكْرَمَ: أَفْعَلَ، اسْتَغْفَرَ: اسْتَفْعَلَ). ومراقبة الميزان تكشف عن المحذوف كوزن (قُلْ: فُلْ) و(عِدْ: عِلْ).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_1_1',
                evidenceKey: 'shadha_arf:bab_mizan',
                citation: 'شذا العرف في فن الصرف للشيخ أحمد الحملاوي',
                sourceId: 'src_shadha_al_arf',
              ),
            ],
            sourceAttribution: 'المنصف لابن جني والممتع في التصريف لابن عصفور وشذا العرف',
          ),
          LessonSection.create(
            sectionId: 'sec_sarf_1_2',
            title: 'أبواب الفعل الثلاثي المجرد ودلالاتها المعنوية',
            contentType: LearningContentType.explanation,
            content: 'ينقسم الثلاثي المجرد إلى ستة أبواب بحسب حركة عين الفعل في الماضي والمضارع: 1. (فَعَلَ يَفْعُلُ) كنَصَرَ يَنْصُرُ، ويكثر في الأفعال المتعدية والدالة على الغلبة. 2. (فَعَلَ يَفْعِلُ) كضَرَبَ يَضْرِبُ. 3. (فَعَلَ يَفْعَلُ) كفَتَحَ يَفْتَحُ، ولا يكون إلا بحلقي العين أو اللام. 4. (فَعِلَ يَفْعَلُ) كفَرِحَ يَفْرَحُ، ويكثر في العلل والأعراض والألوان والامتلاء والخلو. 5. (فَعُلَ يَفْعُلُ) ككَرُمَ يَكْرُمُ، وهو خاص بالغرائز والطبائع الثابتة اللازمة. 6. (فَعِلَ يَفْعِلُ) كحَسِبَ يَحْسِبُ.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_1_2',
                evidenceKey: 'al_marah_fi_sarf:abwab',
                citation: 'مراح الأرواح لأحمد بن علي بن مسعود وشرح الشافية للرضي',
                sourceId: 'src_shadha_al_arf',
              ),
            ],
            sourceAttribution: 'شرح شافية ابن الحاجب للرضي وشذا العرف',
          ),
        ],
      ),

      // Lesson 2: معاني صيغ الزيادة
      Lesson.create(
        lessonId: 'lsn_sarf_abniyah_afal_meanings',
        title: 'معاني صيغ الزيادة في الأفعال (أفعل، فعّل، فاعل، تفعّل، تفاعل، استفعل)',
        courseId: courseId,
        moduleId: 'mod_sarf_mizan_awzan_ziyadah',
        orderIndex: 2,
        sources: const ['src_al_munsif_ibn_jinni', 'src_shadha_al_arf', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_sarf_2_1',
            title: 'القاعدة الكلية: زيادة المبنى تدل على زيادة المعنى',
            description: 'استيعاب كيف يضيف كل حرف زائد في بنية الفعل أبعاداً دلالية ونفسية وتشريعية جديدة.',
          ),
          LearningObjective(
            objectiveId: 'obj_sarf_2_2',
            title: 'تحليل دلالات الصيغ المزيدة',
            description: 'معرفة معاني (أَفْعَلَ) للتعدية والصيرورة، و(فَعَّلَ) للتكثير والتدريج، و(اسْتَفْعَلَ) للطلب والتحول.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_sarf_2_1',
            title: 'صيغ الثلاثي المزيد بحرف: أفعل، فعّل، وفاعل',
            contentType: LearningContentType.sourceText,
            content: 'صيغة (أَفْعَلَ) تفيد التعدية غالباً (أَخْرَجَ، أَنْزَلَ)، والدخول في الزمان أو المكان (أَصْبَحَ، أَمْسَى، أَعْرَقَ)، والسلب والإزالة (أَعْجَمَ الكتاب أي أزال عجمته). وصيغة (فَعَّلَ) تفيد التكثير والمبالغة الشديدة في الفعل أو الفاعل أو المفعول (قَطَّعَ الثياب، غَلَّقَتِ الأبواب)، والتدريج والتفريق (نَزَّلَ القرآن منجماً)، ونسبة المفعول إلى أصل الفعل (فَسَّقَهُ، كَفَّرَهُ). وصيغة (فَاعَلَ) تفيد المشاركة بين اثنين فأكثر (ضَارَبَ، قَاتَلَ) والموالاة (تَابَعَ الصيام).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_2_1',
                evidenceKey: 'quran:12:23',
                citation: 'سورة يوسف: الآية 23 (غَلَّقَتِ الأَبْوَابَ)',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الخصائص لابن جني وشرح الكافية الشافية لابن مالك',
          ),
          LessonSection.create(
            sectionId: 'sec_sarf_2_2',
            title: 'صيغ المزيد بحرفين وبثلاثة أحرف: انْفَعَلَ، افْتَعَلَ، تَفَعَّلَ، تَفَاعَلَ، واسْتَفْعَلَ',
            contentType: LearningContentType.explanation,
            content: 'صيغة (انْفَعَلَ) للمطاوعة والقبول ولا تكون إلا في العلاج الحسي اللازم (انْكَسَرَ، انْفَجَرَ). وصيغة (افْتَعَلَ) للاكتساب والاجتهاد والاعتناء البالغ كقوله تعالى: ﴿لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ﴾؛ فعبّر في الخير بكسب لسهولته وموافقته الفطرة، وفي الشر باكتسب لما فيه من تكلف وافتعال ومعاناة الآثام. وصيغة (تَفَعَّلَ) للتكلف والتدريج (تَعَلَّمَ، تَفَقَّهَ). وصيغة (تَفَاعَلَ) للمشاركة والتظاهر (تَنَاصَرَ، تَمَارَضَ). وصيغة (اسْتَفْعَلَ) للطلب الصريح أو المجازي (اسْتَغْفَرَ: طلب المغفرة) والتحول والصيرورة (اسْتَحْجَرَ الطين).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_2_2',
                evidenceKey: 'quran:2:286',
                citation: 'سورة البقرة: الآية 286',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'معترك الأقران في إعجاز القرآن للسيوطي وشذا العرف',
          ),
        ],
      ),

      // Lesson 3: دقائق الفروق الصرفية في القرآن
      Lesson.create(
        lessonId: 'lsn_sarf_quranic_ziyadah_nuances',
        title: 'دقائق الفروق الصرفية في القرآن: (نزّل وأنزل، استطاعوا واسطاعوا، يتوفى وتوفته)',
        courseId: courseId,
        moduleId: 'mod_sarf_mizan_awzan_ziyadah',
        orderIndex: 3,
        sources: const ['src_itqan_suyuti', 'src_durr_al_masun', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_sarf_3_1',
            title: 'الفرق الدلالي بين التنزيل والإنزال',
            description: 'فهم أسرار استعمال (نَزَّلَ) بالتضعيف للنزول المنجم التدريجي و(أَنْزَلَ) للنزول الجملي أو الدفعة الواحدة.',
          ),
          LearningObjective(
            objectiveId: 'obj_sarf_3_2',
            title: 'التخفيف بالحذف وأثره البياني',
            description: 'تحليل ظواهر الحذف الصرفي للتخفيف ومطابقة المعنى للخفة أو المشقة كقوله في سد ذي القرنين: ﴿فَمَا اسْطَاعُوا أَن يَظْهَرُوهُ وَمَا اسْتَطَاعُوا لَهُ نَقْباً﴾.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_sarf_3_1',
            title: 'السر الصرفي بين (أَنْزَلَ) و(نَزَّلَ) في القرآن والكتب السابقة',
            contentType: LearningContentType.sourceText,
            content: 'استعمل القرآن الكريم صيغة (أَنْزَلَ) الرباعية في نزول القرآن جملة واحدة إلى بيت العزة في السماء الدنيا في ليلة القدر: ﴿إِنَّا أَنزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ﴾، وفي نزول التوراة والإنجيل جملة: ﴿وَأَنزَلَ التَّوْرَاةَ وَالإِنجِيلَ﴾. واستعمل صيغة (نَزَّلَ) المضعفة الدالة على التكرير والتفريق والتنجيم في نزول القرآن مفرقاً على قلب النبي ﷺ بحسب الوقائع في 23 سنة: ﴿وَقُرْآناً فَرَقْنَاهُ لِتَقْرَأَهُ عَلَى النَّاسِ عَلَى مُكْثٍ وَنَزَّلْنَاهُ تَنزِيلاً﴾، وكذا ﴿نَزَّلَ عَلَيْكَ الْكِتَابَ بِالْحَقِّ﴾، فكان التضعيف الصرفي مرآة لواقع التنجيم النبوي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_3_1',
                evidenceKey: 'quran:17:106',
                citation: 'سورة الإسراء: الآية 106',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الإتقان في علوم القرآن للسيوطي والبرهان للزركشي',
          ),
          LessonSection.create(
            sectionId: 'sec_sarf_3_2',
            title: 'التناسب الصرفي بين مبنى الفعل وجهد العمل: ﴿اسْطَاعُوا﴾ و﴿اسْتَطَاعُوا﴾',
            contentType: LearningContentType.scholarlyView,
            content: 'في قصة ذي القرنين في سورة الكهف قال الله تعالى: ﴿فَمَا اسْطَاعُوا أَن يَظْهَرُوهُ وَمَا اسْتَطَاعُوا لَهُ نَقْباً﴾. حذف التاء في الأولى وخفف الفعل (اسْطَاعُوا) لأن صعود السد والظهور عليه كان أسهل وأخف كلفة وزمناً من نقب السد الحديدي المفرغ عليه النحاس المصهور، فلما جاء لذكر النقب الشاق الذي يحتاج إلى آلات هائلة وزمن طويل أتى بالفعل تام الحروف ثقيلاً (اسْتَطَاعُوا) لمطابقة ثقل اللفظ لثقل المعنى والجهد؛ وهو من أبدع مظاهر الإعجاز الصرفي في القرآن.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_3_2',
                evidenceKey: 'quran:18:97',
                citation: 'سورة الكهف: الآية 97',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الكشاف للزمخشري وتفسير ابن عاشور (التحرير والتنوير)',
          ),
        ],
      ),

      // Lesson 4: المشتقات وأثرها التشريعي
      Lesson.create(
        lessonId: 'lsn_sarf_mushtaqqat_shariah_impact',
        title: 'المشتقات العاملة: اسم الفاعل واسم المفعول والصفة المشبهة ودلالاتها التشريعية',
        courseId: courseId,
        moduleId: 'mod_sarf_mushtaqqat_ilal_ibdal',
        orderIndex: 4,
        sources: const ['src_al_burhan_zarkashi', 'src_shadha_al_arf', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_sarf_4_1',
            title: 'أحكام ودلالات اسم الفاعل والمفعول',
            description: 'استيعاب الفرق بين دلالة الفعل على التجدد والحدوث ودلالة الوصف المشتق على الثبوت والاستقرار والمسؤولية الجنائية.',
          ),
          LearningObjective(
            objectiveId: 'obj_sarf_4_2',
            title: 'الأثر الأصولي والفقهي للمشتقات',
            description: 'دراسة قاعدة: تعليق الحكم بالمشتق يؤذن بعلية ما منه الاشتقاق (كالسارق والزاني والمؤمن).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_sarf_4_1',
            title: 'قاعدة تعليق الأحكام بالأسماء المشتقة وأثرها الفقهي',
            contentType: LearningContentType.sourceText,
            content: 'من القواعد الصرفية الأصولية الكبرى: «تعليق الحكم بالاسم المشتق يدل على أن علة الحكم هي المأخذ الذي اشتق منه ذلك الاسم». فقوله تعالى: ﴿وَالسَّارِقُ وَالسَّارِقَةُ فَاقْطَعُواْ أَيْدِيَهُمَا﴾ علّق فيه قطع اليد باسم الفاعل المشتق (السارق)، فدل صرفياً وأصولياً على أن علة وجوب القطع هي صدور السرقة منه. وكذا ﴿الزَّانِيَةُ وَالزَّانِي فَاجْلِدُوا كُلَّ وَاحِدٍ مِّنْهُمَا مِائَةَ جَلْدَةٍ﴾ دل على أن علة الجلد هي الزنا. واشتراط تحقق الوصف حال التلبس بالفعل كان منشأ خلاف الفقهاء في بقاء الاسم المشتق بعد انقضاء الفعل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_4_1',
                evidenceKey: 'quran:5:38',
                citation: 'سورة المائدة: الآية 38',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قواطع الأدلة في الأصول للسمعاني والمحصول للرازي والبرهان للزركشي',
          ),
          LessonSection.create(
            sectionId: 'sec_sarf_4_2',
            title: 'الفرق بين اسم الفاعل والصفة المشبهة وصيغ المبالغة في الأسماء والصفات الإلهية',
            contentType: LearningContentType.explanation,
            content: 'اسم الفاعل يصاغ ليدل على من قام به الفعل على وجه الحدوث والتجدد (كَاتِب، ذَاهِب)، بينما الصفة المشبهة تدل على الثبوت والدوام والاستقرار في الموصوف (كَرِيم، شَهْم، عَلِيم). وصيغ المبالغة تدل على الكثرة والتعظيم (فَعَّال، فَعُول، مِفْعَال، فَعِيل، فَعِل). وتتجلى الدقة الصرفية في أسماء الله الحسنى وصفاته: فـ(الغَفَّار) صيغة مبالغة لكثرة من يغفر لهم من المذنبين وتكرر المغفرة، و(الغَفُور) لعظم المغفرة وستر الكبائر، و(العَلِيم) لثبوت العلم المطلق الذي لا يسبقه جهل ولا يلحقه نسيان.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_4_2',
                evidenceKey: 'quran:20:82',
                citation: 'سورة طه: الآية 82',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'شأن الدعاء للخطابي واشتقاق أسماء الله للزجاجي وشذا العرف',
          ),
        ],
      ),

      // Lesson 5: أسماء الزمان والمكان والمصادر
      Lesson.create(
        lessonId: 'lsn_sarf_zaman_makan_masadir',
        title: 'أسماء الزمان والمكان والآلة والمصدر الميمي واسما المرة والهيئة',
        courseId: courseId,
        moduleId: 'mod_sarf_mushtaqqat_ilal_ibdal',
        orderIndex: 5,
        sources: const ['src_shadha_al_arf', 'src_sharh_ibn_aqil', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_sarf_5_1',
            title: 'صياغة ودلالات أسماء المكان والزمان والآلة',
            description: 'فهم أوزان مَفْعَل ومَفْعِل وصياغتها من غير الثلاثي ومواضع الشذوذ القياسي كـ(المَسْجِد والمَشْرِق).',
          ),
          LearningObjective(
            objectiveId: 'obj_sarf_5_2',
            title: 'المصادر وأنواعها وأثرها في صياغة العقود والتكاليف',
            description: 'التمييز بين المصدر الأصلي والميمي واسم المرة (فَعْلَة) الدال على العدد واسم الهيئة (فِعْلَة) الدال على الكيفية المشروعة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_sarf_5_1',
            title: 'أسماء الزمان والمكان في الاستعمال الشرعي',
            contentType: LearningContentType.sourceText,
            content: 'يصاغ اسما الزمان والمكان من الثلاثي على (مَفْعَل) إذا كان المضارع مضموم العين أو مفتوحها أو ناقصاً (مَكْتَب، مَدْخَل، مَأْوَى)، وعلى (مَفْعِل) إذا كان المضارع مكسور العين أو مثالاً واوياً (مَجْلِس، مَوْعِد). ووردت كلمات بالكسر شذوذاً عن القياس كـ(المَسْجِد، والمَشْرِق، والمَغْرِب، والمَنْسِك). واسم المكان يرتبط به أحكام شرعية تتعلق بحرمة المواضع ومواقيت العبادات الزمانية والمكانية في الحج والصلوات.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_5_1',
                evidenceKey: 'quran:17:1',
                citation: 'سورة الإسراء: الآية 1 (الْمَسْجِدِ الْحَرَامِ)',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تهذيب اللغة للأزهري وشذا العرف في فن الصرف',
          ),
          LessonSection.create(
            sectionId: 'sec_sarf_5_2',
            title: 'اسم المرة واسم الهيئة وأثرهما في السنة النبوية والأحكام',
            contentType: LearningContentType.explanation,
            content: 'اسم المرة يصاغ على وزن (فَعْلَة) ليدل على وقوع الفعل مرة واحدة (ضَرْبَة، سَجْدَة)، واسم الهيئة على وزن (فِعْلَة) ليدل على صفة وهيئة وقوع الفعل (جِلْسَة، مِشْيَة). وتجلى هذا الإحكام الصرفي البديع في قول النبي ﷺ: «إنَّ اللهَ كتبَ الإحسانَ على كلِّ شيء، فإذا قتلتُم فأحسِنوا القِتْلَةَ، وإذا ذبحتُم فأحسِنوا الذِّبْحَةَ»؛ حيث أتى بوزن (فِعْلَة) بالكسر للدلالة على الهيئة الكاملة الرحيمة في إزهاق الروح ومراعاة كرامة الكائن دون تعذيب.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_5_2',
                evidenceKey: 'muslim:1955',
                citation: 'صحيح مسلم: حديث رقم 1955',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'شرح صحيح مسلم للنووي ومقاييس اللغة لابن فارس',
          ),
        ],
      ),

      // Lesson 6: الإعلال والإبدال
      Lesson.create(
        lessonId: 'lsn_sarf_ilal_ibdal_aesthetic_balance',
        title: 'الإعلال والإبدال وتصريف المعتل وأسرار التناسب الصوتي والصرفي في القرآن',
        courseId: courseId,
        moduleId: 'mod_sarf_mushtaqqat_ilal_ibdal',
        orderIndex: 6,
        sources: const ['src_al_munsif_ibn_jinni', 'src_shadha_al_arf', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_sarf_6_1',
            title: 'قوانين الإعلال (بالقلب والنقل والحذف)',
            description: 'فهم تحولات حروف العلة في الأفعال المعتلة كـ(قال وباع وخاف ودعا وقضى) وقواعد التخلص من الثقل.',
          ),
          LearningObjective(
            objectiveId: 'obj_sarf_6_2',
            title: 'قوانين الإبدال والتجاور الصوتي في القرآن',
            description: 'استيعاب إبدال تاء الافتعال طاءً أو دالاً (اصطبر، ازدان، ادّكر) وأثر التآلف الصوتي في الجرس القرآني.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_sarf_6_1',
            title: 'أنواع الإعلال الثلاثة وسر خفة اللسان العربي',
            contentType: LearningContentType.sourceText,
            content: 'الإعلال تغيير يطرأ على حروف العلة (الألف والواو والياء) طلباً للخفة والتناسق، وهو ثلاثة أنواع: 1. الإعلال بالقلب: كقلب الواو والياء ألفاً إذا تحركتا وانفتح ما قبلهما (قَوَلَ صارت قَالَ، وبَيَعَ صارت بَاعَ)، وقلب الواو ياءً إذا سبقت بكسرة (مِقْوَام صارت مِقْيَام). 2. الإعلال بالنقل (التسكين): كنقل حركة حرف العلة إلى الساكن الصحيح قبله (يَقْوُلُ تصبح يَقُولُ، ويَبْيِعُ تصبح يَبِيعُ). 3. الإعلال بالحذف: لحذف حرف العلة دفعاً لالتقاء الساكنين (قُلْ، بِعْ) أو في المضارع المجزوم والأمر (يَدْعُ، لَمْ يَخْشَ).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_6_1',
                evidenceKey: 'shadha_arf:bab_ilal',
                citation: 'شذا العرف في فن الصرف (باب الإعلال والإبدال)',
                sourceId: 'src_shadha_al_arf',
              ),
            ],
            sourceAttribution: 'سر صناعة الإعراب والمنصف لابن جني وشرح الشافية للرضي',
          ),
          LessonSection.create(
            sectionId: 'sec_sarf_6_2',
            title: 'الإبدال القرآني في صيغة الافتعال والتجاور الصوتي الإعجازي',
            contentType: LearningContentType.explanation,
            content: 'الإبدال هو جعل حرف مكان حرف آخر مطلقا، وأشهره في تاء الافتعال لموافقة مخارج الحروف: فإذا كانت فاء الفعل من حروف الإطباق (ص، ض، ط، ظ) أبدلت تاء الافتعال طاءً لتناسب التفخيم كقوله تعالى: ﴿وَاصْطَبِرْ لِعِبَادَتِهِ﴾ أصلها (اصْتَبِرْ)، و﴿مَنِ اضْطُرَّ﴾ أصلها (اضْتُرَّ)؛ وإذا كانت الفاء (د، ذ، ز) أبدلت التاء دالاً كقوله ﴿فَهَلْ مِن مُّدَّكِرٍ﴾ أصلها (مُذْتَكِر) أبدلت التاء دالاً ثم أدغمت الذال في الدال لتجانس النغم الصوتي الفخم المناسب للموعظة والذكر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_sarf_6_2',
                evidenceKey: 'quran:54:15',
                citation: 'سورة القمر: الآية 15 (فَهَلْ مِن مُّدَّكِرٍ)',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'سر صناعة الإعراب لابن جني وإعجاز القرآن للباقلاني',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_sarf_mizan_awzan_ziyadah',
        lessonId: 'lsn_sarf_quranic_ziyadah_nuances',
        title: 'اختبار تقييم استيعاب: الميزان الصرفي وأوزان الأفعال ودلالات الزيادة',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_sarf_1',
            lessonId: 'lsn_sarf_quranic_ziyadah_nuances',
            questionText: 'ما السر البلاغي والصرفي في استعمال (نَزَّلَ) في شأن القرآن و(أَنْزَلَ) في شأن الكتب السابقة؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qsf1_1', text: 'صيغة (نَزَّلَ) بالتضعيف تدل على النزول المنجم مفرقاً بحسب الحوادث بينما (أَنْزَلَ) تدل على النزول جملة واحدة'),
              QuizOption(optionId: 'opt_qsf1_2', text: 'صيغة (أَنْزَلَ) تدل على التكرار بينما (نَزَّلَ) تدل على النزول مرة واحدة'),
              QuizOption(optionId: 'opt_qsf1_3', text: 'لا يوجد أي فرق بين الصيغتين في المعنى اللغوي'),
              QuizOption(optionId: 'opt_qsf1_4', text: 'صيغة (نَزَّلَ) خاصة بالأمطار وصيغة (أَنْزَلَ) خاصة بالكتب'),
            ],
            correctOptionIndices: const [0],
            explanation: 'التضعيف في (نَزَّلَ) يفيد التكثير والتفريق الزماني ليعكس نزول القرآن منجماً في 23 عاماً، بينما الإنزال للنزول الجملي كالتوراة والإنجيل.',
          ),
          QuizQuestion.create(
            questionId: 'q_sarf_2',
            lessonId: 'lsn_sarf_quranic_ziyadah_nuances',
            questionText: 'لماذا خفف الفعل فقال ﴿فَمَا اسْطَاعُوا أَن يَظْهَرُوهُ﴾ وثقل فقال ﴿وَمَا اسْتَطَاعُوا لَهُ نَقْباً﴾ في سورة الكهف؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qsf2_1', text: 'لأن صعود السد أخف وأسهل جهداً من إحداث النقب الشاق في سد الحديد والنحاس فطابق خفة اللفظ خفة المعنى'),
              QuizOption(optionId: 'opt_qsf2_2', text: 'مجرد اختلاف في القافية الفاصلة دون ارتباط بالمعنى والجهد'),
              QuizOption(optionId: 'opt_qsf2_3', text: 'لأن نقب السد كان أسهل من تسلقه'),
              QuizOption(optionId: 'opt_qsf2_4', text: 'لأن يأجوج ومأجوج لم يحاولوا صعود السد أصلاً'),
            ],
            correctOptionIndices: const [0],
            explanation: 'حذف التاء تخفيفاً لمطابقة خفة العمل في التسلق مقارنة بالنقب الشديد المضني الذي تطلب صيغة تامة الحروف (استطاعوا).',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_sarf_mushtaqqat_ilal_ibdal',
        lessonId: 'lsn_sarf_ilal_ibdal_aesthetic_balance',
        title: 'اختبار تقييم استيعاب: المشتقات وأثرها التشريعي وقواعد الإعلال والإبدال',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_sarf_3',
            lessonId: 'lsn_sarf_ilal_ibdal_aesthetic_balance',
            questionText: 'ماذا يقتضي وزن (فِعْلَة) بالكسر في الحديث النبوي: «فإذا ذبحتم فأحسنوا الذِّبْحَةَ»؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qsf3_1', text: 'اسم هيئة يدل على طلب تحسين الكيفية والهيئة الرحيمة في إزهاق الروح'),
              QuizOption(optionId: 'opt_qsf3_2', text: 'اسم مرة يدل على ذبح الشاة مرة واحدة فقط'),
              QuizOption(optionId: 'opt_qsf3_3', text: 'اسم آلة يدل على نوع السكين المستخدمة'),
              QuizOption(optionId: 'opt_qsf3_4', text: 'اسم مكان يدل على وجوب الذبح في المسلخ'),
            ],
            correctOptionIndices: const [0],
            explanation: 'وزن (فِعْلَة) بالكسر صيغة اسم الهيئة الدالة على صفة وهيئة الفعل؛ أي اختاروا أحسن الهيئات وأرحمها بالحيوان.',
          ),
          QuizQuestion.create(
            questionId: 'q_sarf_4',
            lessonId: 'lsn_sarf_ilal_ibdal_aesthetic_balance',
            questionText: 'ما الأصل الصرفي لكلمة ﴿مُدَّكِرٍ﴾ في سورة القمر وما سبب الإبدال الحاصل فيها؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qsf4_1', text: 'أصلها (مُذْتَكِر) فأبدلت التاء دالاً لمجاورتها الذال ثم أدغمت لتجانس النطق وسهولة الأداء'),
              QuizOption(optionId: 'opt_qsf4_2', text: 'أصلها (مُتَدَكِّر) وحذفت التاء الأولى للجازم'),
              QuizOption(optionId: 'opt_qsf4_3', text: 'اسم جامد ثلاثي غير مشتق لا إعلال فيه ولا إبدال'),
              QuizOption(optionId: 'opt_qsf4_4', text: 'أصلها (مُفْتَعَل) من مادة دَكَرَ الثلاثية'),
            ],
            correctOptionIndices: const [0],
            explanation: 'أصلها اسم فاعل (مُذْتَكِر) من الذِّكْر على وزن مُفْتَعِل، أبدلت تاء الافتعال دالاً وأدغمت الذال في الدال لتجانس الصوت وفخامته.',
          ),
        ],
      ),
    ];
  }
}
