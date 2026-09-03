import 'package:equatable/equatable.dart';

/// High-precision monetary amount representation to eliminate floating-point errors (§7).
class CurrencyAmount extends Equatable implements Comparable<CurrencyAmount> {
  final int units; // Value in minor units (e.g., halalas/cents)
  final int decimals; // Number of fractional decimal digits (default: 2)
  final String currency; // Standard currency code (e.g., 'SAR', 'USD')

  const CurrencyAmount({
    required this.units,
    this.decimals = 2,
    this.currency = 'SAR',
  }) : assert(decimals >= 0 && decimals <= 6, 'Decimals must be between 0 and 6');

  static const CurrencyAmount zero = CurrencyAmount(units: 0);

  factory CurrencyAmount.fromDouble(
    double value, {
    String currency = 'SAR',
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
    String currency = 'SAR',
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

  factory CurrencyAmount.fromMap(Map<String, dynamic> map) {
    return CurrencyAmount(
      units: map['units'] as int,
      decimals: map['decimals'] as int? ?? 2,
      currency: map['currency'] as String? ?? 'SAR',
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
