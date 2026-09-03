import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../content/domain/content_record.dart';
import '../content/domain/content_status.dart';
import 'search_models.dart';

/// Contract for the local search indexing platform.
abstract class SearchIndex {
  /// Indexes a list of verified content records.
  Future<Result<void, SystemFailure>> indexRecords(List<ContentRecord> records);

  /// Performs a search query against indexed records.
  Future<Result<List<SearchResultItem>, SystemFailure>> search(SearchQuery query);

  /// Clears the entire index for complete rebuild.
  Future<Result<void, SystemFailure>> clearIndex();
}

/// In-memory search index implementation for local-first testing and offline querying.
class MemorySearchIndex implements SearchIndex {
  final Map<String, ContentRecord> _indexedRecords = {};

  @override
  Future<Result<void, SystemFailure>> indexRecords(List<ContentRecord> records) async {
    for (final record in records) {
      // Only index approved or locked items
      if (record.status.isPubliclyDisplayable && !record.status.isQuarantined) {
        _indexedRecords[record.contentId] = record;
      }
    }
    return Result.ok(null);
  }

  @override
  Future<Result<List<SearchResultItem>, SystemFailure>> search(SearchQuery query) async {
    final cleanTerm = query.term.trim().toLowerCase();
    if (cleanTerm.isEmpty) {
      return Result.ok(const []);
    }

    final matches = <SearchResultItem>[];

    for (final record in _indexedRecords.values) {
      if (query.filterType != null && record.contentType != query.filterType) {
        continue;
      }

      final textLower = record.text.toLowerCase();
      if (textLower.contains(cleanTerm)) {
        // Calculate basic relevance score
        final score = cleanTerm.length / textLower.length;
        final startIdx = textLower.indexOf(cleanTerm);
        final snippetStart = (startIdx - 20).clamp(0, textLower.length);
        final snippetEnd = (startIdx + cleanTerm.length + 20).clamp(0, textLower.length);
        final snippet = '...${record.text.substring(snippetStart, snippetEnd)}...';

        matches.add(
          SearchResultItem(
            contentId: record.contentId,
            contentType: record.contentType,
            snippet: snippet,
            score: score,
          ),
        );
      }
    }

    matches.sort((a, b) => b.score.compareTo(a.score));

    final paged = matches.skip(query.offset).take(query.limit).toList();
    return Result.ok(paged);
  }

  @override
  Future<Result<void, SystemFailure>> clearIndex() async {
    _indexedRecords.clear();
    return Result.ok(null);
  }
}
