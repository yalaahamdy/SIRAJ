import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Adhkar Session Interruption & Resume Suite (§22, §23, §108, §119)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Resume 1: Interrupted counter session safely preserves and resumes exact count (§22, §108)', () async {
      final item = module.getAllItems().valueOrNull!.first;

      // Count 2 times
      await module.incrementProgress(contentId: item.id, targetCount: 10);
      await module.incrementProgress(contentId: item.id, targetCount: 10);

      // Return and resume
      final resumed = await module.getProgress(item.id, 10);
      expect(resumed.isSuccess, true);
      expect(resumed.valueOrNull!.currentCount, 2);
    });
  });
}
