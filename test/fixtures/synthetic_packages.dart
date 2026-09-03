import 'package:siraj/platform/content/domain/content_record.dart';
import 'package:siraj/platform/content/domain/content_status.dart';
import 'package:siraj/platform/content/domain/content_type.dart';
import 'package:siraj/platform/content/domain/source_ref.dart';
import 'package:siraj/platform/content/package/content_package.dart';
import 'package:siraj/platform/content/package/package_manifest.dart';

/// Synthetic, non-religious test fixtures used exclusively for golden and integrity testing.
/// Strictly adheres to Law 2 & Law 3: NO real or AI-invented religious texts.
class SyntheticFixtures {
  static const String testSigner = 'siraj-test-authority';

  /// Creates a valid synthetic content record.
  static ContentRecord createSyntheticRecord({
    String contentId = 'CONTENT-TEST-001',
    String text = 'SYNTHETIC_TEXT_PAYLOAD_FOR_TESTING_PURPOSES_ONLY',
    ContentStatus status = ContentStatus.approved,
    int version = 1,
  }) {
    return ContentRecord.create(
      contentId: contentId,
      contentType: ContentType.testFixture,
      text: text,
      status: status,
      version: version,
      sources: const [
        SourceRef(
          reference: 'Synthetic Verification Manual v1.0, Section 4.2',
          type: SourceType.primary,
        ),
      ],
      attribution: const Attribution(
        to: 'Synthetic Source',
        verifiedByRef: true,
      ),
      reviewRecords: [
        HumanReviewRecord(
          reviewerName: 'Test Human Reviewer',
          reviewerRole: 'sharia_reviewer',
          reviewedAt: DateTime.utc(2026, 1, 1),
          verdict: 'APPROVED',
          notes: 'Synthetic validation pass',
        ),
      ],
    );
  }

  /// Builds a fully valid synthetic package with matching SHA-256 hashes and trusted signature.
  static ContentPackage createValidSyntheticPackage({
    String packageId = 'PACKAGE-TEST-001',
    String version = '1.0.0',
    int recordCount = 2,
    ContentStatus status = ContentStatus.approved,
  }) {
    final records = <ContentRecord>[];
    final fileHashes = <String, String>{};

    for (int i = 1; i <= recordCount; i++) {
      final id = 'CONTENT-TEST-${i.toString().padLeft(3, '0')}';
      final text = 'SYNTHETIC_PAYLOAD_BODY_FOR_ITEM_$i';
      final record = createSyntheticRecord(
        contentId: id,
        text: text,
        status: status,
      );
      records.add(record);
      fileHashes[id] = record.integrityHash;
    }

    final manifest = PackageManifest(
      packageId: packageId,
      version: version,
      targetModule: 'test_module',
      createdAt: DateTime.utc(2026, 1, 1),
      fileHashes: fileHashes,
      signature: 'VALID_TEST_ED25519_SIGNATURE_PAYLOAD',
      signerIdentity: testSigner,
    );

    return ContentPackage(
      manifest: manifest,
      records: records,
    );
  }

  /// Builds a tampered synthetic package where a record's text has been silently modified.
  static ContentPackage createTamperedSyntheticPackage() {
    final valid = createValidSyntheticPackage();
    final originalRecord = valid.records.first;

    // Mutate text payload without updating manifest hash
    final tamperedRecord = ContentRecord(
      contentId: originalRecord.contentId,
      contentType: originalRecord.contentType,
      text: '${originalRecord.text}_TAMPERED_BYTE',
      sources: originalRecord.sources,
      status: originalRecord.status,
      version: originalRecord.version,
      integrityHash: ContentRecord.computeHash('${originalRecord.text}_TAMPERED_BYTE'),
      createdAt: originalRecord.createdAt,
      updatedAt: originalRecord.updatedAt,
      reviewRecords: originalRecord.reviewRecords,
    );

    return ContentPackage(
      manifest: valid.manifest,
      records: [tamperedRecord, ...valid.records.skip(1)],
    );
  }
}
