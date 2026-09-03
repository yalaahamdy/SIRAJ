import 'package:flutter/material.dart';
import '../../modules/fasting/domain/fasting_guide_topic.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Full-featured Detail Screen for Fasting Guidance Topics & FAQs (§11).
class FastingTopicDetailScreen extends StatelessWidget {
  final FastingGuideTopic topic;

  const FastingTopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
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
                    color: isDark ? const Color(0xFF1E293B) : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : Colors.blue.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.menu_book_rounded, color: AppColors.primaryAction(context), size: 20),
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

                // 2. Structured Body Content
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
                            Icon(Icons.article_rounded, color: AppColors.primaryAction(context), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'البيان والتفصيل الشرعي',
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

                // 3. Key Takeaway Points
                if (topic.keyPoints.isNotEmpty) ...[
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
                              const Icon(Icons.check_circle_rounded, color: Colors.teal, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'أبرز الفوائد والضوابط',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...topic.keyPoints.map(
                            (pt) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Expanded(
                                    child: Text(
                                      pt,
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

                // 4. Authoritative References
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
                              const Icon(Icons.menu_book_sharp, color: Colors.amber, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'المصادر والمراجع المعتمدة',
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
