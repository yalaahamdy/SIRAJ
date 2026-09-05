import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/hajj_user_progress.dart';
import '../../../modules/hajj/domain/journey_type.dart';
import '../../../modules/hajj/domain/ritual_step.dart';
import '../../../modules/hajj/engine/hajj_journey_engine.dart';
import '../../../modules/hajj/hajj_module.dart';
import 'ritual_step_detail_screen.dart';
import 'widgets/ritual_step_card.dart';

/// Live Journey Dashboard Screen (§20..§27, §33..§36, §107).
class JourneyDashboardScreen extends StatefulWidget {
  final HajjModule module;
  final JourneyType journeyType;

  const JourneyDashboardScreen({
    super.key,
    required this.module,
    required this.journeyType,
  });

  @override
  State<JourneyDashboardScreen> createState() => _JourneyDashboardScreenState();
}

class _JourneyDashboardScreenState extends State<JourneyDashboardScreen> {
  HajjUserProgress _progress = const HajjUserProgress();
  JourneyStatusSnapshot? _snapshot;
  List<RitualStep> _steps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final progRes = await widget.module.getUserProgress();
    final stepsRes = widget.module.getStepsForJourney(widget.journeyType);

    if (mounted) {
      setState(() {
        if (progRes.isSuccess) {
          _progress = progRes.valueOrNull!;
        }
        if (stepsRes.isSuccess) {
          _steps = stepsRes.valueOrNull!;
        }
        _updateSnapshot();
        _isLoading = false;
      });
    }
  }

  void _updateSnapshot() {
    final snapRes = widget.module.journeyEngine.calculateSnapshot(
      _progress.copyWith(activeJourneyType: widget.journeyType),
    );
    if (snapRes.isSuccess) {
      _snapshot = snapRes.valueOrNull!;
    }
  }

  Future<void> _toggleStep(String stepId) async {
    if (_progress.completedStepIds.contains(stepId)) {
      final updated = Set<String>.from(_progress.completedStepIds)..remove(stepId);
      final newProg = _progress.copyWith(completedStepIds: updated);
      await widget.module.userDataStore.saveProgress(newProg);
      setState(() {
        _progress = newProg;
        _updateSnapshot();
      });
    } else {
      await widget.module.markStepCompleted(stepId);
      final progRes = await widget.module.getUserProgress();
      if (mounted && progRes.isSuccess) {
        setState(() {
          _progress = progRes.valueOrNull!;
          _updateSnapshot();
        });
      }
    }
  }

  Future<void> _confirmResetJourney() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة ضبط هذه الرحلة'),
        content: const Text(
          'هل تريد إلغاء تعليم كافة خطوات هذه الرحلة والبدء من جديد؟ لن تتأثر بقية الوحدات.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('إعادة البدء', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final resetProg = _progress.copyWith(
        completedStepIds: const {},
        journeyState: JourneyState.preparing,
      );
      await widget.module.userDataStore.saveProgress(resetProg);
      setState(() {
        _progress = resetProg;
        _updateSnapshot();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final snap = _snapshot;
    final currentStep = snap?.currentStep;
    final nextStep = snap?.nextRecommendedStep;
    final isCompleted = snap != null && snap.completedStepsCount == snap.totalSteps && snap.totalSteps > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journeyType.labelArabic, style: const TextStyle(fontSize: 16)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'إعادة ضبط الرحلة',
            onPressed: _confirmResetJourney,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Live Journey Hero Card (§34)
          if (isCompleted)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade600],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'اكتملت خطوات الرحلة المسجلة',
                          style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تم استكمال الخطوات المسجلة في الرحلة بحمد الله.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green.shade900,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('العودة للرئيسية'),
                  ),
                ],
              ),
            )
          else if (currentStep != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade800, Colors.teal.shade600],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'المرحلة: ${snap?.currentPhase.labelArabic ?? ""}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${snap?.completedStepsCount ?? 0} من ${snap?.totalSteps ?? 0} خطوة',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'الخطوة الحالية الموصى بها:',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      currentStep.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentStep.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  if (nextStep != null) ...[
                    Text(
                      'ما يأتي بعد ذلك: ${nextStep.title}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  LinearProgressIndicator(
                    value: ((snap?.progressPercentage ?? 0) / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: const Color(0xFF00281F),
                          ),
                          icon: Icon(
                            _progress.completedStepIds.contains(currentStep.stepId)
                                ? Icons.undo
                                : Icons.check_circle_outline,
                          ),
                          label: Text(
                            _progress.completedStepIds.contains(currentStep.stepId)
                                ? 'إلغاء التعليم'
                                : 'تمت هذه الخطوة',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _toggleStep(currentStep.stepId),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RitualStepDetailScreen(step: currentStep, module: widget.module),
                            ),
                          );
                        },
                        child: const Text('التفاصيل'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Fiqh Disclaimer (§43)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.amber.shade900),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'يختلف التفصيل الفقهي باختلاف المذهب والمصدر، والتطبيق ينظم الخطوات استرشاداً.',
                    style: TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              'كافة خطوات النسك بالترتيب الشرعي:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          ..._steps.map((s) => RitualStepCard(
                step: s,
                isCompleted: _progress.completedStepIds.contains(s.stepId),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RitualStepDetailScreen(step: s, module: widget.module),
                    ),
                  );
                },
                onToggleCompleted: () => _toggleStep(s.stepId),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
