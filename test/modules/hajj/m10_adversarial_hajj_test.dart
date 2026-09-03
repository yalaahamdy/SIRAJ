import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/canonical_hajj_package.dart';
import 'package:siraj/modules/hajj/domain/miqat.dart';
import 'package:siraj/modules/hajj/domain/ritual_step.dart';
import 'package:siraj/modules/hajj/domain/sacred_location.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/hajj/store/read_only_hajj_store.dart';
import '../../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('M10 Hajj Adversarial Security & Cryptographic Attack Tests (§44)', () {
    test('Attack 1: Mutating a single word in ritual step description invalidates step hash', () {
      final validStep = SyntheticHajjFixtures.createSteps().first;
      final tamperedStep = RitualStep(
        stepId: validStep.stepId,
        journeyType: validStep.journeyType,
        phase: validStep.phase,
        sequence: validStep.sequence,
        title: validStep.title,
        description: '${validStep.description} تحريف زائد غير مسند.',
        isRequired: validStep.isRequired,
        timeContext: validStep.timeContext,
        sourceIds: validStep.sourceIds,
        integrityHash: validStep.integrityHash,
      );

      expect(tamperedStep.verifyHash(), isFalse);
    });

    test('Attack 2: Modifying Miqat coordinates invalidates miqat hash', () {
      final validMiqat = SyntheticHajjFixtures.createMiqats().first;
      final tamperedMiqat = Miqat(
        miqatId: validMiqat.miqatId,
        nameArabic: validMiqat.nameArabic,
        historicalName: validMiqat.historicalName,
        modernName: validMiqat.modernName,
        region: validMiqat.region,
        latitude: validMiqat.latitude + 0.05, // Tampered latitude
        longitude: validMiqat.longitude,
        distanceFromMakkahKm: validMiqat.distanceFromMakkahKm,
        designatedFor: validMiqat.designatedFor,
        sourceId: validMiqat.sourceId,
        integrityHash: validMiqat.integrityHash,
      );

      expect(tamperedMiqat.verifyHash(), isFalse);
    });

    test('Attack 3: Altering sacred location description invalidates location hash', () {
      final validLoc = SyntheticHajjFixtures.createLocations().first;
      final tamperedLoc = SacredLocation(
        locationId: validLoc.locationId,
        nameArabic: validLoc.nameArabic,
        description: 'وصف محرف باطل',
        latitude: validLoc.latitude,
        longitude: validLoc.longitude,
        historicalContext: validLoc.historicalContext,
        sourceId: validLoc.sourceId,
        integrityHash: validLoc.integrityHash,
      );

      expect(tamperedLoc.verifyHash(), isFalse);
    });

    test('Attack 4: User note injection cannot alter canonical store data', () async {
      final registry = MemoryStorageRegistry();
      final module = HajjModule(storageRegistry: registry);
      module.mountPackage(SyntheticHajjFixtures.createPackage());

      await module.saveUserNote('step_umrah_ihram', 'فتوى شخصية مدعاة باطلة');

      final progRes = await module.getUserProgress();
      expect(progRes.isSuccess, isTrue);
      expect(progRes.valueOrNull!.userNotes['step_umrah_ihram'], contains('فتوى شخصية'));

      final stepRes = module.getStep('step_umrah_ihram');
      expect(stepRes.isSuccess, isTrue);
      final step = stepRes.valueOrNull!;
      expect(step.verifyHash(), isTrue);
      expect(step.description, isNot(contains('فتوى شخصية')));
    });

    test('Attack 5: Tampered package with altered step sequence is rejected by Fail-Closed store', () {
      final validPkg = SyntheticHajjFixtures.createPackage();
      final validStep = validPkg.steps.first;

      final alteredSeqStep = RitualStep(
        stepId: validStep.stepId,
        journeyType: validStep.journeyType,
        phase: validStep.phase,
        sequence: 99, // Altered sequence
        title: validStep.title,
        description: validStep.description,
        isRequired: validStep.isRequired,
        timeContext: validStep.timeContext,
        sourceIds: validStep.sourceIds,
        integrityHash: validStep.integrityHash,
      );

      final tamperedPkg = CanonicalHajjPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        steps: [alteredSeqStep, ...validPkg.steps.skip(1)],
        miqats: validPkg.miqats,
        locations: validPkg.locations,
        preparationItems: validPkg.preparationItems,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final store = ReadOnlyHajjStore();
      final res = store.mountPackage(tamperedPkg);

      expect(res.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });
  });
}
