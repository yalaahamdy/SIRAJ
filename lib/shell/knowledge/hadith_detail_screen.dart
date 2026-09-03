import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import 'widgets/provenance_badge.dart';

/// Screen presenting the full canonical Hadith with separate Matn, Gradings, and Commentaries (§9, §45).
class HadithDetailScreen extends StatelessWidget {
  final HadithEntity hadith;
  final KnowledgeModule module;

  const HadithDetailScreen({
    super.key,
    required this.hadith,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${hadith.bookName} — حديث ${hadith.primaryNumber}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Canonical Matn Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المتن العربي الأصيل',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F5132),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'رقم ${hadith.primaryNumber}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    hadith.arabicMatn,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (hadith.isnad != null && hadith.isnad!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'الإسناد: ${hadith.isnad}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Gradings Section
          const Text(
            'درجة الحديث والتخريج المعتمد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (hadith.gradings.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('لم تسجل أي أحكام بعد على هذا الحديث'),
              ),
            )
          else
            ...hadith.gradings.map(
              (g) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: ProvenanceBadge(grade: g.grade),
                  title: Text(
                    g.scholarName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    'المصدر: ${g.sourceBook}${g.context != null ? ' — ${g.context}' : ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),

          // 3. Commentaries Section (Distinct Separation)
          if (hadith.commentaries.isNotEmpty) ...[
            const Text(
              'الشروح والفوائد العلمية المنسوبة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...hadith.commentaries.map(
              (c) => Card(
                color: const Color(0xFFFDFBF7),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'قول: ${c.scholarName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF856404),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c.quote,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      if (c.pageReference != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'المرجع: ${c.pageReference}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
