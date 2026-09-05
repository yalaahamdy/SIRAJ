import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/hadith_entity.dart';
import '../domain/hadith_grading.dart';
import '../domain/source_record.dart';
import '../domain/source_type.dart';
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

  Result<HadithEntity, Failure> getDailyHadith(DateTime date) {
    return _store.getDailyHadith(date);
  }

  Result<List<Map<String, dynamic>>, Failure> getBooksWithCounts(String collectionId) {
    return _store.getBooksByCollection(collectionId);
  }

  Result<List<SourceRecord>, Failure> getHadithCollections() {
    final sourcesRes = _store.getAllSources();
    if (sourcesRes.isFailure) return sourcesRes;
    final list = sourcesRes.valueOrNull!.where((s) => s.sourceType == SourceType.hadithCollection).toList();
    return Result.ok(list);
  }
}
