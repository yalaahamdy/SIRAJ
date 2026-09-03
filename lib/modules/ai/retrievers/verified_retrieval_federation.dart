import '../../adhkar/adhkar_module.dart';
import '../../hajj/hajj_module.dart';
import '../../knowledge/knowledge_module.dart';
import '../../learning/learning_module.dart';
import '../../quran/store/canonical_quran_store.dart';
import '../../seerah/seerah_module.dart';
import '../domain/ai_intent.dart';
import '../domain/evidence_item.dart';

/// Federation routing queries strictly to verified module interfaces without raw SQL/storage access (§6, §7).
class VerifiedRetrievalFederation {
  final ReadOnlyCanonicalQuranStore? _quranStore;
  final AdhkarModule? _adhkarModule;
  final KnowledgeModule? _knowledgeModule;
  final LearningModule? _learningModule;
  final SeerahModule? _seerahModule;
  final HajjModule? _hajjModule;

  const VerifiedRetrievalFederation({
    ReadOnlyCanonicalQuranStore? quranStore,
    AdhkarModule? adhkarModule,
    KnowledgeModule? knowledgeModule,
    LearningModule? learningModule,
    SeerahModule? seerahModule,
    HajjModule? hajjModule,
  })  : _quranStore = quranStore,
        _adhkarModule = adhkarModule,
        _knowledgeModule = knowledgeModule,
        _learningModule = learningModule,
        _seerahModule = seerahModule,
        _hajjModule = hajjModule;

  /// Retrieves relevant evidence items for a given intent and query (§6, §26).
  Future<List<EvidenceItem>> retrieve({
    required AIIntent intent,
    required String query,
    int maxResults = 5,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return const [];

    final searchTerms = <String>[cleanQuery, ...intent.extractedKeywords];
    final evidenceList = <EvidenceItem>[];
    final seenContentIds = <String>{};

    for (final term in searchTerms) {
      if (evidenceList.length >= maxResults) break;

      // 1. Retrieve Knowledge / Hadith (M7)
      if (_knowledgeModule != null && _knowledgeModule.store.isMounted) {
        final searchRes = _knowledgeModule.search(term);
        if (searchRes.isSuccess) {
          for (final k in searchRes.valueOrNull!) {
            if (seenContentIds.add(k.id)) {
              evidenceList.add(EvidenceItem(
                sourceId: k.sourceTitle,
                contentId: k.id,
                contentType: k.contentType,
                title: k.title,
                textExcerpt: k.snippet,
                referenceLocation: k.sourceTitle,
                verificationState: VerificationState.approved,
                relevanceScore: 0.95,
              ));
              if (evidenceList.length >= maxResults) break;
            }
          }
        }
      }

      // 2. Retrieve Adhkar / Dua (M4)
      if (_adhkarModule != null && evidenceList.length < maxResults) {
        final adhkarItems = _adhkarModule.search(term);
        for (final a in adhkarItems) {
          if (seenContentIds.add(a.id)) {
            evidenceList.add(EvidenceItem(
              sourceId: a.sourceTitle,
              contentId: a.id,
              contentType: 'dhikr',
              title: a.textArabic,
              textExcerpt: a.benefit != null ? '${a.textArabic} — الفضل: ${a.benefit}' : a.textArabic,
              referenceLocation: a.attribution,
              verificationState: VerificationState.canonical,
              relevanceScore: 0.9,
            ));
            if (evidenceList.length >= maxResults) break;
          }
        }
      }

      // 3. Retrieve Seerah (M9)
      if (_seerahModule != null && _seerahModule.store.isMounted && evidenceList.length < maxResults) {
        final seerahRes = _seerahModule.search(term);
        if (seerahRes.isSuccess) {
          for (final s in seerahRes.valueOrNull!) {
            if (seenContentIds.add(s.id)) {
              evidenceList.add(EvidenceItem(
                sourceId: 'seerah_canonical',
                contentId: s.id,
                contentType: 'seerah',
                title: s.title,
                textExcerpt: s.snippet,
                referenceLocation: s.tagLabel,
                verificationState: VerificationState.approved,
                relevanceScore: 0.85,
              ));
              if (evidenceList.length >= maxResults) break;
            }
          }
        }
      }

      // 4. Retrieve Hajj (M10)
      if (_hajjModule != null && _hajjModule.store.isMounted && evidenceList.length < maxResults) {
        final steps = _hajjModule.store.activePackage?.steps ?? const [];
        for (final step in steps) {
          if (step.title.contains(term) || step.description.contains(term)) {
            if (seenContentIds.add(step.stepId)) {
              evidenceList.add(EvidenceItem(
                sourceId: 'hajj_canonical',
                contentId: step.stepId,
                contentType: 'hajj_step',
                title: step.title,
                textExcerpt: step.description,
                referenceLocation: 'مناسك الحج والعمرة - المرحلة ${step.phase.labelArabic}',
                verificationState: VerificationState.canonical,
                relevanceScore: 0.88,
              ));
              if (evidenceList.length >= maxResults) break;
            }
          }
        }
      }

      // 5. Retrieve Learning (M8)
      if (_learningModule != null && _learningModule.store.isMounted && evidenceList.length < maxResults) {
        final learnRes = _learningModule.search(term);
        if (learnRes.isSuccess) {
          for (final l in learnRes.valueOrNull!) {
            if (seenContentIds.add(l.id)) {
              evidenceList.add(EvidenceItem(
                sourceId: l.authorOrSource,
                contentId: l.id,
                contentType: 'lesson',
                title: l.title,
                textExcerpt: l.snippet,
                referenceLocation: l.levelLabel,
                verificationState: VerificationState.approved,
                relevanceScore: 0.82,
              ));
              if (evidenceList.length >= maxResults) break;
            }
          }
        }
      }
    }

    // 6. Direct Quran Ayah if mounted (M2)
    if (_quranStore != null && _quranStore.isMounted && evidenceList.isEmpty && intent.category == IntentCategory.quranLookup) {
      final ayahRes = _quranStore.getAyah(1, 1);
      if (ayahRes.isSuccess) {
        evidenceList.add(EvidenceItem(
          sourceId: 'quran_uthmani_hafs',
          contentId: 'ayah_1_1',
          contentType: 'ayah',
          title: 'سورة الفاتحة [الآية 1]',
          textExcerpt: ayahRes.valueOrNull!.textUthmani,
          referenceLocation: 'المصحف الشريف - سورة الفاتحة',
          verificationState: VerificationState.canonical,
          relevanceScore: 1.0,
        ));
      }
    }

    return List.unmodifiable(evidenceList);
  }
}
