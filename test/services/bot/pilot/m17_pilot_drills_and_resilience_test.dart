import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';
import 'package:siraj/services/bot/ops/lifecycle/channel_lifecycle_manager.dart';
import 'package:siraj/services/bot/pilot/models/pilot_persona.dart';
import 'package:siraj/services/bot/pilot/runner/pilot_cohort_runner.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M17 Controlled Pilot: Operational Drills & Resilience Suite (§50, §51, §52, §53)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late BotOperationsPlatform opsPlatform;
    late PilotCohortRunner runner;
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

      runner = PilotCohortRunner(operationsPlatform: opsPlatform);
      persona = PilotPersona.getStandardCohort().firstWhere((p) => p.type == PilotPersonaType.powerUser);
    });

    test('Drill 1: AI Outage Drill — Deterministic core commands (/prayer, /quran, /adhkar) remain fully operational', () async {
      // Simulate AI kill / outage
      opsPlatform.killSwitch.killAi(reason: 'Scheduled AI Outage Drill');

      // 1. Natural conversation is safely abstained
      final aiRes = await runner.runPersonaStep(persona: persona, text: 'ما فضل صيام يوم عرفة؟');
      expect(aiRes.isAbstained, isTrue);
      expect(aiRes.textArabic, contains('الأوامر الحتمية'));

      // 2. Deterministic commands work perfectly
      final prayerRes = await runner.runPersonaStep(persona: persona, text: '/prayer');
      final quranRes = await runner.runPersonaStep(persona: persona, text: '/quran');
      final adhkarRes = await runner.runPersonaStep(persona: persona, text: '/adhkar');

      expect(prayerRes.isAbstained, isFalse);
      expect(quranRes.isAbstained, isFalse);
      expect(adhkarRes.isAbstained, isFalse);
    });

    test('Drill 2: Channel Outage Drill — Disabling Telegram leaves WhatsApp and API unaffected', () async {
      // Disable Telegram channel
      opsPlatform.channelLifecycle.setChannelState(ChannelType.telegram, ChannelLifecycleState.disabled);

      // WhatsApp Persona interacts normally
      final waPersona = PilotPersona.getStandardCohort().firstWhere((p) => p.type == PilotPersonaType.worshipRoutineUser);
      final waRes = await runner.runPersonaStep(persona: waPersona, text: '/prayer');
      expect(waRes.isAbstained, isFalse);
      expect(waRes.textArabic, contains('مواقيت الصلاة'));

      // API Persona interacts normally
      final apiPersona = PilotPersona.getStandardCohort().firstWhere((p) => p.type == PilotPersonaType.powerUser);
      final apiRes = await runner.runPersonaStep(persona: apiPersona, text: '/adhkar');
      expect(apiRes.isAbstained, isFalse);
      expect(apiRes.textArabic, contains('الأذكار'));
    });
  });
}
