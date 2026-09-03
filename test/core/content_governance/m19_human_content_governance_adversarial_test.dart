import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/content_governance/engine/canonical_content_registry.dart';
import 'package:siraj/core/content_governance/engine/content_revocation_service.dart';
import 'package:siraj/core/content_governance/engine/content_signing_service.dart';
import 'package:siraj/core/content_governance/engine/production_content_importer.dart';
import 'package:siraj/core/content_governance/gates/production_content_gate.dart';
import 'package:siraj/core/content_governance/models/canonical_content_package.dart';

void main() {
  group('M19 Content Governance Adversarial & Resilience Suite (§47, §59)', () {
    late CanonicalContentRegistry registry;
    late ContentSigningService signingService;
    late ProductionContentGate gate;
    late ProductionContentImporter importer;
    late ContentRevocationService revocationService;

    setUp(() {
      registry = CanonicalContentRegistry();
      signingService = const ContentSigningService();
      gate = ProductionContentGate(
        registry: registry,
        signingService: signingService,
      );
      importer = ProductionContentImporter(
        registry: registry,
        signingService: signingService,
      );
      revocationService = ContentRevocationService(registry: registry);
    });

    test('Adversarial 1: Synthetic test fixtures are strictly blocked from production activation', () {
      const syntheticPkg = CanonicalContentPackage(
        packageId: 'siraj_synthetic_knowledge_fixture_v1',
        contentType: 'knowledge',
        contentClass: CanonicalContentClass.transmittedReligious,
        version: '1.0.0',
        sourceEdition: 'Synthetic Fixture Edition',
        contentHashSha256: 'deadbeef00112233445566778899aabbccddeeff00112233445566778899aabb',
        reviewState: ContentReviewState.approved,
        approvedBy: 'Auto Test Generator',
        isSynthetic: true,
      );

      registry.registerPackage(syntheticPkg);

      // Gate check
      final result = gate.evaluatePackageActivation(syntheticPkg.packageId);
      expect(result.isAllowed, isFalse);
      expect(result.rejectionReasonArabic, contains('جدار الحماية'));

      // Importer check
      final imported = importer.importPackage(syntheticPkg);
      expect(imported, isFalse);
    });

    test('Adversarial 2: Fake reviewer claim without verifiable audit trail is blocked', () {
      final fakePkg = CanonicalContentPackage(
        packageId: 'siraj_hajj_unverified_v1',
        contentType: 'hajj',
        contentClass: CanonicalContentClass.calculationalPolicy,
        version: '1.0.0',
        sourceEdition: 'Hajj Guide 1445H',
        contentHashSha256: '112233445566778899aabbccddeeff00112233445566778899aabbccddeeff00',
        reviewState: ContentReviewState.approved,
        approvedBy: 'Anonymous Reviewer',
      );

      final signature = signingService.signPackage(fakePkg);
      final signedFakePkg = fakePkg.copyWith(signature: signature);

      registry.registerPackage(signedFakePkg);

      final result = gate.evaluatePackageActivation(signedFakePkg.packageId);
      expect(result.isAllowed, isFalse);
      expect(result.rejectionReasonArabic, contains('سجل مراجعة بشرية'));
    });

    test('Adversarial 3: Emergency quarantine immediately isolates compromised package', () {
      final pkg = CanonicalContentPackage(
        packageId: 'siraj_learning_paths_v1',
        contentType: 'learning',
        contentClass: CanonicalContentClass.educational,
        version: '1.0.0',
        sourceEdition: 'Islamic Studies Foundation',
        contentHashSha256: '998877665544332211aabbccddeeff00112233445566778899aabbccddeeff00',
        reviewState: ContentReviewState.approved,
        approvedBy: 'Curriculum Board',
      );

      final signature = signingService.signPackage(pkg);
      final signedPkg = pkg.copyWith(signature: signature);
      registry.registerPackage(signedPkg);

      // Quarantine
      final quarantined = revocationService.quarantinePackage(
        packageId: signedPkg.packageId,
        reasonArabic: 'اشتباه في تدليس نص تعليمي',
      );
      expect(quarantined, isTrue);

      final result = gate.evaluatePackageActivation(signedPkg.packageId);
      expect(result.isAllowed, isFalse);
      expect(result.rejectionReasonArabic, contains('محجورة'));
    });
  });
}
