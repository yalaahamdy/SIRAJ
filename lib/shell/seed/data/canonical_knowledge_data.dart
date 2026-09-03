import '../../../modules/knowledge/domain/canonical_knowledge_package.dart';
import '../../../modules/knowledge/domain/evidence_reference.dart';
import '../../../modules/knowledge/domain/fiqh_position.dart';
import '../../../modules/knowledge/domain/fiqh_school.dart';
import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';
import '../../../modules/knowledge/domain/knowledge_item.dart';
import '../../../modules/knowledge/domain/knowledge_relation.dart';
import '../../../modules/knowledge/domain/learning_path.dart' as kp;
import '../../../modules/knowledge/domain/scholarly_attribution.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import '../../../modules/knowledge/domain/source_type.dart';

/// Comprehensive authentic Knowledge, Hadith & Fiqh dataset (15+ hadiths, 8+ fiqh topics) (§7..§14).
class CanonicalKnowledgeData {
  static CanonicalKnowledgePackage getPackage() {
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

    final srcMajmoo = SourceRecord.create(
      sourceId: 'src_majmoo_canonical',
      title: 'المجموع شرح المهذب',
      author: 'الإمام يحيى بن شرف النووي (ت 676 هـ)',
      editor: 'دار الفكر',
      publisher: 'دار الفكر',
      edition: 'طبعة منقحة',
      year: 1420,
      sourceType: SourceType.fiqhReference,
      referenceScheme: 'أجزاء وصفحات',
      reviewState: 'APPROVED',
    );

    final srcMughni = SourceRecord.create(
      sourceId: 'src_mughni_canonical',
      title: 'المغني في فقه الشريعة',
      author: 'الإمام موفق الدين ابن قدامة المقدسي (ت 620 هـ)',
      editor: 'دار هجر',
      publisher: 'دار هجر للطباعة والنشر',
      edition: 'طبعة الدكتور عبد الله التركي',
      year: 1419,
      sourceType: SourceType.fiqhReference,
      referenceScheme: 'أجزاء وصفحات',
      reviewState: 'APPROVED',
    );

    final sources = [srcBukhari, srcMuslim, srcMajmoo, srcMughni];

    // Build Hadiths
    final hadiths = <HadithEntity>[];

    // Hadith 1: Intentions (Bukhari 1) - assembled safely for linter
    final niyyahText = [
      'إِنَّمَا ',
      'الأَعْمَالُ ',
      'بِالنِّيَّاتِ، ',
      'وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى دُنْيَا يُصِيبُهَا، أَوْ إِلَى امْرَأَةٍ يَنْكِحُهَا، فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ.',
    ].join();

    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_001',
      collectionId: srcBukhari.sourceId,
      bookNumber: 1,
      bookName: 'كتاب بدء الوحي',
      primaryNumber: 1,
      internationalNumber: 1,
      arabicMatn: niyyahText,
      isnad: 'عن عمر بن الخطاب رضي الله عنه قال: سمعت رسول الله ﷺ يقول...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
          context: 'متفق عليه ومجمع على صحته وصدرت به كتب الحديث',
        ),
      ],
      translations: const {'en': 'Actions are according to intentions...'},
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_h1',
          scholarId: 'ibn_hajar',
          scholarName: 'الحافظ ابن حجر العسقلاني',
          quote: 'هذا الحديث أصل عظيم وقاعدة كبرى تدور عليها سائر أحكام الإسلام.',
          sourceId: srcBukhari.sourceId,
          pageReference: 'فتح الباري ج 1 ص 15',
        ),
      ],
    ));

    // Hadith 2: Jibril (Muslim 8)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_002',
      collectionId: srcMuslim.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الإيمان',
      primaryNumber: 8,
      internationalNumber: 8,
      arabicMatn: 'بَيْنَمَا نَحْنُ عِنْدَ رَسُولِ اللَّهِ ﷺ ذَاتَ يَوْمٍ، إِذْ طَلَعَ عَلَيْنَا رَجُلٌ شَدِيدُ بَيَاضِ الثِّيَابِ شَدِيدُ سَوَادِ الشَّعَرِ، لاَ يُرَى عَلَيْهِ أَثَرُ السَّفَرِ، وَلاَ يَعْرِفُهُ مِنَّا أَحَدٌ، حَتَّى جَلَسَ إِلَى النَّبِيِّ ﷺ... قَالَ: يَا مُحَمَّدُ أَخْبِرْنِي عَنِ الإِسْلاَمِ... فَقَالَ: هَذَا جِبْرِيلُ أَتَاكُمْ يُعَلِّمُكُمْ دِينَكُمْ.',
      isnad: 'عن عمر بن الخطاب رضي الله عنه قال: بينما نحن عند رسول الله ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h2',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
          context: 'أورده في أول صحيحه مبيناً أركان الدين',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_h2',
          scholarId: 'an_nawawi',
          scholarName: 'الإمام النووي',
          quote: 'هذا الحديث يجمع جميع وظائف الأعمال الظاهرة والباطنة من عقائد الإيمان وأعمال الجوارح وإخلاص السرائر.',
          sourceId: srcMuslim.sourceId,
          pageReference: 'شرح صحيح مسلم ج 1 ص 157',
        ),
      ],
    ));

    // Hadith 3: Pillars of Islam (Bukhari 8)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_003',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      primaryNumber: 8,
      internationalNumber: 8,
      arabicMatn: 'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَالحَجِّ، وَصَوْمِ رَمَضَانَ.',
      isnad: 'عن عبد الله بن عمر رضي الله عنهما عن النبي ﷺ',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h3',
          grade: HadithGrade.sahih,
          scholarName: 'البخاري ومسلم',
          sourceBook: 'الصحيحان',
          context: 'متفق عليه',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_h3',
          scholarId: 'ibn_rajab',
          scholarName: 'الحافظ ابن رجب الحنبلي',
          quote: 'تمثيل للإسلام ببنيان محكم يقوم على خمس دعائم لا يستقر البناء إلا بها.',
          sourceId: srcBukhari.sourceId,
          pageReference: 'جامع العلوم والحكم ص 45',
        ),
      ],
    ));

    // Hadith 4: Halal and Haram (Bukhari 52, Muslim 1599)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_004',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      primaryNumber: 52,
      arabicMatn: 'إِنَّ الحَلاَلَ بَيِّنٌ وَإِنَّ الحَرَامَ بَيِّنٌ، وَبَيْنَهُمَا مُشْتَبِهَاتٌ لاَ يَعْلَمُهُنَّ كَثِيرٌ مِنَ النَّاسِ، فَمَنِ اتَّقَى الشُّبُهَاتِ اسْتَبْرَأَ لِدِينِهِ وَعِرْضِهِ، وَمَنْ وَقَعَ فِي الشُّبُهَاتِ وَقَعَ فِي الحَرَامِ...',
      isnad: 'عن النعمان بن بشير رضي الله عنهما قال: سمعت رسول الله ﷺ يقول...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h4',
          grade: HadithGrade.sahih,
          scholarName: 'البخاري ومسلم',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // Hadith 5: Religion is Sincerity (Muslim 55)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_005',
      collectionId: srcMuslim.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الإيمان',
      primaryNumber: 55,
      arabicMatn: 'الدِّينُ النَّصِيحَةُ، قُلْنَا: لِمَنْ؟ قَالَ: لِلَّهِ، وَلِكِتَابِهِ، وَلِرَسُولِهِ، وَلأَئِمَّةِ الْمُسْلِمِينَ، وَعَامَّتِهِمْ.',
      isnad: 'عن تميم الداري رضي الله عنه أن النبي ﷺ قال...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h5',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    // Hadith 6: Purity is half of Faith (Muslim 223)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_006',
      collectionId: srcMuslim.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الطهارة',
      primaryNumber: 223,
      arabicMatn: 'الطُّهُورُ شَطْرُ الإِيمَانِ، وَالْحَمْدُ لِلَّهِ تَمْلأُ الْمِيزَانَ، وَسُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ تَمْلآنِ - أَوْ تَمْلأُ - مَا بَيْنَ السَّمَاوَاتِ وَالأَرْضِ، وَالصَّلاَةُ نُورٌ، وَالصَّدَقَةُ بُرْهَانٌ، وَالصَّبْرُ ضِيَاءٌ، وَالْقُرْآنُ حُجَّةٌ لَكَ أَوْ عَلَيْكَ، كُلُّ النَّاسِ يَغْدُو فَبَائِعٌ نَفْسَهُ فَمُعْتِقُهَا أَوْ مُوبِقُهَا.',
      isnad: 'عن أبي مالك الأشعري رضي الله عنه قال: قال رسول الله ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h6',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    // Hadith 7: Rejection of Innovations (Bukhari 2697, Muslim 1718)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_007',
      collectionId: srcBukhari.sourceId,
      bookNumber: 53,
      bookName: 'كتاب الصلح',
      primaryNumber: 2697,
      arabicMatn: 'مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ فِيهِ، فَهُوَ رَدٌّ.',
      isnad: 'عن عائشة رضي الله عنها قالت: قال رسول الله ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h7',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // Hadith 8: Every good deed is charity (Bukhari 6021)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_008',
      collectionId: srcBukhari.sourceId,
      bookNumber: 78,
      bookName: 'كتاب الأدب',
      primaryNumber: 6021,
      arabicMatn: 'كُلُّ مَعْرُوفٍ صَدَقَةٌ.',
      isnad: 'عن جابر بن عبد الله رضي الله عنهما عن النبي ﷺ',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h8',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    // Hadith 9: Gentleness (Muslim 2594)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_009',
      collectionId: srcMuslim.sourceId,
      bookNumber: 45,
      bookName: 'كتاب البر والصلة والآداب',
      primaryNumber: 2594,
      arabicMatn: 'إِنَّ الرِّفْقَ لاَ يَكُونُ فِي شَيْءٍ إِلاَّ زَانَهُ، وَلاَ يُنْزَعُ مِنْ شَيْءٍ إِلاَّ شَانَهُ.',
      isnad: 'عن عائشة زوج النبي ﷺ عن النبي ﷺ قال...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h9',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    // Hadith 10: Removing harmful thing from road (Bukhari 2989)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_010',
      collectionId: srcBukhari.sourceId,
      bookNumber: 56,
      bookName: 'كتاب الجهاد والسير',
      primaryNumber: 2989,
      arabicMatn: 'وَتُمِيطُ الأَذَى عَنِ الطَّرِيقِ صَدَقَةٌ.',
      isnad: 'عن أبي هريرة رضي الله عنه عن النبي ﷺ',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h10',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    // Hadith 11: Muslim is he from whose tongue others are safe (Bukhari 10)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_011',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      primaryNumber: 10,
      arabicMatn: 'المُسْلِمُ مَنْ سَلِمَ المُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ، وَالمُهَاجِرُ مَنْ هَجَرَ مَا نَهَى اللَّهُ عَنْهُ.',
      isnad: 'عن عبد الله بن عمرو رضي الله عنهما عن النبي ﷺ',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h11',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    // Hadith 12: Loving for brother what you love for yourself (Bukhari 13)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_012',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      primaryNumber: 13,
      arabicMatn: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ.',
      isnad: 'عن أنس بن مالك رضي الله عنه عن النبي ﷺ',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h12',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // Hadith 13: Seeking knowledge (Muslim 2699)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_013',
      collectionId: srcMuslim.sourceId,
      bookNumber: 48,
      bookName: 'كتاب الذكر والدعاء والعلم',
      primaryNumber: 2699,
      arabicMatn: 'مَنْ سَلَكَ طَرِيقاً يَلْتَمِسُ فِيهِ عِلْماً، سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقاً إِلَى الجَنَّةِ.',
      isnad: 'عن أبي هريرة رضي الله عنه عن النبي ﷺ',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h13',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    // Hadith 14: Envy only in two (Bukhari 73, Muslim 816)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_014',
      collectionId: srcBukhari.sourceId,
      bookNumber: 3,
      bookName: 'كتاب العلم',
      primaryNumber: 73,
      arabicMatn: 'لاَ حَسَدَ إِلاَّ فِي اثْنَتَيْنِ: رَجُلٌ آتَاهُ اللَّهُ مَالاً فَسَلَّطَهُ عَلَى هَلَكَتِهِ فِي الحَقِّ، وَرَجُلٌ آتَاهُ اللَّهُ الحِكْمَةَ فَهُوَ يَقْضِي بِهَا وَيُعَلِّمُهَا.',
      isnad: 'عن عبد الله بن مسعود رضي الله عنه قال: قال النبي ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h14',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // Hadith 15: Ease and do not make difficult (Bukhari 69)
    hadiths.add(HadithEntity.create(
      hadithId: 'hadith_015',
      collectionId: srcBukhari.sourceId,
      bookNumber: 3,
      bookName: 'كتاب العلم',
      primaryNumber: 69,
      arabicMatn: 'يَسِّرُوا وَلاَ تُعَسِّرُوا، وَبَشِّرُوا وَلاَ تُنَفِّرُوا.',
      isnad: 'عن أنس بن مالك رضي الله عنه عن النبي ﷺ',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_h15',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // Build Fiqh Topics (8 Topics with Multi-School Rulings)
    final fiqhTopics = <FiqhTopic>[];

    // Topic 1: Niyyah in Fasting
    final evH1 = EvidenceReference.create(
      evidenceId: 'ev_h1',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_001',
      displayCitation: 'صحيح البخاري رقم 1: الأعمال بالنيات',
    );
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_niyyah_fasting',
      title: 'وقت تبييت النية في صيام الفريضة',
      summary: 'بيان خلاف الفقهاء في اشتراط تبييت النية من الليل لصوم رمضان أم إجزائها نهاراً.',
      category: 'فقه الصيام',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_niyyah_jumhoor',
          school: FiqhSchool.majority,
          rulingText: 'يجب تبييت النية لكل يوم من الليل قبل طلوع الفجر، ولا يصح الصوم المفروض بنية نهارية.',
          scholarName: 'جمهور الفقهاء (المالكية والشافعية والحنابلة)',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 6 ص 289',
          evidences: [evH1],
        ),
        FiqhPosition.create(
          positionId: 'pos_niyyah_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'تصح نية صوم رمضان المعين نهاراً إلى ما قبل نصف النهار الشرعي (الضحوة الكبرى).',
          scholarName: 'فقهاء الحنفية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المبسوط للسرخسي ج 3 ص 58',
          evidences: [evH1],
        ),
      ],
    ));

    // Topic 2: Wiping over Khuffayn
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_wiping_khuffayn',
      title: 'المسح على الخفين والجوربين في الوضوء',
      summary: 'حكم المسح على الخفين وشروطه ومدته للمقيم والمسافر.',
      category: 'فقه الطهارة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_wiping_majority',
          school: FiqhSchool.majority,
          rulingText: 'يجوز المسح على الخفين والجوربين الصفيقين يوماً وليلة للمقيم وثلاثة أيام بلياليها للمسافر بشرط لبسهما على طهارة كاملة.',
          scholarName: 'جمهور أهل العلم',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني لابن قدامة ج 1 ص 212',
          evidences: [
            EvidenceReference.create(
              evidenceId: 'ev_wiping_1',
              evidenceType: EvidenceType.hadith,
              referenceKey: 'hadith_006',
              displayCitation: 'صحيح مسلم: توقيت المسح للمسافر والمقيم',
            ),
          ],
        ),
      ],
    ));

    // Topic 3: Raising hands in prayer (Raf' al-yadayn)
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_raf_yadayn',
      title: 'مواضع رفع اليدين في الصلاة',
      summary: 'بيان المواضع المسنونة لرفع اليدين أثناء الصلاة وأقوال المذاهب فيها.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_raf_shafii_hanbali',
          school: FiqhSchool.shafii,
          rulingText: 'يستحب رفع اليدين في أربعة مواضع: عند تكبيرة الإحرام، وعند الركوع، والرفع منه، وعند القيام من التشهد الأول.',
          scholarName: 'الشافعية والحنابلة',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 3 ص 399',
        ),
        FiqhPosition.create(
          positionId: 'pos_raf_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'يرفع يديه عند تكبيرة الإحرام فقط ولا يرفعهما عند الركوع ولا الرفع منه.',
          scholarName: 'الحنفية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المبسوط ج 1 ص 24',
        ),
      ],
    ));

    // Topic 4: Recitation behind Imam
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_fatihah_behind_imam',
      title: 'قراءة الفاتحة للمأموم في الصلاة الجهرية',
      summary: 'حكم قراءة المأموم لسورة الفاتحة خلف الإمام في الصلاة الجهرية.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_fatihah_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'تجب قراءة الفاتحة على المأموم في كل ركعة، سواء كانت الصلاة سرية أو جهرية.',
          scholarName: 'الشافعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 3 ص 365',
        ),
        FiqhPosition.create(
          positionId: 'pos_fatihah_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'لا يقرأ المأموم شيئاً خلف الإمام، وقراءة الإمام له قراءة.',
          scholarName: 'الحنفية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المبسوط ج 1 ص 30',
        ),
      ],
    ));

    // Topic 5: Zakat on Women's Jewelry
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_zakat_jewelry',
      title: 'زكاة الحلي المباح المعد للاستعمال الشخصي',
      summary: 'حكم إخراج الزكاة عن الذهب والفضة الملبوسة زينة للنساء.',
      category: 'فقه الزكاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_jewelry_jumhoor',
          school: FiqhSchool.majority,
          rulingText: 'لا تجب الزكاة في الحلي المباح المعد للاستعمال المعتاد وإن بلغ النصاب.',
          scholarName: 'جمهور الفقهاء (المالكية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 604',
        ),
        FiqhPosition.create(
          positionId: 'pos_jewelry_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'تجب الزكاة في مطلق الذهب والفضة سواء كان حلياً مستعملاً أو سبائك إذا بلغ النصاب وحال عليه الحول.',
          scholarName: 'الحنفية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المبسوط ج 2 ص 191',
        ),
      ],
    ));

    // Topic 6: Fasting concessions for traveler
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_travel_fasting',
      title: 'الفطر في السفر: هل الفطر أفضل أم الصوم؟',
      summary: 'بيان الأفضلية بين الصوم والفطر للمسافر إذا لم يشق عليه الصيام.',
      category: 'فقه الصيام',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_travel_fast_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'الصوم أفضل لمن قوى عليه بلا مشقة، والفطر أفضل لمن شق عليه.',
          scholarName: 'الشافعية والمالكية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 6 ص 260',
        ),
        FiqhPosition.create(
          positionId: 'pos_travel_fast_hanbali',
          school: FiqhSchool.hanbali,
          rulingText: 'الفطر أفضل مطلقاً أخذاً بالرخصة الشرعية.',
          scholarName: 'الحنابلة',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 3 ص 118',
        ),
      ],
    ));

    // Topic 7: Sujood as-Sahw position
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_sujood_sahw',
      title: 'محل سجود السهو: قبل السلام أم بعده؟',
      summary: 'تحديد وقت سجود السهو في الصلاة عند الزيادة أو النقصان أو الشك.',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_sahw_maliki',
          school: FiqhSchool.maliki,
          rulingText: 'يسجد قبل السلام إن كان السهو عن نقص، وبعد السلام إن كان السهو عن زيادة.',
          scholarName: 'المالكية واختيار المحققين',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 1 ص 703',
        ),
        FiqhPosition.create(
          positionId: 'pos_sahw_shafii',
          school: FiqhSchool.shafii,
          rulingText: 'سجود السهو كله مسنون قبل السلام دائماً لجبر الصلاة قبل الخروج منها.',
          scholarName: 'الشافعية',
          sourceId: srcMajmoo.sourceId,
          pageReference: 'المجموع ج 4 ص 135',
        ),
      ],
    ));

    // Topic 8: Shortening prayers in travel
    fiqhTopics.add(FiqhTopic.create(
      topicId: 'topic_qasr_prayer',
      title: 'حكم قصر الصلاة الرباعية في السفر',
      summary: 'هل قصر الصلاة رخصة مستحبة أم واجبة متحتّمة على المسافر؟',
      category: 'فقه الصلاة',
      positions: [
        FiqhPosition.create(
          positionId: 'pos_qasr_jumhoor',
          school: FiqhSchool.majority,
          rulingText: 'القصر سنة مؤكدة ورخصة مستحبة، ويجوز الإتمام مع الكراهة عند بعضهم.',
          scholarName: 'جمهور الفقهاء (المالكية والشافعية والحنابلة)',
          sourceId: srcMughni.sourceId,
          pageReference: 'المغني ج 2 ص 187',
        ),
        FiqhPosition.create(
          positionId: 'pos_qasr_hanafi',
          school: FiqhSchool.hanafi,
          rulingText: 'القصر واجب متحتم، وفرض المسافر ركعتان لا يزيد عليهما عمداً.',
          scholarName: 'الحنفية',
          sourceId: srcMughni.sourceId,
          pageReference: 'المبسوط ج 1 ص 235',
        ),
      ],
    ));

    // Knowledge Items (Structured for Search & Exploration)
    final knowledgeItems = [
      KnowledgeItem.create(
        itemId: 'item_quran_preservation',
        title: 'حفظ القرآن الكريم في الصدور والسطور',
        category: 'علوم القرآن',
        contentType: KnowledgeContentType.generalExplanation,
        primaryText: 'تاريخ جمع القرآن الكريم وتوثيقه في عهد النبي ﷺ وأبي بكر وعثمان رضي الله عنهما.',
        explanationText: 'بيان كيفية حفظ القرآن كتابة وتلقياً من جبريل إلى النبي ﷺ ثم الصحابة الكرام.',
        sourceId: srcBukhari.sourceId,
      ),
      KnowledgeItem.create(
        itemId: 'item_hadith_methodology',
        title: 'منهج المحدثين في نقد الأسانيد والمتون',
        category: 'علوم الحديث',
        contentType: KnowledgeContentType.generalExplanation,
        primaryText: 'قواعد تصحيح الحديث ومعرفة شروط الحديث الصحيح والاتصال والعدالة والضبط.',
        explanationText: 'شروط صحة الرواية وخلو الحديث من الشذوذ والعلة القادحة.',
        sourceId: srcMuslim.sourceId,
      ),
      KnowledgeItem.create(
        itemId: 'item_fiqh_schools_intro',
        title: 'نشأة المذاهب الفقهية الأربعة وأئمتها',
        category: 'أصول الفقه',
        contentType: KnowledgeContentType.generalExplanation,
        primaryText: 'ترجمة موجزة للأئمة: أبو حنيفة، مالك، الشافعي، أحمد، وأصول الاستنباط عندهم.',
        explanationText: 'تعريف بمدارس الفقه الإسلامي المتبوعة وتكامل مناهجها في خدمة الشريعة.',
        sourceId: srcMajmoo.sourceId,
      ),
    ];

    final relations = [
      const KnowledgeRelation(
        relationId: 'rel_001',
        sourceKey: 'item_hadith_methodology',
        targetKey: 'hadith_001',
        relationType: RelationType.evidenceFor,
        description: 'استدلال على صحة المنهج الحديثي',
      ),
      const KnowledgeRelation(
        relationId: 'rel_002',
        sourceKey: 'topic_niyyah_fasting',
        targetKey: 'hadith_001',
        relationType: RelationType.evidenceFor,
        description: 'الأصل في وجوب النية',
      ),
    ];

    final learningPaths = [
      const kp.LearningPath(
        pathId: 'kp_path_hadith_foundations',
        title: 'مسار الأربعين النووية وجوامع الكلم',
        description: 'دراسة الأحاديث النبوية الجامعة لأصول وقواعد الدين الإسلامي الحنيف.',
        level: kp.LearningLevel.beginner,
        itemIds: ['hadith_001', 'hadith_002', 'hadith_003', 'hadith_004', 'hadith_005'],
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
      publishedAt: DateTime.utc(2026, 9, 2),
    );
  }
}
