import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/knowledge_module.dart';

/// Screen presenting a comparative Fiqh topic and its distinct school positions with high contrast (§13, §14, §45).
class FiqhTopicScreen extends StatelessWidget {
  final FiqhTopic topic;
  final KnowledgeModule module;

  const FiqhTopicScreen({
    super.key,
    required this.topic,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
    final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
          maxLines: 2,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Topic Summary Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cardBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF142E1F) : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: isDark ? const Color(0xFF22543D) : const Color(0xFFA5D6A7)),
                      ),
                      child: Text(
                        topic.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  topic.title,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  topic.summary,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.65,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. School Positions Header
          Row(
            children: [
              Icon(Icons.balance, size: 20, color: primaryAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'أقوال المذاهب الفقهية المعتمدة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5, color: textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3. School Positions List
          ...topic.positions.map(
            (pos) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cardBorder, width: 1.1),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF142E1F) : const Color(0xFF0F5132),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          pos.school.labelArabic,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (pos.scholarName != null && pos.scholarName!.isNotEmpty)
                        Flexible(
                          child: Text(
                            pos.scholarName!,
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textSecondary),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pos.rulingText,
                    style: TextStyle(fontSize: 15, height: 1.65, fontWeight: FontWeight.w500, color: textPrimary),
                  ),
                  if (pos.evidences.isNotEmpty) ...[
                    const Divider(height: 24),
                    Text(
                      'الأدلة والاستشهادات المعتمدة:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryAccent),
                    ),
                    const SizedBox(height: 6),
                    ...pos.evidences.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.bookmark_outline, size: 16, color: primaryAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${e.evidenceType.labelArabic}: ${e.displayCitation}',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
