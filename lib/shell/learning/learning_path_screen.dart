import 'package:flutter/material.dart';
import '../../../modules/learning/domain/course.dart';
import '../../../modules/learning/domain/learning_path.dart';
import '../../../modules/learning/domain/learning_progress.dart';
import '../../../modules/learning/domain/lesson.dart';
import '../../../modules/learning/learning_module.dart';
import 'lesson_screen.dart';
import 'widgets/learning_domain_theme.dart';

/// Screen presenting the learning path details, course hierarchy, and module unlocking (§4, §37, §45).
class LearningPathScreen extends StatefulWidget {
  final LearningPath path;
  final LearningModule module;

  const LearningPathScreen({
    super.key,
    required this.path,
    required this.module,
  });

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  List<Course> _courses = [];
  LearningProgress _progress = LearningProgress(updatedAt: DateTime.now().toUtc());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPathDetails();
  }

  Future<void> _loadPathDetails() async {
    final progRes = await widget.module.getUserProgress();
    final coursesList = <Course>[];

    for (final cId in widget.path.courseIds) {
      final cRes = widget.module.getCourse(cId);
      if (cRes.isSuccess) coursesList.add(cRes.valueOrNull!);
    }

    if (mounted) {
      setState(() {
        _progress = progRes.valueOrNull ?? LearningProgress(updatedAt: DateTime.now().toUtc());
        _courses = coursesList;
        _isLoading = false;
      });
    }
  }

  void _openLesson(Lesson lesson) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          lesson: lesson,
          module: widget.module,
        ),
      ),
    ).then((_) => _loadPathDetails());
  }

  @override
  Widget build(BuildContext context) {
    final theme = LearningDomainTheme.ofCategory(widget.path.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.path.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 2,
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // 1. Path Header Hero Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.primaryColor.withAlpha(40)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          theme.primaryColor.withAlpha(15),
                          theme.secondaryColor.withAlpha(5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(theme.icon, size: 14, color: theme.primaryColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.path.category,
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.path.level.labelArabic,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.path.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.path.description,
                          style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: 14),
                        Divider(height: 1, color: Colors.grey.shade200),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.menu_book_rounded, size: 14, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.path.courseIds.length} مقررات منهجية',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.schedule_rounded, size: 14, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.path.estimatedHours} ساعات تقديرية',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 2. Courses Section
                const Text(
                  'المقررات والوحدات المنهجية:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (_courses.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('لا توجد مقررات مسجلة في هذا المسار حالياً', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ..._courses.map((c) => _buildCourseCard(c, theme)),
              ],
            ),
    );
  }

  Widget _buildCourseCard(Course course, LearningDomainTheme theme) {
    final progressPct = widget.module.curriculumEngine.getCourseProgressPercentage(course, _progress);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.school_outlined, color: theme.primaryColor, size: 20),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              course.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (progressPct / 100.0).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${progressPct.toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.primaryColor),
                ),
              ],
            ),
          ],
        ),
        children: course.moduleIds.map((modId) {
          final modRes = widget.module.store.getModule(modId);
          if (modRes.isFailure) return const SizedBox.shrink();
          final mod = modRes.valueOrNull!;
          final isUnlocked = widget.module.curriculumEngine.isModuleUnlocked(mod, _progress);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.grey.shade50 : Colors.grey.shade100.withAlpha(120),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        isUnlocked ? Icons.folder_open_rounded : Icons.lock_outline_rounded,
                        size: 18,
                        color: isUnlocked ? theme.primaryColor : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          mod.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? Colors.black87 : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUnlocked ? theme.primaryColor.withAlpha(15) : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${mod.lessonIds.length} دروس',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? theme.primaryColor : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                ...mod.lessonIds.map((lsnId) {
                  final lsnRes = widget.module.getLesson(lsnId);
                  if (lsnRes.isFailure) return const SizedBox.shrink();
                  final lsn = lsnRes.valueOrNull!;
                  final isDone = _progress.isLessonCompleted(lsn.lessonId, lsn.version);

                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    leading: Icon(
                      isDone ? Icons.check_circle : (isUnlocked ? Icons.radio_button_unchecked : Icons.lock_outline),
                      size: 18,
                      color: isDone ? const Color(0xFF0F5132) : (isUnlocked ? Colors.grey.shade500 : Colors.grey.shade400),
                    ),
                    title: Text(
                      lsn.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                        color: isUnlocked ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      '${lsn.objectives.length} أهداف • ${lsn.sections.length} محاور علمية',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    trailing: isUnlocked
                        ? (isDone
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F5132).withAlpha(15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'مكتمل',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF0F5132), fontWeight: FontWeight.bold),
                                ),
                              )
                            : const Icon(Icons.arrow_forward_ios, size: 12))
                        : const Icon(Icons.lock, size: 12, color: Colors.grey),
                    enabled: isUnlocked,
                    onTap: isUnlocked ? () => _openLesson(lsn) : null,
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
