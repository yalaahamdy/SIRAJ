import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/storage/storage_contract.dart';
import '../knowledge/knowledge_module.dart';
import 'domain/canonical_seerah_package.dart';
import 'domain/historical_period.dart';
import 'domain/historical_person.dart';
import 'domain/historical_place.dart';
import 'domain/person_relationship.dart';
import 'domain/seerah_event.dart';
import 'domain/seerah_user_progress.dart';
import 'engine/chronology_engine.dart';
import 'engine/narrative_engine.dart';
import 'engine/seerah_timeline_engine.dart';
import 'search/seerah_search_service.dart';
import 'store/read_only_seerah_store.dart';
import 'store/seerah_user_data_store.dart';

/// Unified Facade for the Seerah & Islamic History subsystem (Layer 2).
class SeerahModule {
  final ReadOnlySeerahStore store;
  final ChronologyEngine chronologyEngine;
  final SeerahTimelineEngine timelineEngine;
  final NarrativeEngine narrativeEngine;
  final SeerahSearchService searchService;
  final SeerahUserDataStore userDataStore;

  SeerahModule({
    required StorageRegistry storageRegistry,
    EventBus? eventBus,
    ReadOnlySeerahStore? seerahStore,
    KnowledgeModule? knowledgeModule,
  }) : this._(
          storageRegistry: storageRegistry,
          store: seerahStore ?? ReadOnlySeerahStore(eventBus: eventBus),
          knowledgeModule: knowledgeModule,
        );

  SeerahModule._({
    required StorageRegistry storageRegistry,
    required this.store,
    KnowledgeModule? knowledgeModule,
  })  : chronologyEngine = ChronologyEngine(store: store),
        timelineEngine = SeerahTimelineEngine(store: store),
        narrativeEngine = NarrativeEngine(seerahStore: store, knowledgeModule: knowledgeModule),
        searchService = SeerahSearchService(store: store),
        userDataStore = SeerahUserDataStore(storageRegistry: storageRegistry);

  Result<void, Failure> mountPackage(CanonicalSeerahPackage package) {
    return store.mountPackage(package);
  }

  Result<List<HistoricalPeriod>, Failure> getAllPeriods() {
    return store.getAllPeriods();
  }

  Result<HistoricalPeriod, Failure> getPeriod(String periodId) {
    return store.getPeriod(periodId);
  }

  Result<List<SeerahEvent>, Failure> getAllEvents() {
    return store.getAllEvents();
  }

  Result<SeerahEvent, Failure> getEvent(String eventId) {
    return store.getEvent(eventId);
  }

  Result<List<SeerahEvent>, Failure> getEventsByPeriod(String periodId) {
    return store.getEventsByPeriod(periodId);
  }

  Result<List<HistoricalPerson>, Failure> getAllPersons() {
    return store.getAllPersons();
  }

  Result<HistoricalPerson, Failure> getPerson(String personId) {
    return store.getPerson(personId);
  }

  Result<List<PersonRelationship>, Failure> getRelationshipsForPerson(String personId) {
    return store.getRelationshipsForPerson(personId);
  }

  Result<List<HistoricalPlace>, Failure> getAllPlaces() {
    return store.getAllPlaces();
  }

  Result<HistoricalPlace, Failure> getPlace(String placeId) {
    return store.getPlace(placeId);
  }

  Result<List<PeriodTimelineSlice>, Failure> getSequencedTimeline() {
    return timelineEngine.getSequencedTimeline();
  }

  Result<ResolvedEventReferences, Failure> resolveEventReferences(String eventId) {
    return narrativeEngine.resolveEventReferences(eventId);
  }

  Result<bool, Failure> validateAllChronology() {
    return chronologyEngine.validateAllChronology();
  }

  Future<Result<SeerahUserProgress, Failure>> getUserProgress() {
    return userDataStore.getProgress();
  }

  Future<Result<void, Failure>> markEventViewed(String eventId) {
    return userDataStore.markEventViewed(eventId);
  }

  Future<Result<void, Failure>> toggleBookmark(String eventId) {
    return userDataStore.toggleBookmark(eventId);
  }

  Future<Result<void, Failure>> saveUserNote(String eventId, String note) {
    return userDataStore.saveUserNote(eventId, note);
  }

  Result<List<SeerahSearchResult>, Failure> search(String query) {
    return searchService.search(query);
  }

  Future<Result<void, Failure>> resetAllUserData() {
    return userDataStore.resetAllUserData();
  }
}
