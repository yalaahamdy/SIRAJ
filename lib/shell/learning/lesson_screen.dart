import 'package:flutter/material.dart';
import '../../../modules/learning/domain/lesson.dart';
import '../../../modules/learning/domain/quiz.dart';
import '../../../modules/learning/learning_module.dart';
import 'quiz_screen.dart';
import 'widgets/lesson_section_view.dart';

/// Screen presenting the full multi-section lesson with notes and quiz access (§11, §45).
class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final LearningModule module;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.module,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool _isCompleted = false;
  bool _isBookmarked = false;
  String _userNote = '';
  Quiz? _lessonQuiz;

  @override
  void initState() {
    super.initState();
    _loadLessonState();
  }

  Future<void> _loadLessonState() async {
    final progRes = await widget.module.getUserProgress();
    final quizRes = widget.module.getQuizByLesson(widget.lesson.lessonId);

    if (progRes.isSuccess) {
      final p = progRes.valueOrNull!;
      setState(() {
        _isCompleted = p.isLessonCompleted(widget.lesson.lessonId, widget.lesson.version);
        _isBookmarked = p.bookmarkedLessonIds.contains(widget.lesson.lessonId);
        _userNote = p.userNotes[widget.lesson.lessonId] ?? '';
      });
    }

    if (quizRes.isSuccess) {
      setState(() {
        _lessonQuiz = quizRes.valueOrNull;
      });
    }
  }

  Future<void> _toggleCompletion() async {
    await widget.module.markLessonCompleted(widget.lesson.lessonId, widget.lesson.version);
    setState(() => _isCompleted = true);
  }

  Future<void> _toggleBookmark() async {
    await widget.module.toggleBookmark(widget.lesson.lessonId);
    setState(() => _isBookmarked = !_isBookmarked);
  }

  void _openNotesDialog() {
    final noteController = TextEditingController(text: _userNote);

    showDialog(
      context: context,
      builder: (ctx) {
        final nav = Navigator.of(ctx);
        return AlertDialog(
          title: const Text('ملاحظاتي الشخصية على الدرس'),
          content: TextField(
            controller: noteController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'اكتب ملاحظاتك وتلخيصك الشخصي هنا (محلي وخاص)...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => nav.pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5132), foregroundColor: Colors.white),
              onPressed: () async {
                await widget.module.saveUserNote(widget.lesson.lessonId, noteController.text);
                setState(() => _userNote = noteController.text);
                nav.pop();
              },
              child: const Text('حفظ الملاحظة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            tooltip: 'حفظ الدرس في المفضلة',
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.note_alt_outlined),
            tooltip: 'ملاحظاتي',
            onPressed: _openNotesDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Objectives Card
          if (widget.lesson.objectives.isNotEmpty) ...[
            Card(
              color: Colors.blueGrey.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أهداف الدرس المعرفية:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F5132)),
                    ),
                    const SizedBox(height: 6),
                    ...widget.lesson.objectives.map(
                      (o) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Text(o.title, style: const TextStyle(fontSize: 13))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 2. Sections
          ...widget.lesson.sections.map((s) => LessonSectionView(section: s)),
          const SizedBox(height: 20),

          // 3. User Personal Notes Banner
          if (_userNote.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note, size: 16, color: Color(0xFF856404)),
                      SizedBox(width: 6),
                      Text(
                        'ملاحظاتي الشخصية:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF856404)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_userNote, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 4. Action Buttons (Quiz / Mark Completed)
          if (_lessonQuiz != null)
            ElevatedButton.icon(
              icon: const Icon(Icons.quiz_rounded),
              label: const Text('خوض اختبار استيعاب الدرس'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      quiz: _lessonQuiz!,
                      module: widget.module,
                      onCompleted: _loadLessonState,
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 8),

          OutlinedButton.icon(
            icon: Icon(_isCompleted ? Icons.check_circle : Icons.check_circle_outline),
            label: Text(_isCompleted ? 'تم إكمال الدرس (مُسجل)' : 'تحديد الدرس كمكتمل'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: _isCompleted ? const Color(0xFF0F5132) : Colors.black87,
            ),
            onPressed: _toggleCompletion,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
