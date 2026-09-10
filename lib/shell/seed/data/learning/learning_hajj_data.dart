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

/// بيانات مقرر فقه الحج والعمرة والزيارة النبوية المشروعة (5 دروس تأصيلية + اختبارات استيعاب)
class LearningHajjData {
  static const String courseId = 'course_fiqh_hajj_adv';
  static const String pathId = 'path_fiqh_worship_comprehensive';

  static Course getCourse() {
    return Course.create(
      courseId: courseId,
      pathId: pathId,
      title: 'مقرر فقه الحج والعمرة والزيارة النبوية المشروعة',
      description: 'دراسة فقهية تأصيلية شاملة لشروط الحج والاستطاعة، والمواقيت، والأنساك الثلاثة، ومحظورات الإحرام، وأركان وواجبات الحج خطوة بخطوة، وصفة العمرة، وآداب الزيارة بالمدينة المنورة.',
      level: lp.LearningLevel.beginner,
      moduleIds: const ['mod_hajj_prerequisites_miqat', 'mod_hajj_rituals_umrah'],
      author: 'لجنة التأصيل والتعليم المنهجي بسِراج',
      version: 1,
    );
  }

  static List<CourseModule> getModules() {
    return [
      CourseModule(
        moduleId: 'mod_hajj_prerequisites_miqat',
        courseId: courseId,
        title: 'الوحدة الأولى: شروط الحج والمواقيت والأنساك ومحظورات الإحرام',
        description: 'بيان شروط وجوب الحج، والمواقيت الزمانية والمكانية، والمقارنة بين التمتع والقِران والإفراد، ومحظورات الإحرام وفديتها.',
        orderIndex: 1,
        lessonIds: const [
          'lsn_hajj_conditions_miqat',
          'lsn_hajj_ihram_prohibitions',
        ],
      ),
      CourseModule(
        moduleId: 'mod_hajj_rituals_umrah',
        courseId: courseId,
        title: 'الوحدة الثانية: أعمال الحج والعمرة خطوة بخطوة والزيارة النبوية',
        description: 'الأركان الأربعة والواجبات السبعة، وأعمال أيام منى وعرفة ومزدلفة والنحر والتشريق، وصفة العمرة، والزيارة الشرعية لمسجد النبي ﷺ.',
        orderIndex: 2,
        prerequisiteModuleIds: const ['mod_hajj_prerequisites_miqat'],
        lessonIds: const [
          'lsn_hajj_pillars_duties',
          'lsn_hajj_step_by_step',
          'lsn_hajj_umrah_visitation',
        ],
      ),
    ];
  }

  static List<Lesson> getLessons() {
    // -------------------------------------------------------------------------
    // Lesson 28: شروط الحج والاستطاعة والمواقيت والأنساك
    // -------------------------------------------------------------------------
    final lsn1 = Lesson.create(
      lessonId: 'lsn_hajj_conditions_miqat',
      title: 'شروط وجوب الحج والاستطاعة والمواقيت المكانية والأنساك الثلاثة',
      courseId: courseId,
      moduleId: 'mod_hajj_prerequisites_miqat',
      orderIndex: 1,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_h1_1',
          title: 'معرفة شروط وجوب الحج الخمسة ومفهوم الاستطاعة الشرعية',
          description: 'الإسلام، العقل، البلوغ، الحرية، والاستطاعة المالية والبدنية وأمن الطريق والمحرم للمرأة.',
        ),
        LearningObjective(
          objectiveId: 'obj_h1_2',
          title: 'التمييز بين المواقيت المكانية الخمسة وأنساك الحج الثلاثة',
          description: 'ذو الحليفة، الجحفة، يلملم، قرن المنازل، وذات عرق، والفرق بين التمتع والقِران والإفراد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_h1_1',
          title: 'فرضية الحج وشروط وجوبه والاستطاعة',
          contentType: LearningContentType.sourceText,
          content: 'الحج هو الركن الخامس من أركان الإسلام، فرض في السنة التاسعة من الهجرة لقوله تعالى: ﴿وَلِلَّهِ عَلَى النَّاسِ حِجُّ الْبَيْتِ مَنِ اسْتَطَاعَ إِلَيْهِ سَبِيلًا ۚ وَمَن كَفَرَ فَإِنَّ اللَّهَ غَنِيٌّ عَنِ الْعَالَمِينَ﴾ [آل عمران: 97]. والحج فرض في العمر مرة واحدة على الفور عند القدرة عليه لقوله ﷺ: «الحج مرة فمن زاد فهو تطوع». وتشترط لوجوبه: 1. الإسلام، 2. العقل، 3. البلوغ، 4. الحرية، 5. الاستطاعة: وتشمل وجود الزاد ووسيلة النقل المأمونة، والقدرة البدنية، وأمن الطريق، وخلو المرأة من الموانع مع وجود زوج أو محرم يرافقها في السفر.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h1_ali_imran_97',
              evidenceKey: '3:97',
              citation: 'سورة آل عمران: الآية 97',
              sourceId: 'src_quran_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 3 ص 215',
        ),
        LessonSection.create(
          sectionId: 'sec_h1_2',
          title: 'المواقيت المكانية وأنساك الحج الثلاثة',
          contentType: LearningContentType.explanation,
          content: 'المواقيت المكانية التي وقتها النبي ﷺ ولا يجوز لمريد الحج أو العمرة تجاوزها بغير إحرام هي: 1. ذو الحليفة (أبيار علي) لأهل المدينة، 2. الجحفة (قرب رابغ) لأهل الشام ومصر والمغرب، 3. قَرْن المنازل (السيل الكبير) لأهل نجد والطائف، 4. يَلَمْلَم (السعدية) لأهل اليمن، 5. ذات عِرْق لأهل العراق والمشرق. ومن كان دون هذه المواقيت كأهل مكة وجدة فيحرم من مكانه. \nوأنساك الحج ثلاثة: \nأ) التمتع: أن يحرم بالعمرة في أشهر الحج ثم يتحلل منها، ثم يحرم بالحج في نفس العام، وعليه دم هدي شكران، وهو أفضل الأنساك.\nب) القِران: أن يحرم بالحج والعمرة معاً، أو يحرم بالعمرة ثم يدخل الحج عليها قبل طوافها، ولا يتحلل حتى يفرغ من أعمال الحج، وعليه هدي.\nج) الإفراد: أن يحرم بالحج وحده، ولا هدي عليه.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h1_bukhari_mawaqit',
              evidenceKey: 'hadith_bukhari_mawaqit',
              citation: 'صحيح البخاري رقم 1524 وصحيح مسلم رقم 1181 من حديث ابن عباس رضي الله عنهما',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المجموع شرح المهذب ج 7 ص 198',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_muslim_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 29: الإحرام ومحظوراته والفدية
    // -------------------------------------------------------------------------
    final lsn2 = Lesson.create(
      lessonId: 'lsn_hajj_ihram_prohibitions',
      title: 'الإحرام: سننه، ومحظوراته التسعة، وأقسام الفدية الشرعية',
      courseId: courseId,
      moduleId: 'mod_hajj_prerequisites_miqat',
      orderIndex: 2,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_h2_1',
          title: 'معرفة سنن الإحرام والتلبية النبوية الخالدة',
          description: 'الاغتسال، والتطيب في البدن قبل الإحرام، ولبس إزار ورداء أبيضين نظيفين، والتلبية.',
        ),
        LearningObjective(
          objectiveId: 'obj_h2_2',
          title: 'حفظ محظورات الإحرام التسعة والفرق بين ما فيه فدية أذى أو جزاء صيد أو إفساد الحج',
          description: 'تطبيق قوله تعالى: ﴿فَمَن فَرَضَ فِيهِنَّ الْحَجَّ فَلَا رَفَثَ وَلَا فُسُوقَ وَلَا جِدَالَ فِي الْحَجِّ﴾.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_h2_1',
          title: 'صفة الإحرام وسننه والتلبية',
          contentType: LearningContentType.sourceText,
          content: 'الإحرام هو نية الدخول في النسك (حجاً أو عمرة). يسن قبله: التنظف، وقص الأظفار والشارب، والاغتسال، وتطيب البدن بما لا يمس ثياب الإحرام، ويتجرد الرجل من المخيط المحيط ويلبس إزاراً ورداءً أبيضين نعلين، أما المرأة فتحرم في ثيابها العادية الساترة غير متبرجة وتجتنب النقاب والقفازين وتسدل على وجهها عند مرور الرجال الأجانب. ثم يهل بالنسك قائلاً: «لبيك عمرة متمتعاً بها إلى الحج» أو «لبيك حجاً»، ثم يرفع صوته بالتلبية النبوية: «لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الحَمْدَ وَالنِّعْمَةَ لَكَ وَالمُلْكَ، لا شَرِيكَ لَكَ».',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h2_bukhari_talbiyah',
              evidenceKey: 'hadith_bukhari_talbiyah',
              citation: 'صحيح البخاري رقم 1549 وصحيح مسلم رقم 1184 من حديث عبد الله بن عمر رضي الله عنهما',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'زاد المعاد ج 2 ص 110',
        ),
        LessonSection.create(
          sectionId: 'sec_h2_2',
          title: 'محظورات الإحرام التسعة وأقسام الفدية',
          contentType: LearningContentType.explanation,
          content: 'محظورات الإحرام ما يحرم على المحرم فعله بسبب إحرامه: \n1. حلق شعر الرأس أو البدن أو قصه، 2. تقليم الأظفار، 3. استعمال الطيب في الثوب أو البدن بعد الإحرام، 4. تغطية الرأس بملاصق للرجل، 5. لبس المخيط المفصل على قدر البدن للرجل (كالقميص والسروال والجبة)، 6. قتل صيد البر الوحشي المأكول والتعرض له، 7. عقد النكاح لنفسه أو لغيره (ولا فدية فيه وهو باطل)، 8. المباشرة لشهوة فيما دون الفرج، 9. الجماع في الفرج وهو أعظمها إثماً؛ فإن كان قبل التحلل الأول فسد حجه ولزمه المضي فيه وقضاؤه من قابل وبدنة (ناقة أو بقرة). \nوفدية الأذى في المحظورات الخمسة الأولى على التخيير: صيام ثلاثة أيام، أو إطعام ستة مساكين (لكل مسكين نصف صاع)، أو ذبح شاة توزع على فقراء الحرم لقوله تعالى: ﴿فَفِدْيَةٌ مِّن صِيَامٍ أَوْ صَدَقَةٍ أَوْ نُسُكٍ﴾.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h2_kaab_fidyah',
              evidenceKey: 'hadith_bukhari_kaab_fidyah',
              citation: 'صحيح البخاري رقم 1814 في حديث كعب بن عجرة رضي الله عنه',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 3 ص 290',
        ),
      ],
      sources: const ['src_quran_canonical', 'src_bukhari_canonical', 'src_muslim_canonical', 'src_zad_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 30: أركان الحج وواجباته وسننه
    // -------------------------------------------------------------------------
    final lsn3 = Lesson.create(
      lessonId: 'lsn_hajj_pillars_duties',
      title: 'أركان الحج الأربعة وواجباته السبعة وسننه والفرق الحاسم بينها',
      courseId: courseId,
      moduleId: 'mod_hajj_rituals_umrah',
      orderIndex: 3,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_h3_1',
          title: 'حفظ أركان الحج الأربعة التي لا يصح الحج إلا بها ولا تجبر بدم',
          description: 'الإحرام، والوقوف بعرفة، وطواف الإفاضة، والسعي بين الصفا والمروة.',
        ),
        LearningObjective(
          objectiveId: 'obj_h3_2',
          title: 'حفظ واجبات الحج السبعة التي يجبر تركها السهو بذبح فدية في مكة',
          description: 'الإحرام من الميقات، الوقوف بعرفة للغروب، المبيت بمزدلفة ومنى، رمي الجمار، الحلق أو التقصير، وطواف الوداع.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_h3_1',
          title: 'أركان الحج الأربعة العظام',
          contentType: LearningContentType.sourceText,
          content: 'أركان الحج أربعة لا يسقط منها شيء ولا يجزئ عنها دم، ومن ترك ركناً لم يتم حجه حتى يأتي به: \n1. الإحرام: وهو نية الدخول في النسك.\n2. الوقوف بعرفة: لقوله ﷺ: «الحَجُّ عَرَفَةُ» [رواه أصحاب السنن بإسناد صحيح]، ووقته من زوال شمس يوم التاسع إلى طلوع فجر يوم النحر، فمن فاته الوقوف بعرفة في هذا الوقت فاته الحج وتحلل بعمرة ولزمه القضاء.\n3. طواف الإفاضة (طواف الزيارة): لقوله تعالى: ﴿وَلْيَطَّوَّفُوا بِالْبَيْتِ الْعَتِيقِ﴾ [الحج: 29].\n4. السعي بين الصفا والمروة سبعة أشواط: لقوله ﷺ: «اسْعَوْا، فإنَّ اللَّهَ كَتَبَ عَلَيْكُمُ السَّعْيَ» [رواه أحمد والشافعي].',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h3_arafah_hadith',
              evidenceKey: 'hadith_tirmidhi_arafah',
              citation: 'سنن الترمذي رقم 889 وسنن أبي داود: «الحج عرفة فمن جاء قبل صلاة الفجر من ليلة جمع فقد تم حجه»',
              sourceId: 'src_hadith_sunan',
            ),
          ],
          sourceAttribution: 'بداية المجتهد ونهاية المقتصد ج 1 ص 320',
        ),
        LessonSection.create(
          sectionId: 'sec_h3_2',
          title: 'واجبات الحج السبعة وسننه',
          contentType: LearningContentType.explanation,
          content: 'واجبات الحج سبعة، من ترك واجباً منها لزمه دم (ذبح شاة في مكة توزع على فقرائها) ويصح حجه: \n1. الإحرام من الميقات المعتبر شرعاً،\n2. الوقوف بعرفة إلى غروب الشمس لمن وقف نهاراً،\n3. المبيت بمزدلفة ليلة النحر إلى ما بعد منتصف الليل على الأقل،\n4. المبيت بمنى ليالي أيام التشريق (ليلة 11 و12 للمتعجل و13 للمتأخر)،\n5. رمي الجمار مرتباً (جمرة العقبة يوم النحر، ثم الصغرى فالوسطى فالكبرى في أيام التشريق)،\n6. الحلق أو التقصير لجميع شعر الرأس، والحلق أفضل للرجال لقوله ﷺ: «اللهم ارحم المحلقين، قيل: والمقصرين؟ قال: والمحلقين (ثلاثاً) ثم قال: والمقصرين»، أما المرأة فتقصر من أطراف شعرها قدر أنملة،\n7. طواف الوداع عند الخروج من مكة ويسقط عن الحائض والنفساء.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h3_muhallaqin',
              evidenceKey: 'hadith_bukhari_muhallaqin',
              citation: 'صحيح البخاري رقم 1727 وصحيح مسلم رقم 1301',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'كشاف القناع عن متن الإقناع ج 2 ص 410',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_kashaf_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 31: أعمال الحج خطوة بخطوة من التروية للوداع
    // -------------------------------------------------------------------------
    final lsn4 = Lesson.create(
      lessonId: 'lsn_hajj_step_by_step',
      title: 'خريطة أعمال الحج الميدانية خطوة بخطوة من يوم التروية إلى طواف الوداع',
      courseId: courseId,
      moduleId: 'mod_hajj_rituals_umrah',
      orderIndex: 4,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_h4_1',
          title: 'تتبع أعمال الحج الزمنية: يوم التروية (8)، يوم عرفة (9)، يوم النحر (10)',
          description: 'المبيت بمنى، النفرة لعرفة ثم لمزدلفة، وأعمال يوم العيد الأربعة.',
        ),
        LearningObjective(
          objectiveId: 'obj_h4_2',
          title: 'معرفة التحلل الأول والتحلل الثاني وأيام التشريق وطواف الوداع',
          description: 'التحلل الأصغر بفعل اثنين من ثلاثة (الرمي والحلق والطواف)، والتحلل الأكبر بفعل الثلاثة.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_h4_1',
          title: 'المسار الميداني: يوم التروية ويوم عرفة وليلة مزدلفة',
          contentType: LearningContentType.example,
          content: '• يوم التروية (8 ذو الحجة): يحرم المتمتع بالحج ضحى من مكانه بمكة، ويخرج الحجاج جميعاً إلى منى، فيصلون بها الظهر والعصر والمغرب والعشاء وفجر التاسع قصراً بلا جمع، وهو سنة.\n• يوم عرفة (9 ذو الحجة): بعد طلوع شمس التاسع يسير الحجاج إلى نمرة، ثم بعد الزوال يصلون الظهر والعصر جمع تقديم وقصراً بأذان وإقامتين، ثم يدخلون حدود عرفة، ويجتهدون في الدعاء والتضرع مستقبلي القبلة حتى تغرب الشمس تماماً.\n• ليلة مزدلفة: بعد غروب شمس يوم عرفة يدفع الحجاج بسكينة ووقار إلى مزدلفة، فيصلون بها المغرب ثلاثاً والعشاء ركعتين جمع تأخير بأذان وإقامتين فور وصولهم، ويبيتون بها حتى يصلوا الفجر ويقفوا عند المشعر الحرام داعين مكبرين إلى الإسفار جداً.',
          sourceAttribution: 'صفة حجة النبي ﷺ للشيخ الألباني من حديث جابر في صحيح مسلم رقم 1218',
        ),
        LessonSection.create(
          sectionId: 'sec_h4_2',
          title: 'أعمال يوم النحر وأيام التشريق والتحلل',
          contentType: LearningContentType.example,
          content: '• يوم النحر (10 ذو الحجة): يوم الحج الأكبر وله أربعة أعمال مرتبة في السنة: 1. رمي جمرة العقبة الكبرى بسبع حصيات مكبراً مع كل حصاة وتنقطع التلبية مع أول حصاة، 2. ذبح الهدي للمتمتع والقارن، 3. الحلق أو التقصير (وبه يحصل التحلل الأول فيحل له كل شيء عدا النساء)، 4. طواف الإفاضة بالبيت والسعي (وبه يحصل التحلل الثاني فيحل له كل شيء حتى النساء).\n• أيام التشريق (11 و12 و13 ذو الحجة): يبيت الحجاج بمنى، ويرمون الجمرات الثلاث بعد زوال الشمس كل يوم: الصغرى ثم الوسطى ثم الكبرى بسبع حصيات لكل جمرة مع الدعاء الطويل بعد الأوليين. ومن تعجل في يومين فلا إثم عليه بشرط الخروج من منى قبل غروب شمس اليوم الثاني عشر. فإذا أراد مغادرة مكة طاف طواف الوداع ليكون آخر عهده بالبيت.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h4_muslim_jaber',
              evidenceKey: 'hadith_muslim_jaber_hajj',
              citation: 'صحيح مسلم رقم 1218 في حديث جابر بن عبد الله الطويل في صفة حجة الوداع',
              sourceId: 'src_muslim_canonical',
            ),
          ],
          sourceAttribution: 'الشرح الممتع لابن عثيمين ج 7 ص 310',
        ),
      ],
      sources: const ['src_muslim_canonical', 'src_bukhari_canonical', 'src_mumti_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    // -------------------------------------------------------------------------
    // Lesson 32: صفة العمرة الكاملة وأحكام الزيارة النبوية
    // -------------------------------------------------------------------------
    final lsn5 = Lesson.create(
      lessonId: 'lsn_hajj_umrah_visitation',
      title: 'صفة العمرة الكاملة خطوة بخطوة وفقه الزيارة المشروعة بالمدينة المنورة',
      courseId: courseId,
      moduleId: 'mod_hajj_rituals_umrah',
      orderIndex: 5,
      objectives: const [
        LearningObjective(
          objectiveId: 'obj_h5_1',
          title: 'إتقان صفة العمرة بأركانها الثلاثة (الإحرام، الطواف، السعي) وواجبها (الحلق/التقصير)',
          description: 'الاضطباع والرمل في الطواف، وسنن السعي، وشرب ماء زمزم والتضلع منه.',
        ),
        LearningObjective(
          objectiveId: 'obj_h5_2',
          title: 'معرفة آداب زيارة المسجد النبوي الشريف والسلام على النبي ﷺ وصاحبيه',
          description: 'شد الرحال للمسجد النبوي، والصلاة في الروضة الشريفة، وزيارة قباء والبقيع وشهداء أحد.',
        ),
      ],
      sections: [
        LessonSection.create(
          sectionId: 'sec_h5_1',
          title: 'الصفة النبوية للعمرة التامة',
          contentType: LearningContentType.example,
          content: 'العمرة ركن أو سنة مؤكدة وفضلها عظيم لقوله ﷺ: «العمرة إلى العمرة كفارة لما بينهما، والحج المبرور ليس له جزاء إلا الجنة» [متفق عليه]. \nأعمالها: 1. الإحرام من الميقات والتلبية، 2. الطواف بالبيت العتيق سبعة أشواط يبدأ من محاذاة الحجر الأسود مكبراً ويجعل الكعبة عن يساره، ويسن للرجل الاضطباع (كشف الكتف الأيمن) والرمل (الإسراع في المشي مع تقارب الخطى في الثلاثة أشواط الأولى)، واستلام الركن اليماني وقول: ﴿رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ﴾ بين الركنين، 3. صلاة ركعتين خلف مقام إبراهيم والشرب من زمزم، 4. السعي بين الصفا والمروة 7 أشواط يبدأ بالصفا ويختم بالمروة، 5. الحلق أو التقصير وبه تتم العمرة ويتحلل تماماً.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h5_bukhari_umrah',
              evidenceKey: 'hadith_bukhari_umrah_kaffarah',
              citation: 'صحيح البخاري رقم 1773 وصحيح مسلم رقم 1349',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المغني لابن قدامة ج 3 ص 220',
        ),
        LessonSection.create(
          sectionId: 'sec_h5_2',
          title: 'الزيارة الشرعية للمسجد النبوي الشريف وآدابها',
          contentType: LearningContentType.sourceText,
          content: 'زيارة المسجد النبوي سنة مستحبة في كل وقت وليست من أركان الحج ولا واجباته ولا إحرام لها، لقوله ﷺ: «لا تُشَدُّ الرِّحالُ إلَّا إلى ثَلاثَةِ مَساجِدَ: المَسْجِدِ الحَرامِ، ومَسْجِدِ الرَّسُولِ ﷺ، ومَسْجِدِ الأقْصى» [متفق عليه]. وصلاة فيه خير من ألف صلاة فيما سواه إلا المسجد الحرام. \nوآدابها: يدخل مقدماً رجله اليمنى قائلاً دعاء دخول المسجد، ويصلي ركعتين تحية المسجد في الروضة الشريفة إن تيسر لقوله: «ما بين بيتي ومنبري روضة من رياض الجنة»، ثم يأتي القبر الشريف بأدب وخفض صوت مستقبلاً الحجرة الشريفة فيسلم قائلاً: «السلام عليك يا رسول الله ورحمة الله وبركاته، جزاك الله عن أمتك خير الجزاء...»، ثم يخطو خطوة عن يمينه فيسلم على أبي بكر الصديق، ثم خطوة فيسلم على عمر الفاروق رضي الله عنهما. ويسن كذلك زيارة مسجد قباء والصلاة فيه (تعدل عمرة)، وزيارة مقبرة البقيع وشهداء أحد للدعاء لهم والاعتبار.',
          evidenceLinks: [
            EvidenceLink.create(
              evidenceId: 'ev_h5_bukhari_shadd',
              evidenceKey: 'hadith_bukhari_shadd_rihal',
              citation: 'صحيح البخاري رقم 1189 وصحيح مسلم رقم 1397',
              sourceId: 'src_bukhari_canonical',
            ),
          ],
          sourceAttribution: 'المجموع شرح المهذب للنووي ج 8 ص 270',
        ),
      ],
      sources: const ['src_bukhari_canonical', 'src_muslim_canonical', 'src_majmoo_canonical'],
      authorOrEditor: 'مركز المناهج الشرعية',
    );

    return [lsn1, lsn2, lsn3, lsn4, lsn5];
  }

  static List<Quiz> getQuizzes() {
    // Quiz 1: Hajj prerequisites & mawaqit
    final q1 = QuizQuestion.create(
      questionId: 'q_hajj_miqat_1',
      lessonId: 'lsn_hajj_conditions_miqat',
      questionText: 'ما هو النسك الذي يحرم فيه الحاج بالعمرة في أشهر الحج ويتحلل منها ثم يحرم بالحج في نفس العام وتلزمه فدية هدي؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_hm1_1', text: 'التمتع وهو أفضل الأنساك'),
        QuizOption(optionId: 'opt_hm1_2', text: 'الإفراد'),
        QuizOption(optionId: 'opt_hm1_3', text: 'القِران'),
      ],
      correctOptionIndices: const [0],
      explanation: 'التمتع هو الإحرام بالعمرة في أشهر الحج والتحلل منها ثم الإحرام بالحج في نفس العام، ويلزم المتمتع دم شكران لجمعه بين النسكين في سفرة واحدة.',
    );

    final quiz1 = Quiz.create(
      quizId: 'quiz_hajj_miqat',
      lessonId: 'lsn_hajj_conditions_miqat',
      title: 'اختبار شروط الحج والمواقيت والأنساك',
      questions: [q1],
      passingScorePercentage: 75,
    );

    // Quiz 2: Hajj pillars
    final q2 = QuizQuestion.create(
      questionId: 'q_hajj_pillars_1',
      lessonId: 'lsn_hajj_pillars_duties',
      questionText: 'ما الحكم إذا غربت شمس يوم النحر ولم يقف الحاج بعرفة مطلقاً حتى طلع فجر يوم العيد؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_hp1_1', text: 'فاته الحج باتفاق ويتحلل بعمرة ويلزمه القضاء من قابل'),
        QuizOption(optionId: 'opt_hp1_2', text: 'يصح حجه ويلزمه ذبح شاة فدية في مكة'),
        QuizOption(optionId: 'opt_hp1_3', text: 'يقف في اليوم التالي وتجزئه الصدقة'),
      ],
      correctOptionIndices: const [0],
      explanation: 'لقوله ﷺ: «الحج عرفة»، فمن طلع عليه فجر يوم النحر ولم يقف بعرفة فقد فاته الحج باتفاق الأمة، ويتحلل بعمل عمرة وعليه القضاء.',
    );

    final quiz2 = Quiz.create(
      quizId: 'quiz_hajj_pillars',
      lessonId: 'lsn_hajj_pillars_duties',
      title: 'اختبار أركان الحج وواجباته',
      questions: [q2],
      passingScorePercentage: 75,
    );

    // Quiz 3: Umrah & Visitation
    final q3 = QuizQuestion.create(
      questionId: 'q_hajj_umrah_1',
      lessonId: 'lsn_hajj_umrah_visitation',
      questionText: 'كم عدد أشواط الطواف بالبيت العتيق وأشواط السعي بين الصفا والمروة في العمرة؟',
      questionType: QuestionType.multipleChoice,
      options: const [
        QuizOption(optionId: 'opt_hu1_1', text: 'سبعة أشواط في الطواف تبدأ بالحجر الأسود، وسبعة أشواط في السعي تبدأ بالصفا وتختم بالمروة'),
        QuizOption(optionId: 'opt_hu1_2', text: 'ثلاثة أشواط في كل منهما'),
        QuizOption(optionId: 'opt_hu1_3', text: 'خمسة أشواط في الطواف وسبعة في السعي'),
      ],
      correctOptionIndices: const [0],
      explanation: 'الطواف سبعة أشواط كاملة حول البيت يبدأ من الحجر الأسود، والسعي سبعة أشواط يبدأ من الصفا ويختم بالمروة.',
    );

    final quiz3 = Quiz.create(
      quizId: 'quiz_hajj_umrah',
      lessonId: 'lsn_hajj_umrah_visitation',
      title: 'اختبار صفة العمرة وزيارة المسجد النبوي',
      questions: [q3],
      passingScorePercentage: 75,
    );

    return [quiz1, quiz2, quiz3];
  }
}
