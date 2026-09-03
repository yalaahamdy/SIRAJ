import 'package:equatable/equatable.dart';
import 'date_precision.dart';

/// Historical date representation supporting Hijri chronology and precision levels (§6, §7).
class HistoricalDate extends Equatable {
  final int? hijriYear;
  final bool isBeforeHijrah;
  final int? hijriMonth;
  final int? hijriDay;
  final int? gregorianYear;
  final DatePrecision precision;
  final String dateDisplay;
  final String? conversionBasis;

  const HistoricalDate({
    this.hijriYear,
    this.isBeforeHijrah = false,
    this.hijriMonth,
    this.hijriDay,
    this.gregorianYear,
    this.precision = DatePrecision.exactDate,
    required this.dateDisplay,
    this.conversionBasis,
  });

  Map<String, dynamic> toMap() {
    return {
      'hijri_year': hijriYear,
      'is_before_hijrah': isBeforeHijrah,
      'hijri_month': hijriMonth,
      'hijri_day': hijriDay,
      'gregorian_year': gregorianYear,
      'precision': precision.name,
      'date_display': dateDisplay,
      'conversion_basis': conversionBasis,
    };
  }

  factory HistoricalDate.fromMap(Map<String, dynamic> map) {
    return HistoricalDate(
      hijriYear: map['hijri_year'] as int?,
      isBeforeHijrah: map['is_before_hijrah'] as bool? ?? false,
      hijriMonth: map['hijri_month'] as int?,
      hijriDay: map['hijri_day'] as int?,
      gregorianYear: map['gregorian_year'] as int?,
      precision: DatePrecision.values.byName(map['precision'] as String? ?? 'exactDate'),
      dateDisplay: map['date_display'] as String,
      conversionBasis: map['conversion_basis'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        hijriYear,
        isBeforeHijrah,
        hijriMonth,
        hijriDay,
        gregorianYear,
        precision,
        dateDisplay,
        conversionBasis,
      ];
}
