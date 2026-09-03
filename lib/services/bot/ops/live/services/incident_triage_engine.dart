import 'dart:math';
import '../models/content_incident.dart';

/// Incident triage and automated containment engine (§15, §22, §23, §33).
class IncidentTriageEngine {
  final List<ContentIncident> _incidents = [];

  List<ContentIncident> get incidents => List.unmodifiable(_incidents);

  /// Registers and triages an incident (§15, §22).
  ContentIncident registerIncident({
    required String contentId,
    required String packageId,
    required String releaseId,
    required String reportedBy,
    required IncidentSeverity severity,
    required String descriptionArabic,
  }) {
    final incidentId = 'inc_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';

    String containmentAction = '';
    IncidentStatus initialStatus = IncidentStatus.detected;

    // Automatic containment for critical incidents (§23)
    if (severity == IncidentSeverity.critical) {
      containmentAction = 'تم عزل المحتوى فوراً وإحالته للمراجعة الشرعية البشرية العاجلة';
      initialStatus = IncidentStatus.contained;
    } else if (severity == IncidentSeverity.high) {
      containmentAction = 'تم تسجيل الحظر المؤقت للأداة قيد التحقق';
      initialStatus = IncidentStatus.contained;
    } else {
      containmentAction = 'تم إدراج البلاغ في طابور الفحص والتدقيق الدوري';
    }

    final incident = ContentIncident(
      incidentId: incidentId,
      contentId: contentId,
      packageId: packageId,
      releaseId: releaseId,
      reportedBy: reportedBy,
      severity: severity,
      status: initialStatus,
      detectedAt: DateTime.now(),
      descriptionArabic: descriptionArabic,
      containmentAction: containmentAction,
    );

    _incidents.add(incident);
    return incident;
  }

  /// Updates incident status after review (§15).
  bool updateIncidentStatus({
    required String incidentId,
    required IncidentStatus newStatus,
    String? resolutionNotesArabic,
  }) {
    final index = _incidents.indexWhere((i) => i.incidentId == incidentId);
    if (index == -1) return false;

    final existing = _incidents[index];
    final updated = existing.copyWith(
      status: newStatus,
      resolutionNotesArabic: resolutionNotesArabic,
    );

    _incidents[index] = updated;
    return true;
  }
}
