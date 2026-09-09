import 'package:flutter/material.dart';
import '../../../modules/memorization/domain/memorization_plan.dart';
import '../../../modules/memorization/memorization_module.dart';
import '../../../modules/quran/domain/ayah_key.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';

enum PlanSelectionMode {
  presets,
  byPages,
  bySurahs,
  byAyahs,
}

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
  PlanSelectionMode _selectionMode = PlanSelectionMode.presets;

  int _dailyNew = 5;
  int _dailyReview = 20;
  bool _isLoading = true;
  bool _isSaving = false;
  MemorizationPlan? _currentPlan;

  // Presets
  String _selectedPresetId = 'plan_juz_amma';

  // By Pages
  int _startPage = 582; // Start of Juz Amma (Page 582..604)
  int _endPage = 604;

  // By Surah Range
  int _startSurah = 78; // An-Naba
  int _endSurah = 114; // An-Nas

  // By Precise Ayahs
  int _startAyahSurah = 78;
  int _startAyahNum = 1;
  int _endAyahSurah = 114;
  int _endAyahNum = 6;

  // Individual Single Surah Dropdown
  int _singleSurahNumber = 114;

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
    final plan = planRes.valueOrNull ??
        MemorizationPlan.createDefaultJuzAmma(widget.memorizationModule.clock.nowUtc());

    if (widget.initialTargetAyahKey != null) {
      final k = widget.initialTargetAyahKey!;
      _selectionMode = PlanSelectionMode.byAyahs;
      _startAyahSurah = k.surahNumber;
      _startAyahNum = k.ayahNumber;
      _endAyahSurah = k.surahNumber;
      _endAyahNum = k.ayahNumber;
      _singleSurahNumber = k.surahNumber;
    }

    if (mounted) {
      setState(() {
        _currentPlan = plan;
        _titleController.text = plan.title;
        _dailyNew = plan.dailyNewAyahs.clamp(1, 30);
        _dailyReview = plan.dailyReviewTarget.clamp(5, 100);
        _isLoading = false;
      });
    }
  }

  List<AyahKey> _extractTargetAyahs() {
    final qStore = widget.memorizationModule.quranStore;
    final keys = <AyahKey>[];

    switch (_selectionMode) {
      case PlanSelectionMode.presets:
        if (_selectedPresetId == 'plan_juz_amma') {
          for (int s = 78; s <= 114; s++) {
            final aRes = qStore.getSurahAyahs(s);
            if (aRes.isSuccess) keys.addAll(aRes.valueOrNull!.map((a) => a.key));
          }
        } else if (_selectedPresetId == 'plan_juz_tabarak') {
          for (int s = 67; s <= 77; s++) {
            final aRes = qStore.getSurahAyahs(s);
            if (aRes.isSuccess) keys.addAll(aRes.valueOrNull!.map((a) => a.key));
          }
        } else if (_selectedPresetId == 'plan_baqarah') {
          final aRes = qStore.getSurahAyahs(2);
          if (aRes.isSuccess) keys.addAll(aRes.valueOrNull!.map((a) => a.key));
        } else if (_selectedPresetId == 'plan_mufassal') {
          for (int s = 50; s <= 114; s++) {
            final aRes = qStore.getSurahAyahs(s);
            if (aRes.isSuccess) keys.addAll(aRes.valueOrNull!.map((a) => a.key));
          }
        } else if (_selectedPresetId == 'plan_full_quran') {
          for (int s = 1; s <= 114; s++) {
            final aRes = qStore.getSurahAyahs(s);
            if (aRes.isSuccess) keys.addAll(aRes.valueOrNull!.map((a) => a.key));
          }
        } else if (_selectedPresetId == 'plan_single_surah') {
          final aRes = qStore.getSurahAyahs(_singleSurahNumber);
          if (aRes.isSuccess) keys.addAll(aRes.valueOrNull!.map((a) => a.key));
        }
        break;

      case PlanSelectionMode.byPages:
        final minP = _startPage < _endPage ? _startPage : _endPage;
        final maxP = _startPage > _endPage ? _startPage : _endPage;
        for (int p = minP; p <= maxP; p++) {
          final pRes = qStore.getPageAyahs(p);
          if (pRes.isSuccess) {
            keys.addAll(pRes.valueOrNull!.map((a) => a.key));
          }
        }
        break;

      case PlanSelectionMode.bySurahs:
        final minS = _startSurah < _endSurah ? _startSurah : _endSurah;
        final maxS = _startSurah > _endSurah ? _startSurah : _endSurah;
        for (int s = minS; s <= maxS; s++) {
          final aRes = qStore.getSurahAyahs(s);
          if (aRes.isSuccess) {
            keys.addAll(aRes.valueOrNull!.map((a) => a.key));
          }
        }
        break;

      case PlanSelectionMode.byAyahs:
        final startKey = AyahKey(surahNumber: _startAyahSurah, ayahNumber: _startAyahNum);
        final endKey = AyahKey(surahNumber: _endAyahSurah, ayahNumber: _endAyahNum);
        final isReverse = _startAyahSurah > _endAyahSurah ||
            (_startAyahSurah == _endAyahSurah && _startAyahNum > _endAyahNum);
        final actualStart = isReverse ? endKey : startKey;
        final actualEnd = isReverse ? startKey : endKey;

        for (int s = actualStart.surahNumber; s <= actualEnd.surahNumber; s++) {
          final aRes = qStore.getSurahAyahs(s);
          if (aRes.isSuccess) {
            for (final ayah in aRes.valueOrNull!) {
              if (s == actualStart.surahNumber && ayah.ayahNumber < actualStart.ayahNumber) {
                continue;
              }
              if (s == actualEnd.surahNumber && ayah.ayahNumber > actualEnd.ayahNumber) {
                continue;
              }
              keys.add(ayah.key);
            }
          }
        }
        break;
    }

    return keys;
  }

  void _applyPresetTemplate(String presetId, String title) {
    setState(() {
      _selectedPresetId = presetId;
      _titleController.text = title;
    });
  }

  void _applyJuzPages(int juzNumber) {
    final jRes = widget.memorizationModule.quranStore.getAllJuzs();
    if (jRes.isFailure) return;
    final juzs = jRes.valueOrNull!;
    final juz = juzs.firstWhere((j) => j.number == juzNumber, orElse: () => juzs.first);

    final nextJuz = juzs.where((j) => j.number == juzNumber + 1).firstOrNull;
    final endP = nextJuz != null ? nextJuz.startPage - 1 : 604;

    setState(() {
      _startPage = juz.startPage;
      _endPage = endP;
      _titleController.text = 'خطة حفظ الجزء $juzNumber (صفحة ${juz.startPage} إلى $endP)';
    });
  }

  Future<void> _savePlan() async {
    final targetAyahs = _extractTargetAyahs();
    if (targetAyahs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار نطاق صالح يحتوي على آيات للحفظ'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final now = widget.memorizationModule.clock.nowUtc();
    final firstKey = targetAyahs.first;
    final lastKey = targetAyahs.last;
    final distinctSurahs = targetAyahs.map((k) => k.surahNumber).toSet().toList()..sort();

    final totalDays = (targetAyahs.length / _dailyNew).ceil();
    final targetFinishDate = now.add(Duration(days: totalDays));

    final planTitle = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : 'خطة حفظ (${targetAyahs.length} آية)';

    final updatedPlan = MemorizationPlan(
      id: _currentPlan?.id ?? 'plan_${now.millisecondsSinceEpoch}',
      title: planTitle,
      targetSurahs: distinctSurahs,
      startAyah: firstKey,
      endAyah: lastKey,
      dailyNewAyahs: _dailyNew,
      dailyReviewTarget: _dailyReview,
      targetDate: targetFinishDate,
      isActive: true,
      createdAt: _currentPlan?.createdAt ?? now,
    );

    final result = await widget.memorizationModule.applyPlanWithAyahs(
      plan: updatedPlan,
      ayahs: targetAyahs,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم حفظ وتطبيق الخطة بنجاح! تم إدراج ${targetAyahs.length} آية، والختم المقدر بعد $totalDays يوماً.',
            ),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 4),
          ),
        );
        widget.onSaved();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.failureOrNull?.message ?? 'تعذر حفظ الخطة'),
            backgroundColor: AppColors.error,
          ),
        );
      }
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

    final targetAyahs = _extractTargetAyahs();
    final totalAyahsCount = targetAyahs.length;
    final totalDaysEstimated = _dailyNew > 0 ? (totalAyahsCount / _dailyNew).ceil() : 0;
    final estimatedFinish = DateTime.now().add(Duration(days: totalDaysEstimated));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('خطة الحفظ والمراجعة الذكية'),
        ),
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

                // 1. Smart Real-Time Khatma Estimator Card
                _buildKhatmaEstimatorCard(
                  totalAyahs: totalAyahsCount,
                  days: totalDaysEstimated,
                  finishDate: estimatedFinish,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.m),

                // 2. Selection Mode Selector
                Text(
                  'طريقة تحديد نطاق الحفظ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      avatar: const Icon(Icons.star_rounded, size: 16),
                      label: const Text('قوالب جاهزة'),
                      selected: _selectionMode == PlanSelectionMode.presets,
                      onSelected: (val) {
                        if (val) setState(() => _selectionMode = PlanSelectionMode.presets);
                      },
                    ),
                    ChoiceChip(
                      avatar: const Icon(Icons.auto_stories_rounded, size: 16),
                      label: const Text('بالصفحات والأجزاء'),
                      selected: _selectionMode == PlanSelectionMode.byPages,
                      onSelected: (val) {
                        if (val) setState(() => _selectionMode = PlanSelectionMode.byPages);
                      },
                    ),
                    ChoiceChip(
                      avatar: const Icon(Icons.library_books_rounded, size: 16),
                      label: const Text('بنطاق السور'),
                      selected: _selectionMode == PlanSelectionMode.bySurahs,
                      onSelected: (val) {
                        if (val) setState(() => _selectionMode = PlanSelectionMode.bySurahs);
                      },
                    ),
                    ChoiceChip(
                      avatar: const Icon(Icons.format_list_numbered_rounded, size: 16),
                      label: const Text('بالآيات بدقة'),
                      selected: _selectionMode == PlanSelectionMode.byAyahs,
                      onSelected: (val) {
                        if (val) setState(() => _selectionMode = PlanSelectionMode.byAyahs);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),

                // 3. Selection Mode Body
                _buildModeBody(context, isDark),
                const SizedBox(height: AppSpacing.l),

                // 4. Plan Title
                Text(
                  'عنوان الخطة',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'مثال: خطة جزء عم، خطة سورة البقرة، أول 5 صفحات...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // 5. Daily Pace Settings
                _buildPaceSliders(context),
                const SizedBox(height: AppSpacing.xl),

                // 6. Save Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                  ),
                  onPressed: _isSaving ? null : _savePlan,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_rounded),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _isSaving ? 'جارٍ حفظ وتطبيق الخطة...' : 'حفظ وتطبيق خطة الحفظ',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),

                // 7. Reset Action
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
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('إعادة ضبط وسجل المحفوظات بالكامل'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKhatmaEstimatorCard({
    required int totalAyahs,
    required int days,
    required DateTime finishDate,
    required bool isDark,
  }) {
    final estPages = (totalAyahs / 15).toStringAsFixed(1);
    final dateStr = '${finishDate.day}/${finishDate.month}/${finishDate.year}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMedium,
        side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.4), width: 1.2),
      ),
      color: isDark ? AppColors.surfaceDark : Colors.amber.withValues(alpha: 0.08),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppColors.goldAccent, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الحاسبة الذكية للختم والإنجاز',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? AppColors.goldAccent : Colors.brown.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: _buildEstimatorStat('إجمالي الآيات', '$totalAyahs آية', Icons.format_quote_rounded, AppColors.primary),
                ),
                Expanded(
                  child: _buildEstimatorStat('الصفحات المقدرة', '~$estPages صفحة', Icons.menu_book_rounded, Colors.teal),
                ),
                Expanded(
                  child: _buildEstimatorStat('المدة المقدرة', '$days يوماً', Icons.calendar_today_rounded, Colors.green),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            const Divider(height: 12),
            Row(
              children: [
                const Icon(Icons.event_available_rounded, size: 16, color: AppColors.goldAccent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'تاريخ الختم المقدر: $dateStr (بوتيرة $_dailyNew آيات يومياً)',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatorStat(String label, String val, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  val,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildModeBody(BuildContext context, bool isDark) {
    switch (_selectionMode) {
      case PlanSelectionMode.presets:
        return _buildPresetsBody(context);
      case PlanSelectionMode.byPages:
        return _buildPagesBody(context);
      case PlanSelectionMode.bySurahs:
        return _buildSurahsBody(context);
      case PlanSelectionMode.byAyahs:
        return _buildAyahsBody(context);
    }
  }

  Widget _buildPresetsBody(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اختر قالباً معتمداً لبدء الحفظ:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.star_rounded, size: 16, color: AppColors.goldAccent),
                  label: const Text('جزء عمّ (37 سورة)'),
                  onPressed: () => _applyPresetTemplate('plan_juz_amma', 'حفظ جزء عم (37 سورة)'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.bookmark_added_rounded, size: 16, color: AppColors.primary),
                  label: const Text('جزء تبارك (11 سورة)'),
                  onPressed: () => _applyPresetTemplate('plan_juz_tabarak', 'حفظ جزء تبارك (11 سورة)'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.auto_stories_rounded, size: 16, color: Colors.green),
                  label: const Text('سورة البقرة المباركة'),
                  onPressed: () => _applyPresetTemplate('plan_baqarah', 'حفظ سورة البقرة المباركة'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.library_books_rounded, size: 16, color: Colors.teal),
                  label: const Text('سور المفصّل (ق إلى الناس)'),
                  onPressed: () => _applyPresetTemplate('plan_mufassal', 'حفظ سور المفصل (ق إلى الناس)'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.goldAccent),
                  label: const Text('القرآن كاملاً (30 جزءاً)'),
                  onPressed: () => _applyPresetTemplate('plan_full_quran', 'حفظ القرآن الكريم كاملاً'),
                ),
              ],
            ),
            const Divider(height: 24),
            Text('أو اختر سورة محددة بالكامل:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _singleSurahNumber,
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
                        child: Text('$num. سورة $name', overflow: TextOverflow.ellipsis),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        final sRes = widget.memorizationModule.quranStore.getSurah(val);
                        final name = sRes.isSuccess ? sRes.valueOrNull!.nameArabic : '$val';
                        setState(() {
                          _singleSurahNumber = val;
                          _selectedPresetId = 'plan_single_surah';
                          _titleController.text = 'حفظ سورة $name';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagesBody(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تحديد النطاق بصفحات مصحف المدينة (1 إلى 604):', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.s),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('من صفحة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<int>(
                        initialValue: _startPage,
                        isExpanded: true,
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                        items: List.generate(604, (i) => i + 1).map((p) => DropdownMenuItem(value: p, child: Text('ص $p'))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _startPage = val;
                              if (_endPage < _startPage) _endPage = _startPage;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('إلى صفحة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<int>(
                        initialValue: _endPage,
                        isExpanded: true,
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                        items: List.generate(604, (i) => i + 1).map((p) => DropdownMenuItem(value: p, child: Text('ص $p'))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _endPage = val;
                              if (_startPage > _endPage) _startPage = _endPage;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Text('اختيار سريع بالأجزاء (30 جزءاً):', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (ctx, idx) {
                  final jNum = idx + 1;
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => _applyJuzPages(jNum),
                    child: Text('جزء $jNum', style: const TextStyle(fontSize: 12)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahsBody(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تحديد النطاق من سورة إلى سورة:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.s),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('من سورة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<int>(
                        initialValue: _startSurah,
                        isExpanded: true,
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                        items: List.generate(114, (i) {
                          final sNum = i + 1;
                          final sRes = widget.memorizationModule.quranStore.getSurah(sNum);
                          final name = sRes.isSuccess ? sRes.valueOrNull!.nameArabic : '$sNum';
                          return DropdownMenuItem(value: sNum, child: Text('$sNum. $name', overflow: TextOverflow.ellipsis));
                        }),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _startSurah = val;
                              if (_endSurah < _startSurah) _endSurah = _startSurah;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('إلى سورة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<int>(
                        initialValue: _endSurah,
                        isExpanded: true,
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                        items: List.generate(114, (i) {
                          final sNum = i + 1;
                          final sRes = widget.memorizationModule.quranStore.getSurah(sNum);
                          final name = sRes.isSuccess ? sRes.valueOrNull!.nameArabic : '$sNum';
                          return DropdownMenuItem(value: sNum, child: Text('$sNum. $name', overflow: TextOverflow.ellipsis));
                        }),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _endSurah = val;
                              if (_startSurah > _endSurah) _startSurah = _endSurah;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahsBody(BuildContext context) {
    final startSurahAyahCount = widget.memorizationModule.quranStore.getSurah(_startAyahSurah).valueOrNull?.ayahCount ?? 1;
    final endSurahAyahCount = widget.memorizationModule.quranStore.getSurah(_endAyahSurah).valueOrNull?.ayahCount ?? 1;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تحديد النطاق بالآيات الدقيقة:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.s),
            // Start Ayah
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    initialValue: _startAyahSurah,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'من سورة', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                    items: List.generate(114, (i) {
                      final sNum = i + 1;
                      final sRes = widget.memorizationModule.quranStore.getSurah(sNum);
                      final name = sRes.isSuccess ? sRes.valueOrNull!.nameArabic : '$sNum';
                      return DropdownMenuItem(value: sNum, child: Text('$sNum. $name', overflow: TextOverflow.ellipsis));
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _startAyahSurah = val;
                          _startAyahNum = 1;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    initialValue: _startAyahNum.clamp(1, startSurahAyahCount),
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'آية رقم', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                    items: List.generate(startSurahAyahCount, (i) => i + 1).map((a) => DropdownMenuItem(value: a, child: Text('$a'))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _startAyahNum = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            // End Ayah
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    initialValue: _endAyahSurah,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'إلى سورة', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                    items: List.generate(114, (i) {
                      final sNum = i + 1;
                      final sRes = widget.memorizationModule.quranStore.getSurah(sNum);
                      final name = sRes.isSuccess ? sRes.valueOrNull!.nameArabic : '$sNum';
                      return DropdownMenuItem(value: sNum, child: Text('$sNum. $name', overflow: TextOverflow.ellipsis));
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        final count = widget.memorizationModule.quranStore.getSurah(val).valueOrNull?.ayahCount ?? 1;
                        setState(() {
                          _endAyahSurah = val;
                          _endAyahNum = count;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    initialValue: _endAyahNum.clamp(1, endSurahAyahCount),
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'آية رقم', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                    items: List.generate(endSurahAyahCount, (i) => i + 1).map((a) => DropdownMenuItem(value: a, child: Text('$a'))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _endAyahNum = val);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaceSliders(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Wrap(
              spacing: 6,
              children: [1, 3, 5, 7, 10, 15, 20].map((n) {
                return ChoiceChip(
                  label: Text('$n آيات'),
                  selected: _dailyNew == n,
                  onSelected: (val) {
                    if (val) setState(() => _dailyNew = n);
                  },
                );
              }).toList(),
            ),
            const Divider(height: 24),
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
            Wrap(
              spacing: 6,
              children: [10, 20, 30, 50, 70, 100].map((n) {
                return ChoiceChip(
                  label: Text('$n آية'),
                  selected: _dailyReview == n,
                  onSelected: (val) {
                    if (val) setState(() => _dailyReview = n);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
