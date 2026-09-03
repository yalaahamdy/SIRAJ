import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/knowledge_relation.dart';
import '../store/read_only_knowledge_store.dart';

/// Service exploring deterministic graph connections between canonical entities (§20).
class KnowledgeGraphService {
  final ReadOnlyKnowledgeStore _store;

  const KnowledgeGraphService({required ReadOnlyKnowledgeStore store}) : _store = store;

  /// Retrieves all relations originating from or targeting a specific key.
  Result<List<KnowledgeRelation>, Failure> getRelationsFor(String key) {
    return _store.getRelationsFor(key);
  }

  /// Retrieves evidence relations linked to a specific topic or ruling.
  Result<List<KnowledgeRelation>, Failure> getEvidencesFor(String targetKey) {
    final relsRes = _store.getRelationsFor(targetKey);
    if (relsRes.isFailure) return relsRes;
    final filtered = relsRes.valueOrNull!.where((r) => r.relationType == RelationType.evidenceFor).toList();
    return Result.ok(filtered);
  }

  /// Retrieves commentaries linked to a specific Hadith or text.
  Result<List<KnowledgeRelation>, Failure> getCommentariesFor(String targetKey) {
    final relsRes = _store.getRelationsFor(targetKey);
    if (relsRes.isFailure) return relsRes;
    final filtered = relsRes.valueOrNull!.where((r) => r.relationType == RelationType.commentaryOn).toList();
    return Result.ok(filtered);
  }
}
