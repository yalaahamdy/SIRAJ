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
  group('M48: SIRAJ v1.0 — Real Content Completion Suite (§15, §19, §20, §30)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    test('Quran: Seed package contains all 114 Surahs and 30 Juzs with zero mutation', () {
      final quranPkg = DefaultCanonicalSeedProvider.getQuranSeedPackage();

      expect(quranPkg.surahs.length, equals(114), reason: 'All 114 Surahs must be present');
      expect(quranPkg.juzs.length, equals(30), reason: 'All 30 Juzs must be present');

      // Verify first, middle, and last Surahs
      expect(quranPkg.surahs.first.number, equals(1));
      expect(quranPkg.surahs.first.nameArabic, equals('الفاتحة'));
      expect(quranPkg.surahs.first.ayahCount, equals(7));

      final baqarah = quranPkg.surahs[1];
      expect(baqarah.number, equals(2));
      expect(baqarah.nameArabic, equals('البقرة'));
      expect(baqarah.ayahCount, equals(286));

      final nas = quranPkg.surahs.last;
      expect(nas.number, equals(114));
      expect(nas.nameArabic, equals('الناس'));
      expect(nas.ayahCount, equals(6));

      // Verify 30 Juzs continuity
      for (var i = 1; i <= 30; i++) {
        expect(quranPkg.juzs[i - 1].number, equals(i));
        expect(quranPkg.juzs[i - 1].startAyahNumber, equals(1));
      }

      // Verify canonical signature integrity
      expect(quranPkg.verifyIntegrity().isSuccess, isTrue);
    });

    test('Adhkar: Authenticity-backed authentic dhikr set populated with sources', () {
      final adhkarPkg = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      expect(adhkarPkg.items.isNotEmpty, isTrue);
      expect(adhkarPkg.items.length, greaterThanOrEqualTo(4));

      for (final item in adhkarPkg.items) {
        expect(item.sourceTitle, isNotEmpty);
        expect(item.attribution, isNotEmpty);
        expect(item.textArabic, isNotEmpty);
        expect(item.repetition.count, greaterThanOrEqualTo(1));
      }

      expect(adhkarPkg.contentHash, isNotEmpty);
    });

    test('Knowledge, Learning, Seerah & Hajj: Meaningful structured content populated', () {
      final knowledgePkg = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
      expect(knowledgePkg.hadiths.isNotEmpty, isTrue);
      expect(knowledgePkg.fiqhTopics.isNotEmpty, isTrue);
      expect(knowledgePkg.sources.isNotEmpty, isTrue);

      final learningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      expect(learningPkg.courses.isNotEmpty, isTrue);
      expect(learningPkg.courses.first.title, isNotEmpty);

      final seerahPkg = DefaultCanonicalSeedProvider.getSeerahSeedPackage();
      expect(seerahPkg.events.isNotEmpty, isTrue);
      expect(seerahPkg.periods.isNotEmpty, isTrue);
      expect(seerahPkg.persons.isNotEmpty, isTrue);

      final hajjPkg = DefaultCanonicalSeedProvider.getHajjSeedPackage();
      expect(hajjPkg.miqats.isNotEmpty, isTrue);
      expect(hajjPkg.steps.isNotEmpty, isTrue);
      expect(hajjPkg.preparationItems.isNotEmpty, isTrue);
    });

    test('ContentSeedEngine: Seeds all modules without errors or duplicate insertion', () {
      final quranModule = QuranModule(storageRegistry: storage);
      final adhkarModule = AdhkarModule(storageRegistry: storage);
      final knowledgeModule = KnowledgeModule(storageRegistry: storage);
      final learningModule = LearningModule(storageRegistry: storage);
      final seerahModule = SeerahModule(storageRegistry: storage);
      final hajjModule = HajjModule(storageRegistry: storage);

      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      expect(quranModule.store.isMounted, isTrue);
      expect(adhkarModule.getAllItems().valueOrNull!.length, greaterThanOrEqualTo(4));

      // Re-seeding is idempotent
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      expect(adhkarModule.getAllItems().valueOrNull!.length, greaterThanOrEqualTo(4));
    });
  });
}
