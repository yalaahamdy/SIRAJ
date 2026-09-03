import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/historical_evidence_level.dart';
import '../../../modules/seerah/domain/seerah_event.dart';

/// Card widget presenting a Seerah event with evidence level badge and date precision (§5, §36, §37).
class EventCard extends StatelessWidget {
  final SeerahEvent event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  Color _getEvidenceColor() {
    switch (event.evidenceLevel) {
      case HistoricalEvidenceLevel.primarySource:
      case HistoricalEvidenceLevel.strongReport:
      case HistoricalEvidenceLevel.multipleSources:
        return const Color(0xFF0F5132); // Sacred Green
      case HistoricalEvidenceLevel.singleReport:
        return Colors.teal.shade700;
      case HistoricalEvidenceLevel.disputed:
        return const Color(0xFF856404); // Ochre Gold
      case HistoricalEvidenceLevel.weakReport:
        return Colors.orange.shade800;
      case HistoricalEvidenceLevel.unverified:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getEvidenceColor();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.evidenceLevel.labelArabic,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      event.historicalDate.dateDisplay,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              // Summary
              Text(
                event.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
              ),
              const SizedBox(height: 12),

              // Footer: Uncertain order / Variants count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (event.isOrderUncertain)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: Colors.orange.shade800),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'ترتيب مختلف فيه بين المصادر',
                              style: TextStyle(fontSize: 11, color: Colors.orange.shade800, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),
                  const Row(
                    children: [
                      Text(
                        'عرض التفاصيل والأدلة',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F5132),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF0F5132)),
                    ],
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
