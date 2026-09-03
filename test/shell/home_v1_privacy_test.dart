import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Privacy & Zero Religious Profiling Suite (§68, §114, §119)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Privacy 1: Privacy assertion — Home orchestration contains zero piety scoring or spiritual grading (§68, §119)', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      for (final card in cards) {
        expect(card.titleArabic, isNot(contains('مستوى تدينك')));
        expect(card.titleArabic, isNot(contains('درجة إيمانك')));
        expect(card.subtitleArabic, isNot(contains('أنت مقصر')));
      }
    });
  });
}
