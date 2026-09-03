import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/fiqh_topic_screen.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Comparative Fiqh & Multi-School Suite (§19..§24, §116, §119)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      );
    }

    testWidgets('Fiqh 1: Renders distinct school positions without merging (§20, §21)', (tester) async {
      final topic = knowledgeModule.store.getAllFiqhTopics().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          FiqhTopicScreen(topic: topic, module: knowledgeModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(topic.title), findsWidgets);
      // Header for school positions
      expect(find.text('أقوال المذاهب الفقهية المعتمدة'), findsOneWidget);
      // School names
      for (final pos in topic.positions) {
        expect(find.text(pos.school.labelArabic), findsWidgets);
      }
    });
  });
}
