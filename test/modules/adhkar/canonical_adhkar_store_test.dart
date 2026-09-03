import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/modules/adhkar/store/canonical_adhkar_package.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('L2 ReadOnlyAdhkarStore Fail-Closed & Indexing Tests (§26, §27)', () {
    late ReadOnlyAdhkarStore store;
    late CanonicalAdhkarPackage validPackage;

    setUp(() {
      store = ReadOnlyAdhkarStore();
      validPackage = CanonicalAdhkarFixture.createValidTestPackage();
    });

    test('Mounts valid package and serves items by ID and by Occasion with O(1) performance', () {
      final mountRes = store.mountPackage(validPackage);
      expect(mountRes.isSuccess, isTrue);
      expect(store.isMounted, isTrue);

      final itemRes = store.getItemById('dhikr_morning_001');
      expect(itemRes.isSuccess, isTrue);
      expect(itemRes.valueOrNull?.occasion, equals(DhikrOccasion.morning));

      final morningItems = store.getItemsByOccasion(DhikrOccasion.morning);
      expect(morningItems.isSuccess, isTrue);
      expect(morningItems.valueOrNull?.length, equals(1));

      final allItems = store.getAllItems();
      expect(allItems.isSuccess, isTrue);
      expect(allItems.valueOrNull?.length, equals(4));
    });

    test('Fail-Closed: Tampered package is rejected and preserves previous Last Known Good state', () {
      // 1. Mount good package
      store.mountPackage(validPackage);
      expect(store.getAllItems().valueOrNull?.length, equals(4));

      // 2. Attempt to mount corrupted package
      final corruptedItems = List<DhikrItem>.from(validPackage.items);
      corruptedItems[0] = DhikrItem(
        id: corruptedItems[0].id,
        type: corruptedItems[0].type,
        textArabic: 'تعديل غير مصرح به',
        sourceTitle: corruptedItems[0].sourceTitle,
        sourceAuthor: corruptedItems[0].sourceAuthor,
        reference: corruptedItems[0].reference,
        authenticityGrade: corruptedItems[0].authenticityGrade,
        attribution: corruptedItems[0].attribution,
        occasion: corruptedItems[0].occasion,
        repetition: corruptedItems[0].repetition,
        benefit: corruptedItems[0].benefit,
        integrityHash: corruptedItems[0].integrityHash,
      );

      final badPackage = CanonicalAdhkarPackage(
        packageId: 'bad_pkg',
        version: '2.0.0',
        schemaVersion: 1,
        title: 'حزمة تالفة',
        items: corruptedItems,
        contentHash: validPackage.contentHash,
        signerIdentity: validPackage.signerIdentity,
        signature: validPackage.signature,
        publishedAt: DateTime.utc(2026, 9, 1),
      );

      final badMountRes = store.mountPackage(badPackage);
      expect(badMountRes.isFailure, isTrue);

      // Verify Last Known Good package remains active and intact
      expect(store.activePackage?.packageId, equals(validPackage.packageId));
      expect(store.getAllItems().valueOrNull?.length, equals(4));
    });

    test('Unmounted store returns ContentNotFoundFailure safely', () {
      expect(store.isMounted, isFalse);

      final res = store.getItemById('dhikr_morning_001');
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message.contains('No Adhkar package'), isTrue);
    });
  });
}
