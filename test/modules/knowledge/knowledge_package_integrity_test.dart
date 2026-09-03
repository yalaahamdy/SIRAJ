import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/knowledge/domain/canonical_knowledge_package.dart';
import 'package:siraj/modules/knowledge/domain/hadith_entity.dart';
import 'package:siraj/modules/knowledge/domain/hadith_grading.dart';
import 'package:siraj/modules/knowledge/store/read_only_knowledge_store.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 Knowledge Package Cryptographic Integrity & Fail-Closed Tests (§23, §24)', () {
    late ReadOnlyKnowledgeStore store;

    setUp(() {
      store = ReadOnlyKnowledgeStore();
    });

    test('Valid synthetic package passes all integrity and verification checks', () {
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      expect(pkg.verifyPackageIntegrity(), isTrue);

      final mountRes = store.mountPackage(pkg);
      expect(mountRes.isSuccess, isTrue);
      expect(store.isMounted, isTrue);
      expect(store.verifyIntegrity(), isTrue);
    });

    test('Rejects package if any individual Hadith item text is tampered', () {
      final validPkg = SyntheticKnowledgeFixtures.createPackage();
      final originalHadith = validPkg.hadiths.first;

      // Tamper text
      final tamperedHadith = originalHadith.copyWith(
        arabicMatn: 'إنما الأعمال بالنيات فقط دون غيرها', // unauthorized alteration
      );

      final tamperedPkg = CanonicalKnowledgePackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        sources: validPkg.sources,
        hadiths: [tamperedHadith],
        fiqhTopics: validPkg.fiqhTopics,
        knowledgeItems: validPkg.knowledgeItems,
        relations: validPkg.relations,
        learningPaths: validPkg.learningPaths,
        contentHash: validPkg.contentHash, // Stale hash
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      expect(tamperedPkg.verifyPackageIntegrity(), isFalse);
      final mountRes = store.mountPackage(tamperedPkg);
      expect(mountRes.isFailure, isTrue);
      expect(store.isMounted, isFalse); // Fail-Closed
    });

    test('Rejects package if Hadith grading is modified without authorization', () {
      final validPkg = SyntheticKnowledgeFixtures.createPackage();
      final originalHadith = validPkg.hadiths.first;

      final tamperedGrading = HadithGrading.create(
        gradingId: originalHadith.gradings.first.gradingId,
        grade: HadithGrade.daeef, // Changed from Sahih to Daeef
        scholarName: originalHadith.gradings.first.scholarName,
        sourceBook: originalHadith.gradings.first.sourceBook,
      );

      final tamperedHadith = HadithEntity(
        hadithId: originalHadith.hadithId,
        collectionId: originalHadith.collectionId,
        bookNumber: originalHadith.bookNumber,
        bookName: originalHadith.bookName,
        chapterNumber: originalHadith.chapterNumber,
        chapterName: originalHadith.chapterName,
        primaryNumber: originalHadith.primaryNumber,
        internationalNumber: originalHadith.internationalNumber,
        arabicMatn: originalHadith.arabicMatn,
        isnad: originalHadith.isnad,
        sourceId: originalHadith.sourceId,
        gradings: [tamperedGrading],
        translations: originalHadith.translations,
        commentaries: originalHadith.commentaries,
        integrityHash: originalHadith.integrityHash, // Stale hash
      );

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
      final mountRes = store.mountPackage(tamperedPkg);
      expect(mountRes.isFailure, isTrue);
    });

    test('Rejects package with empty signature or signer identity', () {
      final validPkg = SyntheticKnowledgeFixtures.createPackage();
      final unsignedPkg = CanonicalKnowledgePackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        sources: validPkg.sources,
        hadiths: validPkg.hadiths,
        fiqhTopics: validPkg.fiqhTopics,
        knowledgeItems: validPkg.knowledgeItems,
        relations: validPkg.relations,
        learningPaths: validPkg.learningPaths,
        contentHash: validPkg.contentHash,
        signerIdentity: '', // Empty
        signature: '',
        publishedAt: validPkg.publishedAt,
      );

      expect(unsignedPkg.verifyPackageIntegrity(), isFalse);
      final mountRes = store.mountPackage(unsignedPkg);
      expect(mountRes.isFailure, isTrue);
    });
  });
}

extension on HadithEntity {
  HadithEntity copyWith({String? arabicMatn}) {
    return HadithEntity(
      hadithId: hadithId,
      collectionId: collectionId,
      bookNumber: bookNumber,
      bookName: bookName,
      chapterNumber: chapterNumber,
      chapterName: chapterName,
      primaryNumber: primaryNumber,
      internationalNumber: internationalNumber,
      arabicMatn: arabicMatn ?? this.arabicMatn,
      isnad: isnad,
      sourceId: sourceId,
      gradings: gradings,
      translations: translations,
      commentaries: commentaries,
      integrityHash: integrityHash,
    );
  }
}
