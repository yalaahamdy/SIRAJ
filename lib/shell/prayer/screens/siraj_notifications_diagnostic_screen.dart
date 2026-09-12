import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/notifications/siraj_notification_manager.dart';
import '../../../core/notifications/siraj_native_overlay_bridge.dart';

/// شاشة تشخيص صلاحيات الإشعارات الخارجية لسِراج
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
  bool _testScheduled = false;

  @override
  void initState() {
    super.initState();
    _checkAllPermissions();
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

  Future<void> _scheduleTestNotification() async {
    await SirajNotificationManager.instance.scheduleQuickTestNotification(seconds: 5);
    if (mounted) {
      setState(() => _testScheduled = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '✅ تم جدولة إشعار اختباري بعد 5 ثوانٍ\nأغلق التطبيق أو اقفل الشاشة الآن للتأكد',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
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
                  _buildPermissionCard(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.notifications_active_rounded,
                    title: 'إذن الإشعارات العام',
                    subtitle: 'مطلوب لعرض أي إشعار من التطبيق',
                    isGranted: _notificationsEnabled ?? false,
                    onRequest: () async {
                      await SirajNotificationManager.instance.requestPermissions();
                      _checkAllPermissions();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionCard(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.alarm_rounded,
                    title: 'جدولة المنبهات الدقيقة',
                    subtitle: 'مطلوب للإشعارات في وقتها تماماً (Android 12+)',
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
                  const SizedBox(height: 12),
                  _buildPermissionCard(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.battery_saver_rounded,
                    title: 'استثناء توفير الطاقة',
                    subtitle: 'يمنع النظام من إيقاف إشعارات سِراج عند قفل الشاشة',
                    isGranted: _batteryOptimizationIgnored ?? false,
                    onRequest: () async {
                      await SirajNativeOverlayBridge.requestIgnoreBatteryOptimizations();
                      _checkAllPermissions();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildTestButton(theme, isDark),
                  const SizedBox(height: 12),
                  _buildStatusSummary(theme, isDark),
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
                  'ما سبب عدم ظهور الإشعارات؟',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'لكي تعمل إشعارات الأذان والتذكيرات خارج التطبيق، '
            'يحتاج سِراج إلى الأذونات التالية. '
            'إذا كان أي إذن ناقصاً، اضغط "منح" بجانبه.',
            style: theme.textTheme.bodyMedium?.copyWith(
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28)
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
              child: const Text('منح', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildTestButton(ThemeData theme, bool isDark) {
    return FilledButton.icon(
      onPressed: _testScheduled ? null : _scheduleTestNotification,
      icon: const Icon(Icons.send_rounded),
      label: Text(
        _testScheduled
            ? '✅ تم الإرسال — أغلق التطبيق الآن للاختبار'
            : 'اختبار إشعار خارجي (بعد 5 ثوانٍ)',
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        backgroundColor: _testScheduled ? Colors.grey : const Color(0xFF16A34A),
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
                  ? 'جميع الأذونات ممنوحة ✅ — الإشعارات ستعمل خارج التطبيق'
                  : 'بعض الأذونات ناقصة — امنحها جميعاً لضمان عمل الإشعارات',
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
