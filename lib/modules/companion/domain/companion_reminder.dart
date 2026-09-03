import 'package:equatable/equatable.dart';

/// Priority levels for daily orchestrated reminders (§28).
enum ReminderPriority {
  high, // e.g. prayer time arrival
  medium, // e.g. daily reading or memorization plan
  low; // e.g. general suggestion

  String get labelArabic {
    switch (this) {
      case ReminderPriority.high:
        return 'عالي';
      case ReminderPriority.medium:
        return 'متوسط';
      case ReminderPriority.low:
        return 'منخفض';
    }
  }
}

/// Unified deduplicated reminder structure (§27, §28).
class CompanionReminder extends Equatable {
  final String reminderId;
  final String sourceModule;
  final String titleArabic;
  final String messageArabic;
  final DateTime scheduledTime;
  final ReminderPriority priority;
  final String? targetRoute;
  final bool isDismissed;

  const CompanionReminder({
    required this.reminderId,
    required this.sourceModule,
    required this.titleArabic,
    required this.messageArabic,
    required this.scheduledTime,
    required this.priority,
    this.targetRoute,
    this.isDismissed = false,
  });

  CompanionReminder copyWith({
    String? reminderId,
    String? sourceModule,
    String? titleArabic,
    String? messageArabic,
    DateTime? scheduledTime,
    ReminderPriority? priority,
    String? targetRoute,
    bool? isDismissed,
  }) {
    return CompanionReminder(
      reminderId: reminderId ?? this.reminderId,
      sourceModule: sourceModule ?? this.sourceModule,
      titleArabic: titleArabic ?? this.titleArabic,
      messageArabic: messageArabic ?? this.messageArabic,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      priority: priority ?? this.priority,
      targetRoute: targetRoute ?? this.targetRoute,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  @override
  List<Object?> get props => [
        reminderId,
        sourceModule,
        titleArabic,
        messageArabic,
        scheduledTime,
        priority,
        targetRoute,
        isDismissed,
      ];
}
