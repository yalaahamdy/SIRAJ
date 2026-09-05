import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('M05.1 Knowledge Corpus Inventory & Verification Suite', () {
    late KnowledgeModule module;

    setUp(() {
      final storage = MemoryStorageRegistry();
      module = KnowledgeModule(storageRegistry: storage);
      final pkg = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
      module.mountPackage(pkg);
    });

    test('Computes and logs complete dynamic inventory from real production corpus', () {
      final collectionsRes = module.hadithService.getHadithCollections();
      expect(collectionsRes.isSuccess, isTrue);
      final collections = collectionsRes.valueOrNull!;
      expect(collections, isNotEmpty);

      final hadithsRes = module.store.getAllHadiths();
      expect(hadithsRes.isSuccess, isTrue);
      final hadiths = hadithsRes.valueOrNull!;
      expect(hadiths, isNotEmpty);

      final fiqhRes = module.store.getAllFiqhTopics();
      expect(fiqhRes.isSuccess, isTrue);
      final fiqhTopics = fiqhRes.valueOrNull!;
      expect(fiqhTopics, isNotEmpty);

      final relationsRes = module.store.getAllRelations();
      expect(relationsRes.isSuccess, isTrue);
      final relations = relationsRes.valueOrNull!;

      // Derive distinct books and chapters across collections dynamically
      final distinctBooks = <String>{};
      final distinctChapters = <String>{};
      final collectionBookStats = <String, Map<String, dynamic>>{};

      for (final h in hadiths) {
        final bookKey = '${h.collectionId}_${h.bookNumber}_${h.bookName}';
        distinctBooks.add(bookKey);
        final chapterKey = '${bookKey}_${h.chapterName}';
        distinctChapters.add(chapterKey);
      }

      for (final col in collections) {
        final booksRes = module.hadithService.getBooksWithCounts(col.sourceId);
        final books = booksRes.valueOrNull ?? [];
        final colHadiths = hadiths.where((h) => h.collectionId == col.sourceId).toList();
        collectionBookStats[col.title] = {
          'booksCount': books.length,
          'hadithsCount': colHadiths.length,
        };
      }

      // Print forensic inventory log
      // ignore: avoid_print
      print('\n======================================================');
      // ignore: avoid_print
      print('📜 M05.1 SIRAJ REAL KNOWLEDGE CORPUS INVENTORY REPORT:');
      // ignore: avoid_print
      print('------------------------------------------------------');
      // ignore: avoid_print
      print('• Collections (المجموعات السنية): ${collections.length}');
      // ignore: avoid_print
      print('• Distinct Books (الكتب):         ${distinctBooks.length}');
      // ignore: avoid_print
      print('• Distinct Chapters (الأبواب):     ${distinctChapters.length}');
      // ignore: avoid_print
      print('• Hadiths (الأحاديث النبوية):     ${hadiths.length}');
      // ignore: avoid_print
      print('• Fiqh Topics (المسائل الفقهية):  ${fiqhTopics.length}');
      // ignore: avoid_print
      print('• Knowledge Relations (العلاقات): ${relations.length}');
      // ignore: avoid_print
      print('------------------------------------------------------');
      // ignore: avoid_print
      print('📊 تفصيل كتب وأحاديث المجموعات:');
      collectionBookStats.forEach((title, stats) {
        // ignore: avoid_print
        print('  - $title: ${stats['booksCount']} كتب، ${stats['hadithsCount']} أحاديث');
      });
      // ignore: avoid_print
      print('======================================================\n');

      // Assert hard constraints derived dynamically
      expect(collections.length, greaterThanOrEqualTo(8), reason: 'Must cover at least 8 canonical collections');
      expect(distinctBooks.length, greaterThanOrEqualTo(25), reason: 'Must cover at least 25 classical books');
      expect(distinctChapters.length, greaterThanOrEqualTo(50), reason: 'Must cover at least 50 chapters');
      expect(hadiths.length, greaterThanOrEqualTo(100), reason: 'Must contain at least 100 verified Hadiths');
      expect(fiqhTopics.length, greaterThanOrEqualTo(32), reason: 'Must contain at least 32 Fiqh topics');
    });
  });
}
