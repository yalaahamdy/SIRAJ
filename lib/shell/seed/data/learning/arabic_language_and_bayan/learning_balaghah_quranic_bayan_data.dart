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

/// بيانات مقرر علوم البلاغة القرآنية والإعجاز البياني والأسلوبي (6 دروس تأصيلية + اختباران استيعاب)
class LearningBalaghahQuranicBayanData {
  static const String courseId = 'course_balaghah_quranic_bayan';
  static const String pathId = 'path_arabic_language_bayan_semantics_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر علوم البلاغة القرآنية والإعجاز البياني والأسلوبي',
      description: 'دراسة تأصيلية موسعة لعلوم البلاغة الثلاثة: علم المعاني (النظم، الخبر والإنشاء، التقديم والحذف، القصر)، علم البيان (التشبيه، الاستعارة، الكناية، المجاز المرسل)، وعلم البديع (المحسنات المعنوية واللفظية)، مع التطبيق على دقائق الإعجاز البياني والتصوير الفني في القرآن الكريم ونظرية النظم للجرجاني.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_balaghah_ilm_al_maani', 'mod_balaghah_bayan_badi_ijaz'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_balaghah_ilm_al_maani',
        courseId: courseId,
        title: 'علم المعاني ودقائق النظم القرآني وأسرار التراكيب',
        description: 'مفهوم الفصاحة والبلاغة، نظرية النظم عند عبد القاهر الجرجاني، أحكام الخبر والإنشاء ودلالاتهما التشريعية، وأسرار التقديم والتأخير والحذف والذكر والقصر في القرآن.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_balaghah_fasaahah_balaghah_foundations',
          'lsn_balaghah_khabar_insha_quran',
          'lsn_balaghah_taqdim_hathf_qasr',
        ],
      ),
      CourseModule(
        moduleId: 'mod_balaghah_bayan_badi_ijaz',
        courseId: courseId,
        title: 'علما البيان والبديع ووجوه الإعجاز التصويري والأسلوبي',
        description: 'دراسة التشبيه القرآني والاستعارات التمثيلية، الكناية والمجاز المرسل، المحسنات البديعية المعنوية واللفظية، وتناسب الفواصل ورسوخ إعجاز القرآن البياني.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_balaghah_ilm_al_maani'],
        lessonIds: const [
          'lsn_balaghah_tashbih_istiarah_imagery',
          'lsn_balaghah_kinayah_majaz_mursal',
          'lsn_balaghah_badi_wujooh_ijaz',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 1: الفصاحة والبلاغة ونظرية النظم
      Lesson.create(
        lessonId: 'lsn_balaghah_fasaahah_balaghah_foundations',
        title: 'حد الفصاحة والبلاغة ومفهوم النظم عند الإمام عبد القاهر الجرجاني',
        courseId: courseId,
        moduleId: 'mod_balaghah_ilm_al_maani',
        orderIndex: 1,
        sources: const ['src_dalail_al_ijaz', 'src_asrar_al_balaghah', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_balagh_1_1',
            title: 'شروط فصاحة الكلمة والكلام',
            description: 'سلامة الكلمة من تنافر الحروف ومخالفة القياس والغرابة، وسلامة الكلام من ضعف التأليف والتعقيد اللفظي والمعنوي.',
          ),
          LearningObjective(
            objectiveId: 'obj_balagh_1_2',
            title: 'استيعاب نظرية النظم عند الجرجاني',
            description: 'إدراك أن البلاغة ليست في الألفاظ المفردة ولا المعاني المجردة، بل في توخي معاني النحو وتلاقي الكلمات في نسق تركيبي فريد.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_balagh_1_1',
            title: 'حقيقة الفصاحة ومطابقة الكلام لمقتضى الحال',
            contentType: LearningContentType.sourceText,
            content: 'الفصاحة في أصل اللغة هي الظهور والبيان؛ يقال: أفصح الصبح إذا أضاء. وفصاحة الكلام سلامته من تنافر الحروف وضعف التأليف والتعقيد. أما البلاغة فهي مطابقة الكلام الفصيح لمقتضى حال المخاطبين مع فصاحته؛ فحال المنكر يقتضي التوكيد، وحال المتردد يقتضي الاستحسان، وحال الخالي الذهن يقتضي الإلقاء بغير مؤكدات. والبلاغة القرآنية معجزة لأنها بلغت الغاية القصوى في وفاء كل كلمة بمقتضى الحال العقدي والتشريعي والنفسي الذي لا يبلغه كلام البشر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_1_1',
                evidenceKey: 'talkhis_miftah:qazwini:muqaddimah',
                citation: 'تلخيص المفتاح للخطيب القزويني والإيضاح في علوم البلاغة',
                sourceId: 'src_dalail_al_ijaz',
              ),
            ],
            sourceAttribution: 'مفتاح العلوم للسكاكي والإيضاح للقزويني ودلائل الإعجاز للجرجاني',
          ),
          LessonSection.create(
            sectionId: 'sec_balagh_1_2',
            title: 'نظرية النظم العبقرية عند الإمام عبد القاهر الجرجاني',
            contentType: LearningContentType.explanation,
            content: 'قرر الإمام عبد القاهر الجرجاني في «دلائل الإعجاز» أن إعجاز القرآن الكريم يكمن في "النظم"؛ وهو: «توخي معاني النحو وأحكامه فيما بين الكلم على حسب الأغراض التي يصاغ لها الكلام». فالألفاظ لا تتفاضل من حيث هي مفردات معجمية، وإنما تتفاضل بالملائمة والتعليق الإسنادي والترتيب الذي تقتضيه المعاني النفسية الدقيقة. فإذا وضعت الكلمة في موضعها بحيث لو حذفت أو استبدلت باختل المعنى أو قصر البيان، تحقق النظم الإعجازي الذي تحدى الله به فصحاء العرب فعجزوا.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_1_2',
                evidenceKey: 'dalail_ijaz:jurjani:fasl_nazm',
                citation: 'دلائل الإعجاز للإمام عبد القاهر الجرجاني (فصل في حقيقة النظم)',
                sourceId: 'src_dalail_al_ijaz',
              ),
            ],
            sourceAttribution: 'دلائل الإعجاز وأسرار البلاغة للإمام عبد القاهر الجرجاني',
          ),
        ],
      ),

      // Lesson 2: الخبر والإنشاء
      Lesson.create(
        lessonId: 'lsn_balaghah_khabar_insha_quran',
        title: 'أسلوبا الخبر والإنشاء وأغراضهما البلاغية والتشريعية في القرآن',
        courseId: courseId,
        moduleId: 'mod_balaghah_ilm_al_maani',
        orderIndex: 2,
        sources: const ['src_talkhis_qazwini', 'src_al_burhan_zarkashi', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_balagh_2_1',
            title: 'التمييز بين الخبر والإنشاء الطلبي وغير الطلبي',
            description: 'فهم أضرب الخبر (الابتدائي، الطلبي، الإنكاري) وصيغ الإنشاء (الأمر، النهي، الاستفهام، التمني، والنداء).',
          ),
          LearningObjective(
            objectiveId: 'obj_balagh_2_2',
            title: 'خروج الخبر والإنشاء عن معناهما الأصلي لأغراض تشريعية',
            description: 'إدراك مجيء الخبر بمعنى الأمر والوجوب كقوله تعالى: ﴿وَالْمُطَلَّقَاتُ يَتَرَبَّصْنَ﴾ وأثره في التأكيد والقطع.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_balagh_2_1',
            title: 'أضرب الخبر ومراعاة حال المخاطب في القرآن',
            contentType: LearningContentType.sourceText,
            content: 'الخبر كلام يحتمل الصدق والكذب لذاته، وينقسم باعتبار المخاطب إلى ثلاثة أضرب: 1. ابتدائي: يلقى لخالي الذهن مجرداً عن التوكيد ﴿الْمَالُ وَالْبَنُونَ زِينَةُ الْحَيَاةِ الدُّنْيَا﴾. 2. طلبي: يلقى للشاك المتردد مؤكداً بمؤكد واحد ﴿إِنَّ رَبَّكَ لَبِالْمِرْصَادِ﴾. 3. إنكاري: يلقى للجاحد المنكر مؤكداً بمؤكدين فأكثر بحسب درجة إنكاره كقوله تعالى لرسل أنطاكية حين كذبوا أولاً: ﴿إِنَّا إِلَيْكُم مُّرْسَلُونَ﴾، فلما اشتد إنكارهم قالوا: ﴿رَبُّنَا يَعْلَمُ إِنَّا إِلَيْكُمْ لَمُرْسَلُونَ﴾ بالقسم وإنّ واللام.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_2_1',
                evidenceKey: 'quran:36:14-16',
                citation: 'سورة يس: الآيات 14 إلى 16',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'تلخيص المفتاح للقزويني والبرهان في علوم القرآن للزركشي',
          ),
          LessonSection.create(
            sectionId: 'sec_balagh_2_2',
            title: 'خروج الإنشاء والخبر إلى المعاني البلاغية والتشريعية الدقيقة',
            contentType: LearningContentType.explanation,
            content: 'يخرج الخبر عن معناه إلى الإنشاء لإفادة الطلب المؤكد كقوله تعالى: ﴿وَالْمُطَلَّقَاتُ يَتَرَبَّصْنَ بِأَنفُسِهِنَّ ثَلاثَةَ قُرُوءٍ﴾؛ أتى بصيغة الخبر في معرض التشريع للدلالة على أن هذا الأمر حتمي لا مفر منه حتى لكأنه قد وقع واستقر فصار خبراً يُحدّث به! وكذا خروج الأمر عن الوجوب إلى الإباحة (﴿وَإِذَا حَلَلْتُمْ فَاصْطَادُواْ﴾)، أو التعجيز (﴿فَأْتُواْ بِسُورَةٍ مِّن مِّثْلِهِ﴾)، وخروج الاستفهام إلى التقرير والتوبيخ والتعظيم.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_2_2',
                evidenceKey: 'quran:2:228',
                citation: 'سورة البقرة: الآية 228',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'التحرير والتنوير لابن عاشور والكشاف للزمخشري',
          ),
        ],
      ),

      // Lesson 3: التقديم والحذف والقصر
      Lesson.create(
        lessonId: 'lsn_balaghah_taqdim_hathf_qasr',
        title: 'التقديم والتأخير، الذكر والحذف، وأساليب القصر والحصر ومقاصدها',
        courseId: courseId,
        moduleId: 'mod_balaghah_ilm_al_maani',
        orderIndex: 3,
        sources: const ['src_dalail_al_ijaz', 'src_itqan_suyuti', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_balagh_3_1',
            title: 'أسرار التقديم والتأخير في النظم القرآني',
            description: 'فهم أغراض التقديم: الاختصاص، التشريف، التعجيل بالمسرة أو المساءة، ومراعاة الفواصل.',
          ),
          LearningObjective(
            objectiveId: 'obj_balagh_3_2',
            title: 'بلاغة الحذف وطرق القصر وحصر التوحيد',
            description: 'إدراك حكمة الإيجاز بالحذف وطرق القصر الأربعة (إنما، النفي والاستثناء، العطف، وتقديم ما حقه التأخير).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_balagh_3_1',
            title: 'أسرار التقديم والتأخير وأثرها في التوحيد والتشريع',
            contentType: LearningContentType.sourceText,
            content: 'الأصل في الجملة أن يتقدم العامل على المعمول والمسند إليه على المسند؛ فإذا خولف هذا الترتيب دل على سر بلاغي جليل: فتقديم المعمول يفيد الاختصاص والحصر قطعاً كقوله تعالى: ﴿إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ﴾؛ إذ لو قيل (نعبدك ونستعينك) لم يمتنع أن يعبد معه غيره، فلما قيل (إياك نعبد) انحصرت العبادة في الله وحده. وكذا تقديم الجار والمجرور في قوله: ﴿إِلَى اللَّهِ تُرْجَعُ الأُمُورُ﴾ لإبطال مزاعم الشركاء وإثبات انفراد الله بالقضاء والملك.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_3_1',
                evidenceKey: 'quran:1:5',
                citation: 'سورة الفاتحة: الآية 5',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'دلائل الإعجاز للجرجاني ومفاتيح الغيب لفخر الدين الرازي',
          ),
          LessonSection.create(
            sectionId: 'sec_balagh_3_2',
            title: 'بلاغة الحذف وأساليب القصر الأربعة في القرآن الكريم',
            contentType: LearningContentType.explanation,
            content: 'الحذف في القرآن أبلغ من الذكر؛ لأنه يفتح للذهن آفاقاً واسعة من التدبر وتقدير العظمة كحذف مفعول المشيئة إذا كان المعنى معلوماً (﴿فَلَوْ شَاءَ لَهَدَاكُمْ أَجْمَعِينَ﴾ أي لو شاء هدايتكم)، وحذف جواب لو للتفخيم والتهويل ﴿وَلَوْ تَرَى إِذْ وُقِفُواْ عَلَى النَّارِ﴾ (أي لرأيت أمراً فظيعاً لا يحيط به الوصف). أما القصر فطرقـه المشهورة في القرآن: 1. النفي والاستثناء (﴿وَمَا مِن إِلَهٍ إِلاَّ اللَّهُ﴾). 2. إنما (﴿إِنَّمَا إِلَهُكُمُ اللَّهُ﴾). 3. تقديم ما حقه التأخير (﴿لِلَّهِ الأَمْرُ مِن قَبْلُ وَمِن بَعْدُ﴾).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_3_2',
                evidenceKey: 'quran:6:27',
                citation: 'سورة الأنعام: الآية 27',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الإتقان في علوم القرآن للسيوطي والبرهان للزركشي',
          ),
        ],
      ),

      // Lesson 4: التشبيه والاستعارة والتصوير الفني
      Lesson.create(
        lessonId: 'lsn_balaghah_tashbih_istiarah_imagery',
        title: 'التشبيه القرآني والاستعارة التصريحية والمكنية والتصوير الفني',
        courseId: courseId,
        moduleId: 'mod_balaghah_bayan_badi_ijaz',
        orderIndex: 4,
        sources: const ['src_asrar_al_balaghah', 'src_taswir_fanni_sayyid', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_balagh_4_1',
            title: 'أركان وأنواع التشبيه القرآني',
            description: 'فهم التشبيه البليغ، التشبيه التمثيلي، والتشبيه الضمني، وأثرها في تقريب المعاني الغيبية إلى الأذهان.',
          ),
          LearningObjective(
            objectiveId: 'obj_balagh_4_2',
            title: 'أسرار الاستعارة والتصوير الفني الحي',
            description: 'التمييز بين الاستعارة التصريحية والمكنية والتمثيلية، وكيف يحيل القرآن المعاني المجردة إلى شخوص متحركة ومشاهد مرئية.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_balagh_4_1',
            title: 'التشبيه التمثيلي القرآني وإبراز الحقائق المعنوية',
            contentType: LearningContentType.sourceText,
            content: 'التشبيه في القرآن الكريم ليس ترفاً لفظياً بل وسيلة تربوية برهانية هادية؛ وأعلاه التشبيه التمثيلي الذي يكون وجه الشبه فيه صورة منتزعة من متعدد كقوله تعالى في مثل المنفقين رياءً: ﴿فَمَثَلُهُ كَمَثَلِ صَفْوَانٍ عَلَيْهِ تُرَابٌ فَأَصَابَهُ وَابِلٌ فَتَرَكَهُ صَلْداً لاَّ يَقْدِرُونَ عَلَى شَيْءٍ مِّمَّا كَسَبُواْ﴾؛ فمثل عمل المرائي بحجر أملس رقيق التراب جاءه مطر غزير فمحا أثره وأبقاه صلداً لا ينبت شيئاً، فجسّد هباء الرياء في صورة بصرية مدهشة تخلب الألباب وتستقر في الوجدان.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_4_1',
                evidenceKey: 'quran:2:264',
                citation: 'سورة البقرة: الآية 264',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'أسرار البلاغة للجرجاني والتصوير الفني في القرآن',
          ),
          LessonSection.create(
            sectionId: 'sec_balagh_4_2',
            title: 'الاستعارة المكنية والتصريحية ودب الحياة في الجمادات والمعنويات',
            contentType: LearningContentType.explanation,
            content: 'الاستعارة تشبيه حذف أحد طرفيه مع قرينة مانعة من إرادة المعنى الأصلي؛ وتتجلى قمة الإعجاز البياني في الاستعارة المكنية التي تخلع الحياة والحركة على الجماد كقوله تعالى: ﴿وَالصُّبْحِ إِذَا تَنَفَّسَ﴾؛ حيث استعار للصبح التنفس كأنه كائن حي يستيقظ ويملأ الأفق نضارة وضياءً، وقوله: ﴿وَاخْفِضْ لَهُمَا جَنَاحَ الذُّلِّ مِنَ الرَّحْمَةِ﴾ شبه الذل بطائر وديع له جناح يُخفض استكانةً وبراً بالوالدين، وكذا الاستعارة التصريحية في قوله: ﴿لِتُخْرِجَ النَّاسَ مِنَ الظُّلُمَاتِ إِلَى النُّورِ﴾ حيث استعار الظلمات للكفر والضلال والنور للإيمان والهدى.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_4_2',
                evidenceKey: 'quran:81:18',
                citation: 'سورة التكوير: الآية 18',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'أسرار البلاغة للجرجاني والكشاف للزمخشري والتلخيص للقزويني',
          ),
        ],
      ),

      // Lesson 5: الكناية والمجاز المرسل
      Lesson.create(
        lessonId: 'lsn_balaghah_kinayah_majaz_mursal',
        title: 'الكناية والتعريض والمجاز المرسل وعلاقاته في نصوص الوحي',
        courseId: courseId,
        moduleId: 'mod_balaghah_bayan_badi_ijaz',
        orderIndex: 5,
        sources: const ['src_asrar_al_balaghah', 'src_al_burhan_zarkashi', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_balagh_5_1',
            title: 'الكناية القرآنية وأدب الخطاب الرفيع',
            description: 'معرفة أقسام الكناية (عن صفة، أو موصوف، أو نسبة)، وأدب التعبير القرآني بالكناية عن الجماع وقضاء الحاجة.',
          ),
          LearningObjective(
            objectiveId: 'obj_balagh_5_2',
            title: 'المجاز المرسل وعلاقاته وأثره في استنباط الأحكام',
            description: 'استيعاب علاقات المجاز المرسل (الكلية والجزئية، والسببية والمسببية، واعتبار ما كان وما سيكون).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_balagh_5_1',
            title: 'الكناية القرآنية والأدب الإلهي السامي في التعبير',
            contentType: LearningContentType.sourceText,
            content: 'الكناية لفظ أطلق وأريد به لازم معناه مع جواز إرادة المعنى الأصلي؛ وتمتاز الكناية القرآنية بالطهارة والعفة المطلقة والأدب الرفيع؛ حيث كنى القرآن عن الجماع بالملامسة والمس والمباشرة والإفضاء والتغشي واللباس (﴿هُنَّ لِبَاسٌ لَّكُمْ وَأَنتُمْ لِبَاسٌ لَّهُنَّ﴾)، وكنى عن قضاء الحاجة بالمجيء من الغائط أو أكل الطعام في حق عيسى وأمه ﴿كَانَا يَأْكُلانِ الطَّعَامَ﴾ لنفي الألوهية عنهما بكناية بليغة تفيد حاجتهما البشرية وما يتبع أكل الطعام.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_5_1',
                evidenceKey: 'quran:5:75',
                citation: 'سورة المائدة: الآية 75',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'أسرار البلاغة للجرجاني والبرهان في علوم القرآن للزركشي',
          ),
          LessonSection.create(
            sectionId: 'sec_balagh_5_2',
            title: 'المجاز المرسل وعلاقاته المشهورة في آيات الأحكام',
            contentType: LearningContentType.explanation,
            content: 'المجاز المرسل كلمة استعملت في غير ما وضعت له لعلاقة غير المشابهة مع قرينة مانعة. ومن أشهر علاقاته القرآنية: 1. الجزئية: إطلاق الجزء وإرادة الكل كإطلاق (الرقبة) في الكفارات وإرادة العبد الكامل ﴿فَتَحْرِيرُ رَقَبَةٍ﴾، وإطلاق (الركوع والسجود) وإرادة الصلاة كلها. 2. الكلية: كقوله ﴿يَجْعَلُونَ أَصَابِعَهُمْ فِي آذَانِهِم﴾ والمراد الأنامل. 3. اعتبار ما كان: كقوله ﴿وَآتُواْ الْيَتَامَى أَمْوَالَهُمْ﴾؛ أي الذين كانوا يتامى وبلغوا الرشد؛ لأن اليتيم قبل البلوغ لا يدفع إليه ماله. 4. اعتبار ما سيكون: كقوله ﴿إِنِّي أَرَانِي أَعْصِرُ خَمْراً﴾ أي عنباً يؤول إلى خمر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_5_2',
                evidenceKey: 'quran:4:2',
                citation: 'سورة النساء: الآية 2',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'مفتاح العلوم للسكاكي وشرح التلخيص وشرح الكوكب المنير في الأصول',
          ),
        ],
      ),

      // Lesson 6: البديع ووجوه الإعجاز
      Lesson.create(
        lessonId: 'lsn_balaghah_badi_wujooh_ijaz',
        title: 'المحسنات البديعية المعنوية واللفظية، والتناسب الفاصل، ووجوه إعجاز القرآن',
        courseId: courseId,
        moduleId: 'mod_balaghah_bayan_badi_ijaz',
        orderIndex: 6,
        sources: const ['src_itqan_suyuti', 'src_ijaz_al_quran_baqillani', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_balagh_6_1',
            title: 'إتقان المحسنات المعنوية واللفظية',
            description: 'فهم الطباق والمقابلة والتورية ومراعاة النظير (المعنوية)، والجناس وتناسب الفواصل والسجع المتجرد من التكلف (اللفظية).',
          ),
          LearningObjective(
            objectiveId: 'obj_balagh_6_2',
            title: 'وجوه الإعجاز البلاغي والأسلوبي القرآني',
            description: 'استيعاب كيف تجتمع الفصاحة المطلقة مع سمو المعنى والتشريع المحكم دون تفاوت أو خلل في طول القرآن الكريم وعرضه.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_balagh_6_1',
            title: 'المحسنات البديعية المعنوية واللفظية في خدمة جلال المعنى',
            contentType: LearningContentType.sourceText,
            content: 'علم البديع ينقسم إلى محسنات معنوية ومحسنات لفظية؛ وفي القرآن الكريم لا يأتي البديع زخرفاً متكلفاً بل يجيء تابعاً للمعنى خادماً له: فالطباق يجمع بين الضدين كقوله ﴿وَأَنَّهُ هُوَ أَضْحَكَ وَأَبْكَى * وَأَنَّهُ هُوَ أَمَاتَ وَأَحْيَا﴾ لبيان انفراد الله بالقدرة المطلقة، والمقابلة تجمع أضداداً بأضداد كقوله في صفة النبي ﷺ: ﴿يُحِلُّ لَهُمُ الطَّيِّبَاتِ وَيُحَرِّمُ عَلَيْهِمُ الْخَبَائِثَ﴾، ومراعاة النظير جمع الشيء مع ما يناسبه ﴿الشَّمْسُ وَالْقَمَرُ بِحُسْبَانٍ * وَالنَّجْمُ وَالشَّجَرُ يَسْجُدَانِ﴾، وتناسب الفواصل القرآنية نغم وإيقاع صوتي مهيب يأخذ بالقلوب دون سجع متكلف.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_6_1',
                evidenceKey: 'quran:7:157',
                citation: 'سورة الأعراف: الآية 157',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الإتقان في علوم القرآن للسيوطي والبرهان للزركشي',
          ),
          LessonSection.create(
            sectionId: 'sec_balagh_6_2',
            title: 'وجوه الإعجاز البياني القرآني المعجز للخلق كافة',
            contentType: LearningContentType.explanation,
            content: 'الإعجاز البياني للقرآن الكريم أعظم وجوه الإعجاز؛ وهو المعجزة الباقية الخالدة الدالة على نبوة محمد ﷺ وصدق رسالته. ومن أعظم مظاهره: 1. روعة النظم وجزالة الألفاظ واتساق الحروف. 2. جريان الكلام على نسق واحد من العلو والجمال مع تنوع الموضوعات بين قصص، وأحكام شرعية جافة، ووعيد، وترغيب، وبراهين عقلية دون أدنى هبوط أسلوبي. 3. الإيجاز غير المخل والإطناب غير الممل. 4. الإقناع العقلي الممزوج بالإثارة الوجدانية، بحيث إذا سمعه العربي القح ملك جوارحه كما قال الوليد بن المغيرة: «والله إن لقوله لحلاوة، وإن عليه لطلاوة، وإنه ليعلو وما يُعلى عليه».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_balagh_6_2',
                evidenceKey: 'baqillani:ijaz_quran:bab_fasahah',
                citation: 'إعجاز القرآن للقاضي أبي بكر الباقلاني ودلائل النبوة للبيهقي',
                sourceId: 'src_ijaz_al_quran_baqillani',
              ),
            ],
            sourceAttribution: 'إعجاز القرآن للباقلاني والرسالة الخطابية للخطابي والتحرير والتنوير',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    return [
      Quiz.create(
        quizId: 'quiz_balaghah_ilm_al_maani',
        lessonId: 'lsn_balaghah_taqdim_hathf_qasr',
        title: 'اختبار تقييم استيعاب: علم المعاني ونظرية النظم وأساليب التقديم والحذف والقصر',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_balagh_1',
            lessonId: 'lsn_balaghah_taqdim_hathf_qasr',
            questionText: 'ما جوهر نظرية النظم عند الإمام عبد القاهر الجرجاني في دلائل الإعجاز؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qbl1_1', text: 'أن البلاغة تكمن في توخي معاني النحو وأحكامه وتناسق الكلمات وفق المعاني المرادة وليست في الألفاظ المفردة مجردة'),
              QuizOption(optionId: 'opt_qbl1_2', text: 'أن الفصاحة تكون في اختيار الكلمات الغريبة المجهولة لعامة الناس'),
              QuizOption(optionId: 'opt_qbl1_3', text: 'أن البلاغة تختص فقط بنهايات الآيات والقوافي الشعرية'),
              QuizOption(optionId: 'opt_qbl1_4', text: 'أن الألفاظ معزولة تماماً عن المعاني ولا أثر للتركيب النحوي فيها'),
            ],
            correctOptionIndices: const [0],
            explanation: 'أثبت الجرجاني أن الإعجاز ليس في الألفاظ المفردة ولا في المعاني المجردة وإنما في النظم؛ وهو ترتيب الألفاظ وفق مقتضيات معاني النحو.',
          ),
          QuizQuestion.create(
            questionId: 'q_balagh_2',
            lessonId: 'lsn_balaghah_taqdim_hathf_qasr',
            questionText: 'ما الفائدة البلاغية والتشريعية في قوله تعالى: ﴿وَالْمُطَلَّقَاتُ يَتَرَبَّصْنَ بِأَنفُسِهِنَّ﴾ بصيغة الخبر؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qbl2_1', text: 'إخراج الخبر إلى معنى الأمر المؤكد لتقرير وجوب التربص كأنه أمر واقع لا محالة مفروغ منه'),
              QuizOption(optionId: 'opt_qbl2_2', text: 'الإخبار المجرد عن حال نساء قريش دون تشريع للأمة'),
              QuizOption(optionId: 'opt_qbl2_3', text: 'التخيير للمطلقة بين التربص أو عدمه'),
              QuizOption(optionId: 'opt_qbl2_4', text: 'مجرد أسلوب إنشائي للنهي عن الزواج مطلقاً'),
            ],
            correctOptionIndices: const [0],
            explanation: 'مجيء الخبر بمعنى الأمر يفيد تأكيد الوجوب والمبالغة في امتثاله، حتى لكأنه واقع مفروغ منه يخبر عنه.',
          ),
        ],
      ),
      Quiz.create(
        quizId: 'quiz_balaghah_bayan_badi_ijaz',
        lessonId: 'lsn_balaghah_badi_wujooh_ijaz',
        title: 'اختبار تقييم استيعاب: البيان والبديع والكناية ووجوه إعجاز القرآن',
        passingScorePercentage: 75,
        questions: [
          QuizQuestion.create(
            questionId: 'q_balagh_3',
            lessonId: 'lsn_balaghah_badi_wujooh_ijaz',
            questionText: 'ما علاقة المجاز المرسل في قوله تعالى: ﴿وَآتُواْ الْيَتَامَى أَمْوَالَهُمْ﴾؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qbl3_1', text: 'اعتبار ما كان؛ أي آتوا الذين كانوا يتامى قبل بلوغهم الرشد'),
              QuizOption(optionId: 'opt_qbl3_2', text: 'المجاز بالمشابهة والاستعارة التصريحية'),
              QuizOption(optionId: 'opt_qbl3_3', text: 'علاقة الحالية والمحلية'),
              QuizOption(optionId: 'opt_qbl3_4', text: 'علاقة السببية والمسببية'),
            ],
            correctOptionIndices: const [0],
            explanation: 'اليتيم في الشرع من فقد أباه وهو دون البلوغ، ولا يدفع المال لغير الراشد، فالتعبير باليتامى هنا مجاز مرسل علاقته اعتبار ما كان.',
          ),
          QuizQuestion.create(
            questionId: 'q_balagh_4',
            lessonId: 'lsn_balaghah_badi_wujooh_ijaz',
            questionText: 'ما نوع الاستعارة البديعة في قوله تعالى: ﴿وَالصُّبْحِ إِذَا تَنَفَّسَ﴾؟',
            questionType: QuestionType.multipleChoice,
            options: const [
              QuizOption(optionId: 'opt_qbl4_1', text: 'استعارة مكنية؛ حيث شبه الصبح بكائن حي يتنفس وحذف المشبه به ورمز له بشيء من لوازمه (تنفس)'),
              QuizOption(optionId: 'opt_qbl4_2', text: 'تشبيه بليغ صريح مذكور الطرفين والأداة'),
              QuizOption(optionId: 'opt_qbl4_3', text: 'مجاز مرسل علاقته الكلية والجزئية'),
              QuizOption(optionId: 'opt_qbl4_4', text: 'محسن بديعي لفظي خاص بالسجع الجاهلي'),
            ],
            correctOptionIndices: const [0],
            explanation: 'استعارة مكنية رائعة تخلع الحياة والحركة على انبلاج الصبح، حيث شبه بالحيوان وتنفسه عند الاستيقاظ فبث فيه الحياة.',
          ),
        ],
      ),
    ];
  }
}
