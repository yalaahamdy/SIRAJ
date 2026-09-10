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

/// بيانات مقرر تراجم أئمة الهدى وأعلام الاجتهاد والتجديد في الإسلام (6 دروس تأصيلية + اختباران استيعاب)
class LearningImamsBiographiesData {
  static const String courseId = 'course_imams_biographies_mujtahidin';
  static const String pathId = 'path_madhahib_history_ijtihad_imams_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر تراجم أئمة الهدى وأعلام الاجتهاد والتجديد في الإسلام',
      description: 'دراسة تأصيلية لسير ومناهج أئمة الفقه والحديث الكبار: الأئمة الأربعة، الليث، الثوري، البخاري ومسلم، ومحققي المذاهب وأعلام المقاصد والتجديد: النووي، ابن حجر، العز بن عبد السلام، الشاطبي، ابن تيمية وابن القيم.',
      level: lp.LearningLevel.advanced,
      moduleIds: const ['mod_imams_biographies_classical', 'mod_imams_reformers_scholars'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_imams_biographies_classical',
        courseId: courseId,
        title: 'الوحدة الأولى: سِيَر ومناهج أئمة الفقه والحديث الأعلام في عصر الرواية',
        description: 'سيرة الإمامين أبي حنيفة النعمان ومالك بن أنس، سيرة الإمامين الشافعي وأحمد بن حنبل، وسيرة مجتهدي الأمصار وأئمة نقد الحديث كالثوري والليث والبخاري ومسلم.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_imams_abu_hanifa_malik_biographies',
          'lsn_imams_shafii_ahmad_biographies',
          'lsn_imams_layth_thawri_hadith_scholars',
        ],
      ),
      CourseModule(
        moduleId: 'mod_imams_reformers_scholars',
        courseId: courseId,
        title: 'الوحدة الثانية: أعلام التجديد والتحرير الفقهي والمقاصدي عبر القرون',
        description: 'شيوخ الإسلام المحققون النووي وابن حجر، أعلام المقاصد وسلطان العلماء العز بن عبد السلام والشاطبي، ومنهج التحرير والتجديد عند ابن تيمية وابن القيم.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_imams_biographies_classical'],
        lessonIds: const [
          'lsn_imams_nawawi_ibn_hajar_synthesizers',
          'lsn_imams_izz_abdessalam_shatibi_maqasid',
          'lsn_imams_ibn_taymiyyah_ibn_qayyim_reform',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    return [
      // Lesson 13: أبو حنيفة ومالك
      Lesson.create(
        lessonId: 'lsn_imams_abu_hanifa_malik_biographies',
        title: 'سيرة ومنهج الإمامين أبي حنيفة النعمان ومالك بن أنس',
        courseId: courseId,
        moduleId: 'mod_imams_biographies_classical',
        orderIndex: 1,
        sources: const ['src_siyar_alam_nubala', 'src_tajj_tarajim', 'src_quran_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_bio_1_1',
            title: 'سيرة أبي حنيفة وورعه',
            description: 'استيعاب ملامح شخصية أبي حنيفة: النشأة، التجارة الأمينة، قيام الليل، الورع في القضاء، والمنهج الاستنباطي.',
          ),
          LearningObjective(
            objectiveId: 'obj_bio_1_2',
            title: 'هيبة مالك وتوقيره للحديث',
            description: 'معرفة سيرة إمام دار الهجرة مالك بن أنس: ثباته، توقيره لحديث رسول الله ﷺ، وتورعه عن التسرع في الفتوى.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_bio_1_1',
            title: 'الإمام الأعظم أبو حنيفة النعمان: التاجر الزاهد والفقيه المنظر',
            contentType: LearningContentType.sourceText,
            content: 'ولد أبو حنيفة النعمان بن ثابت بالكوفة سنة 80هـ وتوفي ببغداد سنة 150هـ. كان خزاراً يبيع الخز والأقمشة، واشتهر بالصدق النادر والأمانة والإنفاق العظيم على طلبة العلم. تميز بحدة الذهن وقوة الحجة حتى قال فيه الإمام مالك: «رأيت رجلاً لو كلمك في هذه السارية أن يجعلها ذهباً لقام بحجته!». وكان رضي الله عنه يقوم الليل بالقرآن، وضرب بالسياط وسجن لرفضه تولي منصب القضاء في عهد المنصور حفظاً لدينه واستقلالية فتواه.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_1_1',
                evidenceKey: 'dhahabi:siyar:6:390',
                citation: 'سير أعلام النبلاء للذهبي (ترجمة أبي حنيفة النعمان)',
                sourceId: 'src_siyar_alam_nubala',
              ),
            ],
            sourceAttribution: 'سير أعلام النبلاء للذهبي وتاريخ بغداد للخطيب',
          ),
          LessonSection.create(
            sectionId: 'sec_bio_1_2',
            title: 'الإمام مالك بن أنس: هيبة دار الهجرة وتوقير السنة',
            contentType: LearningContentType.explanation,
            content: 'ولد مالك بن أنس بالمدينة المنورة سنة 93هـ وتوفي بها سنة 179هـ، ولم يرحل عنها إلا للحج، تعظيماً لتربة رسول الله ﷺ وحرصاً على ملازمة آثاره. كان إذا أراد أن يحدّث توضأ واغتسل وتطيب ولبس ثياباً جدداً وتصدر في هيبة بالغة، وقال: «أحب أن أعظم حديث رسول الله ﷺ». وكان إذا سئل عن مسألة لم يتعجل بل قال: «لا أدري، سل غيري»، حتى قال ابن وهب: «لو كتبنا عن مالك "لا أدري" لملأنا الألواح»، تأصيلاً لورع المفتي.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_1_2',
                evidenceKey: 'tartib_madarik:1:120',
                citation: 'ترتيب المدارك للقاضي عياض (باب في توقير مالك لحديث رسول الله ﷺ)',
                sourceId: 'src_tajj_tarajim',
              ),
            ],
            sourceAttribution: 'ترتيب المدارك للقاضي عياض والانتقاء لابن عبد البر',
          ),
        ],
      ),

      // Lesson 14: الشافعي وأحمد
      Lesson.create(
        lessonId: 'lsn_imams_shafii_ahmad_biographies',
        title: 'سيرة ومنهج الإمامين محمد بن إدريس الشافعي وأحمد بن حنبل',
        courseId: courseId,
        moduleId: 'mod_imams_biographies_classical',
        orderIndex: 2,
        sources: const ['src_tabaqat_shafiiyyah', 'src_tabaqat_hanabilah', 'src_bukhari_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_bio_2_1',
            title: 'عبقرية الشافعي وفصاحته ومناظراته',
            description: 'معرفة ملامح سيرة الشافعي: نشأته بغزة ومكة، إتقانه للغة وشعر هذيل، وفصاحته ومناظراته المنهجية.',
          ),
          LearningObjective(
            objectiveId: 'obj_bio_2_2',
            title: 'ثبات الإمام أحمد ومحنته في خلق القرآن',
            description: 'استيعاب موقف الإمام أحمد التاريخي في فتنة القول بخلق القرآن وصبره حتى نصر الله به السنة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_bio_2_1',
            title: 'الإمام محمد بن إدريس الشافعي: حجة اللغة وناصر الحديث',
            contentType: LearningContentType.sourceText,
            content: 'ولد الشافعي بغزة سنة 150هـ ونشأ بمكة يتيماً فقيراً، فحفظ القرآن وهو ابن سبع سنين، والموطأ وهو ابن عشر سنين، وعاش في بادية هذيل عشر سنين حتى صار حجة في لغة العرب وأشعارها. لقب بـ «ناصر الحديث» في بغداد لصلابة برهانه في الرد على منكري حجية السنة وأهل الأهواء. كان يقسم ليله ثلاثة أثلاث: ثلثاً يكتب فيه العلم، وثلثاً يصلي، وثلثاً ينام، واشتهر بالسخاء الفائق والزهد وحسن الخلق.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_2_1',
                evidenceKey: 'subki:tabaqat:2:12',
                citation: 'طبقات الشافعية الكبرى لتاج الدين السبكي (ترجمة الشافعي)',
                sourceId: 'src_tabaqat_shafiiyyah',
              ),
            ],
            sourceAttribution: 'طبقات الشافعية الكبرى للسبكي وآداب الشافعي ومناقبه لابن أبي حاتم',
          ),
          LessonSection.create(
            sectionId: 'sec_bio_2_2',
            title: 'الإمام أحمد بن حنبل: الصمود في المحنة ومنارة الاتباع',
            contentType: LearningContentType.explanation,
            content: 'ولد الإمام أحمد ببغداد سنة 164هـ، ورحل في طلب الحديث إلى الكوفة والبصرة والحجاز واليمن والشام والجزيرة حتى جمع «المسند» العظيم بنحو ثلاثين ألف حديث. وواجه محنة القول بخلق القرآن بثبات أسطوري في عهد ثلاثة خلفاء من بني العباس؛ فضرب بالسياط وسجن وعذب ولم يتراجع قيد أنملة دفاعاً عن أن القرآن كلام الله منزل غير مخلوق، حتى قال علي بن المديني: «إن الله أعز هذا الدين برجلين: بأبي بكر يوم الردة، وبأحمد بن حنبل يوم المحنة».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_2_2',
                evidenceKey: 'ibn_kathir:bidayah:10:330',
                citation: 'البداية والنهاية لابن كثير (ذكر فتنة خلق القرآن ومحنة الإمام أحمد)',
                sourceId: 'src_tabaqat_hanabilah',
              ),
            ],
            sourceAttribution: 'البداية والنهاية لابن كثير وسير أعلام النبلاء للذهبي',
          ),
        ],
      ),

      // Lesson 15: الليث والثوري وأئمة الحديث
      Lesson.create(
        lessonId: 'lsn_imams_layth_thawri_hadith_scholars',
        title: 'سيرة الليث والثوري والأوزاعي وأئمة نقد الرواية والحديث (البخاري ومسلم)',
        courseId: courseId,
        moduleId: 'mod_imams_biographies_classical',
        orderIndex: 3,
        sources: const ['src_siyar_alam_nubala', 'src_tahdhib_kamal'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_bio_3_1',
            title: 'مكانة الليث وسفيان والأوزاعي',
            description: 'إدراك المنزلة العلمية الفقهية لأئمة الاجتهاد المستقل: الليث بن سعد بمصر، سفيان الثوري بالعراق، والأوزاعي بالشام.',
          ),
          LearningObjective(
            objectiveId: 'obj_bio_3_2',
            title: 'أئمة نقد الرواية والبخاري ومسلم',
            description: 'معرفة دور أميري المؤمنين في الحديث البخاري ومسلم في صيانة الأدلة وحفظ السنن التي بني عليها الفقه.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_bio_3_1',
            title: 'أعلام الفقه المستقل في الأمصار الإسلامية',
            contentType: LearningContentType.sourceText,
            content: 'شهد القرن الثاني أئمة مجتهدين بلغوا رتبة الأئمة الأربعة؛ منهم: 1) الليث بن سعد (عالم مصر وفقيهها)، قال فيه الشافعي: «الليث أفقه من مالك، إلا أن أصحابه لم يقوموا به». وكان آية في الجود والكرم. 2) سفيان الثوري (أمير المؤمنين في الحديث والزهد بالكوفة)، وكان فقيهاً مجتهداً له مذهب متبع لقرون. 3) عبد الرحمن بن عمرو الأوزاعي (إمام الشام والمغرب)، الذي اشتهر بفقه السير والمغازي والعدالة وحماية أهل الذمة.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_3_1',
                evidenceKey: 'mizzi:tahdhib:24:260',
                citation: 'تهذيب الكمال في أسماء الرجال للإمام المزي',
                sourceId: 'src_tahdhib_kamal',
              ),
            ],
            sourceAttribution: 'تهذيب الكمال للمزي وسير أعلام النبلاء للذهبي',
          ),
          LessonSection.create(
            sectionId: 'sec_bio_3_2',
            title: 'حراس الأدلة النبوية: الإمامان البخاري ومسلم',
            contentType: LearningContentType.explanation,
            content: 'لا ينفصل الفقه عن الحديث؛ فقد نهض الإمام محمد بن إسماعيل البخاري (194 - 256هـ) والإمام مسلم بن الحجاج النيسابوري (206 - 261هـ) بأعظم مهمة نقدية في تاريخ الإنسانية لتجريد الأحاديث الصحيحة من الضعيف والموضوع. وتضمن «صحيح البخاري» في تراجم أبوابه خلاصة فقهية باهرة صاغها في عناوينه الاستنباطية حتى قيل: «فقه البخاري في تراجمه»، مما وفر القاعدة الصلبة التي اعتمد عليها فقهاء الأمة ومجتهدوها.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_3_2',
                evidenceKey: 'hajar:fath_bari:intro',
                citation: 'هدي الساري مقدمة فتح الباري بشرح صحيح البخاري لابن حجر',
                sourceId: 'src_siyar_alam_nubala',
              ),
            ],
            sourceAttribution: 'هدي الساري لابن حجر وشرح صحيح مسلم للنووي',
          ),
        ],
      ),

      // Lesson 16: النووي وابن حجر
      Lesson.create(
        lessonId: 'lsn_imams_nawawi_ibn_hajar_synthesizers',
        title: 'شيوخ الإسلام المحققون: الإمام النووي وابن حجر العسقلاني والخطابي',
        courseId: courseId,
        moduleId: 'mod_imams_reformers_scholars',
        orderIndex: 4,
        sources: const ['src_sharh_nawawi', 'src_fath_bari_canonical'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_bio_4_1',
            title: 'منهج الإمام النووي في التحقيق والزهد',
            description: 'استيعاب الدور التاريخي لمحيي الدين النووي في تحرير المذهب الشافعي في «المنهاج» وشرح صحيح مسلم ورياض الصالحين.',
          ),
          LearningObjective(
            objectiveId: 'obj_bio_4_2',
            title: 'حافظ العصر ابن حجر ومشروعه في فتح الباري',
            description: 'معرفة عبقرية الحافظ ابن حجر العسقلاني في شرح البخاري والجمع الفقهي المقارن ونقد الأسانيد.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_bio_4_1',
            title: 'الإمام يحيى بن شرف النووي: جامع الفقه والحديث والزهد',
            contentType: LearningContentType.sourceText,
            content: 'الإمام محيي الدين أبو زكريا يحيى بن شرف النووي (631 - 676هـ) عاش حياة قصيرة مباركة بلغت 45 عاماً فقط، لكنه ملأ الدنيا علماً وبركة. حرر المذهب الشافعي في مصنفاته المعتمدة كـ «منهاج الطالبين» و«المجموع شرح المهذب» و«روضة الطالبين»، وجمع الأحاديث المحققة في «رياض الصالحين» و«الأربعين النووية»، وشرح صحيح مسلم بأدق عبارة. واشتهر بالزهد الصادق والنصح الصادع للحكام ومحبة الأمة قاطبة لمصنفاته.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_4_1',
                evidenceKey: 'sakhawi:tarjamah_nawawi',
                citation: 'المنهل العذب الروي في ترجمة قطب الأولياء النووي للإمام السخاوي',
                sourceId: 'src_sharh_nawawi',
              ),
            ],
            sourceAttribution: 'سير أعلام النبلاء للذهبي والمنهل العذب الروي للسخاوي',
          ),
          LessonSection.create(
            sectionId: 'sec_bio_4_2',
            title: 'الحافظ ابن حجر العسقلاني: أمير المؤمنين في الحديث وخاتمة الحفاظ',
            contentType: LearningContentType.explanation,
            content: 'أحمد بن علي بن حجر العسقلاني (773 - 852هـ) شيخ الإسلام وقاضي القضاة. صنف كتابه الموسوعي الذي لا نظير له «فتح الباري بشرح صحيح البخاري» الذي استغرق تصنيفه قرابة ثلاثين عاماً، حتى قيل بحق: «لا هجرة بعد الفتح». وتميز منهجه بالاستقراء التام لطرق الحديث، والمقارنة الفقهية بين المذاهب الأربعة بأعلى درجات الإنصاف والموضوعية، مع التحقيق الدقيق لمراتب الرواة في «تهذيب التهذيب» و«التقريب».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_4_2',
                evidenceKey: 'sakhawi:jawahir_durar',
                citation: 'الجواهر والدرر في ترجمة شيخ الإسلام ابن حجر لشمس الدين السخاوي',
                sourceId: 'src_fath_bari_canonical',
              ),
            ],
            sourceAttribution: 'الجواهر والدرر للسخاوي وشذرات الذهب لابن العماد',
          ),
        ],
      ),

      // Lesson 17: العز بن عبد السلام والشاطبي
      Lesson.create(
        lessonId: 'lsn_imams_izz_abdessalam_shatibi_maqasid',
        title: 'أعلام المقاصد الكبرى: سلطان العلماء العز بن عبد السلام وأبو إسحاق الشاطبي',
        courseId: courseId,
        moduleId: 'mod_imams_reformers_scholars',
        orderIndex: 5,
        sources: const ['src_qawaid_ahkam_izz', 'src_muwafaqat_shatibi'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_bio_5_1',
            title: 'سلطان العلماء وفقه قواعد الأحكام',
            description: 'معرفة منهج العز بن عبد السلام في بناء الشريعة كلها على جلب المصالح ودرء المفاسد ومواقفه الجريئة ضد الظلم.',
          ),
          LearningObjective(
            objectiveId: 'obj_bio_5_2',
            title: 'الشاطبي وتأسيس علم مقاصد الشريعة',
            description: 'استيعاب عبقرية أبي إسحاق الشاطبي في كتاب «الموافقات» وتأصيل نظرية المقاصد القطعية وكليات الدين الخمس.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_bio_5_1',
            title: 'العز بن عبد السلام: سلطان العلماء وباني فقه المصالح',
            contentType: LearningContentType.sourceText,
            content: 'الإمام عبد العزيز بن عبد السلام السلمي (577 - 660هـ) الملقب بـ «سلطان العلماء» و«بائع الأمراء» لموقفه التاريخي في بيع أمراء المماليك لصالح بيت مال المسلمين قبل قتال التتار، وفرض الضرائب على الأمراء قبل الرعية في معركة عين جالوت. صنف كتابه الفريد «قواعد الأحكام في مصالح الأنام» وأرسى فيه القاعدة الكبرى: «الشريعة كلها مصالح؛ إما تدرأ مفاسد أو تجلب مصالح»، مبيناً أن التكاليف كلها راجعة إلى رعاية مصالح العباد في المعاش والمعاد.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_5_1',
                evidenceKey: 'izz:qawaid:1:9',
                citation: 'قواعد الأحكام في مصالح الأنام للإمام العز بن عبد السلام (فصل في مقاصد الشريعة)',
                sourceId: 'src_qawaid_ahkam_izz',
              ),
            ],
            sourceAttribution: 'قواعد الأحكام للعز بن عبد السلام وطبقات الشافعية للسبكي',
          ),
          LessonSection.create(
            sectionId: 'sec_bio_5_2',
            title: 'أبو إسحاق الشاطبي: فيلسوف الشريعة ومجدد الأصول',
            contentType: LearningContentType.explanation,
            content: 'إبراهيم بن موسى الشاطبي الغرناطي الأندلسي (ت 790هـ) أحدث نقلة نوعية في تاريخ الأصول؛ فأخرج علم الأصول من الجدل اللفظي المجرد إلى رحاب «مقاصد الشريعة» في كتابه الأسطوري «الموافقات». أثبت بالاستقراء التام لنصوص الشريعة أن أحكامها معللة برعاية الضروريات الخمس (حفظ الدين، النفس، العقل، النسل، والمال)، ثم الحاجيات ثم التحسينيات. كما صنف كتاب «الاعتصام» ليكون أعظم مصنف في تفكيك مفهوم البدعة وضبط الاتباع.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_5_2',
                evidenceKey: 'shatibi:muwafaqat:2:6',
                citation: 'الموافقات لأبي إسحاق الشاطبي (كتاب المقاصد في الشريعة)',
                sourceId: 'src_muwafaqat_shatibi',
              ),
            ],
            sourceAttribution: 'الموافقات والاعتصام للشاطبي ونيل الابتهاج لأحمد بابا التنبكتي',
          ),
        ],
      ),

      // Lesson 18: ابن تيمية وابن القيم
      Lesson.create(
        lessonId: 'lsn_imams_ibn_taymiyyah_ibn_qayyim_reform',
        title: 'شيخ الإسلام ابن تيمية وتلميذه ابن القيم: التحرير الاجتهادي ونقد الجمود المذهبي',
        courseId: courseId,
        moduleId: 'mod_imams_reformers_scholars',
        orderIndex: 6,
        sources: const ['src_majmu_fatawa_taymiyyah', 'src_ilam_muwaqqiin'],
        authorOrEditor: 'لجنة التأصيل والتعليم المنهجي بسِراج',
        version: 1,
        objectives: const [
          LearningObjective(
            objectiveId: 'obj_bio_6_1',
            title: 'منهج ابن تيمية التجديدي والجهادي',
            description: 'معرفة معالم مشروع ابن تيمية في نقد التقليد المفرط وتجديد الفتوى بالدليل ومواقفه في الجهاد والدفاع عن الأمة.',
          ),
          LearningObjective(
            objectiveId: 'obj_bio_6_2',
            title: 'ابن القيم وتأصيل فقه الفتوى والمقاصد',
            description: 'استيعاب إسهامات ابن القيم في «إعلام الموقعين» و«زاد المعاد» وربط الفقه بالحكمة ومصالح العباد ورحمة الشريعة.',
          ),
        ],
        sections: [
          LessonSection.create(
            sectionId: 'sec_bio_6_1',
            title: 'شيخ الإسلام أحمد بن عبد الحليم بن تيمية: مجدد القرن السابع',
            contentType: LearningContentType.sourceText,
            content: 'تقي الدين أحمد بن تيمية الحراني (661 - 728هـ) علم من أعلام الاجتهاد المطلق في تاريخ الإسلام. خاض معارك فكرية جبارة ضد الجمود والبدع الفلسفية والكلامية، وقاد الأمة جهادياً في معركة شقحب ضد التتار. تميز بذاكرة حديدية واستقراء شامل لمذاهب السلف والفقهاء، وحرر قضايا فقهية شائكة مبنية على النص والمقصد؛ كمسائل الطلاق المتعدد في مجلس واحد، وجواز دفع القيمة في الزكاة للمصلحة، وتحريم الحيل الربوية. وسجن مراراً صابراً محتسباً ومات في قلعة دمشق.',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_6_1',
                evidenceKey: 'taymiyyah:fatawa:20:10',
                citation: 'مجموع فتاوى شيخ الإسلام ابن تيمية (مقدمة الفقه وأصوله)',
                sourceId: 'src_majmu_fatawa_taymiyyah',
              ),
            ],
            sourceAttribution: 'مجموع الفتاوى والعقود الدرية لابن عبد الهادي والبداية والنهاية',
          ),
          LessonSection.create(
            sectionId: 'sec_bio_6_2',
            title: 'الإمام ابن قيم الجوزية: فقيه القلوب ومؤصل مراتب الفتوى',
            contentType: LearningContentType.explanation,
            content: 'شمس الدين محمد بن أبي بكر الزرعي (691 - 751هـ) التلميذ الأبرز لابن تيمية ووارث علمه ومربّي السالكين. صنف كتاب «إعلام الموقعين عن رب العالمين» فكان دستوراً لمنهج الفتوى وقواعد الشريعة، وهو القائل بقاعدته الذهبية الخالدة: «الشريعة مبناها وأساسها على الحكم ومصالح العباد في المعاش والمعاد، وهي عدل كلها، ورحمة كلها، ومصالح كلها، وحكمة كلها؛ فكل مسألة خرجت عن العدل إلى الجور، وعن الرحمة إلى ضدها، وعن المصلحة إلى المفسدة، وعن الحكمة إلى العبث؛ فليست من الشريعة وإن أدخلت فيها بالتأويل».',
            evidenceLinks: [
              EvidenceLink.create(
                evidenceId: 'ev_bio_6_2',
                evidenceKey: 'qayyim:ilam:3:14',
                citation: 'إعلام الموقعين عن رب العالمين للإمام ابن القيم (فصل في تغير الفتوى بتغير الأزمنة والأمكنة والأحوال)',
                sourceId: 'src_ilam_muwaqqiin',
              ),
            ],
            sourceAttribution: 'إعلام الموقعين وزاد المعاد وطريق الهجرتين لابن القيم',
          ),
        ],
      ),
    ];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: أئمة عصر الرواية
    final q1 = QuizQuestion.create(
      questionId: 'q_bio_1',
      lessonId: 'lsn_imams_abu_hanifa_malik_biographies',
      questionText: 'ما هي العبارة الشهيرة التي قالها الإمام مالك بن أنس في الحث على التثبت والتورع في الفتوى؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qb1_1', text: 'كان يكثر من قول «لا أدري»، وقال: «جنة العالم: لا أدري، فإذا أغفلها أُصيبت مقاتله»'),
        QuizOption(optionId: 'opt_qb1_2', text: 'الإفتاء الفوري في كل مسألة يطرحها السائلون بغير تردد'),
        QuizOption(optionId: 'opt_qb1_3', text: 'عدم الإجابة إلا بعد موافقة قضاة الدولة العباسية حصراً'),
      ],
      correctOptionIndices: const [0],
      explanation: 'اشتهر الإمام مالك بالورع الفائق والتريث في الفتوى وكان يعد قول «لا أدري» نصف العلم وجنة العالم.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_imams_biographies_classical',
      lessonId: 'lsn_imams_abu_hanifa_malik_biographies',
      title: 'اختبار تقييم استيعاب سِيَر ومناهج أئمة الفقه والحديث الأعلام في عصر الرواية',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: أعلام المقاصد والتجديد
    final q2 = QuizQuestion.create(
      questionId: 'q_bio_2',
      lessonId: 'lsn_imams_ibn_taymiyyah_ibn_qayyim_reform',
      questionText: 'ما هي القاعدة المقاصدية الكبرى التي صاغها الإمام ابن القيم في كتابه «إعلام الموقعين»؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_qb2_1', text: '«الشريعة عدل كلها، ورحمة كلها، ومصالح كلها، وحكمة كلها؛ فكل مسألة خرجت عن العدل إلى الجور فليست من الشريعة»'),
        QuizOption(optionId: 'opt_qb2_2', text: 'الجمود الحرفي على ظاهر ألفاظ كتب المتأخرين مهما تغيرت أحوال الزمان'),
        QuizOption(optionId: 'opt_qb2_3', text: 'إسقاط الشريعة برأي مجرد لا يستند لأدلة الكتاب والسنة ومقاصد الوحي'),
      ],
      correctOptionIndices: const [0],
      explanation: 'قاعدة ابن القيم الذهبية تعبر عن جوهر مقاصد الشريعة الإسلامية وروحها القائمة على العدل والرحمة ومصالح العباد.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_imams_reformers_scholars',
      lessonId: 'lsn_imams_ibn_taymiyyah_ibn_qayyim_reform',
      title: 'اختبار تقييم استيعاب أعلام التجديد والتحرير الفقهي والمقاصدي وشيوخ الإسلام المحققين',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
