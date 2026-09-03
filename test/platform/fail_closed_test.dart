import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/events/app_events.dart';
import 'package:siraj/core/events/event_bus.dart';
import 'package:siraj/platform/content/domain/content_status.dart';
import 'package:siraj/platform/content/package/content_package.dart';
import 'package:siraj/platform/content/package/package_manifest.dart';
import 'package:siraj/platform/content/package/package_verifier.dart';
import 'package:siraj/platform/content/store/read_only_content_store.dart';
import '../fixtures/synthetic_packages.dart';

void main() {
  group('L1 Fail-Closed Security & Integrity Tests (Laws 2, 3, 4)', () {
    late EventBus bus;
    late PackageVerifier verifier;
    late ReadOnlyContentStore store;

    setUp(() {
      bus = EventBus(sync: true);
      verifier = PackageVerifier(eventBus: bus);
      store = ReadOnlyContentStore(verifier: verifier, eventBus: bus);
    });

    tearDown(() async {
      await bus.dispose();
    });

    test('Single character modification in text causes immediate FAIL-CLOSED rejection and emits event', () {
      final rejectedEvents = <PackageRejectedEvent>[];
      bus.on<PackageRejectedEvent>().listen(rejectedEvents.add);

      final tamperedPkg = SyntheticFixtures.createTamperedSyntheticPackage();
      final res = verifier.verifyPackage(tamperedPkg);

      // Must fail
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('Hash mismatch'));

      // Event must be dispatched
      expect(rejectedEvents.length, equals(1));
      expect(rejectedEvents.first.packageId, equals(tamperedPkg.packageId));
      expect(rejectedEvents.first.reason, contains('Hash mismatch'));
    });

    test('Store rejects mounting tampered package and preserves empty state', () async {
      final tamperedPkg = SyntheticFixtures.createTamperedSyntheticPackage();
      final mountResult = store.mountPackage(tamperedPkg);

      expect(mountResult.isFailure, isTrue);

      // Querying the store should return not found (Fail-Closed)
      final itemResult = await store.getItem('CONTENT-TEST-001');
      expect(itemResult.isFailure, isTrue);
    });

    test('Rejects package if any record is in DRAFT or UNVERIFIED status (Gate 5 violation)', () {
      final draftRecord = SyntheticFixtures.createSyntheticRecord(
        contentId: 'CONTENT-TEST-DRAFT',
        status: ContentStatus.draft,
      );

      final manifest = PackageManifest(
        packageId: 'PACKAGE-WITH-DRAFT',
        version: '1.0.0',
        targetModule: 'test',
        createdAt: DateTime.utc(2026, 1, 1),
        fileHashes: {'CONTENT-TEST-DRAFT': draftRecord.integrityHash},
        signature: 'VALID_SIG',
        signerIdentity: SyntheticFixtures.testSigner,
      );

      final pkg = ContentPackage(
        manifest: manifest,
        records: [draftRecord],
      );

      final res = verifier.verifyPackage(pkg);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('unauthorized governance status'));
    });

    test('Rejects package if record count differs from manifest count', () {
      final valid = SyntheticFixtures.createValidSyntheticPackage(recordCount: 2);

      // Manifest has 2, but we omit one record
      final incompletePkg = ContentPackage(
        manifest: valid.manifest,
        records: [valid.records.first],
      );

      final res = verifier.verifyPackage(incompletePkg);
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('Record count mismatch'));
    });
  });
}
