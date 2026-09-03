import 'package:equatable/equatable.dart';
import 'asset_category.dart';
import 'currency_amount.dart';

/// Immutable entity representing a financial asset or liability owned by the user (§4, §13).
class ZakatAsset extends Equatable {
  final String id;
  final String title;
  final AssetCategory category;
  final CurrencyAmount amount;
  final double? weightGrams;
  final int? purityKarat;
  final DateTime acquisitionDate;
  final bool isDeductibleDebt;
  final String? note;

  const ZakatAsset({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    this.weightGrams,
    this.purityKarat,
    required this.acquisitionDate,
    this.isDeductibleDebt = false,
    this.note,
  }) : assert(id.length >= 2, 'Asset ID must be at least 2 characters');

  ZakatAsset copyWith({
    String? title,
    AssetCategory? category,
    CurrencyAmount? amount,
    double? weightGrams,
    int? purityKarat,
    DateTime? acquisitionDate,
    bool? isDeductibleDebt,
    String? note,
  }) {
    return ZakatAsset(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      weightGrams: weightGrams ?? this.weightGrams,
      purityKarat: purityKarat ?? this.purityKarat,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      isDeductibleDebt: isDeductibleDebt ?? this.isDeductibleDebt,
      note: note ?? this.note,
    );
  }

  factory ZakatAsset.fromMap(Map<String, dynamic> map) {
    return ZakatAsset(
      id: map['id'] as String,
      title: map['title'] as String,
      category: AssetCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => AssetCategory.cash,
      ),
      amount: CurrencyAmount.fromMap(map['amount'] as Map<String, dynamic>),
      weightGrams: (map['weight_grams'] as num?)?.toDouble(),
      purityKarat: map['purity_karat'] as int?,
      acquisitionDate: DateTime.parse(map['acquisition_date'] as String),
      isDeductibleDebt: map['is_deductible_debt'] as bool? ?? false,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'amount': amount.toMap(),
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (purityKarat != null) 'purity_karat': purityKarat,
      'acquisition_date': acquisitionDate.toIso8601String(),
      'is_deductible_debt': isDeductibleDebt,
      if (note != null) 'note': note,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        amount,
        weightGrams,
        purityKarat,
        acquisitionDate,
        isDeductibleDebt,
        note,
      ];
}
