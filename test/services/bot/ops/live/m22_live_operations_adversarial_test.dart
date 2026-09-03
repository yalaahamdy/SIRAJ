import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/content_governance/engine/canonical_content_registry.dart';
import 'package:siraj/core/content_governance/engine/content_signing_service.dart';
import 'package:siraj/core/content_governance/models/canonical_content_package.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';
import 'package:siraj/services/bot/ops/live/models/content_incident.dart';
import 'package:siraj/services/bot/ops/live/models/user_feedback.dart';
import 'package:siraj/services/bot/ops/live/services/continuous_verification_service.dart';
import 'package:siraj/services/bot/ops/live/services/feedback_service.dart';
import 'package:siraj/services/bot/ops/live/services/incident_triage_engine.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import '../../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M22 Live Operations & Incident Response Adversarial Suite (§15, §19, §59, §81)', () {
    late FeedbackService feedbackService;
    late IncidentTriageEngine triageEngine;
    late CanonicalContentRegistry registry;
    late ContentSigningService signingService;
    late BotOperationsPlatform opsPlatform;
    late ContinuousVerificationService verificationService;

    setUp(() {
      feedbackService = FeedbackService();
      triageEngine = IncidentTriageEngine();
      registry = CanonicalContentRegistry();
      signingService = const ContentSigningService();

      final storage = MemoryStorageRegistry();
      final adhkar = AdhkarModule(storageRegistry: storage);
      adhkar.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final knowledge = KnowledgeModule(storageRegistry: storage);
      knowledge.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      final runtime = BotRuntimeEngine.bootstrap(
        adhkarModule: adhkar,
        knowledgeModule: knowledge,
      );

      opsPlatform = BotOperationsPlatform.bootstrap(
        runtimeEngine: runtime,
      );

      verificationService = ContinuousVerificationService(
        opsPlatform: opsPlatform,
        registry: registry,
        signingService: signingService,
      );
    });

    test('Feedback 1: Submitting anonymous content issue preserves privacy and records feedback', () {
      final feedbackId = feedbackService.submitFeedback(
        category: FeedbackCategory.contentIssue,
        reason: 'اشتباه في عزو حديث',
        detailsArabic: 'أرى أن السند المذكور في المسألة رقم 5 يحتاج لمراجعة إضافية',
        isAnonymous: true,
        submitterId: 'sensitive_user_phone_0500000000',
      );

      expect(feedbackId.isNotEmpty, isTrue);
      expect(feedbackService.feedbackRecords.length, equals(1));

      final record = feedbackService.feedbackRecords.first;
      expect(record.isAnonymous, isTrue);
      expect(record.submitterId, isNull); // Privacy redacted
    });

    test('Incident 1: Critical religious content incident triggers automatic containment', () {
      final incident = triageEngine.registerIncident(
        contentId: 'ayah_002_255',
        packageId: 'siraj_canonical_quran_v1',
        releaseId: 'rel_prod_1_22_0',
        reportedBy: 'Scholar Reviewer C',
        severity: IncidentSeverity.critical,
        descriptionArabic: 'اشتباه في علامة ضبط غير دقيقة',
      );

      expect(incident.severity, equals(IncidentSeverity.critical));
      expect(incident.status, equals(IncidentStatus.contained));
      expect(incident.containmentAction, contains('تم عزل المحتوى فوراً'));
    });

    test('Verification 1: Continuous probe verifies system health and signing integrity without mutation', () async {
      final validPkg = CanonicalContentPackage(
        packageId: 'siraj_canonical_adhkar_v1',
        contentType: 'adhkar',
        contentClass: CanonicalContentClass.transmittedReligious,
        version: '1.0.0',
        sourceEdition: 'Canonical Adhkar 1445H',
        contentHashSha256: 'aa11223344556677889900aabbccddeeff0011223344556677889900aabbccddee',
        reviewState: ContentReviewState.active,
        approvedBy: 'Noble Adhkar Board',
      );

      final sig = signingService.signPackage(validPkg);
      final signedPkg = validPkg.copyWith(signature: sig);
      registry.registerPackage(signedPkg);

      final probeResult = await verificationService.runContinuousProbe();
      expect(probeResult['api_ready'], isTrue);
      expect(probeResult['packages_integrity_valid'], isTrue);
      expect(probeResult['active_packages_count'], equals(1));
    });
  });
}
