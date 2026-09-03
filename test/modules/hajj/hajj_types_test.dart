import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/store/read_only_hajj_store.dart';
import '../../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('L2 Hajj Types & Separation of Journeys Tests (§6, §12, §13)', () {
    late ReadOnlyHajjStore store;

    setUp(() {
      store = ReadOnlyHajjStore();
      store.mountPackage(SyntheticHajjFixtures.createPackage());
    });

    test('Strict separation: Umrah steps and Hajj Tamattu steps are distinct streams', () {
      final umrahStepsRes = store.getStepsForJourney(JourneyType.umrah);
      final hajjStepsRes = store.getStepsForJourney(JourneyType.hajjTamattu);

      expect(umrahStepsRes.isSuccess, isTrue);
      expect(hajjStepsRes.isSuccess, isTrue);

      final umrahSteps = umrahStepsRes.valueOrNull!;
      final hajjSteps = hajjStepsRes.valueOrNull!;

      expect(umrahSteps.length, equals(4));
      expect(hajjSteps.length, equals(7));

      final umrahIds = umrahSteps.map((s) => s.stepId).toSet();
      final hajjIds = hajjSteps.map((s) => s.stepId).toSet();

      // No ID collisions
      expect(umrahIds.intersection(hajjIds).isEmpty, isTrue);
    });
  });
}
