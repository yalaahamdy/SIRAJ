import 'package:equatable/equatable.dart';
import 'currency_amount.dart';
import 'nisab_standard.dart';
import 'zakat_currency.dart';
import 'zakat_policy.dart';

/// User's personal, localized, privacy-first Zakat calculation profile (§6, §37).
class ZakatProfile extends Equatable {
  final String currencyCode;
  final NisabStandard nisabStandard;
  final CurrencyAmount? manualNisabValue;
  final String calculationPolicyId;
  final DateTime? hawlStartDate;
  final bool isHijriCalendar;
  final CurrencyAmount goldPricePerGram;
  final CurrencyAmount silverPricePerGram;

  const ZakatProfile({
    this.currencyCode = 'EGP',
    this.nisabStandard = NisabStandard.gold85g,
    this.manualNisabValue,
    this.calculationPolicyId = ZakatPolicy.goldStandardId,
    this.hawlStartDate,
    this.isHijriCalendar = true,
    this.goldPricePerGram = const CurrencyAmount(units: 450000, currency: 'EGP'), // 4,500.00 EGP / g (24k)
    this.silverPricePerGram = const CurrencyAmount(units: 5500, currency: 'EGP'), // 55.00 EGP / g
  });

  ZakatCurrency get currency => ZakatCurrency.findByCode(currencyCode);

  ZakatProfile copyWith({
    String? currencyCode,
    NisabStandard? nisabStandard,
    CurrencyAmount? manualNisabValue,
    String? calculationPolicyId,
    DateTime? hawlStartDate,
    bool? isHijriCalendar,
    CurrencyAmount? goldPricePerGram,
    CurrencyAmount? silverPricePerGram,
  }) {
    return ZakatProfile(
      currencyCode: currencyCode ?? this.currencyCode,
      nisabStandard: nisabStandard ?? this.nisabStandard,
      manualNisabValue: manualNisabValue ?? this.manualNisabValue,
      calculationPolicyId: calculationPolicyId ?? this.calculationPolicyId,
      hawlStartDate: hawlStartDate ?? this.hawlStartDate,
      isHijriCalendar: isHijriCalendar ?? this.isHijriCalendar,
      goldPricePerGram: goldPricePerGram ?? this.goldPricePerGram,
      silverPricePerGram: silverPricePerGram ?? this.silverPricePerGram,
    );
  }

  factory ZakatProfile.fromMap(Map<String, dynamic> map) {
    return ZakatProfile(
      currencyCode: map['currency_code'] as String? ?? 'EGP',
      nisabStandard: NisabStandard.values.firstWhere(
        (s) => s.name == map['nisab_standard'],
        orElse: () => NisabStandard.gold85g,
      ),
      manualNisabValue: map['manual_nisab_value'] != null
          ? CurrencyAmount.fromMap(map['manual_nisab_value'] as Map<String, dynamic>)
          : null,
      calculationPolicyId: map['calculation_policy_id'] as String? ?? ZakatPolicy.goldStandardId,
      hawlStartDate: map['hawl_start_date'] != null
          ? DateTime.tryParse(map['hawl_start_date'] as String)
          : null,
      isHijriCalendar: map['is_hijri_calendar'] as bool? ?? true,
      goldPricePerGram: map['gold_price_per_gram'] != null
          ? CurrencyAmount.fromMap(map['gold_price_per_gram'] as Map<String, dynamic>)
          : const CurrencyAmount(units: 450000, currency: 'EGP'),
      silverPricePerGram: map['silver_price_per_gram'] != null
          ? CurrencyAmount.fromMap(map['silver_price_per_gram'] as Map<String, dynamic>)
          : const CurrencyAmount(units: 5500, currency: 'EGP'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currency_code': currencyCode,
      'nisab_standard': nisabStandard.name,
      if (manualNisabValue != null) 'manual_nisab_value': manualNisabValue!.toMap(),
      'calculation_policy_id': calculationPolicyId,
      if (hawlStartDate != null) 'hawl_start_date': hawlStartDate!.toIso8601String(),
      'is_hijri_calendar': isHijriCalendar,
      'gold_price_per_gram': goldPricePerGram.toMap(),
      'silver_price_per_gram': silverPricePerGram.toMap(),
    };
  }

  @override
  List<Object?> get props => [
        currencyCode,
        nisabStandard,
        manualNisabValue,
        calculationPolicyId,
        hawlStartDate,
        isHijriCalendar,
        goldPricePerGram,
        silverPricePerGram,
      ];
}
