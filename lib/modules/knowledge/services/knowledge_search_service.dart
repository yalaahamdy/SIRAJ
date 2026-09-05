import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/hadith_grading.dart';
import '../store/read_only_knowledge_store.dart';

/// Search filter parameters for targeted retrieval (§19, §28).
class KnowledgeSearchFilter {
  final String? contentType; // 'all', 'hadith', 'fiqh', 'knowledge'
  final String? collectionId; // e.g. 'src_bukhari_canonical'
  final HadithGrade? grade; // e.g. HadithGrade.sahih

  const KnowledgeSearchFilter({
    this.contentType,
    this.collectionId,
    this.grade,
  });
}

/// Search result model preserving full scholarly provenance (§19, §28).
class KnowledgeSearchResult {
  final String id;
  final String title;
  final String snippet;
  final String contentType; // 'hadith', 'fiqh', 'knowledge'
  final String sourceTitle;
  final String? attributionDetails; // e.g. Hadith Grade or Fiqh School

  const KnowledgeSearchResult({
    required this.id,
    required this.title,
    required this.snippet,
    required this.contentType,
    required this.sourceTitle,
    this.attributionDetails,
  });
}

/// Service providing provenance-preserving Arabic search across knowledge domains (§19, §28).
class KnowledgeSearchService {
  final ReadOnlyKnowledgeStore _store;

  const KnowledgeSearchService({required ReadOnlyKnowledgeStore store}) : _store = store;

  /// Pure text normalizer for Arabic search queries.
  static String normalize(String text) {
    var s = text;
    // Strip Arabic diacritics / Tashkeel
    s = s.replaceAll(RegExp(r'[\u064B-\u0652\u0670]'), '');
    // Normalize Alefs
    s = s.replaceAll(RegExp(r'[إأآٱ]'), 'ا');
    // Normalize Taa Marbuta
    s = s.replaceAll('ة', 'ه');
    // Normalize Yaa
    s = s.replaceAll('ى', 'ي');
    return s.trim().toLowerCase();
  }

  /// Searches across all canonical datasets with optional filters.
  Result<List<KnowledgeSearchResult>, Failure> search(String query, [KnowledgeSearchFilter? filter]) {
    final cleanQuery = normalize(query);
    if (cleanQuery.isEmpty) return Result.ok(const []);

    final results = <KnowledgeSearchResult>[];
    final typeFilter = filter?.contentType;
    final includeHadith = typeFilter == null || typeFilter == 'all' || typeFilter == 'hadith';
    final includeFiqh = (typeFilter == null || typeFilter == 'all' || typeFilter == 'fiqh') && filter?.grade == null && (filter?.collectionId == null || filter!.collectionId!.isEmpty);
    final includeKnowledge = (typeFilter == null || typeFilter == 'all' || typeFilter == 'knowledge') && filter?.grade == null && (filter?.collectionId == null || filter!.collectionId!.isEmpty);

    // 1. Search Hadiths
    if (includeHadith) {
      final hadithsRes = _store.getAllHadiths();
      if (hadithsRes.isSuccess) {
        for (final h in hadithsRes.valueOrNull!) {
          // Collection filter
          if (filter?.collectionId != null && filter!.collectionId!.isNotEmpty && h.collectionId != filter.collectionId) {
            continue;
          }
          // Grade filter
          if (filter?.grade != null && !h.gradings.any((g) => g.grade == filter!.grade)) {
            continue;
          }

          final normMatn = normalize(h.arabicMatn);
          final normBook = normalize(h.bookName);
          final normChapter = normalize(h.chapterName ?? '');
          final normIsnad = h.isnad != null ? normalize(h.isnad!) : '';
          final commentariesMatch = h.commentaries.any((c) => normalize(c.quote).contains(cleanQuery) || normalize(c.scholarName).contains(cleanQuery));

          if (normMatn.contains(cleanQuery) ||
              normBook.contains(cleanQuery) ||
              normChapter.contains(cleanQuery) ||
              normIsnad.contains(cleanQuery) ||
              commentariesMatch) {
            final srcRes = _store.getSource(h.sourceId);
            final srcTitle = srcRes.valueOrNull?.title ?? h.collectionId;
            final gradeLabel = h.gradings.isNotEmpty
                ? '${h.gradings.first.grade.labelArabic} (${h.gradings.first.scholarName})'
                : 'غير محقق';

            results.add(
              KnowledgeSearchResult(
                id: h.hadithId,
                title: '${h.bookName} — حديث ${h.primaryNumber}',
                snippet: h.arabicMatn.length > 120 ? '${h.arabicMatn.substring(0, 120)}...' : h.arabicMatn,
                contentType: 'hadith',
                sourceTitle: srcTitle,
                attributionDetails: gradeLabel,
              ),
            );
          }
        }
      }
    }

    // 2. Search Fiqh Topics
    if (includeFiqh) {
      final fiqhRes = _store.getAllFiqhTopics();
      if (fiqhRes.isSuccess) {
        for (final f in fiqhRes.valueOrNull!) {
          final normTitle = normalize(f.title);
          final normSummary = normalize(f.summary);
          final positionsMatch = f.positions.any((p) =>
              normalize(p.rulingText).contains(cleanQuery) ||
              (p.scholarName != null && normalize(p.scholarName!).contains(cleanQuery)));

          if (normTitle.contains(cleanQuery) || normSummary.contains(cleanQuery) || positionsMatch) {
            results.add(
              KnowledgeSearchResult(
                id: f.topicId,
                title: f.title,
                snippet: f.summary,
                contentType: 'fiqh',
                sourceTitle: f.category,
                attributionDetails: 'مسألة فقهية مقارنة (${f.positions.length} أقوال)',
              ),
            );
          }
        }
      }
    }

    // 3. Search General Knowledge Items
    if (includeKnowledge) {
      final itemsRes = _store.getAllKnowledgeItems();
      if (itemsRes.isSuccess) {
        for (final k in itemsRes.valueOrNull!) {
          final normTitle = normalize(k.title);
          final normText = normalize(k.primaryText);
          final normExplanation = k.explanationText != null ? normalize(k.explanationText!) : '';

          if (normTitle.contains(cleanQuery) || normText.contains(cleanQuery) || normExplanation.contains(cleanQuery)) {
            final srcRes = _store.getSource(k.sourceId);
            final srcTitle = srcRes.valueOrNull?.title ?? k.category;

            results.add(
              KnowledgeSearchResult(
                id: k.itemId,
                title: k.title,
                snippet: k.primaryText.length > 120 ? '${k.primaryText.substring(0, 120)}...' : k.primaryText,
                contentType: 'knowledge',
                sourceTitle: srcTitle,
                attributionDetails: k.contentType.labelArabic,
              ),
            );
          }
        }
      }
    }

    return Result.ok(results);
  }
}
