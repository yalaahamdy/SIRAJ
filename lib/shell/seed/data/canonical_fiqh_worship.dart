import '../../../modules/knowledge/domain/evidence_reference.dart';
import '../../../modules/knowledge/domain/fiqh_position.dart';
import '../../../modules/knowledge/domain/fiqh_school.dart';
import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/domain/source_record.dart';

/// المسائل الفقهية المقارنة في العبادات (18 مسألة محققة في الطهارة، الصلاة، الجنائز، الزكاة، الصيام، الحج) (§13..§16).
class CanonicalFiqhWorship {
  static List<FiqhTopic> buildTopics({
    required SourceRecord srcMajmoo,
    required SourceRecord srcMughni,
  }) {
    final list = <FiqhTopic>[];

    // الأدلة الحديثية المستند إليها
    final evH1 = EvidenceReference.create(
      evidenceId: 'ev_h001',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_001',
      displayCitation: 'صحيح البخاري رقم 1: حديث النيات ومقاصد الأعمال',
    );

    final evH6 = EvidenceReference.create(
      evidenceId: 'ev_h006',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_nawawi_23',
      displayCitation: 'صحيح مسلم رقم 223: الطهور شطر الإيمان',
    );

    final evH33 = EvidenceReference.create(
      evidenceId: 'ev_h033',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_abudawud_603',
      displayCitation: 'سنن أبي داود رقم 603: إنما جعل الإمام ليؤتم به',
    );

    final evH35 = EvidenceReference.create(
      evidenceId: 'ev_h035',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_bukhari_631',
      displayCitation: 'صحيح البخاري: صلوا كما رأيتموني أصلي',
    );

    final evH42 = EvidenceReference.create(
      evidenceId: 'ev_h042',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_nawawi_32',
      displayCitation: 'سنن ابن ماجه رقم 2340: لا ضرر ولا ضرار',
    );

    // =========================================================================
    // 1. فقه الطهارة (المسائل 1 إلى 4)
    // =========================================================================

    // 1. المسح على الخفين والجوربين
    list.add(FiqhTopic.create(
      topicId: 'topic_wiping_khuffayn',
      title: 'المسح على الخفين والجوربين في الوضوء',
      summary: 'حكم المسح على الخفين والجوربين وشروطه ومدته للمقيم والمسافر.',
      category: 'فقه الطهارة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_wiping_majority',
          school: FiqhSchool.majority,
          rulingText: 'يجوز المسح على الخفين والجوربين الصفيقين يوماً وليلة للمقيم وثلاثة أيام بلياليها للمسافر بشرط لبسهما على طهارة كاملة.',
          scholarName: 'جمهور أهل العلم (الحنفية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني لابن قدامة ج 1 ص 212',
          evidences: [evH6],
        ),
        FiqhPosition.create(
          positionId: 'pos_wiping_maliki',
          school: FiqhSchool.maliki,
          rulingText: 'يجوز المسح على الخفين دون توقيت بمدة معينة للمقيم والمسافر ما لم ينزعهما أو تصبه جنابة، ويكره المسح على الجورب إلا إذا جُلّد.',
          scholarName: 'المالكية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 1 ص 498',
        ),
      ],
    ));

    // 2. نواقض الوضوء بلمس المرأة
    list.add(FiqhTopic.create(
      topicId: 'topic_nawaqid_wudu',
      title: 'نقض الوضوء بملامسة بشرة المرأة الأجنبية',
      summary: 'حكم ملامسة بشرة المرأة بغير حائل وتأثيرها على صحة الطهارة.',
      category: 'فقه الطهارة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_touch_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'ينتقض الوضوء بمجرد مس بشرة المرأة الأجنبية بدون حائل، سواء كان بشهوة أو بغير شهوة عملاً بظاهر قوله تعالى ﴿أَوْ لَامَسْتُمُ النِّسَاءَ﴾.',
          scholarName: 'الشافعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع شرح المهذب ج 2 ص 31',
        ),
        FiqhPosition.create(
          positionId: 'pos_touch_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'لا ينتقض الوضوء بمجرد اللمس مطلقاً ولو بشهوة، والمراد بالملامسة في الآية الجماع.',
          scholarName: 'الحنفية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 156',
        ),
        FiqhPosition.create(
          positionId: 'pos_touch_maliki_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'ينتقض الوضوء إذا كان اللمس بشهوة أو قُصدت به اللذة، ولا ينتقض إذا كان بغير شهوة.',
          scholarName: 'المالكية والحنابلة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 158',
        ),
      ],
    ));

    // 3. حكم المذي والمني وطهارتهما
    list.add(FiqhTopic.create(
      topicId: 'topic_madhy_many',
      title: 'طهارة المني ونجاسة المذي وموجب الغسل',
      summary: 'الفرق بين المني والمذي من حيث الطهارة والنجاسة وموجبات الغسل والوضوء.',
      category: 'فقه الطهارة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_many_shafii_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'المني طاهر لحديث عائشة أنها كانت تفركه من ثوب النبي ﷺ، وخروجه بشهوة يوجب الغسل، أما المذي فنجس إجماعاً ويوجب الوضوء وغسل الذكر.',
          scholarName: 'الشافعية والحنابلة',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 2 ص 553',
        ),
        FiqhPosition.create(
          positionId: 'pos_many_hanafi_maliki',
          school: FiqhSchool.hanafi,
          rulingText: 'المني نجس نجاسة مخففة يطهر بالفرك إن كان يابساً وبالغسل إن كان رطباً، والمذي نجس يوجب غسل ما أصاب والوضوء.',
          scholarName: 'الحنفية والمالكية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 422',
        ),
      ],
    ));

    // 4. التيمم عند فقد الماء أو المرض
    list.add(FiqhTopic.create(
      topicId: 'topic_tayammum_rules',
      title: 'صفة التيمم وما يتيمم به من صعيد الأرض',
      summary: 'هل يختص التيمم بالتراب ذي الغبار أم يجزئ كل ما صعد على وجه الأرض.',
      category: 'فقه الطهارة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_tayammum_shafii_hanbali',
          school: FiqhSchool.shafii,
          rulingText: 'يشترط أن يكون التيمم بتراب طهور له غبار يعلق باليدين لقوله تعالى ﴿فَتَيَمَّمُوا صَعِيدًا طَيِّبًا فَامْسَحُوا بِوُجُوهِكُمْ وَأَيْدِيكُم مِّنْهُ﴾.',
          scholarName: 'الشافعية والحنابلة',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 2 ص 214',
        ),
        FiqhPosition.create(
          positionId: 'pos_tayammum_hanafi_maliki',
          school: FiqhSchool.maliki,
          rulingText: 'يجوز التيمم بكل ما كان من أجزاء الأرض المتصلة بها كالرمل والحصى والحجارة والتراب.',
          scholarName: 'الحنفية والمالكية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 251',
        ),
      ],
    ));

    // =========================================================================
    // 2. فقه الصلاة والجنائز (المسائل 5 إلى 12)
    // =========================================================================

    // 5. قراءة الفاتحة للمأموم في الصلاة الجهرية
    list.add(FiqhTopic.create(
      topicId: 'topic_fatiha_behind_imam',
      title: 'قراءة الفاتحة للمأموم في الصلاة الجهرية',
      summary: 'حكم قراءة المأموم للفاتحة خلف الإمام في الركعات الجهرية.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_fatiha_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'تجب قراءة الفاتحة على المأموم في كل ركعة سواء كانت الصلاة سرية أو جهرية لعموم حديث: «لا صلاة لمن لم يقرأ بفاتحة الكتاب».',
          scholarName: 'الشافعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 3 ص 365',
          evidences: [evH35],
        ),
        FiqhPosition.create(
          positionId: 'pos_fatiha_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'لا تجوز قراءة الفاتحة للمأموم خلف الإمام مطلقاً بل تكره تحريماً، وقراءة الإمام له قراءة.',
          scholarName: 'الحنفية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 118',
        ),
        FiqhPosition.create(
          positionId: 'pos_fatiha_maliki_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'تستحب القراءة في السرية وسكتات الإمام، وينصت في الجهرية لقوله تعالى ﴿وَإِذَا قُرِئَ الْقُرْآنُ فَاسْتَمِعُوا لَهُ وَأَنصِتُوا﴾.',
          scholarName: 'المالكية والحنابلة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 120',
        ),
      ],
    ));

    // 6. رفع اليدين عند الركوع والرفع منه
    list.add(FiqhTopic.create(
      topicId: 'topic_raf_yadayn',
      title: 'رفع اليدين عند الركوع والرفع منه في الصلاة',
      summary: 'مشروعية رفع اليدين عند تكبيرة الركوع والرفع منه ومواضع الرفع.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_raf_shafii_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'سنة مؤكدة يرفع يديه عند تكبيرة الإحرام، وعند الهوي للركوع، وعند الرفع منه، وعند القيام من التشهد الأول لثبوت ذلك عن ابن عمر عن النبي ﷺ.',
          scholarName: 'الشافعية والحنابلة ورواية عن مالك',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 3 ص 399',
          evidences: [evH35],
        ),
        FiqhPosition.create(
          positionId: 'pos_raf_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'لا يرفع يديه إلا عند تكبيرة الإحرام فقط استدلالاً بحديث ابن مسعود.',
          scholarName: 'الحنفية والمعتمد عند المالكية في المدونة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 295',
        ),
      ],
    ));

    // 7. حكم صلاة الجماعة في المسجد
    list.add(FiqhTopic.create(
      topicId: 'topic_salat_jamaah',
      title: 'حكم صلاة الجماعة في المسجد للرجال',
      summary: 'هل صلاة الجماعة فرض عين أم فرض كفاية أم سنة مؤكدة.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_jamaah_hanbali',
          school: FiqhSchool.hanbali,
          rulingText: 'فرض عين على الرجال المكلفين القادرين حضراً وسفراً لحديث الأعمى: «هل تسمع النداء بالصلاة؟ قال: نعم، قال: فأجب».',
          scholarName: 'الحنابلة وبعض أصحاب الشافعي',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 175',
          evidences: [evH33],
        ),
        FiqhPosition.create(
          positionId: 'pos_jamaah_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'فرض كفاية إذا أقيمت في البلد في موضع تظهر به الشعيرة سقط الإثم عن الباقين.',
          scholarName: 'الشافعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 4 ص 182',
        ),
        FiqhPosition.create(
          positionId: 'pos_jamaah_hanafi_maliki',
          school: FiqhSchool.majority,
          rulingText: 'سنة مؤكدة لا ينبغي تركها إلا لعذر.',
          scholarName: 'الحنفية والمالكية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 177',
        ),
      ],
    ));

    // 8. مسافة القصر والجمع في السفر
    list.add(FiqhTopic.create(
      topicId: 'topic_qasr_travel',
      title: 'مسافة القصر والجمع بين الصلاتين في السفر',
      summary: 'المسافة المبيحة لقصر الصلاة الرباعية والجمع بين الظهرين والعشاءين.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_qasr_majority',
          school: FiqhSchool.majority,
          rulingText: 'تقدر مسافة القصر بأربعة بُرد (حوالي 80 - 85 كم)، ويجوز فيها الجمع والقصر.',
          scholarName: 'جمهور العلماء (المالكية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 257',
        ),
        FiqhPosition.create(
          positionId: 'pos_qasr_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'تقدر بمسيرة ثلاثة أيام ولياليها بسير الإبل المعتاد، ولا يجوز الجمع بين صلاتين في وقت واحد إلا بعرفة ومزدلفة.',
          scholarName: 'الحنفية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 260',
        ),
      ],
    ));

    // 9. قنوت صلاة الفجر ومحله
    list.add(FiqhTopic.create(
      topicId: 'topic_qunut_fajr',
      title: 'حكم قنوت الفجر ومحله في الركعة الثانية',
      summary: 'هل يسن القنوت الراتب في صلاة الصبح دائماً أم يختص بالنوازل.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_qunut_shafii_maliki',
          school: FiqhSchool.shafii,
          rulingText: 'القنوت في صلاة الصبح بعد الرفع من الركوع سنة مؤكدة دائماً يجبر تركه بسجود السهو عند الشافعية، ومستحب قبل الركوع عند المالكية.',
          scholarName: 'الشافعية والمالكية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 3 ص 477',
        ),
        FiqhPosition.create(
          positionId: 'pos_qunut_hanafi_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'لا يسن القنوت في صلاة الصبح بصفة دائمة بل يختص بنوازل المسلمين، أما في غير النوازل فغير مشروع.',
          scholarName: 'الحنفية والحنابلة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 578',
        ),
      ],
    ));

    // 10. جلسة الاستراحة في الصلاة
    list.add(FiqhTopic.create(
      topicId: 'topic_jilsat_istiraha',
      title: 'جلسة الاستراحة بعد السجدة الثانية قبل القيام',
      summary: 'حكم الجلوس الخفيف بعد الركعة الأولى والثالثة قبل النهوض.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_istiraha_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'سنة مستحبة في كل ركعة يقوم منها إلى ركعة بعدها لحديث مالك بن الحويرث في البخاري.',
          scholarName: 'الشافعية ورواية عن أحمد',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 3 ص 441',
        ),
        FiqhPosition.create(
          positionId: 'pos_istiraha_majority',
          school: FiqhSchool.majority,
          rulingText: 'لا تشرع إلا لمن احتاج إليها لكبر سن أو مرض أو ثقل بدن، والأصل النهوض معتمداً على ركبتيه.',
          scholarName: 'الحنفية والمالكية والمعتمد عند الحنابلة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 310',
        ),
      ],
    ));

    // 11. سجود السهو قبلي أم بعدي
    list.add(FiqhTopic.create(
      topicId: 'topic_sujud_sahw',
      title: 'محل سجود السهو: قبل السلام أم بعده',
      summary: 'تفصيل مواضع سجود السهو للزيادة والنقصان والشك.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_sahw_maliki_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'إن كان السهو عن نقص سجد قبل السلام، وإن كان عن زيادة أو شك بنى فيه على غالب الظن سجد بعد السلام جمعاً بين الأحاديث.',
          scholarName: 'المالكية والحنابلة واختيار ابن تيمية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 411',
        ),
        FiqhPosition.create(
          positionId: 'pos_sahw_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'سجود السهو كله قبل السلام في جميع الأحوال لأنه جبر للصلاة فيكون قبل الخروج منها.',
          scholarName: 'الشافعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 4 ص 135',
        ),
        FiqhPosition.create(
          positionId: 'pos_sahw_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'سجود السهو كله بعد السلام يسلم تسليمة واحدة ثم يسجد سجدتين ويتشهد ويسلم.',
          scholarName: 'الحنفية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 415',
        ),
      ],
    ));

    // 12. صلاة الجنازة وعدد تكبيراتها
    list.add(FiqhTopic.create(
      topicId: 'topic_salat_janazah',
      title: 'صلاة الجنازة وقراءة الفاتحة والدعاء فيها',
      summary: 'أركان صلاة الجنازة وموقف الإمام من الميت وقراءة الفاتحة.',
      category: 'فقه الجنائز',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_janazah_shafii_hanbali',
          school: FiqhSchool.majority,
          rulingText: 'أربع تكبيرات، تجب قراءة الفاتحة بعد الأولى، والصلاة على النبي ﷺ بعد الثانية، والدعاء للميت بعد الثالثة، والسلام بعد الرابعة.',
          scholarName: 'الشافعية والحنابلة',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 5 ص 211',
        ),
        FiqhPosition.create(
          positionId: 'pos_janazah_hanafi_maliki',
          school: FiqhSchool.hanafi,
          rulingText: 'لا تجب قراءة الفاتحة في صلاة الجنازة بل يثني على الله بعد الأولى ويدعو، وعند الحنفية تجوز الفاتحة بنية الثناء لا التلاوة.',
          scholarName: 'الحنفية والمالكية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 493',
        ),
      ],
    ));

    // =========================================================================
    // 3. فقه الزكاة والصيام والحج (المسائل 13 إلى 18)
    // =========================================================================

    // 13. إخراج زكاة الفطر نقداً أو طعاماً
    list.add(FiqhTopic.create(
      topicId: 'topic_zakat_fitr_cash',
      title: 'إخراج زكاة الفطر نقداً بقيمتها المالية',
      summary: 'جواز إخراج زكاة الفطر قيمة نقدية تيسيراً على الفقراء.',
      category: 'فقه الزكاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_fitr_majority',
          school: FiqhSchool.majority,
          rulingText: 'الواجب إخراجها طعاماً من غالب قوت البلد كالتمر والبر والأرز، ولا يجزئ إخراج القيمة عملاً بالنص النبوي.',
          scholarName: 'جمهور الفقهاء (المالكية والشافعية والحنابلة)',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 6 ص 112',
        ),
        FiqhPosition.create(
          positionId: 'pos_fitr_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'يجوز إخراج قيمتها نقداً بل هو أفضل وأوفق لحاجة الفقير في العصر الحاضر.',
          scholarName: 'الحنفية والحسن البصري وعمر بن عبد العزيز',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 671',
        ),
      ],
    ));

    // 14. تبييت النية في الصوم
    list.add(FiqhTopic.create(
      topicId: 'topic_niyyah_fasting',
      title: 'اشتراط تبييت النية في صيام الفرض والنافلة',
      summary: 'وقت انعقاد نية الصيام وما يشترط لها من الليل.',
      category: 'فقه الصيام',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_niyyah_majority',
          school: FiqhSchool.majority,
          rulingText: 'يشترط تبييت النية من الليل لكل يوم في صيام الفرض لحديث: «من لم يبيت الصيام قبل الفجر فلا صيام له»، وتجزئ نية النهار في النفل.',
          scholarName: 'جمهور العلماء (الشافعية والحنابلة ورواية عن المالكية)',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 6 ص 294',
          evidences: [evH1],
        ),
        FiqhPosition.create(
          positionId: 'pos_niyyah_maliki_monthly',
          school: FiqhSchool.maliki,
          rulingText: 'تكفي نية واحدة لجميع شهر رمضان في أول ليلة منه ما لم يقطع الصوم بسفر أو مرض فيستأنف النية.',
          scholarName: 'المالكية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 3 ص 26',
        ),
      ],
    ));

    // 15. زكاة الحلي المستعمل المباح
    list.add(FiqhTopic.create(
      topicId: 'topic_zakat_jewelry',
      title: 'وجوب الزكاة في حلي الذهب والفضة المعد للاستعمال المباح',
      summary: 'هل تجب الزكاة في الذهب والفضة المتخذ للزينة المباحة للمرأة.',
      category: 'فقه الزكاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_jewelry_majority',
          school: FiqhSchool.majority,
          rulingText: 'لا زكاة في الحلي المباح المعد للاستعمال واللبس ما دام لم يقصد به الكنز والتجارة لكونه كالثياب والمتاع.',
          scholarName: 'جمهور الفقهاء (المالكية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 604',
        ),
        FiqhPosition.create(
          positionId: 'pos_jewelry_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'تجب الزكاة في مطلق الذهب والفضة إذا بلغا النصاب وحال عليهما الحول سواء كان حلياً مستعملاً أو كنزاً لعموم نصوص الزكاة.',
          scholarName: 'الحنفية وابن حزم',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 6 ص 35',
        ),
      ],
    ));

    // 16. المفطرات المعاصرة
    list.add(FiqhTopic.create(
      topicId: 'topic_contemporary_muftirat',
      title: 'المفطرات الطبية المعاصرة (بخاخ الربو والإبر وقطرة العين)',
      summary: 'أثر الاستعمال الطبي الحديث أثناء نهار رمضان على صحة الصوم.',
      category: 'فقه الصيام',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_muftirat_contemporary_fatwa',
          school: FiqhSchool.majority,
          rulingText: 'بخاخ الربو وقطرة العين والأذن والإبر العضلية والوريدية غير المغذية لا تفطر لعدم وصولها للجوف غذاءً أو شراباً.',
          scholarName: 'مجمع الفقه الإسلامي الدولي وهيئة كبار العلماء',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'قرارات مجمع الفقه الإسلامي قرار رقم 93',
          evidences: [evH42],
        ),
      ],
    ));

    // 17. كفارة الجماع في نهار رمضان على المرأة
    list.add(FiqhTopic.create(
      topicId: 'topic_kaffara_jima_woman',
      title: 'وجوب كفارة الجماع في نهار رمضان على المرأة المطاوعة',
      summary: 'هل تلزم الكفارة الكبرى المغلظة الزوجة إذا طاوعت زوجها في نهار رمضان.',
      category: 'فقه الصيام',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_kaffara_majority',
          school: FiqhSchool.majority,
          rulingText: 'تلزمها الكفارة كفارة مغلظة (عتق رقبة فإن لم تجد فصيام شهرين متتابعين) إذا كانت مطاوعة ذاكرة لصومها.',
          scholarName: 'المالكية والحنفية والحنابلة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 3 ص 62',
        ),
        FiqhPosition.create(
          positionId: 'pos_kaffara_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'الكفارة تجب على الزوج وحده دون الزوجة، لأن النبي ﷺ لم يأمر المرأة في الحديث بكفارة بل أمر الرجل وحده، وعليها القضاء فقط.',
          scholarName: 'الشافعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 6 ص 342',
        ),
      ],
    ));

    // 18. الترتيب بين أعمال يوم النحر
    list.add(FiqhTopic.create(
      topicId: 'topic_tartib_yawm_nahr',
      title: 'حكم مراعاة الترتيب بين أعمال يوم النحر للحاج',
      summary: 'الترتيب بين رمي جمرة العقبة ونحر الهدي والحلق وطواف الإفاضة.',
      category: 'فقه الحج والعمرة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_nahr_majority',
          school: FiqhSchool.majority,
          rulingText: 'السنة الترتيب (الرمي ثم النحر ثم الحلق ثم الطواف)، فإن قدم بعضها على بعض أجزأه ولا فدية عليه لحديث: «افعل ولا حرج».',
          scholarName: 'الشافعية والحنابلة والجمهور',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 3 ص 443',
        ),
        FiqhPosition.create(
          positionId: 'pos_nahr_hanafi_maliki',
          school: FiqhSchool.hanafi,
          rulingText: 'الترتيب واجب بين الرمي والنحر والحلق، فمن قدم الحلق على الرمي لزمه دم عند الحنفية.',
          scholarName: 'الحنفية والمالكية في بعض الأوجه',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 8 ص 205',
        ),
      ],
    ));

    return list;
  }
}
