import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../knowledge/domain/hadith_entity.dart';
import '../../knowledge/domain/source_record.dart';
import '../../knowledge/knowledge_module.dart';
import '../domain/evidence_link.dart';
import '../domain/lesson.dart';
import '../store/read_only_learning_store.dart';

/// Resolved evidence payload for display in lesson views (§11, §12).
class ResolvedEvidence {
  final EvidenceLink link;
  final HadithEntity? hadith;
  final SourceRecord? source;

  const ResolvedEvidence({
    required this.link,
    this.hadith,
    this.source,
  });
}

/// Engine managing lesson loading, section decomposition, and evidence resolution (§11, §12).
class LessonEngine {
  final ReadOnlyLearningStore _learningStore;
  final KnowledgeModule? _knowledgeModule;

  const LessonEngine({
    required ReadOnlyLearningStore learningStore,
    KnowledgeModule? knowledgeModule,
  })  : _learningStore = learningStore,
        _knowledgeModule = knowledgeModule;

  Result<Lesson, Failure> getLesson(String lessonId) {
    return _learningStore.getLesson(lessonId);
  }

  /// Resolves an evidence link with its underlying Hadith or Source record from M7 if available.
  ResolvedEvidence resolveEvidence(EvidenceLink link) {
    HadithEntity? hadith;
    SourceRecord? source;

    if (_knowledgeModule != null) {
      final hadithRes = _knowledgeModule.getHadith(link.evidenceKey);
      if (hadithRes.isSuccess) hadith = hadithRes.valueOrNull;

      final srcRes = _knowledgeModule.getSource(link.sourceId);
      if (srcRes.isSuccess) source = srcRes.valueOrNull;
    }

    return ResolvedEvidence(
      link: link,
      hadith: hadith,
      source: source,
    );
  }
}
