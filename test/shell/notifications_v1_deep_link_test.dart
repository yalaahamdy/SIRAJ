import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Notification Deep Linking & Exact Context Resume Suite (§43, §44, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Deep Links 1: Reminders specify deterministic, safe target routes (§43)', () async {
      final reminders = (await companionModule.getReminders()).valueOrNull!;
      for (final r in reminders) {
        expect(r.targetRoute, isNotNull);
        expect(r.targetRoute!.startsWith('/'), true);
      }
    });
  });
}
