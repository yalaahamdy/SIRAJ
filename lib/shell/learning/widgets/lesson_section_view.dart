import 'package:flutter/material.dart';
import '../../../modules/learning/domain/learning_content_type.dart';
import '../../../modules/learning/domain/lesson_section.dart';
import 'evidence_citation_box.dart';

/// Card widget rendering a distinct lesson section with visual differentiation (§6, §11, §45).
class LessonSectionView extends StatelessWidget {
  final LessonSection section;

  const LessonSectionView({
    super.key,
    required this.section,
  });

  Color _getSectionBorderColor() {
    switch (section.contentType) {
      case LearningContentType.sourceText:
        return const Color(0xFF0F5132); // Deep Sacred Green
      case LearningContentType.explanation:
        return Colors.blueGrey.shade400;
      case LearningContentType.scholarlyView:
        return const Color(0xFF856404); // Ochre Gold
      case LearningContentType.translation:
        return Colors.teal.shade400;
      case LearningContentType.summary:
        return Colors.indigo.shade400;
      case LearningContentType.example:
        return Colors.deepPurple.shade300;
      case LearningContentType.quiz:
        return Colors.orange.shade400;
      case LearningContentType.userNote:
        return Colors.grey.shade400;
    }
  }

  Color _getBackgroundColor() {
    switch (section.contentType) {
      case LearningContentType.sourceText:
        return const Color(0xFFF4F9F5);
      case LearningContentType.scholarlyView:
        return const Color(0xFFFDFBF7);
      case LearningContentType.example:
        return const Color(0xFFFAF7FD);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _getSectionBorderColor();
    final bgColor = _getBackgroundColor();
    final isSourceText = section.contentType == LearningContentType.sourceText;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Right accent strip
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            section.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSourceText ? const Color(0xFF0F5132) : Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: borderColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            section.contentType.labelArabic,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: borderColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Main Section Content
                    Text(
                      section.content,
                      style: TextStyle(
                        fontSize: isSourceText ? 17 : 14.5,
                        height: isSourceText ? 1.8 : 1.6,
                        fontWeight: isSourceText ? FontWeight.w600 : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),

                    // Source Attribution
                    if (section.sourceAttribution != null && section.sourceAttribution!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'المصدر: ${section.sourceAttribution}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                      ),
                    ],

                    // Evidences
                    if (section.evidenceLinks.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...section.evidenceLinks.map((e) => EvidenceCitationBox(link: e)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
