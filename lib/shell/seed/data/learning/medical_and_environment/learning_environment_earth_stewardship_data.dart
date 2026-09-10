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

/// بيانات مقرر فقه البيئة وعمارة الأرض وحماية الموارد الطبيعية (6 دروس تأصيلية + اختباران استيعاب)
class LearningEnvironmentEarthStewardshipData {
  static const String courseId = 'course_environment_earth_stewardship';
  static const String pathId = 'path_medical_bioethics_environment_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه البيئة وعمارة الأرض وحماية الموارد الطبيعية',
      description: 'دراسة تأصيلية فقهية للرؤية الإسلامية للكون والاستخلاف وعمارة الأرض، فقه الموارد المائية وترشيد الاستهلاك، إحياء الموات والتشجير ونظام الحِمى والمحميات، التوازن الكوني والمسؤولية الأخلاقية تجاه المناخ، منظومة الرفق بالحيوان، ومكافحة التلوث وتدوير الموارد.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_environment_earth_stewardship', 'mod_animal_welfare_climate_balance'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_environment_earth_stewardship',
        courseId: courseId,
        title: 'الوحدة الأولى: الاستخلاف البيئي، ترشيد المياه، والتشجير والحِمى',
        description: 'الرؤية التوحيدية للكون، أمانة الاستخلاف، حرمة الإفساد البيئي، الحفاظ على الثروة المائية، فضل الغرس والتشجير، وإحياء الموات والمحميات الطبيعية.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_environment_stewardship_creation_purpose',
          'lsn_environment_water_conservation_purity',
          'lsn_environment_afforestation_land_revival',
        ],
      ),
      CourseModule(
        moduleId: 'mod_animal_welfare_climate_balance',
        courseId: courseId,
        title: 'الوحدة الثانية: التوازن المناخي، الرفق بالحيوان، ومكافحة التلوث',
        description: 'الميزان الكوني والتغير المناخي، منظومة حقوق الحيوان والرفق بالكائنات، وإماطة الأذى ومكافحة التلوث الصناعي وتدوير النفايات.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_environment_earth_stewardship'],
        lessonIds: const [
          'lsn_environment_climate_cosmic_balance',
          'lsn_environment_animal_welfare_compassion',
          'lsn_environment_waste_pollution_harm_removal',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 19
      Lesson.create(
        lessonId: 'lsn_environment_stewardship_creation_purpose',
        title: 'الرؤية الإسلامية للكون والاستخلاف وعمارة الأرض',
        courseId: courseId,
        moduleId: 'mod_environment_earth_stewardship',
        orderIndex: 1,
        sources: const ['src_quran_canonical', 'src_tafsir_tabari', 'src_maqasid_shariah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_env_1_1',
            title: 'الرؤية التوحيدية للكون',
            description: 'إدراك الرؤية التوحيدية للكون باعتباره آية دالة على الخالق سبحانه ومسخراً بالحق.',
          ),
          LearningObjective(
            objectiveId: 'obj_env_1_2',
            title: 'الاستخلاف وعمارة الأرض',
            description: 'تأصيل مفهوم الاستخلاف وعمارة الأرض وحرمة الإفساد البيئي والاعتداء على الموارد.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_env_1_1',
            title: 'الكون مسخر وأمانة الاستخلاف',
            contentType: LearningContentType.sourceText,
            content: 'تنطلق الرؤية الإسلامية للبيئة من عقيدة التوحيد؛ فالكون كله ملك لله تعالى وخلقه المتقن: ﴿وَلِلَّهِ مُلْكُ السَّمَاوَاتِ وَالْأَرْضِ﴾، وهو مسخر للإنسان تسخير انتفاع وتكريم لا تسخير استعلاء وتدمير. وقد جعل الله الإنسان خليفة في الأرض مؤتمناً على مواردها: ﴿هُوَ أَنشَأَكُم مِّنَ الْأَرْضِ وَاسْتَعْمَرَكُمْ فِيهَا﴾، أي طلب منكم عمارتها وإصلاحها وحمايتها من التلف والخراب.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_1_1',
                evidenceKey: '11:61',
                citation: 'قوله تعالى: ﴿هُوَ أَنشَأَكُم مِّنَ الْأَرْضِ وَاسْتَعْمَرَكُمْ فِيهَا فَاسْتَغْفِرُوهُ ثُمَّ تُوبُوا إِلَيْهِ﴾ [هود: 61]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير ابن كثير ومقاصد الشريعة الإسلامية لابن عاشور',
          ),
          LessonSection.create(
            sectionId: 'sec_env_1_2',
            title: 'حرمة الإفساد في الأرض بعد إصلاحها',
            contentType: LearningContentType.explanation,
            content: 'نهت الشريعة نهياً جازماً عن أي سلوك يفضي إلى تلويث البيئة وتدمير عناصر الحياة، وقررت أن الإفساد البيئي جريمة شرعية تدخل في عموم قوله تعالى: ﴿وَلَا تُفْسِدُوا فِي الْأَرْضِ بَعْدَ إِصْلَاحِهَا﴾، وقوله: ﴿وَإِذَا تَوَلَّىٰ سَعَىٰ فِي الْأَرْضِ لِيُفْسِدَ فِيهَا وَيُهْلِكَ الْحَرْثَ وَالنَّسْلَ وَاللَّهُ لَا يُحِبُّ الْفَسَادَ﴾. فالإضرار بالهواء والتربة والغطاء النباتي والبحار عدوان على حق الأجيال الحاضرة والقادمة في بيئة سوية نقية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_1_2',
                evidenceKey: '2:205',
                citation: 'قوله تعالى: ﴿وَإِذَا تَوَلَّىٰ سَعَىٰ فِي الْأَرْضِ لِيُفْسِدَ فِيهَا وَيُهْلِكَ الْحَرْثَ وَالنَّسْلَ وَاللَّهُ لَا يُحِبُّ الْفَسَادَ﴾ [البقرة: 205]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الجامع لأحكام القرآن للقرطبي وتفسير الطبري',
          ),
        ],
      ),

      // Lesson 20
      Lesson.create(
        lessonId: 'lsn_environment_water_conservation_purity',
        title: 'فقه الموارد المائية وترشيد الاستهلاك وصيانة المياه',
        courseId: courseId,
        moduleId: 'mod_environment_earth_stewardship',
        orderIndex: 2,
        sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_fiqh_sunnah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_env_2_1',
            title: 'شراكة البشر في الماء',
            description: 'معرفة مكانة الماء كأصل لكل حياة وعنصر مشترك بين البشر والخلائق.',
          ),
          LearningObjective(
            objectiveId: 'obj_env_2_2',
            title: 'ترشيد الماء وتحريم التلويث',
            description: 'استيعاب أحكام النهي عن الإسراف في الماء والنهي عن تلويث الموارد المائية والآبار.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_env_2_1',
            title: 'مكانة الماء والشراكة الإنسانية في موارده',
            contentType: LearningContentType.sourceText,
            content: 'الماء هو شريان الحياة وأصل تكوين الأحياء: ﴿وَجَعَلْنَا مِنَ الْمَاءِ كُلَّ شَيْءٍ حَيٍّ أَفَلَا يُؤْمِنُونَ﴾، وهو مورد عام للناس جميعاً تشيع فيه الشراكة، لقول النبي ﷺ: «المُسْلِمُونَ شُرَكَاءُ فِي ثَلَاثٍ: فِي المَاءِ، وَالكَلَإِ، وَالنَّارِ». ويحرم شرعاً حجب فضل الماء أو احتكاره لمنع سقي الناس ودوابهم وزروعهم، كما في حديث: «ثَلَاثَةٌ لَا يُكَلِّمُهُمُ اللَّهُ يَوْمَ الْقِيَامَةِ... وَرَجُلٌ مَنَعَ فَضْلَ مَاءٍ».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_2_1',
                evidenceKey: '21:30',
                citation: 'قوله تعالى: ﴿وَجَعَلْنَا مِنَ الْمَاءِ كُلَّ شَيْءٍ حَيٍّ أَفَلَا يُؤْمِنُونَ﴾ [الأنبياء: 30]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وسنن أبي داود',
          ),
          LessonSection.create(
            sectionId: 'sec_env_2_2',
            title: 'ترشيد استهلاك الماء وتحريم تلويثه',
            contentType: LearningContentType.explanation,
            content: 'نهى النبي ﷺ عن الإسراف في استعمال الماء حتى في أشرف العبادات كالوضوء والغسل، وقال لسعد بن أبي وقاص حين رآه يتوضأ: «مَا هَذَا السَّرَفُ؟ فَقَالَ: أَفِي الْوُضُوءِ سَرَفٌ؟ قَالَ: نَعَمْ، وَإِنْ كُنْتَ عَلَى نَهْرٍ جَارٍ». وحرمت الشريعة تلويث مصادر المياه والموارد الطبيعية؛ فنهى النبي ﷺ أن يُبال في الماء الراكد الذي لا يجري ثم يغتسل فيه، ونهى عن قضاء الحاجة في موارد الماء وظلال الأشجار وطرق الناس («اتَّقُوا اللَّعَّانَيْنِ...»).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_2_2',
                evidenceKey: 'ibn_majah:425',
                citation: 'حديث عبد الله بن عمرو في سنن ابن ماجه: «لا تسرف وإن كنت على نهر جار» وحديث مسلم في الماء الراكد',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'سنن ابن ماجه وصحيح مسلم والمستدرك للحاكم',
          ),
        ],
      ),

      // Lesson 21
      Lesson.create(
        lessonId: 'lsn_environment_afforestation_land_revival',
        title: 'إحياء الموات والتشجير والمحميات الطبيعية في الإسلام',
        courseId: courseId,
        moduleId: 'mod_environment_earth_stewardship',
        orderIndex: 3,
        sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_ahkam_sultaniyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_env_3_1',
            title: 'أجر الغرس والتشجير',
            description: 'بيان الأجر العظيم للتشجير والغرس وجعله صدقة جارية إلى يوم القيامة.',
          ),
          LearningObjective(
            objectiveId: 'obj_env_3_2',
            title: 'إحياء الموات ونظام الحِمى',
            description: 'فهم أحكام إحياء الموات وسنة النبي ﷺ وخلفائه في تأسيس «الحِمى» والمحميات الطبيعية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_env_3_1',
            title: 'فضل الغرس والتشجير كعمل صالح ممتد',
            contentType: LearningContentType.sourceText,
            content: 'حث النبي ﷺ على التشجير والغرس حثاً بليغاً، وجعل ما ينتفع به من الشجر والزرع صدقة جارية لصاحبه حياً وميتاً: «مَا مِنْ مُسْلِمٍ يَغْرِسُ غَرْسًا، أَوْ يَزْرَعُ زَرْعًا، فَيَأْكُلُ مِنْهُ طَيْرٌ أَوْ إِنْسَانٌ أَوْ بَهِيمَةٌ، إِلَّا كَانَ لَهُ بِهِ صَدَقَةٌ». وبلغ تأكيد الإسلام على التشجير مداه في قوله ﷺ: «إِنْ قَامَتِ السَّاعَةُ وَبِيَدِ أَحَدِكُمْ فَسِيلَةٌ، فَإِنِ اسْتَطَاعَ أَنْ لَا يَقُومَ حَتَّى يَغْرِسَهَا فَلْيَفْعَلْ»، مما يجسد رسالة الأمل وإعمار الكون حتى آخر رمق من عمر الدنيا.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_3_1',
                evidenceKey: 'bukhari:2320',
                citation: 'حديث أنس بن مالك في الصحيحين وحديث مسند أحمد في غرس الفسيلة عند قيام الساعة (صححه الألباني)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري ومسند الإمام أحمد وسلسلة الأحاديث الصحيحة',
          ),
          LessonSection.create(
            sectionId: 'sec_env_3_2',
            title: 'إحياء الموات ونظام الحِمى والمحميات البيئية',
            contentType: LearningContentType.explanation,
            content: 'شرع الإسلام تملك الأرض الموات بالإحياء لمن عمرها بالحرث وحفر الآبار والزراعة: «مَنْ أَحْيَا أَرْضًا مَيِّتَةً فَهِيَ لَهُ»، تشجيعاً على استصلاح الأراضي البور ومكافحة التصحر. وأرسى النبي ﷺ نظام المحميات الطبيعية المسمى «الحِمى» لحماية الغطاء النباتي والمراعي من الرعي الجائر؛ كحمى النقيع بالمدينة وحمى الربذة في عهد عمر وعثمان، مع حظر قطع أشجار الحرمين وصيد حيواناتهما، ليبقى التوازن البيئي مصوناً بقوة التشريع وسلطة الدولة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_3_2',
                evidenceKey: 'bukhari:2370',
                citation: 'حديث الصعب بن جثامة: «لَا حِمَى إِلَّا لِلَّهِ وَلِرَسُولِهِ» (رواه البخاري) وإعلان حرم المدينة وشجرها',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري والأحكام السلطانية للماوردي',
          ),
        ],
      ),

      // Lesson 22
      Lesson.create(
        lessonId: 'lsn_environment_climate_cosmic_balance',
        title: 'التوازن الكوني والمسؤولية الأخلاقية تجاه المناخ',
        courseId: courseId,
        moduleId: 'mod_animal_welfare_climate_balance',
        orderIndex: 4,
        sources: const ['src_quran_canonical', 'src_tafsir_mufassal'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_env_4_1',
            title: 'الميزان والتقدير الكوني',
            description: 'استيعاب آيات الميزان والتقدير الكوني الدقيق في القرآن الكريم.',
          ),
          LearningObjective(
            objectiveId: 'obj_env_4_2',
            title: 'التفسير القرآني للفساد البيئي',
            description: 'تفسير ظاهرة التغير المناخي والاضطراب البيئي في ضوء آية: ﴿ظَهَرَ الْفَسَادُ فِي الْبَرِّ وَالْبَحْرِ﴾.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_env_4_1',
            title: 'الميزان والتقدير الإلهي المحكم للكون',
            contentType: LearningContentType.sourceText,
            content: 'بنى الله الكون في أدق نظام توازني متناسق لا خلل فيه ولا عشوائية: ﴿وَكُلُّ شَيْءٍ عِندَهُ بِمِقْدَارٍ﴾، وقال جل وعلا: ﴿وَالسَّمَاءَ رَفَعَهَا وَوَضَعَ المِيزَانَ * أَلَّا تَطْغَوْا فِي المِيزَانِ﴾. وهذا الميزان يشمل العدل في المعاملات والتوازن في النظام الكوني والمناخي؛ فنسب الغازات وطبقات الجو ومسارات الرياح وتدفق الأنهار مقدرة بميزان بالغ الإعجاز والكمال، وأي طغيان بشري جشع عليه يحدث خللاً بيئياً جسيماً.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_4_1',
                evidenceKey: '55:7',
                citation: 'قوله تعالى: ﴿إِنَّا كُلَّ شَيْءٍ خَلَقْنَاهُ بِقَدَرٍ﴾ [القمر: 49] وقوله: ﴿وَوَضَعَ المِيزَانَ﴾ [الرحمن: 7]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير التحرير والتنوير لابن عاشور والظلال لسيد قطب',
          ),
          LessonSection.create(
            sectionId: 'sec_env_4_2',
            title: 'التغير المناخي وجناية أيدي الناس في القرآن',
            contentType: LearningContentType.explanation,
            content: 'قدم القرآن الكريم التفسير الأخلاقي الأعمق للاضطرابات البيئية والكوارث المناخية المعاصرة (الاحتباس الحراري، تلوث الغلاف الجوي، انقراض الكائنات، والجفاف) في قوله تعالى: ﴿ظَهَرَ الْفَسَادُ فِي الْبَرِّ وَالْبَحْرِ بِمَا كَسَبَتْ أَيْدِي النَّاسِ لِيُذِيقَهُم بَعْضَ الَّذِي عَمِلُوا لَعَلَّهُمْ يَرْجِعُونَ﴾. فالجشع المادي والنشاط الصناعي غير المنضبط هو الجناية التي أدت إلى اختلال منظومة المناخ، وعلاج ذلك بالرجوع إلى العدل وكبح جماح الاستهلاك المفرط وحماية التنوع الحيوي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_4_2',
                evidenceKey: '30:41',
                citation: 'قوله تعالى: ﴿ظَهَرَ الْفَسَادُ فِي الْبَرِّ وَالْبَحْرِ بِمَا كَسَبَتْ أَيْدِي النَّاسِ لِيُذِيقَهُم بَعْضَ الَّذِي عَمِلُوا لَعَلَّهُمْ يَرْجِعُونَ﴾ [الروم: 41]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تفسير الرازي وتفسير السعدي',
          ),
        ],
      ),

      // Lesson 23
      Lesson.create(
        lessonId: 'lsn_environment_animal_welfare_compassion',
        title: 'منظومة الرفق بالحيوان وحقوق الكائنات الحية في الإسلام',
        courseId: courseId,
        moduleId: 'mod_animal_welfare_climate_balance',
        orderIndex: 5,
        sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_riyad_salihin'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_env_5_1',
            title: 'الرحمة بالحيوان وطريق الجنة',
            description: 'بيان شمولية الرحمة في الإسلام للحيوانات والطير وجعل الإحسان إليها سبباً للمغفرة.',
          ),
          LearningObjective(
            objectiveId: 'obj_env_5_2',
            title: 'المحظورات وإحسان الذبح',
            description: 'معرفة المحظورات الشرعية: تجويع الحيوان، تحميله فوق طاقته، وسمه في الوجه، والتحريش بين البهائم.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_env_5_1',
            title: 'الأمم الحية والرحمة بالحيوان طريق الجنة',
            contentType: LearningContentType.sourceText,
            content: 'اعتبر القرآن الكريم الكائنات الحية أمماً متكاملة ذات حقوق: ﴿وَمَا مِن دَابَّةٍ فِي الْأَرْضِ وَلَا طَائِرٍ يَطِيرُ بِجَنَاحَيْهِ إِلَّا أُمَمٌ أَمْثَالُكُم﴾. وجعل الإسلام الإحسان إلى الحيوان عملاً كبيراً يُغفر به الذنب، كما في حديث الذي سقى كلباً يلهث من العطش في خفه: «فَشَكَرَ اللَّهُ لَهُ فَغَفَرَ لَهُ، قَالُوا: يَا رَسُولَ اللَّهِ، وَإِنَّ لَنَا فِي الْبَهَائِمِ لَأَجْرًا؟ فَقَالَ: فِي كُلِّ كَبِدٍ رَطْبَةٍ أَجْرٌ». في المقابل، استحق عذاب النار من حبس هرة ومنعها الطعام والسعي: «دَخَلَتِ امْرَأَةٌ النَّارَ فِي هِرَّةٍ حَبَسَتْهَا...».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_5_1',
                evidenceKey: '6:38',
                citation: 'قوله تعالى: ﴿إِلَّا أُمَمٌ أَمْثَالُكُم﴾ [الأنعام: 38] وحديث البخاري: «في كل كبد رطبة أجر» وحديث الهرة',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وصحيح مسلم ورياض الصالحين للنووي',
          ),
          LessonSection.create(
            sectionId: 'sec_env_5_2',
            title: 'قواعد إحسان الذبح والمحظورات الصارمة',
            contentType: LearningContentType.explanation,
            content: 'أوجب النبي ﷺ الإحسان في الذبح: «إِنَّ اللَّهَ كَتَبَ الإِحْسَانَ عَلَى كُلِّ شَيْءٍ، فَإِذَا قَتَلْتُمْ فَأَحْسِنُوا الْقِتْلَةَ، وَإِذَا ذَبَحْتُمْ فَأَحْسِنُوا الذَّبْحَ، وَلْيُحِدَّ أَحَدُكُمْ شَفْرَتَهُ، وَلْيُرِحْ ذَبِيحَتَهُ». وحرمت الشريعة: 1) شحذ السكين أمام الذبيحة أو ذبح بهيمة أمام أخرى. 2) وسم الحيوان وضربه على وجهه. 3) اتخاذ الحيوان غرضاً للرماية أو صيده لمجرد اللهو دون أكل. 4) التحريش بين البهائم (كمصارعة الثيران ومناقرة الديوك). 5) إرهاق الدواب بحمل ما لا تطيق.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_5_2',
                evidenceKey: 'muslim:1955',
                citation: 'حديث شداد بن أوس في صحيح مسلم: «إن الله كتب الإحسان على كل شيء...»',
                sourceId: 'src_muslim_canonical',
              ),
            ],
            sourceAttribution: 'صحيح مسلم وسنن الترمذي والمستدرك على الصحيحين',
          ),
        ],
      ),

      // Lesson 24
      Lesson.create(
        lessonId: 'lsn_environment_waste_pollution_harm_removal',
        title: 'مكافحة التلوث والنفايات وإماطة الأذى وتدوير الموارد',
        courseId: courseId,
        moduleId: 'mod_animal_welfare_climate_balance',
        orderIndex: 6,
        sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_qawaid_fiqhiyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_env_6_1',
            title: 'إماطة الأذى شعبة إيمان',
            description: 'بيان المنزلة الإيمانية لإماطة الأذى عن طريق الناس ومرافقه العامة.',
          ),
          LearningObjective(
            objectiveId: 'obj_env_6_2',
            title: 'مكافحة التلوث وتدوير الموارد',
            description: 'تأصيل فقه إدارة النفايات والتدوير ومكافحة الانبعاثات والملوثات الكيميائية والإشعاعية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_env_6_1',
            title: 'إماطة الأذى من شعب الإيمان وحق الطريق',
            contentType: LearningContentType.sourceText,
            content: 'رفع الإسلام نظافة البيئة وحمايتها من القاذورات إلى مرتبة العمل الإيماني العظيم، فقال النبي ﷺ: «الإِيمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً، فَأَفْضَلُهَا قَوْلُ لَا إِلَهَ إِلَّا اللَّهُ، وَأَدْنَاهَا إِمَاطَةُ الأَذَى عَنِ الطَّرِيقِ». وأخبر النبي ﷺ عن رجل دخل الجنة بسبب إزالته غصن شجرة كان يؤذي المسلمين في طريقهم: «مَرَّ رَجُلٌ بِغُصْنِ شَجَرَةٍ عَلَى ظَهْرِ طَرِيقٍ فَقَالَ: وَاللَّهِ لَأُنَحِّيَنَّ هَذَا عَنِ الْمُسْلِمِينَ لَا يُؤْذِيهِمْ، فَأُدْخِلَ الْجَنَّةَ».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_6_1',
                evidenceKey: 'bukhari:9',
                citation: 'حديث أبي هريرة في الصحيحين في شعب الإيمان وحديث غصن الشوك في صحيح مسلم',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح مسلم وصحيح البخاري ومشكاة المصابيح',
          ),
          LessonSection.create(
            sectionId: 'sec_env_6_2',
            title: 'مكافحة التلوث الصناعي وتدوير النفايات',
            contentType: LearningContentType.explanation,
            content: 'إن إلقاء النفايات السامة والمخلفات الصناعية في الأنهار والبحار أو تلويث الأجواء بالغازات والانبعاثات الكيميائية الضارة محرم شرعاً ويعد عدواناً وجناية بموجب قاعدة «لا ضرر ولا ضرار» وقاعدة «الضرر يزال». ويجب شرعاً على الدول والمؤسسات تبني تقنيات تدوير النفايات وإعادة استخدام الموارد (Recycling) والتحول إلى الطاقة النظيفة المتجددة، تفعيلاً لمقاصد الشريعة في حفظ النفس والعقل والمال وصيانة بيئة الأرض التي أودعها الله أمانة بين أيدينا.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_env_6_2',
                evidenceKey: 'qawaid:darar_yuzal_env',
                citation: 'القاعدة الفقهية الكبرى: «الضرر يزال» وقاعدة «يُتحمل الضرر الخاص لدفع الضرر العام»',
                sourceId: 'src_majma_fiqhi',
              ),
            ],
            sourceAttribution: 'الأشباه والنظائر للسيوطي وقرارات مجمع الفقه الإسلامي الدولي المعاصرة',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: الرؤية الإسلامية للبيئة وترشيد المياه
    final q1 = QuizQuestion.create(
      questionId: 'q_env_1',
      lessonId: 'lsn_environment_stewardship_creation_purpose',
      questionText: 'ما هو المفهوم الإسلامي الأساسي لعلاقة الإنسان بالكون والبيئة ومواردها؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qv1_1', text: 'علاقة استخلاف وأمانة وتعمير وإصلاح وتسخير للانتفاع بالحق والعدل'),
        QuizOption(optionId: 'opt_qv1_2', text: 'علاقة تملك مطلق واستعلاء يبيح للإنسان استنزاف الموارد كيفما شاء'),
        QuizOption(optionId: 'opt_qv1_3', text: 'علاقة صراع وحرب دائمة لقهر الطبيعة وإخضاعها بالقوة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الإنسان مستخلف في الأرض ومؤتمن على عمارتها وإصلاحها: {هُوَ أَنشَأَكُم مِّنَ الْأَرْضِ وَاسْتَعْمَرَكُمْ فِيهَا} وتسخير مواردها بالعدل.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_environment_earth_stewardship',
      lessonId: 'lsn_environment_stewardship_creation_purpose',
      title: 'اختبار تقييم استيعاب الرؤية الإسلامية للبيئة وترشيد المياه والتشجير',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: الرفق بالحيوان ومكافحة التلوث
    final q2 = QuizQuestion.create(
      questionId: 'q_env_2',
      lessonId: 'lsn_environment_animal_welfare_compassion',
      questionText: 'أين جعل النبي ﷺ منزلة «إماطة الأذى عن الطريق» ومكافحة القاذورات في منظومة الدين؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qv2_1', text: 'شعبة مباركة من شعب الإيمان وأمراً يغفر الله به الخطايا ويدخل به الجنة'),
        QuizOption(optionId: 'opt_qv2_2', text: 'عملاً دنيوياً لا ثواب فيه ولا عقاب'),
        QuizOption(optionId: 'opt_qv2_3', text: 'مكروهاً لأنه يشغل الإنسان عن الذكر باللسان'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قال النبي ﷺ: «الإيمان بضع وسبعون شعبة... وأدناها إماطة الأذى عن الطريق»، وتطهير المرافق العامة وإزالة الضرر من صميم الإيمان.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_animal_welfare_climate_balance',
      lessonId: 'lsn_environment_animal_welfare_compassion',
      title: 'اختبار تقييم استيعاب التوازن المناخي والرفق بالحيوان ومكافحة التلوث',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
