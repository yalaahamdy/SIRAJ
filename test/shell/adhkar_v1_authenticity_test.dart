import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Authenticity Grade & Scholarly Attribution Suite (§38..§44, §119, §124)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Authenticity 1: Every Dhikr item preserves its canonical AuthenticityGrade and source metadata', () {
      final items = module.getAllItems().valueOrNull!;
      expect(items.isNotEmpty, true);

      for (final item in items) {
        expect(item.authenticityGrade.labelArabic.isNotEmpty, true);
        expect(item.sourceTitle.isNotEmpty, true);
      }
    });
  });
}
