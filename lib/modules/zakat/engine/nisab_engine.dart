import '../domain/currency_amount.dart';
import '../domain/market_data_snapshot.dart';
import '../domain/nisab_standard.dart';
import '../domain/zakat_policy.dart';

/// Pure, deterministic engine for calculating monetary Nisab thresholds (§8, §9).
class NisabEngine {
  const NisabEngine();

  bool hasValidPrice({
    required ZakatPolicy policy,
    required MarketDataSnapshot marketSnapshot,
    CurrencyAmount? manualNisabAmount,
  }) {
    switch (policy.nisabStandard) {
      case NisabStandard.gold85g:
        return marketSnapshot.goldPricePerGram24k.units > 0;
      case NisabStandard.silver595g:
        return marketSnapshot.silverPricePerGram.units > 0;
      case NisabStandard.custom:
        if (manualNisabAmount != null && manualNisabAmount.units > 0) {
          return true;
        }
        return marketSnapshot.goldPricePerGram24k.units > 0;
    }
  }

  CurrencyAmount calculateNisabThreshold({
    required ZakatPolicy policy,
    required MarketDataSnapshot marketSnapshot,
    CurrencyAmount? manualNisabAmount,
  }) {
    if (policy.nisabStandard == NisabStandard.custom &&
        manualNisabAmount != null &&
        manualNisabAmount.units > 0) {
      return manualNisabAmount;
    }

    if (!hasValidPrice(
      policy: policy,
      marketSnapshot: marketSnapshot,
      manualNisabAmount: manualNisabAmount,
    )) {
      return CurrencyAmount(
        units: 0,
        currency: marketSnapshot.currency,
      );
    }

    switch (policy.nisabStandard) {
      case NisabStandard.gold85g:
        final gramPrice = marketSnapshot.goldPricePerGram24k;
        final grams = policy.goldNisabGrams;
        final rawUnits = (gramPrice.units * grams).round();
        return CurrencyAmount(
          units: rawUnits,
          decimals: gramPrice.decimals,
          currency: gramPrice.currency,
        );

      case NisabStandard.silver595g:
        final gramPrice = marketSnapshot.silverPricePerGram;
        final grams = policy.silverNisabGrams;
        final rawUnits = (gramPrice.units * grams).round();
        return CurrencyAmount(
          units: rawUnits,
          decimals: gramPrice.decimals,
          currency: gramPrice.currency,
        );

      case NisabStandard.custom:
        final gramPrice = marketSnapshot.goldPricePerGram24k;
        final grams = policy.goldNisabGrams;
        final rawUnits = (gramPrice.units * grams).round();
        return CurrencyAmount(
          units: rawUnits,
          decimals: gramPrice.decimals,
          currency: gramPrice.currency,
        );
    }
  }

  String explainNisabCalculation({
    required ZakatPolicy policy,
    required MarketDataSnapshot marketSnapshot,
  }) {
    if (!hasValidPrice(policy: policy, marketSnapshot: marketSnapshot)) {
      return 'لا يمكن حساب النصاب لعدم توفر سعر سوقي صالح للمعدن المعتمد.';
    }

    final threshold = calculateNisabThreshold(policy: policy, marketSnapshot: marketSnapshot);
    if (policy.nisabStandard == NisabStandard.gold85g) {
      return 'تم حساب النصاب بناءً على معيار الذهب (${policy.goldNisabGrams} جرام عيار 24) بسعر ${marketSnapshot.goldPricePerGram24k.format()} للجرام = ${threshold.format()}.';
    } else {
      return 'تم حساب النصاب بناءً على معيار الفضة (${policy.silverNisabGrams} جرام) بسعر ${marketSnapshot.silverPricePerGram.format()} للجرام = ${threshold.format()}.';
    }
  }
}
