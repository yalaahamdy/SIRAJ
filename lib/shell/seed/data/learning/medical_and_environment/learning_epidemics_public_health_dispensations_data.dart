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

/// بيانات مقرر فقه الأوبئة والصحة العامة والصيام والرخص الطبية (6 دروس تأصيلية + اختباران استيعاب)
class LearningEpidemicsPublicHealthDispensationsData {
  static const String courseId = 'course_epidemics_public_health_dispensations';
  static const String pathId = 'path_medical_bioethics_environment_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الأوبئة والصحة العامة والصيام والرخص الطبية',
      description: 'دراسة تأصيلية فقهية للهدي النبوي في الوقاية من الأوبئة والتوجيه الفقهي للعدوى، نظام الحجر الصحي وسلطة ولي الأمر في الإغلاق وتقييد الحركة، اللقاحات ونوازل صلاة الجماعة، المفطرات الطبية المعاصرة، ورخص المرضى في الطهارة والصلاة والحج.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_epidemics_quarantine_public_health', 'mod_medical_dispensations_worship'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_epidemics_quarantine_public_health',
        courseId: courseId,
        title: 'الوحدة الأولى: فقه الأوبئة، الحجر الصحي، والطب الوقائي واللقاحات',
        description: 'الهدي النبوي في حفظ الصحة، التوجيه العقدي للعدوى، السبق النبوي للحجر الصحي وتقييد الحركة، ومشروعية اللقاحات ونوازل إقامة صلاة الجمعة والجماعة في الجوائح.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_epidemics_prophetic_prevention_contagion',
          'lsn_epidemics_quarantine_movement_restrictions',
          'lsn_epidemics_vaccines_community_worship',
        ],
      ),
      CourseModule(
        moduleId: 'mod_medical_dispensations_worship',
        courseId: courseId,
        title: 'الوحدة الثانية: المفطرات الطبية المعاصرة ورخص المرضى في العبادات',
        description: 'تحرير أحكام المفطرات الطبية المعاصرة وما يفسد الصوم وما يعفى عنه، ورخص المرضى في الطهارة ومسح الجبائر، والصلاة والجمع، والإنابة في الحج والعمرة.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_epidemics_quarantine_public_health'],
        lessonIds: const [
          'lsn_dispensations_medical_fasting_invalids',
          'lsn_dispensations_illness_prayer_purification',
          'lsn_dispensations_hajj_medical_substitutions',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 13
      Lesson.create(
        lessonId: 'lsn_epidemics_prophetic_prevention_contagion',
        title: 'الهدي النبوي في الوقاية من الأوبئة والتوجيه الفقهي للعدوى',
        courseId: courseId,
        moduleId: 'mod_epidemics_quarantine_public_health',
        orderIndex: 1,
        sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_sharh_nawawi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_epi_1_1',
            title: 'الهدي النبوي في الصحة الوقائية',
            description: 'استيعاب الهدي النبوي المؤسس لقواعد الصحة العامة والنظافة الاحترازية.',
          ),
          LearningObjective(
            objectiveId: 'obj_epi_1_2',
            title: 'التوجيه الفقهي للعدوى والمخالطة',
            description: 'الجمع الفقهي الدقيق بين حديث «لا عدوى» وحديث «فر من المجذوم فرارك من الأسد».',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_epi_1_1',
            title: 'الهدي النبوي في الطب الوقائي وحفظ الصحة',
            contentType: LearningContentType.sourceText,
            content: 'أسست السنة النبوية المطهرة أرقى قواعد الطب الوقائي قبل نشوء الطب الحديث بقرون؛ فأمرت بتغطية الإناء وإيكاء السقاء: «غَطُّوا الإِنَاءَ وَأَوْكُوا السِّقَاءَ فَإِنَّ فِي السَّنَةِ لَيْلَةً يَنْزِلُ فِيهَا وَبَاءٌ»، ونهت عن التنفس في الإناء والنفخ فيه، وألزمت بغسل اليدين بعد الاستيقاظ قبل إدخالهما في الإناء، وشرعت الاستنشاق والمضمضة والوضوء المتكرر كحاجز صحي وقائي يحفظ الجهاز التنفسي والبدن.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_1_1',
                evidenceKey: 'muslim:2014',
                citation: 'حديث جابر بن عبد الله في صحيح مسلم: «غَطُّوا الإِنَاءَ وَأَوْكُوا السِّقَاءَ...»',
                sourceId: 'src_muslim_canonical',
              ),
            ],
            sourceAttribution: 'صحيح مسلم والطب النبوي لابن القيم',
          ),
          LessonSection.create(
            sectionId: 'sec_epi_1_2',
            title: 'التوجيه العقدي والفقهي لأحاديث العدوى والمخالطة',
            contentType: LearningContentType.explanation,
            content: 'جمع أئمة الإسلام بين قوله ﷺ: «لَا عَدْوَى وَلَا طِيَرَةَ» وبين قوله: «فِرَّ مِنَ المَجْذُومِ كَمَا تَفِرُّ مِنَ الأَسَدِ»، وقوله: «لَا يُورِدَنَّ مُمْرِضٌ عَلَى مُصِحٍّ»؛ بأن المنفي في الحديث الأول هو ما كان يعتقده أهل الجاهلية من أن المرض يعدي بطبعه وطاقته الذاتية استقلالاً عن قدرة الله، بينما المثبت في الأحاديث الأخرى هو الأخذ بالأسباب المشروعة؛ فالمرض سبب جعله الله ناقلاً بإذنه ومشيئته سبحانه، وتجنب المخالطة حذر مشروع وفرار من قدر الله إلى قدر الله.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_1_2',
                evidenceKey: 'bukhari:5707',
                citation: 'حديث أبي هريرة المتفق عليه: «لا عدوى ولا طيرة... وفر من المجذوم كما تفر من الأسد»',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'شرح صحيح مسلم للإمام النووي وفتح الباري لابن حجر',
          ),
        ],
      ),

      // Lesson 14
      Lesson.create(
        lessonId: 'lsn_epidemics_quarantine_movement_restrictions',
        title: 'الحجر الصحي وسلطة تقييد الحركة عند الجوائح',
        courseId: courseId,
        moduleId: 'mod_epidemics_quarantine_public_health',
        orderIndex: 2,
        sources: const ['src_bukhari_canonical', 'src_quran_canonical', 'src_majma_fiqhi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_epi_2_1',
            title: 'النص النبوي للحجر الصحي',
            description: 'معرفة النص النبوي الصريح المؤسس لنظام الحجر الصحي المكاني الكامل.',
          ),
          LearningObjective(
            objectiveId: 'obj_epi_2_2',
            title: 'سلطة الدولة في تقييد الحركة',
            description: 'تأصيل مشروعية قرارات ولي الأمر في الإغلاق وتقييد السفر لحماية الأمن الصحي.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_epi_2_1',
            title: 'السبق النبوي في إرساء الحجر الصحي الإقليمي',
            contentType: LearningContentType.sourceText,
            content: 'وضع النبي ﷺ القاعدة الأصولية الأولى في الحجر الصحي الطبي حين قال: «إِذَا سَمِعْتُمْ بِالطَّاعُونِ بِأَرْضٍ فَلَا تَدْخُلُوهَا، وَإِذَا وَقَعَ بِأَرْضٍ وَأَنْتُمْ بِهَا فَلَا تَخْرُجُوا مِنْهَا فِرَارًا مِنْهُ». وهذا النص التشريعي يمثل حصاراً وبائياً محكماً يمنع دخول الأصحاء إلى بؤرة الوباء خشية الإصابة، ويمنع خروج حاملي المرض والمخالطين من البؤرة لئلا يتسع نطاق العدوى في سائر المجتمعات.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_2_1',
                evidenceKey: 'bukhari:5728',
                citation: 'حديث عبد الرحمن بن عوف وأسامة بن زيد في الصحيحين عند مناقشة طاعون عمواس في زمن عمر بن الخطاب',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وصحيح مسلم وموطأ الإمام مالك',
          ),
          LessonSection.create(
            sectionId: 'sec_epi_2_2',
            title: 'سلطة الدولة في تقييد الحركة وتدابير الطوارئ الصحية',
            contentType: LearningContentType.explanation,
            content: 'يملك ولي الأمر وسلطات الصحة العامة شرعاً بمقتضى السياسة الشرعية فرض قيود حظر التجول، تعليق السفر والملاحة الجوية والبرية، إلزام المصابين بالعزل المنزلي أو المؤسسي، وإغلاق المرافق العامة مؤقتاً عند تفشي الأوبئة القاتلة، لقوله ﷺ: «لَا ضَرَرَ وَلَا ضِرَارَ»، وللقاعدة الفقهية الكبرى: «يتحمل الضرر الخاص لدفع الضرر العام»، وتجب طاعة هذه الأوامر ديانة ونظاماً.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_2_2',
                evidenceKey: 'qawaid:darar_khas_aam',
                citation: 'القاعدة الفقهية: «تصرف الإمام على الرعية منوط بالمصلحة» وقاعدة «درء المفاسد مقدم على جلب المصالح»',
                sourceId: 'src_majma_fiqhi',
              ),
            ],
            sourceAttribution: 'الأشباه والنظائر لابن نجيم وقرارات هيئة كبار العلماء في جائحة كورونا',
          ),
        ],
      ),

      // Lesson 15
      Lesson.create(
        lessonId: 'lsn_epidemics_vaccines_community_worship',
        title: 'أحكام اللقاحات الطبية وإلزاميتها ونوازل صلاة الجماعة',
        courseId: courseId,
        moduleId: 'mod_epidemics_quarantine_public_health',
        orderIndex: 3,
        sources: const ['src_majma_fiqhi_resolutions', 'src_hayat_kibar_ulama'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_epi_3_1',
            title: 'مشروعية اللقاحات وإلزاميتها',
            description: 'بيان الحكم الشرعي لأخذ اللقاحات الطبية المعتمدة وسلطة الدولة في إلزاميتها.',
          ),
          LearningObjective(
            objectiveId: 'obj_epi_3_2',
            title: 'نوازل صلاة الجماعة والمساجد',
            description: 'معرفة النوازل الفقهية المتعلقة بالتباعد في الصلاة، ولبس الكمام، وإغلاق المساجد مؤقتاً.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_epi_3_1',
            title: 'مشروعية اللقاحات الطبية وإلزاميتها لحماية المجتمع',
            contentType: LearningContentType.sourceText,
            content: 'أخذ اللقاحات الطبية المعتمدة من الجهات الصحية الموثوقة مشروع ومندوب شرعاً، وهو من باب التداوي الوقائي والأخذ بأسباب حفظ النفس التي هي إحدى الكليات الخمس. ويجوز لولي الأمر إلزام المواطنين والمقيمين بأخذ التطعيمات لحماية المجتمع وتحقيق مناعة القطيع، خاصة للفئات الأكثر عرضة للخطر أو العاملين في الوظائف العامة والحيوية، صيانة للنفس البشرية ودرءاً لانتشار الهلاك الجماعي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_3_1',
                evidenceKey: '2:195',
                citation: 'قوله تعالى: ﴿وَلَا تُلْقُوا بِأَيْدِيكُمْ إِلَى التَّهْلُكَةِ﴾ [البقرة: 195]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'قرار مجمع الفقه الإسلامي الدولي رقم 239 بشأن اللقاحات وفتاوى هيئة كبار العلماء',
          ),
          LessonSection.create(
            sectionId: 'sec_epi_3_2',
            title: 'النوازل الفقهية في صلاة الجماعة والمساجد وقت الأوبئة',
            contentType: LearningContentType.explanation,
            content: 'يجوز عند تفشي الأوبئة المعدية اتخاذ تدابير استثنائية في إقامة الشعائر: 1) جواز الصلاة بالكمامات وإحضار سجادة خاصة ولا كراهة في تغطية الفم للحاجة. 2) جواز التباعد بين المصلين في الصف الواحد لحفظ التباعد الجسدي، وتصح الصلاة مع فوات كمال التراص للعذر. 3) سقوط وجوب صلاة الجمعة والجماعة عن المريض والمخالط والمشتبه بإصابته، بل يحرم عليه ارتياد المسجد قياساً على أكل الثوم والبصل. 4) جواز تعليق صلاة الجمعة والجماعة مؤقتاً إذا تفاقم الخطر وخيف الهلاك العام.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_3_2',
                evidenceKey: 'bukhari:668',
                citation: 'حديث ابن عباس في فتح الباري: «أَنَّ النَّبِيَّ ﷺ قَالَ لِمُؤَذِّنِهِ فِي يَوْمٍ مَطِيرٍ: إِذَا قُلْتَ أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّهِ فَلَا تَقُلْ حَيَّ عَلَى الصَّلَاةِ قُلْ: صَلُّوا فِي بُيُوتِكُمْ» (متفق عليه)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وفتاوى المجمع الفقهي الإسلامي وهيئات الإفتاء الرسمية',
          ),
        ],
      ),

      // Lesson 16
      Lesson.create(
        lessonId: 'lsn_dispensations_medical_fasting_invalids',
        title: 'المفطرات الطبية المعاصرة وضوابط الصيام للمرضى',
        courseId: courseId,
        moduleId: 'mod_medical_dispensations_worship',
        orderIndex: 4,
        sources: const ['src_majma_fiqhi_resolutions', 'src_bukhari_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_epi_4_1',
            title: 'المفطرات الطبية المفسدة للصوم',
            description: 'معرفة المفطرات الطبية المتفق على تفطيرها (كالحقن المغذية والغسيل الكلوي).',
          ),
          LearningObjective(
            objectiveId: 'obj_epi_4_2',
            title: 'الإجراءات الطبية المعفو عنها',
            description: 'استيعاب الإجراءات الطبية غير المفطرة (كبخاخ الربو، قطرات العين، والحقن العضلية والوريدية غير المغذية).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_epi_4_1',
            title: 'المفطرات الطبية المتفق عليها في قرارات المجامع',
            contentType: LearningContentType.sourceText,
            content: 'حدد مجمع الفقه الإسلامي الدولي (القرار رقم 93) الإجراءات الطبية المفطرة للصائم بما يأتي: 1) الحقن المغذية (كالغلوكوز والمحاليل الوريدية المغذية) لأنها تقوم مقام الطعام والشراب في إمداد البدن بالغذاء والطاقة. 2) الغسيل الكلوي بنوعيه الدموي والبريتوني لما يصاحبه من تزويد الجسم بسوائل وأملاح ومواد مغذية. 3) دخول أي مادة جرمية أو دواء عن طريق الفم إلى المعدة استقراراً واختياراً كأقراص الدواء وشراب العلاج.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_4_1',
                evidenceKey: 'majma:res:93',
                citation: 'قرار مجمع الفقه الإسلامي الدولي رقم 93 (10/1) بشأن المفطرات في مجال التداوي',
                sourceId: 'src_majma_fiqhi_resolutions',
              ),
            ],
            sourceAttribution: 'مجلة مجمع الفقه الإسلامي الدولي الدورة العاشرة',
          ),
          LessonSection.create(
            sectionId: 'sec_epi_4_2',
            title: 'الأدوية والإجراءات الطبية التي لا تفسد الصوم',
            contentType: LearningContentType.explanation,
            content: 'قررت المجامع الفقهية وهيئات الفتوى الكبرى أن الإجراءات الطبية الآتية لا تفسد صيام الصائم: 1) قطرات العين، الأذن، وغسول الأذن ما لم تكن طبلة الأذن مخرومة وتنفذ إلى الحلق. 2) بخاخ الربو الموضعي الرذاذي لأنه غاز مضغوط يذهب إلى القصبات الهوائية ولا ينزل للمعدة منه إلا قدر يسير معفو عنه كالمتبقي من المضمضة. 3) الحقن العلاجية العضلية والوريدية والجلدية غير المغذية (كالأنسولين والبنسلين). 4) قلع الضرس، حشو الأسنان، والتخدير الموضعي. 5) التحاميل الشرجية والمناظير المهبلية وفحص عنق الرحم. 6) عينات الدم المسحوبة للتحليل المخبري.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_4_2',
                evidenceKey: 'qawaid:yaqeen_la_yazul',
                citation: 'القاعدة الفقهية: «اليقين بصحة الصيام لا يزول بالشك والشيء التابع المعفو عنه»',
                sourceId: 'src_majma_fiqhi',
              ),
            ],
            sourceAttribution: 'فتاوى ابن عثيمين وقرار مجمع الفقه الإسلامي بجدة رقم 93',
          ),
        ],
      ),

      // Lesson 17
      Lesson.create(
        lessonId: 'lsn_dispensations_illness_prayer_purification',
        title: 'رخص المرضى في الطهارة والصلاة والجمع',
        courseId: courseId,
        moduleId: 'mod_medical_dispensations_worship',
        orderIndex: 5,
        sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_fiqh_madhahib'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_epi_5_1',
            title: 'رخص الطهارة والجبائر',
            description: 'إتقان أحكام التيمم للمريض والمسح على الجبائر واللصقات الطبية والضمادات.',
          ),
          LearningObjective(
            objectiveId: 'obj_epi_5_2',
            title: 'هيئات صلاة المريض وضوابط الجمع',
            description: 'معرفة هيئات صلاة المريض (قاعداً، على جنب، مستلقياً) وضوابط الجمع بين الصلاتين.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_epi_5_1',
            title: 'رخص الطهارة والمسح على الجبائر واللصقات',
            contentType: LearningContentType.sourceText,
            content: 'شرع الله التيمم للمريض إذا خاف باستعمال الماء زيادة المرض أو تأخر البرء لقوله تعالى: ﴿وَإِن كُنتُم مَّرْضَىٰ أَوْ عَلَىٰ سَفَرٍ... فَتَيَمَّمُوا صَعِيدًا طَيِّبًا﴾. ويجوز المسح على الجبائر والضمادات واللصقات الطبية المشدودة على كسر أو جرح ما دامت الحاجة داعية إليها، ويجزئ المسح عليها بالماء بدلاً عن غسل ما تحتها، ولا يشترط في الجبيرة أن تكون وضعت على طهارة في الراجح دفعاً للحرج البالغ في الطوارئ.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_5_1',
                evidenceKey: '5:6',
                citation: 'قوله تعالى: ﴿مَا يُرِيدُ اللَّهُ لِيَجْعَلَ عَلَيْكُم مِّنْ حَرَجٍ وَلَٰكِن يُرِيدُ لِيُطَهِّرَكُمْ﴾ [المائدة: 6]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'المغني لابن قدامة والإنصاف للمرداوي وبداية المجتهد',
          ),
          LessonSection.create(
            sectionId: 'sec_epi_5_2',
            title: 'هيئات صلاة المريض وضوابط الجمع',
            contentType: LearningContentType.explanation,
            content: 'يصلي المريض قائماً، فإن لم يستطع فقاعداً، فإن لم يستطع فعلى جنبه، فإن لم يستطع فمستلقياً ورجلاه إلى القبلة، مومئاً برأسه في الركوع والسجود ويجعل سجوده أخفض من ركوعه لحديث عمران بن حصين في صحيح البخاري. ويجوز للمريض وللطبيب القائم على عملية جراحية حرجة تفوت وقت الصلاة الجمع بين الظهر والعصر، وبين المغرب والعشاء تقديماً أو تأخيراً بحسب الأرفق بحاله، دون قصر للصلوات الرباعية (إلا إذا كان المريض مسافراً أيضاً).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_5_2',
                evidenceKey: 'bukhari:1117',
                citation: 'حديث عمران بن حصين: «صَلِّ قَائِمًا، فَإِنْ لَمْ تَسْتَطِعْ فَقَاعِدًا، فَإِنْ لَمْ تَسْتَطِعْ فَعَلَى جَنْبٍ» (رواه البخاري)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري والمجموع شرح المهذب للنووي',
          ),
        ],
      ),

      // Lesson 18
      Lesson.create(
        lessonId: 'lsn_dispensations_hajj_medical_substitutions',
        title: 'الرخص الطبية والإنابة في مناسك الحج والعمرة',
        courseId: courseId,
        moduleId: 'mod_medical_dispensations_worship',
        orderIndex: 6,
        sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_fatawa_hajj'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_epi_6_1',
            title: 'الإنابة في الحج عن العاجز',
            description: 'معرفة شروط الاستنابة في الحج عن المريض الميؤوس من برئه (المعضوب).',
          ),
          LearningObjective(
            objectiveId: 'obj_epi_6_2',
            title: 'رخص المشقة في مناسك الحج',
            description: 'استيعاب رخص المشقة في الحج: طواف الراكب والمحمول، الإنابة في الرمي، وفدية الأذى.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_epi_6_1',
            title: 'الإنابة في الحج عن العاجز صحياً وعن الميت',
            contentType: LearningContentType.sourceText,
            content: 'من وجب عليه الحج واستقر في ذمته بوجود المال ثم عجز عنه عجزاً بدنياً لا يرجى زواله كالكبر المزمن والمرض المستحكم الذي لا يرجى شفاؤه (المعضوب)، وجب عليه أن ينيب من يحج عنه ويعتمر بماله، استناداً إلى حديث الخثعمية لما سألت النبي ﷺ: «إِنَّ أَبِي أَدْرَكَتْهُ فَرِيضَةُ اللَّهِ فِي الْحَجِّ شَيْخًا كَبِيرًا لَا يَسْتَوِي عَلَى الرَّاحِلَةِ، أَفَأَحُجُّ عَنْهُ؟ قَالَ: نَعَمْ». ويشترط في النائب أن يكون قد حج عن نفسه أولاً.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_6_1',
                evidenceKey: 'bukhari:1513',
                citation: 'حديث ابن عباس في قصة الخثعمية (متفق عليه في الصحيحين)',
                sourceId: 'src_hadith_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وصحيح مسلم ومجموع فتاوى ابن عثيمين',
          ),
          LessonSection.create(
            sectionId: 'sec_epi_6_2',
            title: 'رخص أداء المناسك للمرضى وأصحاب الأعذار',
            contentType: LearningContentType.explanation,
            content: 'يسرت الشريعة للمريض أداء مناسك الحج: 1) جواز الطواف والسعي راكباً أو محمولاً على الكراسي المتحركة أو العربات الكهربائية. 2) جواز التوكيل في رمي الجمار لمن عجز عن الرمي بنفسه لمرض أو عجز أو زحام مهلك، ويرمي الوكيل عن نفسه ثم عن موكله في الموقف ذاته. 3) جواز حلق الرأس للمحرم لعلة برأسه مع إخراج فدية الأذى (صيام ثلاثة أيام أو إطعام ستة مساكين أو ذبح شاة): ﴿فَمَن كَانَ مِنكُم مَّرِيضًا أَوْ بِهِ أَذًى مِّن رَّأْسِهِ فَفِدْيَةٌ﴾. 4) سقوط طواف الوداع عن المرأة الحائض والنفساء وعن المريض المحتاج إلى سرعة النقل الطبي العاجل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_epi_6_2',
                evidenceKey: '2:196',
                citation: 'قوله تعالى: ﴿فَمَن كَانَ مِنكُم مَّرِيضًا أَوْ بِهِ أَذًى مِّن رَّأْسِهِ فَفِدْيَةٌ مِّن صِيَامٍ أَوْ صَدَقَةٍ أَوْ نُسُكٍ﴾ [البقرة: 196]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'صحيح البخاري وكتاب الحج من المغني لابن قدامة',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: فقه الأوبئة والحجر الصحي
    final q1 = QuizQuestion.create(
      questionId: 'q_epi_1',
      lessonId: 'lsn_epidemics_prophetic_prevention_contagion',
      questionText: 'ما هو الأصل التشريعي النبوي الصريح في تأسيس نظام «الحجر الصحي الإقليمي» وقت الطاعون؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qe1_1', text: 'قوله ﷺ: «إذا سمعتم به بأرض فلا تدخلوها، وإذا وقع بأرض وأنتم بها فلا تخرجوا منها فراراً منه»'),
        QuizOption(optionId: 'opt_qe1_2', text: 'قوله ﷺ: «عليكم بالشفاءين العسل والقرآن»'),
        QuizOption(optionId: 'opt_qe1_3', text: 'قوله ﷺ: «تداووا ولا تتداووا بحرام»'),
      ],
      correctOptionIndices: const [0],
      explanation: 'هذا الحديث الصحيح هو أصل علم الوبائيات والحجر الصحي بمنع دخول السالمين إلى بؤرة الوباء وخروج المخالطين منها.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_epidemics_quarantine_public_health',
      lessonId: 'lsn_epidemics_prophetic_prevention_contagion',
      title: 'اختبار تقييم استيعاب فقه الأوبئة والطب الوقائي والحجر الصحي ونوازل العبادات',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: الرخص الطبية في الصيام والصلاة والحج
    final q2 = QuizQuestion.create(
      questionId: 'q_epi_2',
      lessonId: 'lsn_dispensations_medical_fasting_invalids',
      questionText: 'أي من الإجراءات الطبية التالية يعد مفسداً ومفطراً للصيام وفق قرارات المجامع الفقهية الكبرى؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qe2_1', text: 'الحقن الوريدية المغذية (محلول الغلوكوز) والغسيل الكلوي'),
        QuizOption(optionId: 'opt_qe2_2', text: 'بخاخ الربو الموضعي الرذاذي المستنشق في القصبات الهوائية'),
        QuizOption(optionId: 'opt_qe2_3', text: 'قطرة العين وقطرة الأذن التي لا تصل للجوف'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الحقن المغذية تفسد الصوم لأنها تقوم مقام الأكل والشرب في تغذية الجسم، بخلاف البخاخات والقطرات والحقن العلاجية غير المغذية.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_medical_dispensations_worship',
      lessonId: 'lsn_dispensations_medical_fasting_invalids',
      title: 'اختبار تقييم استيعاب الرخص الفقهية الطبية في الصيام والصلاة والحج',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
