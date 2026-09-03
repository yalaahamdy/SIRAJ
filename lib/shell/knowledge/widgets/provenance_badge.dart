import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';

/// Provenance & Authenticity badge with distinct grading colors (§10, §45).
class ProvenanceBadge extends StatelessWidget {
  final HadithGrade grade;
  final String? scholarName;

  const ProvenanceBadge({
    super.key,
    required this.grade,
    this.scholarName,
  });

  Color _getBadgeColor() {
    switch (grade) {
      case HadithGrade.mutawatir:
      case HadithGrade.sahih:
        return const Color(0xFF0F5132); // Emerald Green
      case HadithGrade.hasan:
        return const Color(0xFF198754); // Green
      case HadithGrade.daeef:
        return Colors.orange.shade800;
      case HadithGrade.mawdoo:
        return Colors.red.shade800;
      case HadithGrade.unverified:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor();
    final label = scholarName != null && scholarName!.isNotEmpty
        ? '${grade.labelArabic} • $scholarName'
        : grade.labelArabic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
