import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_notification_settings.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/engine/astronomical_calculator.dart';
import 'package:siraj/modules/prayer/services/prayer_notification_service.dart';
import 'package:siraj/modules/prayer/services/prayer_schedule_service.dart';

void main() {
  group('Prayer Notification Settings Domain Tests (§17, §32)', () {
    test('Default settings initialize all obligatory prayers to full Athan', () {
      final settings = PrayerNotificationSettings.defaultSettings();

      expect(settings.masterVolume, equals(0.85));
      expect(settings.isVibrationEnabled, isTrue);

      final fajr = settings.getSettingFor(PrayerType.fajr);
      expect(fajr.mode, equals(PrayerNotificationMode.fullAthan));
      expect(fajr.preAthanMinutes, equals(0));
      expect(fajr.iqamaMinutes, equals(0));
      expect(fajr.soundOptionId, equals('abdulbasit'));

      final dhuhr = settings.getSettingFor(PrayerType.dhuhr);
      expect(dhuhr.mode, equals(PrayerNotificationMode.fullAthan));
      expect(dhuhr.iqamaMinutes, equals(0));
    });

    test('Per-prayer custom configuration and serialization round-trip', () {
      var settings = PrayerNotificationSettings.defaultSettings();

      // Customize Asr to be takbeerOnly with 10 min pre-alert
      settings = settings.updatePrayerSetting(
        const PerPrayerNotificationSetting(
          prayerType: PrayerType.asr,
          mode: PrayerNotificationMode.takbeerOnly,
          preAthanMinutes: 10,
          iqamaMinutes: 15,
        ),
      );

      final asr = settings.getSettingFor(PrayerType.asr);
      expect(asr.mode, equals(PrayerNotificationMode.takbeerOnly));
      expect(asr.preAthanMinutes, equals(10));

      final json = settings.toJson();
      final restored = PrayerNotificationSettings.fromJson(json);

      expect(restored.masterVolume, equals(settings.masterVolume));
      expect(restored.isVibrationEnabled, equals(settings.isVibrationEnabled));
      expect(restored.getSettingFor(PrayerType.asr), equals(asr));
    });

    test('PrayerNotificationService generates Pre-Athan, Athan, and Iqama reminders', () {
      final clock = TestClock(DateTime.utc(2026, 3, 21, 11, 0, 0));
      const calculator = AstronomicalPrayerCalculator();
      final scheduleService = PrayerScheduleService(engine: calculator, clock: clock);

      final scheduleRes = scheduleService.getSchedule(
        date: DateTime.utc(2026, 3, 21),
        location: const GeoCoordinates(
          latitude: 21.4225,
          longitude: 39.8262,
          source: LocationSource.manual,
        ),
        parameters: CalculationParameters.ummAlQura,
      );

      expect(scheduleRes.isSuccess, isTrue);
      final schedule = scheduleRes.valueOrNull!;

      final notifService = PrayerNotificationService(clock: clock);

      // Custom settings: Dhuhr has 15 min pre-alert, full Athan, and 20 min iqama
      final customSettings = PrayerNotificationSettings.defaultSettings().updatePrayerSetting(
        const PerPrayerNotificationSetting(
          prayerType: PrayerType.dhuhr,
          mode: PrayerNotificationMode.fullAthan,
          preAthanMinutes: 15,
          iqamaMinutes: 20,
        ),
      );

      final result = notifService.scheduleDailyPrayers(
        schedule: schedule,
        now: DateTime.utc(2026, 3, 21, 5, 0, 0),
        customSettings: customSettings,
      );

      expect(result.isSuccess, isTrue);
      final list = result.valueOrNull!;
      expect(list.isNotEmpty, isTrue);

      // Verify Dhuhr entries
      final dhuhrPre = list.firstWhere((n) => n.prayerType == PrayerType.dhuhr && n.isPreAthan);
      final dhuhrMain = list.firstWhere((n) => n.prayerType == PrayerType.dhuhr && !n.isPreAthan && !n.isIqama);
      final dhuhrIqama = list.firstWhere((n) => n.prayerType == PrayerType.dhuhr && n.isIqama);

      expect(dhuhrPre.title, contains('اقترب وقت صلاة الظهر'));
      expect(dhuhrMain.title, contains('حان الآن وقت صلاة الظهر'));
      expect(dhuhrMain.mode, equals(PrayerNotificationMode.fullAthan));
      expect(dhuhrIqama.title, contains('حان وقت إقامة صلاة الظهر'));

      // Verify timing relationships
      final dhuhrTime = schedule.entries[PrayerType.dhuhr]!.time;
      expect(dhuhrPre.scheduledTime, equals(dhuhrTime.subtract(const Duration(minutes: 15))));
      expect(dhuhrMain.scheduledTime, equals(dhuhrTime));
      expect(dhuhrIqama.scheduledTime, equals(dhuhrTime.add(const Duration(minutes: 20))));
    });

    test('Disabled prayer mode excludes reminders completely', () {
      final clock = TestClock(DateTime.utc(2026, 3, 21, 11, 0, 0));
      const calculator = AstronomicalPrayerCalculator();
      final scheduleService = PrayerScheduleService(engine: calculator, clock: clock);

      final scheduleRes = scheduleService.getSchedule(
        date: DateTime.utc(2026, 3, 21),
        location: const GeoCoordinates(
          latitude: 21.4225,
          longitude: 39.8262,
          source: LocationSource.manual,
        ),
        parameters: CalculationParameters.ummAlQura,
      );

      final schedule = scheduleRes.valueOrNull!;
      final notifService = PrayerNotificationService(clock: clock);

      // Disable Isha
      final customSettings = PrayerNotificationSettings.defaultSettings().updatePrayerSetting(
        const PerPrayerNotificationSetting(
          prayerType: PrayerType.isha,
          mode: PrayerNotificationMode.disabled,
        ),
      );

      final list = notifService
          .scheduleDailyPrayers(
            schedule: schedule,
            now: DateTime.utc(2026, 3, 21, 11, 0, 0),
            customSettings: customSettings,
          )
          .valueOrNull!;

      expect(list.any((n) => n.prayerType == PrayerType.isha), isFalse);
    });
  });
}
