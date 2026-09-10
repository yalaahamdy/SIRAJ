import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/moral_lesson.dart';

/// Card presenting educational and moral reflection segregated from historical fact (§15, §16, §37).
class MoralLessonCard extends StatelessWidget {
  final MoralLesson lesson;

  const MoralLessonCard({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);
    final titleColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF0F5132);
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final bgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF6FAF7);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: accent.withAlpha(isDark ? 90 : 60),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 35 : 10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withAlpha(isDark ? 40 : 25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: accent.withAlpha(isDark ? 120 : 90),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wb_incandescent_outlined,
                      size: 14,
                      color: accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'استنباط تربوي',
                      style: TextStyle(
                        fontSize: 11,
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (lesson.sourceOrScholar != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 13,
                      color: subColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lesson.sourceOrScholar!,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: subColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'العبرة والمقصد: ${lesson.themeArabic}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: titleColor,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lesson.lessonText,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.65,
              color: bodyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
