import '../../../modules/knowledge/domain/evidence_reference.dart';
import '../../../modules/knowledge/domain/fiqh_position.dart';
import '../../../modules/knowledge/domain/fiqh_school.dart';
import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/domain/source_record.dart';

/// المسائل الفقهية المقارنة في المعاملات والأسرة والآداب (14 مسألة محققة) (§13..§16).
class CanonicalFiqhTransactions {
  static List<FiqhTopic> buildTopics({
    required SourceRecord srcMajmoo,
    required SourceRecord srcMughni,
  }) {
    final list = <FiqhTopic>[];

    final evH21 = EvidenceReference.create(
      evidenceId: 'ev_h021',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_bukhari_2079',
      displayCitation: 'صحيح البخاري رقم 2079: البيعان بالخيار ما لم يتفرقا',
    );

    final evH28 = EvidenceReference.create(
      evidenceId: 'ev_h028',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_bukhari_010',
      displayCitation: 'صحيح مسلم: أفشوا السلام بينكم تحابوا',
    );

    final evH42 = EvidenceReference.create(
      evidenceId: 'ev_h042',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_nawawi_32',
      displayCitation: 'سنن ابن ماجه: لا ضرر ولا ضرار',
    );

    // =========================================================================
    // 1. فقه البيوع والمعاملات المالية (المسائل 19 إلى 24)
    // =========================================================================

    // 19. خيار المجلس في عقد البيع
    list.add(FiqhTopic.create(
      topicId: 'topic_khiyar_majlis',
      title: 'خيار المجلس في فسخ عقد البيع قبل التفرق',
      summary: 'ثبوت حق الفسخ للعاقدين ما داما في مجلس العقد ولم يتفرقا بالأبدان.',
      category: 'فقه المعاملات والبيوع',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_majlis_shafii_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'يثبت خيار المجلس للمتبايعين ما لم يتفرقا بأبدانهما من مكان العقد لحديث: «البيعان بالخيار ما لم يتفرقا».',
          scholarName: 'الشافعية والحنابلة وابن عمر وابن عباس',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 9 ص 164',
          evidences: [evH21],
        ),
        FiqhPosition.create(
          positionId: 'pos_majlis_hanafi_maliki',
          school: FiqhSchool.hanafi,
          rulingText: 'لا يثبت خيار المجلس بمجرد الإيجاب والقبول يلزم العقد، وحملوا التفرق في الحديث على التفرق بالأقوال لا الأبدان.',
          scholarName: 'الحنفية والمالكية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 4 ص 4',
        ),
      ],
    ));

    // 20. بيع العربون
    list.add(FiqhTopic.create(
      topicId: 'topic_bay_urbun',
      title: 'حكم بيع العربون واحتجاز المبلغ عند عدم إتمام الصفقة',
      summary: 'دفع جزء من الثمن على أنه إن تم البيع حُسب منه وإن فسخ المشتري كان للبائع.',
      category: 'فقه المعاملات والبيوع',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_urbun_hanbali',
          school: FiqhSchool.hanbali,
          rulingText: 'يجوز بيع العربون وصححه عمر بن الخطاب واشترى نافع بن عبد الحارث دار السجن لعمر بالعربون، ويستحقه البائع إن نكل المشتري.',
          scholarName: 'الحنابلة وابن سيرين ومجاهد',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 4 ص 182',
        ),
        FiqhPosition.create(
          positionId: 'pos_urbun_majority',
          school: FiqhSchool.majority,
          rulingText: 'لا يصح بيع العربون ويفسد العقد لكونه من أكل أموال الناس بالباطل ولحديث النهي عن بيع العربان.',
          scholarName: 'جمهور الفقهاء (الحنفية والمالكية والشافعية)',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 9 ص 368',
        ),
      ],
    ));

    // 21. الاحتكار والتسعير الجبري في الأزمات
    list.add(FiqhTopic.create(
      topicId: 'topic_ihtikar_pricing',
      title: 'الاحتكار في السلع الأساسية والتسعير الجبري للمصلحة العامة',
      summary: 'ضوابط حبس الأقوات والسلع وتدخل ولي الأمر بفرض التسعير العادل.',
      category: 'فقه المعاملات والبيوع',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_ihtikar_consensus',
          school: FiqhSchool.majority,
          rulingText: 'يحرم الاحتكار في أقوات الناس وسلعهم الضرورية إجماعاً لحديث: «لا يحتكر إلا خاطئ»، ويجوز لولي الأمر التسعير الجبري العادل عند الحاجة والغلاء الفاحش دفعاً للضرر.',
          scholarName: 'عامة الفقهاء واختيار شيخ الإسلام ابن تيمية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 4 ص 170',
          evidences: [evH42],
        ),
      ],
    ));

    // 22. بيع المرابحة للآمر بالشراء والمعاملات المصرفية
    list.add(FiqhTopic.create(
      topicId: 'topic_murabaha_banking',
      title: 'بيع المرابحة للآمر بالشراء في المؤسسات المصرفية الإسلامية',
      summary: 'شراء البنك للسلعة بطلب العميل ثم بيعها له بربح معلوم مقسطاً.',
      category: 'فقه المعاملات والبيوع',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_murabaha_islamic_banks',
          school: FiqhSchool.majority,
          rulingText: 'يجوز بشرط أن يتملك البنك السلعة حقيقة ويقبضها وتدخل في ضمانه قبل بيعها للآمر بالشراء خروجاً من شبهة بيع ما لا يملك.',
          scholarName: 'مجمع الفقه الإسلامي الدولي وهيئات الرقابة الشرعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'قرارات مجمع الفقه الإسلامي قرار رقم 40',
        ),
      ],
    ));

    // 23. عقد الإجارة المنتهية بالتمليك
    list.add(FiqhTopic.create(
      topicId: 'topic_ijara_tamleek',
      title: 'عقد الإجارة المنتهية بالتمليك وضوابطه الشرعية',
      summary: 'استئجار أصل مع الوعد بتمليكه للمستأجر في نهاية المدة بهبة أو بيع بثمن رمزي.',
      category: 'فقه المعاملات والبيوع',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_ijara_tamleek_valid',
          school: FiqhSchool.majority,
          rulingText: 'جائز شرعاً إذا فُصل عقد الإجارة عن عقد البيع بحيث لا يجتمعان في وثيقة عقد واحدة معلقة، وكان ضمان العين طوال مدة الإجارة على المؤجر.',
          scholarName: 'المجمع الفقهي الإسلامي لرابطة العالم الإسلامي ومجمع جدة',
          sourceId: srcMughni.sourceId,
          pageReference: 'قرارات المجمع الفقهي الدورة الثانية عشرة',
        ),
      ],
    ));

    // 24. التورق المصرفي المنظم
    list.add(FiqhTopic.create(
      topicId: 'topic_tawarruq_banking',
      title: 'التورق المصرفي المنظم والحصول على السيولة النقدية',
      summary: 'الفرق بين التورق الفردي الحقيقي والتورق المنظم عبر الوكالة المصرفية.',
      category: 'فقه المعاملات والبيوع',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_tawarruq_permissible_custom',
          school: FiqhSchool.hanbali,
          rulingText: 'التورق الفردي البسيط (شراء سلعة نسيئة وبيعها نقداً لطرف ثالث غير البائع) جائز عند الحنابلة للحاجة إلى النقد.',
          scholarName: 'جمهور الحنابلة وبعض الشافعية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 4 ص 180',
        ),
        FiqhPosition.create(
          positionId: 'pos_tawarruq_prohibited_figh_council',
          school: FiqhSchool.majority,
          rulingText: 'التورق المصرفي المنظم الذي يتولى فيه البنك قبض السلعة وبيعها نيابة عن العميل صوري ويشبه العينة الممنوعة شرعاً.',
          scholarName: 'مجمع الفقه الإسلامي الدولي بجدة (قرار رقم 179)',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'قرارات مجمع الفقه الإسلامي الدورة التاسعة عشرة',
        ),
      ],
    ));

    // =========================================================================
    // 2. فقه الأسرة والأحوال الشخصية (المسائل 25 إلى 28)
    // =========================================================================

    // 25. اشتراط الولي في نكاح الثيب والبكر
    list.add(FiqhTopic.create(
      topicId: 'topic_wali_nikah',
      title: 'اشتراط إذن الولي لصحة عقد النكاح',
      summary: 'هل يصح للمرأة البالغة الرشيدة أن تزوج نفسها بغير إذن وليها.',
      category: 'فقه الأسرة والأحوال',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_wali_majority',
          school: FiqhSchool.majority,
          rulingText: 'الولي شرط أساسي لصحة النكاح لقوله ﷺ: «لا نكاح إلا بولي وشاهدي عدل»، فإن زوجت نفسها فنكاحها باطل.',
          scholarName: 'جمهور الفقهاء (المالكية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 7 ص 5',
        ),
        FiqhPosition.create(
          positionId: 'pos_wali_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'يجوز للمرأة الحرة العاقلة البالغة أن تزوج نفسها لمن تختاره كفئاً بمهر المثل قياساً على صحة تصرفها في أموالها.',
          scholarName: 'الحنفية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 16 ص 142',
        ),
      ],
    ));

    // 26. الطلاق الثلاث بلفظ واحد
    list.add(FiqhTopic.create(
      topicId: 'topic_talaq_three_one_word',
      title: 'وقوع الطلاق الثلاث بلفظ واحد: يقع واحدة أم ثلاثاً',
      summary: 'حكم من طلق زوجته طلقة واحدة بلفظ الثلاث (كأنتِ طالق بالثلاث).',
      category: 'فقه الأسرة والأحوال',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_talaq_majority',
          school: FiqhSchool.majority,
          rulingText: 'يقع ثلاث طلقات بائناً بينونة كبرى مع الإثم والبدعة في اللفظ عند الأئمة الأربعة.',
          scholarName: 'الأئمة الأربعة (أبو حنيفة ومالك والشافعي وأحمد)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 7 ص 280',
        ),
        FiqhPosition.create(
          positionId: 'pos_talaq_ibn_taymiyyah',
          school: FiqhSchool.majority,
          rulingText: 'يقع طلقة واحدة رجعية لحديث ابن عباس في صحيح مسلم: «كان الطلاق على عهد رسول الله ﷺ وأبي بكر وسنتين من خلافة عمر طلاق الثلاث واحدة».',
          scholarName: 'ابن تيمية وابن القيم وجماعة من الصحابة والتابعين وقوانين الأحوال الشخصية المعاصرة',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 17 ص 85',
        ),
      ],
    ));

    // 27. عدة المتوفى عنها زوجها الحامل
    list.add(FiqhTopic.create(
      topicId: 'topic_iddah_pregnant_widow',
      title: 'عدة المتوفى عنها زوجها وهي حامل',
      summary: 'هل تنتهي عدتها بوضع الحمل أم بتربص أربعة أشهر وعشراً.',
      category: 'فقه الأسرة والأحوال',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_pregnant_consensus',
          school: FiqhSchool.majority,
          rulingText: 'تنتهي عدتها وتستحل النكاح بوضع حملها ولو بعد وفاة زوجها بلحظات لحديث سبيعة الأسلمية، وقوله تعالى ﴿وَأُولَاتُ الْأَحْمَالِ أَجَلُهُنَّ أَن يَضَعْنَ حَمْلَهُنَّ﴾ مخصص لآية التربص.',
          scholarName: 'جمهور الصحابة والفقهاء الأربعة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 7 ص 440',
        ),
      ],
    ));

    // 28. نفقة الزوجة العاملة الناشز
    list.add(FiqhTopic.create(
      topicId: 'topic_nafaqah_working_wife',
      title: 'سقوط نفقة الزوجة العاملة بالنشوز عند الخروج بغير إذن',
      summary: 'مدى استحقاق الزوجة للنفقة والسكنى إذا خرجت للعمل دون موافقة الزوج.',
      category: 'فقه الأسرة والأحوال',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_nafaqah_general',
          school: FiqhSchool.majority,
          rulingText: 'إذا خرجت المرأة للعمل بإذن زوجها الصريح أو المشروط في العقد استحقت النفقة كاملة، فإن خرجت بغير إذنه كانت ناشزاً وسقطت نفقتها حتى ترجع.',
          scholarName: 'الفقهاء الأربعة والمجامع الفقهية المعاصرة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 7 ص 585',
        ),
      ],
    ));

    // =========================================================================
    // 3. الجنايات والديات والآداب والمستجدات (المسائل 29 إلى 32)
    // =========================================================================

    // 29. القصاص في القتل شبه العمد
    list.add(FiqhTopic.create(
      topicId: 'topic_qisas_shibh_amd',
      title: 'حكم القصاص والدية المغلظة في القتل شبه العمد',
      summary: 'القتل بما لا يقتل غالباً كالعصا الصغيرة واللطمة مع قصد العدوان.',
      category: 'فقه الجنايات والحدود',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_shibh_amd_majority',
          school: FiqhSchool.majority,
          rulingText: 'لا قصاص فيه بل تجب فيه دية مغلظة مائة من الإبل أربعون منها خلفة في بطونها أولادها على العاقلة مع الكفارة.',
          scholarName: 'جمهور الفقهاء (الحنفية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 8 ص 253',
        ),
        FiqhPosition.create(
          positionId: 'pos_shibh_amd_maliki',
          school: FiqhSchool.maliki,
          rulingText: 'القتل إما عمد يوجب القصاص أو خطأ يوجب الدية، ولا يثبت شبه العمد في القصاص من المكلف البالغ إلا في تأديب الوالد لولده.',
          scholarName: 'المالكية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 18 ص 330',
        ),
      ],
    ));

    // 30. دية المرأة مقارنة بدية الرجل
    list.add(FiqhTopic.create(
      topicId: 'topic_diyah_woman',
      title: 'مقدار دية المرأة في النفس والجراح قياساً على دية الرجل',
      summary: 'دية النفس في المرأة على النصف من دية الرجل بالإجماع، وتفصيل جراحها.',
      category: 'فقه الجنايات والحدود',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_diyah_majority',
          school: FiqhSchool.majority,
          rulingText: 'دية المرأة الحرة المسلمة في النفس نصف دية الرجل المسلم بإجماع أهل العلم، وفي جراحها توازي دية الرجل حتى تبلغ ثلث الدية فتنصف عند مالك والشافعي وأحمد.',
          scholarName: 'الأئمة الأربعة وعامة علماء المسلمين',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 8 ص 470',
        ),
      ],
    ));

    // 31. حكم مصافحة المرأة الأجنبية والسلام عليها
    list.add(FiqhTopic.create(
      topicId: 'topic_salam_manners',
      title: 'حكم إلقاء السلام ومصافحة المرأة الأجنبية الشابة',
      summary: 'الضوابط الشرعية في السلام والمصافحة بين غير المحارم.',
      category: 'الآداب والأخلاق الشرعية',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_musafahah_majority',
          school: FiqhSchool.majority,
          rulingText: 'تحرم مصافحة المرأة الأجنبية الشابة لحديث: «لأن يُطعن في رأس أحدكم بمخيط من حديد خير له من أن يمس امرأة لا تحل له»، ويجوز إلقاء السلام رداً وابتداءً عند أمن الفتنة وبدون خضوع بالقول.',
          scholarName: 'جمهور الفقهاء (الحنفية والمالكية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 7 ص 342',
          evidences: [evH28],
        ),
      ],
    ));

    // 32. التداوي بالمحرمات والمستجدات الطبية (زراعة الأعضاء)
    list.add(FiqhTopic.create(
      topicId: 'topic_organ_transplant',
      title: 'نقل الأعضاء وزراعتها والتداوي بالمستجدات الطبية',
      summary: 'حكم التبرع بالأعضاء بعد الوفاة الدماغية أو في حال الحياة لإنقاذ نفس معصومة.',
      category: 'الآداب والأخلاق الشرعية',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_organ_permissible',
          school: FiqhSchool.majority,
          rulingText: 'يجوز التبرع بالأعضاء بعد الوفاة الدماغية المحققة أو في الحياة بشرط عدم بيعها وبألا يؤدي التبرع إلى الإضرار بحياة المتبرع أو تعطيل عضو أساسي له حفظاً لنفس الإنسان.',
          scholarName: 'مجمع الفقه الإسلامي الدولي وهيئة كبار العلماء بالمملكة',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'قرارات مجمع الفقه الإسلامي قرار رقم 26',
          evidences: [evH42],
        ),
      ],
    ));

    return list;
  }
}
