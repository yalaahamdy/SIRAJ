import 'package:flutter/material.dart';
import '../../../../modules/memorization/domain/mastery_snapshot.dart';
import '../../../../modules/memorization/domain/memorization_plan.dart';
import '../../../../modules/memorization/domain/review_session.dart';
import '../../../../modules/memorization/memorization_module.dart';
import '../../../../modules/memorization/services/past_memorization_engine.dart';
import '../../../../modules/quran/domain/ayah_key.dart';
import '../../../../modules/quran/quran_module.dart';
import '../../memorization/past_memorization_exam_screen.dart';
import '../../memorization/plan_setup_screen.dart';
import '../../memorization/study_session_screen.dart';
import '../../memorization/widgets/mastery_stat_card.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/state_views.dart';

/// Comprehensive Quran Memorization & Review Hub Tab (تبويبة تحفيظ القرآن الكريم والمراجعة).
/// Replaces the legacy static Juzs tab with a rich, interactive learning experience (§38, §50..§55).
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
  MasterySnapshot? _snapshot;
  MemorizationPlan? _plan;
  ReviewSession? _session;
  PastMasteryStats? _pastStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTahfeezData();
  }

  Future<void> _loadTahfeezData() async {
    setState(() => _isLoading = true);

    await widget.memorizationModule.initialize();
    final snapRes = await widget.memorizationModule.getMasterySnapshot();
    final planRes = await widget.memorizationModule.getPlan();
    final sessionRes = await widget.memorizationModule.getOrCreateTodaySession();
    final pastRes = await widget.memorizationModule.getPastMasteryStats();

    if (mounted) {
      setState(() {
        _snapshot = snapRes.valueOrNull;
        _plan = planRes.valueOrNull;
        _session = sessionRes.valueOrNull;
        _pastStats = pastRes.valueOrNull;
        _isLoading = false;
      });
    }
  }

  void _openPlanSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PlanSetupScreen(
          memorizationModule: widget.memorizationModule,
          onSaved: () {
            Navigator.pop(ctx);
            _loadTahfeezData();
          },
        ),
      ),
    );
  }

  void _startStudySession() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => StudySessionScreen(
          memorizationModule: widget.memorizationModule,
          onFinish: () {
            Navigator.pop(context);
            _loadTahfeezData();
          },
        ),
      ),
    );
  }

  void _startPastExam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PastMemorizationExamScreen(
          memorizationModule: widget.memorizationModule,
          quranModule: widget.quranModule,
          onFinished: () {
            Navigator.pop(context);
            _loadTahfeezData();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const LoadingStateView();
    }

    return RefreshIndicator(
      onRefresh: _loadTahfeezData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Streak & Header Banner
                _buildHeaderBanner(context, isDark),
                const SizedBox(height: AppSpacing.s),

                // 2. Metrics Grid (4 Stat Cards)
                _buildMetricsGrid(context, isDark),
                const SizedBox(height: AppSpacing.m),

                // 3. Active Plan Card
                _buildPlanCard(context, isDark),
                const SizedBox(height: AppSpacing.m),

                // 4. Dedicated Past Memorization Confirmation Card
                _buildPastMemorizationMasteryCard(context, isDark),
                const SizedBox(height: AppSpacing.m),

                // 5. Today's Three-Tier Wird Card
                _buildDailyWirdCard(context, isDark),
                const SizedBox(height: AppSpacing.m),

                // 6. Start Full Session Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                    elevation: 2,
                  ),
                  onPressed: _startStudySession,
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 28),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _session != null && _session!.results.isNotEmpty && !_session!.isCompleted
                          ? 'استئناف جلسة اليوم (${_session!.completedCount}/${_session!.totalItemsCount})'
                          : 'بدء جلسة الحفظ والمراجعة اليومية',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context, bool isDark) {
    final streak = _snapshot?.currentStreakDays ?? 0;
    return Card(
      elevation: 0,
      color: isDark ? AppColors.surfaceDark : AppColors.primaryLight.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_fire_department_rounded, color: AppColors.goldAccent, size: 30),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'برنامج تحفيظ وتثبيت القرآن الكريم',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    streak > 0 ? '$streak أيام متتالية من الالتزام والمراجعة المباركة' : 'ابدأ جلستك اليوم لبناء عادة حفظ يومية مستمرة',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.s,
      crossAxisSpacing: AppSpacing.s,
      childAspectRatio: screenWidth < 400 ? 1.35 : (screenWidth < 600 ? 1.45 : 1.7),
      children: [
        MasteryStatCard(
          title: 'ورد جديد اليوم',
          value: '${_session?.newAyahs.length ?? 0} آيات',
          icon: Icons.fiber_new_rounded,
          color: AppColors.primaryLight,
        ),
        MasteryStatCard(
          title: 'مستحق للمراجعة',
          value: '${_session?.reviewAyahs.length ?? 0} آيات',
          icon: Icons.schedule_rounded,
          color: AppColors.warning,
        ),
        MasteryStatCard(
          title: 'المحفوظ والمتقن',
          value: '${_snapshot?.totalCompletedAyahs ?? 0} آية',
          icon: Icons.verified_rounded,
          color: Colors.green,
        ),
        MasteryStatCard(
          title: 'تمكين حفظ الماضي',
          value: '${_pastStats?.masteryPercentage.toStringAsFixed(0) ?? 100}%',
          icon: Icons.workspace_premium_rounded,
          color: AppColors.goldAccent,
        ),
      ],
    );
  }

  Widget _buildPlanCard(BuildContext context, bool isDark) {
    final plan = _plan;
    final completion = _snapshot?.completionRate ?? 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'خطة التحفيظ المستهدفة',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: const Text('تخصيص الخطة'),
                  onPressed: _openPlanSetup,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              plan?.title ?? 'حفظ جزء عم (خطة افتراضية)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? AppColors.goldAccent : AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            ClipRRect(
              borderRadius: AppRadius.radiusSmall,
              child: LinearProgressIndicator(
                value: (completion / 100).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: isDark ? Colors.white10 : Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('نسبة الإنجاز: ${completion.toStringAsFixed(1)}%', style: Theme.of(context).textTheme.bodySmall),
                Text('المستهدف اليومي: ${plan?.dailyNewAyahs ?? 5} آيات', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastMemorizationMasteryCard(BuildContext context, bool isDark) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMedium,
        side: BorderSide(color: AppColors.goldAccent.withValues(alpha: 0.5), width: 1.5),
      ),
      color: isDark ? AppColors.surfaceDark : Colors.amber.withValues(alpha: 0.07),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.verified_rounded, color: AppColors.goldAccent, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نظام تسميع واختبار (الماضي) — لتأكيد الحفظ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'امتحن استحضار محفوظك السابق غيباً لمنع التفلت وتأكيد التمكين',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.goldAccent : AppColors.primary,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSmall),
                    ),
                    icon: const Icon(Icons.record_voice_over_rounded),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'بدء اختبار وتسميع الماضي الآن 🌟',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: _startPastExam,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyWirdCard(BuildContext context, bool isDark) {
    final session = _session;
    final newAyahs = session?.newAyahs ?? [];
    final reviewAyahs = session?.reviewAyahs ?? [];
    final weakAyahs = session?.weakAyahs ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'أوراد الحفظ والمراجعة لليوم',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            _buildWirdSection(
              title: '1. ورد الحفظ الجديد (السبق)',
              subtitle: newAyahs.isNotEmpty
                  ? '${newAyahs.length} آيات مقررة للتعلم والحفظ غيباً اليوم'
                  : 'تم إنجاز آيات الحفظ الجديد لليوم بحمد الله',
              ayahKeys: newAyahs,
              badgeColor: Colors.green,
              isDark: isDark,
            ),
            const Divider(height: 24),
            _buildWirdSection(
              title: '2. ورد المراجعة الصغرى (مراجعة القريب)',
              subtitle: reviewAyahs.isNotEmpty
                  ? '${reviewAyahs.length} آيات مستحقة للتثبيت والمراجعة'
                  : 'لا توجد آيات مستحقة للمراجعة حالياً',
              ayahKeys: reviewAyahs,
              badgeColor: AppColors.primary,
              isDark: isDark,
            ),
            if (weakAyahs.isNotEmpty) ...[
              const Divider(height: 24),
              _buildWirdSection(
                title: '3. ورد تثبيت المتشابهات والمواضع المتعثرة',
                subtitle: '${weakAyahs.length} آيات تحتاج إلى تركيز وتكرار إضافي',
                ayahKeys: weakAyahs,
                badgeColor: AppColors.warning,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWirdSection({
    required String title,
    required String subtitle,
    required List<AyahKey> ayahKeys,
    required Color badgeColor,
    required bool isDark,
  }) {
    AyahKey? firstKey = ayahKeys.isNotEmpty ? ayahKeys.first : null;
    final surahRes = firstKey != null ? widget.memorizationModule.quranStore.getSurah(firstKey.surahNumber) : null;
    final surahName = surahRes?.isSuccess == true ? surahRes!.valueOrNull?.nameArabic : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (firstKey != null) ...[
              const SizedBox(width: 8),
              TextButton.icon(
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                label: const Text('فتح في المصحف', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  widget.onOpenSurah(firstKey.surahNumber, targetAyah: firstKey.ayahNumber);
                },
              ),
            ],
          ],
        ),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        if (firstKey != null && surahName != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'سورة $surahName — الآيات: ${ayahKeys.first.ayahNumber} إلى ${ayahKeys.last.ayahNumber}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: badgeColor),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
