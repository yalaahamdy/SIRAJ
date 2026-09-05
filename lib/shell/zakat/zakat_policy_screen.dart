import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/zakat_policy.dart';
import '../../../modules/zakat/zakat_module.dart';
import '../theme/app_colors.dart';

/// Screen for selecting and inspecting jurisprudential Zakat policies (§11..§15, §37).
class ZakatPolicyScreen extends StatefulWidget {
  final ZakatModule module;

  const ZakatPolicyScreen({super.key, required this.module});

  @override
  State<ZakatPolicyScreen> createState() => _ZakatPolicyScreenState();
}

class _ZakatPolicyScreenState extends State<ZakatPolicyScreen> {
  late List<ZakatPolicy> _policies;
  ZakatPolicy? _activePolicy;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPolicies();
  }

  Future<void> _loadPolicies() async {
    final policies = widget.module.getAvailablePolicies();
    final active = await widget.module.getActivePolicy();
    if (mounted) {
      setState(() {
        _policies = policies;
        _activePolicy = active;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectPolicy(ZakatPolicy policy) async {
    await widget.module.setActivePolicy(policy.policyId);
    setState(() {
      _activePolicy = policy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('السياسات الفقهية لحساب الزكاة'),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info banner (§12, §13)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'السياسة المحددة للحساب: تتيح منصة سِراج اختيار المنهجية الفقهية المعتمدة لاحتساب النصاب والديون بشفافية وموضوعية دون إلزام أو تفضيل صامت.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Policy Cards (§12)
                ..._policies.map((policy) {
                  final isSelected = _activePolicy?.policyId == policy.policyId;
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    child: InkWell(
                      onTap: () => _selectPolicy(policy),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSelected ? AppColors.primary : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    policy.nameArabic,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              policy.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 4),
                            Text(
                              'معيار النصاب: ${policy.nisabStandard.labelArabic}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'معاملة الديون: ${policy.debtTreatment.labelArabic}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'المصدر المعتمد: ${policy.sourceInstitution}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'المرجع: ${policy.reference}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
