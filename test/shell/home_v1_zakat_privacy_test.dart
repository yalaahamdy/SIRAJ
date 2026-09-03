import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/zakat/domain/asset_category.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/zakat_asset.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Zakat Privacy & Zero Financial Leakage Suite (§36, §101, §114, §119)', () {
    late MemoryStorageRegistry storage;
    late ZakatModule zakatModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: storage);

      companionModule = CompanionModule(
        storageRegistry: storage,
        zakatModule: zakatModule,
      );
    });

    test('Zakat Privacy 1: Home dashboard never exposes exact private wealth numbers on general cards (§36, §119)', () async {
      await zakatModule.addOrUpdateAsset(
        ZakatAsset(
          id: 'test_asset',
          title: 'مدخرات خاصة',
          category: AssetCategory.cash,
          amount: const CurrencyAmount(units: 95000000),
          acquisitionDate: DateTime.utc(2026, 9, 1),
        ),
      );

      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      for (final card in cards) {
        expect(card.subtitleArabic, isNot(contains('95000000')));
        expect(card.titleArabic, isNot(contains('95000000')));
      }
    });
  });
}
