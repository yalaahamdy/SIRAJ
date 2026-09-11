import 'package:flutter/material.dart';
import '../../../modules/learning/domain/course.dart';
import '../../../modules/learning/domain/learning_path.dart';
import '../../../modules/learning/learning_module.dart';
import '../learning_path_screen.dart';
import 'learning_domain_theme.dart';

/// Interactive Course Catalog View browsing all 49 accredited academic courses (§4, §26).
class CourseCatalogView extends StatelessWidget {
  final List<Course> courses;
  final List<LearningPath> paths;
  final LearningModule module;
  final String selectedCategory;
  final String searchQuery;

  const CourseCatalogView({
    super.key,
    required this.courses,
    required this.paths,
    required this.module,
    required this.selectedCategory,
    required this.searchQuery,
  });

  void _openCourseInPath(BuildContext context, Course course) {
    // Find the corresponding learning path for this course
    LearningPath? parentPath;
    for (final p in paths) {
      if (p.courseIds.contains(course.courseId)) {
        parentPath = p;
        break;
      }
    }

    if (parentPath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LearningPathScreen(
            path: parentPath!,
            module: module,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('المقرر: ${course.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter courses by category and search
    var filtered = courses;

    if (selectedCategory != 'الكل') {
      // Find matching path IDs for this category
      final matchingPathIds = paths
          .where((p) => p.category == selectedCategory)
          .map((p) => p.pathId)
          .toSet();

      filtered = filtered.where((c) => matchingPathIds.contains(c.pathId) || c.pathId.contains(selectedCategory)).toList();
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.title.toLowerCase().contains(q) || c.description.toLowerCase().contains(q);
      }).toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'لا توجد مقررات مطابقة للبحث أو التصنيف المختار',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final course = filtered[index];
        final parentPath = paths.firstWhere(
          (p) => p.courseIds.contains(course.courseId),
          orElse: () => paths.first,
        );
        final theme = LearningDomainTheme.ofCategory(parentPath.category);

        return Card(
          elevation: 1.5,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _openCourseInPath(context, course),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading Domain Icon Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      theme.icon,
                      color: theme.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Course Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                parentPath.category,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                course.level.labelArabic,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.layers_outlined, size: 13, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${course.moduleIds.length} وحدات تفاعلية',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  'تصفح المقرر',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 11, color: theme.primaryColor),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
