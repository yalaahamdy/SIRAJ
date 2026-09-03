import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/knowledge/services/knowledge_search_service.dart';
import 'package:siraj/modules/knowledge/store/read_only_knowledge_store.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 Knowledge Search Engine & Normalization Isolation Tests (§19, §28)', () {
    late ReadOnlyKnowledgeStore store;
    late KnowledgeSearchService searchService;

    setUp(() {
      store = ReadOnlyKnowledgeStore();
      searchService = KnowledgeSearchService(store: store);
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('KnowledgeSearchService.normalize strips Tashkeel and unifies Alefs deterministically', () {
      const raw = 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ';
      final normalized = KnowledgeSearchService.normalize(raw);
      expect(normalized, equals('انما الاعمال بالنيات'));
    });

    test('Searches by plain un-diacritized keyword and returns original Hadith with provenance', () {
      final res = searchService.search('الاعمال بالنيات');
      expect(res.isSuccess, isTrue);
      final results = res.valueOrNull!;

      expect(results.isNotEmpty, isTrue);
      final hadithResult = results.firstWhere((r) => r.contentType == 'hadith');
      expect(hadithResult.title.contains('كتاب بدء الوحي'), isTrue);
      expect(hadithResult.attributionDetails!.contains('صحيح'), isTrue);
    });

    test('Searches Fiqh topics and returns comparative positions', () {
      final res = searchService.search('تبييت النيه');
      expect(res.isSuccess, isTrue);
      final results = res.valueOrNull!;

      final fiqhResult = results.firstWhere((r) => r.contentType == 'fiqh');
      expect(fiqhResult.title.contains('حكم تبييت النية'), isTrue);
      expect(fiqhResult.attributionDetails!.contains('أقوال'), isTrue);
    });

    test('Empty or whitespace query returns empty results immediately', () {
      expect(searchService.search('').valueOrNull!, isEmpty);
      expect(searchService.search('   ').valueOrNull!, isEmpty);
    });
  });
}
