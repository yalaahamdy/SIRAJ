import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/source_record.dart';
import '../domain/source_type.dart';
import '../store/read_only_knowledge_store.dart';

/// Service managing scholarly sources and verifying reference integrity (§5, §6).
class SourceRegistryService {
  final ReadOnlyKnowledgeStore _store;

  const SourceRegistryService({required ReadOnlyKnowledgeStore store}) : _store = store;

  /// Retrieves a specific source record by ID.
  Result<SourceRecord, Failure> getSource(String sourceId) {
    return _store.getSource(sourceId);
  }

  /// Lists all registered sources.
  Result<List<SourceRecord>, Failure> getAllSources() {
    return _store.getAllSources();
  }

  /// Filters sources by type.
  Result<List<SourceRecord>, Failure> getSourcesByType(SourceType type) {
    final allRes = _store.getAllSources();
    if (allRes.isFailure) return allRes;
    final filtered = allRes.valueOrNull!.where((s) => s.sourceType == type).toList();
    return Result.ok(filtered);
  }

  /// Validates that a source exists and passes integrity check.
  bool isValidSource(String sourceId) {
    final res = _store.getSource(sourceId);
    if (res.isFailure) return false;
    return res.valueOrNull!.verifyHash();
  }
}
