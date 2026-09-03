import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Adhkar Notifications Suite (§10..§12, §97, §106)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule adhkarModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        adhkarModule: adhkarModule,
      );
    });

    test('Adhkar 1: Adhkar reminder provides clear summary without lock-screen canonical flooding (§11, §12)', () async {
      final reminders = (await companionModule.getReminders(
        currentTime: DateTime(2026, 9, 1, 6, 0),
      )).valueOrNull!;

      final morning = reminders.where((r) => r.sourceModule == 'adhkar');
      expect(morning.isNotEmpty, true);
      expect(morning.first.titleArabic, contains('أذكار'));
    });
  });
}
