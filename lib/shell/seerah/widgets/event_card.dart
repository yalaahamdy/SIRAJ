import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/historical_evidence_level.dart';
import '../../../modules/seerah/domain/seerah_event.dart';
import '../../theme/app_colors.dart';

/// Card widget presenting a Seerah event with evidence level badge and date precision (§5, §36, §37).
class EventCard extends StatelessWidget {
  final SeerahEvent event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  Color _getEvidenceColor(bool isDark) {
    switch (event.evidenceLevel) {
      case HistoricalEvidenceLevel.primarySource:
      case HistoricalEvidenceLevel.strongReport:
      case HistoricalEvidenceLevel.multipleSources:
        return isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132); // Sacred Green
      case HistoricalEvidenceLevel.singleReport:
        return isDark ? const Color(0xFF2DD4BF) : Colors.teal.shade700;
      case HistoricalEvidenceLevel.disputed:
        return isDark ? const Color(0xFFFBBF24) : const Color(0xFF856404); // Ochre Gold
      case HistoricalEvidenceLevel.weakReport:
        return isDark ? const Color(0xFFFB923C) : Colors.orange.shade800;
      case HistoricalEvidenceLevel.unverified:
        return isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = _getEvidenceColor(isDark);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final summaryColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final dateColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    return Card(
      elevation: isDark ? 1 : 2,
      color: isDark ? AppColors.surfaceDark : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Evidence Badge & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(isDark ? 45 : 28),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: badgeColor.withAlpha(isDark ? 140 : 100),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        event.evidenceLevel.labelArabic,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: dateColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            event.historicalDate.dateDisplay,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: dateColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Summary
              Text(
                event.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  color: summaryColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),

              // Evidence tags preview (Quran, Hadith, Lessons)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (event.relatedQuranAyahs.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryAccent.withAlpha(isDark ? 40 : 18),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: primaryAccent.withAlpha(isDark ? 100 : 60),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu_book, size: 12, color: primaryAccent),
                          const SizedBox(width: 4),
                          Text(
                            '${event.relatedQuranAyahs.length} شواهد قرآنية',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: primaryAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (event.moralLessons.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E3A8A).withAlpha(60)
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3B82F6).withAlpha(120)
                              : Colors.blue.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 12,
                            color: isDark
                                ? const Color(0xFF93C5FD)
                                : Colors.blue.shade800,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${event.moralLessons.length} دروس وعبر',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? const Color(0xFFBFDBFE)
                                  : Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Footer: Uncertain order / Details CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (event.isOrderUncertain)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: isDark
                                ? const Color(0xFFFBBF24)
                                : Colors.orange.shade900,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'ترتيب مختلف فيه بين المصادر',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? const Color(0xFFFBBF24)
                                    : Colors.orange.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryAccent.withAlpha(isDark ? 35 : 15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض التفاصيل والأدلة',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 11, color: primaryAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
