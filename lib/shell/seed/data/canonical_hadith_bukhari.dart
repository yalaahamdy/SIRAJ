import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';
import '../../../modules/knowledge/domain/scholarly_attribution.dart';
import '../../../modules/knowledge/domain/source_record.dart';

/// Authentic Canonical Hadiths from Sahih Al-Bukhari across core classical books (§7..§12, M05.1).
class CanonicalHadithBukhari {
  static List<HadithEntity> buildHadiths(SourceRecord srcBukhari) {
    final list = <HadithEntity>[];

    // =========================================================================
    // 1. كتاب بدء الوحي (Book 1)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_001',
      collectionId: srcBukhari.sourceId,
      bookNumber: 1,
      bookName: 'كتاب بدء الوحي',
      chapterNumber: 1,
      chapterName: 'باب كيف كان بدء الوحي إلى رسول الله ﷺ',
      primaryNumber: 1,
      internationalNumber: 1,
      arabicMatn: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى دُنْيَا يُصِيبُهَا، أَوْ إِلَى امْرَأَةٍ يَنْكِحُهَا، فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ.',
      isnad: 'عَنْ عَلْقَمَةَ بْنِ وَقَّاصٍ اللَّيْثِيِّ، قَالَ: سَمِعْتُ عُمَرَ بْنَ الخَطَّابِ رَضِيَ اللَّهُ عَنْهُ عَلَى المِنْبَرِ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b001_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
          context: 'متفق عليه، صدر به البخاري صحيحه مبيناً أنه ميزان الأعمال الباطنة',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_b001_1',
          scholarId: 'ibn_hajar',
          scholarName: 'الحافظ ابن حجر العسقلاني',
          quote: 'هذا الحديث أصل عظيم من أصول الإسلام وقاعدة كبرى تدور عليها سائر الأحكام.',
          sourceId: srcBukhari.sourceId,
          pageReference: 'فتح الباري ج 1 ص 15',
        ),
      ],
    ));

    // =========================================================================
    // 2. كتاب الإيمان (Book 2)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_008',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      chapterNumber: 2,
      chapterName: 'باب دعاؤكم إيمانكم وقول النبي ﷺ بني الإسلام على خمس',
      primaryNumber: 8,
      internationalNumber: 8,
      arabicMatn: 'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَالحَجِّ، وَصَوْمِ رَمَضَانَ.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b008_1',
          grade: HadithGrade.sahih,
          scholarName: 'البخاري ومسلم',
          sourceBook: 'الصحيحان',
          context: 'متفق عليه',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_009',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      chapterNumber: 3,
      chapterName: 'باب أمور الإيمان وقول الله تعالى ليس البر أن تولوا وجوهكم',
      primaryNumber: 9,
      internationalNumber: 9,
      arabicMatn: 'الإِيمَانُ بِضْعٌ وَسِتُّونَ شُعْبَةً، وَالحَيَاءُ شُعْبَةٌ مِنَ الإِيمَانِ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b009_1',
          grade: HadithGrade.sahih,
          scholarName: 'البخاري ومسلم',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_010',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      chapterNumber: 4,
      chapterName: 'باب المسلم من سلم المسلمون من لسانه ويده',
      primaryNumber: 10,
      internationalNumber: 10,
      arabicMatn: 'المُسْلِمُ مَنْ سَلِمَ المُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ، وَالمُهَاجِرُ مَنْ هَجَرَ مَا نَهَى اللَّهُ عَنْهُ.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ عَمْرٍو رَضِيَ اللَّهُ عَنْهُمَا، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b010_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_013',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      chapterNumber: 7,
      chapterName: 'باب من الإيمان أن يحب لأخيه ما يحب لنفسه',
      primaryNumber: 13,
      internationalNumber: 13,
      arabicMatn: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ.',
      isnad: 'عَنْ أَنَسٍ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b013_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_015',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      chapterNumber: 8,
      chapterName: 'باب حب الرسول ﷺ من الإيمان',
      primaryNumber: 15,
      internationalNumber: 15,
      arabicMatn: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى أَكُونَ أَحَبَّ إِلَيْهِ مِنْ وَالِدِهِ وَوَلَدِهِ وَالنَّاسِ أَجْمَعِينَ.',
      isnad: 'عَنْ أَنَسٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ النَّبِيُّ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b015_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_052',
      collectionId: srcBukhari.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الإيمان',
      chapterNumber: 39,
      chapterName: 'باب فضل من استبرأ لدينه',
      primaryNumber: 52,
      internationalNumber: 52,
      arabicMatn: 'إِنَّ الحَلاَلَ بَيِّنٌ وَإِنَّ الحَرَامَ بَيِّنٌ، وَبَيْنَهُمَا مُشْتَبِهَاتٌ لاَ يَعْلَمُهُنَّ كَثِيرٌ مِنَ النَّاسِ، فَمَنِ اتَّقَى الشُّبُهَاتِ اسْتَبْرَأَ لِدِينِهِ وَعِرْضِهِ، وَمَنْ وَقَعَ فِي الشُّبُهَاتِ وَقَعَ فِي الحَرَامِ، كَالرَّاعِي يَرْعَى حَوْلَ الحِمَى، يُوشِكُ أَنْ يَرْتَعَ فِيهِ، أَلاَ وَإِنَّ لِكُلِّ مَلِكٍ حِمًى، أَلاَ وَإِنَّ حِمَى اللَّهِ مَحَارِمُهُ، أَلاَ وَإِنَّ فِي الجَسَدِ مُضْغَةً، إِذَا صَلَحَتْ صَلَحَ الجَسَدُ كُلُّهُ، وَإِذَا فَسَدَتْ فَسَدَ الجَسَدُ كُلُّهُ، أَلاَ وَهِيَ القَلْبُ.',
      isnad: 'عَنِ النُّعْمَانِ بْنِ بَشِيرٍ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b052_1',
          grade: HadithGrade.sahih,
          scholarName: 'البخاري ومسلم',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // =========================================================================
    // 3. كتاب العلم (Book 3)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_069',
      collectionId: srcBukhari.sourceId,
      bookNumber: 3,
      bookName: 'كتاب العلم',
      chapterNumber: 11,
      chapterName: 'باب ما كان النبي ﷺ يتخولهم بالموعظة والعلم كي لا ينفروا',
      primaryNumber: 69,
      internationalNumber: 69,
      arabicMatn: 'يَسِّرُوا وَلاَ تُعَسِّرُوا، وَبَشِّرُوا وَلاَ تُنَفِّرُوا.',
      isnad: 'عَنْ أَنَسِ بْنِ مَالِكٍ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b069_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_071',
      collectionId: srcBukhari.sourceId,
      bookNumber: 3,
      bookName: 'كتاب العلم',
      chapterNumber: 13,
      chapterName: 'باب من يرد الله به خيرا يفقهه في الدين',
      primaryNumber: 71,
      internationalNumber: 71,
      arabicMatn: 'مَنْ يُرِدِ اللَّهُ بِهِ خَيْراً يُفَقِّهْهُ فِي الدِّينِ، وَإِنَّمَا أَنَا قَاسِمٌ وَاللَّهُ يُعْطِي، وَلَنْ تَزَالَ هَذِهِ الأُمَّةُ قَائِمَةً عَلَى أَمْرِ اللَّهِ لاَ يَضُرُّهُمْ مَنْ خَالَفَهُمْ حَتَّى يَأْتِيَ أَمْرُ اللَّهِ.',
      isnad: 'عَنْ حُمَيْدِ بْنِ عَبْدِ الرَّحْمَنِ، سَمِعَ مُعَاوِيَةَ رَضِيَ اللَّهُ عَنْهُ خَطِيباً يَقُولُ: سَمِعْتُ النَّبِيَّ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b071_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_073',
      collectionId: srcBukhari.sourceId,
      bookNumber: 3,
      bookName: 'كتاب العلم',
      chapterNumber: 15,
      chapterName: 'باب الاغتباط في العلم والحكمة',
      primaryNumber: 73,
      internationalNumber: 73,
      arabicMatn: 'لاَ حَسَدَ إِلاَّ فِي اثْنَتَيْنِ: رَجُلٌ آتَاهُ اللَّهُ مَالاً فَسَلَّطَهُ عَلَى هَلَكَتِهِ فِي الحَقِّ، وَرَجُلٌ آتَاهُ اللَّهُ الحِكْمَةَ فَهُوَ يَقْضِي بِهَا وَيُعَلِّمُهَا.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ النَّبِيُّ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b073_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // =========================================================================
    // 4. كتاب الوضوء (Book 4)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_135',
      collectionId: srcBukhari.sourceId,
      bookNumber: 4,
      bookName: 'كتاب الوضوء',
      chapterNumber: 2,
      chapterName: 'باب لا تقبل صلاة بغير طهور',
      primaryNumber: 135,
      internationalNumber: 135,
      arabicMatn: 'لاَ تُقْبَلُ صَلاَةُ مَنْ أَحْدَثَ حَتَّى يَتَوَضَّأَ.',
      isnad: 'عَنْ هَمَّامِ بْنِ مُنَبِّهٍ، أَنَّهُ سَمِعَ أَبَا هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ يَقُولُ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b135_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_136',
      collectionId: srcBukhari.sourceId,
      bookNumber: 4,
      bookName: 'كتاب الوضوء',
      chapterNumber: 3,
      chapterName: 'باب فضل الوضوء والغر المحجلون من آثار الوضوء',
      primaryNumber: 136,
      internationalNumber: 136,
      arabicMatn: 'إِنَّ أُمَّتِي يُدْعَوْنَ يَوْمَ القِيَامَةِ غُرّاً مُحَجَّلِينَ مِنْ آثَارِ الوُضُوءِ، فَمَنِ اسْتَطَاعَ مِنْكُمْ أَنْ يُطِيلَ غُرَّتَهُ فَلْيَفْعَلْ.',
      isnad: 'عَنْ نُعَيْمِ بْنِ عَبْدِ اللَّهِ المُجْمِرِ، قَالَ: رَأَيْتُ أَبَا هُرَيْرَةَ يَتَوَضَّأُ... ثُمَّ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b136_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_140',
      collectionId: srcBukhari.sourceId,
      bookNumber: 4,
      bookName: 'كتاب الوضوء',
      chapterNumber: 7,
      chapterName: 'باب إسباغ الوضوء وغسل الأعقاب',
      primaryNumber: 165,
      internationalNumber: 165,
      arabicMatn: 'وَيْلٌ لِلأَعْقَابِ مِنَ النَّارِ، أَسْبِغُوا الوُضُوءَ.',
      isnad: 'عَنْ مُحَمَّدِ بْنِ زِيَادٍ، قَالَ: سَمِعْتُ أَبَا هُرَيْرَةَ وَكَانَ يَمُرُّ بِنَا وَالنَّاسُ يَتَوَضَّؤُونَ مِنْ المِطْهَرَةِ، قَالَ: أَسْبِغُوا الوُضُوءَ، فَإِنَّ أَبَا القَاسِمِ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b140_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // =========================================================================
    // 5. كتاب الصلاة ومواقيتها (Book 8 & 9)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_438',
      collectionId: srcBukhari.sourceId,
      bookNumber: 8,
      bookName: 'كتاب الصلاة',
      chapterNumber: 56,
      chapterName: 'باب قول النبي ﷺ جعلت لي الأرض مسجدا وطهورا',
      primaryNumber: 438,
      internationalNumber: 438,
      arabicMatn: 'أُعْطِيتُ خَمْساً لَمْ يُعْطَهُنَّ أَحَدٌ قَبْلِي: نُصِرْتُ بِالرُّعْبِ مَسِيرَةَ شَهْرٍ، وَجُعِلَتْ لِي الأَرْضُ مَسْجِداً وَطَهُوراً، فَأَيُّمَا رَجُلٍ مِنْ أُمَّتِي أَدْرَكَتْهُ الصَّلاَةُ فَلْيُصَلِّ...',
      isnad: 'عَنْ جَابِرِ بْنِ عَبْدِ اللَّهِ رَضِيَ اللَّهُ عَنْهُمَا، أَنَّ النَّبِيَّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b438_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_527',
      collectionId: srcBukhari.sourceId,
      bookNumber: 9,
      bookName: 'كتاب مواقيت الصلاة',
      chapterNumber: 5,
      chapterName: 'باب فضل الصلاة لوقتها',
      primaryNumber: 527,
      internationalNumber: 527,
      arabicMatn: 'سَأَلْتُ النَّبِيَّ ﷺ: أَيُّ العَمَلِ أَحَبُّ إِلَى اللَّهِ؟ قَالَ: الصَّلاَةُ عَلَى وَقْتِهَا. قَالَ: ثُمَّ أَيٌّ؟ قَالَ: ثُمَّ بِرُّ الوَالِدَيْنِ. قَالَ: ثُمَّ أَيٌّ؟ قَالَ: الجِهَادُ فِي سَبِيلِ اللَّهِ.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَأَلْتُ النَّبِيَّ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b527_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_574',
      collectionId: srcBukhari.sourceId,
      bookNumber: 9,
      bookName: 'كتاب مواقيت الصلاة',
      chapterNumber: 17,
      chapterName: 'باب فضل صلاة الفجر',
      primaryNumber: 574,
      internationalNumber: 574,
      arabicMatn: 'مَنْ صَلَّى البَرْدَيْنِ دَخَلَ الجَنَّةَ.',
      isnad: 'عَنْ أَبِي بَكْرِ بْنِ أَبِي مُوسَى، عَنْ أَبِيهِ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b574_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // =========================================================================
    // 6. كتاب الأذان والجماعة (Book 10)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_645',
      collectionId: srcBukhari.sourceId,
      bookNumber: 10,
      bookName: 'كتاب الأذان',
      chapterNumber: 30,
      chapterName: 'باب فضل صلاة الجماعة',
      primaryNumber: 645,
      internationalNumber: 645,
      arabicMatn: 'صَلاَةُ الجَمَاعَةِ تَفْضُلُ صَلاَةَ الفَذِّ بِسَبْعٍ وَعِشْرِينَ دَرَجَةً.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b645_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_660',
      collectionId: srcBukhari.sourceId,
      bookNumber: 10,
      bookName: 'كتاب الأذان',
      chapterNumber: 36,
      chapterName: 'باب من جلس في المسجد ينتظر الصلاة وفضل المساجد',
      primaryNumber: 660,
      internationalNumber: 660,
      arabicMatn: 'سَبْعَةٌ يُظِلُّهُمُ اللَّهُ فِي ظِلِّهِ يَوْمَ لاَ ظِلَّ إِلاَّ ظِلُّهُ: الإِمَامُ العَادِلُ، وَشَابٌّ نَشَأَ فِي عِبَادَةِ رَبِّهِ، وَرَجُلٌ قَلْبُهُ مُعَلَّقٌ فِي المَسَاجِدِ، وَرَجُلاَنِ تَحَابَّا فِي اللَّهِ اجْتَمَعَا عَلَيْهِ وَتَفَرَّقَا عَلَيْهِ، وَرَجُلٌ طَلَبَتْهُ امْرَأَةٌ ذَاتُ مَنْصِبٍ وَجَمَالٍ فَقَالَ: إِنِّي أَخَافُ اللَّهَ، وَرَجُلٌ تَصَدَّقَ بِصَدَقَةٍ فَأَخْفَاهَا حَتَّى لاَ تَعْلَمَ شِمَالُهُ مَا تُنْفِقُ يَمِينُهُ، وَرَجُلٌ ذَكَرَ اللَّهَ خَالِياً فَفَاضَتْ عَيْنَاهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b660_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    // =========================================================================
    // 7. كتب المعاملات والآداب والرقاق (Books 34, 47, 53, 66, 78, 81, 97)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_2079',
      collectionId: srcBukhari.sourceId,
      bookNumber: 34,
      bookName: 'كتاب البيوع',
      chapterNumber: 19,
      chapterName: 'باب البيعان بالخيار ما لم يتفرقا',
      primaryNumber: 2079,
      internationalNumber: 2079,
      arabicMatn: 'البَيِّعَانِ بِالخِيَارِ مَا لَمْ يَتَفَرَّقَا - أَوْ قَالَ: حَتَّى يَتَفَرَّقَا - فَإِنْ صَدَقَا وَبَيَّنَا بُورِكَ لَهُمَا فِي بَيْعِهِمَا، وَإِنْ كَتَمَا وَكَذَبَا مُحِقَتْ بَرَكَةُ بَيْعِهِمَا.',
      isnad: 'عَنْ حَكِيمِ بْنِ حِزَامٍ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b2079_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_2493',
      collectionId: srcBukhari.sourceId,
      bookNumber: 47,
      bookName: 'كتاب الشركة',
      chapterNumber: 6,
      chapterName: 'باب هل يقرع في القسمة والاستهام فيها؟',
      primaryNumber: 2493,
      internationalNumber: 2493,
      arabicMatn: 'مَثَلُ القَائِمِ عَلَى حُدُودِ اللَّهِ وَالوَاقِعِ فِيهَا، كَمَثَلِ قَوْمٍ اسْتَهَمُوا عَلَى سَفِينَةٍ، فَأَصَابَ بَعْضُهُمْ أَعْلاَهَا وَبَعْضُهُمْ أَسْفَلَهَا، فَكَانَ الَّذِينَ فِي أَسْفَلِهَا إِذَا اسْتَقَوْا مِنَ المَاءِ مَرُّوا عَلَى مَنْ فَوْقَهُمْ، فَقَالُوا: لَوْ أَنَّا خَرَقْنَا فِي نَصِيبِنَا خَرْقاً وَلَمْ نُؤْذِ مَنْ فَوْقَنَا، فَإِنْ يَتْرُكُوهُمْ وَمَا أَرَادُوا هَلَكُوا جَمِيعاً، وَإِنْ أَخَذُوا عَلَى أَيْدِيهِمْ نَجَوْا وَنَجَوْا جَمِيعاً.',
      isnad: 'عَنِ النُّعْمَانِ بْنِ بَشِيرٍ رَضِيَ اللَّهُ عَنْهُمَا، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b2493_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_2697',
      collectionId: srcBukhari.sourceId,
      bookNumber: 53,
      bookName: 'كتاب الصلح',
      chapterNumber: 5,
      chapterName: 'باب إذا اصطلحوا على صلح جور فالصلح مردود',
      primaryNumber: 2697,
      internationalNumber: 2697,
      arabicMatn: 'مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ فِيهِ، فَهُوَ رَدٌّ.',
      isnad: 'عَنْ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا قَالَتْ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b2697_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_5027',
      collectionId: srcBukhari.sourceId,
      bookNumber: 66,
      bookName: 'كتاب فضائل القرآن',
      chapterNumber: 21,
      chapterName: 'باب خيركم من تعلم القرآن وعلمه',
      primaryNumber: 5027,
      internationalNumber: 5027,
      arabicMatn: 'خَيْرُكُمْ مَنْ تَعَلَّمَ القُرْآنَ وَعَلَّمَهُ.',
      isnad: 'عَنْ عُثْمَانَ بْنِ عَفَّانَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b5027_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_6021',
      collectionId: srcBukhari.sourceId,
      bookNumber: 78,
      bookName: 'كتاب الأدب',
      chapterNumber: 33,
      chapterName: 'باب كل معروف صدقة',
      primaryNumber: 6021,
      internationalNumber: 6021,
      arabicMatn: 'كُلُّ مَعْرُوفٍ صَدَقَةٌ.',
      isnad: 'عَنْ جَابِرِ بْنِ عَبْدِ اللَّهِ رَضِيَ اللَّهُ عَنْهُمَا، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b6021_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_6094',
      collectionId: srcBukhari.sourceId,
      bookNumber: 78,
      bookName: 'كتاب الأدب',
      chapterNumber: 69,
      chapterName: 'باب قول الله تعالى يا أيها الذين آمنوا اتقوا الله وكونوا مع الصادقين',
      primaryNumber: 6094,
      internationalNumber: 6094,
      arabicMatn: 'إِنَّ الصِّدْقَ يَهْدِي إِلَى البِرِّ، وَإِنَّ البِرَّ يَهْدِي إِلَى الجَنَّةِ، وَإِنَّ الرَّجُلَ لَيَصْدُقُ حَتَّى يَكُونَ صِدِّيقاً. وَإِنَّ الكَذِبَ يَهْدِي إِلَى الفُجُورِ، وَإِنَّ الفُجُورَ يَهْدِي إِلَى النَّارِ، وَإِنَّ الرَّجُلَ لَيَكْذِبُ حَتَّى يُكْتَبَ عِنْدَ اللَّهِ كَذَّاباً.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b6094_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_6116',
      collectionId: srcBukhari.sourceId,
      bookNumber: 78,
      bookName: 'كتاب الأدب',
      chapterNumber: 76,
      chapterName: 'باب الحذر من الغضب',
      primaryNumber: 6116,
      internationalNumber: 6116,
      arabicMatn: 'أَنَّ رَجُلاً قَالَ لِلنَّبِيِّ ﷺ: أَوْصِنِي، قَالَ: لاَ تَغْضَبْ. فَرَدَّدَ مِرَاراً، قَالَ: لاَ تَغْضَبْ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَجُلاً قَالَ لِلنَّبِيِّ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b6116_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_6412',
      collectionId: srcBukhari.sourceId,
      bookNumber: 81,
      bookName: 'كتاب الرقاق',
      chapterNumber: 1,
      chapterName: 'باب ما جاء في الصحة والفراغ وأن لا عيش إلا عيش الآخرة',
      primaryNumber: 6412,
      internationalNumber: 6412,
      arabicMatn: 'نِعْمَتَانِ مَغْبُونٌ فِيهِمَا كَثِيرٌ مِنَ النَّاسِ: الصِّحَّةُ وَالفَرَاغُ.',
      isnad: 'عَنِ ابْنِ عَبَّاسٍ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: قَالَ النَّبِيُّ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b6412_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_6475',
      collectionId: srcBukhari.sourceId,
      bookNumber: 81,
      bookName: 'كتاب الرقاق',
      chapterNumber: 23,
      chapterName: 'باب حفظ اللسان',
      primaryNumber: 6475,
      internationalNumber: 6475,
      arabicMatn: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيَقُلْ خَيْراً أَوْ لِيَصْمُتْ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلاَ يُؤْذِ جَارَهُ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيُكْرِمْ ضَيْفَهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b6475_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_bukhari_7563',
      collectionId: srcBukhari.sourceId,
      bookNumber: 97,
      bookName: 'كتاب التوحيد',
      chapterNumber: 58,
      chapterName: 'باب قول الله تعالى ونضع الموازين القسط ليوم القيامة',
      primaryNumber: 7563,
      internationalNumber: 7563,
      arabicMatn: 'كَلِمَتَانِ حَبِيبَتَانِ إِلَى الرَّحْمَنِ، خَفِيفَتَانِ عَلَى اللِّسَانِ، ثَقِيلَتَانِ فِي المِيزَانِ: سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ العَظِيمِ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_b7563_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
          context: 'ختم به البخاري صحيحه الشريف تيمناً بحسن الختام',
        ),
      ],
    ));

    return list;
  }
}
