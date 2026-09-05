import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/storage/storage_contract.dart';
import '../../core/time/clock.dart';
import 'domain/dhikr_favorite.dart';
import 'domain/dhikr_item.dart';
import 'domain/dhikr_occasion.dart';
import 'domain/dhikr_user_progress.dart';
import 'search/adhkar_search_engine.dart';
import 'services/dhikr_occasion_engine.dart';
import 'store/adhkar_content_diff_engine.dart';
import 'store/adhkar_user_data_store.dart';
import 'store/canonical_adhkar_package.dart';
import 'store/read_only_adhkar_store.dart';

/// Unified Module Facade for the Adhkar & Dua Platform (§2, §22).
class AdhkarModule {
  final ReadOnlyAdhkarStore _store;
  final DhikrOccasionEngine _occasionEngine;
  final AdhkarSearchEngine _searchEngine;
  final AdhkarUserDataStore _userDataStore;
  final AdhkarContentDiffEngine _diffEngine;
  final Clock _clock;

  AdhkarModule({
    required StorageRegistry storageRegistry,
    ReadOnlyAdhkarStore? store,
    DhikrOccasionEngine? occasionEngine,
    AdhkarSearchEngine? searchEngine,
    AdhkarUserDataStore? userDataStore,
    AdhkarContentDiffEngine? diffEngine,
    Clock? customClock,
  })  : _clock = customClock ?? const SystemClock(),
        _store = store ?? ReadOnlyAdhkarStore(),
        _occasionEngine = occasionEngine ?? DhikrOccasionEngine(clock: customClock),
        _searchEngine = searchEngine ?? const AdhkarSearchEngine(),
        _userDataStore = userDataStore ?? AdhkarUserDataStore(storageRegistry: storageRegistry),
        _diffEngine = diffEngine ?? AdhkarContentDiffEngine(clock: customClock);

  ReadOnlyAdhkarStore get store => _store;
  AdhkarUserDataStore get userDataStore => _userDataStore;
  AdhkarContentDiffEngine get diffEngine => _diffEngine;
  Clock get clock => _clock;

  Future<void> initialize() async {
    // Initial bootstrap
  }

  Result<void, Failure> mountPackage(CanonicalAdhkarPackage package) {
    return _store.mountPackage(package);
  }

  Result<List<DhikrItem>, Failure> getAllItems() {
    return _store.getAllItems();
  }

  Result<DhikrItem, Failure> getItemById(String id) {
    return _store.getItemById(id);
  }

  Result<List<DhikrItem>, Failure> getItemsByOccasion(DhikrOccasion occasion) {
    return _store.getItemsByOccasion(occasion);
  }

  DhikrOccasion getCurrentOccasion() {
    return _occasionEngine.resolveCurrentOccasion(customTime: _clock.nowUtc());
  }

  List<DhikrItem> search(String query) {
    final allRes = _store.getAllItems();
    if (allRes.isFailure) return const [];
    return _searchEngine.search(query: query, items: allRes.valueOrNull!);
  }

  String _currentDateKey() {
    final now = _clock.nowUtc();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<Result<DhikrUserProgress, Failure>> getProgress(String contentId, int targetCount) async {
    final dateKey = _currentDateKey();
    final res = await _userDataStore.getProgress(contentId: contentId, dateKey: dateKey);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final existing = res.valueOrNull;
    if (existing != null) return Result.ok(existing);

    final initial = DhikrUserProgress(
      contentId: contentId,
      currentCount: 0,
      targetCount: targetCount,
      isCompleted: false,
      dateKey: dateKey,
      updatedAt: _clock.nowUtc(),
    );
    return Result.ok(initial);
  }

  Future<Result<DhikrUserProgress, Failure>> incrementProgress({
    required String contentId,
    required int targetCount,
  }) async {
    final progressRes = await getProgress(contentId, targetCount);
    if (progressRes.isFailure) return Result.err(progressRes.failureOrNull!);

    final current = progressRes.valueOrNull!;
    final nextCount = current.currentCount + 1;
    final updated = current.copyWith(
      currentCount: nextCount,
      targetCount: targetCount,
      isCompleted: nextCount >= targetCount,
      updatedAt: _clock.nowUtc(),
    );

    final saveRes = await _userDataStore.saveProgress(updated);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(updated);
  }

  Future<Result<DhikrUserProgress, Failure>> decrementProgress({
    required String contentId,
    required int targetCount,
  }) async {
    final progressRes = await getProgress(contentId, targetCount);
    if (progressRes.isFailure) return Result.err(progressRes.failureOrNull!);

    final current = progressRes.valueOrNull!;
    if (current.currentCount <= 0) return Result.ok(current);

    final nextCount = current.currentCount - 1;
    final updated = current.copyWith(
      currentCount: nextCount,
      targetCount: targetCount,
      isCompleted: nextCount >= targetCount,
      updatedAt: _clock.nowUtc(),
    );

    final saveRes = await _userDataStore.saveProgress(updated);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(updated);
  }

  Future<Result<DhikrUserProgress, Failure>> resetProgress({
    required String contentId,
    required int targetCount,
  }) async {
    final dateKey = _currentDateKey();
    final reset = DhikrUserProgress(
      contentId: contentId,
      currentCount: 0,
      targetCount: targetCount,
      isCompleted: false,
      dateKey: dateKey,
      updatedAt: _clock.nowUtc(),
    );

    final saveRes = await _userDataStore.saveProgress(reset);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(reset);
  }

  Future<Result<bool, Failure>> toggleFavorite(String contentId) async {
    return _userDataStore.toggleFavorite(contentId: contentId, now: _clock.nowUtc());
  }

  Future<Result<bool, Failure>> isFavorite(String contentId) async {
    return _userDataStore.isFavorite(contentId);
  }

  Future<Result<List<DhikrFavorite>, Failure>> getFavorites() async {
    return _userDataStore.getFavorites();
  }

  Future<Result<List<DhikrItem>, Failure>> getFavoriteItems() async {
    final favsRes = await _userDataStore.getFavorites();
    if (favsRes.isFailure) return Result.err(favsRes.failureOrNull!);

    final favList = favsRes.valueOrNull ?? [];
    final items = <DhikrItem>[];
    for (final fav in favList) {
      final itemRes = _store.getItemById(fav.contentId);
      if (itemRes.isSuccess && itemRes.valueOrNull != null) {
        items.add(itemRes.valueOrNull!);
      }
    }
    return Result.ok(List.unmodifiable(items));
  }

  String getOccasionExplanation(DhikrOccasion occasion) {
    switch (occasion) {
      case DhikrOccasion.morning:
        return 'وقت أذكار الصباح المسنونة (من بعد طلوع الفجر وحتى الشروق/الضحى)';
      case DhikrOccasion.evening:
        return 'وقت أذكار المساء المسنونة (من بعد العصر وحتى مغيب الشفق)';
      case DhikrOccasion.afterPrayer:
        return 'أذكار ما بعد الصلوات المكتوبة';
      case DhikrOccasion.sleep:
        return 'أذكار النوم وآداب الاضطجاع في ثلث الليل الأول والوسط';
      case DhikrOccasion.waking:
        return 'أذكار الاستيقاظ من النوم والحمد على رد الروح';
      case DhikrOccasion.leavingHome:
        return 'أذكار الخروج من المنزل والتوكل على الله';
      case DhikrOccasion.enteringHome:
        return 'أذكار الدخول إلى المنزل والبسملة';
      case DhikrOccasion.travel:
        return 'أذكار ودعاء السفر وركوب الدواب';
      case DhikrOccasion.food:
        return 'أذكار وآداب الطعام والشراب';
      case DhikrOccasion.difficulty:
        return 'أدعية الكرب وتفريج الهموم والشدائد';
      case DhikrOccasion.taharah:
        return 'أذكار الطهارة والوضوء وآداب دخول الخلاء والخروج منه';
      case DhikrOccasion.mosque:
        return 'أذكار المسجد والأذان والمشي إليها';
      case DhikrOccasion.prayer:
        return 'أذكار الصلاة التوقيفية من الاستفتاح والركوع والسجود والتشهد';
      case DhikrOccasion.clothing:
        return 'أذكار وآداب لبس الثوب الجديد وخلعه';
      case DhikrOccasion.illness:
        return 'أدعية عيادة المريض والرقية الشرعية وسؤال الشفاء';
      case DhikrOccasion.weather:
        return 'أذكار الرياح والرعد ونزول المطر والاستسقاء';
      case DhikrOccasion.funerals:
        return 'أدعية المصيبة وتلقين المحتضر والدفن وزيارة القبور';
      case DhikrOccasion.fasting:
        return 'أدعية الصائم عند الإفطار ورؤية الهلال وآداب الصيام';
      case DhikrOccasion.gatherings:
        return 'كفارة المجلس وإفشاء السلام والدعاء لمن صنع معروفاً';
      case DhikrOccasion.general:
        return 'الأذكار والتسبيحات المطلقة في كل وقت وحين';
    }
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    return _userDataStore.resetAllUserData();
  }
}
