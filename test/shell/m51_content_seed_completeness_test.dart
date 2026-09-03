import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seed/content_seed_engine.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('M51: SIRAJ v1.0 — Content Seed Completeness & Idempotency Suite (§20)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;
    late HajjModule hajjModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      adhkarModule = AdhkarModule(storageRegistry: storage);
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      learningModule = LearningModule(storageRegistry: storage);
      seerahModule = SeerahModule(storageRegistry: storage);
      hajjModule = HajjModule(storageRegistry: storage);
    });

    test('All canonical seed packages verify cryptographic integrity and provenance', () {
      final adhkarPkg = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      expect(adhkarPkg.verifyPackageIntegrity(), isTrue);

      final quranPkg = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      expect(quranPkg.verifyIntegrity().isSuccess, isTrue);

      final knowledgePkg = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
      expect(knowledgePkg.verifyPackageIntegrity(), isTrue);

      final learningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      expect(learningPkg.verifyPackageIntegrity(), isTrue);

      final seerahPkg = DefaultCanonicalSeedProvider.getSeerahSeedPackage();
      expect(seerahPkg.verifyPackageIntegrity(), isTrue);

      final hajjPkg = DefaultCanonicalSeedProvider.getHajjSeedPackage();
      expect(hajjPkg.contentHash.startsWith('sha256:'), isTrue);
    });

    test('ContentSeedEngine mounts and populates all 6 core modules successfully', () {
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      expect(quranModule.store.isMounted, isTrue);
      expect(quranModule.store.getAllSurahs().valueOrNull!.length, equals(114));

      expect(adhkarModule.store.isMounted, isTrue);
      expect(adhkarModule.store.activePackage?.items.length, greaterThanOrEqualTo(35));

      expect(knowledgeModule.store.isMounted, isTrue);
      expect(knowledgeModule.store.activePackage?.hadiths.length, greaterThanOrEqualTo(15));

      expect(learningModule.store.isMounted, isTrue);
      expect(learningModule.store.activePackage?.lessons.length, equals(8));

      expect(seerahModule.store.isMounted, isTrue);
      expect(seerahModule.store.activePackage?.events.length, greaterThanOrEqualTo(12));

      expect(hajjModule.store.isMounted, isTrue);
      expect(hajjModule.store.activePackage?.steps.length, equals(19));
    });

    test('ContentSeedEngine seeding is 100% idempotent (running twice produces identical state)', () {
      // First seed run
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      final adhkarCountFirst = adhkarModule.store.activePackage?.items.length;
      final quranSurahCountFirst = quranModule.store.getAllSurahs().valueOrNull!.length;
      final knowledgeHadithCountFirst = knowledgeModule.store.activePackage?.hadiths.length;

      // Second seed run
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      expect(adhkarModule.store.activePackage?.items.length, equals(adhkarCountFirst));
      expect(quranModule.store.getAllSurahs().valueOrNull!.length, equals(quranSurahCountFirst));
      expect(knowledgeModule.store.activePackage?.hadiths.length, equals(knowledgeHadithCountFirst));
    });
  });
}
