import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/hadith_book_browser_screen.dart';
import 'package:siraj/shell/knowledge/hadith_detail_screen.dart';
import 'package:siraj/shell/knowledge/knowledge_favorites_screen.dart';
import 'package:siraj/shell/knowledge/knowledge_search_screen.dart';
import 'package:siraj/shell/seed/data/canonical_knowledge_data.dart';

void main() {
  group('M05.0 Knowledge Shell & UI Expansion Test Suite', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = KnowledgeModule(storageRegistry: storage);
      final package = CanonicalKnowledgeData.getPackage();
      module.mountPackage(package);
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

    testWidgets('UI 1: HadithBookBrowserScreen renders collections and books with dynamic counts', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          HadithBookBrowserScreen(module: module),
        ),
      );
      await tester.pumpAndSettle();

      // Header and title
      expect(find.text('تصفح كتب السنة المشرفة'), findsOneWidget);
      // Collections chips
      expect(find.text('صحيح البخاري'), findsWidgets);
      // Books list
      expect(find.text('كتاب بدء الوحي'), findsOneWidget);
      expect(find.textContaining('أحاديث محققة'), findsWidgets);
    });

    testWidgets('UI 2: HadithDetailScreen renders breadcrumb, interactive Isnad, and local bookmark action', (tester) async {
      final hadith = module.getHadith('hadith_001').valueOrNull!;

      await tester.pumpWidget(
        createTestApp(
          HadithDetailScreen(hadith: hadith, module: module),
        ),
      );
      await tester.pumpAndSettle();

      // Breadcrumb path
      expect(find.textContaining('كتاب بدء الوحي'), findsWidgets);
      // Canonical Matn
      expect(find.textContaining('الأَعْمَالُ بِالنِّيَّاتِ'), findsOneWidget);
      // Interactive Isnad
      expect(find.text('سلسلة الإسناد والرواة'), findsOneWidget);

      // Bookmark action toggle
      final bookmarkBtn = find.byIcon(Icons.bookmark_border);
      expect(bookmarkBtn, findsOneWidget);
      await tester.tap(bookmarkBtn);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('UI 3: KnowledgeFavoritesScreen displays bookmarked Hadiths', (tester) async {
      await module.toggleBookmark('hadith_001');

      await tester.pumpWidget(
        createTestApp(
          KnowledgeFavoritesScreen(module: module),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المفضلة والملاحظات'), findsOneWidget);
      expect(find.textContaining('الأَعْمَالُ بِالنِّيَّاتِ'), findsOneWidget);
    });

    testWidgets('UI 4: KnowledgeSearchScreen filters by type and retrieves results', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          KnowledgeSearchScreen(module: module, initialQuery: 'النية'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('البحث في المعرفة والحديث'), findsOneWidget);
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('أحاديث نبوية'), findsOneWidget);
      expect(find.text('مسائل فقهية'), findsOneWidget);
      expect(find.textContaining('نتائج البحث'), findsOneWidget);
    });
  });
}
