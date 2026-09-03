import 'location_models.dart';

/// Comprehensive canonical city preset for manual location fallback (§10, §11, §30).
class CanonicalCityPreset {
  final String cityNameArabic;
  final String cityNameEnglish;
  final String countryNameArabic;
  final String countryNameEnglish;
  final GeoCoordinates coordinates;

  const CanonicalCityPreset({
    required this.cityNameArabic,
    required this.cityNameEnglish,
    required this.countryNameArabic,
    required this.countryNameEnglish,
    required this.coordinates,
  });

  /// 50+ Curated world and Islamic cities covering all hemispheres and continents.
  static const List<CanonicalCityPreset> canonicalPresets = [
    // Sacred & Historical Islamic Centers
    CanonicalCityPreset(
      cityNameArabic: 'مكة المكرمة',
      cityNameEnglish: 'Makkah',
      countryNameArabic: 'المملكة العربية السعودية',
      countryNameEnglish: 'Saudi Arabia',
      coordinates: GeoCoordinates(
        latitude: 21.4225,
        longitude: 39.8262,
        source: LocationSource.manual,
        cityName: 'مكة المكرمة',
        countryName: 'المملكة العربية السعودية',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'المدينة المنورة',
      cityNameEnglish: 'Madinah',
      countryNameArabic: 'المملكة العربية السعودية',
      countryNameEnglish: 'Saudi Arabia',
      coordinates: GeoCoordinates(
        latitude: 24.4672,
        longitude: 39.6111,
        source: LocationSource.manual,
        cityName: 'المدينة المنورة',
        countryName: 'المملكة العربية السعودية',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'القدس الشريف',
      cityNameEnglish: 'Jerusalem',
      countryNameArabic: 'فلسطين',
      countryNameEnglish: 'Palestine',
      coordinates: GeoCoordinates(
        latitude: 31.7683,
        longitude: 35.2137,
        source: LocationSource.manual,
        cityName: 'القدس الشريف',
        countryName: 'فلسطين',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'الرياض',
      cityNameEnglish: 'Riyadh',
      countryNameArabic: 'المملكة العربية السعودية',
      countryNameEnglish: 'Saudi Arabia',
      coordinates: GeoCoordinates(
        latitude: 24.7136,
        longitude: 46.6753,
        source: LocationSource.manual,
        cityName: 'الرياض',
        countryName: 'المملكة العربية السعودية',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'جدة',
      cityNameEnglish: 'Jeddah',
      countryNameArabic: 'المملكة العربية السعودية',
      countryNameEnglish: 'Saudi Arabia',
      coordinates: GeoCoordinates(
        latitude: 21.5433,
        longitude: 39.1728,
        source: LocationSource.manual,
        cityName: 'جدة',
        countryName: 'المملكة العربية السعودية',
      ),
    ),

    // Arab & Middle East Capitals
    CanonicalCityPreset(
      cityNameArabic: 'القاهرة',
      cityNameEnglish: 'Cairo',
      countryNameArabic: 'جمهورية مصر العربية',
      countryNameEnglish: 'Egypt',
      coordinates: GeoCoordinates(
        latitude: 30.0444,
        longitude: 31.2357,
        source: LocationSource.manual,
        cityName: 'القاهرة',
        countryName: 'مصر',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'الإسكندرية',
      cityNameEnglish: 'Alexandria',
      countryNameArabic: 'جمهورية مصر العربية',
      countryNameEnglish: 'Egypt',
      coordinates: GeoCoordinates(
        latitude: 31.2001,
        longitude: 29.9187,
        source: LocationSource.manual,
        cityName: 'الإسكندرية',
        countryName: 'مصر',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'عمّان',
      cityNameEnglish: 'Amman',
      countryNameArabic: 'المملكة الأردنية الهاشمية',
      countryNameEnglish: 'Jordan',
      coordinates: GeoCoordinates(
        latitude: 31.9454,
        longitude: 35.9284,
        source: LocationSource.manual,
        cityName: 'عمّان',
        countryName: 'الأردن',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'دمشق',
      cityNameEnglish: 'Damascus',
      countryNameArabic: 'الجمهورية العربية السورية',
      countryNameEnglish: 'Syria',
      coordinates: GeoCoordinates(
        latitude: 33.5138,
        longitude: 36.2765,
        source: LocationSource.manual,
        cityName: 'دمشق',
        countryName: 'سوريا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'بيروت',
      cityNameEnglish: 'Beirut',
      countryNameArabic: 'الجمهورية اللبنانية',
      countryNameEnglish: 'Lebanon',
      coordinates: GeoCoordinates(
        latitude: 33.8938,
        longitude: 35.5018,
        source: LocationSource.manual,
        cityName: 'بيروت',
        countryName: 'لبنان',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'بغداد',
      cityNameEnglish: 'Baghdad',
      countryNameArabic: 'جمهورية العراق',
      countryNameEnglish: 'Iraq',
      coordinates: GeoCoordinates(
        latitude: 33.3152,
        longitude: 44.3661,
        source: LocationSource.manual,
        cityName: 'بغداد',
        countryName: 'العراق',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'الكويت',
      cityNameEnglish: 'Kuwait City',
      countryNameArabic: 'دولة الكويت',
      countryNameEnglish: 'Kuwait',
      coordinates: GeoCoordinates(
        latitude: 29.3759,
        longitude: 47.9774,
        source: LocationSource.manual,
        cityName: 'الكويت',
        countryName: 'الكويت',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'الدوحة',
      cityNameEnglish: 'Doha',
      countryNameArabic: 'دولة قطر',
      countryNameEnglish: 'Qatar',
      coordinates: GeoCoordinates(
        latitude: 25.2854,
        longitude: 51.5310,
        source: LocationSource.manual,
        cityName: 'الدوحة',
        countryName: 'قطر',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'أبوظبي',
      cityNameEnglish: 'Abu Dhabi',
      countryNameArabic: 'الإمارات العربية المتحدة',
      countryNameEnglish: 'United Arab Emirates',
      coordinates: GeoCoordinates(
        latitude: 24.4539,
        longitude: 54.3773,
        source: LocationSource.manual,
        cityName: 'أبوظبي',
        countryName: 'الإمارات',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'دبي',
      cityNameEnglish: 'Dubai',
      countryNameArabic: 'الإمارات العربية المتحدة',
      countryNameEnglish: 'United Arab Emirates',
      coordinates: GeoCoordinates(
        latitude: 25.2048,
        longitude: 55.2708,
        source: LocationSource.manual,
        cityName: 'دبي',
        countryName: 'الإمارات',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'مسقط',
      cityNameEnglish: 'Muscat',
      countryNameArabic: 'سلطنة عمان',
      countryNameEnglish: 'Oman',
      coordinates: GeoCoordinates(
        latitude: 23.5880,
        longitude: 58.3829,
        source: LocationSource.manual,
        cityName: 'مسقط',
        countryName: 'عمان',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'المنامة',
      cityNameEnglish: 'Manama',
      countryNameArabic: 'مملكة البحرين',
      countryNameEnglish: 'Bahrain',
      coordinates: GeoCoordinates(
        latitude: 26.2285,
        longitude: 50.5860,
        source: LocationSource.manual,
        cityName: 'المنامة',
        countryName: 'البحرين',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'صنعاء',
      cityNameEnglish: 'Sanaa',
      countryNameArabic: 'الجمهورية اليمنية',
      countryNameEnglish: 'Yemen',
      coordinates: GeoCoordinates(
        latitude: 15.3694,
        longitude: 44.1910,
        source: LocationSource.manual,
        cityName: 'صنعاء',
        countryName: 'اليمن',
      ),
    ),

    // North Africa
    CanonicalCityPreset(
      cityNameArabic: 'الخرطوم',
      cityNameEnglish: 'Khartoum',
      countryNameArabic: 'جمهورية السودان',
      countryNameEnglish: 'Sudan',
      coordinates: GeoCoordinates(
        latitude: 15.5007,
        longitude: 32.5599,
        source: LocationSource.manual,
        cityName: 'الخرطوم',
        countryName: 'السودان',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'طرابلس',
      cityNameEnglish: 'Tripoli',
      countryNameArabic: 'دولة ليبيا',
      countryNameEnglish: 'Libya',
      coordinates: GeoCoordinates(
        latitude: 32.8872,
        longitude: 13.1913,
        source: LocationSource.manual,
        cityName: 'طرابلس',
        countryName: 'ليبيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'تونس',
      cityNameEnglish: 'Tunis',
      countryNameArabic: 'الجمهورية التونسية',
      countryNameEnglish: 'Tunisia',
      coordinates: GeoCoordinates(
        latitude: 36.8065,
        longitude: 10.1815,
        source: LocationSource.manual,
        cityName: 'تونس',
        countryName: 'تونس',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'الجزائر',
      cityNameEnglish: 'Algiers',
      countryNameArabic: 'الجمهورية الجزائرية',
      countryNameEnglish: 'Algeria',
      coordinates: GeoCoordinates(
        latitude: 36.7538,
        longitude: 3.0588,
        source: LocationSource.manual,
        cityName: 'الجزائر',
        countryName: 'الجزائر',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'الرباط',
      cityNameEnglish: 'Rabat',
      countryNameArabic: 'المملكة المغربية',
      countryNameEnglish: 'Morocco',
      coordinates: GeoCoordinates(
        latitude: 34.0209,
        longitude: -6.8416,
        source: LocationSource.manual,
        cityName: 'الرباط',
        countryName: 'المغرب',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'الدار البيضاء',
      cityNameEnglish: 'Casablanca',
      countryNameArabic: 'المملكة المغربية',
      countryNameEnglish: 'Morocco',
      coordinates: GeoCoordinates(
        latitude: 33.5731,
        longitude: -7.5898,
        source: LocationSource.manual,
        cityName: 'الدار البيضاء',
        countryName: 'المغرب',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'نواكشوط',
      cityNameEnglish: 'Nouakchott',
      countryNameArabic: 'الجمهورية الإسلامية الموريتانية',
      countryNameEnglish: 'Mauritania',
      coordinates: GeoCoordinates(
        latitude: 18.0735,
        longitude: -15.9582,
        source: LocationSource.manual,
        cityName: 'نواكشوط',
        countryName: 'موريتانيا',
      ),
    ),

    // Asia & Turkey
    CanonicalCityPreset(
      cityNameArabic: 'إسطنبول',
      cityNameEnglish: 'Istanbul',
      countryNameArabic: 'الجمهورية التركية',
      countryNameEnglish: 'Turkey',
      coordinates: GeoCoordinates(
        latitude: 41.0082,
        longitude: 28.9784,
        source: LocationSource.manual,
        cityName: 'إسطنبول',
        countryName: 'تركيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'أنقرة',
      cityNameEnglish: 'Ankara',
      countryNameArabic: 'الجمهورية التركية',
      countryNameEnglish: 'Turkey',
      coordinates: GeoCoordinates(
        latitude: 39.9334,
        longitude: 32.8597,
        source: LocationSource.manual,
        cityName: 'أنقرة',
        countryName: 'تركيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'جاكرتا',
      cityNameEnglish: 'Jakarta',
      countryNameArabic: 'جمهورية إندونيسيا',
      countryNameEnglish: 'Indonesia',
      coordinates: GeoCoordinates(
        latitude: -6.2088,
        longitude: 106.8456,
        source: LocationSource.manual,
        cityName: 'جاكرتا',
        countryName: 'إندونيسيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'كوالالمبور',
      cityNameEnglish: 'Kuala Lumpur',
      countryNameArabic: 'ماليزيا',
      countryNameEnglish: 'Malaysia',
      coordinates: GeoCoordinates(
        latitude: 3.1390,
        longitude: 101.6869,
        source: LocationSource.manual,
        cityName: 'كوالالمبور',
        countryName: 'ماليزيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'إسلام آباد',
      cityNameEnglish: 'Islamabad',
      countryNameArabic: 'جمهورية باكستان الإسلامية',
      countryNameEnglish: 'Pakistan',
      coordinates: GeoCoordinates(
        latitude: 33.6844,
        longitude: 73.0479,
        source: LocationSource.manual,
        cityName: 'إسلام آباد',
        countryName: 'باكستان',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'كراتشي',
      cityNameEnglish: 'Karachi',
      countryNameArabic: 'جمهورية باكستان الإسلامية',
      countryNameEnglish: 'Pakistan',
      coordinates: GeoCoordinates(
        latitude: 24.8607,
        longitude: 67.0011,
        source: LocationSource.manual,
        cityName: 'كراتشي',
        countryName: 'باكستان',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'دكا',
      cityNameEnglish: 'Dhaka',
      countryNameArabic: 'جمهورية بنغلاديش الشعبية',
      countryNameEnglish: 'Bangladesh',
      coordinates: GeoCoordinates(
        latitude: 23.8103,
        longitude: 90.4125,
        source: LocationSource.manual,
        cityName: 'دكا',
        countryName: 'بنغلاديش',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'نيودلهي',
      cityNameEnglish: 'New Delhi',
      countryNameArabic: 'جمهورية الهند',
      countryNameEnglish: 'India',
      coordinates: GeoCoordinates(
        latitude: 28.6139,
        longitude: 77.2090,
        source: LocationSource.manual,
        cityName: 'نيودلهي',
        countryName: 'الهند',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'طشقند',
      cityNameEnglish: 'Tashkent',
      countryNameArabic: 'جمهورية أوزبكستان',
      countryNameEnglish: 'Uzbekistan',
      coordinates: GeoCoordinates(
        latitude: 41.2995,
        longitude: 69.2401,
        source: LocationSource.manual,
        cityName: 'طشقند',
        countryName: 'أوزبكستان',
      ),
    ),

    // Europe
    CanonicalCityPreset(
      cityNameArabic: 'لندن',
      cityNameEnglish: 'London',
      countryNameArabic: 'المملكة المتحدة',
      countryNameEnglish: 'United Kingdom',
      coordinates: GeoCoordinates(
        latitude: 51.5074,
        longitude: -0.1278,
        source: LocationSource.manual,
        cityName: 'لندن',
        countryName: 'بريطانيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'باريس',
      cityNameEnglish: 'Paris',
      countryNameArabic: 'الجمهورية الفرنسية',
      countryNameEnglish: 'France',
      coordinates: GeoCoordinates(
        latitude: 48.8566,
        longitude: 2.3522,
        source: LocationSource.manual,
        cityName: 'باريس',
        countryName: 'فرنسا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'برلين',
      cityNameEnglish: 'Berlin',
      countryNameArabic: 'جمهورية ألمانيا الاتحادية',
      countryNameEnglish: 'Germany',
      coordinates: GeoCoordinates(
        latitude: 52.5200,
        longitude: 13.4050,
        source: LocationSource.manual,
        cityName: 'برلين',
        countryName: 'ألمانيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'مدريد',
      cityNameEnglish: 'Madrid',
      countryNameArabic: 'مملكة إسبانيا',
      countryNameEnglish: 'Spain',
      coordinates: GeoCoordinates(
        latitude: 40.4168,
        longitude: -3.7038,
        source: LocationSource.manual,
        cityName: 'مدريد',
        countryName: 'إسبانيا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'روما',
      cityNameEnglish: 'Rome',
      countryNameArabic: 'الجمهورية الإيطالية',
      countryNameEnglish: 'Italy',
      coordinates: GeoCoordinates(
        latitude: 41.9028,
        longitude: 12.4964,
        source: LocationSource.manual,
        cityName: 'روما',
        countryName: 'إيطاليا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'سراييفو',
      cityNameEnglish: 'Sarajevo',
      countryNameArabic: 'البوسنة والهرسك',
      countryNameEnglish: 'Bosnia and Herzegovina',
      coordinates: GeoCoordinates(
        latitude: 43.8563,
        longitude: 18.4131,
        source: LocationSource.manual,
        cityName: 'سراييفو',
        countryName: 'البوسنة',
      ),
    ),

    // Americas & Oceania
    CanonicalCityPreset(
      cityNameArabic: 'نيويورك',
      cityNameEnglish: 'New York',
      countryNameArabic: 'الولايات المتحدة الأمريكية',
      countryNameEnglish: 'United States',
      coordinates: GeoCoordinates(
        latitude: 40.7128,
        longitude: -74.0060,
        source: LocationSource.manual,
        cityName: 'نيويورك',
        countryName: 'أمريكا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'واشنطن',
      cityNameEnglish: 'Washington D.C.',
      countryNameArabic: 'الولايات المتحدة الأمريكية',
      countryNameEnglish: 'United States',
      coordinates: GeoCoordinates(
        latitude: 38.9072,
        longitude: -77.0369,
        source: LocationSource.manual,
        cityName: 'واشنطن',
        countryName: 'أمريكا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'شيكاغو',
      cityNameEnglish: 'Chicago',
      countryNameArabic: 'الولايات المتحدة الأمريكية',
      countryNameEnglish: 'United States',
      coordinates: GeoCoordinates(
        latitude: 41.8781,
        longitude: -87.6298,
        source: LocationSource.manual,
        cityName: 'شيكاغو',
        countryName: 'أمريكا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'تورونتو',
      cityNameEnglish: 'Toronto',
      countryNameArabic: 'كندا',
      countryNameEnglish: 'Canada',
      coordinates: GeoCoordinates(
        latitude: 43.6532,
        longitude: -79.3832,
        source: LocationSource.manual,
        cityName: 'تورونتو',
        countryName: 'كندا',
      ),
    ),
    CanonicalCityPreset(
      cityNameArabic: 'سيدني',
      cityNameEnglish: 'Sydney',
      countryNameArabic: 'أستراليا',
      countryNameEnglish: 'Australia',
      coordinates: GeoCoordinates(
        latitude: -33.8688,
        longitude: 151.2093,
        source: LocationSource.manual,
        cityName: 'سيدني',
        countryName: 'أستراليا',
      ),
    ),
  ];

  /// Filters cities by Arabic or English query string.
  static List<CanonicalCityPreset> search(String query) {
    if (query.trim().isEmpty) return canonicalPresets;
    final q = query.trim().toLowerCase();
    return canonicalPresets.where((preset) {
      return preset.cityNameArabic.toLowerCase().contains(q) ||
          preset.cityNameEnglish.toLowerCase().contains(q) ||
          preset.countryNameArabic.toLowerCase().contains(q) ||
          preset.countryNameEnglish.toLowerCase().contains(q);
    }).toList();
  }
}
