import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';
import 'package:siraj/services/bot/pilot/models/pilot_persona.dart';
import 'package:siraj/services/bot/pilot/runner/pilot_cohort_runner.dart';
import 'package:siraj/services/bot/runtime/api/bot_api_server.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M21 Production Pre-Launch Smoke Test Suite (§50, §51, §52)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late BotOperationsPlatform opsPlatform;
    late PilotCohortRunner pilotRunner;
    late PilotPersona persona;

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
      persona = PilotPersona.getStandardCohort().firstWhere((p) => p.type == PilotPersonaType.powerUser);
    });

    test('Smoke 1: Health endpoints, uptime, and system readiness return HTTP 200 OK', () async {
      final healthRes = await opsPlatform.runtimeEngine.apiServer.handleRequest(HttpRequestContext(
        method: 'GET',
        path: '/health',
      ));
      expect(healthRes.statusCode, equals(200));

      final readyRes = await opsPlatform.runtimeEngine.apiServer.handleRequest(HttpRequestContext(
        method: 'GET',
        path: '/ready',
      ));
      expect(readyRes.statusCode, equals(200));
    });

    test('Smoke 2: Deterministic core commands (/prayer, /quran, /adhkar) execute reliably without network dependency', () async {
      final prayerRes = await pilotRunner.runPersonaStep(persona: persona, text: '/prayer');
      expect(prayerRes.isAbstained, isFalse);
      expect(prayerRes.textArabic, contains('مواقيت الصلاة'));

      final quranRes = await pilotRunner.runPersonaStep(persona: persona, text: '/quran');
      expect(quranRes.isAbstained, isFalse);
      expect(quranRes.textArabic, contains('المصحف الشريف'));
    });

    test('Smoke 3: Account linking and token generation endpoint works safely', () async {
      final code = opsPlatform.runtimeEngine.platform.accountLinkingService.generateLinkingCode(
        'user_prod_smoke_01',
      );
      expect(code.isNotEmpty, isTrue);
      expect(code.length, equals(6));
    });

    test('Smoke 4: Global AI Kill switch instantly switches platform to deterministic mode', () async {
      opsPlatform.killSwitch.killAi(reason: 'M21 Production Pre-Launch Drill');

      final aiRes = await pilotRunner.runPersonaStep(persona: persona, text: 'ما فضل صيام يوم عرفة؟');
      expect(aiRes.isAbstained, isTrue);
      expect(aiRes.textArabic, contains('متوقفة مؤقتاً'));

      // Core commands continue working
      final adhkarRes = await pilotRunner.runPersonaStep(persona: persona, text: '/adhkar');
      expect(adhkarRes.isAbstained, isFalse);
      expect(adhkarRes.textArabic, contains('الأذكار'));
    });
  });
}
