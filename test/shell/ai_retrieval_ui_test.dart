import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/ai/ai_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/ai/ai_search_query_screen.dart';
import 'package:siraj/shell/ai/widgets/abstention_card.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L4 AI Retrieval Shell UI Tests (§46, §47)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late AIModule aiModule;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      aiModule = AIModule(
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    testWidgets('AISearchQueryScreen renders search interface and disclaimer', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: AISearchQueryScreen(module: aiModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الاسترجاع المعرفي الموثق بالأدلة'), findsOneWidget);
      expect(find.textContaining('سِراج يقدم استرجاعاً وتوثيقاً'), findsOneWidget);
    });

    testWidgets('Submitting fatwa query displays AbstentionCard in UI', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: AISearchQueryScreen(module: aiModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'افتني في مسألة طرأت لي');
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(AbstentionCard), findsOneWidget);
      expect(find.text('تحفظ شرعي وتحري أمان المعرفة'), findsOneWidget);
    });
  });
}
