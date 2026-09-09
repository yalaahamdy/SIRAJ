import 'package:equatable/equatable.dart';

/// Clean, lightweight summary of a Surah within an active Tahfeez plan.
class TahfeezSurahSummary extends Equatable {
  final int surahNumber;
  final String surahNameArabic;
  final int totalAyahsInPlan;
  final int memorizedAyahsCount;
  final double progressPercent;

  const TahfeezSurahSummary({
    required this.surahNumber,
    required this.surahNameArabic,
    required this.totalAyahsInPlan,
    required this.memorizedAyahsCount,
    required this.progressPercent,
  });

  bool get isCompleted => totalAyahsInPlan > 0 && memorizedAyahsCount >= totalAyahsInPlan;

  @override
  List<Object?> get props => [
        surahNumber,
        surahNameArabic,
        totalAyahsInPlan,
        memorizedAyahsCount,
        progressPercent,
      ];
}
