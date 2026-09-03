import 'package:equatable/equatable.dart';

/// Module domain of a search hit (§25, §59).
enum SearchDomain {
  quran,
  adhkar,
  knowledge,
  learning,
  seerah,
  hajj,
  general,
}

/// Structured cross-module search item result (§25, §59, §60).
class FederatedSearchItem extends Equatable {
  final String itemId;
  final SearchDomain domain;
  final String titleArabic;
  final String snippetArabic;
  final String sourceEdition;
  final String deepLinkUri;
  final double relevanceScore;

  const FederatedSearchItem({
    required this.itemId,
    required this.domain,
    required this.titleArabic,
    required this.snippetArabic,
    required this.sourceEdition,
    required this.deepLinkUri,
    required this.relevanceScore,
  });

  @override
  List<Object?> get props => [
        itemId,
        domain,
        titleArabic,
        snippetArabic,
        sourceEdition,
        deepLinkUri,
        relevanceScore,
      ];
}

/// Unified result containing cross-module hits (§25, §59).
class FederatedSearchResult extends Equatable {
  final String query;
  final List<FederatedSearchItem> items;
  final int totalHits;
  final Duration executionLatency;

  const FederatedSearchResult({
    required this.query,
    required this.items,
    required this.totalHits,
    required this.executionLatency,
  });

  @override
  List<Object?> get props => [query, items, totalHits, executionLatency];
}
