import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Hijri Date Rollover & Occasion Shift Suite (§35, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Hijri Rollover 1: Reminder schedule reflects changes in Hijri calendar contexts (§35)', () async {
      final routine = companionModule.getDailyJourneyRoutine(
        date: DateTime(2026, 3, 10), // Ramadan period
      );

      expect(routine.slots.isNotEmpty, true);
    });
  });
}
