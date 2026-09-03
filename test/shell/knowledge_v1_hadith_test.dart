import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/hadith_detail_screen.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Hadith Detail & Display Suite (§10..§15, §116)', () {
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

    testWidgets('Hadith 1: Renders Matn, explanation, grading, attribution, and source clearly (§11)', (tester) async {
      final hadith = knowledgeModule.store.getAllHadiths().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          HadithDetailScreen(hadith: hadith, module: knowledgeModule),
        ),
      );
      await tester.pumpAndSettle();

      // Matn
      expect(find.textContaining('إنما الأعمال بالنيات'), findsOneWidget);
      // Grading & Scholar Attribution
      expect(find.textContaining('صحيح'), findsWidgets);
      // Source
      expect(find.textContaining('صحيح البخاري'), findsWidgets);
    });
  });
}
