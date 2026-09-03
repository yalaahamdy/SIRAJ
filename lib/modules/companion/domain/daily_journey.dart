import 'package:equatable/equatable.dart';

/// Standard time slots in the customizable daily Islamic life routine (§7, §30).
enum JourneyTimeSlot {
  fajrDawn,
  morning,
  dhuhrNoon,
  asrAfternoon,
  maghribSunset,
  ishaNight,
  sleepNight;

  String get labelArabic {
    switch (this) {
      case JourneyTimeSlot.fajrDawn:
        return 'الفجر وبداية اليوم';
      case JourneyTimeSlot.morning:
        return 'الضحى وأول النهار';
      case JourneyTimeSlot.dhuhrNoon:
        return 'الظهر ومنتصف النهار';
      case JourneyTimeSlot.asrAfternoon:
        return 'العصر ومساء النهار';
      case JourneyTimeSlot.maghribSunset:
        return 'المغرب وغروب الشمس';
      case JourneyTimeSlot.ishaNight:
        return 'العشاء والمساء';
      case JourneyTimeSlot.sleepNight:
        return 'الليل وقبل النوم';
    }
  }
}

/// A specific scheduled slot in the user's daily journey (§7).
class DailyJourneySlot extends Equatable {
  final String slotId;
  final JourneyTimeSlot timeSlot;
  final String titleArabic;
  final String description;
  final String? primaryActionTitle;
  final String? targetRoute;
  final bool isCompleted;

  const DailyJourneySlot({
    required this.slotId,
    required this.timeSlot,
    required this.titleArabic,
    required this.description,
    this.primaryActionTitle,
    this.targetRoute,
    this.isCompleted = false,
  });

  DailyJourneySlot copyWith({
    String? slotId,
    JourneyTimeSlot? timeSlot,
    String? titleArabic,
    String? description,
    String? primaryActionTitle,
    String? targetRoute,
    bool? isCompleted,
  }) {
    return DailyJourneySlot(
      slotId: slotId ?? this.slotId,
      timeSlot: timeSlot ?? this.timeSlot,
      titleArabic: titleArabic ?? this.titleArabic,
      description: description ?? this.description,
      primaryActionTitle: primaryActionTitle ?? this.primaryActionTitle,
      targetRoute: targetRoute ?? this.targetRoute,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        slotId,
        timeSlot,
        titleArabic,
        description,
        primaryActionTitle,
        targetRoute,
        isCompleted,
      ];
}

/// The collection of daily journey slots for today (§7, §30).
class DailyJourneyRoutine extends Equatable {
  final String routineId;
  final String nameArabic;
  final List<DailyJourneySlot> slots;
  final DateTime date;

  const DailyJourneyRoutine({
    required this.routineId,
    required this.nameArabic,
    required this.slots,
    required this.date,
  });

  int get completedCount => slots.where((s) => s.isCompleted).length;
  double get progressPercentage =>
      slots.isNotEmpty ? (completedCount / slots.length * 100.0) : 0.0;

  @override
  List<Object?> get props => [routineId, nameArabic, slots, date];
}
