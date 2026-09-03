import 'package:flutter/material.dart';
import '../../../modules/learning/domain/course.dart';
import '../../../modules/learning/domain/learning_path.dart';
import '../../../modules/learning/domain/learning_progress.dart';
import '../../../modules/learning/domain/lesson.dart';
import '../../../modules/learning/learning_module.dart';
import 'lesson_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.path.title),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Path Header Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F5132).withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.path.level.labelArabic,
                                style: const TextStyle(
                                  color: Color(0xFF0F5132),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.path.estimatedHours} ساعات تقديرية',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.path.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.path.description,
                          style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

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
                  ..._courses.map((c) => _buildCourseCard(c)),
              ],
            ),
    );
  }

  Widget _buildCourseCard(Course course) {
    final progressPct = widget.module.curriculumEngine.getCourseProgressPercentage(course, _progress);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              course.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (progressPct / 100.0).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F5132)),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${progressPct.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        children: course.moduleIds.map((modId) {
          final modRes = widget.module.store.getModule(modId);
          if (modRes.isFailure) return const SizedBox.shrink();
          final mod = modRes.valueOrNull!;
          final isUnlocked = widget.module.curriculumEngine.isModuleUnlocked(mod, _progress);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isUnlocked ? Icons.folder_open : Icons.lock_outline,
                      size: 16,
                      color: isUnlocked ? const Color(0xFF0F5132) : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        mod.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ...mod.lessonIds.map((lsnId) {
                  final lsnRes = widget.module.getLesson(lsnId);
                  if (lsnRes.isFailure) return const SizedBox.shrink();
                  final lsn = lsnRes.valueOrNull!;
                  final isDone = _progress.isLessonCompleted(lsn.lessonId, lsn.version);

                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(right: 20),
                    leading: Icon(
                      isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 16,
                      color: isDone ? const Color(0xFF0F5132) : Colors.grey,
                    ),
                    title: Text(lsn.title, style: const TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                    enabled: isUnlocked,
                    onTap: isUnlocked ? () => _openLesson(lsn) : null,
                  );
                }),
                const Divider(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
