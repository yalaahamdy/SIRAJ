import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/content_record.dart';
import '../domain/content_status.dart';
import '../domain/content_type.dart';
import '../domain/source_ref.dart';

/// Enforcement engine for Content Governance policies (Laws 1, 5, 6).
class GovernanceEngine {
  const GovernanceEngine();

  /// Validates whether a record can transition to a target status.
  Result<ContentRecord, GovernanceViolationFailure> transitionStatus({
    required ContentRecord record,
    required ContentStatus targetStatus,
    required bool isHumanReviewer,
    HumanReviewRecord? reviewRecord,
  }) {
    // 1. Check if record is locked
    if (record.status == ContentStatus.locked && targetStatus != ContentStatus.deprecated) {
      return Result.err(
        GovernanceViolationFailure(
          message: 'Locked content is immutable and cannot change status to $targetStatus. Create a new version instead.',
        ),
      );
    }

    // 2. Validate state machine rules
    if (!record.status.canTransitionTo(targetStatus, isHumanReviewer: isHumanReviewer)) {
      return Result.err(
        GovernanceViolationFailure(
          message: 'Illegal state transition from ${record.status.name} to ${targetStatus.name} (isHumanReviewer: $isHumanReviewer)',
        ),
      );
    }

    // 3. Mandatory checks when moving to VERIFIED
    if (targetStatus == ContentStatus.verified) {
      final completenessResult = _validateMetadataCompleteness(record);
      if (completenessResult.isFailure) {
        return Result.err(completenessResult.failureOrNull!);
      }
    }

    // 4. Mandatory checks when moving to APPROVED
    if (targetStatus == ContentStatus.approved) {
      if (!isHumanReviewer || reviewRecord == null || reviewRecord.verdict != 'APPROVED') {
        return Result.err(
          const GovernanceViolationFailure(
            message: 'Approval requires a named human reviewer sign-off record (Law 6)',
          ),
        );
      }
    }

    // 5. Apply transition
    final updatedReviews = reviewRecord != null
        ? [...record.reviewRecords, reviewRecord]
        : record.reviewRecords;

    final updated = record.copyWith(
      status: targetStatus,
      reviewRecords: updatedReviews,
    );

    return Result.ok(updated);
  }

  /// Places a record under immediate quarantine (Fail-Closed).
  ContentRecord quarantine(ContentRecord record, {required String reason}) {
    return record.copyWith(
      status: ContentStatus.quarantined,
      metadata: {
        ...record.metadata,
        'quarantine_reason': reason,
        'quarantined_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  /// Validates mandatory metadata completeness before content can be verified.
  Result<void, GovernanceViolationFailure> _validateMetadataCompleteness(ContentRecord record) {
    if (record.sources.isEmpty) {
      return Result.err(
        GovernanceViolationFailure(
          message: 'Record "${record.contentId}" lacks authentic sources (Law 5 violation)',
        ),
      );
    }

    if (record.contentType == ContentType.hadith && record.grade == null) {
      return Result.err(
        GovernanceViolationFailure(
          message: 'Hadith record "${record.contentId}" must contain a documented HadithGrade',
        ),
      );
    }

    if (!record.verifyIntegrity()) {
      return Result.err(
        GovernanceViolationFailure(
          message: 'Record "${record.contentId}" failed checksum verification',
        ),
      );
    }

    return Result.ok(null);
  }
}
