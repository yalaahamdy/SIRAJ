import 'package:flutter/material.dart';
import '../../../modules/adhkar/domain/dhikr_item.dart';

class AdhkarLinkBox extends StatelessWidget {
  final List<DhikrItem> adhkar;

  const AdhkarLinkBox({super.key, required this.adhkar});

  @override
  Widget build(BuildContext context) {
    if (adhkar.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.25) : Colors.teal.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF059669).withValues(alpha: 0.4) : Colors.teal.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories,
                size: 18,
                color: isDark ? const Color(0xFF6EE7B7) : Colors.teal.shade900,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'الأدعية والأذكار المأثورة في هذا الموضع (M4):',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? const Color(0xFF6EE7B7) : Colors.teal.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...adhkar.map((d) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.textArabic,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFF1F5F9) : Colors.black87,
                      ),
                    ),
                    if (d.benefit != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'فضله: ${d.benefit}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
