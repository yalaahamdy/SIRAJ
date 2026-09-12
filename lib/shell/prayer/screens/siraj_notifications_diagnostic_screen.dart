import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/notifications/siraj_notification_manager.dart';
import '../../../core/notifications/siraj_native_overlay_bridge.dart';

/// شاشة تشخيص صلاحيات ومنظومة الإشعارات الخارجية لسِراج
class SirajNotificationsDiagnosticScreen extends StatefulWidget {
  const SirajNotificationsDiagnosticScreen({super.key});

  @override
  State<SirajNotificationsDiagnosticScreen> createState() =>
      _SirajNotificationsDiagnosticScreenState();
}

class _SirajNotificationsDiagnosticScreenState
    extends State<SirajNotificationsDiagnosticScreen> {
  bool? _notificationsEnabled;
  bool? _exactAlarmsEnabled;
  bool? _batteryOptimizationIgnored;
  bool _isLoading = true;
  int _countdownSeconds = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _checkAllPermissions();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkAllPermissions() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final notifEnabled =
          await SirajNotificationManager.instance.areNotificationsEnabled();
      final exactAlarms = await SirajNativeOverlayBridge.canScheduleExactAlarms();
      final batteryIgnored =
          await SirajNativeOverlayBridge.isIgnoringBatteryOptimizations();
      if (mounted) {
        setState(() {
          _notificationsEnabled = notifEnabled;
          _exactAlarmsEnabled = exactAlarms;
          _batteryOptimizationIgnored = batteryIgnored;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _triggerImmediateTest() async {
    final res = await SirajNotificationManager.instance.showImmediateTestNotification();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res
                ? '🔔 تم إرسال الإشعار الفوري الآن! اسحب شريط الإشعارات العلوي للتحقق'
                : 'تعذر إرسال الإشعار، يرجى مراجعة إعدادات الإشعارات',
            textAlign: TextAlign.center,
          ),
          backgroundColor: res ? const Color(0xFF16A34A) : Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _schedule10SecondsTest() async {
    _countdownTimer?.cancel();
    setState(() => _countdownSeconds = 10);

    await SirajNotificationManager.instance.scheduleQuickTestNotification(seconds: 10);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdownSeconds <= 1) {
        timer.cancel();
        setState(() => _countdownSeconds = 0);
      } else {
        setState(() => _countdownSeconds--);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⏰ تم ضبط المنبه بعد 10 ثوانٍ!\nاقفل شاشة هاتفك الآن وضع الهاتف جانباً',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 6),
          backgroundColor: Color(0xFF2563EB),
        ),
      );
    }
  }

  Future<void> _stopSound() async {
    await SirajNativeOverlayBridge.stopActiveSound();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إيقاف صوت الأذان', textAlign: TextAlign.center),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('تشخيص إشعارات سِراج'),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1F2937) : colorScheme.primaryContainer,
        foregroundColor: isDark ? Colors.white : colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'إعادة الفحص',
            onPressed: _checkAllPermissions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeader(theme, isDark),
                  const SizedBox(height: 20),

                  // أذونات النظام
                  Text(
                    'حالة الأذونات المطلوبة',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPermissionCard(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.notifications_active_rounded,
                    title: 'إذن الإشعارات العام',
                    subtitle: 'مطلوب لظهور الإشعار في الستارة وشاشة القفل',
                    isGranted: _notificationsEnabled ?? false,
                    onRequest: () async {
                      await SirajNotificationManager.instance.requestPermissions();
                      _checkAllPermissions();
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildPermissionCard(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.alarm_rounded,
                    title: 'جدولة المنبهات الدقيقة (Exact Alarm)',
                    subtitle: 'مطلوب لدقة موعد الأذان بالثانية دون تأخير',
                    isGranted: _exactAlarmsEnabled ?? false,
                    onRequest: () async {
                      try {
                        final androidPlugin = SirajNotificationManager
                            .instance
                            .notificationsPlugin
                            .resolvePlatformSpecificImplementation<
                                AndroidFlutterLocalNotificationsPlugin>();
                        await androidPlugin?.requestExactAlarmsPermission();
                      } catch (_) {}
                      _checkAllPermissions();
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildPermissionCard(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.battery_saver_rounded,
                    title: 'استثناء توفير الطاقة (Battery Optimization)',
                    subtitle: 'يمنع النظام من إيقاف منبهات سِراج عند قفل الشاشة',
                    isGranted: _batteryOptimizationIgnored ?? false,
                    onRequest: () async {
                      await SirajNativeOverlayBridge.requestIgnoreBatteryOptimizations();
                      _checkAllPermissions();
                    },
                  ),
                  const SizedBox(height: 20),

                  // مركز الاختبارات العملية
                  Text(
                    'مركز الاختبار المباشر',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildImmediateTestButton(theme, isDark),
                  const SizedBox(height: 12),
                  _buildLockscreenTestButton(theme, isDark),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _stopSound,
                    icon: const Icon(Icons.volume_off_rounded, color: Colors.red),
                    label: const Text('إيقاف صوت الأذان الشغال حالياً', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // اختصارات إعدادات النظام الحيوية
                  Text(
                    'حلول إضافية لهواتف شاومي وسامسونج وهواوي',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildSystemSettingsCard(theme, isDark),
                  const SizedBox(height: 16),
                  _buildStatusSummary(theme, isDark),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF93C5FD),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ضمان انطلاق صوت الأذان والإشعارات خارجياً',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'تطبق أنظمة أندرويد قيوداً صارمة لمنع التطبيقات من العمل أثناء قفل الشاشة. '
            'جرّب أولاً "إرسال إشعار فوري" للتأكد من خروج الصوت، ثم استخدم "اختبار المنبه الخارجي" واقفل الشاشة.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard({
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isGranted,
    required VoidCallback onRequest,
  }) {
    final Color statusColor = isGranted ? Colors.green : Colors.red;
    final Color cardBg = isDark ? const Color(0xFF1F2937) : Colors.white;
    final Color borderColor = isGranted
        ? Colors.green.withValues(alpha: 0.4)
        : Colors.red.withValues(alpha: 0.4);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isGranted)
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 26)
          else
            TextButton(
              onPressed: onRequest,
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('منح', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildImmediateTestButton(ThemeData theme, bool isDark) {
    return FilledButton.icon(
      onPressed: _triggerImmediateTest,
      icon: const Icon(Icons.notifications_active_rounded),
      label: const Text('1. إرسال إشعار فوري حالاً (الآن)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }

  Widget _buildLockscreenTestButton(ThemeData theme, bool isDark) {
    final isCounting = _countdownSeconds > 0;
    return FilledButton.icon(
      onPressed: isCounting ? null : _schedule10SecondsTest,
      icon: Icon(isCounting ? Icons.hourglass_top_rounded : Icons.timer_rounded),
      label: Text(
        isCounting
            ? '⏳ ينطلق بعد $_countdownSeconds ثوانٍ — اقفل الشاشة الآن!'
            : '2. اختبار منبه خارجي (بعد 10 ثوانٍ فوق القفل)',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: isCounting ? Colors.amber[800] : const Color(0xFF2563EB),
      ),
    );
  }

  Widget _buildSystemSettingsCard(ThemeData theme, bool isDark) {
    final cardBg = isDark ? const Color(0xFF1F2937) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF856404)),
            title: const Text('إعدادات إشعارات سِراج بالنظام', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('للتأكد من تفعيل الظهور فوق الشاشة وصوت المنبه', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => SirajNativeOverlayBridge.openNotificationSettings(),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.power_settings_new_rounded, color: Color(0xFF1E3A8A)),
            title: const Text('إعدادات التشغيل التلقائي (Auto-start)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('ضروري جداً لهواتف Xiaomi, Huawei, Oppo, Samsung', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => SirajNativeOverlayBridge.openAutoStartSettings(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(ThemeData theme, bool isDark) {
    final allGranted = (_notificationsEnabled ?? false) &&
        (_exactAlarmsEnabled ?? false) &&
        (_batteryOptimizationIgnored ?? false);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: allGranted
            ? Colors.green.withValues(alpha: isDark ? 0.15 : 0.1)
            : Colors.orange.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: allGranted
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.orange.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            allGranted ? Icons.verified_rounded : Icons.warning_amber_rounded,
            color: allGranted ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              allGranted
                  ? 'جميع الأذونات ممنوحة بنجاح ✅'
                  : 'بعض الأذونات ناقصة — امنحها لضمان انطلاق المنبهات',
              style: theme.textTheme.bodySmall?.copyWith(
                color: allGranted
                    ? (isDark ? Colors.green[300] : Colors.green[700])
                    : (isDark ? Colors.orange[300] : Colors.orange[700]),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
