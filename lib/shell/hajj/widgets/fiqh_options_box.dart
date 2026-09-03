import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/fiqh_option.dart';

class FiqhOptionsBox extends StatelessWidget {
  final List<FiqhOption> options;

  const FiqhOptionsBox({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, size: 18, color: Colors.amber.shade900),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'الخيارات والأقوال الفقهية المعتبرة (§9):',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...options.map((opt) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                    children: [
                      TextSpan(
                        text: '• [${opt.schoolOrScholar}]: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: opt.positionArabic),
                      if (opt.evidenceSummary.isNotEmpty) ...[
                        TextSpan(
                          text: ' (دليله: ${opt.evidenceSummary})',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
