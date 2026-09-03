import 'package:flutter/material.dart';
import '../modules/companion/companion_module.dart';
import 'companion/companion_preferences_screen.dart';
import 'companion/federated_search_screen.dart';
import 'routing/app_router.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';

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
        ],
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
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        onTap: onTap ?? (route != null ? () => Navigator.pushNamed(context, route) : null),
      ),
    );
  }
}
