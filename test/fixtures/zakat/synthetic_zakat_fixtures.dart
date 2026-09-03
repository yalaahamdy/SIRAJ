import 'package:siraj/modules/zakat/domain/asset_category.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/market_data_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_asset.dart';

/// Synthetic test fixtures for Zakat verification and property tests (§30, §31).
class SyntheticZakatFixtures {
  static MarketDataSnapshot createMarketSnapshot({
    int gold24kHalalas = 35000, // 350.00 SAR / g
    int silverHalalas = 400, // 4.00 SAR / g
    DateTime? timestamp,
  }) {
    return MarketDataSnapshot(
      goldPricePerGram24k: CurrencyAmount(units: gold24kHalalas, currency: 'SAR'),
      silverPricePerGram: CurrencyAmount(units: silverHalalas, currency: 'SAR'),
      currency: 'SAR',
      sourceName: 'Synthetic Market Provider',
      timestamp: timestamp ?? DateTime.utc(2026, 8, 31),
      isManualEntry: false,
    );
  }

  static ZakatAsset createCashAsset({
    String id = 'asset_cash_001',
    String title = 'حساب بنكي جاري',
    double amount = 50000.0,
    DateTime? acquisitionDate,
  }) {
    return ZakatAsset(
      id: id,
      title: title,
      category: AssetCategory.cash,
      amount: CurrencyAmount.fromDouble(amount, currency: 'SAR'),
      acquisitionDate: acquisitionDate ?? DateTime.utc(2025, 1, 1),
    );
  }

  static ZakatAsset createGoldAsset({
    String id = 'asset_gold_001',
    String title = 'سبائك ذهب ادخاري',
    double weightGrams = 100.0,
    int purityKarat = 24,
    DateTime? acquisitionDate,
  }) {
    return ZakatAsset(
      id: id,
      title: title,
      category: AssetCategory.gold,
      amount: const CurrencyAmount(units: 0, currency: 'SAR'),
      weightGrams: weightGrams,
      purityKarat: purityKarat,
      acquisitionDate: acquisitionDate ?? DateTime.utc(2025, 1, 1),
    );
  }

  static ZakatAsset createDebtLiability({
    String id = 'asset_debt_001',
    String title = 'قسط قرض حال عاجل',
    double amount = 10000.0,
    DateTime? acquisitionDate,
  }) {
    return ZakatAsset(
      id: id,
      title: title,
      category: AssetCategory.debts,
      amount: CurrencyAmount.fromDouble(amount, currency: 'SAR'),
      acquisitionDate: acquisitionDate ?? DateTime.utc(2025, 1, 1),
      isDeductibleDebt: true,
    );
  }
}
