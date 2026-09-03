import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/domain/prayer_adjustments.dart';
import 'package:siraj/modules/prayer/services/user_calibration_service.dart';

void main() {
  group('L2 User Calibration Service Tests (§18)', () {
    late MemoryStorageRegistry storage;
    late UserCalibrationService calibration;

    setUp(() {
      storage = MemoryStorageRegistry();
      calibration = UserCalibrationService(storageRegistry: storage);
    });

    test('Returns default zero adjustments initially', () async {
      final res = await calibration.getAdjustments();
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull, equals(PrayerAdjustments.zero));
      expect(res.valueOrNull?.hasAnyAdjustment, isFalse);
    });

    test('Saves and retrieves custom minute adjustments', () async {
      const custom = PrayerAdjustments(
        fajr: 10,
        dhuhr: -3,
        asr: 0,
        maghrib: 4,
        isha: -5,
      );

      final saveRes = await calibration.saveAdjustments(custom);
      expect(saveRes.isSuccess, isTrue);

      final loadRes = await calibration.getAdjustments();
      expect(loadRes.isSuccess, isTrue);
      final loaded = loadRes.valueOrNull!;

      expect(loaded.fajr, equals(10));
      expect(loaded.dhuhr, equals(-3));
      expect(loaded.maghrib, equals(4));
      expect(loaded.isha, equals(-5));
      expect(loaded.hasAnyAdjustment, isTrue);
    });

    test('Reset adjustments restores zero adjustments', () async {
      await calibration.saveAdjustments(const PrayerAdjustments(fajr: 15));
      await calibration.resetAdjustments();

      final res = await calibration.getAdjustments();
      expect(res.valueOrNull, equals(PrayerAdjustments.zero));
    });
  });
}
