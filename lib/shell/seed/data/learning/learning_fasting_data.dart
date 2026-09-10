import '../../../../modules/learning/domain/course.dart';
import '../../../../modules/learning/domain/course_module.dart';
import '../../../../modules/learning/domain/evidence_link.dart';
import '../../../../modules/learning/domain/learning_content_type.dart';
import '../../../../modules/learning/domain/learning_objective.dart';
import '../../../../modules/learning/domain/learning_path.dart' as lp;
import '../../../../modules/learning/domain/lesson.dart';
import '../../../../modules/learning/domain/lesson_section.dart';
import '../../../../modules/learning/domain/quiz.dart';
import '../../../../modules/learning/domain/quiz_question.dart';

/// بيانات مقرر فقه الصيام ومقاصده ونوازله المعاصرة والاعتكاف (4 دروس تأصيلية + اختبارات استيعاب)
class LearningFastingData {
  static const String courseId = 'course_fiqh_fasting_adv';
  static const String pathId = 'path_fiqh_worship_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الصيام ومقاصده ونوازله المعاصرة والاعتكاف',
      description: 'دراسة تأصيلية شاملة لشروط وجوب وصحة صوم رمضان، ومفسدات الصوم، والنوازل الطبية المعاصرة، وأعذار الفطر والقضاء والفدية، وصيام التطوع وفقه الاعتكاف.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_fasting_pillars_nullifiers', 'mod_fasting_excuses_sunan'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_fasting_pillars_nullifiers',
        courseId: courseId,
        title: 'الوحدة الأولى: أركان الصيام وشروطه والنوازل الطبية المعاصرة',
        description: 'بيان شروط وجوب وصحة الصوم، وثبوت الشهر بالرؤية، والمفطرات الأصلية والطبية المعاصرة بدقة.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_fasting_conditions_vision',
          'lsn_fasting_nullifiers_contemporary',
        ],
      ),
      CourseModule(
        moduleId: 'mod_fasting_excuses_sunan',
        courseId: courseId,
        title: 'الوحدة الثانية: الأعذار المرخصة وسنن الصيام والاعتكاف',
        description: 'أحكام المرض والسفر والحمل والرضاع، والقضاء والكفارات، وسنن الصوم وصيام التطوع وأحكام الاعتكاف.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_fasting_pillars_nullifiers'],
        lessonIds: const [
          'lsn_fasting_excuses_expiation',
          'lsn_fasting_sunan_itikaf',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 24: شروط وجوب الصيام وثبوت الشهر
    // -------------------------------------------------------------------------
    final lsn1 = Lesson.create(
      lessonId: 'lsn_fasting_conditions_vision',
      title: 'شروط وجوب صيام رمضان وصحته وثبوت دخول الشهر والنية',
      courseId: courseId,
      moduleId: 'mod_fasting_pillars_nullifiers',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_f1_1',
          title: 'معرفة شروط وجوب الصوم وشروط صحته',
          description: 'الإسلام، البلوغ، العقل، القدرة، الإقامة، وخلو المرأة من الحيض والنفاس.',
        ),
        LearningObjective(
          objectiveId: 'obj_f1_2',
          title: 'إتقان طرق ثبوت الشهر برؤية الهلال أو إكمال شعبان ثلاثين',
          description: 'تبييت النية من الليل في صيام الفريضة قبل طلوع الفجر الثاني.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_f1_1',
          title: 'فرضية صيام رمضان وشروطه وطرق ثبوته',
          contentType: LearningContentType.sourceText,
          content: 'صيام شهر رمضان أحد أركان الإسلام ومبانيه العظام، لقوله تعالى: ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ﴾ [البقرة: 183]. ويشترط لوجوبه: الإسلام، والبلوغ، والعقل، والقدرة، والإقامة، والسلامة من الموانع (الحيض والنفاس). ويثبت دخول الشهر بأحد أمرين: 1. رؤية هلال رمضان برؤية عدل موثوق، 2. إكمال عدة شعبان ثلاثين يوماً إذا تعذرت الرؤية بغيم أو قتر، لقوله ﷺ: «صُومُوا لِرُؤْيَتِهِ وأَفْطِرُوا لِرُؤْيَتِهِ، فإنْ غُبِّيَ علَيْكُم فأكْمِلُوا عِدَّةَ شَعْبانَ ثَلاثِينَ» [متفق عليه].',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_f1_bukhari_ruyah',
              evidenceKey: 'hadith_bukhari_ruyah',
              citation: 'صحيح البخاري رقم 1909 وصحيح مسلم رقم 1081',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 3 ص 5',
        ),
        LessonSection.create(
          sectionId: 'sec_f1_2',
          title: 'ركنية النية وتبييتها ومسائلها',
          contentType: LearningContentType.explanation,
          content: 'النية ركن أساسي في صحة الصيام لحديث: «إنما الأعمال بالنيات». ويجب في صيام الفرض (رمضان، القضاء، النذر، الكفارة) تبييت النية من الليل قبل طلوع الفجر الصادق، لقول النبي ﷺ: «من لم يجمع الصيام قبل الفجر فلا صيام له» [رواه أصحاب السنن]. وتكفي نية واحدة في أول الشهر لصيام رمضان كله ما لم يقطعها بسفر أو مرض فيستأنف النية. أما صيام النفل والتطوع: فيجوز إنشاؤه من النهار بشرط ألا يكون قد أكل أو شرب أو أتى مفطراً بعد الفجر لحديث عائشة: «هل عندكم شيء؟ فقلنا: لا، قال: فإني إذن صائم».',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_f1_muslim_nafl',
              evidenceKey: 'hadith_muslim_nafl_intent',
              citation: 'صحيح مسلم رقم 1154 من حديث عائشة رضي الله عنها',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'المجموع شرح المهذب ج 6 ص 290',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 25: مفسدات الصيام والنوازل الطبية المعاصرة
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_fasting_nullifiers_contemporary',
      title: 'مفسدات الصيام الأصلية وقرارات المجامع الفقهية في النوازل الطبية المعاصرة',
      courseId: courseId,
      moduleId: 'mod_fasting_pillars_nullifiers',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_f2_1',
          title: 'حصر مفسدات الصيام الأصلية والفرق بين العامد والناسي',
          description: 'الأكل، الشرب، الجماع، إنزال المني بشهوة، الاستقاءة عمداً، وخروج دم الحيض والنفاس.',
        ),
        LearningObjective(
          objectiveId: 'obj_f2_2',
          title: 'معرفة الأحكام الفقهية المعاصرة للقطرات والبخاخات والحقن وتحاليل الدم',
          description: 'قرارات مجمع الفقه الإسلامي الدولي بشأن المفطرات في مجال التداوي.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_f2_1',
          title: 'المفطرات الأصلية وما لا يفسد الصوم',
          contentType: LearningContentType.sourceText,
          content: 'يفسد الصوم بما يلي: 1. الأكل والشرب عمداً، 2. الجماع في نهار رمضان وهو أعظمها إثماً وموجب للكفارة المغلظة، 3. إنزال المني بمباشرة أو استمناء عمداً، 4. القيء عمداً لحديث: «من ذرعه القيء فليس عليه قضاء، ومن استقاء عمداً فليقضِ»، 5. خروج دم الحيض أو النفاس ولو قبل الغروب بلحظة، 6. الردة عن الإسلام والعياذ بالله. \nأما من أكل أو شرب ناسياً فصومه تام صحيح لا قضاء عليه ولا إثم لقوله ﷺ: «من نسي وهو صائم فأكل أو شرب فليتم صومه فإنما أطعمه الله وسقاه» [متفق عليه]. والمضمضة والاستنشاق بلا مبالغة، وبلع الريق الطاهر، وتذوق الطعام للحاجة ومجه لا يفطر.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_f2_bukhari_nasiyan',
              evidenceKey: 'hadith_bukhari_nasiyan',
              citation: 'صحيح البخاري رقم 1933 وصحيح مسلم رقم 1155',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 3 ص 120',
        ),
        LessonSection.create(
          sectionId: 'sec_f2_2',
          title: 'النوازل الطبية المعاصرة وضوابط التداوي للصائم',
          contentType: LearningContentType.scholarlyView,
          content: 'وفق قرارات مجمع الفقه الإسلامي الدولي: \n1. لا يفطر: قطرة العين، وقطرة الأذن (إذا كانت الطبلة سليمة)، وبخاخ الربو (لأنه غاز يذهب للرئة لتوسيع الشعب الهوائية وليس طعاماً ولا شراباً)، والأقراص العلاجية تحت اللسان لعلاج الذبحة، وحقن العضل والوريد والجلد غير المغذية (كالأنسولين والبنسلين والمسكنات)، وتحليل الدم اليسير وأخذ عينة منه، ورعاف الأنف، وغاز التخدير والتنظيف الطبي للأسنان.\n2. يفطر: الحقن والمحاليل المغذية بالوريد (كالجلوكوز والسالاين) لأنها تقوم مقام الأكل والشرب في تغذية الجسد، والغسيل الكلوي (الدموي والبريتوني) لاشتماله على إدخال سوائل وأملاح ومواد مغذية للجوف، والرعاف والدم الكثير إذا استفرغه لضعف البدن كالحجامة والتبرع بالدم عند الحنابلة.',
          sourceAttribution: 'قرارات مجمع الفقه الإسلامي الدولي الدورة العاشرة رقم 93 (1/10)',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 26: الأعذار المبيحة للفطر والقضاء والكفارة
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_fasting_excuses_expiation',
      title: 'الأعذار المبيحة للفطر في رمضان وأحكام القضاء والفدية والكفارة المغلظة',
      courseId: courseId,
      moduleId: 'mod_fasting_excuses_sunan',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_f3_1',
          title: 'معرفة من يرخص لهم الفطر ويجب عليهم القضاء، ومن تلزمهم الفدية',
          description: 'المريض مرجُو البرء والمسافر يقضيان، والكبير والمريض المزمن يطعمان مسكيناً عن كل يوم.',
        ),
        LearningObjective(
          objectiveId: 'obj_f3_2',
          title: 'معرفة أحكام كفارة الجماع المغلظة وترتيبها الشرعي الصارم',
          description: 'عتق رقبة، فإن لم يجد فصيام شهرين متتابعين، فإن لم يستطع فإطعام ستين مسكيناً.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_f3_1',
          title: 'الأعذار المرخصة وأقسام المعذورين',
          contentType: LearningContentType.sourceText,
          content: 'قال تعالى: ﴿وَمَن كَانَ مَرِيضًا أَوْ عَلَىٰ سَفَرٍ فَعِدَّةٌ مِّنْ أَيَّامٍ أُخَرَ ۗ يُرِيدُ اللَّهُ بِكُمُ الْيُسْرَ وَلَا يُرِيدُ بِكُمُ الْعُسْرَ﴾ [البقرة: 185]. ينقسم المعذورون إلى أقسام: \n1. المريض مرضاً يرجى شفاؤه والمسافر سفراً تقصر فيه الصلاة: يفطران ويقضيان يوماً مكان كل يوم بعد رمضان.\n2. الشيخ الكبير الهرم والمريض مرضاً مزمناً لا يرجى برؤه: يفطران ولا قضاء عليهما، ويجب إطعام مسكين عن كل يوم نصف صاع (نحو 1.5 كجم من الأرز أو التمر).\n3. الحامل والمرضع: إذا خافتا على نفسيهما أو ولديهما أفطرتا وقضتا كالمريض.\n4. الحائض والنفساء: يحرم عليهما الصوم ويجب عليهما القضاء بعد الطهر.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_f3_baqarah_185',
              evidenceKey: '2:185',
              citation: 'سورة البقرة: الآية 185',
              sourceId: 'src_quran_canonical',
            ),
          ],
          sourceAttribution: 'المجموع للنووي ج 6 ص 260',
        ),
        LessonSection.create(
          sectionId: 'sec_f3_2',
          title: 'الكفارة المغلظة في الجماع في نهار رمضان',
          contentType: LearningContentType.explanation,
          content: 'من جامع في نهار رمضان وهو صائم مكلف مختار أثم إثماً كبيراً وبطل صومه ولزمه الإمساك بقية اليوم وقضاء ذلك اليوم، ووجبت عليه الكفارة المغلظة على الترتيب الشرعي الصارم: 1. عتق رقبة مؤمنة، 2. فإن لم يجد فصيام شهرين متتابعين لا يفطر بينهما إلا لعذر شرعي (كعيد أو مرض شديد)، 3. فإن عجز لعذر بدني دائم أطعم ستين مسكيناً (لكل مسكين مد قمح أو نصف صاع تمر أو أرز). لحديث أبي هريرة في الأعرابي الذي جاء ينتف شعره ويقول: هلكت يا رسول الله! وقعت على امرأتي في رمضان.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_f3_bukhari_kaffarah',
              evidenceKey: 'hadith_bukhari_kaffarah_fasting',
              citation: 'صحيح البخاري رقم 1936 وصحيح مسلم رقم 1111',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'فتح الباري لابن حجر ج 4 ص 163',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 27: سنن الصيام وصيام التطوع والاعتكاف
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_fasting_sunan_itikaf',
      title: 'سنن الصيام المستحبة وصيام التطوع وفقه الاعتكاف وليلة القدر',
      courseId: courseId,
      moduleId: 'mod_fasting_excuses_sunan',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_f4_1',
          title: 'تطبيق سنن الصوم: تعجيل الفطر، تأخير السحور، والدعاء عند الإفطار',
          description: 'السحور بركة، والفطر على رطب أو تمر أو ماء، وحفظ اللسان عن اللغو والغيبة.',
        ),
        LearningObjective(
          objectiveId: 'obj_f4_2',
          title: 'معرفة أيام صيام التطوع الفاضلة وأحكام وشروط الاعتكاف الشرعي',
          description: 'ست من شوال، عرفة، عاشوراء، الإثنين والخميس، والاعتكاف في المسجد في العشر الأواخر.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_f4_1',
          title: 'سنن الصوم المستحبة وصيام التطوع',
          contentType: LearningContentType.sourceText,
          content: 'يسن للصائم: 1. تأخير السحور وأكله ولو على جرعة ماء لقوله ﷺ: «تسحروا فإن في السحور بركة»، 2. تعجيل الفطر إذا غابت الشمس لقوله ﷺ: «لا يزال الناس بخير ما عجلوا الفطر»، 3. الإفطار على رطبات فإن لم يجد فتمرات فإن لم يجد حسا حسوات من ماء، 4. الدعاء عند الإفطار: «ذهب الظمأ وابتلت العروق وثبت الأجر إن شاء الله»، 5. كف اللسان عن الغيبة والنميمة والمشاتمة فإن سابه أحد فليقل: «إني صائم إني صائم». \nومن أفضل صيام التطوع: ستة أيام من شوال، ويوم عرفة لغير الحاج (يكفر سنتين)، ويوم عاشوراء وتاسوعاء (يكفر سنة)، وصيام الإثنين والخميس وثلاثة أيام من كل شهر (الأيام البيض 13 و14 و15).',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_f4_bukhari_suhur',
              evidenceKey: 'hadith_bukhari_suhur_barakah',
              citation: 'صحيح البخاري رقم 1923 وصحيح مسلم رقم 1095',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'رياض الصالحين ص 380',
        ),
        LessonSection.create(
          sectionId: 'sec_f4_2',
          title: 'فقه الاعتكاف في العشر الأواخر وتحري ليلة القدر',
          contentType: LearningContentType.example,
          content: 'الاعتكاف لزوم مسجد لطاعة الله تعالى، وهو سنة مؤكدة في العشر الأواخر من رمضان، كان النبي ﷺ يعتكفها حتى توفاه الله تفرغاً للعبادة وطلباً لليلة القدر التي هي خير من ألف شهر. ويشترط للاعتكاف: الإسلام، والتمييز، والطهارة من الحدث الأكبر، وكونه في مسجد تقام فيه صلاة الجماعة. ويبطل الاعتكاف بالخروج من المسجد لغير حاجة الإنسان الضرورية (كقضاء حاجة وأكل وشرب يتعذر في المسجد)، وبمباشرة النساء وجماعهن لقوله تعالى: ﴿وَلَا تُبَاشِرُوهُنَّ وَأَنتُمْ عَاكِفُونَ فِي الْمَسَاجِدِ﴾. ويتحرى المعتكف ليلة القدر في الأوتار من العشر الأواخر وأرجاها ليلة سبع وعشرين، ويكثر من دعاء: «اللهم إنك عفو تحب العفو فاعف عني».',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_f4_aisha_dua',
              evidenceKey: 'hadith_tirmidhi_qadr_dua',
              citation: 'جامع الترمذي رقم 3513 من حديث عائشة رضي الله عنها',
              sourceId: 'src_hadith_sunan',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 3 ص 185',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_mughni_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    return [lsn1, lsn2, lsn3, lsn4];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Medical nullifiers
    final q1 = QuizQuestion.create(
      questionId: 'q_fast_med_1',
      lessonId: 'lsn_fasting_nullifiers_contemporary',
      questionText: 'ما حكم استخدام بخاخ الربو واستعمال قطرة العين وأخذ حقنة الأنسولين في نهار رمضان؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_fm1_1', text: 'لا تفطر جميعها وصيام المسلم صحيح على الراجح المعتمد'),
        QuizOption(optionId: 'opt_fm1_2', text: 'تفطر كلها وتوجب القضاء والكفارة'),
        QuizOption(optionId: 'opt_fm1_3', text: 'تفطر الحقنة دون البخاخ والقطرة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'وفق قرارات المجامع الفقهية: بخاخ الربو غاز لا يصل للمعدة، وقطرة العين ليست منفذاً معتاداً، وحقنة الأنسولين علاجية غير مغذية، فلا تفطر.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_fasting_nullifiers',
      lessonId: 'lsn_fasting_nullifiers_contemporary',
      title: 'اختبار مفسدات الصيام والنوازل الطبية',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Kaffarah
    final q2 = QuizQuestion.create(
      questionId: 'q_fast_kaf_1',
      lessonId: 'lsn_fasting_excuses_expiation',
      questionText: 'ما هو الترتيب الشرعي لكفارة الجماع العمد في نهار رمضان؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_fk1_1', text: 'عتق رقبة، فإن لم يجد فصيام شهرين متتابعين، فإن لم يستطع فإطعام ستين مسكيناً'),
        QuizOption(optionId: 'opt_fk1_2', text: 'المخير بين الصيام أو الإطعام أو العتق بلا ترتيب'),
        QuizOption(optionId: 'opt_fk1_3', text: 'إطعام عشرة مساكين فقط ككفارة اليمين'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الكفارة مغلظة مرتبة بنص حديث الأعرابي في الصحيحين: العتق أولاً، ثم صيام شهرين متتابعين، ثم إطعام ستين مسكيناً عند العجز.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_fasting_excuses',
      lessonId: 'lsn_fasting_excuses_expiation',
      title: 'اختبار أعذار الصيام والكفارة المغلظة',
      questions: [q2],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2];
  }
}
