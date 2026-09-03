import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/knowledge_home_screen.dart';
import 'package:siraj/shell/knowledge/widgets/fiqh_topic_tile.dart';
import 'package:siraj/shell/knowledge/widgets/hadith_card.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Knowledge Home Suite (§4, §7..§10, §120)', () {
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

    testWidgets('Knowledge Home 1: Renders Hadith tab, Fiqh tab, and Sources tab with mounted data', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          KnowledgeHomeScreen(module: knowledgeModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المعرفة والحديث الشريف'), findsOneWidget);
      expect(find.text('الحديث النبوي'), findsOneWidget);
      expect(find.text('الفقه المقارن'), findsOneWidget);
      expect(find.text('المصادر المعتمدة'), findsOneWidget);

      // Hadith Tab content
      expect(find.byType(HadithCard), findsOneWidget);
      expect(find.textContaining('إنما الأعمال بالنيات'), findsOneWidget);

      // Switch to Fiqh Tab
      await tester.tap(find.text('الفقه المقارن'));
      await tester.pumpAndSettle();

      expect(find.byType(FiqhTopicTile), findsOneWidget);
      expect(find.textContaining('حكم تبييت النية في صوم الفرض'), findsOneWidget);

      // Switch to Sources Tab
      await tester.tap(find.text('المصادر المعتمدة'));
      await tester.pumpAndSettle();

      expect(find.textContaining('صحيح البخاري'), findsOneWidget);
    });
  });
}
