import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/hajj/domain/canonical_hajj_package.dart';
import 'package:siraj/modules/hajj/domain/ritual_step.dart';
import 'package:siraj/modules/hajj/store/read_only_hajj_store.dart';
import '../../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('L2 Hajj Package Cryptographic Integrity & Fail-Closed Tests (§40, §41)', () {
    test('Valid synthetic package passes all integrity and cryptographic checks', () {
      final pkg = SyntheticHajjFixtures.createPackage();
      expect(pkg.verifyIntegrity(), isTrue);

      final store = ReadOnlyHajjStore();
      final res = store.mountPackage(pkg);
      expect(res.isSuccess, isTrue);
      expect(store.isMounted, isTrue);
    });

    test('Rejects package if any individual RitualStep title is tampered', () {
      final validPkg = SyntheticHajjFixtures.createPackage();
      final validStep = validPkg.steps.first;

      final tamperedStep = RitualStep(
        stepId: validStep.stepId,
        journeyType: validStep.journeyType,
        phase: validStep.phase,
        sequence: validStep.sequence,
        title: 'الإحرام من مكة بدل الميقات (تحريف باطل)',
        description: validStep.description,
        isRequired: validStep.isRequired,
        timeContext: validStep.timeContext,
        sourceIds: validStep.sourceIds,
        integrityHash: validStep.integrityHash,
      );

      final tamperedPkg = CanonicalHajjPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        steps: [tamperedStep, ...validPkg.steps.skip(1)],
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

    test('Rejects package with empty signature or signer identity', () {
      final validPkg = SyntheticHajjFixtures.createPackage();
      final emptySigPkg = CanonicalHajjPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        steps: validPkg.steps,
        miqats: validPkg.miqats,
        locations: validPkg.locations,
        preparationItems: validPkg.preparationItems,
        contentHash: validPkg.contentHash,
        signerIdentity: '',
        signature: '',
        publishedAt: validPkg.publishedAt,
      );

      final store = ReadOnlyHajjStore();
      final res = store.mountPackage(emptySigPkg);

      expect(res.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });
  });
}
