import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/hajj_user_progress.dart';
import '../../../modules/hajj/domain/preparation_item.dart';
import '../../../modules/hajj/hajj_module.dart';

/// Preparation Checklist Screen (§9..§13, §98, §107).
class PreparationChecklistScreen extends StatefulWidget {
  final HajjModule module;

  const PreparationChecklistScreen({super.key, required this.module});

  @override
  State<PreparationChecklistScreen> createState() => _PreparationChecklistScreenState();
}

class _PreparationChecklistScreenState extends State<PreparationChecklistScreen> {
  HajjUserProgress _progress = const HajjUserProgress();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final res = await widget.module.getUserProgress();
    if (mounted) {
      setState(() {
        if (res.isSuccess) _progress = res.valueOrNull!;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleItem(String itemId) async {
    await widget.module.togglePreparationItem(itemId);
    await _loadProgress();
  }

  Future<void> _confirmResetChecklist() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة ضبط قائمة التجهيز'),
        content: const Text('هل تريد إلغاء تحديد كافة عناصر قائمة الاستعداد والتجهيز؟'),
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
      final updated = _progress.copyWith(checkedPreparationItemIds: const {});
      await widget.module.userDataStore.saveProgress(updated);
      await _loadProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final itemsRes = widget.module.getPreparationItems();
    final items = itemsRes.isSuccess ? itemsRes.valueOrNull! : <PreparationItem>[];
    final categories = PreparationCategory.values;

    final checkedCount = _progress.checkedPreparationItemIds.length;
    final totalCount = items.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حقيبة واستعداد الحاج والمعتمر',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة ضبط القائمة',
            onPressed: _confirmResetChecklist,
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('لا توجد بنود في قائمة الاستعداد.'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Summary Progress Card
                Card(
                  color: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'عناصر التجهيز المكتملة:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$checkedCount من $totalCount بند',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ...categories.map((cat) {
                  final catItems = items.where((i) => i.category == cat).toList();
                  if (catItems.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Text(
                          cat.labelArabic,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: catItems.map((item) {
                            final isChecked = _progress.checkedPreparationItemIds.contains(item.itemId);
                            return ListTile(
                              onTap: () => _toggleItem(item.itemId),
                              leading: Checkbox(
                                value: isChecked,
                                onChanged: (_) => _toggleItem(item.itemId),
                                activeColor: Colors.teal,
                              ),
                              title: Text(
                                item.titleArabic,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Text(item.description, style: const TextStyle(fontSize: 12)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ],
            ),
    );
  }
}
