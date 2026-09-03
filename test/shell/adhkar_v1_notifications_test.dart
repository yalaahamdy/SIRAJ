import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Adhkar Notifications & Respectful Reminders Suite (§56..§60, §119, §127)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    test('Notifications 1: Reminders provide respectful context without shaming language (§57, §127)', () {
      final morningReminder = module.getOccasionExplanation(DhikrOccasion.morning);
      expect(morningReminder.isNotEmpty, true);
      expect(morningReminder, isNot(contains('فاتك')));
      expect(morningReminder, isNot(contains('متأخر')));
    });
  });
}
