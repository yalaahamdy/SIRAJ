import 'package:flutter/material.dart';
import '../../../modules/companion/companion_module.dart';
import '../../../modules/companion/domain/daily_journey.dart';
import '../../../modules/companion/domain/dashboard_card.dart';
import '../routing/app_router.dart';
import '../theme/app_colors.dart';
import 'companion_preferences_screen.dart';
import 'federated_search_screen.dart';
import 'personal_goals_screen.dart';
import 'widgets/daily_journey_timeline.dart';
import 'widgets/home_hero_now_card.dart';

class HomeDashboardView extends StatefulWidget {
  final CompanionModule module;

  const HomeDashboardView({super.key, required this.module});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  List<DashboardCard> _cards = [];
  late DailyJourneyRoutine _routine;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _routine = widget.module.getDailyJourneyRoutine();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final res = await widget.module.getDashboardCards();
    if (mounted) {
      setState(() {
        if (res.isSuccess) {
          _cards = res.valueOrNull!;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final topNowCard = _cards.isNotEmpty ? _cards.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سِراج — الرفيق الحياتي الموحد',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'البحث الشامل',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FederatedSearchScreen(module: widget.module),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'تخصيص الواجهة',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompanionPreferencesScreen(module: widget.module),
                ),
              );
              _loadDashboard();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 1. Top Now / Context Hero Card
          if (topNowCard != null)
            HomeHeroNowCard(
              card: topNowCard,
              onTap: () {
                if (topNowCard.targetRoute != null) {
                  Navigator.pushNamed(context, topNowCard.targetRoute!);
                }
              },
            ),

          // 2. Daily Journey Timeline
          DailyJourneyTimeline(
            routine: _routine,
            onSlotTap: (slot) {
              if (slot.targetRoute != null) {
                Navigator.pushNamed(context, slot.targetRoute!);
              }
            },
          ),

          // 3. Goals Quick Access Banner
          Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final bannerBg = isDark ? const Color(0xFF262010) : Colors.amber.shade50;
              final bannerBorder = isDark ? const Color(0xFF5A4818) : Colors.amber.shade200;
              final bannerIconColor = isDark ? AppColors.goldAccentLight : Colors.amber.shade900;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bannerBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: bannerBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.track_changes, color: bannerIconColor),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'أهدافك الشخصية لليوم',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primaryText(context),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonalGoalsScreen(module: widget.module),
                          ),
                        );
                        _loadDashboard();
                      },
                      child: Text(
                        'إدارة الأهداف',
                        style: TextStyle(
                          color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'أقسام ومنصات سِراج الموثقة (M1..M10):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.primaryText(context),
              ),
            ),
          ),

          // 4. Quick Module Grid / List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildNavChip(
                  context,
                  title: 'الصلاة والقبلة',
                  icon: Icons.access_time_filled_rounded,
                  route: AppRouter.prayer,
                  color: AppColors.primaryAction(context),
                ),
                _buildNavChip(
                  context,
                  title: 'المصحف الشريف',
                  icon: Icons.menu_book_rounded,
                  route: AppRouter.quran,
                  color: AppColors.primaryAction(context),
                ),
                _buildNavChip(
                  context,
                  title: 'حفظ القرآن',
                  icon: Icons.psychology_rounded,
                  route: AppRouter.memorization,
                  color: const Color(0xFFD4AF37),
                ),
                _buildNavChip(
                  context,
                  title: 'الأذكار والأدعية',
                  icon: Icons.auto_stories_rounded,
                  route: AppRouter.adhkar,
                  color: const Color(0xFF20C997),
                ),
                _buildNavChip(
                  context,
                  title: 'حساب الزكاة',
                  icon: Icons.calculate_rounded,
                  route: AppRouter.zakat,
                  color: AppColors.primaryAction(context),
                ),
                _buildNavChip(
                  context,
                  title: 'الصيام وقضاء رمضان',
                  icon: Icons.nightlight_round,
                  route: AppRouter.fasting,
                  color: const Color(0xFF4DABF7),
                ),
                _buildNavChip(
                  context,
                  title: 'المعرفة والحديث',
                  icon: Icons.menu_book_sharp,
                  route: AppRouter.knowledge,
                  color: AppColors.primaryAction(context),
                ),
                _buildNavChip(
                  context,
                  title: 'المناهج والمسارات',
                  icon: Icons.school_rounded,
                  route: AppRouter.learning,
                  color: const Color(0xFF4DABF7),
                ),
                _buildNavChip(
                  context,
                  title: 'السيرة النبوية',
                  icon: Icons.history_edu,
                  route: AppRouter.seerah,
                  color: const Color(0xFFD4AF37),
                ),
                _buildNavChip(
                  context,
                  title: 'الحج والعمرة',
                  icon: Icons.mosque,
                  route: AppRouter.hajj,
                  color: AppColors.primaryAction(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 5. Start From Here — Guided Exploration Cards (§4)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.explore_rounded, size: 20, color: AppColors.primaryAction(context)),
                const SizedBox(width: 8),
                Text(
                  'ابدأ من هنا — الانطلاق الموجه في رحاب سِراج:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primaryText(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          _buildStartHereTile(
            context,
            title: 'المصحف الشريف: الفهرس الكنسي الكامل لـ 114 سورة',
            subtitle: 'تصفح سور القرآن والأجزاء الـ 30 وابدأ بقراءة سورة الفاتحة وجزء عم الموثق.',
            icon: Icons.menu_book_rounded,
            route: AppRouter.quran,
            color: AppColors.primaryAction(context),
          ),
          _buildStartHereTile(
            context,
            title: 'حصن المسلم: 35+ ذكراً ودعاءً مأثوراً',
            subtitle: 'تصفح أذكار الصباح والمساء والصلوات والنوم المخرجة من صحيحي البخاري ومسلم.',
            icon: Icons.auto_stories_rounded,
            route: AppRouter.adhkar,
            color: const Color(0xFF20C997),
          ),
          _buildStartHereTile(
            context,
            title: 'المناهج والمسارات: ابدأ مسار فقه الطهارة والوضوء',
            subtitle: 'دروس تفاعلية متسلسلة مع أهداف تعليمية وأدلة شرعية واختبارات قياس الفهم.',
            icon: Icons.school_rounded,
            route: AppRouter.learning,
            color: const Color(0xFF4DABF7),
          ),
          _buildStartHereTile(
            context,
            title: 'السيرة النبوية: الخط الزمني والأحداث الكبرى',
            subtitle: 'استكشف 12 حدثاً محورياً من المولد الشريف والبعثة والهجرة حتى حجة الوداع.',
            icon: Icons.history_edu,
            route: AppRouter.seerah,
            color: const Color(0xFFD4AF37),
          ),
          _buildStartHereTile(
            context,
            title: 'دليل الحج والعمرة: المواقيت والمشاعر وخطوات النسك',
            subtitle: 'تصفح مواقيت الإحرام الستة، وخطوات الحج الـ 12 ومناسك العمرة السبعة كاملة.',
            icon: Icons.mosque,
            route: AppRouter.hajj,
            color: AppColors.primaryAction(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavChip(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText(context),
        ),
      ),
      backgroundColor: AppColors.cardBackground(context),
      side: BorderSide(color: AppColors.border(context)),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }

  Widget _buildStartHereTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.border(context)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText(context)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_left, size: 20),
          onTap: () => Navigator.pushNamed(context, route),
        ),
      ),
    );
  }
}
