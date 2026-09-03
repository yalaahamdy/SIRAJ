import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/seed/content_seed_engine.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';

void main() {
  group('M47: Content Seed Integrity & Idempotency Tests (§20)', () {
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

    test('Seeding is 100% idempotent and does not create duplicate entries on repeated runs', () {
      // First seed run
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      final initialAdhkarCount = adhkarModule.getAllItems().valueOrNull!.length;
      final initialSurahCount = quranModule.store.getAllSurahs().valueOrNull!.length;

      // Second seed run (Simulating app restart / hot reload)
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      final afterAdhkarCount = adhkarModule.getAllItems().valueOrNull!.length;
      final afterSurahCount = quranModule.store.getAllSurahs().valueOrNull!.length;

      expect(afterAdhkarCount, equals(initialAdhkarCount));
      expect(afterSurahCount, equals(initialSurahCount));
    });

    test('Quran canonical seed package passes cryptographic verification', () {
      final quranPkg = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      final verifyRes = quranPkg.verifyIntegrity();
      expect(verifyRes.isSuccess, isTrue);
      expect(quranPkg.contentHash.startsWith('sha256:'), isTrue);
    });

    test('Adhkar canonical seed package passes cryptographic verification', () {
      final adhkarPkg = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      expect(adhkarPkg.verifyPackageIntegrity(), isTrue);
    });

    test('All seeded Dhikr items have valid authenticity and provenance citations', () {
      final adhkarPkg = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      for (final item in adhkarPkg.items) {
        expect(item.sourceTitle.isNotEmpty, isTrue);
        expect(item.sourceAuthor.isNotEmpty, isTrue);
        expect(item.reference.isNotEmpty, isTrue);
        expect(item.attribution.isNotEmpty, isTrue);
        expect(item.verifyHash(), isTrue);
      }
    });
  });
}
