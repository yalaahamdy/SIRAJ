import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/content_governance/engine/canonical_content_registry.dart';
import 'package:siraj/core/content_governance/engine/content_revocation_service.dart';
import 'package:siraj/core/content_governance/engine/content_signing_service.dart';
import 'package:siraj/core/content_governance/gates/production_content_gate.dart';
import 'package:siraj/core/content_governance/models/canonical_content_package.dart';
import 'package:siraj/core/content_governance/models/human_review_record.dart';

void main() {
  group('M19 Production Content Gate Verification Suite (§57, §63)', () {
    late CanonicalContentRegistry registry;
    late ContentSigningService signingService;
    late ProductionContentGate gate;
    late ContentRevocationService revocationService;

    setUp(() {
      registry = CanonicalContentRegistry();
      signingService = const ContentSigningService();
      gate = ProductionContentGate(
        registry: registry,
        signingService: signingService,
      );
      revocationService = ContentRevocationService(registry: registry);
    });

    test('Gate Check 1: Unverified or unapproved package is BLOCKED', () {
      const unapprovedPkg = CanonicalContentPackage(
        packageId: 'siraj_canonical_hadith_v1',
        contentType: 'hadith',
        contentClass: CanonicalContentClass.transmittedReligious,
        version: '1.0.0',
        sourceEdition: 'Sahih Al-Bukhari',
        contentHashSha256: 'a1b2c3d4e5f600112233445566778899aabbccddeeff00112233445566778899',
        reviewState: ContentReviewState.unverified,
      );

      registry.registerPackage(unapprovedPkg);

      final result = gate.evaluatePackageActivation(unapprovedPkg.packageId);
      expect(result.isAllowed, isFalse);
      expect(result.rejectionReasonArabic, contains('غير معتمدة'));
    });

    test('Gate Check 2: Approved but unsigned package is BLOCKED', () {
      const unsignedPkg = CanonicalContentPackage(
        packageId: 'siraj_canonical_adhkar_v1',
        contentType: 'adhkar',
        contentClass: CanonicalContentClass.transmittedReligious,
        version: '1.0.0',
        sourceEdition: 'Canonical Adhkar',
        contentHashSha256: 'b2c3d4e5f600112233445566778899aabbccddeeff00112233445566778899aa',
        reviewState: ContentReviewState.approved,
        approvedBy: 'Scholarly Committee A',
      );

      registry.registerPackage(unsignedPkg);

      final result = gate.evaluatePackageActivation(unsignedPkg.packageId);
      expect(result.isAllowed, isFalse);
      expect(result.rejectionReasonArabic, contains('التوقيع الرقمي'));
    });

    test('Gate Check 3: Signed package with hash mismatch is BLOCKED', () {
      final validPkg = CanonicalContentPackage(
        packageId: 'siraj_canonical_seerah_v1',
        contentType: 'seerah',
        contentClass: CanonicalContentClass.historical,
        version: '1.0.0',
        sourceEdition: 'Canonical Seerah 1445H',
        contentHashSha256: 'c3d4e5f600112233445566778899aabbccddeeff00112233445566778899aabb',
        reviewState: ContentReviewState.approved,
        approvedBy: 'Scholarly Committee B',
      );

      final signature = signingService.signPackage(validPkg);
      // Tamper content hash after signing
      final tamperedPkg = validPkg.copyWith(
        signature: signature,
        contentHashSha256: 'ffffffff00112233445566778899aabbccddeeff00112233445566778899aabb',
      );

      registry.registerPackage(tamperedPkg);

      final result = gate.evaluatePackageActivation(tamperedPkg.packageId);
      expect(result.isAllowed, isFalse);
      expect(result.rejectionReasonArabic, contains('فشل التحقق من التوقيع'));
    });

    test('Gate Check 4: Fully approved, signed, hash-bound package is ALLOWED and ACTIVATED', () {
      final validPkg = CanonicalContentPackage(
        packageId: 'siraj_canonical_quran_v1',
        contentType: 'quran',
        contentClass: CanonicalContentClass.sacredText,
        version: '1.0.0',
        sourceEdition: 'King Fahd Complex 1445H',
        contentHashSha256: 'e5f600112233445566778899aabbccddeeff00112233445566778899aabbccdd',
        reviewState: ContentReviewState.approved,
        approvedBy: 'Noble Quran Scholarly Board',
        approvedAt: DateTime.now(),
      );

      final signature = signingService.signPackage(validPkg);
      final signedPkg = validPkg.copyWith(
        signature: signature,
        reviewState: ContentReviewState.signed,
      );

      registry.registerPackage(signedPkg);

      // Record human review audit
      registry.recordHumanReview(HumanReviewRecord(
        recordId: 'rev_quran_001',
        packageId: signedPkg.packageId,
        version: signedPkg.version,
        reviewedHashSha256: signedPkg.contentHashSha256,
        reviewerName: 'Dr. Ahmad Al-Qari',
        reviewerRole: 'Head of Quranic Verification Committee',
        decision: HumanReviewDecision.approved,
        timestamp: DateTime.now(),
        reviewerSignature: 'SIG_ED25519_SCHOLAR_AHMAD_2026',
      ));

      final result = gate.evaluatePackageActivation(signedPkg.packageId);
      expect(result.isAllowed, isTrue);

      final activated = gate.activatePackage(signedPkg.packageId);
      expect(activated, isTrue);
      expect(registry.getPackage(signedPkg.packageId)?.isActive, isTrue);
    });

    test('Gate Check 5: Revoked package is immediately BLOCKED from activation', () {
      final validPkg = CanonicalContentPackage(
        packageId: 'siraj_canonical_fiqh_v1',
        contentType: 'fiqh',
        contentClass: CanonicalContentClass.scholarlyFiqh,
        version: '1.0.0',
        sourceEdition: 'Canonical Fiqh 1445H',
        contentHashSha256: 'f600112233445566778899aabbccddeeff00112233445566778899aabbccdde5',
        reviewState: ContentReviewState.approved,
        approvedBy: 'Fiqh Committee',
      );

      final signature = signingService.signPackage(validPkg);
      final signedPkg = validPkg.copyWith(signature: signature);
      registry.registerPackage(signedPkg);

      // Revoke
      revocationService.revokePackage(
        packageId: signedPkg.packageId,
        reasonArabic: 'اكتشاف تباين في ترقيم المسائل',
      );

      final result = gate.evaluatePackageActivation(signedPkg.packageId);
      expect(result.isAllowed, isFalse);
      expect(result.rejectionReasonArabic, contains('ملغاة'));
    });
  });
}
