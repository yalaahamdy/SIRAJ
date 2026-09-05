import 'package:flutter/material.dart';
import '../../../modules/memorization/domain/mastery_snapshot.dart';
import '../../../modules/memorization/domain/memorization_plan.dart';
import '../../../modules/memorization/domain/review_session.dart';
import '../../../modules/memorization/memorization_module.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';
import 'widgets/mastery_stat_card.dart';

/// Main Dashboard screen for Quran Memorization, Goals, and Daily Reviews (§38).
class MemorizationDashboardScreen extends StatefulWidget {
  final MemorizationModule memorizationModule;
  final VoidCallback onStartSession;
  final VoidCallback onOpenPlanSetup;

  const MemorizationDashboardScreen({
    super.key,
    required this.memorizationModule,
    required this.onStartSession,
    required this.onOpenPlanSetup,
  });

  @override
  State<MemorizationDashboardScreen> createState() => _MemorizationDashboardScreenState();
}

class _MemorizationDashboardScreenState extends State<MemorizationDashboardScreen> {
  MasterySnapshot? _snapshot;
  MemorizationPlan? _plan;
  ReviewSession? _session;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    await widget.memorizationModule.initialize();
    final snapRes = await widget.memorizationModule.getMasterySnapshot();
    final planRes = await widget.memorizationModule.getPlan();
    final sessionRes = await widget.memorizationModule.getOrCreateTodaySession();

    setState(() {
      _snapshot = snapRes.valueOrNull;
      _plan = planRes.valueOrNull;
      _session = sessionRes.valueOrNull;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('حفظ ومراجعة القرآن الكريم'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'إعدادات الخطة',
            onPressed: widget.onOpenPlanSetup,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingStateView()
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Streak / Consistency Banner
                        _buildStreakBanner(context, isDark),

                        // Grid Metrics
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.m),
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: AppSpacing.s,
                            crossAxisSpacing: AppSpacing.s,
                            childAspectRatio: MediaQuery.of(context).textScaler.scale(1) > 1.2 ? 1.4 : 1.7,
                            children: [
                              MasteryStatCard(
                                title: 'مستحق للمراجعة',
                                value: '${_session?.reviewAyahs.length ?? 0}',
                                icon: Icons.schedule_rounded,
                                color: AppColors.warning,
                              ),
                              MasteryStatCard(
                                title: 'جديد اليوم',
                                value: '${_session?.newAyahs.length ?? 0}',
                                icon: Icons.fiber_new_rounded,
                                color: AppColors.primaryLight,
                              ),
                              MasteryStatCard(
                                title: 'المحفوظ والمتقن',
                                value: '${_snapshot?.totalCompletedAyahs ?? 0}',
                                icon: Icons.verified_rounded,
                                color: Colors.green,
                              ),
                              MasteryStatCard(
                                title: 'درجة الإتقان',
                                value: '${_snapshot?.overallMasteryPercent.toStringAsFixed(0) ?? 0}%',
                                icon: Icons.trending_up_rounded,
                                color: isDark ? AppColors.goldAccent : AppColors.primary,
                              ),
                            ],
                          ),
                        ),

                        // Start / Resume Session Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
                            ),
                            onPressed: widget.onStartSession,
                            icon: const Icon(Icons.play_arrow_rounded, size: 28),
                            label: Text(
                              _session != null && _session!.results.isNotEmpty && !_session!.isCompleted
                                  ? 'استئناف جلسة اليوم (${_session!.completedCount}/${_session!.totalItemsCount})'
                                  : 'بدء جلسة الحفظ والمراجعة اليومية',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),

                        // Active Plan Card
                        _buildPlanCard(context, isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStreakBanner(BuildContext context, bool isDark) {
    final streak = _snapshot?.currentStreakDays ?? 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      color: isDark ? AppColors.surfaceDark : AppColors.primaryLight.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMedium),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_fire_department_rounded, color: AppColors.goldAccent, size: 28),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الالتزام اليومي المستمر',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    streak > 0 ? '$streak أيام متتالية من المراجعة والتعلم' : 'ابدأ جلستك اليوم لبناء سلسلة التزام مباركة',
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

  Widget _buildPlanCard(BuildContext context, bool isDark) {
    final plan = _plan;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'الخطة المستهدفة',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: widget.onOpenPlanSetup,
                  child: const Text('تعديل الخطة'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              plan?.title ?? 'حفظ جزء عم (خطة افتراضية)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.goldAccent : AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            ClipRRect(
              borderRadius: AppRadius.radiusSmall,
              child: LinearProgressIndicator(
                value: (_snapshot?.completionRate ?? 0) / 100,
                minHeight: 8,
                backgroundColor: isDark ? Colors.white10 : Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  'نسبة الإنجاز: ${_snapshot?.completionRate.toStringAsFixed(1) ?? 0}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'المستهدف اليومي: ${plan?.dailyNewAyahs ?? 5} آيات',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
