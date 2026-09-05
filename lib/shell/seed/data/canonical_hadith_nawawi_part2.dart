import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';
import '../../../modules/knowledge/domain/scholarly_attribution.dart';
import '../../../modules/knowledge/domain/source_record.dart';

/// الأربعين النووية في مباني الإسلام وقواعد الأحكام — الجزء الثاني (الأحاديث 22 إلى 42)
/// متون محققة ومشكولة بالكامل مع الأسانيد والأحكام والشروح المعتمدة (§7..§12).
class CanonicalHadithNawawiPart2 {
  static List<HadithEntity> buildHadiths({
    required SourceRecord srcBukhari,
    required SourceRecord srcMuslim,
    required SourceRecord srcAbuDawud,
    required SourceRecord srcTirmidhi,
    required SourceRecord srcNasai,
    required SourceRecord srcIbnMajah,
  }) {
    final list = <HadithEntity>[];

    // الحديث 22: الاقتصار على الفرائض ودخول الجنة
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_22',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 22,
      chapterName: 'باب دخول الجنة بالفرائض واجتناب المحرمات',
      primaryNumber: 22,
      internationalNumber: 15,
      arabicMatn: 'أَنَّ رَجُلاً سَأَلَ رَسُولَ اللَّهِ ﷺ فَقَالَ: أَرَأَيْتَ إِذَا صَلَّيْتُ المَكْتُوبَاتِ، وَصُمْتُ رَمَضَانَ، وَأَحْلَلْتُ الحَلاَلَ، وَحَرَّمْتُ الحَرَامَ، وَلَمْ أَزِدْ عَلَى ذَلِكَ شَيْئاً، أَأَدْخُلُ الجَنَّةَ؟ قَالَ: «نَعَمْ».',
      isnad: 'عَنْ أَبِي عَبْدِ اللَّهِ جَابِرِ بْنِ عَبْدِ اللَّهِ الأَنْصَارِيِّ رَضِيَ اللَّهُ عَنْهُمَا...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_22',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم.',
        ),
      ],
    ));

    // الحديث 23: الطهور شطر الإيمان
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_23',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 23,
      chapterName: 'باب فضل الطهارة والذكر والصلاة والصدقة والقرآن',
      primaryNumber: 23,
      internationalNumber: 223,
      arabicMatn: 'الطُّهُورُ شَطْرُ الإِيمَانِ، وَالحَمْدُ لِلَّهِ تَمْلأُ المِيزَانَ، وَسُبْحَانَ اللَّهِ وَالحَمْدُ لِلَّهِ تَمْلآنِ - أَوْ تَمْلأُ - مَا بَيْنَ السَّمَاءِ وَالأَرْضِ، وَالصَّلاَةُ نُورٌ، وَالصَّدَقَةُ بُرْهَانٌ، وَالصَّبْرُ ضِيَاءٌ، وَالقُرْآنُ حُجَّةٌ لَكَ أَوْ عَلَيْكَ، كُلُّ النَّاسِ يَغْدُو فَبَائِعٌ نَفْسَهُ فَمُعْتِقُهَا أَوْ مُوبِقُهَا.',
      isnad: 'عَنْ أَبِي مَالِكٍ الحَارِثِ بْنِ عَاصِمٍ الأَشْعَرِيِّ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_23',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم في صحيحه.',
        ),
      ],
    ));

    // الحديث 24: حديث قدسي: يا عبادي إني حرمت الظلم على نفسي
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_24',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 24,
      chapterName: 'باب تحريم الظلم وسعة فضل الله وغناه عن خلقه وحاجة العباد إليه',
      primaryNumber: 24,
      internationalNumber: 2577,
      arabicMatn: 'يَا عِبَادِي إِنِّي حَرَّمْتُ الظُّلْمَ عَلَى نَفْسِي وَجَعَلْتُهُ بَيْنَكُمْ مُحَرَّماً فَلاَ تَظَالَمُوا، يَا عِبَادِي كُلُّكُمْ ضَالٌّ إِلاَّ مَنْ هَدَيْتُهُ فَاسْتَهْدُونِي أَهْدِكُمْ، يَا عِبَادِي كُلُّكُمْ جَائِعٌ إِلاَّ مَنْ أَطْعَمْتُهُ فَاسْتَطْعِمُونِي أُطْعِمْكُمْ، يَا عِبَادِي كُلُّكُمْ عَارٍ إِلاَّ مَنْ كَسَوْتُهُ فَاسْتَكْسُونِي أَكْسُكُمْ، يَا عِبَادِي إِنَّكُمْ تُخْطِئُونَ بِاللَّيْلِ وَالنَّهَارِ وَأَنَا أَغْفِرُ الذُّنُوبَ جَمِيعاً فَاسْتَغْفِرُونِي أَغْفِرْ لَكُمْ...',
      isnad: 'عَنْ أَبِي ذَرٍّ الغِفَارِيِّ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ فِيمَا يَرْوِيهِ عَنْ رَبِّهِ تَبَارَكَ وَتَعَالَى...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_24',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
          context: 'حديث قدسي جليل رواه مسلم.',
        ),
      ],
    ));

    // الحديث 25: ذهب أهل الدثور بالأجور
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_25',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 25,
      chapterName: 'باب فضل التسبيح والتحميد وأن في كل باب من المعروف صدقة',
      primaryNumber: 25,
      internationalNumber: 1006,
      arabicMatn: 'أَنَّ نَاساً مِنْ أَصْحَابِ رَسُولِ اللَّهِ ﷺ قَالُوا لِلنَّبِيِّ ﷺ: يَا رَسُولَ اللَّهِ، ذَهَبَ أَهْلُ الدُّثُورِ بِالأُجُورِ، يُصَلُّونَ كَمَا نُصَلِّي، وَيَصُومُونَ كَمَا نَصُومُ، وَيَتَصَدَّقُونَ بِفُضُولِ أَمْوَالِهِمْ، قَالَ: «أَوَلَيْسَ قَدْ جَعَلَ اللَّهُ لَكُمْ مَا تَصَّدَّقُونَ؟ إِنَّ بِكُلِّ تَسْبِيحَةٍ صَدَقَةً، وَكُلِّ تَكْبِيرَةٍ صَدَقَةً، وَكُلِّ تَحْمِيدَةٍ صَدَقَةً، وَكُلِّ تَهْلِيلَةٍ صَدَقَةً، وَأَمْرٌ بِالمَعْرُوفِ صَدَقَةٌ، وَنَهْيٌ عَنْ مُنْكَرٍ صَدَقَةٌ، وَفِي بُضْعِ أَحَدِكُمْ صَدَقَةٌ».',
      isnad: 'عَنْ أَبِي ذَرٍّ رَضِيَ اللَّهُ عَنْهُ أَيْضاً...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_25',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم.',
        ),
      ],
    ));

    // الحديث 26: كل سلامى من الناس عليه صدقة
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_26',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 26,
      chapterName: 'باب صدقة مفاصل البدن والعدل وإعانة الضعيف والكلمة الطيبة',
      primaryNumber: 26,
      internationalNumber: 2989,
      arabicMatn: 'كُلُّ سُلاَمَى مِنَ النَّاسِ عَلَيْهِ صَدَقَةٌ، كُلَّ يَوْمٍ تَطْلُعُ فِيهِ الشَّمْسُ: تَعْدِلُ بَيْنَ الاِثْنَيْنِ صَدَقَةٌ، وَتُعِينُ الرَّجُلَ فِي دَابَّتِهِ فَتَحْمِلُهُ عَلَيْهَا أَوْ تَرْفَعُ لَهُ عَلَيْهَا مَتَاعَهُ صَدَقَةٌ، وَالكَلِمَةُ الطَّيِّبَةُ صَدَقَةٌ، وَبِكُلِّ خُطْوَةٍ تَمْشِيهَا إِلَى الصَّلاَةِ صَدَقَةٌ، وَتُمِيطُ الأَذَى عَنِ الطَّرِيقِ صَدَقَةٌ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_26',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم.',
        ),
      ],
    ));

    // الحديث 27: البر حسن الخلق والإثم ما حاك في صدرك
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_27',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 27,
      chapterName: 'باب علامة البر والإثم واستفتاء القلب السليم',
      primaryNumber: 27,
      internationalNumber: 2553,
      arabicMatn: 'البِرُّ حُسْنُ الخُلُقِ، وَالإِثْمُ مَا حَاكَ فِي نَفْسِكَ وَكَرِهْتَ أَنْ يَطَّلِعَ عَلَيْهِ النَّاسُ. وفي حديث وابصة: «اسْتَفْتِ قَلْبَكَ، البِرُّ مَا اطْمَأَنَّتْ إِلَيْهِ النَّفْسُ وَاطْمَأَنَّ إِلَيْهِ القَلْبُ، وَالإِثْمُ مَا حَاكَ فِي النَّفْسِ وَتَرَدَّدَ فِي الصَّدْرِ وَإِنْ أَفْتَاكَ النَّاسُ وَأَفْتَوْكَ».',
      isnad: 'عَنِ النَّوَّاسِ بْنِ سَمْعَانَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_27',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه مسلم وأحمد والدارمي.',
        ),
      ],
    ));

    // الحديث 28: وعظنا رسول الله موعظة وجلت منها القلوب
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_28',
      collectionId: srcAbuDawud.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 28,
      chapterName: 'باب لزوم السنة والتحذير من محدثات الأمور عند الاختلاف',
      primaryNumber: 28,
      internationalNumber: 4607,
      arabicMatn: 'وَعَظَنَا رَسُولُ اللَّهِ ﷺ مَوْعِظَةً بَلِيغَةً وَجِلَتْ مِنْهَا القُلُوبُ، وَذَرَفَتْ مِنْهَا العُيُونُ، فَقُلْنَا: يَا رَسُولَ اللَّهِ، كَأَنَّهَا مَوْعِظَةُ مُوَدِّعٍ فَأَوْصِنَا، قَالَ: «أُوصِيكُمْ بِتَقْوَى اللَّهِ، وَالسَّمْعِ وَالطَّاعَةِ وَإِنْ تَأَمَّرَ عَلَيْكُمْ عَبْدٌ، فَإِنَّهُ مَنْ يَعِشْ مِنْكُمْ بَعْدِي فَسَيَرَى اخْتِلاَفاً كَثِيراً، فَعَلَيْكُمْ بِسُنَّتِي وَسُنَّةِ الخُلَفَاءِ الرَّاشِدِينَ المَهْدِيِّينَ، عَضُّوا عَلَيْهَا بِالنَّوَاجِذِ، وَإِيَّاكُمْ وَمُحْدَثَاتِ الأُمُورِ، فَإِنَّ كُلَّ بِدْعَةٍ ضَلاَلَةٌ».',
      isnad: 'عَنْ أَبِي نَجِيحٍ العِرْبَاضِ بْنِ سَارِيَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ...',
      sourceId: srcAbuDawud.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_28',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي والنووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه أبو داود والترمذي وقال: حديث حسن صحيح.',
        ),
      ],
    ));

    // الحديث 29: أبواب الخير وحصائد اللسان
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_29',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 29,
      chapterName: 'باب رأس الأمر الإسلام وعموده الصلاة وكف اللسان',
      primaryNumber: 29,
      internationalNumber: 2616,
      arabicMatn: 'قُلْتُ: يَا رَسُولَ اللَّهِ، أَخْبِرْنِي بِعَمَلٍ يُدْخِلُنِي الجَنَّةَ وَيُبَاعِدُنِي عَنِ النَّارِ... فَقَالَ: «أَلاَ أُخْبِرُكَ بِمَلاَكِ ذَلِكَ كُلِّهِ؟» قُلْتُ: بَلَى يَا نَبِيَّ اللَّهِ، فَأَخَذَ بِلِسَانِهِ وَقَالَ: «كُفَّ عَلَيْكَ هَذَا». قُلْتُ: يَا نَبِيَّ اللَّهِ، وَإِنَّا لَمُؤَاخَذُونَ بِمَا نَتَكَلَّمُ بِهِ؟ فَقَالَ: «ثَكِلَتْكَ أُمُّكَ يَا مُعَاذُ، وَهَلْ يَكُبُّ النَّاسَ فِي النَّارِ عَلَى وُجُوهِهِمْ - أَوْ عَلَى مَنَاخِرِهِمْ - إِلاَّ حَصَائِدُ أَلْسِنَتِهِمْ؟!».',
      isnad: 'عَنْ مُعَاذِ بْنِ جَبَلٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: كُنْتُ مَعَ النَّبِيِّ ﷺ فِي سَفَرٍ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_29',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'رواه الترمذي وقال: حديث حسن صحيح.',
        ),
      ],
    ));

    // الحديث 30: إن الله فرض فرائض فلا تضيعوها
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_30',
      collectionId: srcNasai.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 30,
      chapterName: 'باب حفظ الفرائض والوقوف عند الحدود وسكوت الشارع رحمة',
      primaryNumber: 30,
      internationalNumber: 30,
      arabicMatn: 'إِنَّ اللَّهَ تَعَالَى فَرَضَ فَرَائِضَ فَلاَ تُضَيِّعُوهَا، وَحَدَّ حُدُوداً فَلاَ تَعْتَدُوهَا، وَحَرَّمَ أَشْيَاءَ فَلاَ تَنْتَهِكُوهَا، وَسَكَتَ عَنْ أَشْيَاءَ رَحْمَةً لَكُمْ غَيْرَ نِسْيَانٍ فَلاَ تَبْحَثُوا عَنْهَا.',
      isnad: 'عَنْ أَبِي ثَعْلَبَةَ الخُشَنِيِّ جُرْثُومِ بْنِ نَاشِرٍ رَضِيَ اللَّهُ عَنْهُ، عَنْ رَسُولِ اللَّهِ ﷺ قَالَ...',
      sourceId: srcNasai.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_30',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'حديث حسن رواه الدارقطني وغيره.',
        ),
      ],
    ));

    // الحديث 31: ازهد في الدنيا يحبك الله
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_31',
      collectionId: srcIbnMajah.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 31,
      chapterName: 'باب حقيقة الزهد وثمرته في محبة الله ومحبة الناس',
      primaryNumber: 31,
      internationalNumber: 4102,
      arabicMatn: 'جَاءَ رَجُلٌ إِلَى النَّبِيِّ ﷺ فَقَالَ: يَا رَسُولَ اللَّهِ، دُلَّنِي عَلَى عَمَلٍ إِذَا عَمِلْتُهُ أَحَبَّنِي اللَّهُ وَأَحَبَّنِي النَّاسُ. فَقَالَ: «ازْهَدْ فِي الدُّنْيَا يُحِبَّكَ اللَّهُ، وَازْهَدْ فِيمَا فِي أَيْدِي النَّاسِ يُحِبَّكَ النَّاسُ».',
      isnad: 'عَنْ أَبِي العَبَّاسِ سَهْلِ بْنِ سَعْدٍ السَّاعِدِيِّ رَضِيَ اللَّهُ عَنْهُ قَالَ...',
      sourceId: srcIbnMajah.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_31',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'حديث حسن رواه ابن ماجه وغيره بأسانيد حسنة.',
        ),
      ],
    ));

    // الحديث 32: لا ضرر ولا ضرار
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_32',
      collectionId: srcIbnMajah.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 32,
      chapterName: 'باب القاعدة الفقهية الكبرى بنفي الضرر والإضرار',
      primaryNumber: 32,
      internationalNumber: 2340,
      arabicMatn: 'لاَ ضَرَرَ وَلاَ ضِرَارَ.',
      isnad: 'عَنْ أَبِي سَعِيدٍ سَعْدِ بْنِ مَالِكِ بْنِ سِنَانٍ الخُدْرِيِّ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcIbnMajah.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_32',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'حديث حسن رواه ابن ماجه والدارقطني ومسنداً ومالك في الموطأ مرسلاً، وله طرق يقوي بعضها بعضاً.',
        ),
      ],
    ));

    // الحديث 33: البينة على المدعي واليمين على من أنكر
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_33',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 33,
      chapterName: 'باب قاعدة القضاء والأقضية في الدعاوى والبينات',
      primaryNumber: 33,
      internationalNumber: 4552,
      arabicMatn: 'لَوْ يُعْطَى النَّاسُ بِدَعْوَاهُمْ، لاَدَّعَى رِجَالٌ أَمْوَالَ قَوْمٍ وَدِمَاءَهُمْ، لَكِنِ البَيِّنَةُ عَلَى المُدَّعِي، وَاليَمِينُ عَلَى مَنْ أَنْكَرَ.',
      isnad: 'عَنِ ابْنِ عَبَّاسٍ رَضِيَ اللَّهُ عَنْهُمَا، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_33',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'حديث حسن رواه البيهقي وغيره هكذا، وبعضه في الصحيحين.',
        ),
      ],
    ));

    // الحديث 34: من رأى منكم منكرا فليغيره
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_34',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 34,
      chapterName: 'باب مراتب الأمر بالمعروف والنهي عن المنكر ودرجات التغيير',
      primaryNumber: 34,
      internationalNumber: 49,
      arabicMatn: 'مَنْ رَأَى مِنْكُمْ مُنْكَراً فَلْيُغَيِّرْهُ بِيَدِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِلِسَانِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِقَلْبِهِ، وَذَلِكَ أَضْعَفُ الإِيمَانِ.',
      isnad: 'عَنْ أَبِي سَعِيدٍ الخُدْرِيِّ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_34',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم والنووي',
          sourceBook: 'صحيح مسلم',
          context: 'رواه مسلم.',
        ),
      ],
    ));

    // الحديث 35: لا تحاسدوا ولا تناجشوا وكونوا عباد الله إخوانا
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_35',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 35,
      chapterName: 'باب حقوق الأخوة الإسلامية وحرمة دم المسلم وماله وعرضه',
      primaryNumber: 35,
      internationalNumber: 2564,
      arabicMatn: 'لاَ تَحَاسَدُوا، وَلاَ تَنَاجَشُوا، وَلاَ تَبَاغَضُوا، وَلاَ تَدَابَرُوا، وَلاَ يَبِعْ بَعْضُكُمْ عَلَى بَيْعِ بَعْضٍ، وَكُونُوا عِبَادَ اللَّهِ إِخْوَاناً، المُسْلِمُ أَخُو المُسْلِمِ: لاَ يَظْلِمُهُ، وَلاَ يَخْذُلُهُ، وَلاَ يَحْقِرُهُ، التَّقْوَى هَاهُنَا - وَيُشِيرُ إِلَى صَدْرِهِ ثَلاَثَ مَرَّاتٍ - بِحَسْبِ امْرِئٍ مِنَ الشَّرِّ أَنْ يَحْقِرَ أَخَاهُ المُسْلِمَ، كُلُّ المُسْلِمِ عَلَى المُسْلِمِ حَرَامٌ: دَمُهُ، وَمَالُهُ، وَعِرْضُهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_35',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
          context: 'رواه مسلم.',
        ),
      ],
    ));

    // الحديث 36: من نفس عن مؤمن كربة
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_36',
      collectionId: srcMuslim.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 36,
      chapterName: 'باب فضل تنفيس الكرب وتيسير المعسر وستر المسلم ومجالس العلم',
      primaryNumber: 36,
      internationalNumber: 2699,
      arabicMatn: 'مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا نَفَّسَ اللَّهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ القِيَامَةِ، وَمَنْ يَسَّرَ عَلَى مُعْسِرٍ يَسَّرَ اللَّهُ عَلَيْهِ فِي الدُّنْيَا وَالآخِرَةِ، وَمَنْ سَتَرَ مُسْلِماً سَتَرَهُ اللَّهُ فِي الدُّنْيَا وَالآخِرَةِ، وَاللَّهُ فِي عَوْنِ العَبْدِ مَا كَانَ العَبْدُ فِي عَوْنِ أَخِيهِ، وَمَنْ سَلَكَ طَرِيقاً يَلْتَمِسُ فِيهِ عِلْماً سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقاً إِلَى الجَنَّةِ، وَمَا اجْتَمَعَ قَوْمٌ فِي بَيْتٍ مِنْ بُيُوتِ اللَّهِ يَتْلُونَ كِتَابَ اللَّهِ وَيَتَدَارَسُونَهُ بَيْنَهُمْ إِلاَّ نَزَلَتْ عَلَيْهِمُ السَّكِينَةُ، وَغَشِيَتْهُمُ الرَّحْمَةُ، وَحَفَّتْهُمُ المَلاَئِكَةُ، وَذَكَرَهُمُ اللَّهُ فِيمَنْ عِنْدَهُ، وَمَنْ بَطَّأَ بِهِ عَمَلُهُ لَمْ يُسْرِعْ بِهِ نَسَبُهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcMuslim.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_36',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مسلم',
          sourceBook: 'صحيح مسلم',
          context: 'رواه مسلم بهذا اللفظ.',
        ),
      ],
    ));

    // الحديث 37: إن الله كتب الحسنات والسيئات
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_37',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 37,
      chapterName: 'باب مضاعفة الحسنات ومحو السيئات وسعة فضل الله',
      primaryNumber: 37,
      internationalNumber: 6491,
      arabicMatn: 'إِنَّ اللَّهَ كَتَبَ الحَسَنَاتِ وَالسَّيِّئَاتِ ثُمَّ بَيَّنَ ذَلِكَ: فَمَنْ هَمَّ بِحَسَنَةٍ فَلَمْ يَعْمَلْهَا كَتَبَهَا اللَّهُ عِنْدَهُ حَسَنَةً كَامِلَةً، وَإِنْ هَمَّ بِهَا فَعَمِلَهَا كَتَبَهَا اللَّهُ عِنْدَهُ عَشْرَ حَسَنَاتٍ إِلَى سَبْعِمِائَةِ ضِعْفٍ إِلَى أَضْعَافٍ كَثِيرَةٍ، وَإِنْ هَمَّ بِسَيِّئَةٍ فَلَمْ يَعْمَلْهَا كَتَبَهَا اللَّهُ عِنْدَهُ حَسَنَةً كَامِلَةً، وَإِنْ هَمَّ بِهَا فَعَمِلَهَا كَتَبَهَا اللَّهُ سَيِّئَةً وَاحِدَةً.',
      isnad: 'عَنِ ابْنِ عَبَّاسٍ رَضِيَ اللَّهُ عَنْهُمَا، عَنْ رَسُولِ اللَّهِ ﷺ فِيمَا يَرْوِيهِ عَنْ رَبِّهِ تَبَارَكَ وَتَعَالَى...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_37',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'رواه البخاري ومسلم في صحيحيهما بهذه الحروف.',
        ),
      ],
    ));

    // الحديث 38: من عادى لي وليا فقد آذنته بالحرب
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_38',
      collectionId: srcBukhari.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 38,
      chapterName: 'باب التقرب إلى الله بالفرائض والنوافل ومحبة الله لعبده',
      primaryNumber: 38,
      internationalNumber: 6502,
      arabicMatn: 'إِنَّ اللَّهَ تَعَالَى قَالَ: مَنْ عَادَى لِي وَلِيّاً فَقَدْ آذَنْتُهُ بِالحَرْبِ، وَمَا تَقَرَّبَ إِلَيَّ عَبْدِي بِشَيْءٍ أَحَبَّ إِلَيَّ مِمَّا افْتَرَضْتُ عَلَيْهِ، وَلاَ يَزَالُ عَبْدِي يَتَقَرَّبُ إِلَيَّ بِالنَّوَافِلِ حَتَّى أُحِبَّهُ، فَإِذَا أَحْبَبْتُهُ كُنْتُ سَمْعَهُ الَّذِي يَسْمَعُ بِهِ، وَبَصَرَهُ الَّذِي يُبْصِرُ بِهِ، وَيَدَهُ الَّتِي يَبْطِشُ بِهَا، وَرِجْلَهُ الَّتِي يَمْشِي بِهَا، وَلَئِنْ سَأَلَنِي لأُعْطِيَنَّهُ، وَلَئِنِ اسْتَعَاذَنِي لأُعِيذَنَّهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_38',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
          context: 'رواه البخاري في كتاب الرقاق.',
        ),
      ],
    ));

    // الحديث 39: إن الله تجاوز لي عن أمتي الخطأ والنسيان
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_39',
      collectionId: srcIbnMajah.sourceId,
      bookNumber: 40,
      bookName: 'الأربعين النووية',
      chapterNumber: 39,
      chapterName: 'باب رفع الحرج والمؤاخذة عن المخطئ والناسي والمكره',
      primaryNumber: 39,
      internationalNumber: 2045,
      arabicMatn: 'إِنَّ اللَّهَ تَجَاوَزَ لِي عَنْ أُمَّتِي الخَطَأَ وَالنِّسْيَانَ وَمَا اسْتُكْرِهُوا عَلَيْهِ.',
      isnad: 'عَنِ ابْنِ عَبَّاسٍ رَضِيَ اللَّهُ عَنْهُمَا، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcIbnMajah.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_39',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'حديث حسن رواه ابن ماجه والبيهقي وغيرهما.',
        ),
      ],
    ));

    // الحديث 40: كن في الدنيا كأنك غريب أو عابر سبيل
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_40',
      collectionId: srcBukhari.sourceId,
      bookNumber: 1,
      bookName: 'الأربعين النووية',
      chapterNumber: 40,
      chapterName: 'باب قصر الأمل والمبادرة بالعمل الصالح قبل الفوت',
      primaryNumber: 40,
      internationalNumber: 6416,
      arabicMatn: 'أَخَذَ رَسُولُ اللَّهِ ﷺ بِمَنْكِبِي فَقَالَ: «كُنْ فِي الدُّنْيَا كَأَنَّكَ غَرِيبٌ أَوْ عَابِرُ سَبِيلٍ». وَكَانَ ابْنُ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا يَقُولُ: «إِذَا أَمْسَيْتَ فَلاَ تَنْتَظِرِ الصَّبَاحَ، وَإِذَا أَصْبَحْتَ فَلاَ تَنْتَظِرِ المَسَاءَ، وَخُذْ مِنْ صِحَّتِكَ لِمَرَضِكَ، وَمِنْ حَيَاتِكَ لِمَوْتِكَ».',
      isnad: 'عَنِ ابْنِ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا قَالَ...',
      sourceId: srcBukhari.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_40',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام البخاري',
          sourceBook: 'صحيح البخاري',
          context: 'رواه البخاري.',
        ),
      ],
    ));

    // الحديث 41: لا يؤمن أحدكم حتى يكون هواه تبعا لما جئت به
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_41',
      collectionId: srcNasai.sourceId,
      bookNumber: 1,
      bookName: 'الأربعين النووية',
      chapterNumber: 41,
      chapterName: 'باب تحكيم الشريعة وانقياد النفس لهدي النبوة',
      primaryNumber: 41,
      internationalNumber: 41,
      arabicMatn: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يَكُونَ هَوَاهُ تَبَعاً لِمَا جِئْتُ بِهِ.',
      isnad: 'عَنْ أَبِي مُحَمَّدٍ عَبْدِ اللَّهِ بْنِ عَمْرِو بْنِ العَاصِ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcNasai.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_41',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام النووي',
          sourceBook: 'الأربعين النووية',
          context: 'حديث حسن صحيح، رويناه في كتاب الحجة بإسناد صحيح.',
        ),
      ],
    ));

    // الحديث 42: يا ابن آدم إنك ما دعوتني ورجوتني غفرت لك
    list.add(HadithEntity.create(
      hadithId: 'hadith_nawawi_42',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 1,
      bookName: 'الأربعين النووية',
      chapterNumber: 42,
      chapterName: 'باب سعة مغفرة الله وفضل التوحيد والدعاء بالرجاء',
      primaryNumber: 42,
      internationalNumber: 3540,
      arabicMatn: 'قَالَ اللَّهُ تَعَالَى: يَا ابْنَ آدَمَ، إِنَّكَ مَا دَعَوْتَنِي وَرَجَوْتَنِي غَفَرْتُ لَكَ عَلَى مَا كَانَ فِيكَ وَلاَ أُبَالِي، يَا ابْنَ آدَمَ، لَوْ بَلَغَتْ ذُنُوبُكَ عَنَانَ السَّمَاءِ ثُمَّ اسْتَغْفَرْتَنِي غَفَرْتُ لَكَ وَلاَ أُبَالِي، يَا ابْنَ آدَمَ، إِنَّكَ لَوْ أَتَيْتَنِي بِقُرَابِ الأَرْضِ خَطَايَا ثُمَّ لَقِيتَنِي لاَ تُشْرِكُ بِي شَيْئاً لأَتَيْتُكَ بِقُرَابِهَا مَغْفِرَةً.',
      isnad: 'عَنْ أَنَسِ بْنِ مَالِكٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ ﷺ يَقُولُ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_nawawi_42',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'رواه الترمذي وقال: حديث حسن صحيح.',
        ),
      ],
      commentaries: [
        ScholarlyAttribution.create(
          attributionId: 'com_nawawi_42',
          scholarId: 'ibn_rajab',
          scholarName: 'ابن رجب الحنبلي',
          quote: 'هذا الحديث يجمع أسباب المغفرة الثلاثة: الدعاء مع الرجاء، والاستغفار، والتوحيد الخالص وهو أعظمها.',
          sourceId: srcTirmidhi.sourceId,
          pageReference: 'جامع العلوم والحكم ج 2 ص 395',
        ),
      ],
    ));

    return list;
  }
}
