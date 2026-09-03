import 'package:equatable/equatable.dart';

/// Availability and operational state of a module (§22, §49).
enum ModuleAvailabilityStatus {
  available,
  degraded,
  offline,
  error,
  notConfigured;

  String get labelArabic {
    switch (this) {
      case ModuleAvailabilityStatus.available:
        return 'متاح';
      case ModuleAvailabilityStatus.degraded:
        return 'أداء محدود';
      case ModuleAvailabilityStatus.offline:
        return 'غير متصل';
      case ModuleAvailabilityStatus.error:
        return 'خطأ';
      case ModuleAvailabilityStatus.notConfigured:
        return 'غير مهيأ';
    }
  }
}

/// Minimal aggregate summary of a module status for M11 dashboard orchestration (§22, §23).
class ModuleStatusSummary extends Equatable {
  final String moduleId;
  final String moduleTitleArabic;
  final ModuleAvailabilityStatus status;
  final String? statusMessage;
  final int? dueCount;
  final String? progressSummary;
  final DateTime timestamp;

  const ModuleStatusSummary({
    required this.moduleId,
    required this.moduleTitleArabic,
    required this.status,
    this.statusMessage,
    this.dueCount,
    this.progressSummary,
    required this.timestamp,
  });

  bool get isOperational =>
      status == ModuleAvailabilityStatus.available ||
      status == ModuleAvailabilityStatus.degraded;

  @override
  List<Object?> get props => [
        moduleId,
        moduleTitleArabic,
        status,
        statusMessage,
        dueCount,
        progressSummary,
        timestamp,
      ];
}
