import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/fiqh_topic_screen.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Fiqh Disagreement & Positions Suite (§15..§19, §120)', () {
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

    testWidgets('Fiqh 1: Displays multiple school positions without false consensus or personal fatwa', (tester) async {
      final topic = knowledgeModule.fiqhService.getAllTopics().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          FiqhTopicScreen(
            topic: topic,
            module: knowledgeModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('حكم تبييت النية في صوم الفرض'), findsWidgets);
      expect(find.text('أقوال المذاهب الفقهية المعتمدة'), findsOneWidget);

      // Hanafi & Majority positions are preserved distinctly
      expect(find.text('المذهب الحنفي'), findsOneWidget);
      expect(find.text('جمهور الفقهاء'), findsOneWidget);
      expect(find.textContaining('تصح النية في صوم رمضان إلى ما قبل نصف النهار الشرعي'), findsOneWidget);
      expect(find.textContaining('يشترط تبييت النية من الليل لكل يوم من أيام صيام الفرض'), findsOneWidget);
    });
  });
}
