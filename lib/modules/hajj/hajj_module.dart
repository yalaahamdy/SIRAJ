import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../adhkar/adhkar_module.dart';
import '../adhkar/domain/dhikr_item.dart';
import '../knowledge/domain/hadith_entity.dart';
import '../knowledge/domain/source_record.dart';
import '../knowledge/knowledge_module.dart';
import 'domain/canonical_hajj_package.dart';
import 'domain/hajj_user_progress.dart';
import 'domain/journey_type.dart';
import 'domain/miqat.dart';
import 'domain/preparation_item.dart';
import 'domain/ritual_step.dart';
import 'domain/sacred_location.dart';
import 'engine/hajj_journey_engine.dart';
import 'services/miqat_service.dart';
import 'store/hajj_user_data_store.dart';
import 'store/read_only_hajj_store.dart';

/// Resolved references and invocations for a ritual step (§29, §30).
class StepResolvedReferences {
  final List<SourceRecord> sources;
  final List<HadithEntity> hadiths;
  final List<DhikrItem> adhkar;

  const StepResolvedReferences({
    this.sources = const [],
    this.hadiths = const [],
    this.adhkar = const [],
  });
}

/// Unified Facade for SIRAJ Hajj & Umrah Journey Platform (§4, §5).
class HajjModule {
  final ReadOnlyHajjStore _store;
  final HajjUserDataStore _userDataStore;
  final HajjJourneyEngine _journeyEngine;
  final MiqatService _miqatService;
  final KnowledgeModule? _knowledgeModule;
  final AdhkarModule? _adhkarModule;

  factory HajjModule({
    required StorageRegistry storageRegistry,
    ReadOnlyHajjStore? store,
    KnowledgeModule? knowledgeModule,
    AdhkarModule? adhkarModule,
  }) {
    final s = store ?? ReadOnlyHajjStore();
    return HajjModule._(
      store: s,
      userDataStore: HajjUserDataStore(registry: storageRegistry),
      journeyEngine: HajjJourneyEngine(store: s),
      miqatService: MiqatService(store: s),
      knowledgeModule: knowledgeModule,
      adhkarModule: adhkarModule,
    );
  }

  HajjModule._({
    required ReadOnlyHajjStore store,
    required HajjUserDataStore userDataStore,
    required HajjJourneyEngine journeyEngine,
    required MiqatService miqatService,
    KnowledgeModule? knowledgeModule,
    AdhkarModule? adhkarModule,
  })  : _store = store,
        _userDataStore = userDataStore,
        _journeyEngine = journeyEngine,
        _miqatService = miqatService,
        _knowledgeModule = knowledgeModule,
        _adhkarModule = adhkarModule;

  ReadOnlyHajjStore get store => _store;
  HajjUserDataStore get userDataStore => _userDataStore;
  HajjJourneyEngine get journeyEngine => _journeyEngine;
  MiqatService get miqatService => _miqatService;

  Result<void, Failure> mountPackage(CanonicalHajjPackage package) {
    return _store.mountPackage(package);
  }

  void unmount() {
    _store.unmount();
  }

  Result<List<RitualStep>, Failure> getStepsForJourney(JourneyType type) {
    return _store.getStepsForJourney(type);
  }

  Result<RitualStep, Failure> getStep(String stepId) {
    return _store.getStep(stepId);
  }

  Result<List<Miqat>, Failure> getAllMiqats() {
    return _store.getAllMiqats();
  }

  Result<Miqat, Failure> getMiqat(String miqatId) {
    return _store.getMiqat(miqatId);
  }

  Result<List<SacredLocation>, Failure> getAllLocations() {
    return _store.getAllLocations();
  }

  Result<SacredLocation, Failure> getLocation(String locationId) {
    return _store.getLocation(locationId);
  }

  Result<List<PreparationItem>, Failure> getPreparationItems() {
    return _store.getPreparationItems();
  }

  Future<Result<HajjUserProgress, Failure>> getUserProgress() {
    return _userDataStore.getProgress();
  }

  Future<Result<void, Failure>> setJourneyType(JourneyType type) {
    return _userDataStore.setJourneyType(type);
  }

  Future<Result<void, Failure>> setJourneyState(JourneyState state) {
    return _userDataStore.setJourneyState(state);
  }

  Future<Result<void, Failure>> markStepCompleted(String stepId) {
    return _userDataStore.markStepCompleted(stepId);
  }

  Future<Result<void, Failure>> togglePreparationItem(String itemId) {
    return _userDataStore.togglePreparationItem(itemId);
  }

  Future<Result<void, Failure>> saveUserNote(String stepId, String note) {
    return _userDataStore.saveUserNote(stepId, note);
  }

  Future<Result<void, Failure>> resetAllUserData() {
    return _userDataStore.resetAllUserData();
  }

  Future<Result<JourneyStatusSnapshot, Failure>> getJourneySnapshot() async {
    final progRes = await getUserProgress();
    if (progRes.isFailure) return Result.err(progRes.failureOrNull!);
    return _journeyEngine.calculateSnapshot(progRes.valueOrNull!);
  }

  Result<List<MiqatDistanceResult>, Failure> findClosestMiqats(double lat, double lon) {
    return _miqatService.findClosestMiqats(lat, lon);
  }

  Result<StepResolvedReferences, Failure> resolveStepReferences(String stepId) {
    final stepRes = _store.getStep(stepId);
    if (stepRes.isFailure) return Result.err(stepRes.failureOrNull!);
    final step = stepRes.valueOrNull!;

    final sources = <SourceRecord>[];
    final hadiths = <HadithEntity>[];
    final adhkarList = <DhikrItem>[];

    if (_knowledgeModule != null) {
      for (final srcId in step.sourceIds) {
        final srcRes = _knowledgeModule.store.getSource(srcId);
        if (srcRes.isSuccess) {
          sources.add(srcRes.valueOrNull!);
        }
      }
    }

    if (_adhkarModule != null) {
      for (final key in step.duaAdhkarKeys) {
        final dhikrRes = _adhkarModule.store.getItemById(key);
        if (dhikrRes.isSuccess) {
          adhkarList.add(dhikrRes.valueOrNull!);
        }
      }
    }

    return Result.ok(StepResolvedReferences(
      sources: List.unmodifiable(sources),
      hadiths: List.unmodifiable(hadiths),
      adhkar: List.unmodifiable(adhkarList),
    ));
  }
}
