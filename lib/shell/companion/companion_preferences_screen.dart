import 'package:flutter/material.dart';
import '../../../modules/companion/companion_module.dart';
import '../../../modules/companion/domain/companion_preferences.dart';

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
        title: const Text('تخصيص الواجهة والساعات الهادئة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
        ],
      ),
    );
  }
}
