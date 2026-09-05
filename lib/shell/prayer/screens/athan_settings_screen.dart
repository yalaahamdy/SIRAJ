import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../modules/prayer/domain/athan_sound_option.dart';
import '../../../modules/prayer/domain/prayer_notification_settings.dart';
import '../../../modules/prayer/domain/prayer_type.dart';
import '../../../modules/prayer/prayer_module.dart';
import '../../../core/notifications/siraj_notification_manager.dart';
import '../widgets/athan_preview_card.dart';

/// Screen for configuring Athan audio, per-prayer alert modes, and reminders (§17, §32).
class AthanSettingsScreen extends StatefulWidget {
  final PrayerModule prayerModule;
  final VoidCallback? onSettingsChanged;

  const AthanSettingsScreen({
    super.key,
    required this.prayerModule,
    this.onSettingsChanged,
  });

  @override
  State<AthanSettingsScreen> createState() => _AthanSettingsScreenState();
}

class _AthanSettingsScreenState extends State<AthanSettingsScreen> {
  late PrayerNotificationSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.prayerModule.notificationService.settings;
  }

  void _updateSettings(PrayerNotificationSettings newSettings) {
    setState(() => _settings = newSettings);
    widget.prayerModule.notificationService.updateSettings(newSettings);
    widget.onSettingsChanged?.call();
  }

  void _showPrayerModeDialog(PrayerType type) {
    final current = _settings.getSettingFor(type);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تخصيص تنبيه صلاة ${type.nameArabic}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'اختر نمط التنبيه عند دخول الوقت:',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: 8),

                  // Mode Options
                  for (final mode in PrayerNotificationMode.values)
                    ListTile(
                      title: Text(mode.displayNameArabic),
                      leading: Icon(
                        mode == current.mode
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: mode == current.mode ? AppColors.primary : Colors.grey,
                      ),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        final updated = _settings.updatePrayerSetting(
                          current.copyWith(mode: mode),
                        );
                        _updateSettings(updated);
                        Navigator.pop(ctx);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الأذان والتنبيهات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Audio Preview Card
          const Text(
            'الصوت المعتمد للأذان',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          AthanPreviewCard(
            audioService: widget.prayerModule.athanAudioService,
            soundOption: AthanSoundOption.abdulbasit,
            volume: _settings.masterVolume,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final res = await widget.prayerModule.athanAudioService.playAthan(
                soundOption: AthanSoundOption.abdulbasit,
                volume: _settings.masterVolume,
              );
              await SirajNotificationManager.instance.testAthanNotification();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      res.isSuccess
                          ? 'جاري إطلاق الأذان التجريبي والإشعار بنجاح! تأكد من رفع مستوى صوت الهاتف.'
                          : 'تعذر تشغيل الصوت: ${res.failureOrNull?.message}',
                    ),
                    backgroundColor: res.isSuccess ? AppColors.primary : AppColors.error,
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'إيقاف',
                      textColor: Colors.white,
                      onPressed: () {
                        widget.prayerModule.athanAudioService.stopAthan();
                      },
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.notifications_active_rounded, color: AppColors.primary),
            label: const Text('اختبار الأذان الشريف والإشعار فوراً'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              side: const BorderSide(color: AppColors.primary, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),

          // Section 2: Audio & Vibration Controls
          const Text(
            'التحكم في الصوت والاهتزاز',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Volume Slider
                  Row(
                    children: [
                      const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'مستوى صوت الأذان',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text('${(_settings.masterVolume * 100).round()}%'),
                    ],
                  ),
                  Slider(
                    value: _settings.masterVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      _updateSettings(_settings.copyWith(masterVolume: val));
                      widget.prayerModule.athanAudioService.setVolume(val);
                    },
                  ),
                  const Divider(),

                  // Vibration Switch
                  SwitchListTile(
                    title: const Text('تفعيل الاهتزاز مع التنبيه'),
                    subtitle: const Text('اهتزاز الهاتف عند دخول وقت الصلاة'),
                    value: _settings.isVibrationEnabled,
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      _updateSettings(_settings.copyWith(isVibrationEnabled: val));
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 3: Per-Prayer Configuration List
          const Text(
            'تخصيص التنبيه لكل صلاة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: PrayerType.values.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final type = PrayerType.values[i];
                final setting = _settings.getSettingFor(type);

                return ListTile(
                  leading: Icon(
                    type == PrayerType.sunrise
                        ? Icons.wb_twilight_rounded
                        : Icons.access_alarm_rounded,
                    color: setting.mode == PrayerNotificationMode.disabled
                        ? Colors.grey
                        : AppColors.primary,
                  ),
                  title: Text(
                    type.nameArabic,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'النمط: ${setting.mode.displayNameArabic}'
                    '${setting.preAthanMinutes > 0 ? ' • تنبيه مسبق (${setting.preAthanMinutes}د)' : ''}'
                    '${setting.iqamaMinutes > 0 ? ' • إقامة (${setting.iqamaMinutes}د)' : ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _showPrayerModeDialog(type),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
