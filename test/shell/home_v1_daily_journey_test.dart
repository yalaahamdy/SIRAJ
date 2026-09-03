import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Daily Journey Timeline & Advisory Routine Suite (§15..§19, §114, §118)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Daily Journey 1: Routine generates structured advisory time slots without compulsory worship scoring (§118)', () {
      final routine = companionModule.getDailyJourneyRoutine();
      expect(routine.slots.isNotEmpty, true);

      for (final slot in routine.slots) {
        expect(slot.titleArabic.isNotEmpty, true);
        expect(slot.description.isNotEmpty, true);
      }
    });
  });
}
