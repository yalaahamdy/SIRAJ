import 'package:flutter/material.dart';
import '../modules/companion/companion_module.dart';
import 'companion/companion_preferences_screen.dart';
import 'companion/federated_search_screen.dart';
import 'routing/app_router.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_theme_controller.dart';
import 'widgets/siraj_app_logo.dart';
import 'widgets/siraj_about_dialog.dart';

/// Screen representing Tab 5 (Knowledge & More / المعرفة والمزيد) in V1 App Shell (§6, §13, §14).
class V1MoreHomeScreen extends StatelessWidget {
  final CompanionModule companionModule;

  const V1MoreHomeScreen({
    super.key,
    required this.companionModule,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المعرفة والمزيد'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'البحث الشامل',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FederatedSearchScreen(module: companionModule),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'الإعدادات والخصوصية',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompanionPreferencesScreen(module: companionModule),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.paddingScreen,
        children: [
          // 0. App Identity Hero Card
          Card(
            elevation: 0,
            color: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: const Color(0xFFDAA520).withValues(alpha: 0.4), width: 1.2),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => showSirajAboutDialog(context),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const SirajAppLogo(
                      size: 54,
                      showShadow: false,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'سِراج — SIRAJ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDAA520).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFDAA520).withValues(alpha: 0.5)),
                                ),
                                child: const Text(
                                  'v1.0.0',
                                  style: TextStyle(
                                    color: Color(0xFFDAA520),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'المنظومة الإسلامية الشاملة والموثقة',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFDAA520),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          // 1. Search Entry Banner
          Card(
            elevation: 0,
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FederatedSearchScreen(module: companionModule),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'ابحث في القرآن، الحديث، الفقه، والسيرة...',
                        style: TextStyle(fontSize: 14, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          // 2. Sections
          const Text(
            'منظومة المعرفة الإسلامية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.s),

          _buildTile(
            context,
            icon: Icons.school_rounded,
            title: 'مسارات التعلم المنهجي',
            subtitle: 'دورات ودروس تفاعلية في العلوم الشرعية',
            color: const Color(0xFF1E3A8A),
            route: AppRouter.learning,
          ),
          _buildTile(
            context,
            icon: Icons.history_edu_rounded,
            title: 'السيرة النبوية الشريفة',
            subtitle: 'خط زمني تسلسلي لأحداث العهدين المكي والمدني',
            color: const Color(0xFF856404),
            route: AppRouter.seerah,
          ),
          _buildTile(
            context,
            icon: Icons.menu_book_rounded,
            title: 'الفقه المقارن والحديث النبوي',
            subtitle: 'مسائل المذاهب الأربعة وأحاديث الأحكام المعتمدة',
            color: AppColors.primary,
            route: AppRouter.knowledge,
          ),
          _buildTile(
            context,
            icon: Icons.psychology_rounded,
            title: 'حفظ ومراجعة القرآن الكريم',
            subtitle: 'برنامج التكرار المتباعد وجلسات الحفظ اليومية',
            color: AppColors.goldAccent,
            route: AppRouter.memorization,
          ),

          const SizedBox(height: AppSpacing.m),
          const Text(
            'الشعائر والعبادات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.s),

          _buildTile(
            context,
            icon: Icons.nightlight_round,
            title: 'الصيام وقضاء رمضان',
            subtitle: 'متابعة صيام النوافل وجدول قضاء الأيام الفائتة',
            color: const Color(0xFF1E3A8A),
            route: AppRouter.fasting,
          ),
          _buildTile(
            context,
            icon: Icons.calculate_rounded,
            title: 'حاسبة الزكاة الشرعية',
            subtitle: 'احتساب زكاة المال، الذهب، والأنصبة المعتمدة',
            color: AppColors.primary,
            route: AppRouter.zakat,
          ),
          _buildTile(
            context,
            icon: Icons.mosque_rounded,
            title: 'دليل مناسك الحج والعمرة',
            subtitle: 'إرشادات تفاعلية خطوة بخطوة للأعمال والميقات',
            color: const Color(0xFF1B4D3E),
            route: AppRouter.hajj,
          ),

          const SizedBox(height: AppSpacing.m),
          const Text(
            'الإعدادات والخصوصية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.s),

          _buildTile(
            context,
            icon: Icons.shield_rounded,
            title: 'تفضيلات الخصوصية والنسخ المحلي',
            subtitle: 'حظر التتبع وإدارة التخزين المحلي والنسخ الاحتياطي',
            color: Colors.blueGrey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompanionPreferencesScreen(module: companionModule),
                ),
              );
            },
          ),
          _buildTile(
            context,
            icon: Icons.palette_outlined,
            title: 'مظهر التطبيق (فاتح / داكن)',
            subtitle: 'الوضع الحالي: ${AppThemeController.getLabelArabic(AppThemeController.instance.themeMode)}',
            color: const Color(0xFF1E3A8A),
            onTap: () => _showThemeDialog(context),
          ),
          _buildTile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'حول سِراج وميثاق المنظومة',
            subtitle: 'رسالة المنظومة، التوثيق الشرعي، والعمل بدون إنترنت 100%',
            color: const Color(0xFF856404),
            onTap: () => showSirajAboutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('اختيار مظهر التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            final isSelected = AppThemeController.instance.themeMode == mode;
            return ListTile(
              leading: Icon(
                AppThemeController.getIcon(mode),
                color: isSelected ? AppColors.primary : null,
              ),
              title: Text(
                AppThemeController.getLabelArabic(mode),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                AppThemeController.instance.setThemeMode(mode);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    String? route,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0.5,
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: isDark ? 0.22 : 0.12),
          child: Icon(icon, color: isDark ? AppColors.goldAccentLight : color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFFCBD5E1) : Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isDark ? Colors.grey.shade400 : Colors.grey,
        ),
        onTap: onTap ?? (route != null ? () => Navigator.pushNamed(context, route) : null),
      ),
    );
  }
}
