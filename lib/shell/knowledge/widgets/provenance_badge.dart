import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';

/// Provenance & Authenticity badge with high-contrast grading colors and theme awareness (§10, §45).
class ProvenanceBadge extends StatelessWidget {
  final HadithGrade grade;
  final String? scholarName;

  const ProvenanceBadge({
    super.key,
    required this.grade,
    this.scholarName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color border;
    Color text;

    switch (grade) {
      case HadithGrade.mutawatir:
      case HadithGrade.sahih:
        bg = isDark ? const Color(0xFF143823) : const Color(0xFFE8F5E9);
        border = isDark ? const Color(0xFF22C55E) : const Color(0xFF2E7D32);
        text = isDark ? const Color(0xFF86EFAC) : const Color(0xFF1B5E20);
        break;
      case HadithGrade.hasan:
        bg = isDark ? const Color(0xFF1C3829) : const Color(0xFFF0FDF4);
        border = isDark ? const Color(0xFF4ADE80) : const Color(0xFF388E3C);
        text = isDark ? const Color(0xFFBBF7D0) : const Color(0xFF166534);
        break;
      case HadithGrade.daeef:
        bg = isDark ? const Color(0xFF3B2510) : const Color(0xFFFFF7ED);
        border = isDark ? const Color(0xFFF97316) : const Color(0xFFEA580C);
        text = isDark ? const Color(0xFFFED7AA) : const Color(0xFF9A3412);
        break;
      case HadithGrade.mawdoo:
        bg = isDark ? const Color(0xFF3D1418) : const Color(0xFFFEF2F2);
        border = isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
        text = isDark ? const Color(0xFFFECACA) : const Color(0xFF991B1B);
        break;
      case HadithGrade.unverified:
        bg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
        border = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
        text = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155);
        break;
    }

    final label = scholarName != null && scholarName!.isNotEmpty
        ? '${grade.labelArabic} • $scholarName'
        : grade.labelArabic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
