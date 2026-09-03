import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';

void main() {
  group('L0 Storage Boundary & KeyValueStore Tests', () {
    late MemoryStorageRegistry registry;

    setUp(() {
      registry = MemoryStorageRegistry();
    });

    test('Enforces mod_ or sys_ prefix for module namespaces', () {
      expect(() => registry.getStoreForModule('mod_prayer'), returnsNormally);
      expect(() => registry.getStoreForModule('sys_config'), returnsNormally);
      expect(
        () => registry.getStoreForModule('unprefixed_module'),
        throwsArgumentError,
      );
    });

    test('Stores and retrieves typed values in isolated module namespaces', () async {
      final store1 = registry.getStoreForModule('mod_prayer');
      final store2 = registry.getStoreForModule('mod_quran');

      await store1.setString('last_calc_method', 'MWL');
      await store2.setString('last_calc_method', 'ISNA');

      final val1 = await store1.getString('last_calc_method');
      final val2 = await store2.getString('last_calc_method');

      expect(val1.valueOrNull, equals('MWL'));
      expect(val2.valueOrNull, equals('ISNA'));
    });

    test('MemoryKeyValueStore operations (ints, bools, remove, clear)', () async {
      final store = registry.getStoreForModule('mod_test');

      await store.setInt('count', 10);
      await store.setBool('active', true);

      expect((await store.getInt('count')).valueOrNull, equals(10));
      expect((await store.getBool('active')).valueOrNull, isTrue);

      await store.remove('count');
      expect((await store.getInt('count')).valueOrNull, isNull);

      await store.clear();
      expect((await store.getBool('active')).valueOrNull, isNull);
    });
  });
}
