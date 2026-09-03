import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../domain/canonical_knowledge_package.dart';
import '../domain/fiqh_topic.dart';
import '../domain/hadith_entity.dart';
import '../domain/knowledge_item.dart';
import '../domain/knowledge_relation.dart';
import '../domain/learning_path.dart';
import '../domain/source_record.dart';

/// Read-only in-memory canonical repository with Fail-Closed security (§23, §24).
class ReadOnlyKnowledgeStore {
  CanonicalKnowledgePackage? _activePackage;

  final Map<String, SourceRecord> _sourcesById = {};
  final Map<String, HadithEntity> _hadithsById = {};
  final Map<String, List<HadithEntity>> _hadithsByCollection = {};
  final Map<String, FiqhTopic> _fiqhTopicsById = {};
  final Map<String, KnowledgeItem> _knowledgeItemsById = {};
  final Map<String, List<KnowledgeRelation>> _relationsBySource = {};
  final Map<String, LearningPath> _learningPathsById = {};

  final EventBus? _eventBus;

  ReadOnlyKnowledgeStore({EventBus? eventBus}) : _eventBus = eventBus;

  CanonicalKnowledgePackage? get activePackage => _activePackage;
  bool get isMounted => _activePackage != null;

  /// Mounts a new [CanonicalKnowledgePackage] with strict cryptographic validation.
  Result<void, Failure> mountPackage(CanonicalKnowledgePackage package) {
    if (!package.verifyPackageIntegrity()) {
      _eventBus?.publish(
        PackageRejectedEvent(
          packageId: package.packageId,
          reason: 'Cryptographic integrity verification failed for Knowledge Package',
        ),
      );
      return Result.err(
        const ContentIntegrityFailure(message: 'Knowledge package verification failed: Hash mismatch or untrusted signature'),
      );
    }

    _sourcesById.clear();
    _hadithsById.clear();
    _hadithsByCollection.clear();
    _fiqhTopicsById.clear();
    _knowledgeItemsById.clear();
    _relationsBySource.clear();
    _learningPathsById.clear();

    for (final s in package.sources) {
      _sourcesById[s.sourceId] = s;
    }

    for (final h in package.hadiths) {
      _hadithsById[h.hadithId] = h;
      _hadithsByCollection.putIfAbsent(h.collectionId, () => []).add(h);
    }

    for (final f in package.fiqhTopics) {
      _fiqhTopicsById[f.topicId] = f;
    }

    for (final k in package.knowledgeItems) {
      _knowledgeItemsById[k.itemId] = k;
    }

    for (final r in package.relations) {
      _relationsBySource.putIfAbsent(r.sourceKey, () => []).add(r);
      if (r.targetKey != r.sourceKey) {
        _relationsBySource.putIfAbsent(r.targetKey, () => []).add(r);
      }
    }

    for (final l in package.learningPaths) {
      _learningPathsById[l.pathId] = l;
    }

    _activePackage = package;

    return Result.ok(null);
  }

  Result<SourceRecord, Failure> getSource(String sourceId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _sourcesById[sourceId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Source not found: $sourceId'));
    return Result.ok(item);
  }

  Result<List<SourceRecord>, Failure> getAllSources() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_sourcesById.values.toList());
  }

  Result<HadithEntity, Failure> getHadith(String hadithId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _hadithsById[hadithId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Hadith not found: $hadithId'));
    return Result.ok(item);
  }

  Result<List<HadithEntity>, Failure> getHadithsByCollection(String collectionId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_hadithsByCollection[collectionId] ?? const []);
  }

  Result<List<HadithEntity>, Failure> getAllHadiths() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_hadithsById.values.toList());
  }

  Result<FiqhTopic, Failure> getFiqhTopic(String topicId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _fiqhTopicsById[topicId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Fiqh topic not found: $topicId'));
    return Result.ok(item);
  }

  Result<List<FiqhTopic>, Failure> getAllFiqhTopics() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_fiqhTopicsById.values.toList());
  }

  Result<KnowledgeItem, Failure> getKnowledgeItem(String itemId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _knowledgeItemsById[itemId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Knowledge item not found: $itemId'));
    return Result.ok(item);
  }

  Result<List<KnowledgeItem>, Failure> getAllKnowledgeItems() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_knowledgeItemsById.values.toList());
  }

  Result<List<KnowledgeRelation>, Failure> getRelationsFor(String sourceKey) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_relationsBySource[sourceKey] ?? const []);
  }

  Result<LearningPath, Failure> getLearningPath(String pathId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _learningPathsById[pathId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Learning path not found: $pathId'));
    return Result.ok(item);
  }

  Result<List<LearningPath>, Failure> getAllLearningPaths() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_learningPathsById.values.toList());
  }

  /// Verifies internal cryptographic health of currently mounted dataset.
  bool verifyIntegrity() {
    if (_activePackage == null) return false;
    return _activePackage!.verifyPackageIntegrity();
  }
}
