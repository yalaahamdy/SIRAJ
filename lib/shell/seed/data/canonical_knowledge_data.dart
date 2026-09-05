import '../../../modules/knowledge/domain/canonical_knowledge_package.dart';
import '../../../modules/knowledge/domain/knowledge_item.dart';
import '../../../modules/knowledge/domain/knowledge_relation.dart';
import '../../../modules/knowledge/domain/learning_path.dart' as kp;
import '../../../modules/knowledge/domain/source_record.dart';
import '../../../modules/knowledge/domain/source_type.dart';
import 'canonical_fiqh_records.dart';
import 'canonical_hadith_records.dart';

/// Comprehensive authentic Knowledge, Hadith & Fiqh dataset (45 hadiths, 16 fiqh topics, 10 canonical sources) (§7..§16).
class CanonicalKnowledgeData {
  static CanonicalKnowledgePackage getPackage() {
    // -------------------------------------------------------------------------
    // 1. Classical Sunnah & Jurisprudence Sources (10 Canonical Sources)
    // -------------------------------------------------------------------------
    final srcBukhari = SourceRecord.create(
      sourceId: 'src_bukhari_canonical',
      title: 'صحيح البخاري (الجامع المسند الصحيح المختصر)',
      author: 'الإمام محمد بن إسماعيل البخاري (ت 256 هـ)',
      editor: 'تحقيق نخبة من العلماء المعتمدين',
      publisher: 'دار التأصيل والتوثيق',
      edition: 'طبعة التأصيل المعتمدة 1445 هـ',
      year: 1445,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'الترقيم العالمي للحديث',
      reviewState: 'APPROVED',
    );

    final srcMuslim = SourceRecord.create(
      sourceId: 'src_muslim_canonical',
      title: 'صحيح مسلم (المسند الصحيح المختصر بنقل العدل عن العدل)',
      author: 'الإمام مسلم بن الحجاج النيسابوري (ت 261 هـ)',
      editor: 'مركز البحوث الإسلامية',
      publisher: 'دار التأصيل',
      edition: 'طبعة التأصيل المعتمدة',
      year: 1445,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'ترقيم فؤاد عبد الباقي',
      reviewState: 'APPROVED',
    );

    final srcAbuDawud = SourceRecord.create(
      sourceId: 'src_abudawud_canonical',
      title: 'سنن أبي داود',
      author: 'الإمام سليمان بن الأشعث السجستاني (ت 275 هـ)',
      editor: 'تحقيق محمد محيي الدين عبد الحميد',
      publisher: 'دار الرسالة العالمية',
      edition: 'الطبعة المحققة المعتمدة',
      year: 1430,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'ترقيم العالمية المعياري',
      reviewState: 'APPROVED',
    );

    final srcTirmidhi = SourceRecord.create(
      sourceId: 'src_tirmidhi_canonical',
      title: 'جامع الترمذي (السنن)',
      author: 'الإمام محمد بن عيسى الترمذي (ت 279 هـ)',
      editor: 'تحقيق أحمد شاكر ومحمد فؤاد عبد الباقي',
      publisher: 'دار إحياء التراث العربي',
      edition: 'طبعة منقحة ومراجعة',
      year: 1425,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'ترقيم فؤاد عبد الباقي',
      reviewState: 'APPROVED',
    );

    final srcNasai = SourceRecord.create(
      sourceId: 'src_nasai_canonical',
      title: 'سنن النسائي (المجتبى من السنن)',
      author: 'الإمام أحمد بن شعيب النسائي (ت 303 هـ)',
      editor: 'تحقيق عبد الفتاح أبو غدة',
      publisher: 'مكتب المطبوعات الإسلامية',
      edition: 'الطبعة المعتمدة',
      year: 1406,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'ترقيم أبي غدة',
      reviewState: 'APPROVED',
    );

    final srcIbnMajah = SourceRecord.create(
      sourceId: 'src_ibnmajah_canonical',
      title: 'سنن ابن ماجه',
      author: 'الإمام محمد بن يزيد القزويني (ت 273 هـ)',
      editor: 'تحقيق محمد فؤاد عبد الباقي',
      publisher: 'دار إحياء الكتب العربية',
      edition: 'طبعة مصححة ومعتمدة',
      year: 1395,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'ترقيم فؤاد عبد الباقي',
      reviewState: 'APPROVED',
    );

    final srcMuwatta = SourceRecord.create(
      sourceId: 'src_muwatta_canonical',
      title: 'موطأ الإمام مالك',
      author: 'الإمام مالك بن أنس الأصبحي (ت 179 هـ)',
      editor: 'رواية يحيى بن يحيى الليثي الأندلسي',
      publisher: 'دار الغرب الإسلامي',
      edition: 'تحقيق الدكتور بشار عواد معروف',
      year: 1417,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'ترقيم بشار معروف',
      reviewState: 'APPROVED',
    );

    final srcMusnad = SourceRecord.create(
      sourceId: 'src_musnad_canonical',
      title: 'مسند الإمام أحمد بن حنبل',
      author: 'الإمام أحمد بن محمد بن حنبل الشيباني (ت 241 هـ)',
      editor: 'تحقيق شعيب الأرنؤوط ونخبة من العلماء',
      publisher: 'مؤسسة الرسالة',
      edition: 'الطبعة الشاملة المحققة',
      year: 1421,
      sourceType: SourceType.hadithCollection,
      referenceScheme: 'ترقيم مؤسسة الرسالة',
      reviewState: 'APPROVED',
    );

    final srcMajmoo = SourceRecord.create(
      sourceId: 'src_majmoo_canonical',
      title: 'المجموع شرح المهذب',
      author: 'الإمام يحيى بن شرف النووي (ت 676 هـ)',
      editor: 'دار الفكر',
      publisher: 'دار الفكر للطباعة والنشر',
      edition: 'طبعة محققة ومنقحة',
      year: 1420,
      sourceType: SourceType.fiqhReference,
      referenceScheme: 'أجزاء وصفحات',
      reviewState: 'APPROVED',
    );

    final srcMughni = SourceRecord.create(
      sourceId: 'src_mughni_canonical',
      title: 'المغني في فقه الشريعة',
      author: 'الإمام موفق الدين ابن قدامة المقدسي (ت 620 هـ)',
      editor: 'تحقيق الدكتور عبد الله بن عبد المحسن التركي',
      publisher: 'دار هجر للطباعة والنشر',
      edition: 'الطبعة المعتمدة المحققة',
      year: 1419,
      sourceType: SourceType.fiqhReference,
      referenceScheme: 'أجزاء وصفحات',
      reviewState: 'APPROVED',
    );

    final sources = [
      srcBukhari,
      srcMuslim,
      srcAbuDawud,
      srcTirmidhi,
      srcNasai,
      srcIbnMajah,
      srcMuwatta,
      srcMusnad,
      srcMajmoo,
      srcMughni,
    ];

    // -------------------------------------------------------------------------
    // 2. Build 45 Verified Hadiths across 8 Sunnah Collections
    // -------------------------------------------------------------------------
    final hadiths = CanonicalHadithRecords.buildHadiths(
      srcBukhari: srcBukhari,
      srcMuslim: srcMuslim,
      srcAbuDawud: srcAbuDawud,
      srcTirmidhi: srcTirmidhi,
      srcNasai: srcNasai,
      srcIbnMajah: srcIbnMajah,
      srcMuwatta: srcMuwatta,
      srcMusnad: srcMusnad,
    );

    // -------------------------------------------------------------------------
    // 3. Build 16 Verified Fiqh Topics across the Four Madhhabs
    // -------------------------------------------------------------------------
    final fiqhTopics = CanonicalFiqhRecords.buildFiqhTopics(
      srcMajmoo: srcMajmoo,
      srcMughni: srcMughni,
    );

    // -------------------------------------------------------------------------
    // 4. Knowledge Overview Items
    // -------------------------------------------------------------------------
    final knowledgeItems = [
      KnowledgeItem.create(
        itemId: 'item_quran_preservation',
        title: 'حفظ القرآن الكريم في الصدور والسطور',
        category: 'علوم القرآن',
        contentType: KnowledgeContentType.generalExplanation,
        primaryText: 'تاريخ جمع القرآن الكريم وتوثيقه في عهد النبي ﷺ وأبي بكر وعثمان رضي الله عنهما.',
        explanationText: 'بيان كيفية حفظ القرآن كتابة وتلقياً بالتواتر القطعي الذي لا يقبل شكاً.',
        sourceId: srcBukhari.sourceId,
      ),
      KnowledgeItem.create(
        itemId: 'item_hadith_methodology',
        title: 'منهج المحدثين في نقد الأسانيد والمتون',
        category: 'علوم الحديث',
        contentType: KnowledgeContentType.generalExplanation,
        primaryText: 'قواعد تصحيح الحديث ومعرفة شروط الحديث الصحيح والاتصال والعدالة والضبط وعدم الشذوذ والعلة.',
        explanationText: 'المعايير الصارمة لعلماء الحديث في نقد الرواة وتدوين السنة المشرفة.',
        sourceId: srcMuslim.sourceId,
      ),
      KnowledgeItem.create(
        itemId: 'item_fiqh_schools_intro',
        title: 'نشأة المذاهب الفقهية الأربعة وأئمتها',
        category: 'أصول الفقه',
        contentType: KnowledgeContentType.generalExplanation,
        primaryText: 'ترجمة موجزة للأئمة: أبو حنيفة، مالك، الشافعي، أحمد، وأصول الاستنباط عندهم.',
        explanationText: 'تكامل مدارس الفقه الإسلامي المتبوعة في خدمة نصوص الشريعة واستنباط الأحكام.',
        sourceId: srcMajmoo.sourceId,
      ),
    ];

    // -------------------------------------------------------------------------
    // 5. Knowledge Graph Relations (Connecting Hadiths to Fiqh Topics and Items)
    // -------------------------------------------------------------------------
    final relations = [
      const KnowledgeRelation(
        relationId: 'rel_001',
        sourceKey: 'item_hadith_methodology',
        targetKey: 'hadith_001',
        relationType: RelationType.evidenceFor,
        description: 'استدلال على صحة المنهج الحديثي وضبط النية',
      ),
      const KnowledgeRelation(
        relationId: 'rel_002',
        sourceKey: 'topic_niyyah_fasting',
        targetKey: 'hadith_001',
        relationType: RelationType.evidenceFor,
        description: 'الأصل في وجوب النية في العبادات',
      ),
      const KnowledgeRelation(
        relationId: 'rel_003',
        sourceKey: 'topic_wiping_khuffayn',
        targetKey: 'hadith_nawawi_23',
        relationType: RelationType.evidenceFor,
        description: 'الأصل في فضل الطهارة والوضوء',
      ),
      const KnowledgeRelation(
        relationId: 'rel_004',
        sourceKey: 'topic_raf_yadayn',
        targetKey: 'hadith_bukhari_631',
        relationType: RelationType.evidenceFor,
        description: 'الأمر بالصلاة على هدي النبي ﷺ',
      ),
      const KnowledgeRelation(
        relationId: 'rel_005',
        sourceKey: 'topic_salat_jamaah',
        targetKey: 'hadith_abudawud_603',
        relationType: RelationType.evidenceFor,
        description: 'وجوب الاقتداء بالإمام ومتابعته في الجماعة',
      ),
      const KnowledgeRelation(
        relationId: 'rel_006',
        sourceKey: 'topic_khiyar_majlis',
        targetKey: 'hadith_bukhari_2079',
        relationType: RelationType.evidenceFor,
        description: 'ثبوت خيار المجلس والتفرق بالأبدان',
      ),
      const KnowledgeRelation(
        relationId: 'rel_007',
        sourceKey: 'topic_salam_manners',
        targetKey: 'hadith_bukhari_010',
        relationType: RelationType.evidenceFor,
        description: 'الأمر بإفشاء السلام وأثره في المحبة والإيمان',
      ),
      const KnowledgeRelation(
        relationId: 'rel_008',
        sourceKey: 'topic_contemporary_muftirat',
        targetKey: 'hadith_nawawi_32',
        relationType: RelationType.evidenceFor,
        description: 'قاعدة نفي الضرر والمشقة في التداوي للصائم',
      ),
      const KnowledgeRelation(
        relationId: 'rel_009',
        sourceKey: 'topic_organ_transplant',
        targetKey: 'hadith_nawawi_32',
        relationType: RelationType.evidenceFor,
        description: 'قاعدة لا ضرر ولا ضرار في التبرع بالأعضاء',
      ),
      const KnowledgeRelation(
        relationId: 'rel_010',
        sourceKey: 'topic_ihtikar_pricing',
        targetKey: 'hadith_nawawi_32',
        relationType: RelationType.evidenceFor,
        description: 'منع الضرر العام باحتكار الأقوات والسلع',
      ),
      const KnowledgeRelation(
        relationId: 'rel_011',
        sourceKey: 'topic_fatiha_behind_imam',
        targetKey: 'hadith_bukhari_631',
        relationType: RelationType.evidenceFor,
        description: 'أداء الصلاة على الهدي النبوي المحفوظ',
      ),
      const KnowledgeRelation(
        relationId: 'rel_012',
        sourceKey: 'topic_zakat_fitr_cash',
        targetKey: 'hadith_bukhari_008',
        relationType: RelationType.evidenceFor,
        description: 'ركنية الزكاة في مباني الإسلام',
      ),
    ];

    // -------------------------------------------------------------------------
    // 6. Structured Learning Paths
    // -------------------------------------------------------------------------
    final learningPaths = [
      const kp.LearningPath(
        pathId: 'kp_path_hadith_foundations',
        title: 'مسار الأربعين النووية وجوامع الكلم',
        description: 'دراسة الأحاديث النبوية الجامعة لأصول وقواعد الدين الإسلامي الحنيف.',
        level: kp.LearningLevel.beginner,
        itemIds: ['hadith_001', 'hadith_002', 'hadith_003', 'hadith_004', 'hadith_005'],
      ),
      const kp.LearningPath(
        pathId: 'kp_path_character_manners',
        title: 'مسار مكارم الأخلاق والآداب النبوية',
        description: 'أحاديث الرفق وحسن الجوار وحفظ اللسان والصدق وإفشاء السلام.',
        level: kp.LearningLevel.beginner,
        itemIds: ['hadith_008', 'hadith_009', 'hadith_017', 'hadith_018', 'hadith_024', 'hadith_028'],
      ),
    ];

    return CanonicalKnowledgePackage.create(
      packageId: 'pkg_knowledge_canonical_seed_v2',
      sources: sources,
      hadiths: hadiths,
      fiqhTopics: fiqhTopics,
      knowledgeItems: knowledgeItems,
      relations: relations,
      learningPaths: learningPaths,
      signerIdentity: 'siraj.knowledge.board',
      signature: 'sig_canonical_valid_s21_verified',
      publishedAt: DateTime.utc(2026, 9, 3),
    );
  }
}
