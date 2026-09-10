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

/// بيانات مقرر أصول وتاريخ المذاهب الفقهية الأربعة المتبوعة (6 دروس تأصيلية + اختباران استيعاب)
class LearningFourMadhahibHistoryData {
  static const String courseId = 'course_four_madhahib_history_principles';
  static const String pathId = 'path_madhahib_history_ijtihad_imams_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر أصول وتاريخ المذاهب الفقهية الأربعة المتبوعة',
      description: 'دراسة تأصيلية تاريخية لنشأة وتطور المذاهب الفقهية الأربعة المتبوعة: الحنفي والمالكي والشافعي والحنبلي، معالم أصول الاستنباط في كل مذهب، موازنة مدرستي الرأي والأثر، والكتب المعتمدة وأسباب استقرار المذاهب وإجماع الأمة على قبولها.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_hanafi_maliki_foundations', 'mod_shafii_hanbali_foundations'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_hanafi_maliki_foundations',
        courseId: courseId,
        title: 'الوحدة الأولى: المذهبان الحنفي والمالكي (مدرسة الرأي ومدرسة الأثر)',
        description: 'نشأة المذهب الحنفي في الكوفة وأصول الاستنباط عند أبي حنيفة وتلاميذه، ونشأة المذهب المالكي في المدينة المنورة وأصوله من عمل أهل المدينة والمصالح وسد الذرائع، والموازنة والتكامل بين مدرستي الرأي والحديث.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_madhahib_hanafi_school_foundations',
          'lsn_madhahib_maliki_school_foundations',
          'lsn_madhahib_ray_vs_athar_synthesis',
        ],
      ),
      CourseModule(
        moduleId: 'mod_shafii_hanbali_foundations',
        courseId: courseId,
        title: 'الوحدة الثانية: المذهبان الشافعي والحنبلي والموسوعية الأصولية واستقرار المذاهب',
        description: 'المذهب الشافعي وتأسيس أصول الفقه بمصر والعراق، والمذهب الحنبلي وأصول الأثر والتمسك بالسنن ومحنته، ومعالم استقرار المذاهب الأربعة وأسباب بقائها التاريخي.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_hanafi_maliki_foundations'],
        lessonIds: const [
          'lsn_madhahib_shafii_school_foundations',
          'lsn_madhahib_hanbali_school_foundations',
          'lsn_madhahib_four_schools_consolidation',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 1: المذهب الحنفي
      Lesson.create(
        lessonId: 'lsn_madhahib_hanafi_school_foundations',
        title: 'المذهب الحنفي: الإمام أبو حنيفة، أصول الاستنباط، وكتب ظاهر الرواية',
        courseId: courseId,
        moduleId: 'mod_hanafi_maliki_foundations',
        orderIndex: 1,
        sources: const ['src_tajj_tarajim', 'src_mabsut_sarakhsi', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_madh_1_1',
            title: 'أصول مذهب أبي حنيفة',
            description: 'استيعاب منهج أبي حنيفة في الاستنباط: الأخذ بكتاب الله، ثم سنة رسوله، ثم فتاوى الصحابة، والقياس والاستحسان.',
          ),
          LearningObjective(
            objectiveId: 'obj_madh_1_2',
            title: 'دور الصاحبين وكتب ظاهر الرواية',
            description: 'معرفة دور القاضي أبي يوسف ومحمد بن الحسن الشيباني، ومراتب كتب المذهب وكتب ظاهر الرواية الست.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_madh_1_1',
            title: 'أصول الاستنباط والاجتهاد عند الإمام أبي حنيفة',
            contentType: LearningContentType.sourceText,
            content: 'أسس الإمام أبو حنيفة النعمان (80 - 150هـ) مذهبه الفقهي في الكوفة على منهج الشورى الفقهية وحلقات المناظرة مع تلاميذه النوابغ. وصرح بمنهجه قائلاً: «إني آخذ بكتاب الله إذا وجدته، فما لم أجده فيه أخذت بسنة رسول الله ﷺ، فإذا لم أجد في كتاب الله ولا سنة رسول الله ﷺ أخذت بقول أصحابه آخذ بقول من شئت منهم وأدع من شئت، ثم لا أخرج عن قولهم إلى قول غيرهم، فإذا انتهى الأمر إلى إبراهيم والشعبي وابن سيرين والحسن وعطاء... فلي أن أجتهد كما اجتهدوا». وتميز المذهب بالتوسع في القياس والاستحسان ومراعاة العرف والتعليل المقاصدي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_1_1',
                evidenceKey: 'tarikh_baghdad:13:368',
                citation: 'تاريخ بغداد للخطيب البغدادي (ترجمة أبي حنيفة النعمان)',
                sourceId: 'src_tajj_tarajim',
              ),
            ],
            sourceAttribution: 'تاريخ بغداد والانتقاء لابن عبد البر والمبسوط للسرخسي',
          ),
          LessonSection.create(
            sectionId: 'sec_madh_1_2',
            title: 'دور الصاحبين ومراتب كتب المذهب وتدوينه',
            contentType: LearningContentType.explanation,
            content: 'كان لأبي يوسف (يعقوب بن إبراهيم) ومحمد بن الحسن الشيباني الفضل الأكبر في نشر المذهب وتدوين أصوله وتفريعاته. وقد دوّن محمد بن الحسن «كتب ظاهر الرواية» الست المعتمدة التي رواها الثقات بالتواتر والشهرة: (المبسوط، الزيادات، الجامع الصغير، الجامع الكبير، السير الصغير، والسير الكبير). وتعتبر هذه الكتب هي المرجع الأول لتقرير فقه المذهب الحنفي، وتليها كتب النوادر ثم كتب الفتاوى والواقعات.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_1_2',
                evidenceKey: 'qawaid:usul_sarakhsi',
                citation: 'أصول السرخسي ورسم المفتي لابن عابدين في ترتيب طبقات الروايات الحنفية',
                sourceId: 'src_mabsut_sarakhsi',
              ),
            ],
            sourceAttribution: 'رد المحتار على الدر المختار لابن عابدين وتاريخ الفقه الإسلامي',
          ),
        ],
      ),

      // Lesson 2: المذهب المالكي
      Lesson.create(
        lessonId: 'lsn_madhahib_maliki_school_foundations',
        title: 'المذهب المالكي: إمام دار الهجرة، عمل أهل المدينة، وسد الذرائع',
        courseId: courseId,
        moduleId: 'mod_hanafi_maliki_foundations',
        orderIndex: 2,
        sources: const ['src_tartib_madarik', 'src_muwatta_canonical', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_madh_2_1',
            title: 'أصول مذهب الإمام مالك',
            description: 'فهم أصول المذهب المالكي الموسوعية وخاصة حجية عمل أهل المدينة والمصالح المرسلة والاستحسان وسد الذرائع.',
          ),
          LearningObjective(
            objectiveId: 'obj_madh_2_2',
            title: 'مكانة الموطأ والمدونة',
            description: 'معرفة القيمة العلمية لكتاب «الموطأ» ومدونة سحنون وروايات أصحاب مالك بمصر والقيروان والأندلس.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_madh_2_1',
            title: 'أصول المذهب المالكي وحجية عمل أهل المدينة',
            contentType: LearningContentType.sourceText,
            content: 'شيد الإمام مالك بن أنس (93 - 179هـ) مذهبه في مدينة رسول الله ﷺ، مهبط الوحي ومستقر الصحابة، فكان «عمل أهل المدينة» المنقول نقلاً متواتراً كابراً عن كابر عنده أصلاً تشريعياً مقدماً على خبر الواحد فيما طريقه التواتر والعمل؛ لأن نقل الجمع عن الجمع أقوى من نقل الفرد. وتفرد المذهب برحابته الأصولية الشاملة التي بلغت ستة عشر أصلاً، منها: النص القرآني، ظاهر اللفظ، مفهوم المخالفة، السنة المتواترة وخبر الواحد، عمل أهل المدينة، القياس، المصالح المرسلة، الاستحسان، سد الذرائع، والعرف والعادات.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_2_1',
                evidenceKey: 'tartib_madarik:1:45',
                citation: 'ترتيب المدارك وتقريب المسالك لمعرفة أعلام مذهب مالك للقاضي عياض',
                sourceId: 'src_tartib_madarik',
              ),
            ],
            sourceAttribution: 'ترتيب المدارك للقاضي عياض وشرح تنقيح الفصول للقرافي',
          ),
          LessonSection.create(
            sectionId: 'sec_madh_2_2',
            title: 'الموطأ والمدونة الكبرى ومدارس المذهب التاريخية',
            contentType: LearningContentType.explanation,
            content: 'صنف الإمام مالك «الموطأ» ليكون جامعاً للسنن والآثار وفتاوى فقهاء المدينة السبعة، وقيل فيه: «ما ظهر على وجه الأرض بعد كتاب الله أصح من كتاب مالك» قبل ظهور الصحيحين. ثم دونت «المدونة الكبرى» برواية سحنون عن ابن القاسم عن مالك لتكون العمود الفقري لفقه الفروع المالكي. وتوسعت مدارسه في مصر (ابن القاسم وأشهب)، والقيروان (سحنون)، وبغداد (القاضي إسماعيل)، والأندلس (ابن عبد البر وابن رشد والباجي والشاطبي).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_2_2',
                evidenceKey: 'muwatta:intro',
                citation: 'مقدمة موطأ الإمام مالك برواية يحيى بن يحيى الليثي',
                sourceId: 'src_muwatta_canonical',
              ),
            ],
            sourceAttribution: 'تاريخ المذهب المالكي في المشرق والمغرب للدكتور الفاضل الجمالي',
          ),
        ],
      ),

      // Lesson 3: مدرسة الرأي ومدرسة الأثر
      Lesson.create(
        lessonId: 'lsn_madhahib_ray_vs_athar_synthesis',
        title: 'مدرسة الرأي ومدرسة الأثر: النشأة، الفروق المنهجية، والتكامل العلمي',
        courseId: courseId,
        moduleId: 'mod_hanafi_maliki_foundations',
        orderIndex: 3,
        sources: const ['src_hujjat_allah_balighah', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_madh_3_1',
            title: 'نشأة مدرستي الرأي والحديث',
            description: 'معرفة الظروف التاريخية والبيئية لنشوء مدرسة الأثر بالحجاز ومدرسة الرأي بالعراق.',
          ),
          LearningObjective(
            objectiveId: 'obj_madh_3_2',
            title: 'تكامل المدرستين وتفنيد الشبهات',
            description: 'إدراك حقيقة الرأي المحمود والتكامل بين الاستنباط المقاصدي والتقيد بالنصوص ونبذ الرأي المذموم.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_madh_3_1',
            title: 'الجذور التاريخية لمدرستي الحجاز والعراق',
            contentType: LearningContentType.sourceText,
            content: 'نشأت مدرستان فقهيتان كبريان في عصر التابعين: 1) مدرسة الحديث والأثر في الحجاز (المدينة المنورة): امتداد لمنهج عبد الله بن عمر وزيد بن ثابت والفقهاء السبعة، وتميزت بكثرة السنن والآثار واستقرار المجتمع النبوي وقلة الفتن. 2) مدرسة الرأي في العراق (الكوفة والبصرة): امتداد لمنهج عبد الله بن مسعود وعلي بن أبي طالب وتلاميذهما كعلقمة والأسود وإبراهيم النخعي، وتميزت بمواجهة مستجدات المجتمعات الحضارية المفتوحة والحاجة لتوليد الأحكام بالقياس واستنباط العلل.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_3_1',
                evidenceKey: 'hujjat_allah:1:145',
                citation: 'حجة الله البالغة للإمام شاه ولي الله الدهلوي (باب أسباب اختلاف أصحاب المذاهب)',
                sourceId: 'src_hujjat_allah_balighah',
              ),
            ],
            sourceAttribution: 'حجة الله البالغة للدهلوي وتاريخ التشريع الإسلامي للخضري بك',
          ),
          LessonSection.create(
            sectionId: 'sec_madh_3_2',
            title: 'التكامل المنهجي ونفي التعارض بين النص والعقل الفقهي',
            contentType: LearningContentType.explanation,
            content: 'لم تكن مدرسة الرأي تقديماً للعقل على النص، بل كان اجتهاداً في فهم مراد النص وتحقيق مناطه وضبط أسباب النزول وشروط قبول الأخبار الآحاد عند انتشار الوضع. وقد التقت المدرستان وتكاملتا تكاملاً تاماً؛ فأهل الرأي اعترفوا بفضل أئمة الأثر، وأهل الأثر استعانوا بمسالك القياس والاستنباط الدقيق، فكان فقه الأمة نسيجاً متوازناً يجمع بين تعظيم النصوص واليقظة لمقاصد الشريعة وعلل الأحكام.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_3_2',
                evidenceKey: 'quran:16:43',
                citation: 'قوله تعالى: ﴿فَاسْأَلُوا أَهْلَ الذِّكْرِ إِن كُنتُمْ لَا تَعْلَمُونَ﴾ [النحل: 43]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'إعلام الموقعين عن رب العالمين لابن القيم',
          ),
        ],
      ),

      // Lesson 4: المذهب الشافعي
      Lesson.create(
        lessonId: 'lsn_madhahib_shafii_school_foundations',
        title: 'المذهب الشافعي: الإمام الشافعي، تأسيس أصول الفقه، والقولان القديم والجديد',
        courseId: courseId,
        moduleId: 'mod_shafii_hanbali_foundations',
        orderIndex: 4,
        sources: const ['src_risalah_shafii', 'src_umm_shafii', 'src_tabaqat_shafiiyyah'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_madh_4_1',
            title: 'تأسيس علم أصول الفقه في الرسالة',
            description: 'إدراك العبقرية الشافعية في وضع أول مصنف جامع لقواعد الاستنباط والأصول في كتاب «الرسالة».',
          ),
          LearningObjective(
            objectiveId: 'obj_madh_4_2',
            title: 'المذهب القديم والمذهب الجديد',
            description: 'معرفة أسباب تغير اجتهاد الشافعي بين العراق ومصر وأشهر كتب المذهب (الأم والمختصر).',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_madh_4_1',
            title: 'الشافعي واضع علم أصول الفقه وموحد المدرستين',
            contentType: LearningContentType.sourceText,
            content: 'يعد الإمام محمد بن إدريس الشافعي (150 - 204هـ) الموفّق الأعظم بين مدرسة الأثر ومدرسة الرأي؛ فقد تفقه في مكة، ثم لازم الإمام مالك بالمدينة وحفظ الموطأ، ثم رحل إلى بغداد وناظر تلاميذ أبي حنيفة ودرس كتب محمد بن الحسن. وألف بطلب من عبد الرحمن بن مهدي كتابه العبقري الخالد «الرسالة»، فكان أول من قعّد علم أصول الفقه ووضع قواعد الجمع والترجيح والناسخ والمنسوخ وحجية خبر الواحد والبيان.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_4_1',
                evidenceKey: 'risalah:intro',
                citation: 'كتاب الرسالة للإمام الشافعي (تحقيق أحمد محمد شاكر)',
                sourceId: 'src_risalah_shafii',
              ),
            ],
            sourceAttribution: 'الرسالة للإمام الشافعي وطبقات الشافعية الكبرى للسبكي',
          ),
          LessonSection.create(
            sectionId: 'sec_madh_4_2',
            title: 'المذهب القديم في العراق والمذهب الجديد في مصر',
            contentType: LearningContentType.explanation,
            content: 'صنف الشافعي في بغداد كتب مذهبه القديم (ككتاب الحجة). وعندما استقر في مصر في أواخر حياته واطلع على أحاديث وآثار جديدة وتغيرت الأعراف البيئية والاجتماعية؛ أعاد النظر في كثير من اجتهاداته وأملى مذهبه الجديد المدون في كتاب «الأم» برواية الربيع بن سليمان المرادي ومختصر المزني. والمعتمد عند جماهير الشافعية هو المذهب الجديد إلا في نحو بضع عشرة مسألة أفتى فيها أصحاب المذهب بالقول القديم لرجحان دليله الحديثي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_4_2',
                evidenceKey: 'umm:1:12',
                citation: 'كتاب الأم للإمام الشافعي ومختصر المزني',
                sourceId: 'src_umm_shafii',
              ),
            ],
            sourceAttribution: 'مغني المحتاج للشربيني الخطيب والمنهاج للنووي',
          ),
        ],
      ),

      // Lesson 5: المذهب الحنبلي
      Lesson.create(
        lessonId: 'lsn_madhahib_hanbali_school_foundations',
        title: 'المذهب الحنبلي: إمام أهل السنة، أصول الأثر، وتدوين الروايات',
        courseId: courseId,
        moduleId: 'mod_shafii_hanbali_foundations',
        orderIndex: 5,
        sources: const ['src_tabaqat_hanabilah', 'src_insaf_mardawi', 'src_musnad_ahmad'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_madh_5_1',
            title: 'أصول مذهب الإمام أحمد',
            description: 'استيعاب الأصول الخمسة لفقه الإمام أحمد: النصوص، فتاوى الصحابة، والحديث المرسل والضعيف المحتج به، والقياس للضرورة.',
          ),
          LearningObjective(
            objectiveId: 'obj_madh_5_2',
            title: 'تدوين المذهب والروايات المعتمدة',
            description: 'معرفة منهج تدوين مسائل الإمام أحمد وتعدد الروايات والكتب المعتمدة من الخرقي إلى المقنع والإنصاف.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_madh_5_1',
            title: 'الأصول الخمسة لفقه الإمام أحمد بن حنبل',
            contentType: LearningContentType.sourceText,
            content: 'الإمام أحمد بن حنبل الشيباني (164 - 241هـ) هو إمام أهل السنة والمحدث الفقيه الجامع لمسند الأمة العظيم. وبنى مذهبه على خمسة أصول كبرى لخصها ابن القيم: 1) النصوص من الكتاب والسنة الصحيحة، فإذا وجد النص لم يلتفت إلى ما خالفه كائناً من كان. 2) فتاوى الصحابة إذا لم يعلم لها مخالف. 3) إذا اختلف الصحابة تخيّر من أقوالهم ما كان أقرب إلى الكتاب والسنة ولم يخرج عن أقوالهم. 4) الأخذ بالحديث المرسل والحديث الحسن والضعيف الذي لم يجمع على تركه مقدماً على القياس والرأي. 5) القياس عند الضرورة القصوى إذا تعذر وجود الأثر.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_5_1',
                evidenceKey: 'ilam_muwaqqiin:1:29',
                citation: 'إعلام الموقعين عن رب العالمين للإمام ابن قيم الجوزية',
                sourceId: 'src_tabaqat_hanabilah',
              ),
            ],
            sourceAttribution: 'إعلام الموقعين لابن القيم والإنصاف للمرداوي وشرح منتهى الإرادات',
          ),
          LessonSection.create(
            sectionId: 'sec_madh_5_2',
            title: 'تعدد الروايات وتحرير المعتمد عند الحنابلة',
            contentType: LearningContentType.explanation,
            content: 'لم يضع الإمام أحمد كتاباً في فروع الفقه بيده، بل حفظ تلاميذه مسائله وفتاواه بروايات متعددة ناشئة عن تغير اجتهاده لورود حديث صحيح جديد أو لتغير علة المسألة ومقاصد التيسير. وقام الخلال (ت 311هـ) بجمع فقه أحمد في «الجامع الكبير»، ثم صنف أبو القاسم الخرقي «المختصر» الشهير، وتتابعت شروحه العظمى كالمغني لابن قدامة والمقنع والكافي والمحرر والإنصاف والمنتهى والإقناع، حتى استقر المعتمد عند المتأخرين على ما اتفق عليه المنتهى والإقناع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_5_2',
                evidenceKey: 'insaf:intro',
                citation: 'مقدمة كتاب الإنصاف في معرفة الراجح من الخلاف للمرداوي',
                sourceId: 'src_insaf_mardawi',
              ),
            ],
            sourceAttribution: 'الإنصاف للمرداوي وطبقات الحنابلة لابن أبي يعلى',
          ),
        ],
      ),

      // Lesson 6: استقرار المذاهب الأربعة
      Lesson.create(
        lessonId: 'lsn_madhahib_four_schools_consolidation',
        title: 'استقرار المذاهب الأربعة: أسباب البقاء، إجماع الأمة، وحفظ الدين',
        courseId: courseId,
        moduleId: 'mod_shafii_hanbali_foundations',
        orderIndex: 6,
        sources: const ['src_ibn_khaldun_muqaddimah', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_madh_6_1',
            title: 'أسباب بقاء المذاهب الأربعة',
            description: 'معرفة العوامل العلمية والتاريخية التي حفظت المذاهب الأربعة دون سائر مذاهب الأئمة المجتهدين كالأوزاعي والليث.',
          ),
          LearningObjective(
            objectiveId: 'obj_madh_6_2',
            title: 'مكانة المذاهب في حفظ الدين',
            description: 'استيعاب كيف كان استقرار المذاهب وسيلة لحفظ الشريعة وصيانة الأمة من الفوضى الفقهية والتحريف.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_madh_6_1',
            title: 'عوامل استقرار المذاهب الأربعة وحفظها التاريخي',
            contentType: LearningContentType.sourceText,
            content: 'كان في عصر السلف أئمة مجتهدون كبار كالثوري والأوزاعي والليث بن سعد وإسحاق بن راهويه وابن جرير الطبري، لكن مذاهبهم اندثرت وبقيت المذاهب الأربعة المتبوعة. ويرجع ذلك إلى أسباب جوهرية بيّنها ابن خلدون: 1) قيام تلاميذ نجباء بتدوين أقوال أئمتهم وتفريعها وتأصيلها. 2) تدوين أصول الاستنباط وقواعد الفقه وضبط مصطلحاته. 3) تبني الدول الإسلامية المتعاقبة للمذاهب في القضاء والإفتاء. 4) انتشار مدارسها في الحواضر الكبرى (مكة، المدينة، بغداد، دمشق، القاهرة، القيروان، فاس، وقرطبة).',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_6_1',
                evidenceKey: 'muqaddimah:ch6:435',
                citation: 'مقدمة ابن خلدون (الفصل السادس: في علم الفقه وما يتبعه من الفرائض)',
                sourceId: 'src_ibn_khaldun_muqaddimah',
              ),
            ],
            sourceAttribution: 'مقدمة ابن خلدون وتاريخ المذاهب الإسلامية للشيخ محمد أبو زهرة',
          ),
          LessonSection.create(
            sectionId: 'sec_madh_6_2',
            title: 'الإجماع العملي على شرعية التمذهب وضبط الاجتهاد',
            contentType: LearningContentType.explanation,
            content: 'أجمعت الأمة الإسلامية على مدار أكثر من ألف عام على أن التمذهب بمذهب من هذه المذاهب الأربعة طريق شرعي سائغ لتفقه المسلم والالتزام بأحكام الشريعة، لما تميزت به من خدمة آلاف العلماء والفقهاء والمحققين تدقيقاً وتنقيحاً ومراجعة على نصوص الكتاب والسنة. وقد وفرت هذه المذاهب سياجاً حصيناً حمى الشريعة من الفوضى التشريعية والتحكم بالهوى والتشهي، وجعلت طريق الاجتهاد مسلكاً منضبطاً بقواعد العلم والورع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_madh_6_2',
                evidenceKey: 'quran:4:83',
                citation: 'قوله تعالى: ﴿وَلَوْ رَدُّوهُ إِلَى الرَّسُولِ وَإِلَىٰ أُولِي الْأَمْرِ مِنْهُمْ لَعَلِمَهُ الَّذِينَ يَسْتَنبِطُونَهُ مِنْهُمْ﴾ [النساء: 83]',
                sourceId: 'src_quran_canonical',
              ),
            ],
            sourceAttribution: 'الإنصاف في بيان أسباب الاختلاف للدهلوي والمدخل المفصل لابن دهيش',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: المذهبان الحنفي والمالكي
    final q1 = QuizQuestion.create(
      questionId: 'q_madh_1',
      lessonId: 'lsn_madhahib_hanafi_school_foundations',
      questionText: 'ما هي كتب ظاهر الرواية الست المعتمدة في تقرير المذهب الحنفي التي صنفها الإمام محمد بن الحسن الشيباني؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qmd1_1', text: 'المبسوط، الزيادات، الجامع الصغير، الجامع الكبير، السير الصغير، والسير الكبير'),
        QuizOption(optionId: 'opt_qmd1_2', text: 'المغني، المحرر، المقنع، الكافي، الشرح الكبير، والإنصاف'),
        QuizOption(optionId: 'opt_qmd1_3', text: 'الأم، الرسالة، مختصر المزني، الحجة، البويطي، والإملاء'),
      ],
      correctOptionIndices: const [0],
      explanation: 'كتب ظاهر الرواية الست هي الأصول الأولى المعتمدة بالتواتر والشهرة لتدوين فقه أبي حنيفة وتلاميذه.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_hanafi_maliki_foundations',
      lessonId: 'lsn_madhahib_hanafi_school_foundations',
      title: 'اختبار تقييم استيعاب أصول وتاريخ المذهبين الحنفي والمالكي ومدرستي الرأي والأثر',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: المذهبان الشافعي والحنبلي
    final q2 = QuizQuestion.create(
      questionId: 'q_madh_2',
      lessonId: 'lsn_madhahib_shafii_school_foundations',
      questionText: 'ما هو الكتاب الذي صنفه الإمام الشافعي ويعد أول تدوين علمي أصولي متكامل في تاريخ الفقه الإسلامي؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qmd2_1', text: 'كتاب «الرسالة» الذي وضعه بطلب من الإمام عبد الرحمن بن مهدي'),
        QuizOption(optionId: 'opt_qmd2_2', text: 'كتاب «الموطأ» الذي جمعه في المدينة المنورة'),
        QuizOption(optionId: 'opt_qmd2_3', text: 'كتاب «مجلة الأحكام العدلية» في القضاء'),
      ],
      correctOptionIndices: const [0],
      explanation: 'كتاب «الرسالة» للشافعي هو أول مصنف أصل لعلم أصول الفقه وقواعد الاستنباط والأدلة المتفق عليها والمختلف فيها.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_shafii_hanbali_foundations',
      lessonId: 'lsn_madhahib_shafii_school_foundations',
      title: 'اختبار تقييم استيعاب أصول وتاريخ المذهبين الشافعي والحنبلي واستقرار المذاهب الأربعة',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
