import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';
import '../../../modules/knowledge/domain/scholarly_attribution.dart';
import '../../../modules/knowledge/domain/source_record.dart';

/// الأربعين النووية في مباني الإسلام وقواعد الأحكام — الجزء الأول (الأحاديث 1 إلى 21)
/// متون محققة ومشكولة بالكامل مع الأسانيد والأحكام والشروح المعتمدة (§7..§12).
class CanonicalHadithNawawiPart1 {
  static List<HadithEntity> buildHadiths({
    required SourceRecord srcBukhari,
    required SourceRecord srcMuslim,
    required SourceRecord srcAbuDawud,
    required SourceRecord srcTirmidhi,
    required SourceRecord srcNasai,
    required SourceRecord srcIbnMajah,
  }) {
    final list = <HadithEntity>[];

    // الحديث 1: النية ومقاصد الأعمال
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_01',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 1,
      chapterName: 'باب النية والإخلاص وميزان الأعمال الباطنة',
      primaryNumber: 1,
      internationalNumber: 1,
      arabicMatn: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ فَهِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ، وَمَنْ كَانَتْ هِجْرَتُهُ لِدُنْيَا يُصِيبُهَا، أَوْ إِلَى امْرَأَةٍ يَنْكِحُهَا، فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ.',
      isnad: 'عَنْ أَمِيرِ المُؤْمِنِينَ أَبِي حَفْصٍ عُمَرَ بْنِ الخَطَّابِ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_01',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'متفق عليه، رواه إماما المحدثين أبو عبد الله البخاري وأبو الحسين مسلم في صحيحيهما.',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_nawawi_01',
          scholarId: 'an_nawawi',
          scholarName: 'الإمام النووي',
          quote: 'هذا الحديث مجمع على عظم موقعه وجلالته، وهو أحد الأحاديث التي عليها مدار الإسلام، وقيل هو ثلث العلم.',
          sourceId: srcBukhari.sourceId,
          pageReference: 'شرح الأربعين النووية ص 12',
        ),
      ],
    ));

    // الحديث 2: حديث جبريل المشهور (الإسلام والإيمان والإحسان)
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_02',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 2,
      chapterName: 'باب مراتب الدين: الإسلام والإيمان والإحسان وعلامات الساعة',
      primaryNumber: 2,
      internationalNumber: 8,
      arabicMatn: 'بَيْنَمَا نَحْنُ عِنْدَ رَسُولِ اللَّهِ ﷺ ذَاتَ يَوْمٍ إِذْ طَلَعَ عَلَيْنَا رَجُلٌ شَدِيدُ بَيَاضِ الثِّيَابِ شَدِيدُ سَوَادِ الشَّعَرِ، لاَ يُرَى عَلَيْهِ أَثَرُ السَّفَرِ، وَلاَ يَعْرِفُهُ مِنَّا أَحَدٌ، حَتَّى جَلَسَ إِلَى النَّبِيِّ ﷺ فَأَسْنَدَ رُكْبَتَيْهِ إِلَى رُكْبَتَيْهِ وَوَضَعَ كَفَّيْهِ عَلَى فَخِذَيْهِ وَقَالَ: يَا مُحَمَّدُ أَخْبِرْنِي عَنِ الإِسْلاَمِ... فَقَالَ: الإِسْلاَمُ أَنْ تَشْهَدَ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً رَسُولُ اللَّهِ، وَتُقِيمَ الصَّلاَةَ، وَتُؤْتِيَ الزَّكَاةَ، وَتَصُومَ رَمَضَانَ، وَتَحُجَّ البَيْتَ إِنِ اسْتَطَعْتَ إِلَيْهِ سَبِيلاً. قَالَ: صَدَقْتَ. قَالَ: فَأَخْبِرْنِي عَنِ الإِيمَانِ، قَالَ: أَنْ تُؤْمِنَ بِاللَّهِ، وَمَلاَئِكَتِهِ، وَكُتُبِهِ، وَرُسُلِهِ، وَاليَوْمِ الآخِرِ، وَتُؤْمِنَ بِالقَدَرِ خَيْرِهِ وَشَرِّهِ. قَالَ: صَدَقْتَ. قَالَ: فَأَخْبِرْنِي عَنِ الإِحْسَانِ، قَالَ: أَنْ تَعْبُدَ اللَّهَ كَأَنَّكَ تَرَاهُ، فَإِنْ لَمْ تَكُنْ تَرَاهُ فَإِنَّهُ يَرَاكَ...',
      isnad: 'عَنْ عُمَرَ بْنِ الخَطَّابِ رَضِيَ اللَّهُ عَنْهُ قَالَ: بَيْنَمَا نَحْنُ جُلُوسٌ عِنْدَ رَسُولِ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_02',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم بن الحجاج',
          sourceBook: 'صحيح مسلم',
          context: 'صحيح، رواه مسلم في كتاب الإيمان.',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_nawawi_02',
          scholarId: 'ibn_daqiq',
          scholarName: 'ابن دقيق العيد',
          quote: 'هذا الحديث بمنزلة أم القرآن؛ لتضمنه جميع علوم الشريعة من أصول وفروع وأعمال قلوب وجوارح.',
          sourceId: srcMuslim.sourceId,
          pageReference: 'شرح الأربعين لابن دقيق العيد ص 18',
        ),
      ],
    ));

    // الحديث 3: بني الإسلام على خمس
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_03',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 3,
      chapterName: 'باب أركان الإسلام ودعائمه العظام',
      primaryNumber: 3,
      internationalNumber: 8,
      arabicMatn: 'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَحَجِّ البَيْتِ، وَصَوْمِ رَمَضَانَ.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ عُمَرَ بْنِ الخَطَّابِ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_03',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 4: خلق الإنسان في بطن أمه والقدر
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_04',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 4,
      chapterName: 'باب أطوار خلق الإنسان وكتابة الأجل والرزق وخواتيم الأعمال',
      primaryNumber: 4,
      internationalNumber: 3208,
      arabicMatn: 'إِنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْماً نُطْفَةً، ثُمَّ يَكُونُ عَلَقَةً مِثْلَ ذَلِكَ، ثُمَّ يَكُونُ مُضْغَةً مِثْلَ ذَلِكَ، ثُمَّ يُرْسَلُ إِلَيْهِ المَلَكُ فَيَنْفُخُ فِيهِ الرُّوحَ، وَيُؤْمَرُ بِأَرْبَعِ كَلِمَاتٍ: بِكَتْبِ رِزْقِهِ، وَأَجَلِهِ، وَعَمَلِهِ، وَشَقِيٌّ أَوْ سَعِيدٌ...',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: حَدَّثَنَا رَسُولُ اللَّهِ ﷺ وَهُوَ الصَّادِقُ المَصْدُوقُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_04',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'متفق عليه، رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 5: من أحدث في أمرنا هذا ما ليس منه فهو رد
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_05',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 5,
      chapterName: 'باب النهي عن الابتداع وميزان الأعمال الظاهرة',
      primaryNumber: 5,
      internationalNumber: 2697,
      arabicMatn: 'مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ مِنْهُ فَهُوَ رَدٌّ. وفي رواية لمسلم: «مَنْ عَمِلَ عَمَلاً لَيْسَ عَلَيْهِ أَمْرُنَا فَهُوَ رَدٌّ».',
      isnad: 'عَنْ أُمِّ المُؤْمِنِينَ أُمِّ عَبْدِ اللَّهِ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا قَالَتْ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_05',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم، وهو ميزان الأعمال في الظاهر كما أن حديث النيات ميزانها في الباطن.',
        ),
      ],
    ));

    // الحديث 6: الحلال بيّن والحرام بيّن
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_06',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 6,
      chapterName: 'باب الورع والشبهات وصلاح مضغة القلب',
      primaryNumber: 6,
      internationalNumber: 52,
      arabicMatn: 'إِنَّ الحَلاَلَ بَيِّنٌ وَإِنَّ الحَرَامَ بَيِّنٌ، وَبَيْنَهُمَا أُمُورٌ مُشْتَبِهَاتٌ لاَ يَعْلَمُهُنَّ كَثِيرٌ مِنَ النَّاسِ، فَمَنِ اتَّقَى الشُّبُهَاتِ اسْتَبْرَأَ لِدِينِهِ وَعِرْضِهِ، وَمَنْ وَقَعَ فِي الشُّبُهَاتِ وَقَعَ فِي الحَرَامِ، كَالرَّاعِي يَرْعَى حَوْلَ الحِمَى يُوشِكُ أَنْ يَرْتَعَ فِيهِ، أَلاَ وَإِنَّ لِكُلِّ مَلِكٍ حِمًى، أَلاَ وَإِنَّ حِمَى اللَّهِ مَحَارِمُهُ، أَلاَ وَإِنَّ فِي الجَسَدِ مُضْغَةً إِذَا صَلَحَتْ صَلَحَ الجَسَدُ كُلُّهُ، وَإِذَا فَسَدَتْ فَسَدَ الجَسَدُ كُلُّهُ، أَلاَ وَهِيَ القَلْبُ.',
      isnad: 'عَنْ أَبِي عَبْدِ اللَّهِ النُّعْمَانِ بْنِ بَشِيرٍ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_06',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'متفق عليه، رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 7: الدين النصيحة
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_07',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 7,
      chapterName: 'باب وجوب النصيحة لله ولكتابه ولرسوله ولأئمة المسلمين وعامتهم',
      primaryNumber: 7,
      internationalNumber: 55,
      arabicMatn: 'الدِّينُ النَّصِيحَةُ. قُلْنَا: لِمَنْ يَا رَسُولَ اللَّهِ؟ قَالَ: لِلَّهِ، وَلِكِتَابِهِ، وَلِرَسُولِهِ، وَلأَئِمَّةِ المُسْلِمِينَ وَعَامَّتِهِمْ.',
      isnad: 'عَنْ أَبِي رُقَيَّةَ تَمِيمِ بْنِ أَوْسٍ الدَّارِيِّ رَضِيَ اللَّهُ عَنْهُ، أَنَّ النَّبِيَّ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_07',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم في صحيحه.',
        ),
      ],
    ));

    // الحديث 8: أمرت أن أقاتل الناس حتى يشهدوا
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_08',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 8,
      chapterName: 'باب حرمة دم المسلم وماله وعصمتهما',
      primaryNumber: 8,
      internationalNumber: 25,
      arabicMatn: 'أُمِرْتُ أَنْ أُقَاتِلَ النَّاسَ حَتَّى يَشْهَدُوا أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً رَسُولُ اللَّهِ، وَيُقِيمُوا الصَّلاَةَ، وَيُؤْتُوا الزَّكَاةَ، فَإِذَا فَعَلُوا ذَلِكَ عَصَمُوا مِنِّي دِمَاءَهُمْ وَأَمْوَالَهُمْ إِلاَّ بِحَقِّ الإِسْلاَمِ، وَحِسَابُهُمْ عَلَى اللَّهِ تَعَالَى.',
      isnad: 'عَنِ ابْنِ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_08',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 9: ما نهيتكم عنه فاجتنبوه
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_09',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 9,
      chapterName: 'باب التكليف بما يستطاع وترك كثرة السؤال والاختلاف',
      primaryNumber: 9,
      internationalNumber: 7288,
      arabicMatn: 'مَا نَهَيْتُكُمْ عَنْهُ فَاجْتَنِبُوهُ، وَمَا أَمَرْتُكُمْ بِهِ فَأْتُوا مِنْهُ مَا اسْتَطَعْتُمْ، فَإِنَّمَا أَهْلَكَ الَّذِينَ مِنْ قَبْلِكُمْ كَثْرَةُ مَسَائِلِهِمْ وَاخْتِلاَفُهُمْ عَلَى أَنْبِيَائِهِمْ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ عَبْدِ الرَّحْمَنِ بْنِ صَخْرٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_09',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 10: إن الله تعالى طيب لا يقبل إلا طيبا
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_10',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 10,
      chapterName: 'باب إطابة المطعم وأثر الرزق الحلال في إجابة الدعاء',
      primaryNumber: 10,
      internationalNumber: 1015,
      arabicMatn: 'إِنَّ اللَّهَ تَعَالَى طَيِّبٌ لاَ يَقْبَلُ إِلاَّ طَيِّباً، وَإِنَّ اللَّهَ أَمَرَ المُؤْمِنِينَ بِمَا أَمَرَ بِهِ المُرْسَلِينَ... ثُمَّ ذَكَرَ الرَّجُلَ يُطِيلُ السَّفَرَ أَشْعَثَ أَغْبَرَ يَمُدُّ يَدَيْهِ إِلَى السَّمَاءِ: يَا رَبِّ يَا رَبِّ، وَمَطْعَمُهُ حَرَامٌ، وَمَشْرَبُهُ حَرَامٌ، وَمَلْبَسُهُ حَرَامٌ، وَغُذِيَ بِالحَرَامِ، فَأَنَّى يُسْتَجَابُ لِذَلِكَ؟!',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_10',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم في صحيحه.',
        ),
      ],
    ));

    // الحديث 11: دع ما يريبك إلى ما لا يريبك
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_11',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 11,
      chapterName: 'باب ترك الشبهات وطمأنينة القلب للحق',
      primaryNumber: 11,
      internationalNumber: 2518,
      arabicMatn: 'دَعْ مَا يَرِيبُكَ إِلَى مَا لاَ يَرِيبُكَ، فَإِنَّ الصِّدْقَ طُمَأْنِينَةٌ، وَإِنَّ الكَذِبَ رِيبَةٌ.',
      isnad: 'عَنْ أَبِي مُحَمَّدٍ الحَسَنِ بْنِ عَلِيِّ بْنِ أَبِي طَالِبٍ سِبْطِ رَسُولِ اللَّهِ ﷺ وَرَيْحَانَتِهِ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: حَفِظْتُ مِنْ رَسُولِ اللَّهِ ﷺ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_11',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي والنووي',
          sourceBook: 'جامع الترمذي والأربعين النووية',
          context: 'رواه الترمذي والنسائي، وقال الترمذي: حديث حسن صحيح.',
        ),
      ],
    ));

    // الحديث 12: من حسن إسلام المرء تركه ما لا يعنيه
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_12',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 12,
      chapterName: 'باب كمال إسلام العبد بترك الفضول وما لا ينفعه',
      primaryNumber: 12,
      internationalNumber: 2317,
      arabicMatn: 'مِنْ حُسْنِ إِسْلاَمِ المَرْءِ تَرْكُهُ مَا لاَ يَعْنِيهِ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_12',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'حديث حسن، رواه الترمذي وغيره هكذا.',
        ),
      ],
    ));

    // الحديث 13: لا يؤمن أحدكم حتى يحب لأخيه ما يحب لنفسه
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_13',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 13,
      chapterName: 'باب كمال الإيمان بمحبة الخير لعموم المسلمين',
      primaryNumber: 13,
      internationalNumber: 13,
      arabicMatn: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ.',
      isnad: 'عَنْ أَبِي حَمْزَةَ أَنَسِ بْنِ مَالِكٍ رَضِيَ اللَّهُ عَنْهُ خَادِمِ رَسُولِ اللَّهِ ﷺ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_13',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 14: لا يحل دم امرئ مسلم إلا بإحدى ثلاث
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_14',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 14,
      chapterName: 'باب أسباب استباحة دم المعصوم في الشريعة',
      primaryNumber: 14,
      internationalNumber: 6878,
      arabicMatn: 'لاَ يَحِلُّ دَمُ امْرِئٍ مُسْلِمٍ يَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنِّي رَسُولُ اللَّهِ إِلاَّ بِإِحْدَى ثَلاَثٍ: الثَّيِّبُ الزَّانِي، وَالنَّفْسُ بِالنَّفْسِ، وَالتَّارِكُ لِدِينِهِ المُفَارِقُ لِلْجَمَاعَةِ.',
      isnad: 'عَنِ ابْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_14',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 15: من كان يؤمن بالله واليوم الآخر فليقل خيرا أو ليصمت
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_15',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 15,
      chapterName: 'باب آفات اللسان وإكرام الجار والضيف',
      primaryNumber: 15,
      internationalNumber: 6018,
      arabicMatn: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيَقُلْ خَيْراً أَوْ لِيَصْمُتْ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيُكْرِمْ جَارَهُ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَاليَوْمِ الآخِرِ فَلْيُكْرِمْ ضَيْفَهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_15',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 16: لا تغضب
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_16',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 16,
      chapterName: 'باب وصية النبي بالنهي عن الغضب وعلاجه',
      primaryNumber: 16,
      internationalNumber: 6116,
      arabicMatn: 'أَنَّ رَجُلاً قَالَ لِلنَّبِيِّ ﷺ: أَوْصِنِي. قَالَ: «لاَ تَغْضَبْ». فَرَدَّدَ مِرَاراً، قَالَ: «لاَ تَغْضَبْ».',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_16',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري.',
        ),
      ],
    ));

    // الحديث 17: إن الله كتب الإحسان على كل شيء
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_17',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 17,
      chapterName: 'باب شمول الإحسان حتى في القتل والذبح والرفق بالحيوان',
      primaryNumber: 17,
      internationalNumber: 1955,
      arabicMatn: 'إِنَّ اللَّهَ كَتَبَ الإِحْسَانَ عَلَى كُلِّ شَيْءٍ، فَإِذَا قَتَلْتُمْ فَأَحْسِنُوا القِتْلَةَ، وَإِذَا ذَبَحْتُمْ فَأَحْسِنُوا الذِّبْحَةَ، وَلْيُحِدَّ أَحَدُكُمْ شَفْرَتَهُ، وَلْيُرِحْ ذَبِيحَتَهُ.',
      isnad: 'عَنْ أَبِي يَعْلَى شَدَّادِ بْنِ أَوْسٍ رَضِيَ اللَّهُ عَنْهُ، عَنْ رَسُولِ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_17',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم.',
        ),
      ],
    ));

    // الحديث 18: اتق الله حيثما كنت
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_18',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 18,
      chapterName: 'باب التقوى في السر والعلن وإتباع السيئة الحسنة وخلق الناس',
      primaryNumber: 18,
      internationalNumber: 1987,
      arabicMatn: 'اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ، وَأَتْبِعِ السَّيِّئَةَ الحَسَنَةَ تَمْحُهَا، وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ.',
      isnad: 'عَنْ أَبِي ذَرٍّ جُنْدُبِ بْنِ جُنَادَةَ، وَأَبِي عَبْدِ الرَّحْمَنِ مُعَاذِ بْنِ جَبَلٍ رَضِيَ اللَّهُ عَنْهُمَا، عَنْ رَسُولِ اللَّهِ ﷺ قَالَ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_18',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام الترمذي والنووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه الترمذي وقال: حديث حسن، وفي بعض النسخ: حسن صحيح.',
        ),
      ],
    ));

    // الحديث 19: احفظ الله يحفظك
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_19',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 19,
      chapterName: 'باب وصية ابن عباس في التوكل واليقين وحفظ حدود الله',
      primaryNumber: 19,
      internationalNumber: 2516,
      arabicMatn: 'يَا غُلاَمُ إِنِّي أُعَلِّمُكَ كَلِمَاتٍ: احْفَظِ اللَّهَ يَحْفَظْكَ، احْفَظِ اللَّهَ تَجِدْهُ تُجَاهَكَ، إِذَا سَأَلْتَ فَاسْأَلِ اللَّهَ، وَإِذَا اسْتَعَنْتَ فَاسْتَعِنْ بِاللَّهِ، وَاعْلَمْ أَنَّ الأُمَّةَ لَوِ اجْتَمَعَتْ عَلَى أَنْ يَنْفَعُوكَ بِشَيْءٍ لَمْ يَنْفَعُوكَ إِلاَّ بِشَيْءٍ قَدْ كَتَبَهُ اللَّهُ لَكَ، وَلَوِ اجْتَمَعُوا عَلَى أَنْ يَضُرُّوكَ بِشَيْءٍ لَمْ يَضُرُّوكَ إِلاَّ بِشَيْءٍ قَدْ كَتَبَهُ اللَّهُ عَلَيْكَ، رُفِعَتِ الأَقْلاَمُ وَجَفَّتِ الصُّحُفُ.',
      isnad: 'عَنْ أَبِي العَبَّاسِ عَبْدِ اللَّهِ بْنِ عَبَّاسٍ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: كُنْتُ خَلْفَ النَّبِيِّ ﷺ يَوْماً فَقَالَ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_19',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'رواه الترمذي وقال: حديث حسن صحيح.',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_nawawi_19',
          scholarId: 'ibn_rajab',
          scholarName: 'ابن رجب الحنبلي',
          quote: 'هذا الحديث يشتمل على وصايا عظيمة وقواعد كلية من أهم أمور الدين، حتى قال بعض العلماء: تدبرت هذا الحديث فأدهشني وكدت أطيش.',
          sourceId: srcTirmidhi.sourceId,
          pageReference: 'جامع العلوم والحكم ج 1 ص 459',
        ),
      ],
    ));

    // الحديث 20: إذا لم تستح فاصنع ما شئت
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_20',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 20,
      chapterName: 'باب الحياء وأنه خصلة من خصال النبوة الأولى',
      primaryNumber: 20,
      internationalNumber: 3484,
      arabicMatn: 'إِنَّ مِمَّا أَدْرَكَ النَّاسُ مِنْ كَلاَمِ النُّبُوَّةِ الأُولَى: إِذَا لَمْ تَسْتَحِ فَاصْنَعْ مَا شِئْتَ.',
      isnad: 'عَنْ أَبِي مَسْعُودٍ عُقْبَةَ بْنِ عَمْرٍو الأَنْصَارِيِّ البَدْرِيِّ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_20',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري.',
        ),
      ],
    ));

    // الحديث 21: قل آمنت بالله ثم استقم
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_21',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 21,
      chapterName: 'باب جامع الإيمان والاستقامة على شرع الله',
      primaryNumber: 21,
      internationalNumber: 38,
      arabicMatn: 'قُلْتُ: يَا رَسُولَ اللَّهِ، قُلْ لِي فِي الإِسْلاَمِ قَوْلاً لاَ أَسْأَلُ عَنْهُ أَحَداً غَيْرَكَ. قَالَ: «قُلْ: آمَنْتُ بِاللَّهِ، ثُمَّ اسْتَقِمْ».',
      isnad: 'عَنْ أَبِي عَمْرٍو - وَقِيلَ أَبِي عَمْرَةَ - سُفْيَانَ بْنِ عَبْدِ اللَّهِ الثَّقَفِيِّ رَضِيَ اللَّهُ عَنْهُ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_21',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم في صحيحه.',
        ),
      ],
    ));

    return list;
  }
}
