import 'package:flutter/material.dart';
import '../../../modules/learning/domain/quiz.dart';
import '../../../modules/learning/engine/assessment_engine.dart';
import '../../../modules/learning/learning_module.dart';

/// Screen presenting an interactive assessment with sourced explanations (§15, §16, §45).
class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  final LearningModule module;
  final VoidCallback? onCompleted;

  const QuizScreen({
    super.key,
    required this.quiz,
    required this.module,
    this.onCompleted,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, List<int>> _selectedAnswers = {};
  bool _isSubmitted = false;
  QuizEvaluationReport? _evaluationReport;

  void _onOptionSelected(int optionIndex) {
    if (_isSubmitted) return;
    final currentQ = widget.quiz.questions[_currentQuestionIndex];
    setState(() {
      _selectedAnswers[currentQ.questionId] = [optionIndex];
    });
  }

  Future<void> _submitQuiz() async {
    final reportRes = widget.module.evaluateQuiz(
      quizId: widget.quiz.quizId,
      userAnswers: _selectedAnswers,
    );

    if (reportRes.isSuccess) {
      final report = reportRes.valueOrNull!;
      await widget.module.recordAssessmentResult(report.result);
      setState(() {
        _evaluationReport = report;
        _isSubmitted = true;
      });
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted && _evaluationReport != null) {
      return _buildSummaryView();
    }

    final currentQ = widget.quiz.questions[_currentQuestionIndex];
    final selectedIndices = _selectedAnswers[currentQ.questionId] ?? [];
    final isLastQuestion = _currentQuestionIndex == widget.quiz.questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
          maxLines: 2,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress tracker
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F5132)),
            ),
            const SizedBox(height: 12),
            Text(
              'سؤال ${_currentQuestionIndex + 1} من ${widget.quiz.questions.length}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Question Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQ.questionText,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Options List
            Expanded(
              child: ListView.builder(
                itemCount: currentQ.options.length,
                itemBuilder: (context, index) {
                  final opt = currentQ.options[index];
                  final isSelected = selectedIndices.contains(index);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF0F5132) : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    color: isSelected ? const Color(0xFF0F5132).withAlpha(15) : Colors.white,
                    child: ListTile(
                      title: Text(
                        opt.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? const Color(0xFF0F5132) : Colors.grey,
                      ),
                      onTap: () => _onOptionSelected(index),
                    ),
                  );
                },
              ),
            ),

            // Bottom Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _currentQuestionIndex--);
                    },
                    child: const Text('السابق'),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5132),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: selectedIndices.isEmpty
                      ? null
                      : () {
                          if (isLastQuestion) {
                            _submitQuiz();
                          } else {
                            setState(() => _currentQuestionIndex++);
                          }
                        },
                  child: Text(isLastQuestion ? 'إنهاء الاختبار وتأكيد الإجابات' : 'التالي'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryView() {
    final report = _evaluationReport!;
    final passed = report.result.passed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة التقييم'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Result Card
          Card(
            elevation: 3,
            color: passed ? const Color(0xFF0F5132) : Colors.red.shade800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    passed ? Icons.check_circle_outline : Icons.highlight_off,
                    size: 56,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      passed ? 'تم اجتياز الاختبار بنجاح' : 'لم يتم اجتياز الاختبار',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'النتيجة: ${report.result.score} من ${report.result.totalQuestions} (${report.result.percentage.toStringAsFixed(0)}%)',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sourced Explanations for all questions
          const Text(
            'التغذية الراجعة والتفسير المصدري لكل مسألة:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...report.feedback.map(
            (f) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          f.isCorrect ? Icons.check_circle : Icons.cancel,
                          color: f.isCorrect ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f.question.questionText,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Text(
                      'البيان والتأصيل: ${f.explanation}',
                      style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                    ),
                    if (f.question.evidenceLink != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'الدليل: ${f.question.evidenceLink!.citation}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0F5132),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5132),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('العودة للدرس'),
          ),
        ],
      ),
    );
  }
}
