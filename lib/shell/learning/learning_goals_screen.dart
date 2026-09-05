import 'package:flutter/material.dart';
import '../../../modules/learning/domain/learning_goal.dart';
import '../../../modules/learning/learning_module.dart';

/// Screen allowing the learner to customize personal study pacing and goals (§24, §40).
class LearningGoalsScreen extends StatefulWidget {
  final LearningModule module;

  const LearningGoalsScreen({
    super.key,
    required this.module,
  });

  @override
  State<LearningGoalsScreen> createState() => _LearningGoalsScreenState();
}

class _LearningGoalsScreenState extends State<LearningGoalsScreen> {
  int _targetLessonsPerWeek = 3;
  int _targetMinutesPerDay = 15;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final progRes = await widget.module.getUserProgress();
    if (progRes.isSuccess) {
      final goal = progRes.valueOrNull?.learningGoal;
      if (goal != null) {
        setState(() {
          _targetLessonsPerWeek = goal.targetLessonsPerWeek;
          _targetMinutesPerDay = goal.targetMinutesPerDay;
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveGoal() async {
    final goal = LearningGoal(
      goalId: 'user_active_goal',
      title: 'هدفي التعليمي المخصص',
      targetLessonsPerWeek: _targetLessonsPerWeek,
      targetMinutesPerDay: _targetMinutesPerDay,
      startDate: DateTime.now().toUtc(),
    );

    await widget.module.saveGoal(goal);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الهدف التعليمي بنجاح')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأهداف التعليمية'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Header Card
                Card(
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تخصيص الخطة والوتيرة الشخصية',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'حدد وتيرة التعلم اليومية والأسبوعية التي تناسب وقتك دون إجهاد أو انقطاع.',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Target Lessons Per Week
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('الدروس المستهدفة أسبوعياً:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('$_targetLessonsPerWeek دروس', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5132))),
                          ],
                        ),
                        Slider(
                          value: _targetLessonsPerWeek.toDouble(),
                          min: 1,
                          max: 14,
                          divisions: 13,
                          activeColor: const Color(0xFF0F5132),
                          onChanged: (val) => setState(() => _targetLessonsPerWeek = val.round()),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Target Minutes Per Day
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('وقت المذاكرة اليومي المقترح:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('$_targetMinutesPerDay دقيقة', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5132))),
                          ],
                        ),
                        Slider(
                          value: _targetMinutesPerDay.toDouble(),
                          min: 5,
                          max: 60,
                          divisions: 11,
                          activeColor: const Color(0xFF0F5132),
                          onChanged: (val) => setState(() => _targetMinutesPerDay = val.round()),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5132),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: _saveGoal,
                  child: const Text('حفظ الخطة وتأكيد الهدف'),
                ),
              ],
            ),
    );
  }
}
