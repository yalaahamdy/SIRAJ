import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../modules/memorization/domain/memorization_plan.dart';
import '../../../../modules/memorization/domain/tahfeez_surah_summary.dart';
import '../../../../modules/memorization/memorization_module.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/domain/ayah_key.dart';
import '../../../../modules/quran/quran_module.dart';
import '../../memorization/plan_setup_screen.dart';
import '../quran_reader_screen.dart';
import 'surah_downloader_sheet.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/state_views.dart';

/// Clean, professional Quran Memorization & Progress Dashboard Tab.
/// Functions as the central command hub for the memorization plan:
/// tracking overall completion, displaying today's target wird,
/// past review targets, and launching QuranReaderScreen for in-mushaf
/// listening, reading, and automated speech recognition tasmee.
class QuranTahfeezTab extends StatefulWidget {
  final QuranModule quranModule;
  final MemorizationModule memorizationModule;
  final Function(int surahNumber, {int? targetPage, int? targetAyah}) onOpenSurah;

  const QuranTahfeezTab({
    super.key,
    required this.quranModule,
    required this.memorizationModule,
    required this.onOpenSurah,
  });

  @override
  State<QuranTahfeezTab> createState() => _QuranTahfeezTabState();
}

class _QuranTahfeezTabState extends State<QuranTahfeezTab> {
  MemorizationPlan? _plan;
  List<Ayah> _todayWirdAyahs = [];
  List<Ayah> _todayReviewAyahs = [];
  bool _isReviewCompletedToday = false;
  List<TahfeezSurahSummary> _surahsSummary = [];
  final Set<AyahKey> _memorizedKeys = {};
  bool _isLoading = true;
  int? _customWirdCount;
  final TextEditingController _customCountController = TextEditingController();
  int? _customReviewCount;
  final TextEditingController _customReviewCountController = TextEditingController();
  int _selectedReviewSurahNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadTahfeezData();
  }

  @override
  void dispose() {
    _customCountController.dispose();
    _customReviewCountController.dispose();
    super.dispose();
  }

  Future<void> _loadTahfeezData() async {
    setState(() => _isLoading = true);

    await widget.memorizationModule.initialize();
    final planRes = await widget.memorizationModule.getPlan();
    final plan = planRes.valueOrNull ??
        MemorizationPlan.createDefaultJuzAmma(widget.memorizationModule.clock.nowUtc());

    final wirdRes = await widget.memorizationModule.getTodayWirdAyahs(
      plan,
      customTargetAyahs: _customWirdCount,
    );
    final reviewWirdRes = await widget.memorizationModule.getTodayReviewAyahs(
      plan,
      customTargetAyahs: _customReviewCount,
    );
    final isRevDoneRes = await widget.memorizationModule.isDailyReviewCompletedToday();
    final summaryRes = await widget.memorizationModule.getPlanSurahsSummary(plan);
    final itemsRes = await widget.memorizationModule.getAllItems();

    final memorized = (itemsRes.valueOrNull ?? [])
        .where((i) => i.masteryScore >= 80.0)
        .map((i) => i.ayahKey)
        .toSet();

    final loadedWird = wirdRes.valueOrNull ?? [];
    if (_customWirdCount == null || _customWirdCount! <= 0) {
      _customWirdCount = loadedWird.isNotEmpty ? loadedWird.length : plan.dailyNewAyahs;
      _customCountController.text = '$_customWirdCount';
    }

    final loadedReviewWird = reviewWirdRes.valueOrNull ?? [];
    if (_customReviewCount == null || _customReviewCount! <= 0) {
      _customReviewCount = loadedReviewWird.isNotEmpty ? loadedReviewWird.length : plan.dailyReviewTarget;
      _customReviewCountController.text = '$_customReviewCount';
    }

    if (mounted) {
      setState(() {
        _plan = plan;
        _todayWirdAyahs = loadedWird;
        _todayReviewAyahs = loadedReviewWird;
        _isReviewCompletedToday = isRevDoneRes.valueOrNull ?? false;
        _surahsSummary = summaryRes.valueOrNull ?? [];
        _memorizedKeys
          ..clear()
          ..addAll(memorized);
        _isLoading = false;
      });
    }
  }

  Future<void> _updateCustomWirdCount(int count) async {
    if (_plan == null) return;
    final wirdRes = await widget.memorizationModule.getTodayWirdAyahs(
      _plan!,
      customTargetAyahs: count,
    );
    if (mounted && wirdRes.isSuccess) {
      setState(() {
        _customWirdCount = count;
        _customCountController.text = '$count';
        _todayWirdAyahs = wirdRes.valueOrNull ?? [];
      });
    }
  }

  Future<void> _updateCustomReviewCount(int count) async {
    if (_plan == null) return;
    final revRes = await widget.memorizationModule.getTodayReviewAyahs(
      _plan!,
      customTargetAyahs: count,
    );
    if (mounted && revRes.isSuccess) {
      setState(() {
        _customReviewCount = count;
        _customReviewCountController.text = '$count';
        _todayReviewAyahs = revRes.valueOrNull ?? [];
      });
    }
  }

  String _getSurahName(int surahNumber) {
    final s = _surahsSummary.where((e) => e.surahNumber == surahNumber).firstOrNull;
    if (s != null) return s.surahNameArabic;
    final res = widget.quranModule.getSurah(surahNumber);
    return res.valueOrNull?.nameArabic ?? 'سورة $surahNumber';
  }

  void _openPlanSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PlanSetupScreen(
          memorizationModule: widget.memorizationModule,
          onSaved: () {
            Navigator.pop(ctx);
            _customWirdCount = null; // Adopt the new plan daily target immediately
            _customReviewCount = null; // Adopt the new plan review target immediately
            _loadTahfeezData();
          },
        ),
      ),
    );
  }

  Future<void> _openReaderForMemorization(
    int surahNumber,
    int startAyah,
    int endAyah, {
    bool isReview = false,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuranReaderScreen(
          quranModule: widget.quranModule,
          memorizationModule: widget.memorizationModule,
          initialSurahNumber: surahNumber,
          isMemorizationMode: true,
          memorizationStartAyah: startAyah,
          memorizationEndAyah: endAyah,
          isReviewMode: isReview,
        ),
      ),
    );
    // Reload when returning from reader to reflect newly memorized verses immediately
    _loadTahfeezData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const LoadingStateView();
    }

    final totalAyahsCount = _surahsSummary.fold<int>(0, (sum, s) => sum + s.totalAyahsInPlan);
    final memorizedCount = _surahsSummary.fold<int>(0, (sum, s) => sum + s.memorizedAyahsCount);
    final overallProgress = totalAyahsCount > 0 ? (memorizedCount / totalAyahsCount) * 100 : 0.0;

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.35,
      child: RefreshIndicator(
        onRefresh: _loadTahfeezData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Top Plan Summary & Hero Card
                  _buildPlanHeroCard(isDark, memorizedCount, totalAyahsCount, overallProgress),
                  const SizedBox(height: AppSpacing.m),

                  // 2. Today's Memorization Wird Card
                  _buildTodayWirdCard(isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 3. Past Memorization Review Card
                  _buildPastReviewCard(isDark),
                  const SizedBox(height: AppSpacing.m),

                  // 4. Plan Surahs Progress List
                  _buildPlanSurahsList(isDark),
                  const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanHeroCard(bool isDark, int memorizedCount, int totalAyahsCount, double progress) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.3)),
      ),
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_added_rounded, color: AppColors.goldAccent, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _plan?.title ?? 'خطة حفظ كتاب الله',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        'المستهدف: ${_plan?.dailyNewAyahs ?? 5} آيات يومياً',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_note_rounded, color: AppColors.primary),
                  tooltip: 'تعديل أو إعادة ضبط الخطة',
                  onPressed: _openPlanSetup,
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (progress / 100).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldAccent),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeroStat('المحفوظ', '$memorizedCount آية', Colors.green, Icons.check_circle_outline_rounded),
                _buildHeroStat('المتبقي', '${(totalAyahsCount - memorizedCount).clamp(0, totalAyahsCount)} آية', Colors.orange, Icons.hourglass_empty_rounded),
                _buildHeroStat('نسبة الإنجاز', '${progress.toStringAsFixed(1)}%', AppColors.goldAccent, Icons.pie_chart_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWirdCard(bool isDark) {
    if (_todayWirdAyahs.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? AppColors.surfaceDark : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            children: [
              const Icon(Icons.celebration_rounded, color: AppColors.goldAccent, size: 40),
              const SizedBox(height: 8),
              const Text(
                'أتممت ورد اليوم بنجاح بحمد الله!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                'يمكنك مراجعة الماضي وتثبيت حفظك في قارئ المصحف أدناه.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('إعادة تحميل الورد'),
                onPressed: _loadTahfeezData,
              ),
            ],
          ),
        ),
      );
    }

    final totalWirdAyahs = _todayWirdAyahs.length;
    final isWirdCompleted = _todayWirdAyahs.every((a) => _memorizedKeys.contains(a.key));

    // Group consecutive ayahs by surah preserving order
    final Map<int, List<Ayah>> surahGroups = {};
    for (final a in _todayWirdAyahs) {
      surahGroups.putIfAbsent(a.surahNumber, () => []).add(a);
    }

    final firstAyah = _todayWirdAyahs.first;
    final lastAyah = _todayWirdAyahs.last;

    final String wirdTitle;
    if (surahGroups.length == 1) {
      final sNum = surahGroups.keys.first;
      wirdTitle = 'سورة ${_getSurahName(sNum)} — من الآية ${firstAyah.ayahNumber} إلى الآية ${lastAyah.ayahNumber}';
    } else {
      wirdTitle = 'من سورة ${_getSurahName(firstAyah.surahNumber)} (${firstAyah.ayahNumber}) إلى سورة ${_getSurahName(lastAyah.surahNumber)} (${lastAyah.ayahNumber})';
    }

    // Find first uncompleted surah group in the wird, or default to the first group
    final uncompletedGroup = surahGroups.entries
        .where((e) => !e.value.every((a) => _memorizedKeys.contains(a.key)))
        .firstOrNull;
    final targetGroup = uncompletedGroup ?? surahGroups.entries.first;

    final totalAyahsInPlan = _surahsSummary.fold<int>(0, (sum, s) => sum + s.totalAyahsInPlan);
    final maxAvailableCount = totalAyahsInPlan > 0 ? totalAyahsInPlan : 286;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isWirdCompleted
              ? Colors.green.withValues(alpha: 0.4)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isWirdCompleted
                          ? Colors.green.withValues(alpha: 0.15)
                          : AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isWirdCompleted ? Icons.check_circle_rounded : Icons.star_rounded,
                          color: isWirdCompleted ? Colors.green : AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isWirdCompleted ? 'تم حفظ ورد اليوم ✅' : 'ورد الحفظ لليوم',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isWirdCompleted ? Colors.green : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    surahGroups.length > 1
                        ? '$totalWirdAyahs آية (${surahGroups.length} سُوَر)'
                        : '$totalWirdAyahs آية مقررة',
                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              wirdTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.amber.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.2)),
              ),
              child: Text(
                '« ${firstAyah.textUthmani} ... »',
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 14,
                  height: 1.6,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            if (surahGroups.length > 1) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: surahGroups.entries.map((entry) {
                  final sNum = entry.key;
                  final aList = entry.value;
                  final isDone = aList.every((a) => _memorizedKeys.contains(a.key));
                  final isTarget = entry.key == targetGroup.key;
                  final sName = _getSurahName(sNum);
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _openReaderForMemorization(
                      sNum,
                      aList.first.ayahNumber,
                      aList.last.ayahNumber,
                      isReview: isDone,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDone
                            ? Colors.green.withValues(alpha: 0.12)
                            : (isTarget
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : (isDark ? Colors.white10 : Colors.grey.shade100)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDone
                              ? Colors.green.withValues(alpha: 0.4)
                              : (isTarget ? AppColors.primary : Colors.transparent),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isDone ? Icons.check_circle_rounded : Icons.menu_book_rounded,
                            size: 13,
                            color: isDone ? Colors.green : AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$sName (${aList.first.ayahNumber}-${aList.last.ayahNumber})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDone ? Colors.green : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '• ${aList.length}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'حدد عدد آيات اليوم بحرية:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'إجمالي ورد اليوم: $totalWirdAyahs آية',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded, size: 24),
                            color: AppColors.primary,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'إنقاص آية',
                            onPressed: () {
                              if (totalWirdAyahs > 1) {
                                _updateCustomWirdCount(totalWirdAyahs - 1);
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 60,
                            height: 36,
                            child: TextFormField(
                              controller: _customCountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              onFieldSubmitted: (val) {
                                final parsed = int.tryParse(val);
                                if (parsed != null && parsed > 0) {
                                  _updateCustomWirdCount(parsed);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
                            color: AppColors.primary,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'زيادة آية',
                            onPressed: () {
                              if (totalWirdAyahs < maxAvailableCount) {
                                _updateCustomWirdCount(totalWirdAyahs + 1);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text('آيات', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: isWirdCompleted ? const Color(0xFF2E7D32) : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: Icon(isWirdCompleted ? Icons.refresh_rounded : Icons.menu_book_rounded, size: 18),
              label: Text(
                isWirdCompleted
                    ? 'مراجعة أو إعادة تسميع الورد في المصحف 🔄'
                    : (surahGroups.length == 1
                        ? 'ابدأ الحفظ والتسميع في المصحف 📖🎙️'
                        : 'ابدأ حفظ سورة ${_getSurahName(targetGroup.key)} (${targetGroup.value.first.ayahNumber} - ${targetGroup.value.last.ayahNumber}) 📖🎙️'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _openReaderForMemorization(
                targetGroup.key,
                targetGroup.value.first.ayahNumber,
                targetGroup.value.last.ayahNumber,
                isReview: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastReviewCard(bool isDark) {
    final memorizedSurahs = _surahsSummary.where((s) => s.memorizedAyahsCount > 0).toList();
    if (memorizedSurahs.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_selectedReviewSurahNumber == 0 || !memorizedSurahs.any((s) => s.surahNumber == _selectedReviewSurahNumber)) {
      _selectedReviewSurahNumber = memorizedSurahs.first.surahNumber;
    }

    final totalMemAyahs = memorizedSurahs.fold<int>(0, (sum, s) => sum + s.memorizedAyahsCount);
    final currentReviewSurah = memorizedSurahs.firstWhere(
      (s) => s.surahNumber == _selectedReviewSurahNumber,
      orElse: () => memorizedSurahs.first,
    );

    final totalReviewAyahs = _todayReviewAyahs.length;
    final hasReviewWird = _todayReviewAyahs.isNotEmpty;

    // Group review wird ayahs by surah
    final Map<int, List<Ayah>> reviewSurahGroups = {};
    for (final a in _todayReviewAyahs) {
      reviewSurahGroups.putIfAbsent(a.surahNumber, () => []).add(a);
    }

    final firstReviewAyah = hasReviewWird ? _todayReviewAyahs.first : null;
    final lastReviewAyah = hasReviewWird ? _todayReviewAyahs.last : null;

    final String reviewWirdTitle;
    if (!hasReviewWird) {
      reviewWirdTitle = 'لا يوجد ورد ماضٍ محدد بعد';
    } else if (reviewSurahGroups.length == 1) {
      final sNum = reviewSurahGroups.keys.first;
      reviewWirdTitle = 'سورة ${_getSurahName(sNum)} — من الآية ${firstReviewAyah!.ayahNumber} إلى الآية ${lastReviewAyah!.ayahNumber}';
    } else {
      reviewWirdTitle = 'من سورة ${_getSurahName(firstReviewAyah!.surahNumber)} (${firstReviewAyah.ayahNumber}) إلى سورة ${_getSurahName(lastReviewAyah!.surahNumber)} (${lastReviewAyah.ayahNumber})';
    }

    // Target surah group for the main recitation button
    final firstReviewGroup = reviewSurahGroups.entries.firstOrNull;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _isReviewCompletedToday
              ? Colors.green.withValues(alpha: 0.4)
              : AppColors.goldAccent.withValues(alpha: 0.5),
        ),
      ),
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Header Row
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isReviewCompletedToday
                          ? Colors.green.withValues(alpha: 0.15)
                          : AppColors.goldAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isReviewCompletedToday ? Icons.verified_rounded : Icons.history_edu_rounded,
                          color: _isReviewCompletedToday ? Colors.green : AppColors.goldAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _isReviewCompletedToday
                                  ? 'تم تسميع ورد الماضي لليوم ✅'
                                  : 'ورد مراجعة الماضي (مطلوب التسميع 🎙️)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _isReviewCompletedToday ? Colors.green : (isDark ? Colors.amber[300] : const Color(0xFF8B6508)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    hasReviewWird
                        ? (reviewSurahGroups.length > 1
                            ? '$totalReviewAyahs آية (${reviewSurahGroups.length} سُوَر)'
                            : '$totalReviewAyahs آية مراجعة')
                        : '$totalMemAyahs آية محفوظة',
                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reviewWirdTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            if (firstReviewAyah != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black26 : Colors.amber.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '« ${firstReviewAyah.textUthmani} ... »',
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    height: 1.6,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (reviewSurahGroups.length > 1) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: reviewSurahGroups.entries.map((entry) {
                  final sNum = entry.key;
                  final aList = entry.value;
                  final sName = _getSurahName(sNum);
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _openReaderForMemorization(
                      sNum,
                      aList.first.ayahNumber,
                      aList.last.ayahNumber,
                      isReview: true,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isReviewCompletedToday
                            ? Colors.green.withValues(alpha: 0.12)
                            : AppColors.goldAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isReviewCompletedToday
                              ? Colors.green.withValues(alpha: 0.4)
                              : AppColors.goldAccent.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isReviewCompletedToday ? Icons.check_circle_rounded : Icons.mic_none_rounded,
                            size: 13,
                            color: _isReviewCompletedToday ? Colors.green : AppColors.goldAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$sName (${aList.first.ayahNumber}-${aList.last.ayahNumber})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _isReviewCompletedToday ? Colors.green : (isDark ? Colors.amber[300] : const Color(0xFF8B6508)),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '• ${aList.length}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),

            // Daily Past Review Count Adjuster
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'حدد عدد آيات ورد الماضي بحرية:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'المقرر لليوم: $totalReviewAyahs آية من أصل $totalMemAyahs',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded, size: 24),
                            color: AppColors.goldAccent,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'إنقاص آية',
                            onPressed: () {
                              if (totalReviewAyahs > 1) {
                                _updateCustomReviewCount(totalReviewAyahs - 1);
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 60,
                            height: 36,
                            child: TextFormField(
                              controller: _customReviewCountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              onFieldSubmitted: (val) {
                                final parsed = int.tryParse(val);
                                if (parsed != null && parsed > 0) {
                                  _updateCustomReviewCount(parsed);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
                            color: AppColors.goldAccent,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'زيادة آية',
                            onPressed: () {
                              if (totalReviewAyahs < totalMemAyahs) {
                                _updateCustomReviewCount(totalReviewAyahs + 1);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text('آيات', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Big Action Button for Past Review Recitation
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _isReviewCompletedToday ? const Color(0xFF2E7D32) : AppColors.goldAccent,
                foregroundColor: _isReviewCompletedToday ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: Icon(_isReviewCompletedToday ? Icons.refresh_rounded : Icons.mic_rounded, size: 18),
              label: Text(
                _isReviewCompletedToday
                    ? 'إعادة تسميع ورد الماضي في المصحف 🔄'
                    : (firstReviewGroup != null
                        ? 'ابدأ تسميع ورد الماضي (${_getSurahName(firstReviewGroup.key)} ${firstReviewGroup.value.first.ayahNumber}-${firstReviewGroup.value.last.ayahNumber}) 🎙️'
                        : 'ابدأ تسميع مراجعة الماضي 🎙️'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (firstReviewGroup != null) {
                  _openReaderForMemorization(
                    firstReviewGroup.key,
                    firstReviewGroup.value.first.ayahNumber,
                    firstReviewGroup.value.last.ayahNumber,
                    isReview: true,
                  );
                } else {
                  _openReaderForMemorization(
                    currentReviewSurah.surahNumber,
                    1,
                    currentReviewSurah.memorizedAyahsCount,
                    isReview: true,
                  );
                }
              },
            ),

            // Individual Surah Choice Chips
            if (memorizedSurahs.length > 1) ...[
              const SizedBox(height: 12),
              const Text(
                'أو اختر سورة معينة لتسميعها بشكل مستقل:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: memorizedSurahs.map((s) {
                  final isSelected = s.surahNumber == _selectedReviewSurahNumber;
                  return ChoiceChip(
                    label: Text('سورة ${s.surahNameArabic} (${s.memorizedAyahsCount})'),
                    selected: isSelected,
                    selectedColor: AppColors.goldAccent.withValues(alpha: 0.25),
                    backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? (isDark ? Colors.amber[300] : const Color(0xFF8B6508))
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedReviewSurahNumber = s.surahNumber);
                        _openReaderForMemorization(
                          s.surahNumber,
                          1,
                          s.memorizedAyahsCount,
                          isReview: true,
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSurahsList(bool isDark) {
    if (_surahsSummary.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            'سور الخطة المقررة:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: isDark ? AppColors.surfaceDark : Colors.white,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _surahsSummary.length,
            separatorBuilder: (ctx, i) => Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade100),
            itemBuilder: (ctx, index) {
              final surah = _surahsSummary[index];
              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: surah.isCompleted
                        ? Colors.green.withValues(alpha: 0.15)
                        : AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: surah.isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.green, size: 18)
                        : Text(
                            '${surah.surahNumber}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                  ),
                ),
                title: Text(
                  'سورة ${surah.surahNameArabic}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (surah.progressPercent / 100).clamp(0.0, 1.0),
                          minHeight: 5,
                          backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            surah.isCompleted ? Colors.green : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${surah.memorizedAyahsCount}/${surah.totalAyahsInPlan}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.download_for_offline_rounded, color: AppColors.goldAccent, size: 18),
                      tooltip: 'تحميل تلاوة سورة ${surah.surahNameArabic}',
                      onPressed: () => SurahDownloaderSheet.show(
                        context,
                        quranModule: widget.quranModule,
                        initialSurahNumber: surah.surahNumber,
                      ),
                    ),
                    if (surah.memorizedAyahsCount > 0)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.mic_rounded, color: AppColors.goldAccent, size: 18),
                        tooltip: 'تسميع ومراجعة سورة ${surah.surahNameArabic}',
                        onPressed: () => _openReaderForMemorization(
                          surah.surahNumber,
                          1,
                          surah.memorizedAyahsCount,
                          isReview: true,
                        ),
                      ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                  ],
                ),
                onTap: () => widget.onOpenSurah(surah.surahNumber),
              );
            },
          ),
        ),
      ],
    );
  }
}
