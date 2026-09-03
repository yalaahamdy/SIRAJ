import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/events/event_bus.dart';
import 'package:siraj/platform/content/package/content_package.dart';
import 'package:siraj/platform/content/package/package_manifest.dart';
import 'package:siraj/platform/content/package/package_verifier.dart';
import '../fixtures/synthetic_packages.dart';

void main() {
  group('L1 Package Verifier Tests', () {
    late EventBus bus;
    late PackageVerifier verifier;

    setUp(() {
      bus = EventBus(sync: true);
      verifier = PackageVerifier(eventBus: bus);
    });

    tearDown(() async {
      await bus.dispose();
    });

    test('Valid synthetic package passes all integrity and signer checks', () {
      final package = SyntheticFixtures.createValidSyntheticPackage();
      final res = verifier.verifyPackage(package);

      expect(res.isSuccess, isTrue);
    });

    test('Rejects package with untrusted signer identity', () {
      final valid = SyntheticFixtures.createValidSyntheticPackage();
      final unstrustedManifest = PackageManifest(
        packageId: valid.packageId,
        version: valid.version,
        targetModule: valid.targetModule,
        createdAt: valid.manifest.createdAt,
        fileHashes: valid.manifest.fileHashes,
        signature: valid.manifest.signature,
        signerIdentity: 'malicious-or-unknown-signer',
      );

      final unstrustedPkg = ContentPackage(
        manifest: unstrustedManifest,
        records: valid.records,
      );

      final res = verifier.verifyPackage(unstrustedPkg);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('not in trusted keystore'));
    });

    test('Rejects package with empty or invalid signature', () {
      final valid = SyntheticFixtures.createValidSyntheticPackage();
      final badSigManifest = PackageManifest(
        packageId: valid.packageId,
        version: valid.version,
        targetModule: valid.targetModule,
        createdAt: valid.manifest.createdAt,
        fileHashes: valid.manifest.fileHashes,
        signature: 'INVALID_SIGNATURE',
        signerIdentity: valid.manifest.signerIdentity,
      );

      final badPkg = ContentPackage(
        manifest: badSigManifest,
        records: valid.records,
      );

      final res = verifier.verifyPackage(badPkg);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('signature is invalid'));
    });
  });
}
