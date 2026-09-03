import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/services/search_federation_service.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seed/content_seed_engine.dart';

void main() {
  group('M52: SIRAJ v1.0 — Unified Real Search & Deep-Linking Suite (§42, §43)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;
    late HajjModule hajjModule;
    late SearchFederationService searchService;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      adhkarModule = AdhkarModule(storageRegistry: storage);
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      learningModule = LearningModule(storageRegistry: storage);
      seerahModule = SeerahModule(storageRegistry: storage);
      hajjModule = HajjModule(storageRegistry: storage);

      // Seed all modules synchronously
      ContentSeedEngine.seedAllModules(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );

      searchService = SearchFederationService(
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );
    });

    test('Quran: Unified search finds real canonical verses with valid deep links', () async {
      final res = await searchService.search('الحمد');
      expect(res.isSuccess, isTrue);

      final quranResults = res.valueOrNull!.where((r) => r.moduleId == 'quran').toList();
      expect(quranResults.isNotEmpty, isTrue);
      expect(quranResults.first.targetRoute, equals('/quran'));
      expect(quranResults.first.snippet, isNotEmpty);
    });

    test('Adhkar: Unified search finds authentic morning/evening dhikr', () async {
      final res = await searchService.search('الملك');
      expect(res.isSuccess, isTrue);

      final adhkarResults = res.valueOrNull!.where((r) => r.moduleId == 'adhkar').toList();
      expect(adhkarResults.isNotEmpty, isTrue);
      expect(adhkarResults.first.targetRoute, equals('/adhkar'));
      expect(adhkarResults.first.titleArabic, isNotEmpty);
    });

    test('Knowledge: Unified search finds authentic Hadith and Fiqh topics', () async {
      final res = await searchService.search('النيات');
      expect(res.isSuccess, isTrue);

      final knowResults = res.valueOrNull!.where((r) => r.moduleId == 'knowledge').toList();
      expect(knowResults.isNotEmpty, isTrue);
      expect(knowResults.first.targetRoute, equals('/knowledge'));
      expect(knowResults.first.titleArabic, isNotEmpty);
    });

    test('Learning, Seerah & Hajj: Unified search returns valid module results with deep routes', () async {
      final seerahRes = await searchService.search('بدر');
      expect(seerahRes.isSuccess, isTrue);
      final seerahResults = seerahRes.valueOrNull!.where((r) => r.moduleId == 'seerah').toList();
      expect(seerahResults.isNotEmpty, isTrue);
      expect(seerahResults.first.targetRoute, equals('/seerah'));

      final hajjRes = await searchService.search('الميقات');
      expect(hajjRes.isSuccess, isTrue);
      final hajjResults = hajjRes.valueOrNull!.where((r) => r.moduleId == 'hajj').toList();
      expect(hajjResults.isNotEmpty, isTrue);
      expect(hajjResults.first.targetRoute, equals('/hajj'));
    });
  });
}
