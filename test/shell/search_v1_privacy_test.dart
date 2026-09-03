import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Search Privacy & Zero Religious Profiling Suite (§7, §56..§58, §79, §93, §96)', () {
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

    test('Privacy 1: Search queries are not persisted into private religious profiles (§56, §96)', () async {
      await companionModule.search('الاستغفار والتوبة');

      // User preferences remain pristine without search behavior profiling
      final prefs = (await companionModule.getPreferences()).valueOrNull!;
      expect(prefs.hiddenCardIds.isEmpty, true);
    });
  });
}
