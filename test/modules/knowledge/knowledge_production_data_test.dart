import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('M05.1 Knowledge Production Data Integrity & Forensic Test Suite', () {
    late KnowledgeModule module;

    setUp(() {
      final storage = MemoryStorageRegistry();
      module = KnowledgeModule(storageRegistry: storage);
      final pkg = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
      module.mountPackage(pkg);
    });

    test('Production corpus adheres to strict authenticity and completeness standards', () {
      final collectionsRes = module.hadithService.getHadithCollections();
      expect(collectionsRes.isSuccess, isTrue);
      final collections = collectionsRes.valueOrNull!;
      expect(collections, isNotEmpty, reason: 'Collections must be non-empty');

      final hadithsRes = module.store.getAllHadiths();
      expect(hadithsRes.isSuccess, isTrue);
      final hadiths = hadithsRes.valueOrNull!;
      expect(hadiths, isNotEmpty, reason: 'Hadiths list must be non-empty');

      final seenIds = <String>{};

      for (final h in hadiths) {
        // No duplicate IDs
        expect(seenIds.contains(h.hadithId), isFalse,
            reason: 'Duplicate Hadith ID detected: ${h.hadithId}');
        seenIds.add(h.hadithId);

        // Every hadith has source
        expect(h.sourceId.trim(), isNotEmpty,
            reason: 'Hadith ${h.hadithId} must have a valid sourceId');
        expect(collections.any((c) => c.sourceId == h.sourceId), isTrue,
            reason: 'Hadith ${h.hadithId} references unknown source: ${h.sourceId}');

        // Every hadith has non-empty Arabic Matn
        expect(h.arabicMatn.trim(), isNotEmpty,
            reason: 'Hadith ${h.hadithId} has empty Arabic matn');
        expect(h.arabicMatn.length, greaterThanOrEqualTo(10),
            reason: 'Hadith ${h.hadithId} matn is too short to be authentic');

        // Every hadith has real book and chapter
        expect(h.bookName.trim(), isNotEmpty,
            reason: 'Hadith ${h.hadithId} has empty bookName');
        expect(h.chapterName?.trim().isNotEmpty ?? false, isTrue,
            reason: 'Hadith ${h.hadithId} has empty chapterName');
        expect(h.bookNumber, greaterThanOrEqualTo(0),
            reason: 'Hadith ${h.hadithId} has invalid bookNumber');
        expect(h.chapterNumber ?? 0, greaterThanOrEqualTo(0),
            reason: 'Hadith ${h.hadithId} has invalid chapterNumber');

        // Every hadith has primary and international numbers
        expect(h.primaryNumber, greaterThan(0),
            reason: 'Hadith ${h.hadithId} has invalid primaryNumber');
        expect(h.internationalNumber ?? 0, greaterThanOrEqualTo(0),
            reason: 'Hadith ${h.hadithId} has invalid internationalNumber');

        // No placeholder text
        expect(h.arabicMatn.contains('سيتم تحميل'), isFalse,
            reason: 'Hadith ${h.hadithId} contains placeholder text');
        expect(h.arabicMatn.contains('placeholder'), isFalse,
            reason: 'Hadith ${h.hadithId} contains placeholder text');
        expect(h.isnad?.contains('placeholder') ?? false, isFalse,
            reason: 'Hadith ${h.hadithId} isnad contains placeholder text');

        // Integrity hash must match computed cryptographic SHA-256 hash
        expect(h.verifyHash(), isTrue,
            reason: 'Hadith ${h.hadithId} integrity hash is tampered or corrupted');
      }

      // Check Bukhari books cover required core books (Requirement 10)
      final bukhariCol = collections.firstWhere((c) => c.title.contains('البخاري'));
      final bukhariBooksRes = module.hadithService.getBooksWithCounts(bukhariCol.sourceId);
      expect(bukhariBooksRes.isSuccess, isTrue);
      final bukhariBooks = bukhariBooksRes.valueOrNull!;

      final bukhariBookNames = bukhariBooks.map((b) => b['bookName'] as String).toList();
      expect(bukhariBookNames.any((n) => n.contains('الإيمان')), isTrue,
          reason: 'Bukhari must contain كتاب الإيمان');
      expect(bukhariBookNames.any((n) => n.contains('العلم')), isTrue,
          reason: 'Bukhari must contain كتاب العلم');
      expect(bukhariBookNames.any((n) => n.contains('الوضوء')), isTrue,
          reason: 'Bukhari must contain كتاب الوضوء');
      expect(bukhariBookNames.any((n) => n.contains('الصلاة')), isTrue,
          reason: 'Bukhari must contain كتاب الصلاة');

      // Check Muslim books cover required core books (Requirement 10)
      final muslimCol = collections.firstWhere((c) => c.title.contains('مسلم'));
      final muslimBooksRes = module.hadithService.getBooksWithCounts(muslimCol.sourceId);
      expect(muslimBooksRes.isSuccess, isTrue);
      final muslimBooks = muslimBooksRes.valueOrNull!;

      final muslimBookNames = muslimBooks.map((b) => b['bookName'] as String).toList();
      expect(muslimBookNames.any((n) => n.contains('الإيمان')), isTrue,
          reason: 'Muslim must contain كتاب الإيمان');
      expect(muslimBookNames.any((n) => n.contains('الطهارة')), isTrue,
          reason: 'Muslim must contain كتاب الطهارة');
      expect(muslimBookNames.any((n) => n.contains('الصلاة')), isTrue,
          reason: 'Muslim must contain كتاب الصلاة');
    });

    test('Search engine successfully retrieves real Hadiths across books and keywords (Requirement 11)', () {
      final searchRes1 = module.searchService.search('الأعمال بالنيات');
      expect(searchRes1.isSuccess, isTrue);
      expect(searchRes1.valueOrNull!, isNotEmpty,
          reason: 'Searching for الأعمال بالنيات must return at least 1 hadith');

      final searchRes2 = module.searchService.search('الصلاة');
      expect(searchRes2.isSuccess, isTrue);
      expect(searchRes2.valueOrNull!, isNotEmpty,
          reason: 'Searching for الصلاة must return results');

      final searchRes3 = module.searchService.search('الإيمان');
      expect(searchRes3.isSuccess, isTrue);
      expect(searchRes3.valueOrNull!, isNotEmpty,
          reason: 'Searching for الإيمان must return results');

      final searchRes4 = module.searchService.search('الوضوء');
      expect(searchRes4.isSuccess, isTrue);
      expect(searchRes4.valueOrNull!, isNotEmpty,
          reason: 'Searching for الوضوء must return results');
    });
  });
}
