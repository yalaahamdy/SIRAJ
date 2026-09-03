import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Notification Privacy & Zero Financial/Piety Leakage Suite (§8, §14, §17, §51..§53, §105, §106, §110)', () {
    late MemoryStorageRegistry storage;
    late ZakatModule zakatModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: storage);
      companionModule = CompanionModule(
        storageRegistry: storage,
        zakatModule: zakatModule,
      );
    });

    test('Privacy 1: Reminders never leak financial zakat balances, debts, or piety profiles onto lock-screen (§17, §51, §110)', () async {
      final reminders = (await companionModule.getReminders()).valueOrNull!;

      for (final r in reminders) {
        expect(r.messageArabic.contains('ريال'), false);
        expect(r.messageArabic.contains('دولار'), false);
        expect(r.messageArabic.contains('نصاب'), false);
        expect(r.messageArabic.contains('مستوى تدين'), false);
      }
    });
  });
}
