import 'package:flutter/material.dart';
import '../../../modules/fasting/domain/qada_plan.dart';
import '../../../modules/fasting/fasting_module.dart';

/// Screen for creating and managing Qada Fasting plans and target completion (§15, §16, §40).
class QadaPlannerScreen extends StatefulWidget {
  final FastingModule module;

  const QadaPlannerScreen({
    super.key,
    required this.module,
  });

  @override
  State<QadaPlannerScreen> createState() => _QadaPlannerScreenState();
}

class _QadaPlannerScreenState extends State<QadaPlannerScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _totalDays;
  late int _completedDays;
  DateTime? _targetDate;
  List<int> _preferredWeekdays = [1, 4];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    final res = await widget.module.getQadaPlan();
    if (mounted) {
      final plan = res.valueOrNull ??
          QadaPlan(totalDays: 0, completedDays: 0, updatedAt: DateTime.now().toUtc());
      setState(() {
        _totalDays = plan.totalDays;
        _completedDays = plan.completedDays;
        _targetDate = plan.targetDate;
        _preferredWeekdays = List<int>.from(plan.preferredWeekdays);
        _isLoading = false;
      });
    }
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final plan = QadaPlan(
      totalDays: _totalDays,
      completedDays: _completedDays,
      targetDate: _targetDate,
      preferredWeekdays: _preferredWeekdays,
      updatedAt: DateTime.now().toUtc(),
    );

    await widget.module.updateQadaPlan(plan);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مخطط قضاء الصيام'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Card(
                    color: Color(0xFFF8F9FA),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'أدخل عدد الأيام التي عليك قضاؤها، وسيساعدك المخطط على توزيعها وتوقع موعد إتمامها بإذن الله.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 1. Total Days
                  TextFormField(
                    initialValue: _totalDays > 0 ? _totalDays.toString() : '',
                    decoration: const InputDecoration(
                      labelText: 'إجمالي عدد أيام القضاء',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n >= 0 && n <= 1000) {
                        setState(() => _totalDays = n);
                      }
                    },
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'يرجى إدخال عدد الأيام';
                      final n = int.tryParse(v);
                      if (n == null || n < 0) return 'يرجى إدخال رقم صحيح موجب';
                      if (n > 1000) return 'الحد الأقصى لأيام القضاء في الخطة هو 1000 يوم';
                      return null;
                    },
                    onSaved: (v) => _totalDays = int.parse(v!),
                  ),
                  const SizedBox(height: 16),

                  // 2. Completed Days
                  TextFormField(
                    initialValue: _completedDays > 0 ? _completedDays.toString() : '',
                    decoration: const InputDecoration(
                      labelText: 'الأيام التي أتممت قضاءها بالفعل',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n >= 0) {
                        setState(() => _completedDays = n);
                      }
                    },
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final n = int.tryParse(v);
                      if (n == null || n < 0) return 'يرجى إدخال رقم صحيح موجب';
                      if (n > _totalDays) return 'الأيام المكتملة لا يمكن أن تتجاوز الإجمالي';
                      return null;
                    },
                    onSaved: (v) => _completedDays = (v != null && v.isNotEmpty) ? int.parse(v) : 0,
                  ),
                  const SizedBox(height: 20),

                  // 3. Preferred Weekdays Toggle
                  const Text(
                    'الأيام المفضلة أسبوعياً للصيام:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildWeekdayChip('الاثنين', 1),
                      _buildWeekdayChip('الخميس', 4),
                      _buildWeekdayChip('السبت', 6),
                      _buildWeekdayChip('الأحد', 7),
                      _buildWeekdayChip('الثلاثاء', 2),
                      _buildWeekdayChip('الأربعاء', 3),
                      _buildWeekdayChip('الجمعة', 5),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Projection Card
                  _buildProjectionCard(),
                  const SizedBox(height: 24),

                  // 4. Save Plan Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0F5132),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _savePlan,
                    child: const Text('حفظ خطة القضاء'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProjectionCard() {
    final remaining = _totalDays - _completedDays;
    if (remaining <= 0) {
      return Card(
        color: Colors.green.shade50,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تم إتمام جميع أيام القضاء المحددة في الخطة.',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_preferredWeekdays.isEmpty) {
      return Card(
        color: Colors.amber.shade50,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'اختر يوماً واحداً على الأقل أسبوعياً لحساب موعد الإتمام المتوقع.',
            style: TextStyle(fontSize: 13),
          ),
        ),
      );
    }

    final tempPlan = QadaPlan(
      totalDays: _totalDays,
      completedDays: _completedDays,
      preferredWeekdays: _preferredWeekdays,
      updatedAt: DateTime.now().toUtc(),
    );

    final projected = widget.module.qadaPlannerService.projectCompletionDate(plan: tempPlan);
    final weeks = widget.module.qadaPlannerService.calculateRequiredWeeks(tempPlan);

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insights_rounded, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'المتبقي: $remaining يوم (${weeks.toStringAsFixed(1)} أسبوع تقريباً)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            if (projected != null) ...[
              const SizedBox(height: 6),
              Text(
                'بناءً على الخطة الحالية: يتوقع إتمام القضاء بحلول ${projected.day}/${projected.month}/${projected.year}م',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayChip(String label, int dayIndex) {
    final isSelected = _preferredWeekdays.contains(dayIndex);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _preferredWeekdays.add(dayIndex);
          } else {
            _preferredWeekdays.remove(dayIndex);
          }
        });
      },
    );
  }
}
