import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah User Progress & Persistence Suite (§46..§50, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Progress 1: Viewing event, bookmarking, and adding note persists across module instances', () async {
      await seerahModule.markEventViewed('evt_badr_major');
      await seerahModule.toggleBookmark('evt_badr_major');
      await seerahModule.saveUserNote('evt_badr_major', 'تأمل شخصي في غزوة بدر');

      // Create new instance with same storage
      final restoredModule = SeerahModule(storageRegistry: storage);
      restoredModule.mountPackage(SyntheticSeerahFixtures.createPackage());

      final progRes = await restoredModule.getUserProgress();
      expect(progRes.isSuccess, isTrue);
      final p = progRes.valueOrNull!;

      expect(p.viewedEventIds.contains('evt_badr_major'), isTrue);
      expect(p.bookmarkedEventIds.contains('evt_badr_major'), isTrue);
      expect(p.userNotes['evt_badr_major'], contains('تأمل شخصي'));
      expect(p.lastViewedEventId, equals('evt_badr_major'));
    });
  });
}
