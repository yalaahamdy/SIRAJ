import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/asset_category.dart';
import '../../../modules/zakat/domain/currency_amount.dart';
import '../../../modules/zakat/domain/zakat_asset.dart';
import '../../../modules/zakat/domain/zakat_calculation_result.dart';
import '../../../modules/zakat/domain/zakat_policy.dart';
import '../../../modules/zakat/domain/zakat_profile.dart';
import '../../../modules/zakat/zakat_module.dart';
import '../theme/app_colors.dart';
import 'asset_entry_screen.dart';
import 'widgets/asset_tile.dart';
import 'widgets/zakat_hero_summary_card.dart';
import 'zakat_breakdown_screen.dart';
import 'zakat_calculator_workflow_screen.dart';
import 'zakat_history_screen.dart';
import 'zakat_settings_screen.dart';

/// Professional Executive Dashboard for Zakat Evaluation (§3, §7, §37).
class ZakatDashboardScreen extends StatefulWidget {
  final ZakatModule module;

  const ZakatDashboardScreen({super.key, required this.module});

  @override
  State<ZakatDashboardScreen> createState() => _ZakatDashboardScreenState();
}

class _ZakatDashboardScreenState extends State<ZakatDashboardScreen> {
  List<ZakatAsset> _assets = [];
  ZakatCalculationResult? _result;
  ZakatPolicy? _activePolicy;
  ZakatProfile _profile = const ZakatProfile();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final assetsRes = await widget.module.getAssets();
    final policy = await widget.module.getActivePolicy();
    final profile = await widget.module.getProfile();
    final calcRes = await widget.module.calculateZakat();

    if (mounted) {
      setState(() {
        _assets = assetsRes.valueOrNull ?? [];
        _activePolicy = policy;
        _profile = profile;
        _result = calcRes.valueOrNull;
        _isLoading = false;
      });
    }
  }

  Future<void> _openAssetEntry([ZakatAsset? asset]) async {
    final res = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AssetEntryScreen(module: widget.module, assetToEdit: asset),
      ),
    );
    if (res == true) {
      _loadData();
    }
  }

  Future<void> _confirmDeleteAsset(ZakatAsset asset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف البند المالي'),
        content: Text('هل أنت متأكد من حذف "${asset.title}" من حساب الزكاة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.module.deleteAsset(asset.id);
      _loadData();
    }
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة ضبط بيانات الزكاة'),
        content: const Text('سيتم حذف بيانات الزكاة والأصول المحفوظة فقط مع الحفاظ على باقي بيانات التطبيق.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('إعادة الضبط'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.module.resetAllUserData();
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currency = _profile.currency;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'زكاتي',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    currency.code == 'EGP' ? 'الجنيه المصري (ج.م)' : currency.nameArabic,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const Text(
              'حساب الزكاة الشرعية',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة ضبط بيانات الزكاة',
            onPressed: _confirmReset,
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'سجل العمليات السابقة',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ZakatHistoryScreen(module: widget.module)),
              );
              _loadData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'إعدادات الزكاة والعملة',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ZakatSettingsScreen(module: widget.module)),
              );
              _loadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // 1. Hero Summary Card
                if (_result != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ZakatHeroSummaryCard(
                      result: _result!,
                      onExplain: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ZakatBreakdownScreen(
                              result: _result!,
                              module: widget.module,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 2. Action Cards Row (Calculator, Settings, History)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          context,
                          icon: Icons.calculate_outlined,
                          title: 'حاسبة الزكاة',
                          subtitle: 'خطوات منظمة',
                          color: isDark ? AppColors.goldAccent : AppColors.primary,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ZakatCalculatorWorkflowScreen(module: widget.module),
                              ),
                            );
                            _loadData();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          icon: Icons.tune_rounded,
                          title: 'إعدادات النصاب',
                          subtitle: _activePolicy?.nisabStandard.labelShortArabic ?? _profile.nisabStandard.labelShortArabic,
                          color: Colors.teal,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ZakatSettingsScreen(module: widget.module),
                              ),
                            );
                            _loadData();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          icon: Icons.history_edu_rounded,
                          title: 'السجل',
                          subtitle: 'السنوات السابقة',
                          color: Colors.indigo,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ZakatHistoryScreen(module: widget.module),
                              ),
                            );
                            _loadData();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Calendar Switch Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _profile.isHijriCalendar ? 'سنة هجرية (2.5%)' : 'سنة ميلادية (2.577%)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Switch(
                          value: !_profile.isHijriCalendar,
                          onChanged: (isGregorian) async {
                            final updated = _profile.copyWith(isHijriCalendar: !isGregorian);
                            setState(() => _profile = updated);
                            await widget.module.saveProfile(updated);
                            _loadData();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Detailed Assets Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الأصول والالتزامات المسجلة (${_assets.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () => _openAssetEntry(),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('إضافة أصل', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 5. Assets List
                if (_assets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.savings_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'لم تقم بإضافة أي أصول مالية بعد',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'أضف أموالك أو مدخراتك للبدء',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._assets.map(
                    (asset) => AssetTile(
                      asset: asset,
                      onEdit: () => _openAssetEntry(asset),
                      onDelete: () => _confirmDeleteAsset(asset),
                    ),
                  ),

                const SizedBox(height: 20),

                // 6. Category Wealth Breakdown Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تقسيم الثروة والأموال',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'الإجمالي: ${_result?.grossAssets.formatLocal() ?? '0.00'}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildCategoryGrid(isDark),

                const SizedBox(height: 24),

                // 6. Fiqh Safety Notice Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.verified_user_outlined, size: 16, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'أمان فقهي وخصوصية محلية',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تعتمد هذه الحاسبة القواعد الحسابية الفقهية المعتمدة لدى مجمع الفقه الإسلامي الدولي. الحساب استرشادي تقريبي ولا يغني عن مراجعة أهل العلم عند المسائل المركبة. كافة البيانات محفوظة محلياً على جهازك 100%.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? Colors.white : Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : Colors.black54),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDark) {
    int cashUnits = 0;
    int goldUnits = 0;
    int silverUnits = 0;
    int tradeUnits = 0;
    int investUnits = 0;
    int debtUnits = 0;

    for (final a in _assets) {
      final val = _result?.itemizedAssetValues[a.id]?.units ?? a.amount.units;
      switch (a.category) {
        case AssetCategory.cash:
        case AssetCategory.receivables:
          cashUnits += val;
          break;
        case AssetCategory.gold:
          goldUnits += val;
          break;
        case AssetCategory.silver:
          silverUnits += val;
          break;
        case AssetCategory.tradeGoods:
          tradeUnits += val;
          break;
        case AssetCategory.investments:
          investUnits += val;
          break;
        case AssetCategory.debts:
          debtUnits += val;
          break;
        case AssetCategory.other:
          cashUnits += val;
          break;
      }
    }

    final currency = _profile.currencyCode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCategoryMiniCard(
                  'النقد والسيولة',
                  CurrencyAmount(units: cashUnits, currency: currency).formatLocal(),
                  Icons.account_balance_wallet_outlined,
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCategoryMiniCard(
                  'الذهب والفضة',
                  CurrencyAmount(units: goldUnits + silverUnits, currency: currency).formatLocal(),
                  Icons.diamond_outlined,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCategoryMiniCard(
                  'التجارة والاستثمار',
                  CurrencyAmount(units: tradeUnits + investUnits, currency: currency).formatLocal(),
                  Icons.storefront_outlined,
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCategoryMiniCard(
                  'الديون الحالة',
                  CurrencyAmount(units: debtUnits, currency: currency).formatLocal(),
                  Icons.money_off_csred_outlined,
                  isDark,
                  isDebt: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryMiniCard(String title, String amount, IconData icon, bool isDark, {bool isDebt = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDebt
                ? Colors.red.withValues(alpha: 0.15)
                : AppColors.primary.withValues(alpha: 0.15),
            child: Icon(
              icon,
              size: 16,
              color: isDebt ? Colors.red : (isDark ? AppColors.goldAccent : AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(
                  amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isDebt ? Colors.red : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
