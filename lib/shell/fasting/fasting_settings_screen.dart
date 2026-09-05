import 'package:flutter/material.dart';
import '../../../modules/fasting/domain/fasting_policy.dart';
import '../../../modules/fasting/fasting_module.dart';

/// Screen for configuring fasting policies, calendar adjustments, and historical snapshots (§40).
class FastingSettingsScreen extends StatefulWidget {
  final FastingModule module;

  const FastingSettingsScreen({
    super.key,
    required this.module,
  });

  @override
  State<FastingSettingsScreen> createState() => _FastingSettingsScreenState();
}

class _FastingSettingsScreenState extends State<FastingSettingsScreen> {
  FastingPolicy _currentPolicy = FastingPolicy.standard;
  int _calendarOffset = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final policy = await widget.module.getActivePolicy();
    final offsetRes = await widget.module.userDataStore.getCalendarOffsetDays();
    if (mounted) {
      setState(() {
        _currentPolicy = policy;
        _calendarOffset = offsetRes.valueOrNull ?? 0;
        _isLoading = false;
      });
    }
  }

  Future<void> _savePolicy(String policyId) async {
    await widget.module.setActivePolicy(policyId);
    await _loadSettings();
  }

  Future<void> _saveCalendarOffset(int offset) async {
    await widget.module.userDataStore.setCalendarOffsetDays(offset);
    setState(() => _calendarOffset = offset);
  }

  Future<void> _createSnapshot() async {
    final snapRes = await widget.module.saveSnapshot();
    if (mounted) {
      if (snapRes.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ لقطة التدقيق بنجاح')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('إعدادات وسياسات الصيام'),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. Fasting Timing Policy
                const Text(
                  'سياسة مواقيت الصيام والإمساك',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          _currentPolicy.policyId == FastingPolicy.standard.policyId
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: const Color(0xFF0F5132),
                        ),
                        title: Text(FastingPolicy.standard.nameArabic),
                        subtitle: Text(FastingPolicy.standard.sourceReference),
                        onTap: () => _savePolicy(FastingPolicy.standard.policyId),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          _currentPolicy.policyId == FastingPolicy.precautionaryImsak.policyId
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: const Color(0xFF0F5132),
                        ),
                        title: Text(FastingPolicy.precautionaryImsak.nameArabic),
                        subtitle: Text(FastingPolicy.precautionaryImsak.sourceReference),
                        onTap: () => _savePolicy(FastingPolicy.precautionaryImsak.policyId),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32),

                // 2. Calendar Offset
                const Text(
                  'تعديل التقويم الهجري المحلي',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'في حال اختلاف الرؤية المحلية لثبوت الهلال عن الحساب الفلكي، يمكنك ضبط الإزاحة بالأيام (من -2 إلى +2):',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _calendarOffset > -2 ? () => _saveCalendarOffset(_calendarOffset - 1) : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_calendarOffset يوم',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _calendarOffset < 2 ? () => _saveCalendarOffset(_calendarOffset + 1) : null,
                    ),
                  ],
                ),
                const Divider(height: 32),

                // 3. Historical Snapshot & Privacy
                const Text(
                  'لقطات التدقيق التاريخية والخصوصية',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'يمكنك إنشاء لقطة تدقيق تاريخية موثقة وغير قابلة للتعديل لسجلات الصيام:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _createSnapshot,
                  icon: const Icon(Icons.security),
                  label: const Text('حفظ لقطة تدقيق تاريخية محصنة'),
                ),
                const Divider(height: 32),

                // 4. Reset Data
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('إعادة ضبط جميع سجلات وخطة الصيام'),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تأكيد إعادة الضبط'),
                        content: const Text('هل أنت متأكد من رغبتك في حذف جميع سجلات الصيام المحلية وخطة القضاء؟\n(لن تتأثر بيانات القرآن أو الصلاة أو الأذكار)'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('إعادة ضبط'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await widget.module.resetAllUserData();
                      await _loadSettings();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تمت إعادة ضبط بيانات الصيام بنجاح')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
    );
  }
}
