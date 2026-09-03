import '../models/federated_search_result.dart';

/// Contract interface for module-level search providers (§25, §59).
abstract class SearchProviderContract {
  SearchDomain get domain;
  Future<List<FederatedSearchItem>> search(String query);
}

/// Cross-module federated search coordinator (§25, §59, §60).
class FederatedSearchCoordinator {
  final List<SearchProviderContract> _providers = [];

  List<SearchProviderContract> get providers => List.unmodifiable(_providers);

  /// Registers a module search provider contract (§25).
  void registerProvider(SearchProviderContract provider) {
    _providers.add(provider);
  }

  /// Executes parallel federated search across all registered module providers (§25, §59).
  Future<FederatedSearchResult> searchAll({
    required String query,
    Set<SearchDomain>? filterDomains,
  }) async {
    final stopwatch = Stopwatch()..start();
    final items = <FederatedSearchItem>[];

    final targetProviders = filterDomains == null
        ? _providers
        : _providers.where((p) => filterDomains.contains(p.domain)).toList();

    final results = await Future.wait(
      targetProviders.map((provider) => provider.search(query)),
    );

    for (final list in results) {
      items.addAll(list);
    }

    // Sort by relevance score descending
    items.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    stopwatch.stop();

    return FederatedSearchResult(
      query: query,
      items: items,
      totalHits: items.length,
      executionLatency: stopwatch.elapsed,
    );
  }
}
