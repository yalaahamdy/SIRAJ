import 'package:equatable/equatable.dart';

/// Severity level of a religious or technical content incident (§15, §22).
enum IncidentSeverity {
  critical,
  high,
  medium,
  low,
}

/// Operational status of an incident (§15, §32).
enum IncidentStatus {
  detected,
  contained,
  underScholarlyReview,
  resolved,
  closed,
}

/// Structured Content & AI Incident Record (§15, §22, §33).
class ContentIncident extends Equatable {
  final String incidentId;
  final String contentId;
  final String packageId;
  final String releaseId;
  final String reportedBy;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final DateTime detectedAt;
  final String descriptionArabic;
  final String containmentAction;
  final String? resolutionNotesArabic;

  const ContentIncident({
    required this.incidentId,
    required this.contentId,
    required this.packageId,
    required this.releaseId,
    required this.reportedBy,
    required this.severity,
    required this.status,
    required this.detectedAt,
    required this.descriptionArabic,
    this.containmentAction = '',
    this.resolutionNotesArabic,
  });

  ContentIncident copyWith({
    String? incidentId,
    String? contentId,
    String? packageId,
    String? releaseId,
    String? reportedBy,
    IncidentSeverity? severity,
    IncidentStatus? status,
    DateTime? detectedAt,
    String? descriptionArabic,
    String? containmentAction,
    String? resolutionNotesArabic,
  }) {
    return ContentIncident(
      incidentId: incidentId ?? this.incidentId,
      contentId: contentId ?? this.contentId,
      packageId: packageId ?? this.packageId,
      releaseId: releaseId ?? this.releaseId,
      reportedBy: reportedBy ?? this.reportedBy,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      detectedAt: detectedAt ?? this.detectedAt,
      descriptionArabic: descriptionArabic ?? this.descriptionArabic,
      containmentAction: containmentAction ?? this.containmentAction,
      resolutionNotesArabic: resolutionNotesArabic ?? this.resolutionNotesArabic,
    );
  }

  @override
  List<Object?> get props => [
        incidentId,
        contentId,
        packageId,
        releaseId,
        reportedBy,
        severity,
        status,
        detectedAt,
        descriptionArabic,
        containmentAction,
        resolutionNotesArabic,
      ];
}
