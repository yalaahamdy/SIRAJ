import 'package:flutter/material.dart';
import '../../../modules/memorization/domain/memorization_plan.dart';
import '../../../modules/memorization/memorization_module.dart';
import '../../../modules/quran/domain/ayah_key.dart';
import '../../../modules/quran/domain/surah.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';

enum PlanSelectionMode {
  byJuz,
  bySurah,
  customRange,
}

/// Screen allowing the user to select and configure a clean, structured Quran memorization plan.
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
  final TextEditingController _dailyNewController = TextEditingController();
  final TextEditingController _startAyahController = TextEditingController();
  final TextEditingController _endAyahController = TextEditingController();
  PlanSelectionMode _selectionMode = PlanSelectionMode.byJuz;

  int _selectedJuz = 30; // Default to Juz Amma
  int _selectedSurah = 78; // Default An-Naba
  int _dailyNew = 5;
  int _dailyReview = 20;

  // Custom range
  int _startSurah = 78;
  int _startAyah = 1;
  int _endSurah = 114;
  int _endAyah = 6;

  bool _isLoading = true;
  bool _isSaving = false;
  List<Surah> _allSurahs = [];

  @override
  void initState() {
    super.initState();
    _startAyahController.text = '$_startAyah';
    _endAyahController.text = '$_endAyah';
    _loadInitialData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dailyNewController.dispose();
    _startAyahController.dispose();
    _endAyahController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    final surahsRes = widget.memorizationModule.quranStore.getAllSurahs();
    _allSurahs = surahsRes.valueOrNull ?? [];

    final planRes = await widget.memorizationModule.getPlan();
    final plan = planRes.valueOrNull ??
        MemorizationPlan.createDefaultJuzAmma(widget.memorizationModule.clock.nowUtc());

    _dailyNew = plan.dailyNewAyahs > 0 ? plan.dailyNewAyahs : 5;
    _dailyNewController.text = '$_dailyNew';
    _dailyReview = plan.dailyReviewTarget > 0 ? plan.dailyReviewTarget : 20;

    if (widget.initialTargetAyahKey != null) {
      final k = widget.initialTargetAyahKey!;
      _selectionMode = PlanSelectionMode.bySurah;
      _selectedSurah = k.surahNumber;
      _titleController.text = 'خطة حفظ سورة ${_getSurahName(k.surahNumber)}';
    } else {
      _titleController.text = plan.title;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String _getSurahName(int sNum) {
    final s = _allSurahs.where((e) => e.number == sNum).firstOrNull;
    return s?.nameArabic ?? 'سورة $sNum';
  }

  int _getSurahAyahsCount(int sNum) {
    final s = _allSurahs.where((e) => e.number == sNum).firstOrNull;
    return s?.ayahCount ?? 7;
  }

  List<AyahKey> _calculateTargetAyahs() {
    final qStore = widget.memorizationModule.quranStore;
    final keys = <AyahKey>[];

    switch (_selectionMode) {
      case PlanSelectionMode.byJuz:
        if (_selectedJuz == 0) {
          // Whole Quran (1..114)
          for (int s = 1; s <= 114; s++) {
            final aRes = qStore.getSurahAyahs(s);
            if (aRes.isSuccess) keys.addAll(aRes.valueOrNull!.map((a) => a.key));
          }
        } else {
          final jRes = qStore.getAllJuzs();
          if (jRes.isSuccess) {
            final juzList = jRes.valueOrNull ?? [];
            final juz = juzList.where((j) => j.number == _selectedJuz).firstOrNull;
            if (juz != null) {
              final nextJuz = juzList.where((j) => j.number == _selectedJuz + 1).firstOrNull;
              final endPage = nextJuz != null ? nextJuz.startPage - 1 : 604;
              for (int p = juz.startPage; p <= endPage; p++) {
                final pRes = qStore.getPageAyahs(p);
                if (pRes.isSuccess) keys.addAll(pRes.valueOrNull!.map((a) => a.key));
              }
            }
          }
        }
        break;

      case PlanSelectionMode.bySurah:
        final aRes = qStore.getSurahAyahs(_selectedSurah);
        if (aRes.isSuccess) {
          keys.addAll(aRes.valueOrNull!.map((a) => a.key));
        }
        break;

      case PlanSelectionMode.customRange:
        final isReverse = _startSurah > _endSurah;
        if (!isReverse) {
          for (int s = _startSurah; s <= _endSurah; s++) {
            final aRes = qStore.getSurahAyahs(s);
            if (aRes.isSuccess) {
              final ayahs = aRes.valueOrNull!;
              final maxAyah = _getSurahAyahsCount(s);
              final fromA = s == _startSurah ? _startAyah.clamp(1, maxAyah) : 1;
              final toA = s == _endSurah ? _endAyah.clamp(1, maxAyah) : maxAyah;
              for (final ayah in ayahs) {
                if (ayah.ayahNumber >= fromA && ayah.ayahNumber <= toA) {
                  keys.add(ayah.key);
                }
              }
            }
          }
        } else {
          // Descending / Reverse order (e.g. Surah 114 down to Surah 78)
          for (int s = _startSurah; s >= _endSurah; s--) {
            final aRes = qStore.getSurahAyahs(s);
            if (aRes.isSuccess) {
              final ayahs = aRes.valueOrNull!;
              final maxAyah = _getSurahAyahsCount(s);
              final fromA = s == _startSurah ? _startAyah.clamp(1, maxAyah) : 1;
              final toA = s == _endSurah ? _endAyah.clamp(1, maxAyah) : maxAyah;
              for (final ayah in ayahs) {
                if (ayah.ayahNumber >= fromA && ayah.ayahNumber <= toA) {
                  keys.add(ayah.key);
                }
              }
            }
          }
        }
        break;
    }

    return keys;
  }

  Future<void> _savePlan() async {
    final targetAyahs = _calculateTargetAyahs();
    if (targetAyahs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار نطاق صالح يحتوي على آيات'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final now = widget.memorizationModule.clock.nowUtc();
    final firstKey = targetAyahs.first;
    final lastKey = targetAyahs.last;
    // Preserve the user-selected order (whether ascending or descending 114 -> 78)
    final distinctSurahs = <int>[];
    for (final k in targetAyahs) {
      if (!distinctSurahs.contains(k.surahNumber)) {
        distinctSurahs.add(k.surahNumber);
      }
    }

    final totalDays = (targetAyahs.length / _dailyNew).ceil();
    final targetFinishDate = now.add(Duration(days: totalDays));

    String finalTitle = _titleController.text.trim();
    if (finalTitle.isEmpty) {
      if (_selectionMode == PlanSelectionMode.byJuz) {
        finalTitle = _selectedJuz == 0 ? 'خطة حفظ القرآن الكريم كاملاً' : 'خطة حفظ الجزء $_selectedJuz';
      } else if (_selectionMode == PlanSelectionMode.bySurah) {
        finalTitle = 'خطة حفظ سورة ${_getSurahName(_selectedSurah)}';
      } else {
        final isReverse = _startSurah > _endSurah;
        finalTitle = isReverse
            ? 'خطة حفظ من سورة ${_getSurahName(_startSurah)} إلى ${_getSurahName(_endSurah)}'
            : 'خطة حفظ من سورة ${_getSurahName(_startSurah)} إلى ${_getSurahName(_endSurah)}';
      }
    }

    final newPlan = MemorizationPlan(
      id: 'plan_${now.millisecondsSinceEpoch}',
      title: finalTitle,
      targetSurahs: distinctSurahs,
      startAyah: firstKey,
      endAyah: lastKey,
      dailyNewAyahs: _dailyNew,
      dailyReviewTarget: _dailyReview,
      targetDate: targetFinishDate,
      isActive: true,
      createdAt: now,
    );

    final result = await widget.memorizationModule.applyPlanWithAyahs(
      plan: newPlan,
      ayahs: targetAyahs,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تفعيل $finalTitle بنجاح (${targetAyahs.length} آية)'),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 3),
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
        title: const Text('تصفير سجلات الحفظ'),
        content: const Text(
          'هل تريد مسح سجلات الحفظ والبدء من جديد؟ لن تتأثر النصوص أو القراءات.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تصفير السجلات'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.memorizationModule.resetAllData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تصفير سجلات الحفظ بنجاح')),
        );
        widget.onSaved();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('تخصيص خطة التحفيظ')),
        body: const LoadingStateView(),
      );
    }

    final targetAyahs = _calculateTargetAyahs();
    final totalAyahs = targetAyahs.length;
    final totalDays = (totalAyahs / _dailyNew).ceil();
    final finishDate = DateTime.now().add(Duration(days: totalDays));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تخصيص خطة التحفيظ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.warning),
              tooltip: 'تصفير السجلات',
              onPressed: _confirmReset,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Mode Selector Segmented Buttons
                  _buildModeSelector(isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 2. Mode Content Pickers
                  _buildScopePicker(isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 3. Daily Target Picker
                  _buildDailyTargetPicker(isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 4. Estimation Summary Card
                  _buildEstimationCard(totalAyahs, totalDays, finishDate, isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 5. Plan Title TextField
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'مسمى الخطة المباركة',
                      hintText: 'مثال: خطة جزء عم، أو حفظ سورة الكهف',
                      prefixIcon: const Icon(Icons.bookmark_border_rounded, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // 6. Big Action Button (Save & Activate)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    onPressed: _isSaving ? null : _savePlan,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_rounded, size: 22),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _isSaving ? 'جارٍ الحفظ والتهيئة...' : 'حفظ الخطة وتفعيلها الآن 🌟',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildTabBtn(
              label: 'بالأجزاء',
              icon: Icons.menu_book_rounded,
              mode: PlanSelectionMode.byJuz,
            ),
          ),
          Expanded(
            child: _buildTabBtn(
              label: 'بالسورة',
              icon: Icons.auto_stories_rounded,
              mode: PlanSelectionMode.bySurah,
            ),
          ),
          Expanded(
            child: _buildTabBtn(
              label: 'نطاق مخصص',
              icon: Icons.tune_rounded,
              mode: PlanSelectionMode.customRange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBtn({
    required String label,
    required IconData icon,
    required PlanSelectionMode mode,
  }) {
    final isSelected = _selectionMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectionMode = mode;
          if (mode == PlanSelectionMode.byJuz) {
            _titleController.text = _selectedJuz == 0 ? 'خطة القرآن كاملاً' : 'خطة حفظ جزء $_selectedJuz';
          } else if (mode == PlanSelectionMode.bySurah) {
            _titleController.text = 'خطة حفظ سورة ${_getSurahName(_selectedSurah)}';
          } else {
            _titleController.text = 'خطة حفظ مخصصة';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScopePicker(bool isDark) {
    switch (_selectionMode) {
      case PlanSelectionMode.byJuz:
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختر الجزء المقرر للحفظ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: _selectedJuz,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: [
                    const DropdownMenuItem(value: 30, child: Text('جزء عمّ (الجزء 30 - 37 سورة)')),
                    const DropdownMenuItem(value: 29, child: Text('جزء تبارك (الجزء 29 - 11 سورة)')),
                    const DropdownMenuItem(value: 28, child: Text('جزء قد سمع (الجزء 28)')),
                    const DropdownMenuItem(value: 0, child: Text('القرآن الكريم كاملاً (30 جزءاً)')),
                    for (int j = 1; j <= 27; j++)
                      DropdownMenuItem(value: j, child: Text('الجزء $j')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedJuz = val;
                        _titleController.text = val == 0 ? 'خطة حفظ القرآن كاملاً' : 'خطة حفظ الجزء $val';
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );

      case PlanSelectionMode.bySurah:
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختر السورة الكريمة للحفظ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: _selectedSurah,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: _allSurahs.map((s) {
                    return DropdownMenuItem<int>(
                      value: s.number,
                      child: Text('${s.number}. سورة ${s.nameArabic} (${s.ayahCount} آية)'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedSurah = val;
                        _titleController.text = 'خطة حفظ سورة ${_getSurahName(val)}';
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );

      case PlanSelectionMode.customRange:
        final isReverseOrder = _startSurah > _endSurah;
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('حدد نطاق البداية والنهاية:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                if (isReverseOrder) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.35)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.swap_vert_rounded, size: 16, color: AppColors.goldAccent),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'نظام حفظ تنازلي مبارك (من سورة لاحقة إلى سابقة كما في الكتاتيب)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<int>(
                        initialValue: _startSurah,
                        isExpanded: true,
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'من سورة',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: _allSurahs.map((s) => DropdownMenuItem(value: s.number, child: Text(s.nameArabic, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _startSurah = v;
                              _startAyah = 1;
                              _startAyahController.text = '1';
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _startAyahController,
                        decoration: InputDecoration(
                          labelText: 'آية',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _startAyah = int.tryParse(v) ?? 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<int>(
                        initialValue: _endSurah,
                        isExpanded: true,
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'إلى سورة',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: _allSurahs.map((s) => DropdownMenuItem(value: s.number, child: Text(s.nameArabic, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _endSurah = v;
                              _endAyah = _getSurahAyahsCount(v);
                              _endAyahController.text = '$_endAyah';
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _endAyahController,
                        decoration: InputDecoration(
                          labelText: 'آية',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _endAyah = int.tryParse(v) ?? 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildDailyTargetPicker(bool isDark) {
    final targets = [3, 5, 7, 10, 15];
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المستهدف اليومي للحفظ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('$_dailyNew آيات / يومياً', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: targets.map((t) {
                final isSel = _dailyNew == t;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSel ? AppColors.primary : Colors.transparent,
                        foregroundColor: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        side: BorderSide(color: isSel ? AppColors.primary : Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          _dailyNew = t;
                          _dailyNewController.text = '$t';
                        });
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('$t آيات', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Text('أو اكتب عدداً مخصصاً:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline_rounded, size: 22),
                    color: AppColors.primary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'إنقاص آية',
                    onPressed: () {
                      if (_dailyNew > 1) {
                        setState(() {
                          _dailyNew--;
                          _dailyNewController.text = '$_dailyNew';
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 54,
                    height: 36,
                    child: TextFormField(
                      controller: _dailyNewController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onChanged: (val) {
                        final parsed = int.tryParse(val);
                        if (parsed != null && parsed > 0) {
                          setState(() {
                            _dailyNew = parsed;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
                    color: AppColors.primary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'زيادة آية',
                    onPressed: () {
                      setState(() {
                        _dailyNew++;
                        _dailyNewController.text = '$_dailyNew';
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  const Text('آية / يوم', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimationCard(int totalAyahs, int totalDays, DateTime finishDate, bool isDark) {
    final months = (totalDays / 30).toStringAsFixed(1);
    final dateStr = '${finishDate.year}/${finishDate.month.toString().padLeft(2, '0')}/${finishDate.day.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.goldAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('إجمالي الآيات', '$totalAyahs آية', Icons.format_list_numbered_rounded),
          Container(width: 1, height: 32, color: Colors.grey.shade300),
          _buildStatItem('مدة الختم المقدرة', '$totalDays يوم ($months شهر)', Icons.timelapse_rounded),
          Container(width: 1, height: 32, color: Colors.grey.shade300),
          _buildStatItem('تاريخ الإتمام', dateStr, Icons.event_available_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.goldAccent),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
