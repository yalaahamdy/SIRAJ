import 'package:flutter/material.dart';
import '../../modules/zakat/domain/zakat_guide_topic.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Full-featured Detail Screen for Zakat Guidance & Practical Calculation Models (§12).
class ZakatGuideDetailScreen extends StatelessWidget {
  final ZakatGuideTopic topic;

  const ZakatGuideDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 2,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Category & Title Header Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : Colors.green.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calculate_rounded, color: AppColors.primaryAction(context), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            topic.category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryAction(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic.summary,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText(context),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // 2. Structured Explanation Content
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.border(context)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.rule_rounded, color: AppColors.primaryAction(context), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'التأصيل والبيان الفقهي',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText(context),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          topic.content,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.8,
                            color: AppColors.primaryText(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // 3. Calculation Steps (If applicable)
                if (topic.calculationSteps.isNotEmpty) ...[
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.format_list_numbered_rounded, color: Colors.blueAccent, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'خطوات الحساب العملية',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...topic.calculationSteps.asMap().entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.primaryAction(context),
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: AppColors.primaryText(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                ],

                // 4. Practical Examples Box
                if (topic.examples.isNotEmpty) ...[
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'أمثلة وحالات واقعية',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...topic.examples.map(
                            (ex) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border(context)),
                              ),
                              child: Text(
                                ex,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: AppColors.primaryText(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                ],

                // 5. Authoritative References
                if (topic.references.isNotEmpty) ...[
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.menu_book_sharp, color: Colors.teal, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'المصادر والمعايير المعتمدة',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...topic.references.map(
                            (ref) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '• $ref',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.secondaryText(context),
                                ),
                              ),
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
    );
  }
}
