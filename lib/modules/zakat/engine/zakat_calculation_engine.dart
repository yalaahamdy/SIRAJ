import 'dart:math';
import '../../../core/time/clock.dart';
import '../domain/asset_category.dart';
import '../domain/currency_amount.dart';
import '../domain/debt_treatment.dart';
import '../domain/market_data_snapshot.dart';
import '../domain/zakat_asset.dart';
import '../domain/zakat_calculation_result.dart';
import '../domain/zakat_policy.dart';
import 'hawl_engine.dart';
import 'nisab_engine.dart';

/// Pure, deterministic calculation engine for Zakat evaluation (§20, §21).
class ZakatCalculationEngine {
  final NisabEngine _nisabEngine;
  final HawlEngine _hawlEngine;
  final Clock _clock;

  ZakatCalculationEngine({
    NisabEngine? nisabEngine,
    HawlEngine? hawlEngine,
    Clock? clock,
  })  : _nisabEngine = nisabEngine ?? const NisabEngine(),
        _hawlEngine = hawlEngine ?? HawlEngine(clock: clock),
        _clock = clock ?? const SystemClock();

  ZakatCalculationResult calculate({
    required List<ZakatAsset> assets,
    required ZakatPolicy policy,
    required MarketDataSnapshot marketSnapshot,
    bool isHijriCalendar = true,
    DateTime? customNow,
  }) {
    final now = customNow ?? _clock.nowUtc();
    final currency = marketSnapshot.currency;

    // 1. Value all assets item by item
    var grossUnits = 0;
    var debtUnits = 0;
    final itemizedMap = <String, CurrencyAmount>{};
    DateTime? oldestDate;

    for (final asset in assets) {
      if (oldestDate == null || asset.acquisitionDate.isBefore(oldestDate)) {
        oldestDate = asset.acquisitionDate;
      }

      final itemValue = _evaluateAssetValue(asset: asset, marketSnapshot: marketSnapshot);
      itemizedMap[asset.id] = itemValue;

      if (asset.category.isLiability || asset.isDeductibleDebt) {
        if (policy.debtTreatment != DebtTreatment.ignoreDebts) {
          debtUnits += itemValue.units;
        }
      } else {
        grossUnits += itemValue.units;
      }
    }

    final grossAssets = CurrencyAmount(units: grossUnits, currency: currency);
    final deductibleLiabilities = CurrencyAmount(units: debtUnits, currency: currency);
    final netBaseUnits = max(0, grossUnits - debtUnits);
    final netZakatableBase = CurrencyAmount(units: netBaseUnits, currency: currency);

    // 2. Nisab evaluation
    final hasValidNisabPrice = _nisabEngine.hasValidPrice(
      policy: policy,
      marketSnapshot: marketSnapshot,
    );

    final nisabThreshold = _nisabEngine.calculateNisabThreshold(
      policy: policy,
      marketSnapshot: marketSnapshot,
    );

    final reachesNisab = hasValidNisabPrice && netZakatableBase.units >= nisabThreshold.units;

    // 3. Hawl evaluation
    final hawlStart = oldestDate ?? now;
    final isHawlComplete = _hawlEngine.isHawlCompleted(
      startDate: hawlStart,
      currentTime: now,
      isHijri: isHijriCalendar,
    );
    final daysRemaining = _hawlEngine.calculateDaysRemaining(
      startDate: hawlStart,
      currentTime: now,
      isHijri: isHijriCalendar,
    );

    // 4. Rate & Zakat determination
    final appliedRate = isHijriCalendar ? policy.annualRateHijri : policy.annualRateGregorian;

    ZakatResultStatus status;
    CurrencyAmount zakatDue;

    if (!hasValidNisabPrice) {
      status = ZakatResultStatus.insufficientData;
      zakatDue = CurrencyAmount.zero;
    } else if (assets.isEmpty || netZakatableBase.isZero || !reachesNisab) {
      status = ZakatResultStatus.notDueBelowNisab;
      zakatDue = CurrencyAmount.zero;
    } else if (!isHawlComplete) {
      status = ZakatResultStatus.notDueHawlIncomplete;
      zakatDue = CurrencyAmount.zero;
    } else {
      status = ZakatResultStatus.due;
      zakatDue = netZakatableBase.multiplyByRate(appliedRate);
    }

    // 5. Build transparent explanation
    final explanation = _buildExplanation(
      status: status,
      grossAssets: grossAssets,
      deductibleLiabilities: deductibleLiabilities,
      netZakatableBase: netZakatableBase,
      nisabThreshold: nisabThreshold,
      zakatDue: zakatDue,
      appliedRate: appliedRate,
      policy: policy,
      daysRemaining: daysRemaining,
      isHijriCalendar: isHijriCalendar,
    );

    return ZakatCalculationResult(
      status: status,
      grossAssets: grossAssets,
      deductibleLiabilities: deductibleLiabilities,
      netZakatableBase: netZakatableBase,
      nisabThreshold: nisabThreshold,
      zakatDue: zakatDue,
      isHawlComplete: isHawlComplete,
      daysRemainingInHawl: daysRemaining,
      appliedRate: appliedRate,
      policyUsed: policy,
      marketSnapshotUsed: marketSnapshot,
      itemizedAssetValues: itemizedMap,
      explanation: explanation,
      calculatedAt: now,
    );
  }

  CurrencyAmount _evaluateAssetValue({
    required ZakatAsset asset,
    required MarketDataSnapshot marketSnapshot,
  }) {
    if (asset.category == AssetCategory.gold && asset.weightGrams != null && asset.weightGrams! > 0) {
      final karat = (asset.purityKarat ?? 24).clamp(1, 24);
      final purityMultiplier = karat / 24.0;
      final goldPrice = marketSnapshot.goldPricePerGram24k;
      if (goldPrice.units <= 0) return CurrencyAmount.zero;

      final rawUnits = (asset.weightGrams! * goldPrice.units * purityMultiplier).round();
      return CurrencyAmount(
        units: max(0, rawUnits),
        decimals: goldPrice.decimals,
        currency: goldPrice.currency,
      );
    }

    if (asset.category == AssetCategory.silver && asset.weightGrams != null && asset.weightGrams! > 0) {
      final silverPrice = marketSnapshot.silverPricePerGram;
      if (silverPrice.units <= 0) return CurrencyAmount.zero;

      final rawUnits = (asset.weightGrams! * silverPrice.units).round();
      return CurrencyAmount(
        units: max(0, rawUnits),
        decimals: silverPrice.decimals,
        currency: silverPrice.currency,
      );
    }

    if (asset.amount.units < 0) {
      return CurrencyAmount(
        units: 0,
        decimals: asset.amount.decimals,
        currency: asset.amount.currency,
      );
    }

    return asset.amount;
  }

  String _buildExplanation({
    required ZakatResultStatus status,
    required CurrencyAmount grossAssets,
    required CurrencyAmount deductibleLiabilities,
    required CurrencyAmount netZakatableBase,
    required CurrencyAmount nisabThreshold,
    required CurrencyAmount zakatDue,
    required double appliedRate,
    required ZakatPolicy policy,
    required int daysRemaining,
    required bool isHijriCalendar,
  }) {
    final ratePercent = (appliedRate * 100).toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');
    final calendarType = isHijriCalendar ? 'سنة هجرية' : 'سنة ميلادية';

    switch (status) {
      case ZakatResultStatus.due:
        return 'الزكاة مستحقة شرعاً بمقدار ${zakatDue.format()} ($ratePercent% لـ$calendarType) '
            'على الوعاء الزكوي الصافي البالغ ${netZakatableBase.format()} بعد استيفاء النصاب (${nisabThreshold.format()}) وحولان الحول وفق ${policy.nameArabic}.';

      case ZakatResultStatus.notDueBelowNisab:
        return 'الزكاة غير واجبة حالياً لأن الوعاء الزكوي الصافي (${netZakatableBase.format()}) '
            'أقل من حد النصاب الشرعي المحدد بـ (${nisabThreshold.format()}) وفق ${policy.nameArabic}.';

      case ZakatResultStatus.notDueHawlIncomplete:
        return 'المال بلغ النصاب الشرعي (${netZakatableBase.format()} >= ${nisabThreshold.format()}) '
            'ولكن لم يكتمل الحول بعد (متبقي $daysRemaining يوماً على اكتمال الحول).';

      case ZakatResultStatus.insufficientData:
        return 'البيانات المالية أو أسعار السوق غير كافية أو غير صالحة لاحتساب النصاب والزكاة بدقة.';

      case ZakatResultStatus.policyRequired:
        return 'يرجى تحديد السياسة الفقهية المناسبة لاحتساب النصاب ومعالجة الديون.';

      case ZakatResultStatus.reviewRequired:
        return 'تتضمن الأصول حالات استثمارية مركبة يُستحب فيها الرجوع لعالم شرعي متخصص.';
    }
  }
}
