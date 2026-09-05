import '../../../../modules/seerah/domain/date_precision.dart';
import '../../../../modules/seerah/domain/historical_date.dart';
import '../../../../modules/seerah/domain/historical_evidence_level.dart';
import '../../../../modules/seerah/domain/moral_lesson.dart';
import '../../../../modules/seerah/domain/narrative_variant.dart';
import '../../../../modules/seerah/domain/seerah_event.dart';

/// Comprehensive canonical dataset for Seerah Events - Part 1 (Makkan Era to Hijrah & Constitution) (§5, §12, §15, §28, §29).
class SeerahEventsPart1Data {
  static List<SeerahEvent> getEvents() {
    return [
      // 1. Mowlid
      SeerahEvent.create(
        eventId: 'evt_mowlid',
        title: 'المولد النبوي الشريف والنشأة المباركة',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 53,
          isBeforeHijrah: true,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'عام الفيل (12 ربيع الأول نحو 571 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad'],
        summary:
            'ولد سيد الخلق محمد بن عبد الله ﷺ يتيماً في شعب بني هاشم بمكة، وتولت أمه آمنة بنت وهب وحليمة السعدية في بادية بني سعد رضاعه ونشأته الأولى، حيث بركت ديارهم بنوره الشريف ووقعت له حادثة شق الصدر الأولى. توفيت أمه بالأبواء وهو ابن ست سنين فكفله جده عبد المطلب ثم عمه أبو طالب، ورعى الغنم لأهل مكة على قراريط حكمةً وتواضعاً.',
        evidenceLevel: HistoricalEvidenceLevel.strongReport,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة الضحى: ﴿أَلَمْ يَجِدْكَ يَتِيمًا فَآوَىٰ ۝ وَوَجَدَكَ ضَالًّا فَهَدَىٰ ۝ وَوَجَدَكَ عَائِلًا فَأَغْنَىٰ﴾',
        ],
        relatedHadithIds: const [
          'صحيح مسلم: سئل ﷺ عن صوم يوم الإثنين فقال: «ذاك يوم ولدت فيه، ويوم بعثت أو أنزل علي فيه».',
          'صحيح البخاري: «ما بعث الله نبياً إلا رعى الغنم، فقال أصحابه: وأنت؟ فقال: نعم، كنت أرعاها على قراريط لأهل مكة».',
        ],
        variants: [
          NarrativeVariant.create(
            variantId: 'var_mowlid_day',
            eventId: 'evt_mowlid',
            narratorOrScholar: 'ابن إسحاق والجمهور',
            narrativeSummary: 'المشهور عند جمهور أهل السير أنه ولد يوم الإثنين الثاني عشر من ربيع الأول عام الفيل، وقيل في التاسع منه عند بعض الفلكيين.',
            sourceId: 'src_ibn_hisham',
            evidenceLevel: HistoricalEvidenceLevel.multipleSources,
            scholarlyNotes: 'اتفق الأئمة على ولادته يوم الإثنين في عام الفيل، واختلفوا في تحديد يوم الشهر مع ترجيح الثاني عشر أو التاسع.',
          ),
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'رعاية الله لرسوله ﷺ منذ طفولته باليتم ليجعله ملاذاً لليتامى والمستضعفين، فلا يدين بفضله لأحد من البشر بل لربه وحده.',
            themeArabic: 'العناية الربانية باليتم',
            sourceOrScholar: 'ابن هشام في السيرة النبوية',
          ),
          MoralLesson(
            lessonText: 'رعي الغنم مدرسة الأنبياء الكبرى لاكتساب الصبر، والحلم، والرفق بالرعية، وإتقان سياسة النفوس قبل قيادة الأمم.',
            themeArabic: 'التربية على التواضع والمسؤولية',
            sourceOrScholar: 'الحافظ ابن حجر في فتح الباري',
          ),
        ],
        version: 2,
      ),

      // 2. Hilf Al-Fudul & Kaaba
      SeerahEvent.create(
        eventId: 'evt_hilf_fudul_kaaba',
        title: 'حلف الفضول وبناء الكعبة ونقل الحجر الأسود',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 35,
          isBeforeHijrah: true,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'قبل البعثة بخمس عشرة سنة (نحو 595 - 605 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad', 'person_khadijah'],
        summary:
            'شهد النبي ﷺ في شبابه حلف الفضول في دار عبد الله بن جدعان لنصرة المظلومين ورد الحقوق. وتاجر في مال خديجة بنت خويلد إلى الشام بصدقه وأمانته حتى تزوجها. ولما بلغ الخامسة والثلاثين شارك في تجديد بناء الكعبة، واختلفت قبايل قريش في وضع الحجر الأسود حتى كادت تقع حرب دماء، فحكّموه لما رأوا أمانته، فبسط رداءه الشريف ووضع الحجر بيده وأمر كل قبيلة بأخذ طرف فحقن الدماء بحكمته.',
        evidenceLevel: HistoricalEvidenceLevel.strongReport,
        sourceIds: const ['src_bukhari_canonical'],
        relatedHadithIds: const [
          'مسند أحمد: «لقد شهدت في دار عبد الله بن جدعان حلفاً ما أحب أن لي به حمر النعم، ولو أُدعى به في الإسلام لأجبت».',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'الإسلام يقر قيم العدالة ونصرة المظلوم وإغاثة الملهوف في كل زمان ومكان، ولو كان أصلها قبل البعثة.',
            themeArabic: 'إقرار قيم العدل والحق',
            sourceOrScholar: 'ابن كثير في البداية والنهاية',
          ),
          MoralLesson(
            lessonText: 'الحكمة القيادية والذكاء الاجتماعي في حل النزاعات وتوحيد الكلمة وحقن دماء المجتمع.',
            themeArabic: 'الحكمة القيادية ونزع فتيل الفتن',
            sourceOrScholar: 'سليمان الندوي في السيرة النبوية',
          ),
        ],
        version: 1,
      ),

      // 3. First Revelation
      SeerahEvent.create(
        eventId: 'evt_revelation',
        title: 'مبعث النبي ﷺ ونزول أول الوحي بغار حراء',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 13,
          isBeforeHijrah: true,
          precision: DatePrecision.exactDate,
          dateDisplay: 'شهر رمضان المبارك (نحو أغسطس 610 م)',
        ),
        locationId: 'place_hira',
        participantIds: const ['person_prophet_muhammad', 'person_khadijah'],
        summary:
            'حبب إلى النبي ﷺ الخلاء فكان يتحنث الليالي ذوات العدد في غار حراء حتى أتاه الحق فجأة؛ إذ هبط عليه الملك جبريل عليه السلام وقال: «اقرأ»، فقال: «ما أنا بقارئ»، فغطه ثلاثاً حتى بلغ منه الجهد، ثم قال: ﴿اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ﴾. فرجع بها يرجف فؤاده إلى خديجة رضي الله عنها قائلاً: «زملوني زملوني»، فثبتته بكلماتها الخالدة: «كلا والله ما يخزيك الله أبداً، إنك لتصل الرحم، وتصدق الحديث، وتحمل الكل، وتكسب المعدوم، وتقري الضيف، وتعين على نوائب الحق»، وأخذته إلى ورقة بن نوفل فبشره بنبوة آخر الزمان.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة العلق: ﴿اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ ۝ خَلَقَ الْإِنسَانَ مِنْ عَلَقٍ ۝ اقْرَأْ وَرَبُّكَ الْأَكْرَمُ ۝ الَّذِي عَلَّمَ بِالْقَلَمِ ۝ عَلَّمَ الْإِنسَانَ مَا لَمْ يَعْلَمْ﴾',
          'سورة المدثر: ﴿يَا أَيُّهَا الْمُدَّثِّرُ ۝ قُمْ فَأَنذِرْ ۝ وَرَبَّكَ فَكَبِّرْ ۝ وَثِيَابَكَ فَطَهِّرْ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: كتاب بدء الوحي، حديث عائشة رضي الله عنها في بدء ما بدئ به رسول الله ﷺ من الرؤيا الصالحة ونزول الملك.',
        ],
        variants: [
          NarrativeVariant.create(
            variantId: 'var_revelation_date',
            eventId: 'evt_revelation',
            narratorOrScholar: 'المباركفوري والجمهور',
            narrativeSummary: 'وقع نزول الوحي في ليلة القدر من شهر رمضان وهو ابن أربعين سنة قمرية وستة أشهر، وحددها بعض المحققين بيوم الإثنين 21 من رمضان.',
            sourceId: 'src_raheeq',
            evidenceLevel: HistoricalEvidenceLevel.strongReport,
            scholarlyNotes: 'يتفق مع نص القرآن الكريم في نزول القرآن في شهر رمضان وفي ليلة القدر المباركة.',
          ),
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'مركزية القراءة والعلم والافتقار إلى الله كأول تكليف تشريعي، فلا نهضة للإنسان بغير العلم الموصول باسم الله الرب الأكرم.',
            themeArabic: 'أولوية العلم والمعرفة',
            sourceOrScholar: 'صحيح البخاري: كتاب بدء الوحي',
          ),
          MoralLesson(
            lessonText: 'المروءة وصنائع المعروف تمنع مصارع السوء، وثبات الزوجة الصالحة ورجاحة عقلها سند عظيم في ساعات الشدائد الكبرى.',
            themeArabic: 'أثر صنائع المعروف وعظمة المرأة المؤمنة',
            sourceOrScholar: 'ابن حجر في فتح الباري',
          ),
        ],
        version: 2,
      ),

      // 4. Secret & Public Da'wah
      SeerahEvent.create(
        eventId: 'evt_dawah_safa',
        title: 'الدعوة السرية والصدع بالحق على جبل الصفا',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 10,
          isBeforeHijrah: true,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'السنة الثالثة من البعثة (نحو 613 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali'],
        summary:
            'بدأت الدعوة سراً نحو ثلاث سنين في دار الأرقم بن أبي الأرقم لتأسيس الرعيل الأول (خديجة، علي، أبو بكر، زيد بن حارثة)، حتى نزل قوله تعالى: ﴿وَأَنذِرْ عَشِيرَتَكَ الْأَقْرَبِينَ﴾ وقوله: ﴿فَاصْدَعْ بِمَا تُؤْمَرُ﴾. فصعد النبي ﷺ على جبل الصفا وصدح بالنداء: «يا صباحاه»، فاجتمعت قريش فقال: «لو أخبرتكم أن خيلاً تخرج بسفح هذا الجبل أكنتم مصدقي؟ قالوا: ما جربنا عليك كذباً، قال: فإني نذير لكم بين يدي عذاب شديد». فنهض عمه أبو لهب وقال تباً لك ألهذا جمعتنا؟ فنزل تبت يدا أبي لهب.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة الشعراء: ﴿وَأَنذِرْ عَشِيرَتَكَ الْأَقْرَبِينَ ۝ وَاخْفِضْ جَنَاحَكَ لِمَنِ اتَّبَعَكَ مِنَ الْمُؤْمِنِينَ﴾',
          'سورة الحجر: ﴿فَاصْدَعْ بِمَا تُؤْمَرُ وَأَعْرِضْ عَنِ الْمُشْرِكِينَ﴾',
          'سورة المسد: ﴿تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ﴾',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'التدرج الحكيم في بناء التغيير: البدء بتربية النواة الصلبة سراً قبل إعلان المواجهة الشاملة مع قوى الباطل.',
            themeArabic: 'فقه التدرج والبناء التربوي',
            sourceOrScholar: 'الغزالي في فقه السيرة',
          ),
          MoralLesson(
            lessonText: 'استثمار رصيد السمعة الأخلاقية والصدق الشخصي كأقوى حجة في تقديم المبادئ والدعوة إلى الله.',
            themeArabic: 'الصدق الشخصي كمنطلق للدعوة',
            sourceOrScholar: 'السباعي في السيرة النبوية دروس وعبر',
          ),
        ],
        version: 1,
      ),

      // 5. Abyssinia Migrations
      SeerahEvent.create(
        eventId: 'evt_abyssinia',
        title: 'الاضطهاد والهجرتان إلى أرض الحبشة',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 8,
          isBeforeHijrah: true,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'السنة الخامسة والسابعة من البعثة (نحو 615 - 616 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad', 'person_uthman', 'person_jafar', 'person_bilal'],
        summary:
            'لما اشتد إيذاء قريش للمستضعفين وتعذيب بلال وخباب وسمية وآل ياسر، أمر النبي ﷺ أصحابه بالهجرة إلى الحبشة قائلاً: «إن بأرض الحبشة ملكاً لا يظلم أحد عنده فالحقوا ببلاده حتى يجعل الله لكم فرجاً ومخرجاً». فهاجر الفوج الأول برئاسة عثمان بن عفان ومعه رقية بنت رسول الله، ثم الفوج الثاني وكانوا أكثر من ثمانين رجلاً بقيادة جعفر بن أبي طالب، فأرسلت قريش عمرو بن العاص ليردهم، فوقف جعفر خطيباً مفوهاً أمام النجاشي وقرأ فواتح سورة مريم فبكى النجاشي وأساقفته حتى بلوا لحاهم وقال: «إن هذا والذي جاء به عيسى ليخرج من مشكاة واحدة»، ومنحهم الأمان التام.',
        evidenceLevel: HistoricalEvidenceLevel.strongReport,
        sourceIds: const ['src_bukhari_canonical'],
        relatedQuranAyahs: const [
          'سورة النحل: ﴿وَالَّذِينَ هَاجَرُوا فِي اللَّهِ مِن بَعْدِ مَا ظُلِمُوا لَنُبَوِّئَنَّهُمْ فِي الدُّنْيَا حَسَنَةً وَلَأَجْرُ الْآخِرَةِ أَكْبَرُ﴾',
          'سورة مريم: صدر السورة وتلاوة قصة زكريا وعيسى عليهما السلام أمام النجاشي.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'البحث عن بيئات حرة تحمي كرامة الإنسان وتصون عقيدته ودعوته، واستثمار التحالفات العادلة ولو مع غير المسلمين.',
            themeArabic: 'فقه الهجرة والأمان الإنساني',
            sourceOrScholar: 'ابن إسحاق في السيرة',
          ),
          MoralLesson(
            lessonText: 'فصاحة الحوار وبلاغة الخطاب الدبلوماسي التي مثلها جعفر بن أبي طالب في عرض محاسن الإسلام دون مداهنة.',
            themeArabic: 'البلاغة الدبلوماسية وعزة المسلم',
            sourceOrScholar: 'الندوي في السيرة النبوية',
          ),
        ],
        version: 1,
      ),

      // 6. Boycott & Year of Sorrow
      SeerahEvent.create(
        eventId: 'evt_boycott_sorrow',
        title: 'مقاطعة شِعب أبي طالب وعام الحزن',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 3,
          isBeforeHijrah: true,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'من السنة 7 إلى 10 من البعثة (نحو 617 - 619 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad', 'person_khadijah', 'person_abu_bakr'],
        summary:
            'أجمعت قريش على ميثاق حصار شامل لبني هاشم وبني المطلب في شِعب أبي طالب، وكتبوا صحيفة ظالمة علقوها بجوف الكعبة تقضي بمقاطعتهم اقتصادياً واجتماعياً. استمر الحصار ثلاث سنوات قاسية حتى أكل الصحابة ورق الشجر وسُمع بكاء صبيانهم من وراء الشِعب، حتى قيّض الله رجالاً من قريش نقضوا الصحيفة ووجدوا دودة الأَرَضَة قد أكلت كل ما فيها إلا اسم الله. وبعد الخروج بفترة يسيرة، فُجع النبي ﷺ بوفاة عمه الحامي أبي طالب ثم رفيقة دربه خديجة رضي الله عنها، فسُمي ذلك العام بـ "عام الحزن".',
        evidenceLevel: HistoricalEvidenceLevel.strongReport,
        sourceIds: const ['src_bukhari_canonical'],
        moralLessons: const [
          MoralLesson(
            lessonText: 'الصبر الملحمي على الحصار والتجويع في سبيل المبدأ، وثبات المؤمنين وتماسكهم في أحلك الظروف.',
            themeArabic: 'الثبات تحت الحصار والمقاطعة',
            sourceOrScholar: 'ابن كثير في البداية والنهاية',
          ),
          MoralLesson(
            lessonText: 'فقد الأعوان البشريين (أبو طالب وخديجة) تهيئة لتعلق قلب النبي ﷺ والمؤمنين بالله وحده لا شريك له.',
            themeArabic: 'التجرد والاعتماد التام على الله',
            sourceOrScholar: 'الغزالي في فقه السيرة',
          ),
        ],
        version: 1,
      ),

      // 7. Ta'if Journey
      SeerahEvent.create(
        eventId: 'evt_taif_journey',
        title: 'رحلة الطائف ودعاء الاستنصار وإسلام الجن',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 3,
          isBeforeHijrah: true,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'شوال سنة 10 من البعثة (نحو 619 م)',
        ),
        locationId: 'place_taif',
        participantIds: const ['person_prophet_muhammad'],
        summary:
            'خرج النبي ﷺ راجلاً إلى الطائف يلتمس النصرة من ثقيف مع مولاه زيد بن حارثة. فقابله سادتهم بالجفاء وأغروا به سفهاءهم وعبيدهم فرموه بالحجارة حتى دميت قدماه الشريفتان وشُج رأس زيد وهو يحميه. فالتجأ إلى بستان عتبة وشيبة ابني ربيعة ودعا بدعائه الخالد: «اللهم إليك أشكو ضعف قوتي، وقلة حيلتي، وهواني على الناس، يا أرحم الراحمين... إن لم يكن بك علي غضب فلا أبالي»، وأسلم عداس النصراني خادم البستان. ولما أرسل الله ملك الجبال يطلب إذنه ليطبق عليهم الأخشَبين، أبى نبي الرحمة وقال: «بل أرجو أن يخرج الله من أصلابهم من يعبد الله وحده لا يشرك به شيئاً». وفي طريق العودة بوادي نخلة صرف الله إليه نفراً من الجن فاستمعوا القرآن وآمنوا.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة الأحقاف: ﴿وَإِذْ صَرَفْنَا إِلَيْكَ نَفَرًا مِّنَ الْجِنِّ يَسْتَمِعُونَ الْقُرْآنَ فَلَمَّا حَضَرُوهُ قَالُوا أَنصِتُوا فَلَمَّا قُضِيَ وَلَّوْا إِلَىٰ قَوْمِهِم مُّنذِرِينَ﴾',
          'سورة الجن: ﴿قُلْ أُوحِيَ إِلَيَّ أَنَّهُ اسْتَمَعَ نَفَرٌ مِّنَ الْجِنِّ فَقَالُوا إِنَّا سَمِعْنَا قُرْآنًا عَجَبًا﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث عائشة رضي الله عنها حين سألت النبي ﷺ: هل أتى عليك يوم كان أشد من يوم أحد؟ فقال: لقد لقيت من قومك ما لقيت، وكان أشد ما لقيت منهم يوم العقبة...',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'ذروة الرحمة النبوية المهداة: العفو ورفض الانتقام حتى عند التمكن التام استشرافاً لهداية أجيال المستقبل.',
            themeArabic: 'الرحمة المطلقة ورفض الانتقام',
            sourceOrScholar: 'ابن حجر في فتح الباري',
          ),
          MoralLesson(
            lessonText: 'دعاء الاستنصار في الطائف نموذج خالد لعبودية الافتقار الصادق والرضا المطلق بقضاء الله وحكمه.',
            themeArabic: 'الافتقار والالتجاء الصادق إلى الله',
            sourceOrScholar: 'ابن القيم في زاد المعاد',
          ),
        ],
        version: 1,
      ),

      // 8. Isra and Mi'raj
      SeerahEvent.create(
        eventId: 'evt_isra_miraj',
        title: 'معجزة الإسراء والمعراج وفرض الصلوات الخمس',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 3,
          isBeforeHijrah: true,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'قبل الهجرة بثلاث سنوات (نحو 620 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad', 'person_abu_bakr'],
        summary:
            'في أعقاب رحلة الطائف أسرى الله بنبيه ﷺ ليلاً على ظهر البُراق بصحبة جبريل عليه السلام من المسجد الحرام بمكة إلى المسجد الأقصى ببيت المقدس، فصلى بالأنبياء جميعاً إماماً في مشهد جامع لوحدة الرسالات. ثم عُرج به إلى السماوات السبع فرأى الأنبياء والجنة والنار، وتجاوز سدرة المنتهى حيث كلّمه ربه وفرض عليه الصلوات الخمسين، ثم خُففت بمراجعة موسى عليه السلام إلى خمس صلوات في العمل وخمسين في الأجر. ولما أصبح كذبته قريش فطلبوا منه وصف بيت المقدس فجلاه الله له حتى وصفه باباً بابا، وصدّقه أبو بكر الصديق فوراً قائلاً: «إن كان قال فقد صدق، إني لأصدقه في أبعد من ذلك في خبر السماء».',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة الإسراء: ﴿سُبْحَانَ الَّذِي أَسْرَىٰ بِعَبْدِهِ لَيْلًا مِّنَ الْمَسْجِدِ الْحَرَامِ إِلَى الْمَسْجِدِ الْأَقْصَى الَّذِي بَارَكْنَا حَوْلَهُ لِنُرِيَهُ مِنْ آيَاتِنَا إِنَّهُ هُوَ السَّمِيعُ الْبَصِيرُ﴾',
          'سورة النجم: ﴿وَلَقَدْ رَآهُ نَزْلَةً أُخْرَىٰ ۝ عِندَ سِدْرَةِ الْمُنتَهَىٰ ۝ عِندَهَا جَنَّةُ الْمَأْوَىٰ ۝ إِذْ يَغْشَى السِّدْرَةَ مَا يَغْشَىٰ ۝ مَا زَاغَ الْبَصَرُ وَمَا طَغَىٰ ۝ لَقَدْ رَأَىٰ مِنْ آيَاتِ رَبِّهِ الْكُبْرَىٰ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري وصحيح مسلم: حديث الإسراء والمعراج الطويل عن أنس بن مالك ومالك بن صعصعة رضي الله عنهما.',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'عظمة الصلاة ومنزلتها كفريضة فُرضت مباشرة في السماء دون واسطة وحبل وصل متين بين العبد وخالقه كل يوم.',
            themeArabic: 'قدسية الصلاة ومكانتها العلوية',
            sourceOrScholar: 'النووي في شرح صحيح مسلم',
          ),
          MoralLesson(
            lessonText: 'الرابطة العقدية والتاريخية الأبدية بين المسجد الحرام والمسجد الأقصى، وريادة أمة الإسلام لكافة الرسالات السماوية.',
            themeArabic: 'مركزية المسجد الأقصى وبركته',
            sourceOrScholar: 'ابن كثير في التفسير',
          ),
        ],
        version: 2,
      ),

      // 9. Aqabah Pledges
      SeerahEvent.create(
        eventId: 'evt_aqabah_second',
        title: 'بيعتا العقبة وإرسال مصعب بن عمير إلى يثرب',
        periodId: 'prd_makkan',
        historicalDate: const HistoricalDate(
          hijriYear: 1,
          isBeforeHijrah: true,
          precision: DatePrecision.exactDate,
          dateDisplay: 'مواسم الحج قبل الهجرة (نحو 621 - 622 م)',
        ),
        locationId: 'place_makkah',
        participantIds: const ['person_prophet_muhammad', 'person_musab'],
        summary:
            'كان النبي ﷺ يعرض دعوته على القبائل في مواسم الحج حتى لقي ستة نفر من الخزرج بيثرب فأسلموا. وفي العام التالي جاء اثنا عشر رجلاً فبايعوا بيعة العقبة الأولى على توحيد الله ومكارم الأخلاق، فأرسل معهم مصعب بن عمير أول سفير في الإسلام لتعليمهم القرآن، فدخل الإسلام كل بيوت المدينة وأسلم سيدا الأوس سعد بن معاذ وأسيد بن حضير. وفي موسم الحج التالي، اجتمع 73 رجلاً وامرأتان من الأنصار في شعب العقبة سراً وبايعوا النبي ﷺ بيعة العقبة الكبرى على السمع والطاعة والنفقة وحمايته مما يحمون منه نساءهم وأبناءهم، فاختار منهم 12 نقيباً، وتمهدت أرض الهجرة وبناء الدولة.',
        evidenceLevel: HistoricalEvidenceLevel.strongReport,
        sourceIds: const ['src_bukhari_canonical'],
        relatedHadithIds: const [
          'صحيح البخاري: حديث عبادة بن الصامت رضي الله عنه في بيعة العقبة: «بايعوني على أن لا تشركوا بالله شيئاً...».',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'التخطيط الاستراتيجي في بناء التحالفات وتأمين قاعدة صلبة ومستقرة لانطلاق الدعوة والدولة.',
            themeArabic: 'التخطيط الاستراتيجي وتأمين النصرة',
            sourceOrScholar: 'ابن هشام في السيرة',
          ),
          MoralLesson(
            lessonText: 'كفاءة الشباب في القيادة الدبلوماسية ونشر الفكر بالرفق والحجة كما جسده مصعب بن عمير رضي الله عنه.',
            themeArabic: 'دور الشباب ورسالتهم في التغيير',
            sourceOrScholar: 'السباعي في السيرة النبوية دروس وعبر',
          ),
        ],
        version: 2,
      ),

      // 10. Hijrah
      SeerahEvent.create(
        eventId: 'evt_hijrah',
        title: 'الهجرة النبوية الشريفة وتأسيس الدولة الإسلامية',
        periodId: 'prd_medinan_early',
        historicalDate: const HistoricalDate(
          hijriYear: 1,
          isBeforeHijrah: false,
          hijriMonth: 3,
          hijriDay: 12,
          precision: DatePrecision.exactDate,
          dateDisplay: '12 ربيع الأول 1 هـ (سبتمبر 622 م)',
        ),
        locationId: 'place_madinah',
        participantIds: const ['person_prophet_muhammad', 'person_abu_bakr', 'person_ali'],
        summary:
            'بعد مؤامرة دار الندوة لاغتيال النبي ﷺ بتفريق دمه بين القبائل، أذن الله له بالهجرة، فبات علي بن أبي طالب في فراشه الشريف فداءً لرد الأمانات وتمويهاً على قريش. خرج النبي ﷺ بصحبة أبي بكر الصديق إلى غار ثور فمكثا ثلاث ليالٍ والملائكة تحفهما وأبو بكر يرتجف خوفاً على رسول الله حتى قال له: «ما ظنك يا أبا بكر باثنين الله ثالثهما». ولما طاردهم سراقة بن مالك ساخت قوائم فرسه في الأرض فاستأمن وبشره بسواري كسرى. وصل الركب إلى قباء فأسس أول مسجد، ثم دخل يثرب وسط استقبال تاريخي حافل وفرحة غامرة من الأنصار والصغار ينشدون طلع البدر علينا.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
        relatedQuranAyahs: const [
          'سورة التوبة: ﴿إِلَّا تَنصُرُوهُ فَقَدْ نَصَرَهُ اللَّهُ إِذْ أَخْرَجَهُ الَّذِينَ كَفَرُوا ثَانِيَ اثْنَيْنِ إِذْ هُمَا فِي الْغَارِ إِذْ يَقُولُ لِصَاحِبِهِ لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا فَأَنزَلَ اللَّهُ سَكِينَتَهُ عَلَيْهِ وَأَيَّدَهُ بِجُنُودٍ لَّمْ تَرَوْهَا﴾',
          'سورة الأنفال: ﴿وَإِذْ يَمْكُرُ بِكَ الَّذِينَ كَفَرُوا لِيُثْبِتُوكَ أَوْ يَقْتُلُوكَ أَوْ يُخْرِجُوكَ وَيَمْكُرُونَ وَيَمْكُرُ اللَّهُ وَاللَّهُ خَيْرُ الْمَاكِرِينَ﴾',
        ],
        relatedHadithIds: const [
          'صحيح البخاري: حديث أبي بكر رضي الله عنه: «قلت للنبي ﷺ وأنا في الغار: لو أن أحدهم نظر تحت قدميه لأبصرنا، فقال: ما ظنك يا أبا بكر باثنين الله ثالثهما».',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'استنفاد كافة الأسباب والاحتياطات المادية والدقيقة في التخطيط (الدليل، الراعي، التوقيت، الطريق المعاكس) مقرونة بالتوكل اليقيني على الله.',
            themeArabic: 'الجمع بين الأخذ بالأسباب والتوكل',
            sourceOrScholar: 'ابن حجر في فتح الباري',
          ),
          MoralLesson(
            lessonText: 'فداء علي بن أبي طالب العظيم وتضحيته بنفسه يعلم الأجيال معنى التضحية بالروح لحماية القيادة والدعوة.',
            themeArabic: 'الفداء والتضحية بالنفس للمبدأ',
            sourceOrScholar: 'الذهبي في سير أعلام النبلاء',
          ),
        ],
        version: 2,
      ),

      // 11. Mosque, Brotherhood & Constitution
      SeerahEvent.create(
        eventId: 'evt_mosque_brotherhood',
        title: 'بناء المسجد النبوي والمؤاخاة ووثيقة المدينة',
        periodId: 'prd_medinan_early',
        historicalDate: const HistoricalDate(
          hijriYear: 1,
          isBeforeHijrah: false,
          precision: DatePrecision.approximateDate,
          dateDisplay: 'العام الأول من الهجرة (نحو 622 - 623 م)',
        ),
        locationId: 'place_madinah',
        participantIds: ['person_prophet_muhammad', 'person_abu_bakr', 'person_bilal', 'person_salman'],
        summary:
            'وضع النبي ﷺ أعمدة المجتمع الإسلامي في يثرب بثلاثة أركان مؤسسية كبرى: أولاً: بناء المسجد النبوي الشريف مركزاً للعبادة والعلم والشورى وإدارة شؤون الأمة وشارك في بنائه بنفسه. ثانياً: المؤاخاة التاريخية المعجزة بين المهاجرين والأنصار في دار أنس بن مالك ليتقاسموا الأموال والدور والإيثار حتى قال الله فيهم ﴿وَيُؤْثِرُونَ عَلَىٰ أَنفُسِهِمْ وَلَوْ كَانَ بِهِمْ خَصَاصَةٌ﴾. ثالثاً: صياغة "وثيقة المدينة" كأول دستور مدني وحقوقي في التاريخ يحدد حقوق المواطنة والتعايش السلمي وينظم العلاقات بين المسلمين واليهود وسائر القبائل في إطار العدل والواجبات المشتركة.',
        evidenceLevel: HistoricalEvidenceLevel.primarySource,
        sourceIds: const ['src_bukhari_canonical'],
        relatedQuranAyahs: const [
          'سورة الحشر: ﴿وَالَّذِينَ تَبَوَّءُوا الدَّارَ وَالإِيمَانَ مِن قَبْلِهِمْ يُحِبُّونَ مَنْ هَاجَرَ إِلَيْهِمْ وَلَا يَجِدُونَ فِي صُدُورِهِمْ حَاجَةً مِّمَّا أُوتُوا وَيُؤْثِرُونَ عَلَىٰ أَنفُسِهِمْ وَلَوْ كَانَ بِهِمْ خَصَاصَةٌ﴾',
          'سورة التوبة: ﴿لَّمَسْجِدٌ أُسِّسَ عَلَى التَّقْوَىٰ مِنْ أَوَّلِ يَوْمٍ أَحَقُّ أَن تَقُومَ فِيهِ﴾',
        ],
        moralLessons: const [
          MoralLesson(
            lessonText: 'المسجد ليس مجرد مكان لأداء الشعائر بل هو قلب المجتمع النابض بالحياة، يجمع الروح والفكر والدولة والأخوة.',
            themeArabic: 'شمولية دور المسجد في الإسلام',
            sourceOrScholar: 'الغزالي في فقه السيرة',
          ),
          MoralLesson(
            lessonText: 'السبق الدستوري الإسلامي في إرساء وثيقة المدينة القائمة على التعايش السلمي، والمواطنة، وسيادة القانون، والعدل الاجتماعي.',
            themeArabic: 'العدالة الدستورية وإدارة التنوع',
            sourceOrScholar: 'الدكتور محمد حميد الله في وثائق العهد النبوي',
          ),
        ],
        version: 2,
      ),
    ];
  }
}
