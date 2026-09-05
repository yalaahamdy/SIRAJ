import '../../../../modules/seerah/domain/date_precision.dart';
import '../../../../modules/seerah/domain/historical_date.dart';
import '../../../../modules/seerah/domain/historical_evidence_level.dart';
import '../../../../modules/seerah/domain/moral_lesson.dart';
import '../../../../modules/seerah/domain/narrative_variant.dart';
import '../../../../modules/seerah/domain/seerah_event.dart';

/// Comprehensive canonical dataset for Seerah Events - Part 2 (Battles, Fath Makkah, Farewell Pilgrimage, and Wafat) (§5, §12, §15, §28, §29).
class SeerahEventsPart2Data {
  static List<SeerahEvent> getEvents() {
    return [
      // 12. Qibla & Fasting
      SeerahEvent.create(
        eventId: 'evt_qibla_fasting',
        title: 'تحويل القبلة إلى المسجد الحرام وفرض صيام رمضان',
        periodId: 'prd_medinan_early',
        historicalDate: const HistoricalDate(
          hijriYear: 2,
          isBeforeHijrah: false,
          hijriMonth: 8,
          precision: DatePrecision.exactDate,
          dateDisplay: 'شعبان 2 هـ (فبراير 624 م)',
        ),
        locationId: 'place_madinah',
        participantIds: const ['person_prophet_muhammad'],
        summary:
            'ظل المسلمون يتوجهون في صلاتهم نحو بيت المقدس ستة عشر أو سبعة عشر شهراً بعد الهجرة، وكان النبي ﷺ يقلب وجهه في السماء شوقاً إلى قبلة إبراهيم وإسماعيل عليهما السلام، فنزل الوحي بالأمر الإلهي: ﴿قَدْ نَرَىٰ تَقَلُّبَ وَجْهِكَ فِي السَّمَاءِ فَلَنُوَلِّيَنَّكَ قِبْلَةً تَرْضَاهَا فَوَلِّ وَجْهَكَ شَطْرَ الْمَسْجِدِ الْحَرَامِ﴾. فتحول النبي ﷺ والمسلمون وهم في صلاة الظهر أو العصر بموضع مسجد القبلتين في مشهد إيماني يعكس كمال الامتثال واليقين، وتزامن مع ذلك تشريع فريضة صيام شهر رمضان وزكاة الفطر تزكية للأرواح وتطهيراً للنفوس.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة البقرة: ﴿قَدْ نَرَىٰ تَقَلُّبَ وَجْهِكَ فِي السَّمَاءِ فَلَنُوَلِّيَنَّكَ قِبْلَةً تَرْضَاهَا فَوَلِّ وَجْهَكَ شَطْرَ الْمَسْجِدِ الْحَرَامِ﴾',
          'سورة البقرة: ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث البراء بن عازب رضي الله عنه في صلاة النبي ﷺ إلى بيت المقدس ستة عشر شهراً ثم توجيهه إلى الكعبة.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'الاستقلالية والتميز الحضاري والروحي للأمة المسلمة بارتباطها بقبلة أبي الأنبياء إبراهيم عليه السلام.',
            themeArabic: 'الاستقلال الحضاري للأمة',
            sourceOrScholar: 'ابن كثير في التفسير',
          ),
          MoralLesson(
            lessonText: 'سرعة الامتثال والاستجابة الفورية لأمر الله ورسوله دون تردد أو ارتياب.',
            themeArabic: 'كمال الامتثال والانقياد',
            sourceOrScholar: 'النووي في شرح صحيح مسلم',
          ),
        ],
        version: 1,
      ),

      // 13. Battle of Badr
      SeerahEvent.create(
        eventId: 'evt_badr_major',
        title: 'غزوة بدر الكبرى (يوم الفرقان)',
        periodId: 'prd_medinan_early',
        historicalDate: const HistoricalDate(
          hijriYear: 2,
          isBeforeHijrah: false,
          hijriMonth: 9,
          hijriDay: 17,
          precision: DatePrecision.exactDate,
          dateDisplay: '17 رمضان 2 هـ (مارس 624 م)',
        ),
        locationId: 'place_badr',
        participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali', 'person_hamzah'],
        summary:
            'أول ملحمة فاصلة في تاريخ الإسلام خرج فيها النبي ﷺ في 314 رجلاً لاعتراض قافلة قريش، فتحولت إلى مواجهة حتمية مع جيش المشركين المدجج بنحو ألف مقاتل بقيادة أبي جهل. أعمل النبي ﷺ مبدأ الشورى مع المهاجرين والأنصار فقال سعد بن معاذ كلمته الخالدة: «لو خضت بنا هذا البحر لخضناه معك»، ونزل عند أدنى ماء إلى القوم بمشورة الحباب بن المنذر. وبات النبي ﷺ ليلته يبتهل في العريش حتى سقط رداؤه قائلاً: «اللهم إن تهلك هذه العصابة فلن تعبد في الأرض»، فنزل نصر الله بمدد الملائكة مردفين وقُتل سبعون من صناديد الشرك على رأسهم أبو جهل وأمية بن خلف وأُسر سبعون.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة الأنفال: ﴿إِذْ تَسْتَغِيثُونَ رَبَّكُمْ فَاسْتَجَابَ لَكُمْ أَنِّي مُمِدُّكُم بِأَلْفٍ مِّنَ الْمَلَائِكَةِ مُرْدِفِينَ﴾',
          'سورة آل عمران: ﴿وَلَقَدْ نَصَرَكُمُ اللَّهُ بِبَدْرٍ وَأَنتُمْ أَذِلَّةٌ فَاتَّقُوا اللَّهَ لَعَلَّكُمْ تَشْكُرُونَ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: كتاب المغازي، حديث دعاء النبي ﷺ في العريش يوم بدر حتى سقط رداؤه فأخذه أبو بكر ووضعه على منكبيه.',
        ],
        variants: [
          NarrativeVariant.create(
            variantId: 'var_badr_combatants',
            eventId: 'evt_badr_major',
            narratorOrScholar: 'موسى بن عقبة وابن إسحاق',
            narrativeSummary: 'تذكر رواية موسى بن عقبة خروج النبي ﷺ في ثلاثمائة وبضعة عشر رجلاً، وجلهم من الأنصار (بين 230 إلى 240)، ومعه فرسان فقط (المقداد والزبير).',
            sourceId: 'src_maghazi_musa',
            evidenceLevel: HistoricalEvidenceLevel.strongReport,
            scholarlyNotes: 'رواية موسى بن عقبة من أقدم وأصح المصادر المغازية التي وثقها الإمام مالك والذهبي.',
          ),
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'النصر الإلهي الحقيقي منوط بصفاء العقيدة والتوكل الصادق والأخذ بالأسباب المشروعة، لا بكثرة العدد ولا ضخامة العتاد.',
            themeArabic: 'معيار النصر في الميزان الإلهي',
            sourceOrScholar: 'الحافظ ابن كثير في البداية والنهاية',
          ),
          MoralLesson(
            lessonText: 'أهمية الشورى النبوية العملية والنزول على رأي أهل الخبرة الميدانية في خطط المعارك وإدارة الدولة.',
            themeArabic: 'الشورى المؤسسية وأثرها القيادي',
            sourceOrScholar: 'ابن القيم في زاد المعاد',
          ),
        ],
        version: 2,
      ),

      // 14. Battle of Uhud
      SeerahEvent.create(
        eventId: 'evt_uhud',
        title: 'غزوة أحد ودروس الرماة والثبات',
        periodId: 'prd_medinan_early',
        historicalDate: const HistoricalDate(
          hijriYear: 3,
          isBeforeHijrah: false,
          hijriMonth: 10,
          precision: DatePrecision.exactDate,
          dateDisplay: 'شوال 3 هـ (مارس 625 م)',
        ),
        locationId: 'place_uhud',
        participantIds: const ['person_prophet_muhammad', 'person_ali', 'person_hamzah', 'person_musab', 'person_saad'],
        summary:
            'خرجت قريش بثلاثة آلاف مقاتل للثأر من بدر، وخرج المسلمون في ألف مقاتل انسحب منهم ثلثهم بقيادة عبد الله بن أبي سلول المنافق. تمركز النبي ﷺ عند جبل أحد وأمّر عبد الله بن جبير على خمسين رامياً فوق جبل عينين لحماية ظهر المسلمين مشدداً: «إن رأيتمونا تخطفنا الطير فلا تبرحوا مكانكم هذا». انتصر المسلمون في الجولة الأولى، لكن أغلب الرماة ظنوا انتهاء المعركة فنزلوا لجمع الغنائم، فاستغل خالد بن الوليد (قبل إسلامه) الثغرة والتف بالفرسان. انقلبت الموازين واضطربت الصفوف واستشهد سبعون من خيرة الصحابة كحمزة سيد الشهداء ومصعب بن عمير، وأصيب النبي ﷺ وشُج وجهه وكسرت رباعيته الشريفة، فثبت حوله نفر كالأطواد كعلي وسعد وأبي دجانة حتى أعاد لم شمل الجيش.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة آل عمران: ﴿وَلَقَدْ صَدَقَكُمُ اللَّهُ وَعْدَهُ إِذْ تَحُسُّونَهُم بِإِذْنِهِ حَتَّىٰ إِذَا فَشِلْتُمْ وَتَنَازَعْتُمْ فِي الْأَمْرِ وَعَصَيْتُم مِّن بَعْدِ مَا أَرَاكُم مَّا تُحِبُّونَ مِنكُم مَّن يُرِيدُ الدُّنْيَا وَمِنكُم مَّن يُرِيدُ الْآخِرَةَ﴾',
          'سورة آل عمران: ﴿وَلَا تَهِنُوا وَلَا تَحْزَنُوا وَأَنتُمُ الْأَعْلَوْنَ إِن كُنتُم مُّؤْمِنِينَ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث البراء بن عازب رضي الله عنه في أمر النبي ﷺ للرماة وتفاصيل مخالفة الأمر والتحول في معركة أحد.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'عواقب مخالفة أمر القيادة والانشغال بالغنائم والدنيا، فالنصر مرتبط بامتثال أمر الله ورسوله في المنشط والمكره.',
            themeArabic: 'شؤم المعصية وأثر التطلع إلى الدنيا',
            sourceOrScholar: 'ابن حجر في فتح الباري',
          ),
          MoralLesson(
            lessonText: 'الابتلاء سنة ربانية لتمحيص صفوف المؤمنين وكشف المنافقين ورفع درجات الشهداء وإعداد الأمة للمهام العظمى.',
            themeArabic: 'حكمة الابتلاء والتمحيص الإلهي',
            sourceOrScholar: 'ابن القيم في زاد المعاد',
          ),
        ],
        version: 2,
      ),

      // 15. Banu Nadir & Ifk
      SeerahEvent.create(
        eventId: 'evt_ifk_nadheer',
        title: 'غزوة بني النضير وبراءة عائشة في حادثة الإفك',
        periodId: 'prd_medinan_early',
        historicalDate: const HistoricalDate(
          hijriYear: 4,
          isBeforeHijrah: false,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'السنة الرابعة والخامسة للهجرة (نحو 625 - 626 م)',
        ),
        locationId: 'place_madinah',
        participantIds: const ['person_prophet_muhammad', 'person_aisha', 'person_abu_bakr', 'person_ali'],
        summary:
            'غدر يهود بني النضير بمحاولة إلقاء صخرة على النبي ﷺ وهو جالس إلى جدارهم، فنزل جبريل بالخبر وحاصرهم المسلمون حتى أجلاهم النبي ﷺ عن المدينة حاملي ما تستطيع إبلهم حمله عدا السلاح فنزل فيهم سورة الحشر. وفي غزوة بني المصطلق قاد رأس النفاق ابن سلول مؤامرة شنيعة اتهم فيها أم المؤمنين عائشة رضي الله عنها بالبهتان في حادثة الإفك. عاش النبي ﷺ وعائشة وبيت الصديق شهراً من الألم والصبر المرير، حتى أنزل الله براءتها بقرآن يتلى إلى يوم القيامة في فواتح سورة النور وجعل الطعن في الأعراض من أكبر الكبائر المستوجبة للعقوبة واللعان.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة النور: ﴿إِنَّ الَّذِينَ جَاءُوا بِالْإِفْكِ عُصْبَةٌ مِّنكُمْ لَا تَحْسَبُوهُ شَرًّا لَّكُم بَلْ هُوَ خَيْرٌ لَّكُمْ لِكُلِّ امْرِئٍ مِّنْهُم مَّا اكْتَسَبَ مِنَ الْإِثْمِ وَالَّذِي تَوَلَّىٰ كِبْرَهُ مِنْهُمْ لَهُ عَذَابٌ عَظِيمٌ﴾',
          'سورة الحشر: ﴿هُوَ الَّذِي أَخْرَجَ الَّذِينَ كَفَرُوا مِنْ أَهْلِ الْكِتَابِ مِن دِيَارِهِمْ لِأَوَّلِ الْحَشْرِ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث الإفك الطويل المروي عن عائشة رضي الله عنها بلفظها وتفاصيل مرضها وبكائها وتنزيل براءتها.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'صيانة الأعراض وحرمة تداول الشائعات والأكاذيب، ووجوب حسن الظن بالمؤمنين والتحقق قبل الحكم.',
            themeArabic: 'حرمة الأعراض وتجريم الشائعات',
            sourceOrScholar: 'القرطبي في الجامع لأحكام القرآن',
          ),
          MoralLesson(
            lessonText: 'طهارة بيت النبوة وفضل أم المؤمنين عائشة رضي الله عنها، وعاقبة الصبر الجميل على البلاء والافتراء.',
            themeArabic: 'فضل الصديقة وعاقبة الصبر الجميل',
            sourceOrScholar: 'النووي في شرح صحيح مسلم',
          ),
        ],
        version: 1,
      ),

      // 16. Battle of Khandaq
      SeerahEvent.create(
        eventId: 'evt_khandaq',
        title: 'غزوة الأحزاب (الخندق) وتداعي القبائل',
        periodId: 'prd_medinan_early',
        historicalDate: const HistoricalDate(
          hijriYear: 5,
          isBeforeHijrah: false,
          hijriMonth: 11,
          precision: DatePrecision.exactDate,
          dateDisplay: 'شوال وذو القعدة 5 هـ (فبراير - مارس 627 م)',
        ),
        locationId: 'place_khandaq',
        participantIds: const ['person_prophet_muhammad', 'person_ali', 'person_salman', 'person_abu_bakr'],
        summary:
            'أعظم حصار واجهته المدينة النبوية حين حرض يهود بني النضير قريشاً وغطفان وقبائل العرب فجمعوا عشرة آلاف مقاتل لاستئصال شأفة المسلمين. أشار سلمان الفارسي رضي الله عنه بحفر خندق شمال المدينة، فشارك النبي ﷺ أصحابه بيده في الحفر وسط برد قارس ومجاعة شديدة ورأوا منه المعجزات في تفتيت الصخرة العظيمة التي بشرهم فيها بفتح مدائن كسرى وقيصر وصنعاء. نقض يهود بني قريظة العهد من الجنوب فاشتد الكرب ﴿وَإِذْ زَاغَتِ الْأَبْصَارُ وَبَلَغَتِ الْقُلُوبُ الْحَنَاجِرَ﴾، فاستعمل النبي ﷺ ذكاء نعيم بن مسعود لتفريق صفوف الأحزاب، ثم أرسل الله ريحاً عاصفة وجنوداً من الملائكة اقتلعت خيامهم وكفأت قدورهم وهزمت جمعهم بغير قتال.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة الأحزاب: ﴿يَا أَيُّهَا الَّذِينَ آمَنُوا اذْكُرُوا نِعْمَةَ اللَّهِ عَلَيْكُمْ إِذْ جَاءَتْكُمْ جُنُودٌ فَأَرْسَلْنَا عَلَيْهِمْ رِيحًا وَجُنُودًا لَّمْ تَرَوْهَا وَكَانَ اللَّهُ بِمَا تَعْمَلُونَ بَصِيرًا﴾',
          'سورة الأحزاب: ﴿وَرَدَّ اللَّهُ الَّذِينَ كَفَرُوا بِغَيْظِهِمْ لَمْ يَنَالُوا خَيْرًا وَكَفَى اللَّهُ الْمُؤْمِنِينَ الْقِتَالَ وَكَانَ اللَّهُ قَوِيًّا عَزِيزًا﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث جابر بن عبد الله رضي الله عنه في حفر الخندق ومعجزة إطعام الجيش كله من صاع شعير وعناق.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'الانفتاح الواعي على تجارب الأمم العسكرية والتكتيكية المفيدة وتطبيق فكرة الخندق التي أشار بها سلمان الفارسي.',
            themeArabic: 'الاستفادة من الخبرات والتجارب العالمية',
            sourceOrScholar: 'السباعي في السيرة النبوية دروس وعبر',
          ),
          MoralLesson(
            lessonText: 'اليقين المطلق بنصر الله وحفظه، واستشراف البشارات الكبرى للأمة حتى في أحلك ساعات الحصار والجوع والشدة.',
            themeArabic: 'صناعة الأمل واليقين وسط الشدائد',
            sourceOrScholar: 'الغزالي في فقه السيرة',
          ),
        ],
        version: 2,
      ),

      // 17. Treaty of Hudaybiyyah
      SeerahEvent.create(
        eventId: 'evt_hudaybiyyah',
        title: 'صلح الحديبية وبيعة الرضوان (الفتح المبين)',
        periodId: 'prd_medinan_late',
        historicalDate: const HistoricalDate(
          hijriYear: 6,
          isBeforeHijrah: false,
          hijriMonth: 11,
          precision: DatePrecision.exactDate,
          dateDisplay: 'ذو القعدة 6 هـ (مارس 628 م)',
        ),
        locationId: 'place_hudaybiyyah',
        participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_umar', 'person_uthman', 'person_ali'],
        summary:
            'خرج النبي ﷺ في ألف وأربعمائة من أصحابه معتمرين مسالمين لا يحملون إلا سلاح الراكب، فسدّت قريش طريقهم عند الحديبية. أرسل عثمان بن عفان للمفاوضة فشاع خبر مقتله، فدعا النبي ﷺ الصحابة لبيعة الرضوان تحت الشجرة على الموت وعدم الفرار، فنزل فيهم الرضا الإلهي ﴿لَّقَدْ رَضِيَ اللَّهُ عَنِ الْمُؤْمِنِينَ إِذْ يُبَايِعُونَكَ تَحْتَ الشَّجَرَةِ﴾. ثم جاء سهيل بن عمرو مفاوضاً، فوقع النبي ﷺ صلح الحديبية ببنوده الشاقة ظاهرياً (هدنة عشر سنين ورد من يأتي مسلماً والرجوع في عامهم)، ولما ثقل ذلك على بعض الصحابة وجهته أم المؤمنين أم سلمة رضي الله عنها بحكمتها أن يبدأ بنفسه بالحلق والنحر فاقتدى به الجيش كله. وسماه الله في القرآن فتحاً مبيناً لأنه فتح الباب لدخول الناس في دين الله أفواجاً.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة الفتح: ﴿إِنَّا فَتَحْنَا لَكَ فَتْحًا مُّبِينًا ۝ لِّيَغْفِرَ لَكَ اللَّهُ مَا تَقَدَّمَ مِن ذَنبِكَ وَمَا تَأَخَّرَ وَيُتِمَّ نِعْمَتَهُ عَلَيْكَ وَيَهْدِيَكَ صِرَاطًا مُّسْتَقِيمًا﴾',
          'سورة الفتح: ﴿لَّقَدْ رَضِيَ اللَّهُ عَنِ الْمُؤْمِنِينَ إِذْ يُبَايِعُونَكَ تَحْتَ الشَّجَرَةِ فَعَلِمَ مَا فِي قُلُوبِهِمْ فَأَنزَلَ السَّكِينَةَ عَلَيْهِمْ وَأَثَابَهُمْ فَتْحًا قَرِيبًا﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: كتاب الشروط، حديث صلح الحديبية المفصل عن المسور بن مخرمة ومروان بن الحكم.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'بُعد النظر السياسي والاستراتيجي والتنازل عن الشكليات لحقن الدماء وتحقيق المقاصد الكبرى للدعوة.',
            themeArabic: 'فقه الموازنات والسياسة الشرعية',
            sourceOrScholar: 'ابن القيم في زاد المعاد (فقه صلح الحديبية)',
          ),
          MoralLesson(
            lessonText: 'عظمة استشارة المرأة الصالحة وحكمتها البالغة كما تجلى في مشورة أم سلمة التي أنقذت الموقف وحفظت الجيش.',
            themeArabic: 'حكمة المرأة في القرارات المصيرية',
            sourceOrScholar: 'ابن حجر في فتح الباري',
          ),
        ],
        version: 2,
      ),

      // 18. Conquest of Khaybar & Royal Letters
      SeerahEvent.create(
        eventId: 'evt_khaybar_letters',
        title: 'غزوة خيبر ورسائل النبي ﷺ إلى ملوك العالم',
        periodId: 'prd_medinan_late',
        historicalDate: const HistoricalDate(
          hijriYear: 7,
          isBeforeHijrah: false,
          hijriMonth: 1,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'محرم 7 هـ (مايو 628 م)',
        ),
        locationId: 'place_khaybar',
        participantIds: ['person_prophet_muhammad', 'person_ali', 'person_abu_bakr', 'person_jafar'],
        summary:
            'استثمر المسلمون هدنة الحديبية لتأمين الجبهة الشمالية واستئصال بؤرة المؤامرات في واحة خيبر الحصينة. خرج النبي ﷺ في أصحاب الشجرة وحاصروا الحصون المنيعة واحداً تلو الآخر حتى استعصت عليهم بعضها، فقال النبي ﷺ كلمته المشهورة: «لأعطين الراية غداً رجلاً يحب الله ورسوله ويحبه الله ورسوله يفتح الله على يديه». فأعطاها علي بن أبي طالب رضي الله عنه بعد أن تفل في عينيه وكانتا رمداوان، فبارز مرحب قائد اليهود وقتله واقتلع باب الحصن وفتح الله خيبر، وصالحهم على نصف ما يخرج منها. وتزامن مع ذلك إرسال رسائل النبي ﷺ التاريخية المختومة بـ "محمد رسول الله" إلى كبار ملوك الأرض (كسرى فارس، قيصر الروم، المقوقس حاكم مصر، والنجاشي) لتبليغ رسالة الإسلام عالمياً.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedHadithIds: const [
          'صحيح البخاري وصحيح مسلم: حديث إعطاء الراية لعلي بن أبي طالب رضي الله عنه يوم خيبر وفضله العظيم.',
          'صحيح البخاري: كتاب بدء الوحي، حديث كتاب النبي ﷺ إلى هرقل عظيم الروم وسؤال هرقل لأبي سفيان بن حرب.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'عالمية الرسالة الإسلامية وخروجها الشجاع لمخاطبة قادة العالم وأكاسرتهم وقياصرتهم بلغة الحق والسلام والهداية.',
            themeArabic: 'عالمية الدعوة والخطاب الإنساني',
            sourceOrScholar: 'الندوي في السيرة النبوية',
          ),
        ],
        version: 1,
      ),

      // 19. Battle of Mu'tah
      SeerahEvent.create(
        eventId: 'evt_mutah',
        title: 'سرية مؤتة الخالدة وملاحم الشهداء',
        periodId: 'prd_medinan_late',
        historicalDate: const HistoricalDate(
          hijriYear: 8,
          isBeforeHijrah: false,
          hijriMonth: 5,
          precision: DatePrecision.exactDate,
          dateDisplay: 'جمادى الأولى 8 هـ (سبتمبر 629 م)',
        ),
        locationId: 'place_mutah',
        participantIds: const ['person_prophet_muhammad', 'person_jafar', 'person_khalid'],
        summary:
            'أول ملحمة كبرى للمسلمين خارج جزيرة العرب وقعت بأرض الشام جنوب الأردن بعد قتل الغساسنة لسفير النبي ﷺ الحارث بن عمير الأزدي. أرسل النبي ﷺ ثلاثة آلاف مقاتل ورتب القيادة بنص نبوي معجز: «أميركم زيد بن حارثة، فإن قُتل فجعفر بن أبي طالب، فإن قُتل فعبد الله بن رواحة». التقى المسلمون بجيش الروم وحلفائهم المقدر بمائتي ألف مقاتل، واستبسل القادة الثلاثة في الشجاعة والبطولة حتى استشهدوا جميعاً بعد أن قُطعت يدا جعفر وهو قابض على الراية. تسلم الراية سيف الله المسلول خالد بن الوليد فاخترع خطة تكتيكية عبقرية بتغيير الميمنة والميسرة وإثارة الغبار خلف الجيش لإيهام العدو بوصول إمدادات ضخمة، وانسحب بالجيش سالماً دون خسائر، ونعاهم النبي ﷺ للمدينة وعيناه تذرفان.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical'],
        relatedHadithIds: const [
          'صحيح البخاري: حديث نعي النبي ﷺ لقادة مؤتة بالوحي وهو بالمدينة قبل أن يصل الخبر من أرض المعركة: «أخذ الراية زيد فأصيب، ثم أخذها جعفر فأصيب... حتى أخذها سيف من سيوف الله فتح الله عليه».',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'العبقرية العسكرية لخالد بن الوليد وقيمة الانسحاب التكتيكي الحكيم لإنقاذ الجيوش حينما تقتضي الحكمة الميدانية ذلك.',
            themeArabic: 'الانسحاب التكتيكي وحفظ الأنفس',
            sourceOrScholar: 'ابن كثير في البداية والنهاية',
          ),
        ],
        version: 1,
      ),

      // 20. Conquest of Makkah
      SeerahEvent.create(
        eventId: 'evt_fath_makkah',
        title: 'فتح مكة المكرمة وتطهير الكعبة من الأصنام',
        periodId: 'prd_medinan_late',
        historicalDate: const HistoricalDate(
          hijriYear: 8,
          isBeforeHijrah: false,
          hijriMonth: 9,
          hijriDay: 20,
          precision: DatePrecision.exactDate,
          dateDisplay: '20 رمضان 8 هـ (يناير 630 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali', 'person_bilal', 'person_khalid'],
        summary:
            'نقضت قريش صلح الحديبية بإعانتها بني بكر على خزاعة حلفاء المسلمين، فجهز النبي ﷺ جيشاً عرمرماً من عشرة آلاف صحابي بتكتم تام. دخلت الجيوش مكة من أربعة محاور دون إراقة دماء، ودخل رسول الله ﷺ راكباً ناقته القصواء مطأطئاً رأسه تواضعاً وخضوعاً لله حتى إن لحيته الشريفة لتكاد تمس واسطة الرحل. طاف بالبيت العتيق وحطم 360 صنماً بعوده وهو يتلو: ﴿وَقُلْ جَاءَ الْحَقُّ وَزَهَقَ الْبَاطِلُ إِنَّ الْبَاطِلَ كَانَ زَهُوقًا﴾. ثم وقف أمام قريش وهم ينتظرون مصيرهم بعد عقود من التعذيب والحروب فقال: «ما تظنون أني فاعل بكم؟ قالوا: خيراً، أخ كريم وابن أخ كريم، فقال: لا تثريب عليكم اليوم، اذهبوا فأنتم الطلقاء». وأمر بلال بن رباح أن يصعد فوق ظهر الكعبة ليصدح بأذان التوحيد معلناً نهاية عهد الوثنية.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة النصر: ﴿إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ ۝ وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا ۝ فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا﴾',
          'سورة الإسراء: ﴿وَقُلْ جَاءَ الْحَقُّ وَزَهَقَ الْبَاطِلُ إِنَّ الْبَاطِلَ كَانَ زَهُوقًا﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث ابن عباس رضي الله عنهما في فتح مكة وكسر الأصنام حول الكعبة ودخول النبي ﷺ متواضعاً.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'العفو عند المقدرة: أسمى نموذج في تاريخ البشرية للتسامح النبوي المطلق مع ألد الأعداء الذين حاربوه وأخرجوه وقتلوا أصحابه.',
            themeArabic: 'العفو عند المقدرة وسمو الأخلاق النبوية',
            sourceOrScholar: 'ابن القيم في زاد المعاد',
          ),
          MoralLesson(
            lessonText: 'التواضع عند النصر والتمكين، ونسبة كل فضل وفتح لله تعالى بالتسبيح والاستغفار والخضوع لا بالخيلاء والتجبر.',
            themeArabic: 'التواضع الإيماني عند ذروة الانتصار',
            sourceOrScholar: 'الغزالي في فقه السيرة',
          ),
        ],
        version: 2,
      ),

      // 21. Hunayn & Tabuk
      SeerahEvent.create(
        eventId: 'evt_hunayn_tabuk',
        title: 'غزوة حنين وقسمة الغنائم وغزوة تبوك (جيش العسرة)',
        periodId: 'prd_medinan_late',
        historicalDate: const HistoricalDate(
          hijriYear: 9,
          isBeforeHijrah: false,
          hijriMonth: 7,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'من شوال 8 هـ إلى رجب 9 هـ (630 م)',
        ),
        locationId: 'place_hunayn',
        participantIds: ['person_prophet_muhammad', 'person_abu_bakr', 'person_uthman', 'person_ali'],
        summary:
            'في وادي حنين واجه المسلمون في اثني عشر ألفاً هوازن وثقيف، فباغتهم كمين المشركين وتراجع المسلمون لإعجابهم بكثرتهم ﴿إِذْ أَعْجَبَتْكُمْ كَثْرَتُكُمْ فَلَمْ تُغْنِ عَنكُمْ شَيْئًا﴾، فثبت النبي ﷺ كالطود الأشم ينادي: «أنا النبي لا كذب، أنا ابن عبد المطلب»، والتف حوله الصحابة ونزل نصر الله. وفي قسمة غنائم حنين خص النبي ﷺ المؤلفة قلوبهم لتأليفهم، فوجد الأنصار في أنفسهم، فجمعهم وخطب فيهم خطبته التاريخية الباكية: «ألا ترضون يا معشر الأنصار أن يذهب الناس بالشاة والبعير، وترجعون برسول الله إلى رحالكم؟ فبكوا حتى اخضلت لحاهم». وفي صيف 9 هـ كانت غزوة تبوك (جيش العسرة) لمواجهة الروم، فتسابق الصحابة في البذل وجهز عثمان ثلث الجيش بماله، وقطع الجيش مسافات شاسعة في لهيب الصيف حتى أظهر الله هيبة الإسلام وأخضع قبائل الشمال دون قتال، ونزلت توبة الله العظيمة على الثلاثة الذين خُلّفوا.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة التوبة: ﴿لَقَدْ نَصَرَكُمُ اللَّهُ فِي مَوَاطِنَ كَثِيرَةٍ وَيَوْمَ حُنَيْنٍ إِذْ أَعْجَبَتْكُمْ كَثْرَتُكُمْ فَلَمْ تُغْنِ عَنكُمْ شَيْئًا﴾',
          'سورة التوبة: ﴿لَّقَد تَّابَ اللَّهُ عَلَى النَّبِيِّ وَالْمُهَاجِرِينَ وَالْأَنصَارِ الَّذِينَ اتَّبَعُوهُ فِي سَاعَةِ الْعُسْرَةِ﴾',
          'سورة التوبة: ﴿وَعَلَى الثَّلَاثَةِ الَّذِينَ خُلِّفُوا حَتَّىٰ إِذَا ضَاقَتْ عَلَيْهِمُ الْأَرْضُ بِمَا رَحُبَتْ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث خطبة النبي ﷺ للأنصار في الجعرانة وبكائهم الشديد وقولهم: رضينا برسول الله قسماً وحظاً.',
          'صحيح البخاري: حديث كعب بن مالك رضي الله عنه الطويل في تخلفه عن غزوة تبوك وصدقه وتوبة الله عليه.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'الكثرة المجردة لا تنفع ما لم تصحبها التقوى والافتقار الصادق إلى الله، ودرس حنين تحذير دائم للأمة من الغرور العددي.',
            themeArabic: 'التحذير من فتنة الغرور بالكثرة',
            sourceOrScholar: 'القرطبي في التفسير',
          ),
          MoralLesson(
            lessonText: 'عظمة الصدق ونجاة الصادقين كما تجسد في قصة كعب بن مالك وصاحبيه وخلود توبة الله عليهم في القرآن المجيد.',
            themeArabic: 'نجاة الصدق وبركة التوبة النصوح',
            sourceOrScholar: 'النووي في شرح صحيح مسلم',
          ),
        ],
        version: 1,
      ),

      // 22. Farewell Pilgrimage & Wafat
      SeerahEvent.create(
        eventId: 'evt_wada',
        title: 'حجة الوداع وخطبة عرفات والوفاة الشريفة',
        periodId: 'prd_medinan_late',
        historicalDate: const HistoricalDate(
          hijriYear: 10,
          isBeforeHijrah: false,
          hijriMonth: 12,
          hijriDay: 9,
          precision: DatePrecision.exactDate,
          dateDisplay: 'من 9 ذي الحجة 10 هـ إلى 12 ربيع الأول 11 هـ (632 م)',
        ),
        locationId: 'place_arafat',
        participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali', 'person_aisha', 'person_fatimah'],
        summary:
            'في ذي الحجة سنة 10 هـ خرج النبي ﷺ لحجة الوداع ومعه أكثر من مائة ألف من المسلمين، ووقف على صعيد عرفات ليلقي خطبة الوداع التاريخية الجامعة؛ فأعلن حرمة الدماء والأموال والأعراض، وأبطل مآثر الجاهلية ورباها، وأوصى بالنساء خيراً، وأكد المساواة الإنسانية: «لا فضل لعربي على أعجمي إلا بالتقوى»، ونزل قوله تعالى: ﴿الْيَوْمَ أَكْمَلْتُ لَكُمْ دِينَكُمْ وَأَتْمَمْتُ عَلَيْكُمْ نِعْمَتِي وَرَضِيتُ لَكُمُ الْإِسْلَامَ دِينًا﴾. وفي أواخر صفر 11 هـ بدأ مرضه الشريف واستأذن أزواجه ليمرض في بيت عائشة، وأمر أبا بكر الصديق أن يصلي بالناس. وفي ضحى الإثنين 12 ربيع الأول 11 هـ شخص بصره نحو السماء وقال كلماته الأخيرة: «بل الرفيق الأعلى من الجنة»، وفاضت روحه الشريفة وأظلمت المدينة لمصابه، وثبّت الله الأمة بكلمات أبي بكر: «ألا من كان يعبد محمداً فإن محمداً قد مات، ومن كان يعبد الله فإن الله حي لا يموت»، ودُفن في حجرته الشريفة.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة المائدة: ﴿الْيَوْمَ أَكْمَلْتُ لَكُمْ دِينَكُمْ وَأَتْمَمْتُ عَلَيْكُمْ نِعْمَتِي وَرَضِيتُ لَكُمُ الْإِسْلَامَ دِينًا﴾',
          'سورة آل عمران: ﴿وَمَا مُحَمَّدٌ إِلَّا رَسُولٌ قَدْ خَلَتْ مِن قَبْلِهِ الرُّسُلُ أَفَإِن مَّاتَ أَوْ قُتِلَ انقَلَبْتُمْ عَلَىٰ أَعْقَابِكُمْ وَمَن يَنقَلِبْ عَلَىٰ عَقِبَيْهِ فَلَن يَضُرَّ اللَّهَ شَيْئًا وَسَيَجْزِي اللَّهُ الشَّاكِرِينَ﴾',
        ],
        relatedHadithIds: const [
          'صحيح مسلم: حديث جابر بن عبد الله رضي الله عنه الطويل في صفة حجة النبي ﷺ وخطبة عرفات.',
          'صحيح البخاري: حديث عائشة وأنس رضي الله عنهما في وفاة رسول الله ﷺ وكلماته الأخيرة وثبات أبي بكر الصديق.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'ميثاق حقوق الإنسان النبوي في خطبة الوداع: تقرير حرمة النفس والمال والعرض وإلغاء التمييز العنصري والمناطقي والعرقي.',
            themeArabic: 'أول إعلان عالمي شامل لحقوق الإنسان',
            sourceOrScholar: 'ابن القيم في زاد المعاد',
          ),
          MoralLesson(
            lessonText: 'ثبات المنهج والعقيدة برحيل القادة والأنبياء؛ فالرسل يموتون ولكن الله باقٍ لا يموت ورسالته خالدة إلى قيام الساعة.',
            themeArabic: 'خلود المنهج وثبات الأمة',
            sourceOrScholar: 'الحافظ ابن كثير في البداية والنهاية',
          ),
        ],
        version: 2,
      ),
    ];
  }
}
