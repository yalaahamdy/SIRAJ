import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';
import '../../../modules/knowledge/domain/source_record.dart';

/// Authentic Canonical Hadiths from the Sunan & Masanid collections (§7..§12, M05.1).
/// Covers: Abu Dawud, At-Tirmidhi, An-Nasa'i, Ibn Majah, Muwatta Malik, and Musnad Ahmad.
class CanonicalHadithSunan {
  static List<HadithEntity> buildHadiths({
    required SourceRecord srcAbuDawud,
    required SourceRecord srcTirmidhi,
    required SourceRecord srcNasai,
    required SourceRecord srcIbnMajah,
    required SourceRecord srcMuwatta,
    required SourceRecord srcMusnad,
  }) {
    final list = <HadithEntity>[];

    // =========================================================================
    // 1. سنن أبي داود (Abu Dawud)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_abudawud_497',
      collectionId: srcAbuDawud.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الصلاة',
      chapterNumber: 54,
      chapterName: 'باب في الأذان والإقامة وكيفية الصلاة',
      primaryNumber: 497,
      internationalNumber: 497,
      arabicMatn: 'صَلُّوا كَمَا رَأَيْتُمُونِي أُصَلِّي، فَإِذَا حَضَرَتِ الصَّلاَةُ فَلْيُؤَذِّنْ لَكُمْ أَحَدُكُمْ، وَلْيَؤُمَّكُمْ أَكْبَرُكُمْ.',
      isnad: 'عَنْ مَالِكِ بْنِ الحُوَيْرِثِ رَضِيَ اللَّهُ عَنْهُ، أَنَّ النَّبِيَّ ﷺ قَالَ...',
      sourceId: srcAbuDawud.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_ad497_1',
          grade: HadithGrade.sahih,
          scholarName: 'أبو داود والألباني',
          sourceBook: 'سنن أبي داود',
          context: 'صحيح، أصله في صحيح البخاري',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_abudawud_603',
      collectionId: srcAbuDawud.sourceId,
      bookNumber: 2,
      bookName: 'كتاب الصلاة',
      chapterNumber: 68,
      chapterName: 'باب في الإمام يصلي من قعود',
      primaryNumber: 603,
      internationalNumber: 603,
      arabicMatn: 'إِنَّمَا جُعِلَ الإِمَامُ لِيُؤْتَمَّ بِهِ، فَإِذَا كَبَّرَ فَكَبِّرُوا، وَإِذَا رَكَعَ فَارْكَعُوا، وَإِذَا رَفَعَ فَارْفَعُوا، وَإِذَا قَالَ: سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ، فَقُولُوا: رَبَّنَا وَلَكَ الحَمْدُ، وَإِذَا صَلَّى قَاعِداً فَصَلُّوا قُعُوداً أَجْمَعُونَ.',
      isnad: 'عَنْ أَنَسِ بْنِ مَالِكٍ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcAbuDawud.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_ad603_1',
          grade: HadithGrade.sahih,
          scholarName: 'أبو داود',
          sourceBook: 'سنن أبي داود',
          context: 'متفق عليه أصله في الصحيحين',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_abudawud_3658',
      collectionId: srcAbuDawud.sourceId,
      bookNumber: 25,
      bookName: 'كتاب العلم',
      chapterNumber: 9,
      chapterName: 'باب في كراهية منع العلم وكتمانه',
      primaryNumber: 3658,
      internationalNumber: 3658,
      arabicMatn: 'مَنْ سُئِلَ عَنْ عِلْمٍ فَكَتَمَهُ، أَلْجَمَهُ اللَّهُ بِلِجَامٍ مِنْ نَارٍ يَوْمَ القِيَامَةِ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcAbuDawud.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_ad3658_1',
          grade: HadithGrade.hasan,
          scholarName: 'أبو داود والترمذي',
          sourceBook: 'سنن أبي داود',
          context: 'حديث حسن صحيح صححه الألباني',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_abudawud_4799',
      collectionId: srcAbuDawud.sourceId,
      bookNumber: 42,
      bookName: 'كتاب الأدب',
      chapterNumber: 7,
      chapterName: 'باب في حسن الخلق وفضله',
      primaryNumber: 4799,
      internationalNumber: 4799,
      arabicMatn: 'مَا مِنْ شَيْءٍ أَثْقَلُ فِي مِيزَانِ المُؤْمِنِ يَوْمَ القِيَامَةِ مِنْ خُلُقٍ حَسَنٍ، وَإِنَّ اللَّهَ لَيُبْغِضُ الفَاحِشَ البَذِيءَ.',
      isnad: 'عَنْ أَبِي الدَّرْدَاءِ رَضِيَ اللَّهُ عَنْهُ، أَنَّ النَّبِيَّ ﷺ قَالَ...',
      sourceId: srcAbuDawud.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_ad4799_1',
          grade: HadithGrade.sahih,
          scholarName: 'أبو داود والترمذي',
          sourceBook: 'سنن أبي داود',
        ),
      ],
    ));

    // =========================================================================
    // 2. جامع الترمذي (At-Tirmidhi)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_tirmidhi_1927',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 27,
      bookName: 'أبواب البر والصلة عن رسول الله ﷺ',
      chapterNumber: 18,
      chapterName: 'باب ما جاء في شفقة المسلم على المسلم',
      primaryNumber: 1927,
      internationalNumber: 1927,
      arabicMatn: 'المُسْلِمُ أَخُو المُسْلِمِ؛ لاَ يَظْلِمُهُ، وَلاَ يَخْذُلُهُ، التَّقْوَى هَاهُنَا - وَيُشِيرُ إِلَى صَدْرِهِ - بِحَسْبِ امْرِئٍ مِنَ الشَّرِّ أَنْ يَحْقِرَ أَخَاهُ المُسْلِمَ، كُلُّ المُسْلِمِ عَلَى المُسْلِمِ حَرَامٌ: دَمُهُ، وَمَالُهُ، وَعِرْضُهُ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_t1927_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'حديث حسن صحيح، وأصله في صحيح مسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_tirmidhi_1987',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 27,
      bookName: 'أبواب البر والصلة عن رسول الله ﷺ',
      chapterNumber: 55,
      chapterName: 'باب ما جاء في معاشرة الناس وخلق التقوى',
      primaryNumber: 1987,
      internationalNumber: 1987,
      arabicMatn: 'اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ، وَأَتْبِعِ السَّيِّئَةَ الحَسَنَةَ تَمْحُهَا، وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ.',
      isnad: 'عَنْ أَبِي ذَرٍّ وَمُعَاذِ بْنِ جَبَلٍ رَضِيَ اللَّهُ عَنْهُمَا، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_t1987_1',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'قال أبو عيسى: هذا حديث حسن صحيح',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_tirmidhi_2516',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 37,
      bookName: 'أبواب صفة القيامة والرقائق والورع',
      chapterNumber: 59,
      chapterName: 'باب منه (وصية النبي ﷺ لابن عباس)',
      primaryNumber: 2516,
      internationalNumber: 2516,
      arabicMatn: 'يَا غُلاَمُ إِنِّي أُعَلِّمُكَ كَلِمَاتٍ: احْفَظِ اللَّهَ يَحْفَظْكَ، احْفَظِ اللَّهَ تَجِدْهُ تُجَاهَكَ، إِذَا سَأَلْتَ فَاسْأَلِ اللَّهَ، وَإِذَا اسْتَعَنْتَ فَاسْتَعِنْ بِاللَّهِ، وَاعْلَمْ أَنَّ الأُمَّةَ لَوِ اجْتَمَعَتْ عَلَى أَنْ يَنْفَعُوكَ بِشَيْءٍ لَمْ يَنْفَعُوكَ إِلاَّ بِشَيْءٍ قَدْ كَتَبَهُ اللَّهُ لَكَ، وَلَوِ اجْتَمَعُوا عَلَى أَنْ يَضُرُّوكَ بِشَيْءٍ لَمْ يَضُرُّوكَ إِلاَّ بِشَيْءٍ قَدْ كَتَبَهُ اللَّهُ عَلَيْكَ، رُفِعَتِ الأَقْلاَمُ وَجَفَّتِ الصُّحُفُ.',
      isnad: 'عَنِ ابْنِ عَبَّاسٍ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: كُنْتُ خَلْفَ رَسُولِ اللَّهِ ﷺ يَوْماً فَقَالَ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_t2516_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'قال الترمذي: حديث حسن صحيح',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_tirmidhi_2616',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 38,
      bookName: 'أبواب الإيمان عن رسول الله ﷺ',
      chapterNumber: 8,
      chapterName: 'باب ما جاء في حرمة الصلاة وعمود الإسلام',
      primaryNumber: 2616,
      internationalNumber: 2616,
      arabicMatn: 'رَأْسُ الأَمْرِ الإِسْلاَمُ، وَعَمُودُهُ الصَّلاَةُ، وَذِرْوَةُ سَنَامِهِ الجِهَادُ فِي سَبِيلِ اللَّهِ.',
      isnad: 'عَنْ مُعَاذِ بْنِ جَبَلٍ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_t2616_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'حديث حسن صحيح',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_tirmidhi_2670',
      collectionId: srcTirmidhi.sourceId,
      bookNumber: 39,
      bookName: 'أبواب العلم عن رسول الله ﷺ',
      chapterNumber: 14,
      chapterName: 'باب ما جاء في الدال على الخير كفاعله',
      primaryNumber: 2670,
      internationalNumber: 2670,
      arabicMatn: 'مَنْ دَلَّ عَلَى خَيْرٍ فَلَهُ مِثْلُ أَجْرِ فَاعِلِهِ.',
      isnad: 'عَنْ أَنَسِ بْنِ مَالِكٍ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcTirmidhi.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_t2670_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام الترمذي',
          sourceBook: 'جامع الترمذي',
          context: 'صحيح، وأصله في صحيح مسلم',
        ),
      ],
    ));

    // =========================================================================
    // 3. سنن النسائي (An-Nasa'i)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_nasai_005',
      collectionId: srcNasai.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الطهارة',
      chapterNumber: 4,
      chapterName: 'باب السواك والترغيب فيه',
      primaryNumber: 5,
      internationalNumber: 5,
      arabicMatn: 'السِّوَاكُ مَطْهَرَةٌ لِلْفَمِ مَرْضَاةٌ لِلرَّبِّ.',
      isnad: 'عَنْ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcNasai.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_n005_1',
          grade: HadithGrade.sahih,
          scholarName: 'النسائي وابن خزيمة',
          sourceBook: 'سنن النسائي',
          context: 'إسناده صحيح على شرط البخاري ومسلم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_nasai_010',
      collectionId: srcNasai.sourceId,
      bookNumber: 1,
      bookName: 'كتاب الطهارة',
      chapterNumber: 9,
      chapterName: 'باب خصال الفطرة',
      primaryNumber: 10,
      internationalNumber: 10,
      arabicMatn: 'خَمْسٌ مِنَ الفِطْرَةِ: الخِتَانُ، وَالاسْتِحْدَادُ، وَتَقْلِيمُ الأَظْفَارِ، وَنَتْفُ الإِبْطِ، وَقَصُّ الشَّارِبِ.',
      isnad: 'عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcNasai.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_n010_1',
          grade: HadithGrade.sahih,
          scholarName: 'النسائي',
          sourceBook: 'سنن النسائي',
          context: 'متفق عليه في الصحيحين',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_nasai_4016',
      collectionId: srcNasai.sourceId,
      bookNumber: 37,
      bookName: 'كتاب تحريم الدم',
      chapterNumber: 5,
      chapterName: 'باب ما يحرم به دم المسلم',
      primaryNumber: 4016,
      internationalNumber: 4016,
      arabicMatn: 'لاَ يَحِلُّ دَمُ امْرِئٍ مُسْلِمٍ يَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنِّي رَسُولُ اللَّهِ إِلاَّ بِإِحْدَى ثَلاَثٍ: الثَّيِّبُ الزَّانِي، وَالنَّفْسُ بِالنَّفْسِ، وَالتَّارِكُ لِدِينِهِ المُفَارِقُ لِلْجَمَاعَةِ.',
      isnad: 'عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ ﷺ قَالَ...',
      sourceId: srcNasai.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_n4016_1',
          grade: HadithGrade.sahih,
          scholarName: 'النسائي',
          sourceBook: 'سنن النسائي',
          context: 'متفق عليه في الصحيحين',
        ),
      ],
    ));

    // =========================================================================
    // 4. سنن ابن ماجه (Ibn Majah)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_ibnmajah_012',
      collectionId: srcIbnMajah.sourceId,
      bookNumber: 0,
      bookName: 'المقدمة',
      chapterNumber: 6,
      chapterName: 'باب اتباع سنة رسول الله ﷺ والخلفاء الراشدين',
      primaryNumber: 42,
      internationalNumber: 42,
      arabicMatn: 'عَلَيْكُمْ بِسُنَّتِي وَسُنَّةِ الخُلَفَاءِ الرَّاشِدِينَ المَهْدِيِّينَ مِنْ بَعْدِي، عَضُّوا عَلَيْهَا بِالنَّوَاجِذِ، وَإِيَّاكُمْ وَمُحْدَثَاتِ الأُمُورِ، فَإِنَّ كُلَّ مُحْدَثَةٍ بِدْعَةٌ، وَكُلَّ بِدْعَةٍ ضَلاَلَةٌ.',
      isnad: 'عَنِ العِرْبَاضِ بْنِ سَارِيَةَ رَضِيَ اللَّهُ عَنْهُ، قَالَ: وَعَظَنَا رَسُولُ اللَّهِ ﷺ مَوْعِظَةً بَلِيغَةً...',
      sourceId: srcIbnMajah.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_im012_1',
          grade: HadithGrade.sahih,
          scholarName: 'ابن ماجه والألباني',
          sourceBook: 'سنن ابن ماجه',
          context: 'حديث صحيح مشهور',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_ibnmajah_224',
      collectionId: srcIbnMajah.sourceId,
      bookNumber: 0,
      bookName: 'المقدمة',
      chapterNumber: 17,
      chapterName: 'باب فضل العلماء والحث على طلب العلم',
      primaryNumber: 224,
      internationalNumber: 224,
      arabicMatn: 'طَلَبُ العِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ.',
      isnad: 'عَنْ أَنَسِ بْنِ مَالِكٍ رَضِيَ اللَّهُ عَنْهُ، قَالَ: قَالَ رَسُولُ اللَّهِ ﷺ...',
      sourceId: srcIbnMajah.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_im224_1',
          grade: HadithGrade.hasan,
          scholarName: 'ابن ماجه والمزي والألباني',
          sourceBook: 'سنن ابن ماجه',
          context: 'حديث حسن بشواهده وطرقه المتعددة',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_ibnmajah_2340',
      collectionId: srcIbnMajah.sourceId,
      bookNumber: 13,
      bookName: 'كتاب الأحكام',
      chapterNumber: 17,
      chapterName: 'باب من بنى في حقه ما يضر بجاره',
      primaryNumber: 2340,
      internationalNumber: 2340,
      arabicMatn: 'لاَ ضَرَرَ وَلاَ ضِرَارَ.',
      isnad: 'عَنْ عُبَادَةَ بْنِ الصَّامِتِ رَضِيَ اللَّهُ عَنْهُ، أَنَّ رَسُولَ اللَّهِ ﷺ قَضَى أَنْ...',
      sourceId: srcIbnMajah.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_im2340_1',
          grade: HadithGrade.hasan,
          scholarName: 'ابن ماجه والنووي',
          sourceBook: 'سنن ابن ماجه',
          context: 'قاعدة فقهية كلية مجمع عليها، حسنه النووي وابن الصلاح',
        ),
      ],
    ));

    // =========================================================================
    // 5. موطأ الإمام مالك (Muwatta Malik)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_muwatta_1594',
      collectionId: srcMuwatta.sourceId,
      bookNumber: 46,
      bookName: 'كتاب القدر',
      chapterNumber: 1,
      chapterName: 'باب النهي عن القول في القدر والتمسك بالاعتصام',
      primaryNumber: 1594,
      internationalNumber: 1594,
      arabicMatn: 'تَرَكْتُ فِيكُمْ أَمْرَيْنِ لَنْ تَضِلُّوا مَا تَمَسَّكْتُمْ بِهِمَا: كِتَابَ اللَّهِ، وَسُنَّةَ نَبِيِّهِ ﷺ.',
      isnad: 'عَنْ مَالِكٍ، أَنَّهُ بَلَغَهُ أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuwatta.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_mw1594_1',
          grade: HadithGrade.hasan,
          scholarName: 'الإمام مالك والحاكم',
          sourceBook: 'موطأ مالك',
          context: 'بلاغ مالك وهو متصل وموصول من طرق أخرى صححه الحاكم',
        ),
      ],
    ));

    list.add(HadithEntity.create(
      hadithId: 'hadith_muwatta_1614',
      collectionId: srcMuwatta.sourceId,
      bookNumber: 47,
      bookName: 'كتاب حسن الخلق',
      chapterNumber: 1,
      chapterName: 'باب ما جاء في حسن الخلق ومكارم الشريعة',
      primaryNumber: 1614,
      internationalNumber: 1614,
      arabicMatn: 'بُعِثْتُ لِأُتَمِّمَ حُسْنَ الأَخْلاَقِ.',
      isnad: 'عَنْ مَالِكٍ، أَنَّهُ بَلَغَهُ أَنَّ رَسُولَ اللَّهِ ﷺ قَالَ...',
      sourceId: srcMuwatta.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_mw1614_1',
          grade: HadithGrade.sahih,
          scholarName: 'الإمام مالك وابن عبد البر',
          sourceBook: 'موطأ مالك',
          context: 'صحيح موصول من حديث أبي هريرة وغيره عند أحمد والبيهقي',
        ),
      ],
    ));

    // =========================================================================
    // 6. مسند الإمام أحمد (Musnad Ahmad)
    // =========================================================================
    list.add(HadithEntity.create(
      hadithId: 'hadith_musnad_17144',
      collectionId: srcMusnad.sourceId,
      bookNumber: 4,
      bookName: 'مسند الشاميين',
      chapterNumber: 1,
      chapterName: 'باب حديث العرباض بن سارية رضي الله عنه',
      primaryNumber: 17144,
      internationalNumber: 17144,
      arabicMatn: 'قَدْ تَرَكْتُكُمْ عَلَى البَيْضَاءِ لَيْلُهَا كَنَهَارِهَا، لاَ يَزِيغُ عَنْهَا بَعْدِي إِلاَّ هَالِكٌ، وَمَنْ يَعِشْ مِنْكُمْ فَسَيَرَى اخْتِلاَفاً كَثِيراً، فَعَلَيْكُمْ بِمَا عَرَفْتُمْ مِنْ سُنَّتِي وَسُنَّةِ الخُلَفَاءِ المَهْدِيِّينَ الرَّاشِدِينَ، عَضُّوا عَلَيْهَا بِالنَّوَاجِذِ.',
      isnad: 'عَنِ العِرْبَاضِ بْنِ سَارِيَةَ رَضِيَ اللَّهُ عَنْهُ، قَالَ: صَلَّى بِنَا رَسُولُ اللَّهِ ﷺ ذَاتَ يَوْمٍ، ثُمَّ أَقْبَلَ عَلَيْنَا فَوَعَظَنَا مَوْعِظَةً بَلِيغَةً...',
      sourceId: srcMusnad.sourceId,
      gradings: [
        HadithGrading.create(
          gradingId: 'grd_ms17144_1',
          grade: HadithGrade.sahih,
          scholarName: 'أحمد وشعيب الأرنؤوط',
          sourceBook: 'مسند أحمد',
          context: 'إسناده صحيح رجاله ثقات رجال الصحيح',
        ),
      ],
    ));

    return list;
  }
}
