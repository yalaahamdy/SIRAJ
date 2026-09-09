import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../modules/prayer/domain/athan_sound_option.dart';
import '../../../modules/prayer/domain/prayer_notification_settings.dart';
import '../../../modules/prayer/domain/prayer_type.dart';
import '../../../modules/prayer/prayer_module.dart';
import '../../../core/notifications/siraj_notification_manager.dart';
import '../../../core/notifications/siraj_native_overlay_bridge.dart';
import '../widgets/athan_preview_card.dart';
import 'siraj_athan_full_screen_view.dart';

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
  bool _notificationsGranted = true;
  bool _overlayGranted = true;

  @override
  void initState() {
    super.initState();
    _settings = widget.prayerModule.notificationService.settings;
    _checkSystemPermissions();
  }

  Future<void> _checkSystemPermissions() async {
    final notifs = await SirajNotificationManager.instance.areNotificationsEnabled();
    final overlay = await SirajNativeOverlayBridge.checkOverlayPermission();
    if (mounted) {
      setState(() {
        _notificationsGranted = notifs;
        _overlayGranted = overlay;
      });
    }
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
          const SizedBox(height: 24),

          // Section 4: Lockscreen Popups & System Overlay
          const Text(
            'النوافذ المنبثقة وشاشة القفل',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.screen_lock_portrait_rounded, color: AppColors.primary),
                    title: Text('إيقاظ الهاتف فوق شاشة القفل', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('عرض شاشة الأذان التفاعلية الكبيرة فور دخول الوقت حتى لو كان الهاتف مقفلاً'),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        widget.prayerModule.athanAudioService.playAthan(
                          soundOption: AthanSoundOption.abdulbasit,
                          volume: _settings.masterVolume,
                        );
                        SirajAthanFullScreenView.show(
                          context,
                          prayerType: PrayerType.asr,
                          prayerTime: DateTime.now(),
                          locationName: 'القاهرة، مصر',
                          audioService: widget.prayerModule.athanAudioService,
                          onSnooze: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم تأجيل تنبيه الأذان 5 دقائق')),
                            );
                          },
                          onMarkPrayed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تقبل الله طاعتكم وصالح أعمالكم 🤲')),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.open_in_full_rounded, size: 18),
                      label: const Text('تجربة محاكاة شاشة الأذان المنبثقة الكاملة الآن'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 5: Android System Permissions & Diagnostics
          const Text(
            'فحص صلاحيات النظام والتنبيهات (Android Permissions)',
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
                  // 1. Notification Permission Tile
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _notificationsGranted ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                      color: _notificationsGranted ? Colors.green : Colors.orange,
                      size: 28,
                    ),
                    title: const Text('إذن إشعارات النظام الرسمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(
                      _notificationsGranted
                          ? 'مفعّل وممنوح بنجاح • تعمل إشعارات الأذان ومتحكمات الصوت بشكل سليم'
                          : 'غير مفعّل • يلزم تفعيله لتصلك تنبيهات الصلاة وأزرار المشغل في الإشعارات',
                      style: TextStyle(
                        fontSize: 12,
                        color: _notificationsGranted ? Colors.green : Colors.orange.shade700,
                      ),
                    ),
                    trailing: !_notificationsGranted
                        ? OutlinedButton(
                            onPressed: () async {
                              await SirajNotificationManager.instance.requestPermissions();
                              await _checkSystemPermissions();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.orange),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                            child: const Text('تفعيل الإذن', style: TextStyle(fontSize: 12, color: Colors.orange)),
                          )
                        : null,
                  ),
                  const Divider(),

                  // 2. Overlay & Lockscreen Permission Tile
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _overlayGranted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                      color: _overlayGranted ? Colors.green : AppColors.goldAccent,
                      size: 28,
                    ),
                    title: const Text('إذن الظهور فوق التطبيقات وشاشة القفل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(
                      _overlayGranted
                          ? 'مفعّل وممنوح • تنبثق شاشة الأذان التفاعلية الكبيرة فور دخول الوقت'
                          : 'يسمح بفتح نافذة الأذان تلقائياً وإيقاظ الهاتف حتى عند قفل الشاشة',
                      style: TextStyle(
                        fontSize: 12,
                        color: _overlayGranted ? Colors.green : null,
                      ),
                    ),
                    trailing: OutlinedButton(
                      onPressed: () async {
                        await SirajNativeOverlayBridge.requestOverlayPermission();
                        await _checkSystemPermissions();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _overlayGranted ? Colors.grey : AppColors.goldAccent),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      child: Text(
                        _overlayGranted ? 'الإعدادات' : 'منح الإذن',
                        style: TextStyle(
                          fontSize: 12,
                          color: _overlayGranted ? Colors.grey : AppColors.goldAccent,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),

                  // 3. Android 14+ Full-Screen Intent Setting Button
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.alarm_on_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    title: const Text('إذن شاشة الإنذار الكاملة (Android 14+)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text(
                      'للأجهزة الحديثة لضمان عرض نافذة الأذان عند المنبه دون قيود النظام',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: OutlinedButton(
                      onPressed: () async {
                        await SirajNativeOverlayBridge.requestFullScreenIntentPermission();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      child: const Text('التحقق', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
