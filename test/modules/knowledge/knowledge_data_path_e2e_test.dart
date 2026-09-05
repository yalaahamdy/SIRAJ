import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/knowledge/hadith_book_browser_screen.dart';
import 'package:siraj/shell/knowledge/hadith_detail_screen.dart';
import 'package:siraj/shell/knowledge/knowledge_home_screen.dart';
import 'package:siraj/shell/routing/app_router.dart';
import 'package:siraj/shell/seed/data/canonical_knowledge_data.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('M05.1 Knowledge End-to-End Data Path Verification Suite', () {
    test('Proves unbreakable chain: Canonical Data -> Seed -> Store -> Service -> UI', () {
      // Step 1: Canonical Data is strictly non-empty
      final canonicalPkg = CanonicalKnowledgeData.getPackage();
      expect(canonicalPkg.hadiths, isNotEmpty, reason: 'Canonical list must not be empty');
      expect(canonicalPkg.sources, isNotEmpty, reason: 'Canonical sources must not be empty');

      // Step 2: Seed Package is populated and authenticated
      final seedPkg = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
      expect(seedPkg.hadiths, isNotEmpty, reason: 'Seed package hadiths must not be empty');
      expect(seedPkg.hadiths.length, equals(canonicalPkg.hadiths.length));

      // Step 3: Read-Only Store mounts package correctly
      final storage = MemoryStorageRegistry();
      final module = KnowledgeModule(storageRegistry: storage);
      final mountRes = module.mountPackage(seedPkg);
      expect(mountRes.isSuccess, isTrue);

      final storeHadiths = module.store.getAllHadiths();
      expect(storeHadiths.isSuccess, isTrue);
      expect(storeHadiths.valueOrNull, isNotEmpty, reason: 'Store must not be empty after mount');

      // Step 4: Hadith Service returns non-empty collections, books, and hadiths
      final collections = module.hadithService.getHadithCollections();
      expect(collections.isSuccess, isTrue);
      expect(collections.valueOrNull, isNotEmpty, reason: 'Service must return non-empty collections');

      final bukhariCol = collections.valueOrNull!.firstWhere((c) => c.title.contains('البخاري'));
      final bukhariBooks = module.hadithService.getBooksWithCounts(bukhariCol.sourceId);
      expect(bukhariBooks.isSuccess, isTrue);
      expect(bukhariBooks.valueOrNull, isNotEmpty, reason: 'Bukhari books list must not be empty');

      final firstBook = bukhariBooks.valueOrNull!.first;
      final bookHadiths = module.hadithService.getHadithsByBook(
        bukhariCol.sourceId,
        firstBook['bookNumber'] as int,
      );
      expect(bookHadiths.isSuccess, isTrue);
      expect(bookHadiths.valueOrNull, isNotEmpty, reason: 'Book hadiths must not be empty');
    });

    testWidgets('AppRouter safely seeds KnowledgeModule if uninitialized (§20 fail-safe)', (tester) async {
      // Ensure defaultKnowledgeModule is cleared to test fail-safe lazy seeding
      AppRouter.defaultKnowledgeModule = null;

      final module = AppRouter.getOrSeedKnowledgeModule();
      expect(module.store.getAllHadiths().valueOrNull, isNotEmpty,
          reason: 'AppRouter must auto-seed knowledge package if uninitialized');

      // Pushing KnowledgeHomeScreen must render real content, not an empty state
      await tester.pumpWidget(MaterialApp(
        home: KnowledgeHomeScreen(module: module),
      ));
      await tester.pumpAndSettle();

      // Verify home screen displays the real Bukhari collection and Hadiths
      expect(find.textContaining('حديث اليوم'), findsOneWidget);
      expect(find.textContaining('صحيح البخاري'), findsWidgets);
      expect(find.text('لا توجد أحاديث مسجلة في الحزمة'), findsNothing);
    });

    testWidgets('UI Navigation Flow: Home -> Book Browser -> Book -> Hadith Detail renders real data', (tester) async {
      final module = AppRouter.getOrSeedKnowledgeModule();

      await tester.pumpWidget(MaterialApp(
        home: HadithBookBrowserScreen(module: module),
      ));
      await tester.pumpAndSettle();

      // Verify books list is rendered with real books and counts
      expect(find.byType(ListView), findsWidgets);
      expect(find.text('لا توجد كتب مسجلة لهذه المجموعة'), findsNothing);

      // Select first book
      final bookTile = find.byType(ListTile).first;
      await tester.tap(bookTile);
      await tester.pumpAndSettle();

      // Verify Hadiths of selected book are rendered
      expect(find.text('لا توجد أحاديث مسجلة في هذا الكتاب'), findsNothing);
      expect(find.textContaining('إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ'), findsOneWidget);

      // Tap on the Hadith to open detail
      await tester.tap(find.textContaining('إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ'));
      await tester.pumpAndSettle();

      // Verify HadithDetailScreen renders Matn, Isnad, and Gradings
      expect(find.byType(HadithDetailScreen), findsOneWidget);
      expect(find.textContaining('الإسناد'), findsWidgets);
      expect(find.textContaining('الإمام البخاري'), findsWidgets);
    });
  });
}
