import 'package:flutter/material.dart';
import '../../../modules/memorization/domain/memorization_plan.dart';
import '../../../modules/memorization/memorization_module.dart';
import '../../../modules/quran/domain/ayah_key.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';

/// Screen allowing the user to configure learning pace, daily targets, add ranges/ayahs, and reset options (§15, §22..§25, §27).
class PlanSetupScreen extends StatefulWidget {
  final MemorizationModule memorizationModule;
  final VoidCallback onSaved;
  final AyahKey? initialTargetAyahKey;

  const PlanSetupScreen({
    super.key,
    required this.memorizationModule,
    required this.onSaved,
    this.initialTargetAyahKey,
  });

  @override
  State<PlanSetupScreen> createState() => _PlanSetupScreenState();
}

class _PlanSetupScreenState extends State<PlanSetupScreen> {
  final TextEditingController _titleController = TextEditingController();
  int _dailyNew = 5;
  int _dailyReview = 20;
  bool _isLoading = true;
  MemorizationPlan? _currentPlan;
  int _selectedSurahNumber = 114; // Default to An-Nas / Juz Amma

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadPlan() async {
    setState(() => _isLoading = true);

    final planRes = await widget.memorizationModule.getPlan();
    final plan = planRes.valueOrNull ?? MemorizationPlan.createDefaultJuzAmma(widget.memorizationModule.clock.nowUtc());

    if (widget.initialTargetAyahKey != null) {
      await widget.memorizationModule.addAyahToPlan(widget.initialTargetAyahKey!);
    }

    if (mounted) {
      setState(() {
        _currentPlan = plan;
        _titleController.text = plan.title;
        _dailyNew = plan.dailyNewAyahs.clamp(1, 30);
        _dailyReview = plan.dailyReviewTarget.clamp(1, 100);
        _selectedSurahNumber = widget.initialTargetAyahKey?.surahNumber ?? 114;
        _isLoading = false;
      });
    }
  }

  Future<void> _addSelectedSurahToPlan() async {
    final surahRes = widget.memorizationModule.quranStore.getSurah(_selectedSurahNumber);
    if (surahRes.isFailure) return;

    final surah = surahRes.valueOrNull!;
    final keys = List.generate(
      surah.ayahCount,
      (index) => AyahKey(surahNumber: surah.number, ayahNumber: index + 1),
    );

    final addRes = await widget.memorizationModule.addAyahsToPlan(keys);
    if (mounted) {
      final count = addRes.valueOrNull ?? 0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(count > 0
              ? 'تمت إضافة $count آيات من سورة ${surah.nameArabic} إلى خطة الحفظ'
              : 'آيات سورة ${surah.nameArabic} موجودة بالفعل في الخطة'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _savePlan() async {
    if (_currentPlan == null) return;

    final updatedPlan = _currentPlan!.copyWith(
      title: _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : _currentPlan!.title,
      dailyNewAyahs: _dailyNew,
      dailyReviewTarget: _dailyReview,
    );

    final res = await widget.memorizationModule.savePlan(updatedPlan);
    if (res.isSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ إعدادات الخطة بنجاح'),
          backgroundColor: AppColors.primary,
        ),
      );
      widget.onSaved();
    }
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد إعادة ضبط سجلات الحفظ'),
        content: const Text(
          'سيؤدي هذا الإجراء إلى مسح سجلات الحفظ ونتائج المراجعات السابقة ودرجات الإتقان وإعادتها لحالتها الأولى. لن يتأثر النص القرآني أو الفواصل المرجعية.\n\nهل تريد المتابعة؟',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تصفير البيانات'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.memorizationModule.resetAllData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت إعادة ضبط بيانات الحفظ بنجاح'),
            backgroundColor: AppColors.primary,
          ),
        );
        widget.onSaved();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('إعدادات خطة الحفظ')),
        body: const LoadingStateView(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('خطة الحفظ والمراجعة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreen,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info banner for incoming Ayah
                if (widget.initialTargetAyahKey != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'تم ربط الآية ${widget.initialTargetAyahKey!.ayahNumber} من سورة رقم ${widget.initialTargetAyahKey!.surahNumber} بالخطة',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                ],

                // Plan Name
                Text('عنوان الخطة', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'مثال: خطة جزء عم، خطة سورة البقرة...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // Add Surah Range to Plan
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إضافة سور إلى الخطة',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'اختر السورة لإضافة جميع آياتها إلى قائمة المحفوظات المستهدفة',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _selectedSurahNumber,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: List.generate(114, (idx) {
                                  final num = idx + 1;
                                  final sRes = widget.memorizationModule.quranStore.getSurah(num);
                                  final name = sRes.isSuccess ? sRes.valueOrNull!.nameArabic : '$num';
                                  return DropdownMenuItem(
                                    value: num,
                                    child: Text('$num. سورة $name'),
                                  );
                                }),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedSurahNumber = val);
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.m),
                            ElevatedButton.icon(
                              onPressed: _addSelectedSurahToPlan,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('إضافة'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // Daily New Ayahs Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الجديد اليومي المستهدف', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('$_dailyNew آيات / يوم', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                Slider(
                  value: _dailyNew.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: '$_dailyNew',
                  onChanged: (val) => setState(() => _dailyNew = val.round()),
                ),
                const SizedBox(height: AppSpacing.m),

                // Daily Review Target Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الحد الأقصى للمراجعات اليومية', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('$_dailyReview آية / يوم', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                Slider(
                  value: _dailyReview.toDouble(),
                  min: 5,
                  max: 100,
                  divisions: 19,
                  label: '$_dailyReview',
                  onChanged: (val) => setState(() => _dailyReview = val.round()),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Save Plan Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                  ),
                  onPressed: _savePlan,
                  child: const Text('حفظ إعدادات الخطة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: AppSpacing.l),

                // Reset Action
                const Divider(),
                const SizedBox(height: AppSpacing.m),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                  ),
                  onPressed: _confirmReset,
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('إعادة ضبط وسجل المحفوظات بالكامل'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
