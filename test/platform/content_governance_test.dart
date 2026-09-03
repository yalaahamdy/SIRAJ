import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/platform/content/domain/content_record.dart';
import 'package:siraj/platform/content/domain/content_status.dart';
import 'package:siraj/platform/content/domain/content_type.dart';
import 'package:siraj/platform/content/domain/source_ref.dart';
import 'package:siraj/platform/content/governance/governance_engine.dart';
import '../fixtures/synthetic_packages.dart';

void main() {
  group('L1 Content Governance Engine Tests (Laws 1, 5, 6)', () {
    const engine = GovernanceEngine();

    test('Valid transition sequence: DRAFT -> RESEARCHED -> VERIFIED -> HUMAN_REVIEW_REQUIRED -> APPROVED -> LOCKED', () {
      var record = SyntheticFixtures.createSyntheticRecord(
        status: ContentStatus.draft,
      );

      // 1. DRAFT -> RESEARCHED
      var res = engine.transitionStatus(
        record: record,
        targetStatus: ContentStatus.researched,
        isHumanReviewer: false,
      );
      expect(res.isSuccess, isTrue);
      record = res.valueOrNull!;

      // 2. RESEARCHED -> VERIFIED
      res = engine.transitionStatus(
        record: record,
        targetStatus: ContentStatus.verified,
        isHumanReviewer: false,
      );
      expect(res.isSuccess, isTrue);
      record = res.valueOrNull!;

      // 3. VERIFIED -> HUMAN_REVIEW_REQUIRED
      res = engine.transitionStatus(
        record: record,
        targetStatus: ContentStatus.humanReviewRequired,
        isHumanReviewer: false,
      );
      expect(res.isSuccess, isTrue);
      record = res.valueOrNull!;

      // 4. HUMAN_REVIEW_REQUIRED -> APPROVED (With human sign-off)
      final review = HumanReviewRecord(
        reviewerName: 'Named Sharia Scholar',
        reviewerRole: 'sharia_reviewer',
        reviewedAt: DateTime.utc(2026, 8, 31),
        verdict: 'APPROVED',
        notes: 'Source matched against physical primary book',
      );
      res = engine.transitionStatus(
        record: record,
        targetStatus: ContentStatus.approved,
        isHumanReviewer: true,
        reviewRecord: review,
      );
      expect(res.isSuccess, isTrue);
      record = res.valueOrNull!;

      // 5. APPROVED -> LOCKED
      res = engine.transitionStatus(
        record: record,
        targetStatus: ContentStatus.locked,
        isHumanReviewer: false,
      );
      expect(res.isSuccess, isTrue);
      record = res.valueOrNull!;
      expect(record.status, equals(ContentStatus.locked));
    });

    test('AI / Non-human reviewer CANNOT transition directly to APPROVED (Law 6)', () {
      final record = SyntheticFixtures.createSyntheticRecord(
        status: ContentStatus.humanReviewRequired,
      );

      final res = engine.transitionStatus(
        record: record,
        targetStatus: ContentStatus.approved,
        isHumanReviewer: false, // AI attempting approval
      );

      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, anyOf(contains('named human reviewer'), contains('isHumanReviewer: false')));
    });

    test('LOCKED content cannot be modified directly (Immutable Canonical Data - Law 2)', () {
      final record = SyntheticFixtures.createSyntheticRecord(
        status: ContentStatus.locked,
      );

      final res = engine.transitionStatus(
        record: record,
        targetStatus: ContentStatus.draft,
        isHumanReviewer: true,
      );

      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('Locked content is immutable'));
    });

    test('Cannot advance to VERIFIED if sources are missing (Law 5)', () {
      final recordWithoutSources = ContentRecord.create(
        contentId: 'TEST-NO-SOURCE',
        contentType: ContentType.testFixture,
        text: 'SYNTHETIC_TEXT',
        sources: const [], // Empty sources
        status: ContentStatus.researched,
      );

      final res = engine.transitionStatus(
        record: recordWithoutSources,
        targetStatus: ContentStatus.verified,
        isHumanReviewer: false,
      );

      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('lacks authentic sources'));
    });

    test('Quarantine halts record immediately regardless of state', () {
      final record = SyntheticFixtures.createSyntheticRecord(
        status: ContentStatus.approved,
      );

      final quarantined = engine.quarantine(record, reason: 'Suspected typographical error in source print');

      expect(quarantined.status, equals(ContentStatus.quarantined));
      expect(quarantined.status.isQuarantined, isTrue);
      expect(quarantined.status.isPubliclyDisplayable, isFalse);
      expect(quarantined.metadata['quarantine_reason'], contains('Suspected'));
    });
  });
}
