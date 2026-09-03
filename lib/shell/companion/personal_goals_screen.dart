import 'package:flutter/material.dart';
import '../../../modules/companion/companion_module.dart';
import '../../../modules/companion/domain/personal_goal.dart';

class PersonalGoalsScreen extends StatefulWidget {
  final CompanionModule module;

  const PersonalGoalsScreen({super.key, required this.module});

  @override
  State<PersonalGoalsScreen> createState() => _PersonalGoalsScreenState();
}

class _PersonalGoalsScreenState extends State<PersonalGoalsScreen> {
  List<PersonalGoal> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final res = await widget.module.getGoals();
    if (mounted) {
      setState(() {
        if (res.isSuccess) {
          _goals = res.valueOrNull!;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddGoalDialog() async {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '10');
    final unitCtrl = TextEditingController(text: 'صفحات');
    GoalType selectedType = GoalType.quranReading;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('إضافة هدف شخصي جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'عنوان الهدف (مثال: قراءة 10 صفحات يومياً)'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<GoalType>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(labelText: 'نوع الهدف'),
                  items: GoalType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.labelArabic)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedType = val);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: targetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'العدد المستهدف'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: unitCtrl,
                  decoration: const InputDecoration(labelText: 'الوحدة (آيات، صفحات، دقائق، أذكار)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final targetVal = double.tryParse(targetCtrl.text.trim()) ?? 1.0;
                if (titleCtrl.text.trim().isNotEmpty && targetVal > 0) {
                  final newGoal = PersonalGoal(
                    goalId: 'goal_${DateTime.now().millisecondsSinceEpoch}',
                    type: selectedType,
                    title: titleCtrl.text.trim(),
                    target: targetVal,
                    unitArabic: unitCtrl.text.trim(),
                    startDate: DateTime.now(),
                    sourceModule: 'mod_companion',
                  );
                  await widget.module.addGoal(newGoal);
                  if (ctx.mounted) Navigator.pop(ctx);
                  _loadGoals();
                }
              },
              child: const Text('حفظ الهدف'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأهداف الشخصية'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalDialog,
        icon: const Icon(Icons.add),
        label: const Text('هدف جديد'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _goals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.track_changes_outlined, size: 56, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text(
                        'لا توجد أهداف نشطة حالياً',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'حدد أهدافك الخاصة لتلاوة القرآن، الحفظ، الأذكار، أو التعلم',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _goals.length,
                  itemBuilder: (context, idx) {
                    final goal = _goals[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  goal.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    goal.type.labelArabic,
                                    style: TextStyle(fontSize: 11, color: Colors.teal.shade800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (goal.progressPercentage / 100).clamp(0.0, 1.0),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'المنجز: ${goal.currentProgress.toInt()} من ${goal.target.toInt()} ${goal.unitArabic}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, size: 20),
                                      onPressed: () async {
                                        await widget.module.updateGoalProgress(goal.goalId, 1.0);
                                        _loadGoals();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                      onPressed: () async {
                                        await widget.module.deleteGoal(goal.goalId);
                                        _loadGoals();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
