import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/asset_category.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/market_data_snapshot.dart';
import 'package:siraj/modules/zakat/domain/nisab_standard.dart';
import 'package:siraj/modules/zakat/domain/zakat_asset.dart';
import 'package:siraj/modules/zakat/domain/zakat_currency.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';

void main() {
  group('M04.0 Professional Zakat Upgrade Specification Tests (§1..§17)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule module;

    setUp(() {
      registry = MemoryStorageRegistry();
      module = ZakatModule(storageRegistry: registry);
    });

    // 🇪🇬 REQUIREMENT #1 & #2: Currency Tests
    group('Requirement #1 & #2: Egyptian Pound Default & Currency Management', () {
      test('EGP is the mandatory default currency in profile and module', () async {
        final profile = await module.getProfile();
        expect(profile.currencyCode, equals('EGP'));
        expect(profile.currency.code, equals('EGP'));
        expect(profile.currency.symbolArabic, equals('ج.م'));
        expect(profile.currency.nameArabic, equals('الجنيه المصري'));

        final marketSnapshot = await module.getMarketSnapshot();
        expect(marketSnapshot.currency, equals('EGP'));
        expect(marketSnapshot.goldPricePerGram24k.currency, equals('EGP'));
        expect(marketSnapshot.goldPricePerGram24k.units, equals(450000)); // 4500.00 EGP
      });

      test('Supported currencies list includes all 11 required currencies', () {
        const requiredCodes = ['EGP', 'SAR', 'USD', 'AED', 'KWD', 'QAR', 'BHD', 'OMR', 'JOD', 'GBP', 'EUR'];
        for (final code in requiredCodes) {
          final currency = ZakatCurrency.findByCode(code);
          expect(currency.code, equals(code));
          expect(currency.symbolArabic.isNotEmpty, isTrue);
          expect(currency.nameArabic.isNotEmpty, isTrue);
        }
      });

      test('EGP formatting renders Arabic symbol and thousands commas correctly', () {
        final amount = CurrencyAmount.fromDouble(250000.50, currency: 'EGP');
        expect(amount.formatLocal(), equals('250,000.50 ج.م'));

        final integerAmount = CurrencyAmount.fromDouble(5250.0, currency: 'EGP');
        expect(integerAmount.formatLocal(), equals('5,250 ج.م'));
      });

      test('Other currencies format with their specific Arabic symbols', () {
        final sar = CurrencyAmount.fromDouble(10000.0, currency: 'SAR');
        expect(sar.formatLocal(), equals('10,000 ر.س'));

        final usd = CurrencyAmount.fromDouble(1250.0, currency: 'USD');
        expect(usd.formatLocal(), equals('1,250 \$'));

        final kwd = CurrencyAmount.fromDouble(500.0, currency: 'KWD', decimals: 3);
        expect(kwd.formatLocal(), equals('500 د.ك'));
      });

      test('Currency persistence: switching currency saves locally and stays persistent', () async {
        final initialProfile = await module.getProfile();
        expect(initialProfile.currencyCode, equals('EGP'));

        // Switch to USD
        final updatedProfile = initialProfile.copyWith(currencyCode: 'USD');
        await module.saveProfile(updatedProfile);

        final loadedProfile = await module.getProfile();
        expect(loadedProfile.currencyCode, equals('USD'));
        expect(loadedProfile.currency.nameArabic, equals('الدولار الأمريكي'));
      });
    });

    // 🪙 REQUIREMENT #4: Nisab Settings & Methods
    group('Requirement #4: Nisab Standards & Methods', () {
      test('Gold Nisab 85g calculates exact threshold in EGP', () async {
        // Gold 24k @ 4,500 EGP/g -> 85g * 4,500 = 382,500 EGP
        final snapshot = MarketDataSnapshot(
          goldPricePerGram24k: CurrencyAmount.fromDouble(4500.0, currency: 'EGP'),
          silverPricePerGram: CurrencyAmount.fromDouble(55.0, currency: 'EGP'),
          currency: 'EGP',
          sourceName: 'Local Market',
          timestamp: DateTime.utc(2026, 9, 1),
        );
        await module.setMarketSnapshot(snapshot);

        final threshold = module.nisabEngine.calculateNisabThreshold(
          policy: ZakatPolicy.goldStandard,
          marketSnapshot: snapshot,
        );

        expect(threshold.toDouble(), equals(382500.0));
        expect(threshold.currency, equals('EGP'));
        expect(threshold.formatLocal(), equals('382,500 ج.م'));
      });

      test('Silver Nisab 595g calculates exact threshold in EGP', () async {
        // Silver @ 55 EGP/g -> 595g * 55 = 32,725 EGP
        final snapshot = MarketDataSnapshot(
          goldPricePerGram24k: CurrencyAmount.fromDouble(4500.0, currency: 'EGP'),
          silverPricePerGram: CurrencyAmount.fromDouble(55.0, currency: 'EGP'),
          currency: 'EGP',
          sourceName: 'Local Market',
          timestamp: DateTime.utc(2026, 9, 1),
        );
        await module.setMarketSnapshot(snapshot);

        final threshold = module.nisabEngine.calculateNisabThreshold(
          policy: ZakatPolicy.silverStandard,
          marketSnapshot: snapshot,
        );

        expect(threshold.toDouble(), equals(32725.0));
        expect(threshold.currency, equals('EGP'));
        expect(threshold.formatLocal(), equals('32,725 ج.م'));
      });

      test('Manual Nisab method allows direct monetary threshold specification', () async {
        final manualAmount = CurrencyAmount.fromDouble(200000.0, currency: 'EGP');
        final profile = (await module.getProfile()).copyWith(
          nisabStandard: NisabStandard.custom,
          manualNisabValue: manualAmount,
          calculationPolicyId: ZakatPolicy.manualStandardId,
        );
        await module.saveProfile(profile);

        final marketSnapshot = await module.getMarketSnapshot();
        final threshold = module.nisabEngine.calculateNisabThreshold(
          policy: ZakatPolicy.manualStandard,
          marketSnapshot: marketSnapshot,
          manualNisabAmount: manualAmount,
        );

        expect(threshold.toDouble(), equals(200000.0));
        expect(threshold.currency, equals('EGP'));
      });
    });

    // 🧮 REQUIREMENT #3: Gold Karats Valuation
    group('Requirement #3: Gold by Karat Valuation & Asset Calculation', () {
      test('Valuates Gold 24K, 22K, 21K, and 18K with exact purity multipliers', () {
        final engine = module.calcEngine;
        final snapshot = MarketDataSnapshot(
          goldPricePerGram24k: CurrencyAmount.fromDouble(4000.0, currency: 'EGP'),
          silverPricePerGram: CurrencyAmount.fromDouble(50.0, currency: 'EGP'),
          currency: 'EGP',
          sourceName: 'Market',
          timestamp: DateTime.utc(2026, 9, 1),
        );

        // 100g 24K @ 4000 EGP = 400,000 EGP
        final gold24 = ZakatAsset(
          id: 'g24',
          title: 'ذهب 24',
          category: AssetCategory.gold,
          amount: CurrencyAmount.zero,
          weightGrams: 100.0,
          purityKarat: 24,
          acquisitionDate: DateTime.utc(2025, 1, 1),
        );

        // 100g 21K @ 4000 * (21/24) = 350,000 EGP
        final gold21 = ZakatAsset(
          id: 'g21',
          title: 'ذهب 21',
          category: AssetCategory.gold,
          amount: CurrencyAmount.zero,
          weightGrams: 100.0,
          purityKarat: 21,
          acquisitionDate: DateTime.utc(2025, 1, 1),
        );

        // 100g 18K @ 4000 * (18/24) = 300,000 EGP
        final gold18 = ZakatAsset(
          id: 'g18',
          title: 'ذهب 18',
          category: AssetCategory.gold,
          amount: CurrencyAmount.zero,
          weightGrams: 100.0,
          purityKarat: 18,
          acquisitionDate: DateTime.utc(2025, 1, 1),
        );

        final res = engine.calculate(
          assets: [gold24, gold21, gold18],
          policy: ZakatPolicy.goldStandard,
          marketSnapshot: snapshot,
        );

        expect(res.itemizedAssetValues['g24']!.toDouble(), equals(400000.0));
        expect(res.itemizedAssetValues['g21']!.toDouble(), equals(350000.0));
        expect(res.itemizedAssetValues['g18']!.toDouble(), equals(300000.0));
        expect(res.grossAssets.toDouble(), equals(1050000.0));
      });

      test('End-to-end full calculation: cash, gold, trade, minus debt in EGP', () async {
        // Market: Gold 24k @ 4,000 EGP, Silver @ 50 EGP
        final snapshot = MarketDataSnapshot(
          goldPricePerGram24k: CurrencyAmount.fromDouble(4000.0, currency: 'EGP'),
          silverPricePerGram: CurrencyAmount.fromDouble(50.0, currency: 'EGP'),
          currency: 'EGP',
          sourceName: 'Market',
          timestamp: DateTime.utc(2026, 9, 1),
        );
        await module.setMarketSnapshot(snapshot);

        // Assets:
        // Cash: 300,000 EGP
        await module.addOrUpdateAsset(ZakatAsset(
          id: 'cash_1',
          title: 'حساب بنكي',
          category: AssetCategory.cash,
          amount: CurrencyAmount.fromDouble(300000.0, currency: 'EGP'),
          acquisitionDate: DateTime.utc(2025, 1, 1),
        ));

        // Trade Goods: 200,000 EGP
        await module.addOrUpdateAsset(ZakatAsset(
          id: 'trade_1',
          title: 'بضاعة متجر',
          category: AssetCategory.tradeGoods,
          amount: CurrencyAmount.fromDouble(200000.0, currency: 'EGP'),
          acquisitionDate: DateTime.utc(2025, 1, 1),
        ));

        // Debt (current liability): 100,000 EGP
        await module.addOrUpdateAsset(ZakatAsset(
          id: 'debt_1',
          title: 'قسط مورد حال',
          category: AssetCategory.debts,
          amount: CurrencyAmount.fromDouble(100000.0, currency: 'EGP'),
          acquisitionDate: DateTime.utc(2025, 1, 1),
        ));

        final calcRes = await module.calculateZakat();
        expect(calcRes.isSuccess, isTrue);
        final result = calcRes.valueOrNull!;

        // Gross = 300k + 200k = 500,000 EGP
        expect(result.grossAssets.toDouble(), equals(500000.0));
        // Debt = 100,000 EGP
        expect(result.deductibleLiabilities.toDouble(), equals(100000.0));
        // Net = 400,000 EGP
        expect(result.netZakatableBase.toDouble(), equals(400000.0));
        // Nisab = 85 * 4,000 = 340,000 EGP
        expect(result.nisabThreshold.toDouble(), equals(340000.0));
        expect(result.reachesNisab, isTrue);
        expect(result.isDue, isTrue);

        // Zakat Due = 400,000 * 2.5% = 10,000 EGP
        expect(result.zakatDue.toDouble(), equals(10000.0));
        expect(result.zakatDue.formatLocal(), equals('10,000 ج.م'));
      });
    });

    // 📅 REQUIREMENT #5: Hawl Tracking
    group('Requirement #5: Hawl Engine & Date Handling', () {
      test('Calculates Hawl completion accurately and respects custom Hawl date', () async {
        final profile = (await module.getProfile()).copyWith(
          hawlStartDate: DateTime.utc(2025, 1, 1),
          isHijriCalendar: true,
        );
        await module.saveProfile(profile);

        final daysRemaining = module.hawlEngine.calculateDaysRemaining(
          startDate: profile.hawlStartDate!,
          currentTime: DateTime.utc(2025, 1, 1).add(const Duration(days: 300)),
          isHijri: true,
        );
        // 354 - 300 = 54 days
        expect(daysRemaining, equals(54));
      });
    });

    // 📚 REQUIREMENT #8: Zakat History Snapshots & Deletion
    group('Requirement #8: Zakat History Storage & Deletion', () {
      test('Saves snapshots, lists them, and deletes individual snapshots', () async {
        // Initial empty history
        final initialSnaps = await module.getSnapshots();
        expect(initialSnaps.valueOrNull!.isEmpty, isTrue);

        // Calculate and save snapshot
        await module.addOrUpdateAsset(ZakatAsset(
          id: 'test_cash',
          title: 'سيولة',
          category: AssetCategory.cash,
          amount: CurrencyAmount.fromDouble(500000.0, currency: 'EGP'),
          acquisitionDate: DateTime.utc(2025, 1, 1),
        ));

        final calcRes = await module.calculateZakat();
        final saveRes = await module.saveSnapshot(calcRes.valueOrNull!);
        expect(saveRes.isSuccess, isTrue);
        final snapshotId = saveRes.valueOrNull!.snapshotId;

        // Check history has 1 entry
        final listRes = await module.getSnapshots();
        expect(listRes.valueOrNull!.length, equals(1));
        expect(listRes.valueOrNull!.first.snapshotId, equals(snapshotId));

        // Delete snapshot
        final deleteRes = await module.deleteSnapshot(snapshotId);
        expect(deleteRes.isSuccess, isTrue);

        final afterDelete = await module.getSnapshots();
        expect(afterDelete.valueOrNull!.isEmpty, isTrue);
      });
    });

    // 🔐 REQUIREMENT #9 & #16: Local-Only Privacy & Reset
    group('Requirement #9 & #16: Privacy & Reset Integrity', () {
      test('Reset clears all user data and restores EGP default profile', () async {
        // Modify profile to USD
        await module.saveProfile((await module.getProfile()).copyWith(currencyCode: 'USD'));
        await module.addOrUpdateAsset(ZakatAsset(
          id: 'temp_asset',
          title: 'أصل مؤقت',
          category: AssetCategory.cash,
          amount: CurrencyAmount.fromDouble(5000.0, currency: 'USD'),
          acquisitionDate: DateTime.utc(2025, 1, 1),
        ));

        // Reset
        await module.resetAllUserData();

        final assets = await module.getAssets();
        expect(assets.valueOrNull!.isEmpty, isTrue);

        final history = await module.getSnapshots();
        expect(history.valueOrNull!.isEmpty, isTrue);

        final profile = await module.getProfile();
        expect(profile.currencyCode, equals('EGP'));
      });
    });
  });
}
