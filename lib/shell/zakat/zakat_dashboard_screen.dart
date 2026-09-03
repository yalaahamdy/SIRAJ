import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/zakat_asset.dart';
import '../../../modules/zakat/domain/zakat_calculation_result.dart';
import '../../../modules/zakat/domain/zakat_guide_topic.dart';
import '../../../modules/zakat/domain/zakat_policy.dart';
import '../../../modules/zakat/zakat_module.dart';
import '../theme/app_colors.dart';
import 'asset_entry_screen.dart';
import 'widgets/asset_tile.dart';
import 'widgets/zakat_hero_summary_card.dart';
import 'zakat_breakdown_screen.dart';
import 'zakat_guide_detail_screen.dart';
import 'zakat_policy_screen.dart';

/// Main Dashboard Screen for Zakat Calculation & Asset Management (§3, §37).
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
  bool _isHijri = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final assetsRes = await widget.module.getAssets();
    final policy = await widget.module.getActivePolicy();
    final calcRes = await widget.module.calculateZakat(isHijriCalendar: _isHijri);

    if (mounted) {
      setState(() {
        _assets = assetsRes.valueOrNull ?? [];
        _activePolicy = policy;
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
        title: const Text('حذف الأصل المالي'),
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

  Future<void> _confirmResetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة ضبط بيانات الزكاة'),
        content: const Text(
          'سيتم حذف بيانات الزكاة والأصول المحفوظة فقط. لن تتأثر أي بيانات أخرى في التطبيق. هل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('إعادة الضبط', style: TextStyle(color: Colors.white)),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حساب الزكاة الشرعية',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'السياسات الفقهية',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ZakatPolicyScreen(module: widget.module)),
              );
              _loadData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة ضبط بيانات الزكاة',
            onPressed: _confirmResetData,
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

                // 2. Calendar Toggle & Active Policy Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Active Policy Badge
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ZakatPolicyScreen(module: widget.module)),
                            );
                            _loadData();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_outlined, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    _activePolicy?.nisabStandard.labelArabic ?? 'سياسة الذهب',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Hijri / Gregorian Switch
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                _isHijri ? 'سنة هجرية (2.5%)' : 'سنة ميلادية (2.577%)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Switch(
                              value: _isHijri,
                              onChanged: (val) {
                                setState(() => _isHijri = val);
                                _loadData();
                              },
                              activeThumbColor: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Section Header: Assets
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'الأصول والالتزامات المالية',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('إضافة أصل'),
                        onPressed: () => _openAssetEntry(),
                      ),
                    ],
                  ),
                ),

                // 4. Asset List or Empty State
                if (_assets.isEmpty) ...[
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 48,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لم تقم بإضافة أي أصول مالية بعد',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _openAssetEntry(),
                          icon: const Icon(Icons.add),
                          label: const Text('أضف أموالك أو مدخراتك للبدء'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ..._assets.map(
                    (asset) => AssetTile(
                      asset: asset,
                      onEdit: () => _openAssetEntry(asset),
                      onDelete: () => _confirmDeleteAsset(asset),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // 5. Educational Guide & Calculation Examples Section (§12)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.school_rounded, size: 20, color: AppColors.primaryAction(context)),
                      const SizedBox(width: 8),
                      const Text(
                        'دليل فقه الزكاة والأمثلة التطبيقية',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...ZakatGuideData.topics.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade50,
                        child: Icon(Icons.calculate_rounded, color: AppColors.primaryAction(context), size: 20),
                      ),
                      title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(t.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.chevron_left, size: 20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ZakatGuideDetailScreen(topic: t)),
                        );
                      },
                    ),
                  ),
                )),

                const SizedBox(height: 24),

                // 6. Local Privacy Notice Card (§89, §90)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_outline, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'بيانات الزكاة والأصول المالية خاصة بك بأعلى درجات الأمان والخصوصية التامة.',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: _assets.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => _openAssetEntry(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
