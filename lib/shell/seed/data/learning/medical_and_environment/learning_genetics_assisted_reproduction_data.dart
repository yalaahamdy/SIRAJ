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

/// بيانات مقرر الهندسة الوراثية والإنجاب المساعد والأخلاقيات الحيوية (6 دروس تأصيلية + اختباران استيعاب)
class LearningGeneticsAssistedReproductionData {
  static const String courseId = 'course_genetics_assisted_reproduction';
  static const String pathId = 'path_medical_bioethics_environment_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر الهندسة الوراثية والإنجاب المساعد والأخلاقيات الحيوية',
      description: 'دراسة تأصيلية فقهية لأحكام التلقيح الصناعي وأطفال الأنابيب، استئجار الأرحام وبنوك النطف، الفحص الوراثي قبل الزواج وإجهاض الجنين المشوه، الهندسة الوراثية وتعديل الجينوم البشري، الاستنساخ، واستخدام الخلايا الجذعية.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_assisted_reproduction_genetics', 'mod_genetic_engineering_cloning'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_assisted_reproduction_genetics',
        courseId: courseId,
        title: 'الوحدة الأولى: فقه الإنجاب المساعد، تأجير الأرحام، والفحص الوراثي',
        description: 'ضوابط التلقيح الصناعي وأطفال الأنابيب، حفظ الأنساب، تحريم تأجير الأرحام وبنوك النطاف، والفحص الجيني قبل الزواج وأحكام إجهاض الأجنة المشوهة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_assisted_reproduction_ivf_insemination',
          'lsn_assisted_surrogacy_gamete_banks',
          'lsn_genetics_premarital_pgd_abortion',
        ],
      ),
      CourseModule(
        moduleId: 'mod_genetic_engineering_cloning',
        courseId: courseId,
        title: 'الوحدة الثانية: الهندسة الوراثية، الاستنساخ، وأبحاث الخلايا الجذعية',
        description: 'الرؤية الشرعية لتعديل الجينوم البشري والعلاج الجيني، تحريم الاستنساخ البشري ورخص الاستنساخ الحيواني، والمصادر المباحة للخلايا الجذعية والطب التجديدي.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_assisted_reproduction_genetics'],
        lessonIds: const [
          'lsn_genetics_human_genome_modifications',
          'lsn_genetics_cloning_therapeutic_reproductive',
          'lsn_genetics_stem_cells_regenerative_medicine',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 7
      Lesson.create(
        lessonId: 'lsn_assisted_reproduction_ivf_insemination',
        title: 'وسائل الإنجاب المساعد وأطفال الأنابيب بين الحل والحرمة',
        courseId: courseId,
        moduleId: 'mod_assisted_reproduction_genetics',
        orderIndex: 1,
        sources: const ['src_majma_fiqhi_resolutions', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_gen_1_1',
            title: 'الصور المشروعة للإنجاب المساعد',
            description: 'معرفة الصور المشروعة للإنجاب المساعد والصور المحرمة التي يدخل فيها طرف ثالث.',
          ),
          LearningObjective(
            objectiveId: 'obj_gen_1_2',
            title: 'شروط حفظ الأنساب بالمختبرات',
            description: 'إدراك شروط السلامة والاحتياط المشدد لمنع اختلاط النطاف في المختبرات الطبية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_gen_1_1',
            title: 'الصور المشروعة للتلقيح الصناعي وأطفال الأنابيب',
            contentType: LearningContentType.sourceText,
            content: 'أجاز مجمع الفقه الإسلامي الدولي (القرار رقم 16) التلقيح الاصطناعي الخارجي (أطفال الأنابيب IVF) والتلقيح الداخلي بين الزوجين حصراً عند تعذر الحمل الطبيعي، بشرطين جوهريين: 1) أن يتم التلقيح بين نطفة الزوج وبويضة زوجته وهما في عصمة نكاح شرعي صحيح وقائم. 2) أن يتم زرع البويضة الملقحة في رحم الزوجة صاحبة البويضة ذاتها. ويشترط استنفاد الاحتياطات الطبية القصوى لتفادي أي خطأ أو خلط في العينات المختبرية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_1_1',
                evidenceKey: 'majma:res:16',
                citation: 'قرار مجمع الفقه الإسلامي الدولي رقم 16 (4/3) بشأن أطفال الأنابيب',
                sourceId: 'src_majma_fiqhi_resolutions',
              ),
            ],
            sourceAttribution: 'مجلة مجمع الفقه الإسلامي الدولي الدورة الثالثة',
          ),
          LessonSection.create(
            sectionId: 'sec_gen_1_2',
            title: 'الصور المحرمة لمشاركة طرف ثالث واختلاط الأنساب',
            contentType: LearningContentType.explanation,
            content: 'أجمع العلماء والمجامع الفقهية على تحريم أي صورة يدخل فيها طرف ثالث غير الزوجين في العملية التناسلية؛ كاستخدام نطفة رجل أجنبي متبرع، أو استخدام بويضة امرأة أجنبية متبرعة، أو زرع اللقيحة بعد انفصام عقد النكاح بالوفاة أو الطلاق البائن. وذلك حفظاً لمقصد الشريعة القطعي في حفظ النسب والعرض، ولحديث النبي ﷺ: «لَا يَحِلُّ لِامْرِئٍ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ أَنْ يَسْقِيَ مَاءَهُ زَرْعَ غَيْرِهِ».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_1_2',
                evidenceKey: 'abu_dawud:2158',
                citation: 'حديث رويفع بن ثابت: «لَا يَحِلُّ لِامْرِئٍ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ أَنْ يَسْقِيَ مَاءَهُ زَرْعَ غَيْرِهِ» (رواه أبو داود والترمذي وحسنه)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'سنن أبي داود وقرارات المجمع الفقهي الإسلامي بمكة المكرمة',
          ),
        ],
      ),

      // Lesson 8
      Lesson.create(
        lessonId: 'lsn_assisted_surrogacy_gamete_banks',
        title: 'أحكام استئجار الأرحام وبنوك النطف والبويضات',
        courseId: courseId,
        moduleId: 'mod_assisted_reproduction_genetics',
        orderIndex: 2,
        sources: const ['src_majma_fiqhi_resolutions', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_gen_2_1',
            title: 'أدلة تحريم استئجار الأرحام',
            description: 'استيعاب أدلة تحريم استئجار الأرحام والنزاع القانوني والفقهي في تحديد الأم الحقيقية.',
          ),
          LearningObjective(
            objectiveId: 'obj_gen_2_2',
            title: 'بطلان بنوك النطف والبويضات',
            description: 'بيان بطلان بنوك النطف والبويضات المجمدة وتجريم تداولها والتسويق لها.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_gen_2_1',
            title: 'تحريم استئجار الأرحام (الأم البديلة)',
            contentType: LearningContentType.sourceText,
            content: 'قررت المجامع الفقهية بالإجماع تحريم استئجار الأرحام (Surrogacy) بجميع صوره؛ سواء كانت الأم الحاضنة للرحم امرأة أجنبية متطوعة أو بأجر، أو كانت زوجة أخرى للرجل نفسه. ويرجع التحريم إلى: 1) مجهولية الأمومة الحقيقية والتنازع بين صاحبة البويضة الوراثية وصاحبة الرحم والولادة: ﴿إِنْ أُمَّهَاتُهُمْ إِلَّا اللَّائِي وَلَدْنَهُمْ﴾. 2) تعريض كرامة المرأة لأن تكون وعاءً تجارياً للإيجار. 3) ضياع حقوق المولود وإثارة النزاعات النفسية والوراثية العويصة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_2_1',
                evidenceKey: '58:2',
                citation: 'قوله تعالى: ﴿إِنْ أُمَّهَاتُهُمْ إِلَّا اللَّائِي وَلَدْنَهُمْ﴾ [المجادلة: 2]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرارات المجمع الفقهي لرابطة العالم الإسلامي ومجمع الفقه الدولي',
          ),
          LessonSection.create(
            sectionId: 'sec_gen_2_2',
            title: 'بنوك النطف والبويضات المجمدة',
            contentType: LearningContentType.explanation,
            content: 'يحرم شرعاً إنشاء ما يسمى «بنوك النطف» و«بنوك البويضات» المخصصة لبيع النطاف أو وهبها لغير الأزواج، لما فيها من اختلاط الأنساب وإشاعة الفواحش المقننة. أما تجميد بويضات الزوجة أو نطف الزوج لحاجتهما الذاتية المستقبلية (كالعلاج الكيماوي لمرض السرطان)، فيجوز بضوابط بالغة التوثيق؛ شريطة ألا تستخدم إلا بينهما حال قيام الزوجية الحية فقط، وتتلف العينات حتماً بمجرد وفاة أحدهما أو وقوع الطلاق.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_2_2',
                evidenceKey: 'qawaid:sadd_dharai',
                citation: 'القاعدة الفقهية: «سد الذرائع المفضية إلى الفساد واختلاط الأنساب واجب»',
                sourceId: 'src_majma_fiqhi',
              ),
            ],
            sourceAttribution: 'الفتاوى الكبرى لابن تيمية وقرارات مجمع الفقه الإسلامي بجدة',
          ),
        ],
      ),

      // Lesson 9
      Lesson.create(
        lessonId: 'lsn_genetics_premarital_pgd_abortion',
        title: 'الفحص الوراثي قبل الزواج وإجهاض الجنين المشوه',
        courseId: courseId,
        moduleId: 'mod_assisted_reproduction_genetics',
        orderIndex: 3,
        sources: const ['src_majma_fiqhi_resolutions', 'src_hayat_kibar_ulama'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_gen_3_1',
            title: 'الفحص الجيني قبل الزواج',
            description: 'معرفة الموقف الشرعي من إلزامية الفحص الطبي الوراثي قبل عقد النكاح للمصلحة العامة.',
          ),
          LearningObjective(
            objectiveId: 'obj_gen_3_2',
            title: 'إجهاض الجنين المشوه',
            description: 'إدراك شروط وضوابط جواز إجهاض الجنين المشوه تشويهاً جسيماً قبل نفخ الروح وبعده.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_gen_3_1',
            title: 'الفحص الجيني قبل الزواج والمصلحة المرسلة',
            contentType: LearningContentType.sourceText,
            content: 'الفحص الطبي الوراثي قبل الزواج للكشف عن الأمراض الوراثية المتناقلة (كالثلاسيميا وفقر الدم المنجلي) مشروع ومندوب، بل يجوز لولي الأمر إلزامه نظامياً بمقتضى السياسة الشرعية للمصلحة المرسلة ودفع الضرر عن النسل. غير أن نتائج الفحص ذات طابع إرشادي استشاري ولا يملك الطبيب منع عقد النكاح جبراً إذا أصر الطرفان مع علمهما بالمخاطر، إلا إذا تضمن المرض عيباً موجباً لفسخ النكاح شرعاً.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_3_1',
                evidenceKey: 'bukhari:5771',
                citation: 'حديث النبي ﷺ: «لَا تُورِدُوا المُمْرِضَ عَلَى المُصِحِّ» (متفق عليه)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وقرار مجمع الفقه الإسلامي الدولي رقم 134',
          ),
          LessonSection.create(
            sectionId: 'sec_gen_3_2',
            title: 'أحكام إجهاض الجنين المصاب بتشوهات جينية خطيرة',
            contentType: LearningContentType.explanation,
            content: 'الأصل حرمة الإجهاض في جميع مراحل الحمل. واستثنى مجمع الفقه وهيئة كبار العلماء حالة واحدة لجواز إسقاط الجنين المصاب بتشوهات خلقية جسيمة: 1) أن يثبت بتقرير لجنة طبية عدول من ذوي الاختصاص أن التشوه خطير جداً وغير قابل للعلاج ويجعل حياة الجنين عذاباً عليه وعلى أهله. 2) أن يتم الإجهاض قبل مرور مائة وعشرين يوماً على الحمل (قبل نفخ الروح). 3) بطلب ورضا الزوجين. أما بعد نفخ الروح (120 يوماً)، فيحرم الإجهاض قطعاً إلا إذا كانت استمرارية الحمل خطراً محققاً على حياة الأم تطبيقاً لتقديم الأصل على الفرع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_3_2',
                evidenceKey: 'kibar_ulama:res:140',
                citation: 'قرار هيئة كبار العلماء بالمملكة رقم 140 وقرار مجمع الفقه الإسلامي الدولي رقم 58',
                sourceId: 'src_hayat_kibar_ulama',
              ),
            ],
            sourceAttribution: 'أبحاث هيئة كبار العلماء بالمملكة ومجلة المجمع الفقهي',
          ),
        ],
      ),

      // Lesson 10
      Lesson.create(
        lessonId: 'lsn_genetics_human_genome_modifications',
        title: 'الهندسة الوراثية وتعديل الجينوم البشري',
        courseId: courseId,
        moduleId: 'mod_genetic_engineering_cloning',
        orderIndex: 4,
        sources: const ['src_majma_fiqhi_resolutions', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_gen_4_1',
            title: 'العلاج الجيني الجسدي',
            description: 'التمييز بين العلاج الجيني في الخلايا الجسدية وبين تعديل الخلايا التناسلية الناقلة للوراثة.',
          ),
          LearningObjective(
            objectiveId: 'obj_gen_4_2',
            title: 'محاذير تحسين النسل الاصطناعي',
            description: 'إدراك المحاذير الشرعية من تقنيات تحسين النسل وانتقاء الصفات الشكلية (Eugenics).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_gen_4_1',
            title: 'مشروعية العلاج الجيني في الخلايا الجسدية',
            contentType: LearningContentType.sourceText,
            content: 'يجوز استخدام تقنيات الهندسة الوراثية (العلاج الجيني Gene Therapy) في الخلايا الجسدية لعلاج الأمراض المستعصية والعيوب الوراثية كالسرطانات والضمور العضلي، لأن هذا من باب التداوي المأمور به شرعاً وإصلاح ما اعترى البدن من خلل. وقررت المجامع جواز هذه التقنية ما دامت مقصورة على المريض نفسه ولا تتعدى إلى ذريته ولا تعبث بالخريطة الوراثية الإنسانية الأصيلة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_4_1',
                evidenceKey: '82:7',
                citation: 'قوله تعالى: ﴿الَّذِي خَلَقَكَ فَسَوَّاكَ فَعَدَلَكَ﴾ [الانفطار: 7] والاستدلال على حفظ الفطرة السوية',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرار مجمع الفقه الإسلامي الدولي رقم 124 بشأن الهندسة الوراثية',
          ),
          LessonSection.create(
            sectionId: 'sec_gen_4_2',
            title: 'تحريم تعديل الخلايا التناسلية وتحسين السلالات الاصطناعي',
            contentType: LearningContentType.explanation,
            content: 'يحرم شرعاً التدخل في الجينات الوراثية للخلايا التناسلية (النطاف والبويضات) أو الأجنة المبكرة في مرحلة التلقيح بهدف توريث تعديلات جيلية، أو بغرض التحكم في الصفات غير المرضية (كلون العينين، الطول، الذكاء، وتحديد الملامح) لما ينطوي عليه من استعلاء وتغيير لخلق الله، والولوج في باب «تحسين النسل الانتقائي» (Eugenics) الذي يهدد التنوع الفطري البشري ويفتح أبواب التمييز العنصري البيولوجي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_4_2',
                evidenceKey: '30:30',
                citation: 'قوله تعالى: ﴿فِطْرَتَ اللَّهِ الَّتِي فَطَرَ النَّاسَ عَلَيْهَا لَا تَبْدِيلَ لِخَلْقِ اللَّهِ﴾ [الروم: 30]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'وثيقة المنظمة الإسلامية للعلوم الطبية حول الأخلاقيات الحيوية والجينوم',
          ),
        ],
      ),

      // Lesson 11
      Lesson.create(
        lessonId: 'lsn_genetics_cloning_therapeutic_reproductive',
        title: 'الاستنساخ البشري والحيواني في ميزان الشريعة',
        courseId: courseId,
        moduleId: 'mod_genetic_engineering_cloning',
        orderIndex: 5,
        sources: const ['src_majma_fiqhi_resolutions', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_gen_5_1',
            title: 'تحريم الاستنساخ البشري',
            description: 'معرفة الأدلة الشرعية القاطعة لتحريم الاستنساخ البشري التكاثري ومخاطره الكارثية.',
          ),
          LearningObjective(
            objectiveId: 'obj_gen_5_2',
            title: 'ضوابط الاستنساخ الحيواني والنباتي',
            description: 'بيان ضوابط الاستنساخ الحيواني والنباتي واستخداماته في تحسين الموارد الزراعية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_gen_5_1',
            title: 'التحريم القطعي للاستنساخ البشري التكاثري',
            contentType: LearningContentType.sourceText,
            content: 'أجمع مجمع الفقه الإسلامي الدولي ومجمع البحوث الإسلامية وسائر الهيئات الشرعية على التحريم القاطع لـ «الاستنساخ البشري التكاثري» (Cloning). وتستند الحرمة إلى بطلان مؤسسة الزواج والأسرة بموجبه، وضياع الأنساب والأمومة والأبوة، ومصادمة سنة الله الكونية في خلق الإنسان من زوجين ذكر وأنثى: ﴿وَأَنَّهُ خَلَقَ الزَّوْجَيْنِ الذَّكَرَ وَالْأُنثَىٰ * مِن نُّطْفَةٍ إِذَا تُمْنَىٰ﴾، علاوة على إفضائه إلى اضطرابات صحية ونفسية وتشوهات مهلكة للمستنسخين.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_5_1',
                evidenceKey: '49:13',
                citation: 'قوله تعالى: ﴿يَا أَيُّهَا النَّاسُ إِنَّا خَلَقْنَاكُم مِّن ذَكَرٍ وَأُنثَىٰ﴾ [الحجرات: 13]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرار مجمع الفقه الإسلامي الدولي رقم 100 (3/10) بشأن الاستنساخ البشري',
          ),
          LessonSection.create(
            sectionId: 'sec_gen_5_2',
            title: 'الاستنساخ في الحيوان والنبات واستخداماته المشروعة',
            contentType: LearningContentType.explanation,
            content: 'يجوز الاستنساخ في الحيوان والنبات للأغراض الاقتصادية والإنتاجية المشروعة (كزيادة إنتاج اللحوم والألبان ومقاومة الآفات الزراعية)، بشرطين: 1) تحقق المصلحة الراجحة الحقيقية. 2) انتفاء الإضرار بالحيوان بتعذيبه أو تشويهه وانتفاء الإضرار بالبيئة وصحة الإنسان من جراء استهلاك منتجاته المعدلة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_5_2',
                evidenceKey: 'qawaid:ibahah_manafi',
                citation: 'القاعدة الفقهية: «الأصل في المنافع الإباحة ما لم يثبت ضرر أو نهي خاص»',
                sourceId: 'src_majma_fiqhi',
              ),
            ],
            sourceAttribution: 'المعايير الشرعية للمنظمة الإسلامية للعلوم الطبية',
          ),
        ],
      ),

      // Lesson 12
      Lesson.create(
        lessonId: 'lsn_genetics_stem_cells_regenerative_medicine',
        title: 'الخلايا الجذعية وأبحاث الطب التجديدي',
        courseId: courseId,
        moduleId: 'mod_genetic_engineering_cloning',
        orderIndex: 6,
        sources: const ['src_majma_fiqhi_resolutions', 'src_contemporary_bioethics'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_gen_6_1',
            title: 'أقسام الخلايا الجذعية ومصادرها',
            description: 'معرفة أقسام الخلايا الجذعية (البالغة، المشيمية، الجنينية) ومصادرها الطبية.',
          ),
          LearningObjective(
            objectiveId: 'obj_gen_6_2',
            title: 'شروط استخدام الأجنة الفائضة',
            description: 'استيعاب الشروط الفقهية المشددة لاستخدام الأجنة الفائضة في استخلاص الخلايا الجذعية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_gen_6_1',
            title: 'المصادر المباحة بيقين للخلايا الجذعية',
            contentType: LearningContentType.sourceText,
            content: 'يجوز بالإجماع الحصول على الخلايا الجذعية واستخدامها في العلاج والأبحاث من المصادر الآتية: 1) الشخص البالغ برضاه إذا لم يتضرر، كأخذها من نخاع العظم أو الدم أو الدهون. 2) المشيمة والحبل السري للأطفال بعد الولادة الطبيعية بإذن الوالدين. 3) الأجنة المجهضة إجهاضاً تلقائياً طبيعياً أو إجهاضاً علاجياً مأذوناً به شرعاً، على ألا يكون الإجهاض قد جرى عمداً لغرض الحصول على الخلايا.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_6_1',
                evidenceKey: 'majma:res:123',
                citation: 'قرار مجمع الفقه الإسلامي الدولي رقم 123 (17/3) بشأن استخدام الخلايا الجذعية في العلاج والبحث',
                sourceId: 'src_majma_fiqhi_resolutions',
              ),
            ],
            sourceAttribution: 'مجلة مجمع الفقه الإسلامي الدولي الدورة السابعة عشرة',
          ),
          LessonSection.create(
            sectionId: 'sec_gen_6_2',
            title: 'أحكام الأجنة الفائضة وتخليق الأجنة للأبحاث',
            contentType: LearningContentType.explanation,
            content: 'يحرم قطعاً تخليق أجنة بشرية في المختبر عمداً لغرض استخلاص الخلايا الجذعية منها وإتلافها بعد ذلك، لأن الجنين البشري محترم في جميع أطواره. أما الأجنة الفائضة الناتجة عن عمليات أطفال الأنابيب المشروعة التي تعذر زرعها في رحم الأم وتؤول حتماً إلى التلف الطبيعي بانتهاء فترة حفظها، فقد أجاز بعض المجامع الاستفادة من خلاياها الجذعية لأغراض علاجية وبحثية دقيقة لإنقاذ حياة مرضى آخرين، شريطة عدم تداولها تجارياً والحصول على إذن الوالدين الكامل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_gen_6_2',
                evidenceKey: 'qawaid:akhf_dararayn',
                citation: 'القاعدة الفقهية: «تحصيل أعلى المصلحتين بارتكاب أخفهما» عند تعين تلف الأجنة الفائضة حتماً',
                sourceId: 'src_majma_fiqhi',
              ),
            ],
            sourceAttribution: 'أبحاث ندوة الاستنساخ والعلاج الجيني بالدار البيضاء',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: فقه الإنجاب المساعد وتأجير الأرحام
    final q1 = QuizQuestion.create(
      questionId: 'q_gen_1',
      lessonId: 'lsn_assisted_reproduction_ivf_insemination',
      questionText: 'ما هو الشرط الجوهري لجواز إجراء عملية أطفال الأنابيب (التلقيح الاصطناعي الخارجي) وفق قرارات المجامع الفقهية؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qg1_1', text: 'أن تتم بنطفة الزوج وبويضة الزوجة أثناء قيام الزوجية الشرعية وزرعها في رحم الزوجة نفسها'),
        QuizOption(optionId: 'opt_qg1_2', text: 'أن يتم استعارة نطفة من متبرع مجهول لزيادة نسبة نجاح الحمل'),
        QuizOption(optionId: 'opt_qg1_3', text: 'أن يتم زرع النطفة في رحم أم بديلة متطوعة دون أجر'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يشترط قيام رابطة الزوجية بين صاحبي النطفة والبويضة حصراً وزرع اللقيحة في رحم الزوجة نفسها حفظاً للأنساب من الاختلاط.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_assisted_reproduction_genetics',
      lessonId: 'lsn_assisted_reproduction_ivf_insemination',
      title: 'اختبار تقييم استيعاب فقه الإنجاب المساعد وتأجير الأرحام والفحص الوراثي',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: الهندسة الوراثية والاستنساخ
    final q2 = QuizQuestion.create(
      questionId: 'q_gen_2',
      lessonId: 'lsn_genetics_human_genome_modifications',
      questionText: 'ما هو الحكم الفقهي للعلاج الجيني في الخلايا الجسدية للمريض لعلاج الأمراض المستعصية كالسرطان؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qg2_1', text: 'جائز ومشروع لأنه نوع من التداوي وإصلاح الخلل العارض في البدن'),
        QuizOption(optionId: 'opt_qg2_2', text: 'محرم لأنه تدخّل غير مشروع في خلق الله تعالى'),
        QuizOption(optionId: 'opt_qg2_3', text: 'مكروه إلا إذا أوشك المريض على الموت المحقق'),
      ],
      correctOptionIndices: const [0],
      explanation: 'العلاج الجيني الجسدي مشروع لأنه من باب التداوي المشروع لإزالة المرض والعلة العارضة دون المساس بالجينات التناسلية المنقولة.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_genetic_engineering_cloning',
      lessonId: 'lsn_genetics_human_genome_modifications',
      title: 'اختبار تقييم استيعاب فقه الهندسة الوراثية والاستنساخ والخلايا الجذعية',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
