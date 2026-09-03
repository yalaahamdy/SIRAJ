import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import 'provenance_badge.dart';

/// Card widget displaying canonical Hadith text, collection info, and grading badges (§9, §45).
class HadithCard extends StatelessWidget {
  final HadithEntity hadith;
  final VoidCallback? onTap;

  const HadithCard({
    super.key,
    required this.hadith,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              // 1. Header: Book and Number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${hadith.bookName} • حديث ${hadith.primaryNumber}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5132),
                      ),
                    ),
                  ),
                  if (hadith.gradings.isNotEmpty)
                    ProvenanceBadge(
                      grade: hadith.gradings.first.grade,
                      scholarName: hadith.gradings.first.scholarName,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. Canonical Arabic Matn
              Text(
                hadith.arabicMatn,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // 3. Footer: Chapter if available
              if (hadith.chapterName != null && hadith.chapterName!.isNotEmpty)
                Text(
                  'باب: ${hadith.chapterName}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
