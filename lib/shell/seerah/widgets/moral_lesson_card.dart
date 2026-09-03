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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9F5),
        border: Border.all(color: const Color(0xFF0F5132).withAlpha(40)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'العبرة والمقصد: ${lesson.themeArabic}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F5132),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F5132).withAlpha(15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'استنباط تربوي',
                  style: TextStyle(fontSize: 10, color: Color(0xFF0F5132), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            lesson.lessonText,
            style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
          ),
          if (lesson.sourceOrScholar != null) ...[
            const SizedBox(height: 4),
            Text(
              'المستنبط: ${lesson.sourceOrScholar!}',
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
