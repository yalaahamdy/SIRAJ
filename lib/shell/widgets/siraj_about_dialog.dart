import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'siraj_app_logo.dart';

/// نافذة "حول سِراج" التعريفية الرسمية متضمنة الشعار والهوية المعتمدة
void showSirajAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => const SirajAboutDialog(),
  );
}

class SirajAboutDialog extends StatelessWidget {
  const SirajAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Logo with shadow
              const SirajAppLogo(
                size: 64,
                showBorder: true,
                showShadow: true,
              ),
              const SizedBox(height: 12),

              // 2. App Name & Version
              const Text(
                'سِراج — SIRAJ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'الإصدار 1.0.0 (النسخة المستقرة المعيارية)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Guarantee Badges
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  _buildBadge(
                    icon: Icons.wifi_off_rounded,
                    label: 'أوفلاين 100%',
                    color: const Color(0xFF0F5132),
                  ),
                  _buildBadge(
                    icon: Icons.verified_user_rounded,
                    label: 'انعدام التتبع',
                    color: const Color(0xFF1E3A8A),
                  ),
                  _buildBadge(
                    icon: Icons.verified_rounded,
                    label: 'أدلة موثقة',
                    color: const Color(0xFF856404),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Description Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: const Text(
                  'سِراج هو رفيقك الحياتي الموحد، صُمم بعناية لخدمة المسلم في شتى عباداته اليومية: القرآن الكريم بالرسم العثماني، الأذكار، مواقيت الصلاة والقبلة، السيرة النبوية الشاملة، الفقه والحديث، الزكاة، الصيام، والحج والعمرة، مع صون تام لقدسية النصوص وخصوصية المستخدم.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),

              // 5. Close action
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
