import 'package:flutter/material.dart';
import '../../../modules/learning/domain/evidence_link.dart';

/// Box displaying canonical evidence citation within a lesson section (§12, §45).
class EvidenceCitationBox extends StatelessWidget {
  final EvidenceLink link;

  const EvidenceCitationBox({
    super.key,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    final isSeerahEvidence = link.sourceId == 'src_seerah_canonical' ||
        link.evidenceKey.startsWith('evt_') ||
        link.evidenceKey.startsWith('person_') ||
        link.evidenceKey.startsWith('place_');

    final primaryColor = isSeerahEvidence ? const Color(0xFF856404) : const Color(0xFF0F5132);
    final iconData = isSeerahEvidence ? Icons.history_edu_rounded : Icons.menu_book_rounded;
    final prefixTitle = isSeerahEvidence ? 'توثيق السيرة:' : 'الدليل:';

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(12),
        border: Border.all(color: primaryColor.withAlpha(40)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 18,
            color: primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$prefixTitle ${link.citation}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    if (isSeerahEvidence)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'موسوعة السيرة',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF856404)),
                        ),
                      ),
                  ],
                ),
                if (link.context != null && link.context!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    link.context!,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
