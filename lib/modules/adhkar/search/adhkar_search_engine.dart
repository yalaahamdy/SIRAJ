import '../domain/dhikr_item.dart';
import 'adhkar_text_normalizer.dart';

/// Isolated In-Memory Search Engine for Adhkar & Dua (§23).
class AdhkarSearchEngine {
  const AdhkarSearchEngine();

  List<DhikrItem> search({
    required String query,
    required List<DhikrItem> items,
  }) {
    final normalizedQuery = AdhkarTextNormalizer.normalize(query);
    if (normalizedQuery.isEmpty) return const [];

    final results = <DhikrItem>[];

    for (final item in items) {
      final normText = AdhkarTextNormalizer.normalize(item.textArabic);
      final normSource = AdhkarTextNormalizer.normalize(item.sourceTitle);
      final normAuthor = AdhkarTextNormalizer.normalize(item.sourceAuthor);
      final normBenefit = item.benefit != null ? AdhkarTextNormalizer.normalize(item.benefit!) : '';
      final normAttribution = AdhkarTextNormalizer.normalize(item.attribution);

      if (normText.contains(normalizedQuery) ||
          normSource.contains(normalizedQuery) ||
          normAuthor.contains(normalizedQuery) ||
          normBenefit.contains(normalizedQuery) ||
          normAttribution.contains(normalizedQuery)) {
        results.add(item);
      }
    }

    return List.unmodifiable(results);
  }
}
