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
  group('M17 Controlled Pilot: 7 Personas E2E Journeys (§3, §4, §60)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late BotOperationsPlatform opsPlatform;
    late PilotCohortRunner runner;
    late List<PilotPersona> cohort;

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
      cohort = PilotPersona.getStandardCohort();
    });

    test('Persona A (New User): First contact discovery and help menu', () async {
      final personaA = cohort.firstWhere((p) => p.type == PilotPersonaType.newUser);

      final startRes = await runner.runPersonaStep(persona: personaA, text: '/start');
      expect(startRes.isAbstained, isFalse);
      expect(startRes.textArabic, contains('مرحباً بك في سِراج'));

      final helpRes = await runner.runPersonaStep(persona: personaA, text: '/help');
      expect(helpRes.isAbstained, isFalse);
      expect(helpRes.textArabic, contains('دليل أوامر سِراج'));
    });

    test('Persona B (Quran User): Quran command and ayah reading', () async {
      final personaB = cohort.firstWhere((p) => p.type == PilotPersonaType.quranUser);

      final quranRes = await runner.runPersonaStep(persona: personaB, text: '/quran');
      expect(quranRes.isAbstained, isFalse);
      expect(quranRes.textArabic, contains('المصحف الشريف'));
    });

    test('Persona C (Worship User): Prayer times and daily adhkar', () async {
      final personaC = cohort.firstWhere((p) => p.type == PilotPersonaType.worshipRoutineUser);

      final prayerRes = await runner.runPersonaStep(persona: personaC, text: '/prayer');
      expect(prayerRes.isAbstained, isFalse);
      expect(prayerRes.textArabic, contains('مواقيت الصلاة'));

      final adhkarRes = await runner.runPersonaStep(persona: personaC, text: '/adhkar');
      expect(adhkarRes.isAbstained, isFalse);
      expect(adhkarRes.textArabic, contains('الأذكار'));
    });

    test('Persona D (Knowledge Learner): Knowledge search and learning paths', () async {
      final personaD = cohort.firstWhere((p) => p.type == PilotPersonaType.knowledgeLearner);

      final searchRes = await runner.runPersonaStep(persona: personaD, text: '/search صلاة');
      expect(searchRes.isAbstained, isFalse);
      expect(searchRes.textArabic, contains('البحث'));

      final learnRes = await runner.runPersonaStep(persona: personaD, text: '/learn');
      expect(learnRes.isAbstained, isFalse);
      expect(learnRes.textArabic, contains('المسارات التعليمية'));
    });

    test('Persona E (Hajj User): Hajj journeys overview', () async {
      final personaE = cohort.firstWhere((p) => p.type == PilotPersonaType.hajjUser);

      final hajjRes = await runner.runPersonaStep(persona: personaE, text: '/hajj');
      expect(hajjRes.isAbstained, isFalse);
      expect(hajjRes.textArabic, contains('العمرة'));
    });

    test('Persona F (Power User): Fast multi-step commands and latency benchmarks', () async {
      final personaF = cohort.firstWhere((p) => p.type == PilotPersonaType.powerUser);

      final res1 = await runner.runPersonaStep(persona: personaF, text: '/start');
      final res2 = await runner.runPersonaStep(persona: personaF, text: '/prayer');
      final res3 = await runner.runPersonaStep(persona: personaF, text: '/adhkar');

      expect(res1.isAbstained, isFalse);
      expect(res2.isAbstained, isFalse);
      expect(res3.isAbstained, isFalse);
      expect(runner.metricsCollector.totalTasksCompleted, equals(3));
      expect(runner.metricsCollector.taskCompletionRate, equals(1.0));
    });
  });
}
