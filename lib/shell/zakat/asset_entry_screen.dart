import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/asset_category.dart';
import '../../../modules/zakat/domain/currency_amount.dart';
import '../../../modules/zakat/domain/zakat_asset.dart';
import '../../../modules/zakat/domain/zakat_profile.dart';
import '../../../modules/zakat/zakat_module.dart';

/// Screen for adding or editing a financial asset or liability (§16, §37).
class AssetEntryScreen extends StatefulWidget {
  final ZakatModule module;
  final ZakatAsset? assetToEdit;
  final AssetCategory? preselectedCategory;

  const AssetEntryScreen({
    super.key,
    required this.module,
    this.assetToEdit,
    this.preselectedCategory,
  });

  @override
  State<AssetEntryScreen> createState() => _AssetEntryScreenState();
}

class _AssetEntryScreenState extends State<AssetEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  late String _title;
  late AssetCategory _category;
  late double _amount;
  double? _weightGrams;
  int? _purityKarat;
  late DateTime _acquisitionDate;
  late bool _isDeductibleDebt;
  ZakatProfile _profile = const ZakatProfile();

  @override
  void initState() {
    super.initState();
    final asset = widget.assetToEdit;
    if (asset != null) {
      _title = asset.title;
      _category = asset.category;
      _amount = asset.amount.toDouble();
      _weightGrams = asset.weightGrams;
      _purityKarat = asset.purityKarat;
      _acquisitionDate = asset.acquisitionDate;
      _isDeductibleDebt = asset.isDeductibleDebt;
      _amountController.text = _amount > 0 ? _amount.toStringAsFixed(2) : '';
      if (_weightGrams != null) {
        _weightController.text = _weightGrams.toString();
      }
    } else {
      _title = '';
      _category = widget.preselectedCategory ?? AssetCategory.cash;
      _amount = 0.0;
      _acquisitionDate = DateTime.now();
      _isDeductibleDebt = _category == AssetCategory.debts;
      _purityKarat = 24;
    }

    _loadProfile();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await widget.module.getProfile();
    if (mounted) {
      setState(() {
        _profile = profile;
      });
    }
  }

  void _onWeightOrKaratChanged() {
    final weight = double.tryParse(_weightController.text.trim());
    if (weight == null || weight <= 0) return;

    if (_category == AssetCategory.gold) {
      final karat = _purityKarat ?? 24;
      final pricePerGram24k = _profile.goldPricePerGram.toDouble();
      final karatRatio = karat / 24.0;
      final estimatedValue = weight * pricePerGram24k * karatRatio;
      _amountController.text = estimatedValue.toStringAsFixed(2);
      _amount = estimatedValue;
    } else if (_category == AssetCategory.silver) {
      final pricePerGram = _profile.silverPricePerGram.toDouble();
      final estimatedValue = weight * pricePerGram;
      _amountController.text = estimatedValue.toStringAsFixed(2);
      _amount = estimatedValue;
    }
  }

  Future<void> _saveAsset() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final parsedAmount = double.tryParse(_amountController.text.trim()) ?? _amount;
    final id = widget.assetToEdit?.id ?? 'asset_${DateTime.now().millisecondsSinceEpoch}';
    final asset = ZakatAsset(
      id: id,
      title: _title.trim().isEmpty ? _category.labelArabic : _title.trim(),
      category: _category,
      amount: CurrencyAmount.fromDouble(parsedAmount, currency: _profile.currencyCode),
      weightGrams: _weightGrams,
      purityKarat: _purityKarat,
      acquisitionDate: _acquisitionDate,
      isDeductibleDebt: _category == AssetCategory.debts || _isDeductibleDebt,
    );

    await widget.module.addOrUpdateAsset(asset);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.assetToEdit != null;
    final currency = _profile.currency;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'تعديل أصل زكوي' : 'إضافة أصل زكوي',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Asset Title
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(
                labelText: 'اسم الأصل أو الحساب (اختياري)',
                hintText: 'مثال: حساب جاري، مدخرات الذهب، بضاعة المتجر',
                border: OutlineInputBorder(),
              ),
              onSaved: (v) => _title = v ?? '',
            ),
            const SizedBox(height: 16),

            // 2. Asset Category Dropdown
            DropdownButtonFormField<AssetCategory>(
              initialValue: _category,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'فئة الأصل المالي أو الالتزام',
                border: OutlineInputBorder(),
              ),
              items: AssetCategory.values.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(c.labelArabic, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _category = v;
                    _isDeductibleDebt = v == AssetCategory.debts;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Category description notice
            Text(
              _category.descriptionArabic,
              style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 16),

            // 3. Gold / Silver specific fields
            if (_category == AssetCategory.gold) ...[
              DropdownButtonFormField<int>(
                initialValue: _purityKarat ?? 24,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'عيار الذهب',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 24, child: Text('عيار 24 (ذهب نقي 100%)', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 22, child: Text('عيار 22', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 21, child: Text('عيار 21 (الأكثر شيوعاً)', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 18, child: Text('عيار 18', overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (v) {
                  setState(() => _purityKarat = v);
                  _onWeightOrKaratChanged();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'وزن الذهب بالجرام',
                  hintText: 'مثال: 85',
                  suffixText: 'جرام',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _onWeightOrKaratChanged(),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty) {
                    final w = double.tryParse(v);
                    if (w == null || w <= 0) return 'يرجى إدخال وزن موجب صحيح بالجرام';
                  }
                  return null;
                },
                onSaved: (v) => _weightGrams = (v != null && v.isNotEmpty) ? double.tryParse(v) : null,
              ),
              const SizedBox(height: 16),
            ],

            if (_category == AssetCategory.silver) ...[
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'وزن الفضة بالجرام',
                  hintText: 'مثال: 595',
                  suffixText: 'جرام',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _onWeightOrKaratChanged(),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty) {
                    final w = double.tryParse(v);
                    if (w == null || w <= 0) return 'يرجى إدخال وزن موجب صحيح بالجرام';
                  }
                  return null;
                },
                onSaved: (v) => _weightGrams = (v != null && v.isNotEmpty) ? double.tryParse(v) : null,
              ),
              const SizedBox(height: 16),
            ],

            // 4. Amount Field in Active Profile Currency
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'القيمة الإجمالية بالعملة (${currency.nameArabic})',
                suffixText: currency.symbolArabic,
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'يرجى إدخال القيمة';
                final numVal = double.tryParse(v);
                if (numVal == null || numVal < 0 || numVal.isNaN || numVal.isInfinite) {
                  return 'يرجى إدخال قيمة مالية موجبة وصحيحة';
                }
                return null;
              },
              onSaved: (v) => _amount = double.tryParse(v ?? '0') ?? 0.0,
            ),
            const SizedBox(height: 16),

            // 5. Date of Acquisition
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('تاريخ بدء التملك / الحول'),
              subtitle: Text(
                '${_acquisitionDate.year}-${_acquisitionDate.month.toString().padLeft(2, '0')}-${_acquisitionDate.day.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today_rounded),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _acquisitionDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _acquisitionDate = picked);
                }
              },
            ),
            const SizedBox(height: 24),

            // 6. Submit Button
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveAsset,
              child: Text(isEditing ? 'حفظ التعديلات' : 'إضافة إلى الحساب'),
            ),
          ],
        ),
      ),
    );
  }
}
