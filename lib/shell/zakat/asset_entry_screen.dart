import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/asset_category.dart';
import '../../../modules/zakat/domain/currency_amount.dart';
import '../../../modules/zakat/domain/zakat_asset.dart';
import '../../../modules/zakat/zakat_module.dart';

/// Screen for adding or editing a financial asset or liability (§16, §37).
class AssetEntryScreen extends StatefulWidget {
  final ZakatModule module;
  final ZakatAsset? assetToEdit;

  const AssetEntryScreen({
    super.key,
    required this.module,
    this.assetToEdit,
  });

  @override
  State<AssetEntryScreen> createState() => _AssetEntryScreenState();
}

class _AssetEntryScreenState extends State<AssetEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late AssetCategory _category;
  late double _amount;
  double? _weightGrams;
  int? _purityKarat;
  late DateTime _acquisitionDate;
  late bool _isDeductibleDebt;

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
    } else {
      _title = '';
      _category = AssetCategory.cash;
      _amount = 0.0;
      _acquisitionDate = DateTime.now();
      _isDeductibleDebt = false;
    }
  }

  Future<void> _saveAsset() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final id = widget.assetToEdit?.id ?? 'asset_${DateTime.now().millisecondsSinceEpoch}';
    final asset = ZakatAsset(
      id: id,
      title: _title.trim().isEmpty ? _category.labelArabic : _title.trim(),
      category: _category,
      amount: CurrencyAmount.fromDouble(_amount, currency: 'SAR'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'تعديل أصل مالي' : 'إضافة أصل مالي',
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
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
                hintText: 'مثال: حساب بنكي جاري، مدخرات الذهب، بضاعة المتجر',
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
                labelText: 'فئة الأصل المالي',
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
                  setState(() => _category = v);
                }
              },
            ),
            const SizedBox(height: 16),

            // 3. Amount Field
            TextFormField(
              initialValue: _amount > 0 ? _amount.toStringAsFixed(2) : '',
              decoration: const InputDecoration(
                labelText: 'القيمة النقدية (بالريال السعودي)',
                border: OutlineInputBorder(),
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
              onSaved: (v) => _amount = double.parse(v!),
            ),
            const SizedBox(height: 16),

            // 4. Gold / Silver specific fields
            if (_category == AssetCategory.gold) ...[
              TextFormField(
                initialValue: _weightGrams?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'وزن الذهب بالجرام (اختياري للتقويم التلقائي)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              DropdownButtonFormField<int>(
                initialValue: _purityKarat ?? 24,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'عيار الذهب',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 24, child: Text('عيار 24 (ذهب خالص)', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 22, child: Text('عيار 22', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 21, child: Text('عيار 21', overflow: TextOverflow.ellipsis)),
                  DropdownMenuItem(value: 18, child: Text('عيار 18', overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (v) => setState(() => _purityKarat = v),
              ),
              const SizedBox(height: 16),
            ],

            if (_category == AssetCategory.silver) ...[
              TextFormField(
                initialValue: _weightGrams?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'وزن الفضة بالجرام',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

            // 5. Date of Acquisition
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('تاريخ بدء الحول / التملك'),
              subtitle: Text(
                '${_acquisitionDate.year}-${_acquisitionDate.month.toString().padLeft(2, '0')}-${_acquisitionDate.day.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _saveAsset,
              child: Text(isEditing ? 'حفظ التعديلات' : 'إضافة الأصل'),
            ),
          ],
        ),
      ),
    );
  }
}
