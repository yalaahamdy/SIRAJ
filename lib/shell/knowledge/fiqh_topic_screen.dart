import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/knowledge_module.dart';

/// Screen presenting a comparative Fiqh topic and its distinct school positions (§13, §14, §45).
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
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Topic Summary
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topic.summary,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. School Positions Header
          const Text(
            'أقوال المذاهب الفقهية المعتمدة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          // 3. School Positions List
          ...topic.positions.map(
            (pos) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F5132),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            pos.school.labelArabic,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (pos.scholarName != null && pos.scholarName!.isNotEmpty)
                          Text(
                            pos.scholarName!,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pos.rulingText,
                      style: const TextStyle(fontSize: 15, height: 1.6),
                    ),
                    if (pos.evidences.isNotEmpty) ...[
                      const Divider(height: 20),
                      const Text(
                        'الأدلة والاستشهادات:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      ...pos.evidences.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.bookmark_border, size: 14, color: Color(0xFF0F5132)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${e.evidenceType.labelArabic}: ${e.displayCitation}',
                                  style: const TextStyle(fontSize: 12),
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
          ),
        ],
      ),
    );
  }
}
