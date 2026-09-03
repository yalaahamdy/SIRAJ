import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/platform/content/domain/content_type.dart';
import 'package:siraj/platform/search/search_index.dart';
import 'package:siraj/platform/search/search_models.dart';
import '../fixtures/synthetic_packages.dart';

void main() {
  group('L1 Search Index Platform Tests', () {
    late MemorySearchIndex searchIndex;

    setUp(() {
      searchIndex = MemorySearchIndex();
    });

    test('Indexes records and performs keyword searches with score and snippets', () async {
      final records = [
        SyntheticFixtures.createSyntheticRecord(
          contentId: 'SEARCH-TEST-001',
          text: 'This is the first searchable synthetic record in the index',
        ),
        SyntheticFixtures.createSyntheticRecord(
          contentId: 'SEARCH-TEST-002',
          text: 'Another completely different record about testing mechanisms',
        ),
      ];

      await searchIndex.indexRecords(records);

      final query = const SearchQuery(term: 'searchable', filterType: ContentType.testFixture);
      final res = await searchIndex.search(query);

      expect(res.isSuccess, isTrue);
      final results = res.valueOrNull!;
      expect(results.length, equals(1));
      expect(results.first.contentId, equals('SEARCH-TEST-001'));
      expect(results.first.snippet, contains('searchable'));
      expect(results.first.score, greaterThan(0));
    });

    test('Empty query returns empty results', () async {
      final res = await searchIndex.search(const SearchQuery(term: '   '));
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull, isEmpty);
    });

    test('Clear index removes all indexed records', () async {
      final records = [
        SyntheticFixtures.createSyntheticRecord(
          contentId: 'SEARCH-TEST-003',
          text: 'Removable content index item',
        ),
      ];
      await searchIndex.indexRecords(records);
      await searchIndex.clearIndex();

      final res = await searchIndex.search(const SearchQuery(term: 'Removable'));
      expect(res.valueOrNull, isEmpty);
    });
  });
}
