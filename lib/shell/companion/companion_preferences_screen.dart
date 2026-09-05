import 'package:flutter/material.dart';
import '../../../modules/companion/companion_module.dart';
import '../../../modules/companion/domain/companion_preferences.dart';
import '../theme/app_theme_controller.dart';
import '../widgets/siraj_app_logo.dart';
import '../widgets/siraj_about_dialog.dart';

class CompanionPreferencesScreen extends StatefulWidget {
  final CompanionModule module;

  const CompanionPreferencesScreen({super.key, required this.module});

  @override
  State<CompanionPreferencesScreen> createState() => _CompanionPreferencesScreenState();
}

class _CompanionPreferencesScreenState extends State<CompanionPreferencesScreen> {
  CompanionPreferences _prefs = const CompanionPreferences();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final res = await widget.module.getPreferences();
    if (mounted) {
      setState(() {
        if (res.isSuccess) {
          _prefs = res.valueOrNull!;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _savePrefs(CompanionPreferences newPrefs) async {
    await widget.module.savePreferences(newPrefs);
    setState(() => _prefs = newPrefs);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('تخصيص الواجهة والساعات الهادئة'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 0. Theme Mode Setting
          const Text(
            'مظهر وسمة التطبيق (الوضع الداكن / الفاتح):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: AppThemeController.instance,
            builder: (context, _) {
              final currentMode = AppThemeController.instance.themeMode;
              return SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text('فاتح'),
                    icon: Icon(Icons.wb_sunny_rounded),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text('داكن'),
                    icon: Icon(Icons.dark_mode_rounded),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text('تلقائي'),
                    icon: Icon(Icons.settings_brightness_rounded),
                  ),
                ],
                selected: {currentMode},
                onSelectionChanged: (newSelection) {
                  AppThemeController.instance.setThemeMode(newSelection.first);
                },
              );
            },
          ),
          const SizedBox(height: 20),

          const Text(
            'نمط الواجهة والتركيز:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<DashboardFocusMode>(
            initialValue: _prefs.focusMode,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: DashboardFocusMode.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.labelArabic)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                _savePrefs(_prefs.copyWith(focusMode: val));
              }
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'كثافة العرض:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<DashboardDensity>(
            initialValue: _prefs.density,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: DashboardDensity.values
                .map((d) => DropdownMenuItem(value: d, child: Text(d.labelArabic)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                _savePrefs(_prefs.copyWith(density: val));
              }
            },
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('تفعيل الساعات الهادئة (Quiet Hours)'),
            subtitle: const Text('كتم التنبيهات غير العاجلة ليلاً لراحة البال'),
            value: _prefs.enableQuietHours,
            onChanged: (val) {
              _savePrefs(_prefs.copyWith(enableQuietHours: val));
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('إعادة ضبط كافة بيانات الرفيق الشخصي'),
            subtitle: const Text('حذف الأهداف والعادات المحلية وإعادة الإعدادات للافتراضي'),
            trailing: const Icon(Icons.restore, color: Colors.red),
            onTap: () async {
              await widget.module.resetAllUserData();
              _loadPrefs();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تمت استعادة الإعدادات الافتراضية بنجاح')),
                );
              }
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showSirajAboutDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDAA520).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const SirajAppLogo(size: 42, showShadow: false),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'سِراج — رفيقك الإسلامي الموثق',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'خصوصية تامة • بدون إنترنت • اضغط للتفاصيل',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFDAA520)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
