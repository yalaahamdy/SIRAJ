import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';
import '../../../modules/knowledge/domain/scholarly_attribution.dart';
import '../../../modules/knowledge/domain/source_record.dart';

/// Authentic Canonical Hadiths from Sahih Muslim across core classical books (§7..§12, M05.1).
class CanonicalHadithMuslim {
  static List<HadithEntity> buildHadiths(SourceRecord srcMuslim) {
    final list = <HadithEntity>[];

    // =========================================================================
    // 1. كتاب الإيمان (Book 1)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_008',
      collectionId: srcMuslim.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الإيمان',
      chapterNumber: 1,
      chapterName: 'باب بيان الإيمان والإسلام والإحسان ووجوب الإيمان بإثبات قدر الله',
      primaryNumber: 8,
      internationalNumber: 8,
      arabicMatn: 'قَالَ: فَأَخْبِرْنِي عَنِ الإِسْلاَمِ، فَقَالَ رَسُولُ اللَّهِ ﷺ: الإِسْلاَمُ أَنْ تَشْهَدَ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً رَسُولُ اللَّهِ، وَتُقِيمَ الصَّلاَةَ، وَتُؤْتِيَ الزَّكَاةَ، وَتَصُومَ رَمَضَانَ، وَتَحُجَّ البَيْتَ إِنِ اسْتَطَعْتَ إِلَيْهِ سَبِيلاً. قَالَ: صَدَقْتَ... قَالَ: فَأَخْبِرْنِي عَنِ الإِيمَانِ، قَالَ: أَنْ تُؤْمِنَ بِاللَّهِ، وَمَلاَئِكَتِهِ، وَكُتُبِهِ، وَرُسُلِهِ، وَاليَوْمِ الآخِرِ، وَتُؤْمِنَ بِالقَدَرِ خَيْرِهِ وَشَرِّهِ. قَالَ: صَدَقْتَ... قَالَ: فَأَخْبِرْنِي عَنِ الإِحْسَانِ، قَالَ: أَنْ تَعْبُدَ اللَّهَ كَأَنَّكَ تَرَاهُ، فَإِنْ لَمْ تَكُنْ تَرَاهُ فَإِنَّهُ يَرَاكَ.',
      isnad: 'عَنْ عُمَرَ بْنِ الخَطَّابِ رَضِيَ اللَّهُ عَنْهُ، قَالَ: بَيْنَمَا نَحْنُ عِنْدَ رَسُولِ اللَّهِ ﷺ ذَاتَ يَوْمٍ، إِذْ طَلَعَ عَلَيْنَا رَجُلٌ شَدِيدُ بَيَاضِ الثِّيَابِ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m008_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
          context: 'حديث جبريل الطويل المشهور، وهو أم السنة كما أن الفاتحة أم القرآن',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_m008_1',
          scholarId: 'nawawi',
          scholarName: 'الإمام النووي',
          quote: 'هذا الحديث يجمع جوامع الإسلام وقواعده الكلية، وقد اشتمل على بيان جميع وظائف العبادات الظاهرة والباطنة.',
          sourceId: srcMuslim.sourceId,
          pageReference: 'المنهاج شرح صحيح مسلم ج 1 ص 157',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_035',
      collectionId: srcMuslim.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الإيمان',
      chapterNumber: 12,
      chapterName: 'باب بيان عدد شعب الإيمان وأفضلها وأدناها وفضيلة الحياء',
      primaryNumber: 35,
      internationalNumber: 35,
      arabicMatn: 'الإِيمَانُ بِضْعٌ وَسَبْعُونَ - أَوْ بِضْعٌ وَسِتُّونَ - شُعْبَةً، فَأَفْضَلُهَا قَوْلُ لاَ إِلَهَ إِلاَّ اللَّهُ، وَأَدْنَاهَا إِمَاطَةُ الأَذَى عَنِ الطَّرِيقِ، وَالحَيَاءُ شُعْبَةٌ مِنَ الإِيمَانِ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m035_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_054',
      collectionId: srcMuslim.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الإيمان',
      chapterNumber: 22,
      chapterName: 'باب بيان أنه لا يدخل الجنة إلا المؤمنون وأن محبة المؤمنين من الإيمان وأن إفشاء السلام سببه',
      primaryNumber: 54,
      internationalNumber: 54,
      arabicMatn: 'لاَ تَدْخُلُونَ الجَنَّةَ حَتَّى تُؤْمِنُوا، وَلاَ تُؤْمِنُوا حَتَّى تَحَابُّوا، أَوَلاَ أَدُلُّكُمْ عَلَى شَيْءٍ إِذَا فَعَلْتُمُوهُ تَحَابَبْتُمْ؟ أَفْشُوا السَّلاَمَ بَيْنَكُمْ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m054_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_055',
      collectionId: srcMuslim.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الإيمان',
      chapterNumber: 23,
      chapterName: 'باب بيان أن الدين النصيحة',
      primaryNumber: 55,
      internationalNumber: 55,
      arabicMatn: 'الدِّينُ النَّصِيحَةُ. قُلْنَا: لِمَنْ؟ قَالَ: لِلَّهِ وَلِكِتَابِهِ وَلِرَسُولِهِ وَلأَئِمَّةِ المُسْلِمِينَ وَعَامَّتِهِمْ.',
      isnad: 'عَنْ تَمِيمٍ الدَّارِيِّ رَضِيَ اللَّهُ عَنْهُ، أَنَّ النَّبِيَّ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m055_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    // =========================================================================
    // 2. كتاب الطهارة (Book 2)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_223',
      collectionId: srcMuslim.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الطهارة',
      chapterNumber: 1,
      chapterName: 'باب فضل الوضوء والصلاة عقبه',
      primaryNumber: 223,
      internationalNumber: 223,
      arabicMatn: 'الطُّهُورُ شَطْرُ الإِيمَانِ، وَالحَمْدُ لِلَّهِ تَمْلأُ المِيزَانَ، وَسُبْحَانَ اللَّهِ وَالحَمْدُ لِلَّهِ تَمْلآنِ - أَوْ تَمْلأُ - مَا بَيْنَ السَّمَاوَاتِ وَالأَرْضِ، وَالصَّلاَةُ نُورٌ، وَالصَّدَقَةُ بُرْهَانٌ، وَالصَّبْرُ ضِيَاءٌ، وَالقُرْآنُ حُجَّةٌ لَكَ أَوْ عَلَيْكَ، كُلُّ النَّاسِ يَغْدُو فَبَايِعٌ نَفْسَهُ فَمُعْتِقُهَا أَوْ مُوبِقُهَا.',
      isnad: 'عَنْ أَبِي مَالِكٍ الأَشْعَرِيِّ رَضِيَ اللَّهُ عَنْهُ، قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m223_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_234',
      collectionId: srcMuslim.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الطهارة',
      chapterNumber: 6,
      chapterName: 'باب الذكر المستحب عقب الوضوء',
      primaryNumber: 234,
      internationalNumber: 234,
      arabicMatn: 'مَا مِنْكُمْ مِنْ أَحَدٍ يَتَوَضَّأُ فَيُبْلِغُ - أَوْ فَيُسْبِغُ - الوُضُوءَ ثُمَّ يَقُولُ: أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً عَبْدُ اللَّهِ وَرَسُولُهُ، إِلاَّ فُتِحَتْ لَهُ أَبْوَابُ الجَنَّةِ الثَّمَانِيَةُ يَدْخُلُ مِنْ أَيِّهَا شَاءَ.',
      isnad: 'عَنْ عُقْبَةَ بْنِ عَامِرٍ رَضِيَ اللَّهُ عَنْهُ، عَنْ عُمَرَ بْنِ الخَطَّابِ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m234_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_244',
      collectionId: srcMuslim.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الطهارة',
      chapterNumber: 11,
      chapterName: 'باب خروج الخطايا مع ماء الوضوء',
      primaryNumber: 244,
      internationalNumber: 244,
      arabicMatn: 'إِذَا تَوَضَّأَ العَبْدُ المُسْلِمُ - أَوِ المُؤْمِنُ - فَغَسَلَ وَجْهَهُ خَرَجَ مِنْ وَجْهِهِ كُلُّ خَطِيئَةٍ نَظَرَ إِلَيْهَا بِعَيْنَيْهِ مَعَ المَاءِ - أَوْ مَعَ آخِرِ قَطْرِ المَاءِ - فَإِذَا غَسَلَ يَدَيْهِ خَرَجَ مِنْ يَدَيْهِ كُلُّ خَطِيئَةٍ كَانَ بَطَشَتْهَا يَدَاهُ مَعَ المَاءِ... حَتَّى يَخْرُجَ نَقِيّاً مِنَ الذُّنُوبِ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m244_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    // =========================================================================
    // 3. كتاب الصلاة (Book 4)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_394',
      collectionId: srcMuslim.sourceId,
      bookNumber: 4,
      bookName: 'كتاب الصلاة',
      chapterNumber: 11,
      chapterName: 'باب وجوب قراءة الفاتحة في كل ركعة وإنه إذا لم يحسن الفاتحة قرأ ما تيسر له من غيرها',
      primaryNumber: 394,
      internationalNumber: 394,
      arabicMatn: 'لاَ صَلاَةَ لِمَنْ لَمْ يَقْرَأْ بِأُمِّ القُرْآنِ.',
      isnad: 'عَنْ عُبَادَةَ بْنِ الصَّامِتِ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m394_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_533',
      collectionId: srcMuslim.sourceId,
      bookNumber: 4,
      bookName: 'كتاب الصلاة',
      chapterNumber: 4,
      chapterName: 'باب فضل بناء المساجد والحث عليها',
      primaryNumber: 533,
      internationalNumber: 533,
      arabicMatn: 'مَنْ بَنَى مَسْجِداً لِلَّهِ بَنَى اللَّهُ لَهُ مِثْلَهُ فِي الجَنَّةِ.',
      isnad: 'عَنْ عُثْمَانَ بْنِ عَفَّانَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m533_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_666',
      collectionId: srcMuslim.sourceId,
      bookNumber: 4,
      bookName: 'كتاب الصلاة',
      chapterNumber: 51,
      chapterName: 'باب فضل كثرة الخطا إلى المساجد',
      primaryNumber: 666,
      internationalNumber: 666,
      arabicMatn: 'أَلاَ أَدُلُّكُمْ عَلَى مَا يَمْحُو اللَّهُ بِهِ الخَطَايَا، وَيَرْفَعُ بِهِ الدَّرَجَاتِ؟ قَالُوا: بَلَى يَا رَسُولَ اللَّهِ، قَالَ: إِسْبَاغُ الوُضُوءِ عَلَى المَكَارِهِ، وَكَثْرَةُ الخُطَا إِلَى المَسَاجِدِ، وَانْتِظَارُ الصَّلاَةِ بَعْدَ الصَّلاَةِ، فَذَلِكُمُ الرِّبَاطُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m666_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    // =========================================================================
    // 4. كتب الصيام والوصية والذبائح والبر (Books 6, 13, 25, 34, 45, 48)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_782',
      collectionId: srcMuslim.sourceId,
      bookNumber: 6,
      bookName: 'كتاب صلاة المسافرين وقصرها',
      chapterNumber: 30,
      chapterName: 'باب فضيلة العمل الدائم من قيام الليل وغيره',
      primaryNumber: 782,
      internationalNumber: 782,
      arabicMatn: 'أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ.',
      isnad: 'عَنْ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا قَالَتْ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m782_1',
          grade: HadithGrade.sahih,
          scholarName: 'متفق عليه',
          sourceBook: 'الصحيحان',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_1162',
      collectionId: srcMuslim.sourceId,
      bookNumber: 13,
      bookName: 'كتاب الصيام',
      chapterNumber: 36,
      chapterName: 'باب استحباب صيام ثلاثة أيام من كل شهر وصوم يوم عرفة وعاشوراء',
      primaryNumber: 1162,
      internationalNumber: 1162,
      arabicMatn: 'صِيَامُ يَوْمِ عَرَفَةَ أَحْتَسِبُ عَلَى اللَّهِ أَنْ يُكَفِّرَ السَّنَةَ الَّتِي قَبْلَهُ وَالسَّنَةَ الَّتِي بَعْدَهُ، وَصِيَامُ يَوْمِ عَاشُورَاءَ أَحْتَسِبُ عَلَى اللَّهِ أَنْ يُكَفِّرَ السَّنَةَ الَّتِي قَبْلَهُ.',
      isnad: 'عَنْ أَبِي قَتَادَةَ الأَنْصَارِيِّ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ سُئِلَ عَنْ صَوْمِ يَوْمِ عَرَفَةَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m1162_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_1631',
      collectionId: srcMuslim.sourceId,
      bookNumber: 25,
      bookName: 'كتاب الوصية',
      chapterNumber: 3,
      chapterName: 'باب ما يلحق الإنسان من الثواب بعد وفاته',
      primaryNumber: 1631,
      internationalNumber: 1631,
      arabicMatn: 'إِذَا مَاتَ الإِنْسَانُ انْقَطَعَ عَنْهُ عَمَلُهُ إِلاَّ مِنْ ثَلاَثَةٍ: إِلاَّ مِنْ صَدَقَةٍ جَارِيَةٍ، أَوْ عِلْمٍ يُنْتَفَعُ بِهِ، أَوْ وَلَدٍ صَالِحٍ يَدْعُو لَهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m1631_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_1955',
      collectionId: srcMuslim.sourceId,
      bookNumber: 34,
      bookName: 'كتاب الصيد والذبائح وما يؤكل من الحيوان',
      chapterNumber: 11,
      chapterName: 'باب الأمر بإحسان الذبح والقتل وتحديد الشفرة',
      primaryNumber: 1955,
      internationalNumber: 1955,
      arabicMatn: 'إِنَّ اللَّهَ كَتَبَ الإِحْسَانَ عَلَى كُلِّ شَيْءٍ، فَإِذَا قَتَلْتُمْ فَأَحْسِنُوا القِتْلَةَ، وَإِذَا ذَبَحْتُمْ فَأَحْسِنُوا الذِّبْحَةَ، وَلْيُحِدَّ أَحَدُكُمْ شَفْرَتَهُ، فَلْيُرِحْ ذَبِيحَتَهُ.',
      isnad: 'عَنْ شَدَّادِ بْنِ أَوْسٍ رَضِيَ اللَّهُ عَنْهُ، عَنْ رَسُولِ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m1955_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_2577',
      collectionId: srcMuslim.sourceId,
      bookNumber: 45,
      bookName: 'كتاب البر والصلة والآداب',
      chapterNumber: 15,
      chapterName: 'باب تحريم الظلم',
      primaryNumber: 2577,
      internationalNumber: 2577,
      arabicMatn: 'يَا عِبَادِي إِنِّي حَرَّمْتُ الظُّلْمَ عَلَى نَفْسِي، وَجَعَلْتُهُ بَيْنَكُمْ مُحَرَّماً، فَلاَ تَظَالَمُوا، يَا عِبَادِي كُلُّكُمْ ضَالٌّ إِلاَّ مَنْ هَدَيْتُهُ، فَاسْتَهْدُونِي أَهْدِكُمْ، يَا عِبَادِي كُلُّكُمْ جَائِعٌ إِلاَّ مَنْ أَطْعَمْتُهُ، فَاسْتَطْعِمُونِي أُطْعِمْكُمْ...',
      isnad: 'عَنْ أَبِي ذَرٍّ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ فِيمَا رَوَى عَنِ اللَّهِ تَبَارَكَ وَتَعَالَى...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m2577_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
          context: 'حديث قدسي جليل في أصول العدل الإلهي وتنزيه الخالق عن الظلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_2588',
      collectionId: srcMuslim.sourceId,
      bookNumber: 45,
      bookName: 'كتاب البر والصلة والآداب',
      chapterNumber: 19,
      chapterName: 'باب استحباب العفو والتواضع',
      primaryNumber: 2588,
      internationalNumber: 2588,
      arabicMatn: 'مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ، وَمَا زَادَ اللَّهُ عَبْداً بِعَفْوٍ إِلاَّ عِزّاً، وَمَا تَوَاضَعَ أَحَدٌ لِلَّهِ إِلاَّ رَفَعَهُ اللَّهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، عَنْ رَسُولِ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m2588_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_2594',
      collectionId: srcMuslim.sourceId,
      bookNumber: 45,
      bookName: 'كتاب البر والصلة والآداب',
      chapterNumber: 23,
      chapterName: 'باب فضل الرفق',
      primaryNumber: 2594,
      internationalNumber: 2594,
      arabicMatn: 'إِنَّ الرِّفْقَ لاَ يَكُونُ فِي شَيْءٍ إِلاَّ زَانَهُ، وَلاَ يُنْزَعُ مِنْ شَيْءٍ إِلاَّ شَانَهُ.',
      isnad: 'عَنْ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا زَوْجِ النَّبِيِّ ﷺ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m2594_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_2699',
      collectionId: srcMuslim.sourceId,
      bookNumber: 48,
      bookName: 'كتاب الذكر والدعاء والتوبة والاستغفار',
      chapterNumber: 11,
      chapterName: 'باب فضل الاجتماع على تلاوة القرآن وعلى الذكر',
      primaryNumber: 2699,
      internationalNumber: 2699,
      arabicMatn: 'مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا، نَفَّسَ اللَّهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ القِيَامَةِ، وَمَنْ يَسَّرَ عَلَى مُعْسِرٍ، يَسَّرَ اللَّهُ عَلَيْهِ فِي الدُّنْيَا وَالآخِرَةِ، وَمَنْ سَتَرَ مُسْلِماً، سَتَرَهُ اللَّهُ فِي الدُّنْيَا وَالآخِرَةِ، وَاللَّهُ فِي عَوْنِ العَبْدِ مَا كَانَ العَبْدُ فِي عَوْنِ أَخِيهِ، وَمَنْ سَلَكَ طَرِيقاً يَلْتَمِسُ فِيهِ عِلْماً، سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقاً إِلَى الجَنَّةِ، وَمَا اجْتَمَعَ قَوْمٌ فِي بَيْتٍ مِنْ بُيُوتِ اللَّهِ، يَتْلُونَ كِتَابَ اللَّهِ، وَيَتَدَارَسُونَهُ بَيْنَهُمْ، إِلاَّ نَزَلَتْ عَلَيْهِمُ السَّكِينَةُ، وَغَشِيَتْهُمُ الرَّحْمَةُ وَحَفَّتْهُمُ المَلاَئِكَةُ، وَذَكَرَهُمُ اللَّهُ فِيمَنْ عِنْدَهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m2699_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muslim_2702',
      collectionId: srcMuslim.sourceId,
      bookNumber: 48,
      bookName: 'كتاب الذكر والدعاء والتوبة والاستغفار',
      chapterNumber: 12,
      chapterName: 'باب استحباب الاستغفار والاستكثار منه',
      primaryNumber: 2702,
      internationalNumber: 2702,
      arabicMatn: 'يَا أَيُّهَا النَّاسُ تُوبُوا إِلَى اللَّهِ، فَإِنِّي أَتُوبُ فِي اليَوْمِ إِلَيْهِ مِائَةَ مَرَّةٍ.',
      isnad: 'عَنِ الأَغَرِّ المُزَنِيِّ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_m2702_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
        ),
      ],
    ));

    return list;
  }
}
