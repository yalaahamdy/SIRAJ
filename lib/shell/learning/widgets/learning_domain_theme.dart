import 'package:flutter/material.dart';

/// Design tokens, gradients, and icon themes for the 12 Islamic Knowledge Domains (§4, §26).
class LearningDomainTheme {
  final String categoryName;
  final String shortTitle;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final LinearGradient gradient;
  final Color chipBackgroundColor;

  const LearningDomainTheme({
    required this.categoryName,
    required this.shortTitle,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gradient,
    required this.chipBackgroundColor,
  });

  static const defaultTheme = LearningDomainTheme(
    categoryName: 'عام',
    shortTitle: 'المنهج العام',
    icon: Icons.school_outlined,
    primaryColor: Color(0xFF0F5132),
    secondaryColor: Color(0xFF198754),
    gradient: LinearGradient(
      colors: [Color(0xFF0F5132), Color(0xFF198754)],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ),
    chipBackgroundColor: Color(0xFFE8F5E9),
  );

  static final Map<String, LearningDomainTheme> _themes = {
    // 1. فقه العبادات
    'فقه العبادات': const LearningDomainTheme(
      categoryName: 'فقه العبادات',
      shortTitle: 'العبادات والطهارة',
      icon: Icons.water_drop_outlined,
      primaryColor: Color(0xFF047857),
      secondaryColor: Color(0xFF059669),
      gradient: LinearGradient(
        colors: [Color(0xFF064E3B), Color(0xFF047857)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFD1FAE5),
    ),

    // 2. العقيدة الإسلامية
    'العقيدة الإسلامية': const LearningDomainTheme(
      categoryName: 'العقيدة الإسلامية',
      shortTitle: 'العقيدة والإيمان',
      icon: Icons.lightbulb_outline,
      primaryColor: Color(0xFF1D4ED8),
      secondaryColor: Color(0xFF2563EB),
      gradient: LinearGradient(
        colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFDBEAFE),
    ),

    // 3. علوم القرآن والتفسير
    'علوم القرآن والتفسير': const LearningDomainTheme(
      categoryName: 'علوم القرآن والتفسير',
      shortTitle: 'القرآن والتفسير',
      icon: Icons.menu_book_outlined,
      primaryColor: Color(0xFF0D9488),
      secondaryColor: Color(0xFF14B8A6),
      gradient: LinearGradient(
        colors: [Color(0xFF134E4A), Color(0xFF0D9488)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFCCFBF1),
    ),

    // 4. علوم الحديث والسنة
    'علوم الحديث والسنة': const LearningDomainTheme(
      categoryName: 'علوم الحديث والسنة',
      shortTitle: 'الحديث ومصطلحه',
      icon: Icons.record_voice_over_outlined,
      primaryColor: Color(0xFF475569),
      secondaryColor: Color(0xFF64748B),
      gradient: LinearGradient(
        colors: [Color(0xFF1E293B), Color(0xFF475569)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFE2E8F0),
    ),

    // 5. السيرة النبوية والتاريخ الإسلامي
    'السيرة النبوية والتاريخ الإسلامي': const LearningDomainTheme(
      categoryName: 'السيرة النبوية والتاريخ الإسلامي',
      shortTitle: 'السيرة والشمائل',
      icon: Icons.history_edu_outlined,
      primaryColor: Color(0xFFB45309),
      secondaryColor: Color(0xFFD97706),
      gradient: LinearGradient(
        colors: [Color(0xFF78350F), Color(0xFFB45309)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFFEF3C7),
    ),

    // 6. فقه المعاملات والاقتصاد الإسلامي
    'فقه المعاملات والاقتصاد الإسلامي': const LearningDomainTheme(
      categoryName: 'فقه المعاملات والاقتصاد الإسلامي',
      shortTitle: 'المعاملات والمالية',
      icon: Icons.account_balance_outlined,
      primaryColor: Color(0xFF15803D),
      secondaryColor: Color(0xFF16A34A),
      gradient: LinearGradient(
        colors: [Color(0xFF14532D), Color(0xFF15803D)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFDCFCE7),
    ),

    // 7. فقه الأسرة والمجتمع والأخلاق
    'فقه الأسرة والمجتمع والأخلاق': const LearningDomainTheme(
      categoryName: 'فقه الأسرة والمجتمع والأخلاق',
      shortTitle: 'الأسرة والمجتمع',
      icon: Icons.family_restroom_outlined,
      primaryColor: Color(0xFF7C3AED),
      secondaryColor: Color(0xFF8B5CF6),
      gradient: LinearGradient(
        colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFEDE9FE),
    ),

    // 8. السياسة الشرعية والقضاء وحقوق الإنسان
    'السياسة الشرعية والقضاء وحقوق الإنسان': const LearningDomainTheme(
      categoryName: 'السياسة الشرعية والقضاء وحقوق الإنسان',
      shortTitle: 'السياسة والقضاء',
      icon: Icons.gavel_outlined,
      primaryColor: Color(0xFF334155),
      secondaryColor: Color(0xFF475569),
      gradient: LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF334155)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFF1F5F9),
    ),

    // 9. النوازل الطبية والأخلاقيات الحيوية والبيئة
    'النوازل الطبية والأخلاقيات الحيوية والبيئة': const LearningDomainTheme(
      categoryName: 'النوازل الطبية والأخلاقيات الحيوية والبيئة',
      shortTitle: 'الطب والبيئة',
      icon: Icons.health_and_safety_outlined,
      primaryColor: Color(0xFF0E7490),
      secondaryColor: Color(0xFF06B6D4),
      gradient: LinearGradient(
        colors: [Color(0xFF164E63), Color(0xFF0E7490)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFCFFAFE),
    ),

    // 10. تاريخ الفقه والمذاهب والاجتهاد
    'تاريخ الفقه والمذاهب والاجتهاد': const LearningDomainTheme(
      categoryName: 'تاريخ الفقه والمذاهب والاجتهاد',
      shortTitle: 'المذاهب وتراجم الأئمة',
      icon: Icons.auto_stories_outlined,
      primaryColor: Color(0xFF854D0E),
      secondaryColor: Color(0xFFA16207),
      gradient: LinearGradient(
        colors: [Color(0xFF713F12), Color(0xFF854D0E)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFFEF9C3),
    ),

    // 11. علوم اللغة العربية والبيان القرآني
    'علوم اللغة العربية والبيان القرآني': const LearningDomainTheme(
      categoryName: 'علوم اللغة العربية والبيان القرآني',
      shortTitle: 'اللسان العربي والبيان',
      icon: Icons.border_color_outlined,
      primaryColor: Color(0xFFBE123C),
      secondaryColor: Color(0xFFE11D48),
      gradient: LinearGradient(
        colors: [Color(0xFF881337), Color(0xFFBE123C)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFFFE4E6),
    ),

    // 12. مقاصد الشريعة وفلسفة التشريع
    'مقاصد الشريعة وفلسفة التشريع': const LearningDomainTheme(
      categoryName: 'مقاصد الشريعة وفلسفة التشريع',
      shortTitle: 'مقاصد الشريعة والأولويات',
      icon: Icons.explore_outlined,
      primaryColor: Color(0xFF6B21A8),
      secondaryColor: Color(0xFF9333EA),
      gradient: LinearGradient(
        colors: [Color(0xFF3B0764), Color(0xFF6B21A8)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      chipBackgroundColor: Color(0xFFF3E8FF),
    ),
  };

  static LearningDomainTheme ofCategory(String category) {
    return _themes[category] ?? defaultTheme;
  }

  static List<String> getAllCategories() {
    return _themes.keys.toList();
  }
}
