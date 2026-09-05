import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/asset_category.dart';
import '../../../modules/zakat/domain/zakat_asset.dart';
import '../../../modules/zakat/domain/zakat_calculation_result.dart';
import '../../../modules/zakat/domain/zakat_currency.dart';
import '../../../modules/zakat/domain/zakat_policy.dart';
import '../../../modules/zakat/domain/zakat_profile.dart';
import '../../../modules/zakat/zakat_module.dart';
import '../theme/app_colors.dart';
import 'asset_entry_screen.dart';
import 'zakat_settings_screen.dart';

/// 4-Step Guided Zakat Calculation Workflow (§3, §37).
class ZakatCalculatorWorkflowScreen extends StatefulWidget {
  final ZakatModule module;

  const ZakatCalculatorWorkflowScreen({super.key, required this.module});

  @override
  State<ZakatCalculatorWorkflowScreen> createState() => _ZakatCalculatorWorkflowScreenState();
}

class _ZakatCalculatorWorkflowScreenState extends State<ZakatCalculatorWorkflowScreen> {
  int _currentStep = 0;
  List<ZakatAsset> _assets = [];
  ZakatProfile _profile = const ZakatProfile();
  ZakatPolicy _policy = ZakatPolicy.goldStandard;
  ZakatCalculationResult? _result;
  bool _isLoading = true;
  bool _isSavingSnapshot = false;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final assetsRes = await widget.module.getAssets();
    final profile = await widget.module.getProfile();
    final policy = await widget.module.getActivePolicy();
    final calcRes = await widget.module.calculateZakat();

    if (mounted) {
      setState(() {
        _assets = assetsRes.valueOrNull ?? [];
        _profile = profile;
        _policy = policy;
        _result = calcRes.valueOrNull;
        _isLoading = false;
      });
    }
  }

  Future<void> _openAssetEntry([ZakatAsset? assetToEdit, AssetCategory? defaultCategory]) async {
    final res = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AssetEntryScreen(
          module: widget.module,
          assetToEdit: assetToEdit,
          preselectedCategory: defaultCategory,
        ),
      ),
    );
    if (res == true) {
      _loadAllData();
    }
  }

  Future<void> _deleteAsset(String id) async {
    await widget.module.deleteAsset(id);
    _loadAllData();
  }

  Future<void> _saveToHistory() async {
    if (_result == null || _isSavingSnapshot) return;
    setState(() {
      _isSavingSnapshot = true;
    });

    final res = await widget.module.saveSnapshot(_result!);
    if (mounted) {
      setState(() {
        _isSavingSnapshot = false;
      });
      if (res.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ عملية الحساب في سجل الزكاة بنجاح 🤲'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currency = _profile.currency;

    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة الزكاة المنظمة'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top Step Progress Indicator Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
                  ),
                  child: Row(
                    children: [
                      _buildStepTab(0, 'الملف', Icons.person_outline),
                      _buildStepDivider(0),
                      _buildStepTab(1, 'الأصول', Icons.account_balance_wallet_outlined),
                      _buildStepDivider(1),
                      _buildStepTab(2, 'الالتزامات', Icons.money_off_outlined),
                      _buildStepDivider(2),
                      _buildStepTab(3, 'النتيجة', Icons.assessment_outlined),
                    ],
                  ),
                ),

                // Step Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_currentStep == 0) _buildStepProfile(isDark, currency),
                      if (_currentStep == 1) _buildStepAssets(isDark, currency),
                      if (_currentStep == 2) _buildStepLiabilities(isDark, currency),
                      if (_currentStep == 3) _buildStepSummary(isDark, currency),

                      // Navigation buttons
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                if (_currentStep < 3) {
                                  setState(() => _currentStep++);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: isDark ? AppColors.goldAccent : AppColors.primary,
                                foregroundColor: isDark ? Colors.black : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(_currentStep == 3 ? 'إنهاء والعودة' : 'المتابعة للخطوة التالية'),
                            ),
                          ),
                          if (_currentStep > 0) ...[
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () => setState(() => _currentStep--),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              ),
                              child: const Text('السابق'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepTab(int stepIndex, String title, IconData icon) {
    final isActive = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;
    final color = isActive
        ? AppColors.primary
        : (isDone ? Colors.green : Colors.grey);

    return InkWell(
      onTap: () => setState(() => _currentStep = stepIndex),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                isDone ? Icons.check : icon,
                size: 13,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepDivider(int afterIndex) {
    final isDone = _currentStep > afterIndex;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: isDone ? Colors.green : Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }

  // --- Step 0: Profile View ---
  Widget _buildStepProfile(bool isDark, ZakatCurrency currency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('معايير الحساب الحالية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton.icon(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ZakatSettingsScreen(module: widget.module)),
                        );
                        _loadAllData();
                      },
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('تعديل'),
                    ),
                  ],
                ),
                const Divider(),
                _buildProfileRow('العملة المعتمدة:', '${currency.nameArabic} (${currency.symbolArabic})'),
                _buildProfileRow('معيار النصاب:', _profile.nisabStandard.labelShortArabic),
                _buildProfileRow('سعر جرام الذهب (24K):', '${_profile.goldPricePerGram.formatLocal()} / جرام'),
                _buildProfileRow('سعر جرام الفضة:', '${_profile.silverPricePerGram.formatLocal()} / جرام'),
                _buildProfileRow(
                  'تاريخ الحول:',
                  _profile.hawlStartDate != null
                      ? '${_profile.hawlStartDate!.year}/${_profile.hawlStartDate!.month}/${_profile.hawlStartDate!.day}'
                      : 'سنة كاملة (مستوفى)',
                ),
                _buildProfileRow('نوع التقويم:', _profile.isHijriCalendar ? 'قمري هجري (2.5%)' : 'شمسي ميلادي (2.577%)'),
                _buildProfileRow('السياسة المعتمدة:', _policy.nameArabic),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 1: Assets List ---
  Widget _buildStepAssets(bool isDark, ZakatCurrency currency) {
    final assetItems = _assets.where((a) => !a.category.isLiability && !a.isDeductibleDebt).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الأصول المسجلة (${assetItems.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            FilledButton.tonalIcon(
              onPressed: () => _openAssetEntry(null, AssetCategory.cash),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('إضافة أصل'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (assetItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('لم يتم إدخال أي أصول مالية بعد. اضغط على "إضافة أصل" لإدخال أموالك.'),
            ),
          )
        else
          for (final asset in assetItems)
            _buildAssetCard(asset, isDark),
      ],
    );
  }

  // --- Step 2: Liabilities List ---
  Widget _buildStepLiabilities(bool isDark, ZakatCurrency currency) {
    final liabilityItems = _assets.where((a) => a.category.isLiability || a.isDeductibleDebt).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الالتزامات والديون (${liabilityItems.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            FilledButton.tonalIcon(
              onPressed: () => _openAssetEntry(null, AssetCategory.debts),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('إضافة التزام'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: const Text(
            'تنبيه فقهي: تُخصم الديون والالتزامات الحالة العاجلة الواجبة السداد قبل نهاية الحول. أما الديون المؤجلة أو طويلة الأجل فمحل خلاف وتفصيل عند الفقهاء.',
            style: TextStyle(fontSize: 11, height: 1.5),
          ),
        ),
        const SizedBox(height: 12),
        if (liabilityItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('لا توجد التزامات أو ديون مسجلة للخصم.'),
            ),
          )
        else
          for (final debt in liabilityItems)
            _buildAssetCard(debt, isDark),
      ],
    );
  }

  Widget _buildAssetCard(ZakatAsset asset, bool isDark) {
    final isLiability = asset.category.isLiability || asset.isDeductibleDebt;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: ListTile(
        title: Text(asset.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          asset.category == AssetCategory.gold && asset.weightGrams != null
              ? '${asset.category.labelArabic} · ${asset.weightGrams} جرام (عيار ${asset.purityKarat ?? 24}K)'
              : asset.category.labelArabic,
          style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              asset.amount.formatLocal(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isLiability ? Colors.red : null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              onPressed: () => _deleteAsset(asset.id),
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 3: Calculation Summary ---
  Widget _buildStepSummary(bool isDark, ZakatCurrency currency) {
    if (_result == null) return const SizedBox.shrink();
    final res = _result!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Breakdown Numbers Card
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSummaryLine('إجمالي الأصول الزكوية', '+ ${res.grossAssets.formatLocal()}', Colors.blue),
                const SizedBox(height: 8),
                _buildSummaryLine('الالتزامات المخصومة', '- ${res.deductibleLiabilities.formatLocal()}', Colors.red),
                const Divider(height: 24),
                _buildSummaryLine('صافي الوعاء الزكوي', '= ${res.netZakatableBase.formatLocal()}', null, isBold: true),
                const SizedBox(height: 8),
                _buildSummaryLine('حد النصاب الشرعي', '= ${res.nisabThreshold.formatLocal()}', Colors.amber),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('حالة النصاب:', style: TextStyle(fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (res.reachesNisab ? Colors.green : Colors.grey).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        res.reachesNisab ? '✓ بلغ النصاب الشرعي' : 'دون النصاب الشرعي',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: res.reachesNisab ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSummaryLine('نسبة الزكاة الواجبة', '${(res.appliedRate * 100).toStringAsFixed(2)}%', null),
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (res.isDue ? Colors.green : AppColors.primary).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'الزكاة التقديرية الواجبة:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            res.zakatDue.formatLocal(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.5,
                              color: res.isDue ? Colors.green : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Action: Save to History
        FilledButton.icon(
          onPressed: _saveToHistory,
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text('حفظ هذه العملية في سجل الزكاة'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 12),

        // Shariah Safety Disclaimer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: const Text(
            'تنبيه: هذه الحاسبة أداة مساعدة تعليمية وحسابية وليست فتوى شرعية ملزمة. تختلف بعض أحكام الأموال باختلاف الظروف والمذاهب المعتبرة.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryLine(String label, String value, Color? color, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
