import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/seerah/domain/canonical_seerah_package.dart';
import 'package:siraj/modules/seerah/domain/seerah_event.dart';
import 'package:siraj/modules/seerah/store/read_only_seerah_store.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('L2 Seerah Package Cryptographic Integrity & Fail-Closed Tests (§28, §29)', () {
    late ReadOnlySeerahStore store;

    setUp(() {
      store = ReadOnlySeerahStore();
    });

    test('Valid synthetic package passes all integrity and cryptographic checks', () {
      final pkg = SyntheticSeerahFixtures.createPackage();
      final res = store.mountPackage(pkg);

      expect(res.isSuccess, isTrue);
      expect(store.isMounted, isTrue);
      expect(store.verifyIntegrity(), isTrue);
    });

    test('Rejects package if any individual Event summary is tampered', () {
      final validPkg = SyntheticSeerahFixtures.createPackage();
      final validEvent = validPkg.events.first;

      // Tampered event with different summary but keeping old hash
      final tamperedEvent = SeerahEvent(
        eventId: validEvent.eventId,
        title: validEvent.title,
        periodId: validEvent.periodId,
        historicalDate: validEvent.historicalDate,
        summary: 'ملخص محرف غير موثق',
        sourceIds: validEvent.sourceIds,
        integrityHash: validEvent.integrityHash, // Old hash
      );

      final tamperedPkg = CanonicalSeerahPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        periods: validPkg.periods,
        events: [tamperedEvent],
        persons: validPkg.persons,
        relationships: validPkg.relationships,
        places: validPkg.places,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final res = store.mountPackage(tamperedPkg);
      expect(res.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });

    test('Rejects package with empty signature or signer identity', () {
      final validPkg = SyntheticSeerahFixtures.createPackage();
      final invalidPkg = CanonicalSeerahPackage(
        packageId: validPkg.packageId,
        schemaVersion: validPkg.schemaVersion,
        periods: validPkg.periods,
        events: validPkg.events,
        persons: validPkg.persons,
        relationships: validPkg.relationships,
        places: validPkg.places,
        contentHash: validPkg.contentHash,
        signerIdentity: '',
        signature: '',
        publishedAt: validPkg.publishedAt,
      );

      final res = store.mountPackage(invalidPkg);
      expect(res.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });
  });
}
