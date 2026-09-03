import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';
import 'package:siraj/services/bot/pilot/models/pilot_persona.dart';
import 'package:siraj/services/bot/pilot/runner/pilot_cohort_runner.dart';
import 'package:siraj/services/bot/runtime/api/bot_api_server.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M18 Release Candidate Full System Verification Suite (§37, §68)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late BotOperationsPlatform opsPlatform;
    late PilotCohortRunner pilotRunner;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      final runtime = BotRuntimeEngine.bootstrap(
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );

      opsPlatform = BotOperationsPlatform.bootstrap(
        runtimeEngine: runtime,
      );

      pilotRunner = PilotCohortRunner(operationsPlatform: opsPlatform);
    });

    test('Gate 1 & 2: Full End-to-End Release Candidate executes verified prayer, quran, and adhkar flows', () async {
      final powerUser = PilotPersona.getStandardCohort().firstWhere((p) => p.type == PilotPersonaType.powerUser);

      // 1. Prayer Command
      final prayerRes = await pilotRunner.runPersonaStep(persona: powerUser, text: '/prayer');
      expect(prayerRes.isAbstained, isFalse);
      expect(prayerRes.textArabic, contains('مواقيت الصلاة'));

      // 2. Quran Command
      final quranRes = await pilotRunner.runPersonaStep(persona: powerUser, text: '/quran');
      expect(quranRes.isAbstained, isFalse);
      expect(quranRes.textArabic, contains('المصحف الشريف'));

      // 3. Adhkar Command
      final adhkarRes = await pilotRunner.runPersonaStep(persona: powerUser, text: '/adhkar');
      expect(adhkarRes.isAbstained, isFalse);
      expect(adhkarRes.textArabic, contains('الأذكار'));
    });

    test('Gate 3: Sensitive data redaction and zero secret exposure in responses and API metrics', () async {
      final healthRes = await opsPlatform.adminApiServer.handleAdminRequest(HttpRequestContext(
        method: 'GET',
        path: '/admin/dashboard',
      ));

      expect(healthRes.statusCode, equals(200));
      final json = jsonDecode(healthRes.body);
      final jsonStr = jsonEncode(json);

      // Verify no secrets or sensitive terms leaked
      expect(jsonStr.contains('password'), isFalse);
      expect(jsonStr.contains('secret_key'), isFalse);
      expect(jsonStr.contains('private_token'), isFalse);
    });

    test('Gate 4: Emergency Kill Switch drill freezes conversational AI while preserving core worship commands', () async {
      // 1. Trigger AI kill
      opsPlatform.killSwitch.killAi(reason: 'M18 Pre-Release Safety Drill');

      final powerUser = PilotPersona.getStandardCohort().firstWhere((p) => p.type == PilotPersonaType.powerUser);

      // 2. AI conversational query is safely gated
      final aiRes = await pilotRunner.runPersonaStep(persona: powerUser, text: 'ما فضل صيام يوم عاشوراء؟');
      expect(aiRes.isAbstained, isTrue);
      expect(aiRes.textArabic, contains('الأوامر الحتمية'));

      // 3. Core worship command works perfectly
      final prayerRes = await pilotRunner.runPersonaStep(persona: powerUser, text: '/prayer');
      expect(prayerRes.isAbstained, isFalse);
      expect(prayerRes.textArabic, contains('مواقيت الصلاة'));
    });
  });
}
