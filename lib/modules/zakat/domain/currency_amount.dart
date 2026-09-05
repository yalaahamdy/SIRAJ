import 'package:equatable/equatable.dart';
import 'zakat_currency.dart';

/// High-precision monetary amount representation to eliminate floating-point errors (§7).
class CurrencyAmount extends Equatable implements Comparable<CurrencyAmount> {
  final int units; // Value in minor units (e.g., piasters/halalas/cents)
  final int decimals; // Number of fractional decimal digits (default: 2)
  final String currency; // Standard currency code (e.g., 'EGP', 'SAR', 'USD')

  const CurrencyAmount({
    required this.units,
    this.decimals = 2,
    this.currency = 'EGP',
  }) : assert(decimals >= 0 && decimals <= 6, 'Decimals must be between 0 and 6');

  static const CurrencyAmount zero = CurrencyAmount(units: 0);

  factory CurrencyAmount.fromDouble(
    double value, {
    String currency = 'EGP',
    int decimals = 2,
  }) {
    final factor = _multiplier(decimals);
    final intUnits = (value * factor).round();
    return CurrencyAmount(
      units: intUnits,
      decimals: decimals,
      currency: currency,
    );
  }

  factory CurrencyAmount.fromUnits(
    int units, {
    String currency = 'EGP',
    int decimals = 2,
  }) {
    return CurrencyAmount(
      units: units,
      decimals: decimals,
      currency: currency,
    );
  }

  double toDouble() {
    final factor = _multiplier(decimals);
    return units / factor;
  }

  static int _multiplier(int decimals) {
    var res = 1;
    for (var i = 0; i < decimals; i++) {
      res *= 10;
    }
    return res;
  }

  CurrencyAmount operator +(CurrencyAmount other) {
    _assertSameCurrency(other);
    return CurrencyAmount(
      units: units + other.units,
      decimals: decimals,
      currency: currency,
    );
  }

  CurrencyAmount operator -(CurrencyAmount other) {
    _assertSameCurrency(other);
    return CurrencyAmount(
      units: units - other.units,
      decimals: decimals,
      currency: currency,
    );
  }

  CurrencyAmount multiplyByRate(double rate) {
    final newUnits = (units * rate).round();
    return CurrencyAmount(
      units: newUnits,
      decimals: decimals,
      currency: currency,
    );
  }

  bool get isZero => units == 0;
  bool get isPositive => units > 0;
  bool get isNegative => units < 0;

  void _assertSameCurrency(CurrencyAmount other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot operate on mismatched currencies: $currency vs ${other.currency}');
    }
    if (decimals != other.decimals) {
      throw ArgumentError('Cannot operate on mismatched decimal precision: $decimals vs ${other.decimals}');
    }
  }

  String format({bool includeSymbol = true}) {
    final factor = _multiplier(decimals);
    final absUnits = units.abs();
    final wholePart = absUnits ~/ factor;
    final fracPart = (absUnits % factor).toString().padLeft(decimals, '0');
    final sign = units < 0 ? '-' : '';

    final numberStr = decimals > 0 ? '$wholePart.$fracPart' : '$wholePart';
    return includeSymbol ? '$sign$numberStr $currency' : '$sign$numberStr';
  }

  /// Formats with thousands commas and local Arabic currency symbols (e.g. `10,000 ج.م`).
  String formatLocal({bool includeSymbol = true}) {
    final factor = _multiplier(decimals);
    final absUnits = units.abs();
    final wholePart = absUnits ~/ factor;
    final fracPart = (absUnits % factor).toString().padLeft(decimals, '0');
    final sign = units < 0 ? '-' : '';

    final wholeStr = wholePart.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < wholeStr.length; i++) {
      if (i > 0 && (wholeStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(wholeStr[i]);
    }

    final numberStr = (decimals > 0 && absUnits % factor != 0)
        ? '$buffer.$fracPart'
        : buffer.toString();

    if (!includeSymbol) return '$sign$numberStr';
    final zc = ZakatCurrency.findByCode(currency);
    return '$sign$numberStr ${zc.symbolArabic}';
  }

  factory CurrencyAmount.fromMap(Map<String, dynamic> map) {
    return CurrencyAmount(
      units: map['units'] as int,
      decimals: map['decimals'] as int? ?? 2,
      currency: map['currency'] as String? ?? 'EGP',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'units': units,
      'decimals': decimals,
      'currency': currency,
    };
  }

  @override
  int compareTo(CurrencyAmount other) {
    _assertSameCurrency(other);
    return units.compareTo(other.units);
  }

  @override
  List<Object?> get props => [units, decimals, currency];

  @override
  String toString() => format();
}
