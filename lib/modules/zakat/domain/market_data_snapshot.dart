import 'package:equatable/equatable.dart';
import 'currency_amount.dart';

/// Snapshot of market prices for precious metals and currencies with provenance (§9, §10).
class MarketDataSnapshot extends Equatable {
  final CurrencyAmount goldPricePerGram24k;
  final CurrencyAmount silverPricePerGram;
  final String currency;
  final String sourceName;
  final DateTime timestamp;
  final bool isManualEntry;

  const MarketDataSnapshot({
    required this.goldPricePerGram24k,
    required this.silverPricePerGram,
    this.currency = 'SAR',
    required this.sourceName,
    required this.timestamp,
    this.isManualEntry = false,
  });

  /// Checks if market data is older than the specified max age (default: 24 hours).
  bool isStale(DateTime currentTime, {Duration maxAge = const Duration(hours: 24)}) {
    return currentTime.difference(timestamp).abs() > maxAge;
  }

  factory MarketDataSnapshot.fromMap(Map<String, dynamic> map) {
    return MarketDataSnapshot(
      goldPricePerGram24k: CurrencyAmount.fromMap(map['gold_price_per_gram_24k'] as Map<String, dynamic>),
      silverPricePerGram: CurrencyAmount.fromMap(map['silver_price_per_gram'] as Map<String, dynamic>),
      currency: map['currency'] as String? ?? 'SAR',
      sourceName: map['source_name'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isManualEntry: map['is_manual_entry'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gold_price_per_gram_24k': goldPricePerGram24k.toMap(),
      'silver_price_per_gram': silverPricePerGram.toMap(),
      'currency': currency,
      'source_name': sourceName,
      'timestamp': timestamp.toIso8601String(),
      'is_manual_entry': isManualEntry,
    };
  }

  @override
  List<Object?> get props => [
        goldPricePerGram24k,
        silverPricePerGram,
        currency,
        sourceName,
        timestamp,
        isManualEntry,
      ];
}
