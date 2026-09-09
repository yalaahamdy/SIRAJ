import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/persistent_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('siraj_storage_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('PersistentKeyValueStore stores and reads primitives and persists to disk', () async {
    final store1 = PersistentKeyValueStore('mod_memorization', tempDir);
    await store1.setString('test_key', 'test_value');
    await store1.setInt('test_int', 42);
    await store1.setBool('test_bool', true);

    expect((await store1.getString('test_key')).valueOrNull, 'test_value');
    expect((await store1.getInt('test_int')).valueOrNull, 42);
    expect((await store1.getBool('test_bool')).valueOrNull, true);

    // Re-instantiate from disk to verify true persistence
    final store2 = PersistentKeyValueStore('mod_memorization', tempDir);
    expect((await store2.getString('test_key')).valueOrNull, 'test_value');
    expect((await store2.getInt('test_int')).valueOrNull, 42);
    expect((await store2.getBool('test_bool')).valueOrNull, true);
  });

  test('PersistentStorageRegistry manages stores and persists plan data', () async {
    final registry1 = PersistentStorageRegistry(tempDir);
    final memStore = registry1.getStoreForModule('mod_memorization');

    final plan = MemorizationPlan(
      id: 'test_plan_1',
      title: 'خطة تجريبية',
      targetSurahs: const [114, 113],
      startAyah: const AyahKey(surahNumber: 114, ayahNumber: 1),
      endAyah: const AyahKey(surahNumber: 113, ayahNumber: 5),
      dailyNewAyahs: 7,
      dailyReviewTarget: 14,
      targetDate: DateTime.utc(2026, 12, 31),
      isActive: true,
      createdAt: DateTime.utc(2026, 9, 9),
    );

    await memStore.setString('memorization_plan', plan.toMap().toString());

    // Verify re-opening registry loads the persisted plan
    final registry2 = PersistentStorageRegistry(tempDir);
    final memStore2 = registry2.getStoreForModule('mod_memorization');
    final res = await memStore2.getString('memorization_plan');
    expect(res.isSuccess, true);
    expect(res.valueOrNull, contains('test_plan_1'));
  });
}
