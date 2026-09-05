import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import 'provenance_badge.dart';

/// Card widget displaying canonical Hadith text, collection info, and grading badges with high-contrast accessibility (§9, §45).
class HadithCard extends StatelessWidget {
  final HadithEntity hadith;
  final VoidCallback? onTap;

  const HadithCard({
    super.key,
    required this.hadith,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
    final headerColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);
    final matnColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final chapterColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Book, Number, and Grading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_outline, size: 16, color: headerColor),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${hadith.bookName} • حديث ${hadith.primaryNumber}',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: headerColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hadith.gradings.isNotEmpty)
                      ProvenanceBadge(
                        grade: hadith.gradings.first.grade,
                        scholarName: hadith.gradings.first.scholarName,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2. Canonical Arabic Matn (High Contrast & Amiri Font)
                Text(
                  hadith.arabicMatn,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 17.5,
                    height: 1.95,
                    fontWeight: FontWeight.w600,
                    color: matnColor,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),

                // 3. Footer: Chapter tag if available
                if (hadith.chapterName != null && hadith.chapterName!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF141F18) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark ? const Color(0xFF26382D) : const Color(0xFF94A3B8),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.folder_open_outlined, size: 14, color: chapterColor),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'باب: ${hadith.chapterName}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: chapterColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
