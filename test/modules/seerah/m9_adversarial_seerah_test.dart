import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/domain/historical_place.dart';
import 'package:siraj/modules/seerah/domain/narrative_variant.dart';
import 'package:siraj/modules/seerah/domain/seerah_event.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('M9 Seerah Adversarial Security & Cryptographic Attack Tests (§40)', () {
    late MemoryStorageRegistry registry;
    late SeerahModule seerahModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: registry);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Attack 1: Mutating a single word in Seerah Event summary invalidates event hash', () {
      final valid = SyntheticSeerahFixtures.createEvent();
      final tampered = SeerahEvent(
        eventId: valid.eventId,
        title: valid.title,
        periodId: valid.periodId,
        historicalDate: valid.historicalDate,
        summary: '${valid.summary} زيادة غير مسندة',
        sourceIds: valid.sourceIds,
        integrityHash: valid.integrityHash,
      );

      expect(tampered.verifyHash(), isFalse);
    });

    test('Attack 2: Modifying participant list invalidates event hash', () {
      final valid = SyntheticSeerahFixtures.createEvent();
      final tampered = SeerahEvent(
        eventId: valid.eventId,
        title: valid.title,
        periodId: valid.periodId,
        historicalDate: valid.historicalDate,
        summary: valid.summary,
        participantIds: const ['person_fabricated_participant'],
        sourceIds: valid.sourceIds,
        integrityHash: valid.integrityHash,
      );

      expect(tampered.verifyHash(), isFalse);
    });

    test('Attack 3: Altering narrative variant summary invalidates variant hash', () {
      final valid = SyntheticSeerahFixtures.createVariant();
      final tampered = NarrativeVariant(
        variantId: valid.variantId,
        eventId: valid.eventId,
        narrativeSummary: 'نص محرف للرواية',
        narratorOrScholar: valid.narratorOrScholar,
        sourceId: valid.sourceId,
        integrityHash: valid.integrityHash,
      );

      expect(tampered.verifyHash(), isFalse);
    });

    test('Attack 4: Altering place certainty invalidates place hash', () {
      final valid = SyntheticSeerahFixtures.createPlace();
      final tampered = HistoricalPlace(
        placeId: valid.placeId,
        nameArabic: valid.nameArabic,
        region: valid.region,
        geographicalDescription: valid.geographicalDescription,
        certainty: PlaceCertainty.disputed,
        sourceIds: valid.sourceIds,
        integrityHash: valid.integrityHash,
      );

      expect(tampered.verifyHash(), isFalse);
    });

    test('Attack 5: User note injection cannot alter canonical store data', () async {
      await seerahModule.saveUserNote('evt_badr_major', 'رواية مزيفة تم حقنها من المستخدم');

      final eventRes = seerahModule.getEvent('evt_badr_major');
      expect(eventRes.isSuccess, isTrue);
      final event = eventRes.valueOrNull!;

      expect(event.verifyHash(), isTrue);
      expect(event.summary, isNot(contains('رواية مزيفة')));
    });
  });
}
