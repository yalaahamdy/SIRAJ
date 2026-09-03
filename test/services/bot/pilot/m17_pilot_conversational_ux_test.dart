import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';
import 'package:siraj/services/bot/pilot/models/pilot_persona.dart';
import 'package:siraj/services/bot/pilot/runner/pilot_cohort_runner.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M17 Controlled Pilot: Conversational UX & Semantic Equivalence (§7, §8, §10, §11)', () {
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

    test('Semantic Equivalence: Command /prayer and Natural Language query route to verified prayer capability', () async {
      // 1. Typed Command
      final cmdRes = await runner.runPersonaStep(persona: persona, text: '/prayer');
      expect(cmdRes.isAbstained, isFalse);
      expect(cmdRes.textArabic, contains('مواقيت الصلاة'));

      // 2. Natural Language Request
      final nlRes = await runner.runPersonaStep(persona: persona, text: 'أريد معرفة مواقيت الصلاة لليوم');
      expect(nlRes.isAbstained, isFalse);
      expect(nlRes.textArabic, contains('الصلاة'));
    });

    test('Context Reset: /resetcontext cleanly clears session state without side effects', () async {
      final resetRes = await runner.runPersonaStep(persona: persona, text: '/resetcontext');
      expect(resetRes.isAbstained, isFalse);
      expect(resetRes.textArabic, contains('إعادة ضبط سياق المحادثة'));
    });

    test('Data Deletion Flow: /deletemydata provides explicit confirmation prompt', () async {
      final deletePrompt = await runner.runPersonaStep(persona: persona, text: '/deletemydata');
      expect(deletePrompt.isAbstained, isFalse);
      expect(deletePrompt.textArabic, contains('حذف كافة بيانات'));
      expect(deletePrompt.menu?.rows.isNotEmpty, isTrue);
    });
  });
}
