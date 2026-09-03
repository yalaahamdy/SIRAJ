import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/events/app_events.dart';
import 'package:siraj/core/events/event_bus.dart';
import 'package:siraj/platform/content/domain/content_type.dart';
import 'package:siraj/platform/content/package/package_verifier.dart';
import 'package:siraj/platform/content/store/read_only_content_store.dart';
import '../fixtures/synthetic_packages.dart';

void main() {
  group('L1 ReadOnlyContentStore Tests', () {
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

    test('Mounts valid package and serves read-only items and collections', () async {
      final installedEvents = <PackageInstalledEvent>[];
      bus.on<PackageInstalledEvent>().listen(installedEvents.add);

      final package = SyntheticFixtures.createValidSyntheticPackage(recordCount: 3);
      final mountRes = store.mountPackage(package);

      expect(mountRes.isSuccess, isTrue);
      expect(installedEvents.length, equals(1));

      // Query single item
      final itemRes = await store.getItem('CONTENT-TEST-001');
      expect(itemRes.isSuccess, isTrue);
      expect(itemRes.valueOrNull?.text, contains('SYNTHETIC_PAYLOAD'));

      // Query collection
      final colRes = await store.getCollection(ContentType.testFixture);
      expect(colRes.isSuccess, isTrue);
      expect(colRes.valueOrNull?.length, equals(3));

      // Installed version
      final version = await store.installedVersion(package.packageId);
      expect(version, equals('1.0.0'));
    });

    test('Returns ContentNotFoundFailure for unmounted or non-existent items', () async {
      final itemRes = await store.getItem('NON_EXISTENT_ID');
      expect(itemRes.isFailure, isTrue);
      expect(itemRes.failureOrNull?.message, contains('not found'));
    });

    test('verifyIntegrity verifies all currently mounted packages successfully', () async {
      final package = SyntheticFixtures.createValidSyntheticPackage();
      store.mountPackage(package);

      final integrityRes = await store.verifyIntegrity();
      expect(integrityRes.isSuccess, isTrue);
      expect(integrityRes.valueOrNull, isTrue);
    });
  });
}
