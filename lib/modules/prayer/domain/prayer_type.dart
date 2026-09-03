/// Canonical prayer and astronomical solar transition types.
enum PrayerType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  sunset,
  maghrib,
  isha,
  imsak,
  midnight,
  lastThirdOfNight,
}

extension PrayerTypeX on PrayerType {
  String get nameArabic {
    switch (this) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.sunrise:
        return 'الشروق';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.sunset:
        return 'الغروب';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
      case PrayerType.imsak:
        return 'الإمساك';
      case PrayerType.midnight:
        return 'منتصف الليل';
      case PrayerType.lastThirdOfNight:
        return 'الثلث الأخير من الليل';
    }
  }

  String get nameEnglish {
    switch (this) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.sunrise:
        return 'Sunrise';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.sunset:
        return 'Sunset';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
      case PrayerType.imsak:
        return 'Imsak';
      case PrayerType.midnight:
        return 'Midnight';
      case PrayerType.lastThirdOfNight:
        return 'Last Third of Night';
    }
  }

  /// True if this type represents one of the five obligatory daily prayers.
  bool get isObligatoryPrayer {
    switch (this) {
      case PrayerType.fajr:
      case PrayerType.dhuhr:
      case PrayerType.asr:
      case PrayerType.maghrib:
      case PrayerType.isha:
        return true;
      default:
        return false;
    }
  }
}
