import 'package:equatable/equatable.dart';
import '../content/domain/content_type.dart';

/// Represents a search query against the local content index.
class SearchQuery extends Equatable {
  final String term;
  final ContentType? filterType;
  final int limit;
  final int offset;

  const SearchQuery({
    required this.term,
    this.filterType,
    this.limit = 20,
    this.offset = 0,
  }) : assert(limit > 0 && limit <= 100, 'Limit must be between 1 and 100');

  @override
  List<Object?> get props => [term, filterType, limit, offset];
}

/// A search result item with canonical contentId and snippet context.
class SearchResultItem extends Equatable {
  final String contentId;
  final ContentType contentType;
  final String snippet;
  final double score;

  const SearchResultItem({
    required this.contentId,
    required this.contentType,
    required this.snippet,
    required this.score,
  });

  @override
  List<Object?> get props => [contentId, contentType, snippet, score];
}
