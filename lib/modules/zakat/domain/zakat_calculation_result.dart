import 'package:equatable/equatable.dart';
import 'currency_amount.dart';
import 'market_data_snapshot.dart';
import 'zakat_policy.dart';

/// Semantic status of the Zakat calculation result (§26).
enum ZakatResultStatus {
  due,
  notDueBelowNisab,
  notDueHawlIncomplete,
  insufficientData,
  policyRequired,
  reviewRequired;

  String get labelArabic {
    switch (this) {
      case ZakatResultStatus.due:
        return 'الزكاة مستحقة شرعاً';
      case ZakatResultStatus.notDueBelowNisab:
        return 'غير مستحقة (المال دون النصاب)';
      case ZakatResultStatus.notDueHawlIncomplete:
        return 'غير مستحقة (الحول لم يكتمل بعد)';
      case ZakatResultStatus.insufficientData:
        return 'بيانات مالية أو أسعار سوقية غير مكتملة';
      case ZakatResultStatus.policyRequired:
        return 'يلزم اختيار سياسة فقهية معتمدة';
      case ZakatResultStatus.reviewRequired:
        return 'حالة مركبة تلزم مراجعة عالم شرعي';
    }
  }
}

/// Explainable, comprehensive result of a Zakat calculation (§20, §21).
class ZakatCalculationResult extends Equatable {
  final ZakatResultStatus status;
  final CurrencyAmount grossAssets;
  final CurrencyAmount deductibleLiabilities;
  final CurrencyAmount netZakatableBase;
  final CurrencyAmount nisabThreshold;
  final CurrencyAmount zakatDue;
  final bool isHawlComplete;
  final int daysRemainingInHawl;
  final double appliedRate;
  final ZakatPolicy policyUsed;
  final MarketDataSnapshot marketSnapshotUsed;
  final Map<String, CurrencyAmount> itemizedAssetValues;
  final String explanation;
  final DateTime calculatedAt;

  const ZakatCalculationResult({
    required this.status,
    required this.grossAssets,
    required this.deductibleLiabilities,
    required this.netZakatableBase,
    required this.nisabThreshold,
    required this.zakatDue,
    required this.isHawlComplete,
    required this.daysRemainingInHawl,
    required this.appliedRate,
    required this.policyUsed,
    required this.marketSnapshotUsed,
    required this.itemizedAssetValues,
    required this.explanation,
    required this.calculatedAt,
  });

  bool get isDue => status == ZakatResultStatus.due;
  bool get reachesNisab => netZakatableBase.units >= nisabThreshold.units && nisabThreshold.units > 0;

  factory ZakatCalculationResult.fromMap(Map<String, dynamic> map) {
    final rawItemized = map['itemized_asset_values'] as Map<String, dynamic>? ?? {};
    final parsedItemized = rawItemized.map(
      (k, v) => MapEntry(k, CurrencyAmount.fromMap(v as Map<String, dynamic>)),
    );

    return ZakatCalculationResult(
      status: ZakatResultStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => ZakatResultStatus.insufficientData,
      ),
      grossAssets: CurrencyAmount.fromMap(map['gross_assets'] as Map<String, dynamic>),
      deductibleLiabilities: CurrencyAmount.fromMap(map['deductible_liabilities'] as Map<String, dynamic>),
      netZakatableBase: CurrencyAmount.fromMap(map['net_zakatable_base'] as Map<String, dynamic>),
      nisabThreshold: CurrencyAmount.fromMap(map['nisab_threshold'] as Map<String, dynamic>),
      zakatDue: CurrencyAmount.fromMap(map['zakat_due'] as Map<String, dynamic>),
      isHawlComplete: map['is_hawl_complete'] as bool? ?? false,
      daysRemainingInHawl: map['days_remaining_in_hawl'] as int? ?? 0,
      appliedRate: (map['applied_rate'] as num?)?.toDouble() ?? 0.025,
      policyUsed: ZakatPolicy.fromMap(map['policy_used'] as Map<String, dynamic>),
      marketSnapshotUsed: MarketDataSnapshot.fromMap(map['market_snapshot_used'] as Map<String, dynamic>),
      itemizedAssetValues: parsedItemized,
      explanation: map['explanation'] as String,
      calculatedAt: DateTime.parse(map['calculated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'gross_assets': grossAssets.toMap(),
      'deductible_liabilities': deductibleLiabilities.toMap(),
      'net_zakatable_base': netZakatableBase.toMap(),
      'nisab_threshold': nisabThreshold.toMap(),
      'zakat_due': zakatDue.toMap(),
      'is_hawl_complete': isHawlComplete,
      'days_remaining_in_hawl': daysRemainingInHawl,
      'applied_rate': appliedRate,
      'policy_used': policyUsed.toMap(),
      'market_snapshot_used': marketSnapshotUsed.toMap(),
      'itemized_asset_values': itemizedAssetValues.map((k, v) => MapEntry(k, v.toMap())),
      'explanation': explanation,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        status,
        grossAssets,
        deductibleLiabilities,
        netZakatableBase,
        nisabThreshold,
        zakatDue,
        isHawlComplete,
        daysRemainingInHawl,
        appliedRate,
        policyUsed,
        marketSnapshotUsed,
        itemizedAssetValues,
        explanation,
        calculatedAt,
      ];
}
