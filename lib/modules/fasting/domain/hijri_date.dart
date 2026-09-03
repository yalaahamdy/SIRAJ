import 'package:equatable/equatable.dart';

/// Immutable representation of an Islamic Hijri calendar date (§4, §7).
class HijriDate extends Equatable {
  final int year;
  final int month;
  final int day;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
  })  : assert(month >= 1 && month <= 12, 'Hijri month must be between 1 and 12'),
        assert(day >= 1 && day <= 30, 'Hijri day must be between 1 and 30');

  bool get isRamadan => month == 9;

  String get monthNameArabic {
    switch (month) {
      case 1:
        return 'محرم';
      case 2:
        return 'صفر';
      case 3:
        return 'ربيع الأول';
      case 4:
        return 'ربيع الآخر';
      case 5:
        return 'جمادى الأولى';
      case 6:
        return 'جمادى الآخرة';
      case 7:
        return 'رجب';
      case 8:
        return 'شعبان';
      case 9:
        return 'رمضان';
      case 10:
        return 'شوال';
      case 11:
        return 'ذو القعدة';
      case 12:
        return 'ذو الحجة';
      default:
        return 'غير معروف';
    }
  }

  String formatArabic() {
    return '$day $monthNameArabic $year هـ';
  }

  factory HijriDate.fromMap(Map<String, dynamic> map) {
    return HijriDate(
      year: map['year'] as int,
      month: map['month'] as int,
      day: map['day'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
    };
  }

  @override
  List<Object?> get props => [year, month, day];
}
