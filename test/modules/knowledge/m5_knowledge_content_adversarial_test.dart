import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/domain/canonical_knowledge_package.dart';
import 'package:siraj/modules/knowledge/domain/hadith_entity.dart';
import 'package:siraj/modules/knowledge/domain/hadith_grading.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/seed/data/canonical_knowledge_data.dart';

void main() {
  group('M05.0 Knowledge & Hadith Content Adversarial & Expansion Test Suite', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = KnowledgeModule(storageRegistry: storage);
      final package = CanonicalKnowledgeData.getPackage();
      final mountRes = module.mountPackage(package);
      expect(mountRes.isSuccess, isTrue, reason: 'Canonical knowledge package must pass cryptographic verification');
    });

    test('Verification 1: Full Sunnah expansion with >= 40 authentic Hadiths and 8 Sunnah collections', () {
      final hadithsRes = module.store.getAllHadiths();
      expect(hadithsRes.isSuccess, isTrue);
      final hadiths = hadithsRes.valueOrNull!;
      expect(hadiths.length, greaterThanOrEqualTo(40));

      final collectionsRes = module.hadithService.getHadithCollections();
      expect(collectionsRes.isSuccess, isTrue);
      final collections = collectionsRes.valueOrNull!;
      expect(collections.length, greaterThanOrEqualTo(8));

      // Verify representations from each of the 8 canonical Sunnah collections
      final collectionIds = hadiths.map((h) => h.collectionId).toSet();
      expect(collectionIds, contains('src_bukhari_canonical'));
      expect(collectionIds, contains('src_muslim_canonical'));
      expect(collectionIds, contains('src_abudawud_canonical'));
      expect(collectionIds, contains('src_tirmidhi_canonical'));
      expect(collectionIds, contains('src_nasai_canonical'));
      expect(collectionIds, contains('src_ibnmajah_canonical'));
      expect(collectionIds, contains('src_muwatta_canonical'));
      expect(collectionIds, contains('src_musnad_canonical'));
    });

    test('Verification 2: Multi-school Comparative Fiqh expansion with >= 15 verified topics', () {
      final topicsRes = module.fiqhService.getAllTopics();
      expect(topicsRes.isSuccess, isTrue);
      final topics = topicsRes.valueOrNull!;
      expect(topics.length, greaterThanOrEqualTo(15));

      // Verify multi-school presence across topics
      final categoriesRes = module.fiqhService.getCategories();
      expect(categoriesRes.isSuccess, isTrue);
      final categories = categoriesRes.valueOrNull!;
      expect(categories, contains('فقه الطهارة'));
      expect(categories, contains('فقه الصلاة'));
      expect(categories, contains('فقه الزكاة'));
      expect(categories, contains('فقه الصيام'));
      expect(categories, contains('فقه المعاملات والبيوع'));
    });

    test('Verification 3: Deterministic Daily Hadith selection', () {
      final date1 = DateTime.utc(2026, 9, 3);
      final date2 = DateTime.utc(2026, 9, 3);
      final date3 = DateTime.utc(2026, 9, 4);

      final daily1 = module.hadithService.getDailyHadith(date1).valueOrNull;
      final daily2 = module.hadithService.getDailyHadith(date2).valueOrNull;
      final daily3 = module.hadithService.getDailyHadith(date3).valueOrNull;

      expect(daily1, isNotNull);
      expect(daily2, isNotNull);
      expect(daily1!.hadithId, equals(daily2!.hadithId), reason: 'Daily Hadith must be strictly deterministic on the same date');
      expect(daily1.hadithId, isNot(equals(daily3?.hadithId)), reason: 'Adjacent days should yield distinct Hadiths');
    });

    test('Verification 4: Dynamic Book counts derived programmatically from mounted data', () {
      final bukhariBooks = module.hadithService.getBooksWithCounts('src_bukhari_canonical').valueOrNull;
      expect(bukhariBooks, isNotNull);
      expect(bukhariBooks, isNotEmpty);

      for (final book in bukhariBooks!) {
        final bookNum = book['bookNumber'] as int;
        final reportedCount = book['hadithCount'] as int;
        final actualHadiths = module.hadithService.getHadithsByBook('src_bukhari_canonical', bookNum).valueOrNull!;
        expect(reportedCount, equals(actualHadiths.length), reason: 'Dynamic count must strictly match actual records');
      }
    });

    test('Verification 5: Multi-dimensional Search Engine with Normalization & Multi-Filter support', () {
      // 1. Text normalization search (Alef and Tashkeel invariance)
      final res1 = module.search('الاعمال').valueOrNull!;
      expect(res1.any((r) => r.id == 'hadith_001'), isTrue);

      // 2. Search in Isnad
      final res2 = module.search('علقمة').valueOrNull!;
      expect(res2.any((r) => r.id == 'hadith_001'), isTrue);

      // 3. Search in Commentaries
      final res3 = module.search('ابن حجر').valueOrNull!;
      expect(res3.isNotEmpty, isTrue);

      // 4. Search with Type Filter: Fiqh only
      final filterFiqh = const KnowledgeSearchFilter(contentType: 'fiqh');
      final resFiqh = module.search('النية', filterFiqh).valueOrNull!;
      expect(resFiqh.every((r) => r.contentType == 'fiqh'), isTrue);

      // 5. Search with Grade Filter: Sahih only
      final filterSahih = const KnowledgeSearchFilter(grade: HadithGrade.sahih);
      final resSahih = module.search('الاعمال', filterSahih).valueOrNull!;
      expect(resSahih.any((r) => r.id == 'hadith_001'), isTrue);
    });

    test('Adversarial 1: Fail-Closed cryptographic rejection upon Matn tampering', () {
      final validPkg = CanonicalKnowledgeData.getPackage();
      final originalHadith = validPkg.hadiths.first;

      final tamperedHadith = HadithEntity(
        hadithId: originalHadith.hadithId,
        collectionId: originalHadith.collectionId,
        bookNumber: originalHadith.bookNumber,
        bookName: originalHadith.bookName,
        primaryNumber: originalHadith.primaryNumber,
        arabicMatn: '${originalHadith.arabicMatn} محرف',
        integrityHash: originalHadith.integrityHash, // keeping old hash
        sourceId: originalHadith.sourceId,
        gradings: originalHadith.gradings,
        commentaries: originalHadith.commentaries,
      );

      expect(tamperedHadith.verifyHash(), isFalse);

      final tamperedPkg = CanonicalKnowledgePackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        sources: validPkg.sources,
        hadiths: [tamperedHadith],
        fiqhTopics: validPkg.fiqhTopics,
        knowledgeItems: validPkg.knowledgeItems,
        relations: validPkg.relations,
        learningPaths: validPkg.learningPaths,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final cleanStorage = MemoryStorageRegistry();
      final freshModule = KnowledgeModule(storageRegistry: cleanStorage);
      final mountRes = freshModule.mountPackage(tamperedPkg);

      expect(mountRes.isFailure, isTrue, reason: 'Fail-Closed must reject tampered Hadith Matn');
    });

    test('Adversarial 2: Fail-Closed rejection upon unauthorized grading alteration', () {
      final validPkg = CanonicalKnowledgeData.getPackage();
      final originalHadith = validPkg.hadiths.first;

      final forgedGrading = HadithGrading.create(
        gradingId: 'forged_01',
        grade: HadithGrade.daeef,
        scholarName: 'Unauthorized Actor',
        sourceBook: 'Forged Book',
      );

      final tamperedHadith = HadithEntity(
        hadithId: originalHadith.hadithId,
        collectionId: originalHadith.collectionId,
        bookNumber: originalHadith.bookNumber,
        bookName: originalHadith.bookName,
        primaryNumber: originalHadith.primaryNumber,
        arabicMatn: originalHadith.arabicMatn,
        integrityHash: originalHadith.integrityHash,
        sourceId: originalHadith.sourceId,
        gradings: [forgedGrading],
        commentaries: originalHadith.commentaries,
      );

      expect(tamperedHadith.verifyHash(), isFalse);

      final tamperedPkg = CanonicalKnowledgePackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        sources: validPkg.sources,
        hadiths: [tamperedHadith],
        fiqhTopics: validPkg.fiqhTopics,
        knowledgeItems: validPkg.knowledgeItems,
        relations: validPkg.relations,
        learningPaths: validPkg.learningPaths,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final freshModule = KnowledgeModule(storageRegistry: MemoryStorageRegistry());
      final mountRes = freshModule.mountPackage(tamperedPkg);

      expect(mountRes.isFailure, isTrue, reason: 'Fail-Closed must reject tampered Hadith grading');
    });

    test('Adversarial 3: Privacy & Zero Telemetry Isolation: user notes & bookmarks stored strictly in mod_knowledge', () async {
      await module.toggleBookmark('hadith_001');
      await module.saveNote('hadith_001', 'تدبر خاص بالنية والإخلاص');

      final prog = (await module.getUserProgress()).valueOrNull!;
      expect(prog.bookmarkedItemIds, contains('hadith_001'));
      expect(prog.userNotes['hadith_001'], equals('تدبر خاص بالنية والإخلاص'));

      // Verify no leakage into other namespaces in storage registry
      final otherStore = storage.getStoreForModule('mod_quran');
      final quranVal = await otherStore.getString('user_knowledge_progress');
      expect(quranVal.valueOrNull, isNull, reason: 'Knowledge user data must never leak to other modules');
    });
  });
}
