import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/domain/canonical_knowledge_package.dart';
import 'package:siraj/modules/knowledge/domain/fiqh_topic.dart';
import 'package:siraj/modules/knowledge/domain/hadith_entity.dart';
import 'package:siraj/modules/knowledge/domain/source_record.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M7 Knowledge Adversarial Security & Cryptographic Attack Tests (§41, §42)', () {
    late MemoryStorageRegistry registry;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      knowledgeModule.mountPackage(pkg);
    });

    test('Attack 1: Single character or word mutation in Hadith Matn causes Fail-Closed rejection', () {
      final validPkg = SyntheticKnowledgeFixtures.createPackage();
      final hadith = validPkg.hadiths.first;

      final tamperedHadith = HadithEntity(
        hadithId: hadith.hadithId,
        collectionId: hadith.collectionId,
        bookNumber: hadith.bookNumber,
        bookName: hadith.bookName,
        chapterNumber: hadith.chapterNumber,
        chapterName: hadith.chapterName,
        primaryNumber: hadith.primaryNumber,
        internationalNumber: hadith.internationalNumber,
        arabicMatn: '${hadith.arabicMatn} محرف', // Appended unauthorized word
        isnad: hadith.isnad,
        sourceId: hadith.sourceId,
        gradings: hadith.gradings,
        translations: hadith.translations,
        commentaries: hadith.commentaries,
        integrityHash: hadith.integrityHash, // Stale hash
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

      expect(tamperedPkg.verifyPackageIntegrity(), isFalse);
    });

    test('Attack 2: Modifying Fiqh ruling text triggers instant hash invalidation', () {
      final topic = SyntheticKnowledgeFixtures.createFiqhTopic();
      expect(topic.verifyHash(), isTrue);

      final tamperedTopic = FiqhTopic(
        topicId: topic.topicId,
        title: topic.title,
        summary: 'حكم محرف تماماً ومزور',
        category: topic.category,
        positions: topic.positions,
        reviewState: topic.reviewState,
        integrityHash: topic.integrityHash, // Stale
      );

      expect(tamperedTopic.verifyHash(), isFalse);
    });

    test('Attack 3: Modifying source book title or author triggers hash invalidation', () {
      final src = SyntheticKnowledgeFixtures.createSourceRecord();
      expect(src.verifyHash(), isTrue);

      final tamperedSrc = SourceRecord(
        sourceId: src.sourceId,
        title: 'عنوان مصدر مزور',
        author: src.author,
        editor: src.editor,
        publisher: src.publisher,
        edition: src.edition,
        year: src.year,
        language: src.language,
        sourceType: src.sourceType,
        referenceScheme: src.referenceScheme,
        reviewState: src.reviewState,
        integrityHash: src.integrityHash, // Stale
      );

      expect(tamperedSrc.verifyHash(), isFalse);
    });

    test('Attack 4: Privacy Isolation: Knowledge user records reside exclusively in mod_knowledge namespace', () async {
      await knowledgeModule.markCompleted('hadith_001');

      final knowledgeStore = registry.getStoreForModule('mod_knowledge');
      final prayerStore = registry.getStoreForModule('mod_prayer');
      final zakatStore = registry.getStoreForModule('mod_zakat');

      expect((await knowledgeStore.getString('user_knowledge_progress')).valueOrNull, isNotNull);
      expect((await prayerStore.getString('user_knowledge_progress')).valueOrNull, isNull);
      expect((await zakatStore.getString('user_knowledge_progress')).valueOrNull, isNull);
    });
  });
}
