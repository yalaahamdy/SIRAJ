import 'package:flutter/material.dart';
import '../../../modules/ai/domain/evidence_item.dart';
import '../../theme/app_colors.dart';

class EvidenceDrawer extends StatelessWidget {
  final List<EvidenceItem> evidenceItems;

  const EvidenceDrawer({super.key, required this.evidenceItems});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: isDark ? AppColors.goldAccentLight : const Color(0xFF0F5132),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'سجل الأدلة والمصادر المعتمدة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          if (evidenceItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'لا توجد أدلة ملحقة بهذا الاستعلام',
                  style: TextStyle(color: textSecondary),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: evidenceItems.length,
                itemBuilder: (context, idx) {
                  final e = evidenceItems[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade50,
                    elevation: isDark ? 0 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  e.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF064E3B) : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF059669) : Colors.green.shade200,
                                  ),
                                ),
                                child: Text(
                                  e.verificationState.labelArabic,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFF6EE7B7) : Colors.green.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e.textExcerpt,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'الموضع: ${e.referenceLocation} (المصدر: ${e.sourceId})',
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
