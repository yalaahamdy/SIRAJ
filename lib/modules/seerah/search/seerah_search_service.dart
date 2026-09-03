import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../store/read_only_seerah_store.dart';

/// Provenance-preserving Seerah search result item (§30).
class SeerahSearchResult {
  final String id;
  final String title;
  final String snippet;
  final String type; // 'event', 'person', 'place'
  final String tagLabel;

  const SeerahSearchResult({
    required this.id,
    required this.title,
    required this.snippet,
    required this.type,
    required this.tagLabel,
  });
}

/// Service providing Arabic search across Seerah events, persons, and geographical places (§30).
class SeerahSearchService {
  final ReadOnlySeerahStore _store;

  const SeerahSearchService({required ReadOnlySeerahStore store}) : _store = store;

  static String normalize(String text) {
    var s = text;
    s = s.replaceAll(RegExp(r'[\u064B-\u0652\u0670]'), '');
    s = s.replaceAll(RegExp(r'[إأآٱ]'), 'ا');
    s = s.replaceAll('ة', 'ه');
    s = s.replaceAll('ى', 'ي');
    return s.trim().toLowerCase();
  }

  Result<List<SeerahSearchResult>, Failure> search(String query) {
    final cleanQuery = normalize(query);
    if (cleanQuery.isEmpty) return Result.ok(const []);

    final results = <SeerahSearchResult>[];

    // 1. Search Events
    final eventsRes = _store.getAllEvents();
    if (eventsRes.isSuccess) {
      for (final e in eventsRes.valueOrNull!) {
        if (normalize(e.title).contains(cleanQuery) || normalize(e.summary).contains(cleanQuery)) {
          results.add(
            SeerahSearchResult(
              id: e.eventId,
              title: e.title,
              snippet: e.summary.length > 120 ? '${e.summary.substring(0, 120)}...' : e.summary,
              type: 'event',
              tagLabel: e.evidenceLevel.labelArabic,
            ),
          );
        }
      }
    }

    // 2. Search Persons
    final personsRes = _store.getAllPersons();
    if (personsRes.isSuccess) {
      for (final p in personsRes.valueOrNull!) {
        final nameMatch = normalize(p.canonicalName).contains(cleanQuery);
        final kunyahMatch = p.kunyah != null && normalize(p.kunyah!).contains(cleanQuery);
        final titleMatch = p.titleOrLakab != null && normalize(p.titleOrLakab!).contains(cleanQuery);
        final bioMatch = normalize(p.biographicalSummary).contains(cleanQuery);
        final aliasMatch = p.aliases.any((a) => normalize(a).contains(cleanQuery));

        if (nameMatch || kunyahMatch || titleMatch || bioMatch || aliasMatch) {
          results.add(
            SeerahSearchResult(
              id: p.personId,
              title: p.canonicalName,
              snippet: p.biographicalSummary.length > 120 ? '${p.biographicalSummary.substring(0, 120)}...' : p.biographicalSummary,
              type: 'person',
              tagLabel: p.historicalRole,
            ),
          );
        }
      }
    }

    // 3. Search Places
    final placesRes = _store.getAllPlaces();
    if (placesRes.isSuccess) {
      for (final pl in placesRes.valueOrNull!) {
        final nameMatch = normalize(pl.nameArabic).contains(cleanQuery);
        final modernMatch = pl.modernName != null && normalize(pl.modernName!).contains(cleanQuery);
        final regionMatch = normalize(pl.region).contains(cleanQuery);
        final descMatch = normalize(pl.geographicalDescription).contains(cleanQuery);

        if (nameMatch || modernMatch || regionMatch || descMatch) {
          results.add(
            SeerahSearchResult(
              id: pl.placeId,
              title: pl.nameArabic,
              snippet: pl.geographicalDescription.length > 120 ? '${pl.geographicalDescription.substring(0, 120)}...' : pl.geographicalDescription,
              type: 'place',
              tagLabel: pl.certainty.labelArabic,
            ),
          );
        }
      }
    }

    return Result.ok(results);
  }
}
