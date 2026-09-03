import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/hadith_detail_screen.dart';
import 'package:siraj/shell/knowledge/knowledge_home_screen.dart';
import 'package:siraj/shell/knowledge/knowledge_search_screen.dart';
import 'package:siraj/shell/knowledge/widgets/hadith_card.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L4 Knowledge Shell UI & Interaction Tests (§45, §46)', () {
    late MemoryStorageRegistry registry;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      knowledgeModule.mountPackage(pkg);
    });

    testWidgets('KnowledgeHomeScreen renders tabs and cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: KnowledgeHomeScreen(module: knowledgeModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المعرفة والحديث الشريف'), findsOneWidget);
      expect(find.text('الحديث النبوي'), findsOneWidget);
      expect(find.text('الفقه المقارن'), findsOneWidget);
      expect(find.text('المصادر المعتمدة'), findsOneWidget);
      expect(find.byType(HadithCard), findsOneWidget);
    });

    testWidgets('Tapping HadithCard navigates to HadithDetailScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: KnowledgeHomeScreen(module: knowledgeModule),
        ),
      );
      await tester.pumpAndSettle();

      final hadithCard = find.byType(HadithCard);
      expect(hadithCard, findsOneWidget);
      await tester.tap(hadithCard);
      await tester.pumpAndSettle();

      expect(find.byType(HadithDetailScreen), findsOneWidget);
      expect(find.text('المتن العربي الأصيل'), findsOneWidget);
      expect(find.textContaining('إنما الأعمال بالنيات'), findsOneWidget);
    });

    testWidgets('KnowledgeSearchScreen performs search and displays results', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: KnowledgeSearchScreen(module: knowledgeModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('البحث في المعرفة والحديث'), findsOneWidget);

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'النيات');
      await tester.pumpAndSettle();

      expect(find.textContaining('كتاب بدء الوحي'), findsOneWidget);
    });
  });
}
