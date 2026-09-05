import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/storage/storage_contract.dart';
import 'domain/canonical_knowledge_package.dart';
import 'domain/fiqh_topic.dart';
import 'domain/hadith_entity.dart';
import 'domain/knowledge_user_progress.dart';
import 'domain/source_record.dart';
import 'services/fiqh_service.dart';
import 'services/hadith_service.dart';
import 'services/knowledge_graph_service.dart';
import 'services/knowledge_search_service.dart';
import 'services/source_registry_service.dart';
import 'store/knowledge_user_data_store.dart';
import 'store/read_only_knowledge_store.dart';
export 'services/knowledge_search_service.dart' show KnowledgeSearchFilter, KnowledgeSearchResult;

/// Unified Facade for the Islamic Knowledge & Hadith subsystem (Layer 2).
class KnowledgeModule {
  final ReadOnlyKnowledgeStore store;
  final SourceRegistryService sourceRegistryService;
  final HadithService hadithService;
  final FiqhService fiqhService;
  final KnowledgeSearchService searchService;
  final KnowledgeGraphService graphService;
  final KnowledgeUserDataStore userDataStore;

  KnowledgeModule({
    required StorageRegistry storageRegistry,
    EventBus? eventBus,
    ReadOnlyKnowledgeStore? knowledgeStore,
  }) : this._(
          storageRegistry: storageRegistry,
          store: knowledgeStore ?? ReadOnlyKnowledgeStore(eventBus: eventBus),
        );

  KnowledgeModule._({
    required StorageRegistry storageRegistry,
    required this.store,
  })  : sourceRegistryService = SourceRegistryService(store: store),
        hadithService = HadithService(store: store),
        fiqhService = FiqhService(store: store),
        searchService = KnowledgeSearchService(store: store),
        graphService = KnowledgeGraphService(store: store),
        userDataStore = KnowledgeUserDataStore(storageRegistry: storageRegistry);

  Result<void, Failure> mountPackage(CanonicalKnowledgePackage package) {
    return store.mountPackage(package);
  }

  Result<List<KnowledgeSearchResult>, Failure> search(String query, [KnowledgeSearchFilter? filter]) {
    return searchService.search(query, filter);
  }

  Result<HadithEntity, Failure> getHadith(String hadithId) {
    return hadithService.getHadithById(hadithId);
  }

  Result<FiqhTopic, Failure> getFiqhTopic(String topicId) {
    return fiqhService.getTopicById(topicId);
  }

  Result<SourceRecord, Failure> getSource(String sourceId) {
    return sourceRegistryService.getSource(sourceId);
  }

  Future<Result<KnowledgeUserProgress, Failure>> getUserProgress() {
    return userDataStore.getProgress();
  }

  Future<Result<void, Failure>> markCompleted(String itemId) {
    return userDataStore.markItemCompleted(itemId);
  }

  Future<Result<void, Failure>> toggleBookmark(String itemId) {
    return userDataStore.toggleBookmark(itemId);
  }

  Future<Result<void, Failure>> saveNote(String itemId, String note) {
    return userDataStore.saveUserNote(itemId, note);
  }

  Future<Result<void, Failure>> resetAllUserData() {
    return userDataStore.resetAllUserData();
  }
}
