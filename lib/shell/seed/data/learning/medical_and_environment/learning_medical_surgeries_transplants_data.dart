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

/// بيانات مقرر النوازل الطبية والجراحية وأحكام التداوي ونقل الأعضاء (6 دروس تأصيلية + اختباران استيعاب)
class LearningMedicalSurgeriesTransplantsData {
  static const String courseId = 'course_medical_surgeries_transplants';
  static const String pathId = 'path_medical_bioethics_environment_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر النوازل الطبية والجراحية وأحكام التداوي ونقل الأعضاء',
      description: 'دراسة تأصيلية فقهية لأحكام التداوي والمسؤولية الطبية والموت الدماغي ورفع أجهزة الإنعاش، وزراعة ونقل الأعضاء، وبنوك الدم والقرنيات، وضوابط الجراحة التجميلية العلاجية والتحسينية في ضوء قرارات المجامع الفقهية.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_medical_treatment_brain_death', 'mod_organ_transplant_plastic_surgery'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_medical_treatment_brain_death',
        courseId: courseId,
        title: 'الوحدة الأولى: فقه التداوي والمسؤولية الطبية والتخدير والموت الدماغي',
        description: 'تأصيل حكم التداوي ومراتبه، التداوي بالمحرمات وشرط الضرورة، المسؤولية الطبية وضمان الطبيب، والإذن المستنير، وحقيقة الموت الدماغي ورفع أجهزة الإنعاش.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_medical_treatment_necessity_rules',
          'lsn_medical_brain_death_resuscitation',
          'lsn_medical_anesthesia_liability_consent',
        ],
      ),
      CourseModule(
        moduleId: 'mod_organ_transplant_plastic_surgery',
        courseId: courseId,
        title: 'الوحدة الثانية: زراعة ونقل الأعضاء البشرية والجراحات التجميلية وبنوك الدم',
        description: 'أحكام نقل الأعضاء من الأحياء والأموات، تجريم بيع الأعضاء، بنوك الدم والقرنيات، وضوابط الجراحة التجميلية بين الحاجة العلاجية والتحسين وتغيير خلق الله.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_medical_treatment_brain_death'],
        lessonIds: const [
          'lsn_medical_organ_transplant_living_deceased',
          'lsn_medical_blood_cornea_stem_banks',
          'lsn_medical_plastic_cosmetic_surgeries',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 1
      Lesson.create(
        lessonId: 'lsn_medical_treatment_necessity_rules',
        title: 'حكم التداوي في الشريعة الإسلامية وضوابط الضرورة العلاجية',
        courseId: courseId,
        moduleId: 'mod_medical_treatment_brain_death',
        orderIndex: 1,
        sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_majma_fiqhi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_med_1_1',
            title: 'الموقف الشرعي من التداوي',
            description: 'معرفة الموقف الشرعي من التداوي والأخذ بالأسباب وأقوال الفقهاء في مراتبه التكليفية.',
          ),
          LearningObjective(
            objectiveId: 'obj_med_1_2',
            title: 'ضوابط التداوي بالمحرمات',
            description: 'إدراك حكم التداوي بالمحرمات وضوابط الضرورة المبيحة وشروط فقدان البديل المباح.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_med_1_1',
            title: 'مشروعية التداوي ومراتبه التكليفية',
            contentType: LearningContentType.sourceText,
            content: 'التداوي مشروع بالاتفاق استناداً إلى هدي النبي ﷺ في قوله: «تَدَاوَوْا فَإِنَّ اللَّهَ عَزَّ وَجَلَّ لَمْ يَضَعْ داءً إِلَّا وَضَعَ لَهُ دَوَاءً». وتتفاوت مراتب التداوي التكليفية بحسب الحالة: فيكون واجباً إذا كان تركه يفضي إلى الهلاك أو تلف عضو أو ضرر بالغ، ويكون مستحباً إذا كان يرجى به النفع من غير يقين بالهلاك، ومباحاً إذا استوى فيه الأمران، ومكروهاً أو محرماً إذا انطوى على غرر مؤكد أو خرافة لا سند علمي ولا شرعي لها.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_1_1',
                evidenceKey: 'abu_dawud:3855',
                citation: 'حديث أسامة بن شريك: «تَدَاوَوْا يَا عِبَادَ اللَّهِ» (رواه أبو داود والترمذي وصححه)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح أبي داود وسنن الترمذي ومجموع الفتاوى لابن تيمية',
          ),
          LessonSection.create(
            sectionId: 'sec_med_1_2',
            title: 'ضوابط التداوي بالمحرمات وقاعدة الضرورة',
            contentType: LearningContentType.explanation,
            content: 'الأصل تحريم التداوي بالنجاسات والمحرمات لحديث: «إِنَّ اللَّهَ أَنْزَلَ الدَّاءَ وَالدَّوَاءَ وَجَعَلَ لِكُلِّ دَاءٍ دَوَاءً فَتَدَاوَوْا وَلَا تَدَاوَوْا بِحَرَامٍ». غير أن جمهور الفقهاء والمجامع الفقهية قرروا جواز التداوي بما أصله محرم أو نجس عند الضرورة القصوى بشروط دقيقة: 1) تعين الدواء وعدم وجود بديل مباح يكافئه في العلاج. 2) إخبار طبيب مسلم عدل ثقة بأن هذا الدواء يحقق النفع المطلوب. 3) ألا يتناول المريض منه إلا بقدر ما تندفع به الضرورة لقوله تعالى: ﴿فَمَنِ اضْطُرَّ غَيْرَ بَاغٍ وَلَا عَادٍ فَلَا إِثْمَ عَلَيْهِ﴾.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_1_2',
                evidenceKey: '6:119',
                citation: 'قوله تعالى: ﴿وَقَدْ فَصَّلَ لَكُم مَّا حَرَّمَ عَلَيْكُمْ إِلَّا مَا اضْطُرِرْتُمْ إِلَيْهِ﴾ [الأنعام: 119]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي وقواعد الأحكام للعز بن عبد السلام',
          ),
        ],
      ),

      // Lesson 2
      Lesson.create(
        lessonId: 'lsn_medical_brain_death_resuscitation',
        title: 'الموت الدماغي وضوابط رفع أجهزة الإنعاش الصناعية',
        courseId: courseId,
        moduleId: 'mod_medical_treatment_brain_death',
        orderIndex: 2,
        sources: const ['src_majma_fiqhi_resolutions', 'src_hayat_kibar_ulama'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_med_2_1',
            title: 'التكييف الفقهي للموت الدماغي',
            description: 'فهم التكييف الفقهي لمفهوم موت جذع الدماغ والمقارنة بينه وبين توقف القلب والتنفس.',
          ),
          LearningObjective(
            objectiveId: 'obj_med_2_2',
            title: 'ضوابط رفع أجهزة الإنعاش',
            description: 'معرفة الضوابط الفقهية والطبية الصارمة لرفع أجهزة الإنعاش الصناعية عن المريض.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_med_2_1',
            title: 'التكييف الشرعي لحقيقة الموت وموت الدماغ',
            contentType: LearningContentType.sourceText,
            content: 'قرر مجمع الفقه الإسلامي الدولي (القرار رقم 17) وهيئة كبار العلماء أن الموت الشرعي الذي تترتب عليه جميع أحكامه من الإرث والعدة وانفساخ النكاح يتحقق بأحد أمرين: 1) توقف القلب والتنفس توقفاً تاماً لا رجعة فيه وحكم الأطباء باستحالة عودتهما. 2) تعطل جميع وظائف الدماغ تعطلاً نهائياً، وخاصة جذع الدماغ، وحكمت لجنة طبية ثلاثية مختصة باستحالة عودته إلى الحياة وأخذ دماغه في التحلل. فحينئذ يعد الشخص في حكم الميت شرعاً وطبياً.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_2_1',
                evidenceKey: 'majma:res:17',
                citation: 'قرار مجمع الفقه الإسلامي الدولي رقم 17 (5/3) بشأن أجهزة الإنعاش وعلامات الوفاة',
                sourceId: 'src_majma_fiqhi_resolutions',
              ),
            ],
            sourceAttribution: 'مجلة مجمع الفقه الإسلامي ومقررات هيئة كبار العلماء بالمملكة',
          ),
          LessonSection.create(
            sectionId: 'sec_med_2_2',
            title: 'ضوابط رفع أجهزة الإنعاش وتحريم القتل الرحيم',
            contentType: LearningContentType.explanation,
            content: 'يجوز رفع أجهزة الإنعاش الصناعية (كجهاز التنفس الاصطناعي ومضخات القلب) إذا ثبت موت جذع الدماغ بتقرير لجنة متخصصة لا مصلحة لأعضائها بنقل الأعضاء، أو إذا كان المريض في غيبوبة عميقة مستديمة لا يرجى برؤها وتعتمد حياته كلياً على الأجهزة بلا وظائف ذاتية. في المقابل، تحرم الشريعة الإسلامية قطعاً ما يسمى «القتل الرحيم» (Euthanasia) الفاعل أو الانتحار المساعد بإعطاء جرعة قاتلة لإنهاء حياة المريض لآلامه؛ لأن الروح ملك لله تعالى، والنفس محرم قتلها بأي مبرر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_2_2',
                evidenceKey: '4:29',
                citation: 'قوله تعالى: ﴿وَلَا تَقْتُلُوا أَنفُسَكُمْ إِنَّ اللَّهَ كَانَ بِكُمْ رَحِيمًا﴾ [النساء: 29]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرارات المنظمة الإسلامية للعلوم الطبية والمجمع الفقهي لرابطة العالم الإسلامي',
          ),
        ],
      ),

      // Lesson 3
      Lesson.create(
        lessonId: 'lsn_medical_anesthesia_liability_consent',
        title: 'المسؤولية الطبية والتخدير وحقوق المريض والإذن المستنير',
        courseId: courseId,
        moduleId: 'mod_medical_treatment_brain_death',
        orderIndex: 3,
        sources: const ['src_majma_fiqhi', 'src_qawaid_fiqhiyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_med_3_1',
            title: 'قواعد المسؤولية الطبية',
            description: 'استيعاب قواعد المسؤولية الطبية وحالات ضمان الطبيب وحالات سقوط الضمان.',
          ),
          LearningObjective(
            objectiveId: 'obj_med_3_2',
            title: 'الإذن المستنير والتخدير',
            description: 'معرفة مفهوم الإذن الطبي المستنير وأحكام التخدير الطبي وأثره على الأهلية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_med_3_1',
            title: 'قواعد المسؤولية الطبية وضمان الطبيب',
            contentType: LearningContentType.sourceText,
            content: 'الأصل في عمل الطبيب المأذون له الحاذق عدم الضمان إذا التزم بالأصول العلمية والمهنية المتعارف عليها ولم يقصر أو يعتد، لقول النبي ﷺ: «مَنْ تَطَبَّبَ وَلَمْ يُعْلَمْ مِنْهُ طِبٌّ قَبْلَ ذَلِكَ فَهُوَ ضَامِنٌ». ويضمن الطبيب في ثلاث حالات رئيسة: 1) التعدي بمخالفة الأصول الطبية المستقرة أو إجراء جراحة بغير إذن المريض المعتبر. 2) التفريط والإهمال الجسيم في المتابعة والعناية. 3) الجهل وممارسة مهنة الطب دون تدريب وأهلية وترخيص معتبر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_3_1',
                evidenceKey: 'abu_dawud:4586',
                citation: 'حديث عمرو بن شعيب عن أبيه عن جده: «مَنْ تَطَبَّبَ وَلَمْ يُعْلَمْ مِنْهُ طِبٌّ فَهُوَ ضَامِنٌ» (رواه أبو داود والنسائي وحسنه الألباني)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'سنن أبي داود وزاد المعاد لابن القيم والمغني لابن قدامة',
          ),
          LessonSection.create(
            sectionId: 'sec_med_3_2',
            title: 'الإذن الطبي المستنير وأحكام التخدير',
            contentType: LearningContentType.explanation,
            content: 'الإذن الطبي المستنير (Informed Consent) حق أصيل للمريض المكلف العاقل، ويلزم إحاطته بطبيعة التدخل الجراحي ونسبة النجاح والمخاطر المترتبة، ولا يجوز التدخل الجراحي دونه إلا في حالات الطوارئ القصوى لإنقاذ الحياة عند غياب الوعي وتعذر حضور الولي. والتخدير الطبي جائز شرعاً للحاجة العلاجية ودفع المشقة، ولا يترتب عليه بطلان العقود إلا إذا تمت تحت تأثيره المسقط للإدراك والتمييز.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_3_2',
                evidenceKey: 'qawaid:darar_yuzal',
                citation: 'القاعدة الفقهية: «المشقة تجلب التيسير» وقاعدة «الضرر يزال»',
                sourceId: 'src_majma_fiqhi',
              ),
            ],
            sourceAttribution: 'الأشباه والنظائر للسيوطي وفتاوى اللجنة الدائمة للبحوث العلمية',
          ),
        ],
      ),

      // Lesson 4
      Lesson.create(
        lessonId: 'lsn_medical_organ_transplant_living_deceased',
        title: 'زراعة ونقل الأعضاء البشرية بين الأحياء والأموات',
        courseId: courseId,
        moduleId: 'mod_organ_transplant_plastic_surgery',
        orderIndex: 4,
        sources: const ['src_majma_fiqhi_resolutions', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_med_4_1',
            title: 'نقل الأعضاء من المتبرع الحي',
            description: 'معرفة شروط وضوابط نقل الأعضاء من الإنسان الحي لغيره ومحظورات ذلك.',
          ),
          LearningObjective(
            objectiveId: 'obj_med_4_2',
            title: 'نقل الأعضاء بعد الوفاة وتحريم البيع',
            description: 'استيعاب أحكام الوصية بنقل الأعضاء بعد الموت والتحريم المطلق لبيع الأعضاء.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_med_4_1',
            title: 'نقل الأعضاء من المتبرع الحي وضوابطه',
            contentType: LearningContentType.sourceText,
            content: 'يجوز نقل عضو أو جزء من عضو من إنسان حي إلى إنسان آخر تتوقف حياته عليه أو يتوقف شفاؤه عليه، وفق ضوابط إسلامية مجمع عليها: 1) ألا يلحق النقل بالمتبرع ضرراً يهدد حياته أو يعطل معيشته الأساسية تطبيقاً لقاعدة «الضرر لا يزال بضرر مثله». 2) ألا يكون العضو المنقول أحادياً تتوقف عليه الحياة كالقلب والرئة والبنكرياس. 3) ألا ينقل صفات وراثية كالأعضاء التناسلية (الخصية والمبيض). 4) أن يكون التبرع طوعياً محضاً بإرادة حرة واعية.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_4_1',
                evidenceKey: '5:32',
                citation: 'قوله تعالى: ﴿وَمَنْ أَحْيَاهَا فَكَأَنَّمَا أَحْيَا النَّاسَ جَمِيعًا﴾ [المائدة: 32]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرار مجمع الفقه الإسلامي الدولي رقم 26 بشأن زراعة الأعضاء',
          ),
          LessonSection.create(
            sectionId: 'sec_med_4_2',
            title: 'نقل الأعضاء من الميت والتحريم القاطع لبيع الأعضاء',
            contentType: LearningContentType.explanation,
            content: 'يجوز نقل عضو من ميت إلى حي تتوقف حياته على ذلك أو يسترد به وظيفة أساسية كالقرنية والقلب والكبد، إذا أوصى الميت بذلك في حياته أو أذن ورثته الشرعيون بعد وفاته، مع اشتراط التحقق الكامل من وفاته الشرعية أو الدماغية. ويحرم بالإجماع بيع الأعضاء البشرية أو المتاجرة بها بأي صورة كانت؛ لأن الإنسان مكرم لا يدخل تحت البيع والابتذال والتثمين المالي: ﴿وَلَقَدْ كَرَّمْنَا بَنِي آدَمَ﴾.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_4_2',
                evidenceKey: '17:70',
                citation: 'قوله تعالى: ﴿وَلَقَدْ كَرَّمْنَا بَنِي آدَمَ﴾ [الإسراء: 70] وإجماع المجامع الفقهية على تجريم بيع الأعضاء',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرارات المجمع الفقهي الإسلامي بمكة المكرمة وهيئة كبار العلماء',
          ),
        ],
      ),

      // Lesson 5
      Lesson.create(
        lessonId: 'lsn_medical_blood_cornea_stem_banks',
        title: 'أحكام بنوك الدم والقرنيات ونقل الخلايا والأنسجة',
        courseId: courseId,
        moduleId: 'mod_organ_transplant_plastic_surgery',
        orderIndex: 5,
        sources: const ['src_majma_fiqhi', 'src_fatawa_contemporary'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_med_5_1',
            title: 'أحكام بنوك وحفظ الدم',
            description: 'بيان أحكام التبرع بالدم وبنوك حفظه وشروط التعويض المالي التكلفي الإداري.',
          ),
          LearningObjective(
            objectiveId: 'obj_med_5_2',
            title: 'القرنيات والخلايا الجذعية',
            description: 'معرفة أحكام نقل القرنيات وبنوك الأنسجة والتبرع بالخلايا الجذعية ونخاع العظم.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_med_5_1',
            title: 'التبرع بالدم وبنوك حفظ الدم',
            contentType: LearningContentType.sourceText,
            content: 'التبرع بالدم عمل صالح مندوب ومتقرب به إلى الله لما فيه من إنقاذ الأنفس وإعانة المصابين، شريطة ألا يتضرر المتبرع طبياً بفقد الدم. والأصل تحريم بيع الدم لنهي النبي ﷺ عن ثمن الدم، ولكن يجوز لبنوك الدم تحصيل تكاليف استخلاص الدم وفحصه وحفظه ونقله (رسوم خدمات وتكاليف تقنية لا ثمناً للدم ذاته). ويجوز للمضطر شراء الدم إذا امتنع من بذله مجاناً، ويكون الإثم على الآخذ دون المضطر المعذور.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_5_1',
                evidenceKey: 'bukhari:2237',
                citation: 'حديث أبي جحيفة: «نَهَى النَّبِيُّ ﷺ عَنْ ثَمَنِ الدَّمِ وَثَمَنِ الْكَلْبِ وَكَسْبِ الْبَغِيِّ» (رواه البخاري)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وفتاوى دار الإفتاء المصرية والمجمع الفقهي الإسلامي',
          ),
          LessonSection.create(
            sectionId: 'sec_med_5_2',
            title: 'بنوك القرنيات والتبرع بنخاع العظم والخلايا',
            contentType: LearningContentType.explanation,
            content: 'يجوز إنشاء بنوك لحفظ القرنيات المأخوذة من المتوفين بإذن مسبق لمعالجة فاقدي البصر، وكذا التبرع بنخاع العظم (Bone Marrow) والخلايا الجذعية من الدم المحيطي لمرضى سرطان الدم والأورام، ويعد هذا التبرع صدقة جارية ونوعاً من أنواع الإحياء المعنوي والبدني المنصوص على فضله في التنزيل الحكيم.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_5_2',
                evidenceKey: '5:2',
                citation: 'قوله تعالى: ﴿وَتَعَاوَنُوا عَلَى الْبِرِّ وَالتَّقْوَىٰ وَلَا تَعَاوَنُوا عَلَى الْإِثْمِ وَالْعُدْوَانِ﴾ [المائدة: 2]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'مقررات الندوة الفقهية الطبية الثامنة للمنظمة الإسلامية للعلوم الطبية',
          ),
        ],
      ),

      // Lesson 6
      Lesson.create(
        lessonId: 'lsn_medical_plastic_cosmetic_surgeries',
        title: 'الجراحات التجميلية بين الضرورة العلاجية والتغيير المحرم',
        courseId: courseId,
        moduleId: 'mod_organ_transplant_plastic_surgery',
        orderIndex: 6,
        sources: const ['src_majma_fiqhi_resolutions', 'src_bukhari_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_med_6_1',
            title: 'التجميل العلاجي',
            description: 'إدراك الفارق المنهجي بين جراحة التجميل العلاجية والجراحة التحسينية المحضة.',
          ),
          LearningObjective(
            objectiveId: 'obj_med_6_2',
            title: 'ضوابط التحسين وتغيير الخلق',
            description: 'معرفة ضوابط ومحاذير الجراحة التحسينية وتطبيقات تغيير خلق الله والتدليس.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_med_6_1',
            title: 'جراحة التجميل العلاجية والضرورية',
            contentType: LearningContentType.sourceText,
            content: 'الجراحة التجميلية العلاجية هي التي يقصد منها إزالة عيب خلقي ناشئ عن ولادة (كالشفة الأرنبية والتصاق الأصابع) أو عيب طارئ ناشئ عن حوادث أو حروق أو أمراض (كاستئصال الأورام وإعادة بناء العضو). وهذه الجراحة جائزة ومشروعة باتفاق الفقهاء والمجامع، لأنها رد للبدن إلى أصل الخلقة السوية ورفع للضرر الحسي والنفسي، ودليلها إذن النبي ﷺ لعرفجة بن أسعد أن يتخذ أنفاً من ذهب لما قُطع أنفه في معركة الكُلاب.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_6_1',
                evidenceKey: 'abu_dawud:4232',
                citation: 'حديث عرفجة بن أسعد: «أَنَّهُ أُصِيبَ أَنْفُهُ يَوْمَ الْكُلَابِ فِي الْجَاهِلِيَّةِ فَاتَّخَذَ أَنْفًا مِنْ وَرِقٍ فَأَنْتَنَ عَلَيْهِ فَأَمَرَهُ النَّبِيُّ ﷺ أَنْ يَتَّخِذَ أَنْفًا مِنْ ذَهَبٍ» (رواه أبو داود والترمذي وحسنه)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'سنن أبي داود والترمذي وقرار مجمع الفقه الإسلامي الدولي رقم 173',
          ),
          LessonSection.create(
            sectionId: 'sec_med_6_2',
            title: 'الجراحة التحسينية وضوابط تغيير خلق الله والتدليس',
            contentType: LearningContentType.explanation,
            content: 'الجراحة التجميلية التحسينية التي لا تهدف إلى إزالة عيب أو تشوه مؤذٍ، بل تبتغي مجرد مطابقة مقاييس الجمال الشائعة أو الرغبة في التشبيه والتدليس، كعمليات تغيير شكل الأنف الطبيعي أو تكبير الشفاه أو شفط الدهون من غير ضرورة طبية؛ محرمة شرعاً لما تنطوي عليه من تغيير لخلق الله تعالى ابتغاء مجرد الهوى ودخولها في وعيد الشيطان: ﴿وَلَآمُرَنَّهُمْ فَلَيُغَيِّرُنَّ خَلْقَ اللَّهِ﴾، ولحديث لعن الواصلة والمستوشمة والمتفلجات للحسن المغيرات خلق الله.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_med_6_2',
                evidenceKey: '4:119',
                citation: 'قوله تعالى: ﴿وَلَآمُرَنَّهُمْ فَلَيُغَيِّرُنَّ خَلْقَ اللَّهِ﴾ [النساء: 119] وحديث ابن مسعود في الصحيحين',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'صحيح مسلم وقرار مجمع الفقه الإسلامي الدولي رقم 173 (18/4)',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: فقه التداوي والمسؤولية الطبية والموت الدماغي
    final q1 = QuizQuestion.create(
      questionId: 'q_med_1',
      lessonId: 'lsn_medical_treatment_necessity_rules',
      questionText: 'ما هو الحكم الفقهي الراجح للتداوي إذا كان تركه يفضي إلى هلاك المريض أو تلف عضو أساسي منه؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qm1_1', text: 'واجب شرعاً صيانة للنفس المعصومة من التلف والهلاك'),
        QuizOption(optionId: 'opt_qm1_2', text: 'مكروه لأنه ينافي التوكل على الله تعالى'),
        QuizOption(optionId: 'opt_qm1_3', text: 'مباح يتساوى فيه الفعل والترك في جميع الأحوال'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يكون التداوي واجباً إذا كان تركه يفضي حتماً إلى الهلاك أو تلف الأعضاء الأساسية حفظاً للنفس التي أوجب الشارع صيانتها.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_medical_treatment_brain_death',
      lessonId: 'lsn_medical_treatment_necessity_rules',
      title: 'اختبار تقييم استيعاب فقه التداوي والمسؤولية الطبية والموت الدماغي',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: زراعة الأعضاء والجراحات التجميلية
    final q2 = QuizQuestion.create(
      questionId: 'q_med_2',
      lessonId: 'lsn_medical_organ_transplant_living_deceased',
      questionText: 'ما هو الشرط الأهم لجواز تبرع الإنسان الحي بأحد أعضائه لغيره وفق الشريعة الإسلامية؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qm2_1', text: 'ألا يلحق النقل بالمتبرع ضرراً فادحاً يهدد حياته أو يعطل معيشته الأساسية وأن يكون طوعاً مجاناً'),
        QuizOption(optionId: 'opt_qm2_2', text: 'أن يتقاضى مقابلاً مادياً مجزياً يعوضه عن فقد العضو'),
        QuizOption(optionId: 'opt_qm2_3', text: 'أن يكون العضو المنقول هو القلب أو المخ لإعطاء الحياة للمتلقي'),
      ],
      correctOptionIndices: const [0],
      explanation: 'يشترط ألا يتضرر المتبرع ضرراً كلياً تطبيقاً لقاعدة «الضرر لا يزال بمثله»، وأن يكون التبرع تبرعاً طوعياً بغير بيع.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_organ_transplant_plastic_surgery',
      lessonId: 'lsn_medical_organ_transplant_living_deceased',
      title: 'اختبار تقييم استيعاب فقه زراعة الأعضاء والجراحات التجميلية وبنوك الدم',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
