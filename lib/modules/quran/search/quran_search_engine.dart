import 'package:equatable/equatable.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/ayah.dart';
import '../store/canonical_quran_store.dart';
import 'quran_text_normalizer.dart';

/// Search match result pointing directly to the canonical Ayah entity.
class QuranSearchResult extends Equatable {
  final Ayah ayah;
  final String matchedQuery;
  final String snippet;
  final double score;

  const QuranSearchResult({
    required this.ayah,
    required this.matchedQuery,
    required this.snippet,
    required this.score,
  });

  @override
  List<Object?> get props => [ayah, matchedQuery, snippet, score];
}

/// Search indexing item combining canonical Ayah with pre-normalized search text.
class _SearchIndexItem {
  final Ayah ayah;
  final String normalizedText;

  const _SearchIndexItem({
    required this.ayah,
    required this.normalizedText,
  });
}

/// Offline, in-memory search engine for the Holy Quran (§11, §23).
class QuranSearchEngine {
  final ReadOnlyCanonicalQuranStore _store;
  final List<_SearchIndexItem> _index = [];

  QuranSearchEngine({
    required ReadOnlyCanonicalQuranStore store,
  }) : _store = store {
    _buildIndex();
  }

  /// Builds or rebuilds the normalized search index from the mounted store.
  void rebuildIndex() {
    _buildIndex();
  }

  void _buildIndex() {
    _index.clear();
    if (!_store.isMounted) return;

    final surahsRes = _store.getAllSurahs();
    if (surahsRes.isFailure) return;

    for (final surah in surahsRes.valueOrNull!) {
      final ayahsRes = _store.getSurahAyahs(surah.number);
      if (ayahsRes.isSuccess) {
        for (final ayah in ayahsRes.valueOrNull!) {
          // Pre-normalize Uthmani text for instantaneous matching
          final norm = QuranTextNormalizer.normalizeForSearch(ayah.textUthmani);
          _index.add(_SearchIndexItem(ayah: ayah, normalizedText: norm));
        }
      }
    }
  }

  /// Searches for matching Ayahs using the normalized query, optionally filtering by Surah.
  Result<List<QuranSearchResult>, Failure> search(String query, {int? surahNumber, int limit = 50}) {
    final cleanQuery = QuranTextNormalizer.normalizeForSearch(query);
    if (cleanQuery.isEmpty) {
      return Result.ok(const []);
    }

    if (_index.isEmpty && _store.isMounted) {
      _buildIndex();
    }

    final results = <QuranSearchResult>[];

    for (final item in _index) {
      if (surahNumber != null && item.ayah.surahNumber != surahNumber) {
        continue;
      }

      final idx = item.normalizedText.indexOf(cleanQuery);
      if (idx != -1) {
        // Calculate basic relevance score (exact match / earlier in verse gets higher score)
        final score = (cleanQuery.length / item.normalizedText.length) + (idx == 0 ? 1.0 : 0.5);

        results.add(
          QuranSearchResult(
            ayah: item.ayah,
            matchedQuery: query,
            snippet: item.ayah.textUthmani,
            score: score,
          ),
        );

        if (results.length >= limit) break;
      }
    }

    // Sort by score descending
    results.sort((a, b) => b.score.compareTo(a.score));
    return Result.ok(List.unmodifiable(results));
  }
}
