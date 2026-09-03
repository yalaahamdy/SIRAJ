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
  group('M50: SIRAJ v1.0 — Content Search & Cross-Module Retrieval Suite (§17, §42, §43)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;
    late HajjModule hajjModule;
    late SearchFederationService searchService;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      adhkarModule = AdhkarModule(storageRegistry: storage);
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      learningModule = LearningModule(storageRegistry: storage);
      seerahModule = SeerahModule(storageRegistry: storage);
      hajjModule = HajjModule(storageRegistry: storage);

      // Seed all modules with canonical data
      ContentSeedEngine.seedAllModules(
        adhkarModule: adhkarModule,
        quranModule: quranModule,
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

    test('Quran search: Finds canonical surahs and verses', () async {
      final res = await searchService.search('الحمد');
      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;
      expect(list.any((r) => r.moduleId == 'quran'), isTrue);
      final quranResult = list.firstWhere((r) => r.moduleId == 'quran');
      expect(quranResult.targetRoute, equals('/quran'));
      expect(quranResult.snippet.isNotEmpty, isTrue);
    });

    test('Adhkar search: Finds authentic dhikr by text or occasion', () async {
      final res = await searchService.search('الصباح');
      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;
      expect(list.any((r) => r.moduleId == 'adhkar'), isTrue);
      for (final item in list.where((r) => r.moduleId == 'adhkar')) {
        expect(item.provenanceState, equals('APPROVED'));
        expect(item.snippet.isNotEmpty, isTrue);
      }
    });

    test('Knowledge search: Finds authentic Hadith and Fiqh rulings', () async {
      final res = await searchService.search('الصيام');
      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;
      expect(list.any((r) => r.moduleId == 'knowledge'), isTrue);
    });

    test('Fasting & Zakat search: Finds structured educational guidance topics', () async {
      final fastingRes = await searchService.search('السحور');
      expect(fastingRes.isSuccess, isTrue);
      expect(fastingRes.valueOrNull!.any((r) => r.moduleId == 'fasting'), isTrue);

      final zakatRes = await searchService.search('الذهب');
      expect(zakatRes.isSuccess, isTrue);
      expect(zakatRes.valueOrNull!.any((r) => r.moduleId == 'zakat'), isTrue);
    });

    test('Seerah & Hajj search: Finds historical events and ritual steps', () async {
      final seerahRes = await searchService.search('بدر');
      expect(seerahRes.isSuccess, isTrue);
      expect(seerahRes.valueOrNull!.any((r) => r.moduleId == 'seerah'), isTrue);

      final hajjRes = await searchService.search('عرفة');
      expect(hajjRes.isSuccess, isTrue);
      expect(hajjRes.valueOrNull!.any((r) => r.moduleId == 'hajj'), isTrue);
    });

    test('Empty or blank query returns empty results cleanly without error', () async {
      final resEmpty = await searchService.search('');
      expect(resEmpty.isSuccess, isTrue);
      expect(resEmpty.valueOrNull!, isEmpty);

      final resSpaces = await searchService.search('     ');
      expect(resSpaces.isSuccess, isTrue);
      expect(resSpaces.valueOrNull!, isEmpty);
    });
  });
}
