import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/hadith_entity.dart';
import '../domain/hadith_grading.dart';
import '../store/read_only_knowledge_store.dart';

/// Core service for Hadith narration lookup, multi-grading retrieval, and commentaries (§7, §10, §11).
class HadithService {
  final ReadOnlyKnowledgeStore _store;

  const HadithService({required ReadOnlyKnowledgeStore store}) : _store = store;

  Result<HadithEntity, Failure> getHadithById(String hadithId) {
    return _store.getHadith(hadithId);
  }

  Result<List<HadithEntity>, Failure> getHadithsByCollection(String collectionId) {
    return _store.getHadithsByCollection(collectionId);
  }

  Result<List<HadithEntity>, Failure> getHadithsByBook(String collectionId, int bookNumber) {
    final res = _store.getHadithsByCollection(collectionId);
    if (res.isFailure) return res;
    final list = res.valueOrNull!.where((h) => h.bookNumber == bookNumber).toList();
    return Result.ok(list);
  }

  Result<List<HadithEntity>, Failure> getHadithsByGrade(HadithGrade grade) {
    final allRes = _store.getAllHadiths();
    if (allRes.isFailure) return allRes;
    final filtered = allRes.valueOrNull!.where((h) => h.gradings.any((g) => g.grade == grade)).toList();
    return Result.ok(filtered);
  }
}
