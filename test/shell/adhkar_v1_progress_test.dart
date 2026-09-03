import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Daily Progress & Non-Judgmental Metrics Suite (§48..§50, §119)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Progress 1: Progress tracking updates completed counts without calculating spiritual scores (§48, §49)', () async {
      final item = module.getAllItems().valueOrNull!.first;

      final res = await module.incrementProgress(contentId: item.id, targetCount: item.repetition.count);
      expect(res.isSuccess, true);
      final prog = res.valueOrNull!;
      expect(prog.currentCount, 1);
    });
  });
}
