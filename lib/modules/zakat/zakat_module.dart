import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/storage/storage_contract.dart';
import '../../core/time/clock.dart';
import 'domain/market_data_snapshot.dart';
import 'domain/zakat_asset.dart';
import 'domain/zakat_calculation_result.dart';
import 'domain/zakat_calculation_snapshot.dart';
import 'domain/zakat_policy.dart';
import 'domain/zakat_profile.dart';
import 'engine/hawl_engine.dart';
import 'engine/nisab_engine.dart';
import 'engine/zakat_calculation_engine.dart';
import 'store/zakat_user_data_store.dart';

/// Unified Module Facade for Zakat Engine & Governance (§3, §20).
class ZakatModule {
  final ZakatCalculationEngine _calcEngine;
  final NisabEngine _nisabEngine;
  final HawlEngine _hawlEngine;
  final ZakatUserDataStore _userDataStore;
  final Clock _clock;

  ZakatModule({
    required StorageRegistry storageRegistry,
    ZakatCalculationEngine? calcEngine,
    NisabEngine? nisabEngine,
    HawlEngine? hawlEngine,
    ZakatUserDataStore? userDataStore,
    Clock? customClock,
  })  : _clock = customClock ?? const SystemClock(),
        _nisabEngine = nisabEngine ?? const NisabEngine(),
        _hawlEngine = hawlEngine ?? HawlEngine(clock: customClock),
        _calcEngine = calcEngine ??
            ZakatCalculationEngine(
              nisabEngine: nisabEngine,
              hawlEngine: hawlEngine,
              clock: customClock,
            ),
        _userDataStore = userDataStore ?? ZakatUserDataStore(storageRegistry: storageRegistry);

  ZakatUserDataStore get userDataStore => _userDataStore;
  ZakatCalculationEngine get calcEngine => _calcEngine;
  NisabEngine get nisabEngine => _nisabEngine;
  HawlEngine get hawlEngine => _hawlEngine;
  Clock get clock => _clock;

  Future<void> initialize() async {
    // Initial bootstrap
  }

  List<ZakatPolicy> getAvailablePolicies() {
    return const [
      ZakatPolicy.goldStandard,
      ZakatPolicy.silverStandard,
      ZakatPolicy.manualStandard,
    ];
  }

  Future<ZakatProfile> getProfile() async {
    final res = await _userDataStore.getProfile();
    return res.valueOrNull ?? const ZakatProfile();
  }

  Future<Result<void, Failure>> saveProfile(ZakatProfile profile) async {
    return _userDataStore.saveProfile(profile);
  }

  Future<ZakatPolicy> getActivePolicy() async {
    final profile = await getProfile();
    final match = getAvailablePolicies().where((p) => p.policyId == profile.calculationPolicyId).firstOrNull;
    if (match != null) return match;

    final policyIdRes = await _userDataStore.getSelectedPolicyId();
    final policyId = policyIdRes.valueOrNull;

    if (policyId != null) {
      final oldMatch = getAvailablePolicies().where((p) => p.policyId == policyId).firstOrNull;
      if (oldMatch != null) return oldMatch;
    }

    return ZakatPolicy.goldStandard;
  }

  Future<Result<void, Failure>> setActivePolicy(String policyId) async {
    final profile = await getProfile();
    await _userDataStore.saveProfile(profile.copyWith(calculationPolicyId: policyId));
    return _userDataStore.setSelectedPolicyId(policyId);
  }

  Future<Result<List<ZakatAsset>, Failure>> getAssets() async {
    return _userDataStore.getAssets();
  }

  Future<Result<void, Failure>> addOrUpdateAsset(ZakatAsset asset) async {
    return _userDataStore.saveAsset(asset);
  }

  Future<Result<void, Failure>> deleteAsset(String id) async {
    return _userDataStore.deleteAsset(id);
  }

  Future<MarketDataSnapshot> getMarketSnapshot() async {
    final snapRes = await _userDataStore.getMarketSnapshot();
    final stored = snapRes.valueOrNull;
    final profile = await getProfile();

    if (stored != null && stored.currency == profile.currencyCode) {
      return stored;
    }

    // Default reference snapshot in active profile currency (EGP default: Gold ~ 4,500 EGP/g, Silver ~ 55 EGP/g)
    return MarketDataSnapshot(
      goldPricePerGram24k: profile.goldPricePerGram,
      silverPricePerGram: profile.silverPricePerGram,
      currency: profile.currencyCode,
      sourceName: 'سعر استرشادي محلي (قابل للتعديل)',
      timestamp: _clock.nowUtc(),
      isManualEntry: true,
    );
  }

  Future<Result<void, Failure>> setMarketSnapshot(MarketDataSnapshot snapshot) async {
    return _userDataStore.setMarketSnapshot(snapshot);
  }

  Future<Result<ZakatCalculationResult, Failure>> calculateZakat({
    bool? isHijriCalendar,
  }) async {
    final assetsRes = await getAssets();
    if (assetsRes.isFailure) return Result.err(assetsRes.failureOrNull!);

    final profile = await getProfile();
    final policy = await getActivePolicy();
    final marketSnapshot = await getMarketSnapshot();
    final useHijri = isHijriCalendar ?? profile.isHijriCalendar;

    final result = _calcEngine.calculate(
      assets: assetsRes.valueOrNull!,
      policy: policy,
      marketSnapshot: marketSnapshot,
      isHijriCalendar: useHijri,
      customNow: _clock.nowUtc(),
      manualNisabAmount: profile.manualNisabValue,
      customHawlStartDate: profile.hawlStartDate,
    );

    return Result.ok(result);
  }

  Future<Result<ZakatCalculationSnapshot, Failure>> saveSnapshot(ZakatCalculationResult result) async {
    final assetsRes = await getAssets();
    if (assetsRes.isFailure) return Result.err(assetsRes.failureOrNull!);

    final now = _clock.nowUtc();
    final snapshotId = 'snap_zakat_${now.millisecondsSinceEpoch}';

    final snapshot = ZakatCalculationSnapshot.create(
      snapshotId: snapshotId,
      assets: assetsRes.valueOrNull!,
      policy: result.policyUsed,
      marketSnapshot: result.marketSnapshotUsed,
      result: result,
      createdAt: now,
    );

    final saveRes = await _userDataStore.saveSnapshot(snapshot);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(snapshot);
  }

  Future<Result<List<ZakatCalculationSnapshot>, Failure>> getSnapshots() async {
    return _userDataStore.getSnapshots();
  }

  Future<Result<void, Failure>> deleteSnapshot(String snapshotId) async {
    return _userDataStore.deleteSnapshot(snapshotId);
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    return _userDataStore.resetAllUserData();
  }
}
