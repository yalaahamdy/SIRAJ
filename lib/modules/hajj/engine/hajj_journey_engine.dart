import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/hajj_user_progress.dart';
import '../domain/journey_type.dart';
import '../domain/ritual_phase.dart';
import '../domain/ritual_step.dart';
import '../store/read_only_hajj_store.dart';

/// Calculation snapshot for active pilgrimage journey (§21, §23).
class JourneyStatusSnapshot {
  final JourneyType journeyType;
  final JourneyState journeyState;
  final int totalSteps;
  final int completedStepsCount;
  final double progressPercentage;
  final RitualStep? currentStep;
  final RitualStep? nextRecommendedStep;
  final RitualPhase currentPhase;

  const JourneyStatusSnapshot({
    required this.journeyType,
    required this.journeyState,
    required this.totalSteps,
    required this.completedStepsCount,
    required this.progressPercentage,
    this.currentStep,
    this.nextRecommendedStep,
    required this.currentPhase,
  });
}

/// Deterministic Engine for Hajj and Umrah journey state and step progression (§20, §21).
class HajjJourneyEngine {
  final ReadOnlyHajjStore _store;

  const HajjJourneyEngine({required ReadOnlyHajjStore store}) : _store = store;

  Result<JourneyStatusSnapshot, Failure> calculateSnapshot(HajjUserProgress progress) {
    if (!_store.isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }

    final stepsRes = _store.getStepsForJourney(progress.activeJourneyType);
    if (stepsRes.isFailure) return Result.err(stepsRes.failureOrNull!);

    final steps = stepsRes.valueOrNull!;
    if (steps.isEmpty) {
      return Result.ok(JourneyStatusSnapshot(
        journeyType: progress.activeJourneyType,
        journeyState: progress.journeyState,
        totalSteps: 0,
        completedStepsCount: 0,
        progressPercentage: 0.0,
        currentPhase: RitualPhase.preparation,
      ));
    }

    final total = steps.length;
    final completedCount = steps.where((s) => progress.completedStepIds.contains(s.stepId)).length;
    final percentage = total > 0 ? (completedCount / total) * 100.0 : 0.0;

    RitualStep? activeStep;
    RitualStep? nextStep;

    for (int i = 0; i < steps.length; i++) {
      if (!progress.completedStepIds.contains(steps[i].stepId)) {
        activeStep = steps[i];
        if (i + 1 < steps.length) {
          nextStep = steps[i + 1];
        }
        break;
      }
    }

    // If all completed, active is the last step
    final phase = activeStep?.phase ?? steps.last.phase;

    return Result.ok(JourneyStatusSnapshot(
      journeyType: progress.activeJourneyType,
      journeyState: completedCount == total && total > 0 ? JourneyState.completed : progress.journeyState,
      totalSteps: total,
      completedStepsCount: completedCount,
      progressPercentage: percentage.clamp(0.0, 100.0),
      currentStep: activeStep ?? steps.last,
      nextRecommendedStep: nextStep,
      currentPhase: phase,
    ));
  }
}
