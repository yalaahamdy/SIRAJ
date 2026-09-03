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
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F5132).withAlpha(12),
        border: Border.all(color: const Color(0xFF0F5132).withAlpha(40)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            size: 16,
            color: Color(0xFF0F5132),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الدليل: ${link.citation}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F5132),
                  ),
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
