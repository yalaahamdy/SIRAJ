import 'package:flutter/foundation.dart';
import '../location/location_models.dart';
import '../../modules/prayer/domain/calculation_parameters.dart';
import '../../modules/prayer/domain/prayer_adjustments.dart';
import '../../modules/prayer/domain/prayer_notification_settings.dart';
import '../../modules/prayer/domain/prayer_type.dart';
import '../../modules/prayer/prayer_module.dart';
import 'siraj_notification_manager.dart';

/// محرك الجدولة الاستباقي الشامل للتنبيهات الخارجية في نظام أندرويد (Rolling 14-Day Auto-Scheduler)
///
/// يضمن عمل كافة الإشعارات (الأذان، الصلوات، الأذكار، قيام الليل، الضحى، سنن الجمعة، صيام النوافل، وورد القرآن)
/// بشكل خارجي ومستقل تماماً عن تشغيل التطبيق أو كونه مفتوحاً في الواجهة، ولمدة 14 يوماً قادمة في AlarmManager.
class SirajAutoSchedulerService {
  static final SirajAutoSchedulerService instance = SirajAutoSchedulerService._internal();

  SirajAutoSchedulerService._internal();

  DateTime? _lastScheduledTime;
  int _lastScheduledCount = 0;

  DateTime? get lastScheduledTime => _lastScheduledTime;
  int get lastScheduledCount => _lastScheduledCount;

  // معرفات الفئات الثابتة لمنع أي تضارب بين الإشعارات
  static const int basePreAthan = 10000;
  static const int baseAthan = 20000;
  static const int baseIqama = 30000;
  static const int baseAdhkar = 40000;
  static const int baseQiyam = 50000;
  static const int baseDuha = 60000;
  static const int baseFriday = 70000;
  static const int baseQuranWird = 80000;
  static const int baseFastingSuhoor = 90000;
  static const int baseFastingIftar = 95000;

  /// جدولة شاملة لـ 14 يوماً قادمة في نظام أندرويد
  Future<int> scheduleRolling14Days({
    required PrayerModule prayerModule,
    GeoCoordinates? location,
    CalculationParameters? parameters,
    PrayerAdjustments? adjustments,
    int daysCount = 14,
  }) async {
    final now = DateTime.now();
    final effectiveLocation = location ??
        const GeoCoordinates(latitude: 30.0444, longitude: 31.2357, cityName: 'القاهرة');

    final effectiveParams = parameters ?? CalculationParameters.egyptian;
    final effectiveAdj = adjustments ??
        (await prayerModule.calibrationService.getAdjustments()).valueOrNull ??
        PrayerAdjustments.zero;
    final settings = prayerModule.notificationService.settings;

    int totalScheduled = 0;

    for (int dayOffset = 0; dayOffset < daysCount; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final dateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);

      // 1. حساب مواقيت الصلاة لليوم المحدد
      final scheduleRes = await prayerModule.getSchedule(
        date: dateOnly,
        location: effectiveLocation,
        parameters: effectiveParams,
        adjustments: effectiveAdj,
      );

      if (!scheduleRes.isSuccess || scheduleRes.valueOrNull == null) {
        continue;
      }

      final schedule = scheduleRes.valueOrNull!;

      // 2. جدولة الصلوات الخمس لليوم المحدد
      for (final entry in schedule.obligatoryPrayers) {
        final perPrayer = settings.getSettingFor(entry.type);
        if (perPrayer.mode == PrayerNotificationMode.disabled) continue;

        final prayerIdx = entry.type.index;

        // أ) تنبيه ما قبل الأذان
        if (perPrayer.preAthanMinutes > 0) {
          final preTime = entry.time.subtract(Duration(minutes: perPrayer.preAthanMinutes));
          if (preTime.isAfter(now)) {
            final preId = basePreAthan + (dayOffset * 100) + prayerIdx;
            await SirajNotificationManager.instance.schedulePrayerNotification(
              id: preId,
              title: 'اقترب وقت صلاة ${entry.type.nameArabic}',
              body: 'بقي ${perPrayer.preAthanMinutes} دقيقة على دخول الوقت — استعد وتوضأ',
              scheduledTime: preTime,
              playAthanSound: false,
              payload: 'siraj_pre_${entry.type.name}',
            );
            totalScheduled++;
          }
        }

        // ب) أذان الصلاة الأساسي بالصوت الكامل
        if (entry.time.isAfter(now)) {
          final athanId = baseAthan + (dayOffset * 100) + prayerIdx;
          final isAthanAudio = perPrayer.mode == PrayerNotificationMode.fullAthan ||
              perPrayer.mode == PrayerNotificationMode.takbeerOnly;

          await SirajNotificationManager.instance.schedulePrayerNotification(
            id: athanId,
            title: 'حان الآن موعد أذان ${entry.type.nameArabic}',
            body: 'حي على الصلاة، حي على الفلاح — أقبل على صلاتك وذكر ربك',
            scheduledTime: entry.time,
            playAthanSound: isAthanAudio,
            payload: 'siraj_athan_${entry.type.name}',
          );
          totalScheduled++;
        }

        // ج) تنبيه الإقامة
        if (perPrayer.iqamaMinutes > 0) {
          final iqamaTime = entry.time.add(Duration(minutes: perPrayer.iqamaMinutes));
          if (iqamaTime.isAfter(now)) {
            final iqamaId = baseIqama + (dayOffset * 100) + prayerIdx;
            await SirajNotificationManager.instance.schedulePrayerNotification(
              id: iqamaId,
              title: 'حان وقت إقامة صلاة ${entry.type.nameArabic}',
              body: 'استعد للصلاة بخشوع وسكينة وأقبل على ربك',
              scheduledTime: iqamaTime,
              playAthanSound: false,
              payload: 'siraj_iqama_${entry.type.name}',
            );
            totalScheduled++;
          }
        }
      }

      // 3. أذكار الصباح (بعد الشروق بـ 20 دقيقة أو 6:30 ص)
      final morningTime = schedule.sunrise != null
          ? schedule.sunrise!.time.add(const Duration(minutes: 20))
          : DateTime(dateOnly.year, dateOnly.month, dateOnly.day, 6, 30);
      if (morningTime.isAfter(now)) {
        final morningId = baseAdhkar + (dayOffset * 100) + 1;
        await SirajNotificationManager.instance.scheduleAdhkarNotification(
          id: morningId,
          title: 'أذكار الصباح ☀️',
          body: 'أصبحنا وأصبح الملك لله والحمد لله — ابدأ يومك بنور الذكر واليقين',
          scheduledTime: morningTime,
          payload: 'siraj_adhkar_morning',
        );
        totalScheduled++;
      }

      // 4. أذكار المساء (بعد العصر بـ 30 دقيقة أو 5:00 م)
      DateTime eveningTime;
      try {
        final asrPrayer = schedule.obligatoryPrayers.firstWhere(
          (p) => p.type.name == 'asr',
        );
        eveningTime = asrPrayer.time.add(const Duration(minutes: 30));
      } catch (_) {
        eveningTime = DateTime(dateOnly.year, dateOnly.month, dateOnly.day, 17, 0);
      }
      if (eveningTime.isAfter(now)) {
        final eveningId = baseAdhkar + (dayOffset * 100) + 2;
        await SirajNotificationManager.instance.scheduleAdhkarNotification(
          id: eveningId,
          title: 'أذكار المساء 🌙',
          body: 'أمسينا وأمسى الملك لله — حصّن نفسك وبيتك بأذكار المساء المباركة',
          scheduledTime: eveningTime,
          payload: 'siraj_adhkar_evening',
        );
        totalScheduled++;
      }

      // 5. أذكار النوم (الساعة 10:00 مساءً)
      final sleepTime = DateTime(dateOnly.year, dateOnly.month, dateOnly.day, 22, 0);
      if (sleepTime.isAfter(now)) {
        final sleepId = baseAdhkar + (dayOffset * 100) + 3;
        await SirajNotificationManager.instance.scheduleAdhkarNotification(
          id: sleepId,
          title: 'أذكار النوم 🛏️',
          body: 'باسمك ربي وضعت جنبي وبك أرفعه — اختم يومك بذكر وطمأنينة',
          scheduledTime: sleepTime,
          payload: 'siraj_adhkar_sleep',
        );
        totalScheduled++;
      }

      // 6. قيام الليل والثلث الأخير (قبل الفجر بـ 90 دقيقة)
      try {
        final fajrPrayer = schedule.obligatoryPrayers.firstWhere(
          (p) => p.type.name == 'fajr',
        );
        final qiyamTime = fajrPrayer.time.subtract(const Duration(minutes: 90));
        if (qiyamTime.isAfter(now)) {
          final qiyamId = baseQiyam + (dayOffset * 100);
          await SirajNotificationManager.instance.scheduleQiyamNotification(
            id: qiyamId,
            scheduledTime: qiyamTime,
          );
          totalScheduled++;
        }
      } catch (_) {}

      // 7. صلاة الضحى (بعد الشروق بـ 45 دقيقة)
      if (schedule.sunrise != null) {
        final duhaTime = schedule.sunrise!.time.add(const Duration(minutes: 45));
        if (duhaTime.isAfter(now)) {
          final duhaId = baseDuha + (dayOffset * 100);
          await SirajNotificationManager.instance.scheduleDuhaNotification(
            id: duhaId,
            scheduledTime: duhaTime,
          );
          totalScheduled++;
        }
      }

      // 8. سنن يوم الجمعة (صباح كل جمعة الساعة 9:00 صباحاً)
      if (dateOnly.weekday == DateTime.friday) {
        final fridayTime = DateTime(dateOnly.year, dateOnly.month, dateOnly.day, 9, 0);
        if (fridayTime.isAfter(now)) {
          final fridayId = baseFriday + (dayOffset * 100);
          await SirajNotificationManager.instance.scheduleFridayReminder(
            id: fridayId,
            scheduledTime: fridayTime,
          );
          totalScheduled++;
        }
      }

      // 9. ورد التحفيظ القرآني اليومي (الساعة 7:30 مساءً)
      final wirdTime = DateTime(dateOnly.year, dateOnly.month, dateOnly.day, 19, 30);
      if (wirdTime.isAfter(now)) {
        final wirdId = baseQuranWird + (dayOffset * 100);
        await SirajNotificationManager.instance.scheduleQuranWirdNotification(
          id: wirdId,
          title: 'ورد القرآن والتحفيظ اليومي 📖',
          body: 'رتل آياتك وثبّت حفظك اليومي، ما زاحم القرآن شيئاً إلا باركه ونوّره',
          scheduledTime: wirdTime,
          payload: 'siraj_quran_wird',
        );
        totalScheduled++;
      }

      // 10. صيام النوافل (الإثنين والخميس)
      if (dateOnly.weekday == DateTime.monday || dateOnly.weekday == DateTime.thursday) {
        try {
          final fajrPrayer = schedule.obligatoryPrayers.firstWhere((p) => p.type.name == 'fajr');
          final suhoorTime = fajrPrayer.time.subtract(const Duration(minutes: 45));
          if (suhoorTime.isAfter(now)) {
            final suhoorId = baseFastingSuhoor + (dayOffset * 100);
            await SirajNotificationManager.instance.scheduleFastingNotification(
              id: suhoorId,
              title: 'تنبيه السحور 🥣',
              body: 'تسحروا فإن في السحور بركة، استعد لصيام نافلة مباركة اليوم',
              scheduledTime: suhoorTime,
              payload: 'siraj_fasting_suhoor',
            );
            totalScheduled++;
          }

          final maghribPrayer = schedule.obligatoryPrayers.firstWhere((p) => p.type.name == 'maghrib');
          if (maghribPrayer.time.isAfter(now)) {
            final iftarId = baseFastingIftar + (dayOffset * 100);
            await SirajNotificationManager.instance.scheduleFastingNotification(
              id: iftarId,
              title: 'موعد الإفطار المبارك 🌴',
              body: 'ذهب الظمأ وابتلت العروق وثبت الأجر إن شاء الله، تقبل الله صيامكم وطاعتكم',
              scheduledTime: maghribPrayer.time,
              payload: 'siraj_fasting_iftar',
            );
            totalScheduled++;
          }
        } catch (_) {}
      }
    }

    _lastScheduledTime = DateTime.now();
    _lastScheduledCount = totalScheduled;

    debugPrint('SirajAutoSchedulerService: Successfully scheduled $totalScheduled alarms for next $daysCount days.');
    return totalScheduled;
  }
}
