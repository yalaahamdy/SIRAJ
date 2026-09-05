import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/fiqh_school.dart';
import '../domain/fiqh_topic.dart';
import '../store/read_only_knowledge_store.dart';

/// Service for exploring Islamic jurisprudential topics and multi-school positions (§13, §14).
class FiqhService {
  final ReadOnlyKnowledgeStore _store;

  const FiqhService({required ReadOnlyKnowledgeStore store}) : _store = store;

  Result<FiqhTopic, Failure> getTopicById(String topicId) {
    return _store.getFiqhTopic(topicId);
  }

  Result<List<FiqhTopic>, Failure> getAllTopics() {
    return _store.getAllFiqhTopics();
  }

  Result<List<FiqhTopic>, Failure> getTopicsByCategory(String category) {
    final allRes = _store.getAllFiqhTopics();
    if (allRes.isFailure) return allRes;
    final filtered = allRes.valueOrNull!.where((t) => t.category == category).toList();
    return Result.ok(filtered);
  }

  Result<List<FiqhTopic>, Failure> getTopicsBySchool(FiqhSchool school) {
    final allRes = _store.getAllFiqhTopics();
    if (allRes.isFailure) return allRes;
    final filtered = allRes.valueOrNull!.where((t) => t.positions.any((p) => p.school == school)).toList();
    return Result.ok(filtered);
  }

  Result<List<String>, Failure> getCategories() {
    final allRes = _store.getAllFiqhTopics();
    if (allRes.isFailure) return Result.err(allRes.failureOrNull!);
    final categories = allRes.valueOrNull!.map((t) => t.category).toSet().toList()..sort();
    return Result.ok(categories);
  }
}
