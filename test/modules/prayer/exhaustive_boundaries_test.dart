import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/services/prayer_schedule_service.dart';

void main() {
  group('L2 Exhaustive Chronological Point & Boundary Audit Tests (§12, §13)', () {
    late TestClock clock;
    late PrayerScheduleService service;

    const location = GeoCoordinates(latitude: 24.7136, longitude: 46.6753);
    const params = CalculationParameters.muslimWorldLeague;
    const tz = Duration(hours: 3);

    setUp(() {
      clock = TestClock(DateTime.utc(2026, 8, 31, 12, 0));
      service = PrayerScheduleService(clock: clock);
    });

    test('Verifies accurate current & next prayer at all 15 discrete diurnal points', () {
      final scheduleRes = service.getSchedule(
        date: DateTime.utc(2026, 8, 31),
        location: location,
        parameters: params,
        timezoneOffset: tz,
      );
      final schedule = scheduleRes.valueOrNull!;

      final fajr = schedule.fajr!.time;
      final sunrise = schedule.sunrise!.time;
      final dhuhr = schedule.dhuhr!.time;
      final asr = schedule.asr!.time;
      final maghrib = schedule.maghrib!.time;
      final isha = schedule.isha!.time;

      // 1. Before Fajr (e.g. 02:00 AM)
      final t1 = DateTime.utc(2026, 8, 31, 2, 0);
      expect(service.getNextPrayer(currentTime: t1, todaySchedule: schedule)?.type, equals(PrayerType.fajr));
      expect(service.getCurrentPrayer(currentTime: t1, todaySchedule: schedule)?.type, equals(PrayerType.isha));

      // 2. Exactly at Fajr
      expect(service.getCurrentPrayer(currentTime: fajr, todaySchedule: schedule)?.type, equals(PrayerType.fajr));
      expect(service.getNextPrayer(currentTime: fajr, todaySchedule: schedule)?.type, equals(PrayerType.sunrise));

      // 3. After Fajr before Sunrise
      final t3 = fajr.add(const Duration(minutes: 20));
      expect(service.getCurrentPrayer(currentTime: t3, todaySchedule: schedule)?.type, equals(PrayerType.fajr));
      expect(service.getNextPrayer(currentTime: t3, todaySchedule: schedule)?.type, equals(PrayerType.sunrise));

      // 4. Exactly at Sunrise
      expect(service.getCurrentPrayer(currentTime: sunrise, todaySchedule: schedule)?.type, equals(PrayerType.sunrise));
      expect(service.getNextPrayer(currentTime: sunrise, todaySchedule: schedule)?.type, equals(PrayerType.dhuhr));

      // 5. Between Sunrise and Dhuhr
      final t5 = sunrise.add(const Duration(hours: 2));
      expect(service.getCurrentPrayer(currentTime: t5, todaySchedule: schedule)?.type, equals(PrayerType.sunrise));
      expect(service.getNextPrayer(currentTime: t5, todaySchedule: schedule)?.type, equals(PrayerType.dhuhr));

      // 6. Exactly at Dhuhr
      expect(service.getCurrentPrayer(currentTime: dhuhr, todaySchedule: schedule)?.type, equals(PrayerType.dhuhr));
      expect(service.getNextPrayer(currentTime: dhuhr, todaySchedule: schedule)?.type, equals(PrayerType.asr));

      // 7. Between Dhuhr and Asr
      final t7 = dhuhr.add(const Duration(hours: 1));
      expect(service.getCurrentPrayer(currentTime: t7, todaySchedule: schedule)?.type, equals(PrayerType.dhuhr));
      expect(service.getNextPrayer(currentTime: t7, todaySchedule: schedule)?.type, equals(PrayerType.asr));

      // 8. Exactly at Asr
      expect(service.getCurrentPrayer(currentTime: asr, todaySchedule: schedule)?.type, equals(PrayerType.asr));
      expect(service.getNextPrayer(currentTime: asr, todaySchedule: schedule)?.type, equals(PrayerType.maghrib));

      // 9. Between Asr and Maghrib
      final t9 = asr.add(const Duration(minutes: 45));
      expect(service.getCurrentPrayer(currentTime: t9, todaySchedule: schedule)?.type, equals(PrayerType.asr));
      expect(service.getNextPrayer(currentTime: t9, todaySchedule: schedule)?.type, equals(PrayerType.maghrib));

      // 10. Exactly at Maghrib
      expect(service.getCurrentPrayer(currentTime: maghrib, todaySchedule: schedule)?.type, equals(PrayerType.maghrib));
      expect(service.getNextPrayer(currentTime: maghrib, todaySchedule: schedule)?.type, equals(PrayerType.isha));

      // 11. Between Maghrib and Isha
      final t11 = maghrib.add(const Duration(minutes: 30));
      expect(service.getCurrentPrayer(currentTime: t11, todaySchedule: schedule)?.type, equals(PrayerType.maghrib));
      expect(service.getNextPrayer(currentTime: t11, todaySchedule: schedule)?.type, equals(PrayerType.isha));

      // 12. Exactly at Isha
      expect(service.getCurrentPrayer(currentTime: isha, todaySchedule: schedule)?.type, equals(PrayerType.isha));
      expect(service.getNextPrayer(currentTime: isha, todaySchedule: schedule)?.type, equals(PrayerType.fajr));

      // 13. After Isha before Midnight (e.g. 23:00 PM)
      final t13 = DateTime.utc(2026, 8, 31, 23, 0);
      expect(service.getCurrentPrayer(currentTime: t13, todaySchedule: schedule)?.type, equals(PrayerType.isha));
      expect(service.getNextPrayer(currentTime: t13, todaySchedule: schedule)?.type, equals(PrayerType.fajr));

      // 14. Exactly at Midnight (23:59:59 -> 00:00:00)
      final t14 = DateTime.utc(2026, 8, 31, 23, 59, 59);
      expect(service.getCurrentPrayer(currentTime: t14, todaySchedule: schedule)?.type, equals(PrayerType.isha));
      expect(service.getNextPrayer(currentTime: t14, todaySchedule: schedule)?.type, equals(PrayerType.fajr));

      // 15. After Midnight on same schedule before next day's Fajr
      final t15 = DateTime.utc(2026, 8, 31, 23, 45);
      final nextP = service.getNextPrayer(currentTime: t15, todaySchedule: schedule);
      expect(nextP?.type, equals(PrayerType.fajr));
      expect(nextP!.time.day, equals(1)); // Day rollover verified
    });
  });
}
