import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/engine/nisab_engine.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('L2 NisabEngine Monetary Threshold Tests (§8, §9)', () {
    const engine = NisabEngine();

    test('Calculates 85g Gold Nisab threshold correctly', () {
      // 85g * 350.00 SAR/g = 29,750.00 SAR (2,975,000 halalas)
      final marketSnapshot = SyntheticZakatFixtures.createMarketSnapshot(
        gold24kHalalas: 35000, // 350.00 SAR
      );

      final threshold = engine.calculateNisabThreshold(
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
      );

      expect(threshold.toDouble(), equals(29750.0));
      expect(threshold.currency, equals('SAR'));
    });

    test('Calculates 595g Silver Nisab threshold correctly', () {
      // 595g * 4.00 SAR/g = 2,380.00 SAR (238,000 halalas)
      final marketSnapshot = SyntheticZakatFixtures.createMarketSnapshot(
        silverHalalas: 400, // 4.00 SAR
      );

      final threshold = engine.calculateNisabThreshold(
        policy: ZakatPolicy.silverStandard,
        marketSnapshot: marketSnapshot,
      );

      expect(threshold.toDouble(), equals(2380.0));
      expect(threshold.currency, equals('SAR'));
    });

    test('Generates transparent textual explanation with exact prices', () {
      final marketSnapshot = SyntheticZakatFixtures.createMarketSnapshot();
      final exp = engine.explainNisabCalculation(
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
      );

      expect(exp.contains('85'), isTrue);
      expect(exp.contains('29750.00 SAR'), isTrue);
    });
  });
}
