import 'package:equatable/equatable.dart';

/// Major canonical period within Prophetic biography and early Islamic history (§4, §20).
class HistoricalPeriod extends Equatable {
  final String periodId;
  final String titleArabic;
  final String description;
  final int orderIndex;
  final String startYearDisplay;
  final String endYearDisplay;

  const HistoricalPeriod({
    required this.periodId,
    required this.titleArabic,
    required this.description,
    required this.orderIndex,
    required this.startYearDisplay,
    required this.endYearDisplay,
  });

  Map<String, dynamic> toMap() {
    return {
      'period_id': periodId,
      'title_arabic': titleArabic,
      'description': description,
      'order_index': orderIndex,
      'start_year_display': startYearDisplay,
      'end_year_display': endYearDisplay,
    };
  }

  factory HistoricalPeriod.fromMap(Map<String, dynamic> map) {
    return HistoricalPeriod(
      periodId: map['period_id'] as String,
      titleArabic: map['title_arabic'] as String,
      description: map['description'] as String,
      orderIndex: map['order_index'] as int,
      startYearDisplay: map['start_year_display'] as String,
      endYearDisplay: map['end_year_display'] as String,
    );
  }

  @override
  List<Object?> get props => [
        periodId,
        titleArabic,
        description,
        orderIndex,
        startYearDisplay,
        endYearDisplay,
      ];
}
