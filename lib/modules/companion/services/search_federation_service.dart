import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../adhkar/adhkar_module.dart';
import '../../fasting/domain/fasting_guide_topic.dart';
import '../../hajj/hajj_module.dart';
import '../../knowledge/knowledge_module.dart';
import '../../learning/learning_module.dart';
import '../../quran/quran_module.dart';
import '../../seerah/seerah_module.dart';
import '../../zakat/domain/zakat_guide_topic.dart';
import '../domain/federated_search_result.dart';

/// Service executing federated cross-module search in parallel (§42, §43).
class SearchFederationService {
  final QuranModule? _quranModule;
  final AdhkarModule? _adhkarModule;
  final KnowledgeModule? _knowledgeModule;
  final LearningModule? _learningModule;
  final SeerahModule? _seerahModule;
  final HajjModule? _hajjModule;

  const SearchFederationService({
    QuranModule? quranModule,
    AdhkarModule? adhkarModule,
    KnowledgeModule? knowledgeModule,
    LearningModule? learningModule,
    SeerahModule? seerahModule,
    HajjModule? hajjModule,
  })  : _quranModule = quranModule,
        _adhkarModule = adhkarModule,
        _knowledgeModule = knowledgeModule,
        _learningModule = learningModule,
        _seerahModule = seerahModule,
        _hajjModule = hajjModule;

  Future<Result<List<FederatedSearchResult>, Failure>> search(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return Result.ok(const []);
    }

    final results = <FederatedSearchResult>[];

    // 1. Search Quran (M1)
    if (_quranModule != null && _quranModule.store.isMounted) {
      final quranRes = _quranModule.searchEngine.search(cleanQuery);
      if (quranRes.isSuccess) {
        for (final item in quranRes.valueOrNull!) {
          results.add(FederatedSearchResult(
            moduleId: 'quran',
            moduleTitleArabic: 'القرآن الكريم',
            itemId: item.ayah.key.toString(),
            titleArabic: 'سورة ${item.ayah.surahNumber} — الآية ${item.ayah.ayahNumber}',
            snippet: item.snippet,
            itemType: 'آية قرآنية',
            provenanceState: 'APPROVED',
            targetRoute: '/quran',
          ));
        }
      }
    }

    // 2. Search Adhkar (M4)
    if (_adhkarModule != null) {
      final items = _adhkarModule.search(cleanQuery);
      for (final item in items) {
        results.add(FederatedSearchResult(
          moduleId: 'adhkar',
          moduleTitleArabic: 'الأذكار والأدعية',
          itemId: item.id,
          titleArabic: item.textArabic,
          snippet: item.benefit ?? item.attribution,
          itemType: 'ذكر / دعاء',
          provenanceState: 'APPROVED',
          targetRoute: '/adhkar',
        ));
      }
    }

    // 3. Search Knowledge (M7)
    if (_knowledgeModule != null) {
      final res = _knowledgeModule.search(cleanQuery);
      if (res.isSuccess) {
        for (final item in res.valueOrNull!) {
          results.add(FederatedSearchResult(
            moduleId: 'knowledge',
            moduleTitleArabic: 'المعرفة والحديث',
            itemId: item.id,
            titleArabic: item.title,
            snippet: item.snippet,
            itemType: item.contentType,
            provenanceState: 'APPROVED',
            targetRoute: '/knowledge',
          ));
        }
      }
    }

    // 4. Search Learning (M8)
    if (_learningModule != null) {
      final res = _learningModule.search(cleanQuery);
      if (res.isSuccess) {
        for (final item in res.valueOrNull!) {
          results.add(FederatedSearchResult(
            moduleId: 'learning',
            moduleTitleArabic: 'المناهج والمسارات',
            itemId: item.id,
            titleArabic: item.title,
            snippet: item.snippet,
            itemType: item.type,
            provenanceState: 'APPROVED',
            targetRoute: '/learning',
          ));
        }
      }
    }

    // 5. Search Seerah (M9)
    if (_seerahModule != null) {
      final res = _seerahModule.search(cleanQuery);
      if (res.isSuccess) {
        for (final item in res.valueOrNull!) {
          results.add(FederatedSearchResult(
            moduleId: 'seerah',
            moduleTitleArabic: 'السيرة النبوية',
            itemId: item.id,
            titleArabic: item.title,
            snippet: item.snippet,
            itemType: item.type,
            provenanceState: 'APPROVED',
            targetRoute: '/seerah',
          ));
        }
      }
    }

    // 6. Search Hajj (M10)
    if (_hajjModule != null && _hajjModule.store.isMounted) {
      final stepsRes = _hajjModule.store.activePackage?.steps ?? const [];
      for (final s in stepsRes) {
        if (s.title.contains(cleanQuery) || s.description.contains(cleanQuery)) {
          results.add(FederatedSearchResult(
            moduleId: 'hajj',
            moduleTitleArabic: 'الحج والعمرة',
            itemId: s.stepId,
            titleArabic: s.title,
            snippet: s.description,
            itemType: 'خطوة نسك',
            provenanceState: 'APPROVED',
            targetRoute: '/hajj',
          ));
        }
      }
    }

    // 7. Search Fasting Guides (M6)
    for (final topic in FastingGuideData.topics) {
      if (topic.title.contains(cleanQuery) ||
          topic.summary.contains(cleanQuery) ||
          topic.content.contains(cleanQuery)) {
        results.add(FederatedSearchResult(
          moduleId: 'fasting',
          moduleTitleArabic: 'الصيام ورمضان',
          itemId: topic.id,
          titleArabic: topic.title,
          snippet: topic.summary,
          itemType: 'فقه الصيام',
          provenanceState: 'APPROVED',
          targetRoute: '/fasting',
        ));
      }
    }

    // 8. Search Zakat Guides (M5)
    for (final topic in ZakatGuideData.topics) {
      if (topic.title.contains(cleanQuery) ||
          topic.summary.contains(cleanQuery) ||
          topic.content.contains(cleanQuery)) {
        results.add(FederatedSearchResult(
          moduleId: 'zakat',
          moduleTitleArabic: 'حساب الزكاة',
          itemId: topic.id,
          titleArabic: topic.title,
          snippet: topic.summary,
          itemType: 'فقه الزكاة',
          provenanceState: 'APPROVED',
          targetRoute: '/zakat',
        ));
      }
    }

    return Result.ok(List.unmodifiable(results));
  }
}
