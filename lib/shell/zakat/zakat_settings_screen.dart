import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/currency_amount.dart';
import '../../../modules/zakat/domain/market_data_snapshot.dart';
import '../../../modules/zakat/domain/nisab_standard.dart';
import '../../../modules/zakat/domain/zakat_policy.dart';
import '../../../modules/zakat/domain/zakat_profile.dart';
import '../../../modules/zakat/zakat_module.dart';
import '../theme/app_colors.dart';
import 'currency_picker_bottom_sheet.dart';

/// Screen for configuring Zakat profile, currency, nisab method, gold/silver prices, and hawl date (§6, §37).
class ZakatSettingsScreen extends StatefulWidget {
  final ZakatModule module;

  const ZakatSettingsScreen({super.key, required this.module});

  @override
  State<ZakatSettingsScreen> createState() => _ZakatSettingsScreenState();
}

class _ZakatSettingsScreenState extends State<ZakatSettingsScreen> {
  ZakatProfile _profile = const ZakatProfile();
  bool _isLoading = true;

  final TextEditingController _goldPriceController = TextEditingController();
  final TextEditingController _silverPriceController = TextEditingController();
  final TextEditingController _manualNisabController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _goldPriceController.dispose();
    _silverPriceController.dispose();
    _manualNisabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await widget.module.getProfile();
    final snapshot = await widget.module.getMarketSnapshot();

    if (mounted) {
      setState(() {
        _profile = profile;
        _goldPriceController.text = snapshot.goldPricePerGram24k.toDouble().toStringAsFixed(0);
        _silverPriceController.text = snapshot.silverPricePerGram.toDouble().toStringAsFixed(0);
        if (profile.manualNisabValue != null) {
          _manualNisabController.text = profile.manualNisabValue!.toDouble().toStringAsFixed(0);
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final goldPriceDouble = double.tryParse(_goldPriceController.text.trim()) ?? _profile.goldPricePerGram.toDouble();
    final silverPriceDouble = double.tryParse(_silverPriceController.text.trim()) ?? _profile.silverPricePerGram.toDouble();

    CurrencyAmount? manualNisab;
    if (_profile.nisabStandard == NisabStandard.custom) {
      final manualVal = double.tryParse(_manualNisabController.text.trim());
      if (manualVal != null && manualVal > 0) {
        manualNisab = CurrencyAmount.fromDouble(manualVal, currency: _profile.currencyCode);
      }
    }

    final newProfile = _profile.copyWith(
      goldPricePerGram: CurrencyAmount.fromDouble(goldPriceDouble, currency: _profile.currencyCode),
      silverPricePerGram: CurrencyAmount.fromDouble(silverPriceDouble, currency: _profile.currencyCode),
      manualNisabValue: manualNisab,
    );

    // Save profile and update snapshot
    await widget.module.saveProfile(newProfile);
    await widget.module.setMarketSnapshot(
      MarketDataSnapshot(
        goldPricePerGram24k: newProfile.goldPricePerGram,
        silverPricePerGram: newProfile.silverPricePerGram,
        currency: newProfile.currencyCode,
        sourceName: 'سعر محلي مدخل من المزكي',
        timestamp: widget.module.clock.nowUtc(),
        isManualEntry: true,
      ),
    );

    if (mounted) {
      setState(() {
        _profile = newProfile;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ إعدادات الزكاة بنجاح'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _changeCurrency() async {
    final selected = await CurrencyPickerBottomSheet.show(
      context,
      selectedCurrencyCode: _profile.currencyCode,
    );

    if (selected != null && selected.code != _profile.currencyCode) {
      // Update currency
      final updated = _profile.copyWith(
        currencyCode: selected.code,
        goldPricePerGram: CurrencyAmount.fromDouble(
          _profile.goldPricePerGram.toDouble(),
          currency: selected.code,
        ),
        silverPricePerGram: CurrencyAmount.fromDouble(
          _profile.silverPricePerGram.toDouble(),
          currency: selected.code,
        ),
      );
      await widget.module.saveProfile(updated);
      _loadProfile();
    }
  }

  Future<void> _pickHawlDate() async {
    final initialDate = _profile.hawlStartDate ?? DateTime.now().subtract(const Duration(days: 354));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'اختر تاريخ بدء حول الزكاة',
      cancelText: 'إلغاء',
      confirmText: 'تعيين',
    );

    if (picked != null) {
      final updated = _profile.copyWith(hawlStartDate: picked);
      await widget.module.saveProfile(updated);
      setState(() {
        _profile = updated;
      });
    }
  }

  Future<void> _confirmResetAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة ضبط بيانات الزكاة'),
        content: const Text(
          'سيتم حذف كافة الأصول المالية المسجلة، وسجل العمليات، وإعادة العملة إلى الجنيه المصري (EGP). لن تتأثر أي بيانات أخرى في تطبيق سِراج.\n\nهل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('تأكيد إعادة الضبط'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.module.resetAllUserData();
      await _loadProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت إعادة ضبط بيانات الزكاة إلى الحالة الافتراضية (EGP)'),
            backgroundColor: Colors.red,
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
        title: const Text('إعدادات الزكاة والعملة'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Currency Section
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
                          children: [
                            const Icon(Icons.monetization_on_outlined, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'عملة الحساب والعرض',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        currency.nameArabic,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      if (currency.code == 'EGP') ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'الافتراضية',
                                            style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    '${currency.code} · ${currency.symbolArabic} · ${currency.nameEnglish}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              OutlinedButton.icon(
                                onPressed: _changeCurrency,
                                icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                                label: const Text('تغيير'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'الجنيه المصري (EGP) هو العملة الافتراضية المعتمدة لحساب الزكاة. تغيير العملة لا ينفذ أي تحويل وهمي للأرصدة.',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Nisab Method Section
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
                          children: [
                            const Icon(Icons.balance_rounded, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'طريقة ومعيار النصاب الشرعي',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        for (final standard in NisabStandard.values)
                          InkWell(
                            onTap: () {
                              String policyId = ZakatPolicy.goldStandardId;
                              if (standard == NisabStandard.silver595g) {
                                policyId = ZakatPolicy.silverStandardId;
                              } else if (standard == NisabStandard.custom) {
                                policyId = ZakatPolicy.manualStandardId;
                              }
                              setState(() {
                                _profile = _profile.copyWith(
                                  nisabStandard: standard,
                                  calculationPolicyId: policyId,
                                );
                              });
                              widget.module.saveProfile(_profile);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _profile.nisabStandard == standard
                                    ? AppColors.primary.withValues(alpha: 0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _profile.nisabStandard == standard
                                      ? AppColors.primary
                                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    _profile.nisabStandard == standard
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    color: _profile.nisabStandard == standard
                                        ? AppColors.primary
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          standard.labelShortArabic,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: _profile.nisabStandard == standard
                                                ? AppColors.primary
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          standard.descriptionArabic,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_profile.nisabStandard == NisabStandard.custom) ...[
                          const SizedBox(height: 8),
                          TextField(
                            controller: _manualNisabController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'قيمة النصاب النقدية اليدوية (${currency.symbolArabic})',
                              hintText: 'أدخل قيمة النصاب مباشرة',
                              border: const OutlineInputBorder(),
                              suffixText: currency.symbolArabic,
                            ),
                            onChanged: (_) => _saveChanges(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Gold and Silver Local Prices Section
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
                          children: [
                            const Icon(Icons.price_change_outlined, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'سعر الذهب والفضة المحلي (${currency.symbolArabic})',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _goldPriceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'ذهب عيار 24 / جرام',
                                  suffixText: currency.symbolArabic,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _silverPriceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'فضة نقية / جرام',
                                  suffixText: currency.symbolArabic,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'المزكي مسؤول عن مراجعة السعر المحلي.',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _saveChanges,
                              child: const Text('حفظ الأسعار'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Hawl and Calendar Section
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
                          children: [
                            const Icon(Icons.event_repeat_rounded, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'تاريخ الحول ونظام التقويم',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('تاريخ بدء الحول'),
                          subtitle: Text(
                            _profile.hawlStartDate != null
                                ? 'بدأ في: ${_profile.hawlStartDate!.year}/${_profile.hawlStartDate!.month}/${_profile.hawlStartDate!.day}'
                                : 'لم يتم تحديد تاريخ الحول بعد (يُحسب افتراضياً سنة كاملة)',
                          ),
                          trailing: OutlinedButton(
                            onPressed: _pickHawlDate,
                            child: Text(_profile.hawlStartDate == null ? 'تحديد' : 'تعديل'),
                          ),
                        ),
                        const Divider(),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('اعتماد الحول القمري الهجري (2.5%)'),
                          subtitle: Text(
                            _profile.isHijriCalendar
                                ? 'السنة الهجرية 354 يوماً بنسبة الزكاة الشرعية 2.5%.'
                                : 'السنة الميلادية 365 يوماً بنسبة الزكاة المعدلة 2.577% لمراعاة فارق الأيام الـ 11.',
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: _profile.isHijriCalendar,
                          onChanged: (val) {
                            setState(() {
                              _profile = _profile.copyWith(isHijriCalendar: val);
                            });
                            widget.module.saveProfile(_profile);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Privacy & Offline Disclosure
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  color: (isDark ? Colors.blueGrey.shade900 : Colors.blue.shade50).withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'الخصوصية والأمان المالي (100% Offline)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'كافة بياناتك وأصولك وحساباتك المالية تُحفظ محلياً على جهازك فقط بصيغة مشفرة ومعزولة. لا يتم إرسال أي أرقام أو أصول إلى أي خوادم سحابية (Zero Telemetry)، ولا يحتوي التطبيق على أي تتبع مالي.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 6. Reset Data Button
                Center(
                  child: TextButton.icon(
                    onPressed: _confirmResetAll,
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                    label: const Text(
                      'إعادة ضبط كافة بيانات الزكاة',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
