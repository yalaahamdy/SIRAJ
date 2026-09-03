import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/hajj/domain/hajj_user_progress.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/domain/ritual_phase.dart';
import 'package:siraj/modules/hajj/engine/hajj_journey_engine.dart';
import 'package:siraj/modules/hajj/store/read_only_hajj_store.dart';
import '../../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('L2 Hajj & Umrah Journey Engine Tests (§20, §21, §23)', () {
    late ReadOnlyHajjStore store;
    late HajjJourneyEngine engine;

    setUp(() {
      store = ReadOnlyHajjStore();
      store.mountPackage(SyntheticHajjFixtures.createPackage());
      engine = HajjJourneyEngine(store: store);
    });

    test('Computes snapshot for fresh Umrah journey at initial step', () {
      const progress = HajjUserProgress(
        activeJourneyType: JourneyType.umrah,
        journeyState: JourneyState.notStarted,
        completedStepIds: {},
      );

      final snapshotRes = engine.calculateSnapshot(progress);
      expect(snapshotRes.isSuccess, isTrue);
      final snap = snapshotRes.valueOrNull!;

      expect(snap.journeyType, equals(JourneyType.umrah));
      expect(snap.totalSteps, equals(4));
      expect(snap.completedStepsCount, equals(0));
      expect(snap.progressPercentage, equals(0.0));
      expect(snap.currentStep?.stepId, equals('step_umrah_ihram'));
      expect(snap.nextRecommendedStep?.stepId, equals('step_umrah_tawaf'));
      expect(snap.currentPhase, equals(RitualPhase.miqatAndIhram));
    });

    test('Advances active step and progress percentage when steps are marked completed', () {
      const progress = HajjUserProgress(
        activeJourneyType: JourneyType.umrah,
        journeyState: JourneyState.inProgress,
        completedStepIds: {'step_umrah_ihram', 'step_umrah_tawaf'},
      );

      final snapshotRes = engine.calculateSnapshot(progress);
      expect(snapshotRes.isSuccess, isTrue);
      final snap = snapshotRes.valueOrNull!;

      expect(snap.totalSteps, equals(4));
      expect(snap.completedStepsCount, equals(2));
      expect(snap.progressPercentage, equals(50.0));
      expect(snap.currentStep?.stepId, equals('step_umrah_sai'));
      expect(snap.nextRecommendedStep?.stepId, equals('step_umrah_tahallul'));
      expect(snap.currentPhase, equals(RitualPhase.sai));
    });

    test('Transitions journeyState to completed when all steps are marked done', () {
      const progress = HajjUserProgress(
        activeJourneyType: JourneyType.umrah,
        journeyState: JourneyState.inProgress,
        completedStepIds: {
          'step_umrah_ihram',
          'step_umrah_tawaf',
          'step_umrah_sai',
          'step_umrah_tahallul',
        },
      );

      final snapshotRes = engine.calculateSnapshot(progress);
      expect(snapshotRes.isSuccess, isTrue);
      final snap = snapshotRes.valueOrNull!;

      expect(snap.totalSteps, equals(4));
      expect(snap.completedStepsCount, equals(4));
      expect(snap.progressPercentage, equals(100.0));
      expect(snap.journeyState, equals(JourneyState.completed));
    });
  });
}
