import 'package:flutter/widgets.dart';

/// Central localization manager.
/// Arabic is the primary and default language.
class LocaleManager {
  static const Locale arabicLocale = Locale('ar');
  static const Locale englishLocale = Locale('en');

  static const List<Locale> supportedLocales = [
    arabicLocale,
    englishLocale,
  ];

  Locale _currentLocale = arabicLocale;

  Locale get currentLocale => _currentLocale;

  bool get isRtl => _currentLocale.languageCode == 'ar';

  TextDirection get textDirection => isRtl ? TextDirection.rtl : TextDirection.ltr;

  void setLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      _currentLocale = locale;
    }
  }
}
