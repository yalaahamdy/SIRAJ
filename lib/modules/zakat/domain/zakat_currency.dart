import 'package:equatable/equatable.dart';

/// Supported currencies for Zakat evaluation and display (§7, §134).
class ZakatCurrency extends Equatable {
  final String code; // ISO 4217 code (e.g. 'EGP', 'SAR', 'USD')
  final String symbolArabic; // Local Arabic representation (e.g. 'ج.م', 'ر.س')
  final String nameArabic; // Arabic name
  final String nameEnglish; // English name
  final int decimals; // Decimal places (2 for most, 3 for KWD/BHD/OMR/JOD)

  const ZakatCurrency({
    required this.code,
    required this.symbolArabic,
    required this.nameArabic,
    required this.nameEnglish,
    this.decimals = 2,
  });

  /// Egyptian Pound (EGP) — Mandatory Default for SIRAJ Zakat Experience
  static const ZakatCurrency egp = ZakatCurrency(
    code: 'EGP',
    symbolArabic: 'ج.م',
    nameArabic: 'الجنيه المصري',
    nameEnglish: 'Egyptian Pound',
    decimals: 2,
  );

  static const ZakatCurrency sar = ZakatCurrency(
    code: 'SAR',
    symbolArabic: 'ر.س',
    nameArabic: 'الريال السعودي',
    nameEnglish: 'Saudi Riyal',
    decimals: 2,
  );

  static const ZakatCurrency usd = ZakatCurrency(
    code: 'USD',
    symbolArabic: '\$',
    nameArabic: 'الدولار الأمريكي',
    nameEnglish: 'US Dollar',
    decimals: 2,
  );

  static const ZakatCurrency aed = ZakatCurrency(
    code: 'AED',
    symbolArabic: 'د.إ',
    nameArabic: 'الدرهم الإماراتي',
    nameEnglish: 'UAE Dirham',
    decimals: 2,
  );

  static const ZakatCurrency kwd = ZakatCurrency(
    code: 'KWD',
    symbolArabic: 'د.ك',
    nameArabic: 'الدينار الكويتي',
    nameEnglish: 'Kuwaiti Dinar',
    decimals: 3,
  );

  static const ZakatCurrency qar = ZakatCurrency(
    code: 'QAR',
    symbolArabic: 'ر.ق',
    nameArabic: 'الريال القطري',
    nameEnglish: 'Qatari Riyal',
    decimals: 2,
  );

  static const ZakatCurrency bhd = ZakatCurrency(
    code: 'BHD',
    symbolArabic: 'د.ب',
    nameArabic: 'الدينار البحريني',
    nameEnglish: 'Bahraini Dinar',
    decimals: 3,
  );

  static const ZakatCurrency omr = ZakatCurrency(
    code: 'OMR',
    symbolArabic: 'ر.ع',
    nameArabic: 'الريال العُماني',
    nameEnglish: 'Omani Rial',
    decimals: 3,
  );

  static const ZakatCurrency jod = ZakatCurrency(
    code: 'JOD',
    symbolArabic: 'د.أ',
    nameArabic: 'الدينار الأردني',
    nameEnglish: 'Jordanian Dinar',
    decimals: 3,
  );

  static const ZakatCurrency gbp = ZakatCurrency(
    code: 'GBP',
    symbolArabic: '£',
    nameArabic: 'الجنيه الإسترليني',
    nameEnglish: 'British Pound',
    decimals: 2,
  );

  static const ZakatCurrency eur = ZakatCurrency(
    code: 'EUR',
    symbolArabic: '€',
    nameArabic: 'اليورو',
    nameEnglish: 'Euro',
    decimals: 2,
  );

  static const List<ZakatCurrency> supportedCurrencies = [
    egp,
    sar,
    usd,
    aed,
    kwd,
    qar,
    bhd,
    omr,
    jod,
    gbp,
    eur,
  ];

  static ZakatCurrency findByCode(String? code) {
    if (code == null || code.trim().isEmpty) return egp;
    final normalized = code.trim().toUpperCase();
    return supportedCurrencies.firstWhere(
      (c) => c.code == normalized,
      orElse: () => egp,
    );
  }

  @override
  List<Object?> get props => [code, symbolArabic, nameArabic, nameEnglish, decimals];
}
