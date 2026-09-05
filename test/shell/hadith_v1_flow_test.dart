import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/hadith_detail_screen.dart';
import 'package:siraj/shell/knowledge/widgets/provenance_badge.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Hadith Flow & Provenance Suite (§8..§14, §120)', () {
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

    testWidgets('Hadith 1: Detail screen distinctly separates Matn, Gradings, and Commentaries', (tester) async {
      final hadith = knowledgeModule.store.getAllHadiths().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          HadithDetailScreen(
            hadith: hadith,
            module: knowledgeModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Matn
      expect(find.text('المتن العربي الأصيل'), findsOneWidget);
      expect(find.textContaining('إنما الأعمال بالنيات'), findsOneWidget);

      // 2. Grading & Provenance
      expect(find.text('درجة الحديث والتخريج المعتمد'), findsOneWidget);
      expect(find.byType(ProvenanceBadge), findsOneWidget);
      expect(find.text('صحيح'), findsOneWidget);
      expect(find.text('الإمام البخاري'), findsOneWidget);

      // 3. Commentaries
      await tester.scrollUntilVisible(find.text('الشروح والفوائد العلمية المنسوبة'), 100);
      expect(find.text('الشروح والفوائد العلمية المنسوبة'), findsOneWidget);
      expect(find.textContaining('الحافظ ابن حجر العسقلاني'), findsOneWidget);
    });
  });
}
