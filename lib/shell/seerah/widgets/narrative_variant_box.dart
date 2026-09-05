import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/narrative_variant.dart';

/// Box displaying a divergent historical narrative variant without collapsing (§13, §14, §37).
class NarrativeVariantBox extends StatelessWidget {
  final NarrativeVariant variant;

  const NarrativeVariantBox({
    super.key,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E);
    final titleColor = isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E);
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);
    final noteColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final bgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFDF5);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: accentColor.withAlpha(isDark ? 100 : 70),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 8),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'رواية: ${variant.narratorOrScholar}',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentColor.withAlpha(isDark ? 45 : 25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: accentColor.withAlpha(isDark ? 130 : 90),
                            ),
                          ),
                          child: Text(
                            variant.evidenceLevel.labelArabic,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      variant.narrativeSummary,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.6,
                        color: bodyColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (variant.scholarlyNotes != null && variant.scholarlyNotes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.comment_outlined,
                            size: 13,
                            color: noteColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'ملاحظة المحققين: ${variant.scholarlyNotes!}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: noteColor,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
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
