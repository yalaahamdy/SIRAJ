import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';

void main() {
  group('L2 CurrencyAmount High-Precision Monetary Tests (§7)', () {
    test('Eliminates floating-point arithmetic drift with default EGP currency', () {
      // 0.1 + 0.2 in floating-point is 0.30000000000000004
      final a = CurrencyAmount.fromDouble(0.1);
      final b = CurrencyAmount.fromDouble(0.2);
      final c = a + b;

      expect(c.toDouble(), equals(0.3));
      expect(c.units, equals(30)); // 30 piasters / cents
      expect(c.currency, equals('EGP'));
      expect(c.format(), equals('0.30 EGP'));
      expect(c.formatLocal(), equals('0.30 ج.م'));
    });

    test('Multiplication by 2.5% rate is exact and rounded deterministically', () {
      final base = CurrencyAmount.fromDouble(100000.0); // 100,000 EGP
      final zakat = base.multiplyByRate(0.025);

      expect(zakat.toDouble(), equals(2500.0));
      expect(zakat.format(), equals('2500.00 EGP'));
      expect(zakat.formatLocal(), equals('2,500 ج.م'));
    });

    test('Throws error on mismatched currency operations', () {
      const sar = CurrencyAmount(units: 1000, currency: 'SAR');
      const usd = CurrencyAmount(units: 1000, currency: 'USD');

      expect(() => sar + usd, throwsArgumentError);
      expect(() => sar - usd, throwsArgumentError);
    });

    test('JSON serialization and deserialization preserves exact units', () {
      const original = CurrencyAmount(units: 1234567, decimals: 2, currency: 'SAR');
      final map = original.toMap();
      final restored = CurrencyAmount.fromMap(map);

      expect(restored, equals(original));
      expect(restored.units, equals(1234567));
    });
  });
}
