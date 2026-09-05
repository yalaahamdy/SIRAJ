import '../../../../modules/seerah/domain/historical_place.dart';

/// Comprehensive canonical dataset for Seerah & Islamic History Places (§11, §28, §29).
class SeerahPlacesData {
  static List<HistoricalPlace> getPlaces() {
    return [
      HistoricalPlace.create(
        placeId: 'place_makkah',
        nameArabic: 'مكة المكرمة (البلد الحرام)',
        modernName: 'مدينة مكة المكرمة بالمملكة العربية السعودية',
        region: 'الحجاز',
        latitude: 21.4225,
        longitude: 39.8262,
        geographicalDescription:
            'البلد الحرام ومهبط الوحي ومولد النبي ﷺ ومقر الكعبة المشرفة والمسجد الحرام، وفيه دار الأرقم وشعب بني هاشم وبدء مسيرة الدعوة.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_hira',
        nameArabic: 'غار حراء بجبل النور',
        modernName: 'جبل النور شمال شرق مكة المكرمة',
        region: 'الحجاز',
        latitude: 21.4578,
        longitude: 39.8592,
        geographicalDescription:
            'الغار الواقع في أعلى جبل النور، كان النبي ﷺ يخلو فيه للتعبد والتحنث الليالي ذوات العدد، وفيه هبط أمين الوحي جبريل عليه السلام بأول آيات القرآن: ﴿اقْرَأْ بِاسْمِ رَبِّكَ﴾.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_thawr',
        nameArabic: 'غار ثور بجبل ثور',
        modernName: 'جبل ثور جنوب مكة المكرمة',
        region: 'الحجاز',
        latitude: 21.3789,
        longitude: 39.8519,
        geographicalDescription:
            'الغار الواقع في جبل ثور الشامخ جنوب مكة، التجأ إليه النبي ﷺ وصاحبه أبو بكر الصديق ثلاث ليالٍ إبان الهجرة النبوية المباركة تحت رعاية الله وعنايته.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_madinah',
        nameArabic: 'المدينة المنورة (طيبة الطيبة)',
        modernName: 'المدينة المنورة بالمملكة العربية السعودية',
        region: 'الحجاز',
        latitude: 24.4672,
        longitude: 39.6111,
        geographicalDescription:
            'يثرب المباركة، دار الهجرة ومستقر رسول الله ﷺ وعاصمة الإسلام الأولى ومنطلق الفتوحات والتشريع، وموطن مسجده الشريف وروضته الطاهرة وقبره الشريف.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_quba',
        nameArabic: 'مسجد قباء ومشارف المدينة',
        modernName: 'حي قباء بالمدينة المنورة',
        region: 'المدينة المنورة',
        latitude: 24.4392,
        longitude: 39.6172,
        geographicalDescription:
            'أول مسجد أُسس على التقوى في الإسلام، نزل به النبي ﷺ عند قدومه مهاجراً من مكة وبنى فيه مسجده قبل دخول قلب يثرب، وتفضلت الصلاة فيه كأجر عمرة.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_badr',
        nameArabic: 'موضع ماء بدر',
        modernName: 'محافظة بدر بمنطقة المدينة المنورة',
        region: 'الحجاز',
        latitude: 23.7833,
        longitude: 38.7833,
        geographicalDescription:
            'موضع ماء ومحطة قوافل تاريخية شهيرة على طريق الشام، دارت عنده معركة بدر الكبرى (يوم الفرقان) في 17 رمضان 2 هـ وتحقق فيه النصر الأول الفاصل للمسلمين.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_uhud',
        nameArabic: 'جبل أحد ومقبرة الشهداء',
        modernName: 'شمال المسجد النبوي بالمدينة المنورة',
        region: 'المدينة المنورة',
        latitude: 24.5034,
        longitude: 39.6120,
        geographicalDescription:
            'جبل مهيب يحبه المسلمون ويحبهم كما ثبت في الحديث الصحيح، وقعت عنده غزوة أحد في شوال 3 هـ وفيه جبل الرماة ومقبرة سيد الشهداء حمزة وسبعين من صحابة رسول الله ﷺ.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_khandaq',
        nameArabic: 'الخندق وموضع المساجد السبعة بجبل سلع',
        modernName: 'الجهة الشمالية الغربية للمدينة المنورة',
        region: 'المدينة المنورة',
        latitude: 24.4756,
        longitude: 39.5983,
        geographicalDescription:
            'موقع حفر الخندق الدفاعي العظيم في غزوة الأحزاب 5 هـ شمال المدينة بمشورة سلمان الفارسي رضي الله عنه لصد تحالف قبائل قريش وغطفان.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_hudaybiyyah',
        nameArabic: 'الحديبية (موضع الشجرة)',
        modernName: 'منطقة الشميسي غرب مكة المكرمة',
        region: 'مكة المكرمة',
        latitude: 21.4361,
        longitude: 39.6389,
        geographicalDescription:
            'موضع بيعة الرضوان الخالدة تحت الشجرة وصلح الحديبية التاريخي في ذي القعدة 6 هـ والذي سماه القرآن فتحاً مبيناً وهيأ لنشر الإسلام عالمياً.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_khaybar',
        nameArabic: 'واحة وحصون خيبر',
        modernName: 'محافظة خيبر شمال المدينة المنورة بنحو 165 كم',
        region: 'خيبر',
        latitude: 25.6983,
        longitude: 39.2906,
        geographicalDescription:
            'واحة خصبة محصنة كانت المعقل الأكبر ليهود الحجاز وتضم حصوناً منيعة (كالناعم والقموص والوطيح)، فتحها المسلمون في محرم 7 هـ بقيادة النبي ﷺ وبطولة علي بن أبي طالب.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_mutah',
        nameArabic: 'موضع سرية مؤتة',
        modernName: 'بلدة مؤتة بمحافظة الكرك بالمملكة الأردنية الهاشمية',
        region: 'بلاد الشام',
        latitude: 31.0961,
        longitude: 35.7003,
        geographicalDescription:
            'ساحة ملحمة مؤتة الخالدة في جمادى الأولى 8 هـ، أول مواجهة كبرى للمسلمين ضد الروم الغساسنة، واستشهد فيها القادة الثلاثة: زيد وجعفر وابن رواحة رضي الله عنهم.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_hunayn',
        nameArabic: 'وادي حنين',
        modernName: 'وادي حنين بين مكة المكرمة ومدينة الطائف',
        region: 'الحجاز',
        latitude: 21.4722,
        longitude: 40.0917,
        geographicalDescription:
            'الوادي الفسيح الذي وقعت فيه غزوة حنين الكبرى في شوال 8 هـ ضد هوازن وثقيف، وشهد ثبات النبي ﷺ الراسخ بعد الكمين ونزول سكينة الله ونصر المؤمنين.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_tabuk',
        nameArabic: 'تبوك وموضع عين السكر',
        modernName: 'مدينة تبوك شمال غرب المملكة العربية السعودية',
        region: 'شمال الجزيرة العربية',
        latitude: 28.3835,
        longitude: 36.5662,
        geographicalDescription:
            'أبعد نقطة بلغها النبي ﷺ في غزواته مع جيش العسرة في رجب 9 هـ لملاقاة حشود الروم، وشهدت عين تبوك المباركة ومصالحة قبائل الشمال وإظهار هيبة الدولة الإسلامية.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical', 'src_muslim_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_arafat',
        nameArabic: 'صعيد عرفات ومسجد نمرة',
        modernName: 'مشعر عرفات بمكة المكرمة',
        region: 'مكة المكرمة',
        latitude: 21.3549,
        longitude: 39.9841,
        geographicalDescription:
            'الموقف الأعظم للحج وموضع خطبة الوداع الخالدة في 9 ذي الحجة 10 هـ حيث أرسى النبي ﷺ قواعد العدالة وحقوق الإنسان وحرمة الدماء والأموال وكمال الدين.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_muslim_canonical'],
      ),
      HistoricalPlace.create(
        placeId: 'place_taif',
        nameArabic: 'مدينة الطائف وبساتينها',
        modernName: 'مدينة الطائف بالمملكة العربية السعودية',
        region: 'الحجاز',
        latitude: 21.2854,
        longitude: 40.4222,
        geographicalDescription:
            'موطن قبيلة ثقيف، خرج إليها النبي ﷺ ماشياً في عام الحزن يلتمس النصرة فآذوه ودعا دعاءه الخالد، وحاصرها المسلمون بعد غزوة حنين سنة 8 هـ قبل إسلام أهلها.',
        certainty: PlaceCertainty.high,
        sourceIds: const ['src_bukhari_canonical'],
      ),
    ];
  }
}
