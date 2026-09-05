import 'package:flutter/material.dart';
import '../../../core/notifications/siraj_notification_manager.dart';
import '../../../modules/prayer/domain/athan_sound_option.dart';
import '../../../modules/prayer/domain/calculation_parameters.dart';
import '../../../modules/prayer/domain/prayer_adjustments.dart';
import '../../../modules/prayer/domain/prayer_type.dart';
import '../../../modules/prayer/prayer_module.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'screens/athan_settings_screen.dart';
import 'widgets/siraj_athan_dialog.dart';

/// Screen for managing all Prayer calculation, calibration, and notification settings (§17..§22).
class PrayerSettingsScreen extends StatefulWidget {
  final PrayerModule prayerModule;
  final CalculationParameters currentParameters;
  final ValueChanged<CalculationParameters> onParametersChanged;
  final VoidCallback onSettingsChanged;

  const PrayerSettingsScreen({
    super.key,
    required this.prayerModule,
    required this.currentParameters,
    required this.onParametersChanged,
    required this.onSettingsChanged,
  });

  @override
  State<PrayerSettingsScreen> createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  late CalculationParameters _params;
  PrayerAdjustments _adjustments = PrayerAdjustments.zero;
  bool _notificationsEnabled = true;
  bool _prePrayerReminder = false;
  final int _prePrayerMinutes = 15;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _params = widget.currentParameters;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final adjRes = await widget.prayerModule.calibrationService.getAdjustments();
    if (mounted) {
      setState(() {
        _adjustments = adjRes.valueOrNull ?? PrayerAdjustments.zero;
        _isLoading = false;
      });
    }
  }

  void _updateMethod(CalculationParameters newParams) {
    setState(() => _params = newParams);
    widget.onParametersChanged(newParams);
    widget.onSettingsChanged();
  }

  void _updateAsrMethod(AsrJuristicMethod method) {
    final newParams = _params.copyWith(asrJuristicMethod: method);
    _updateMethod(newParams);
  }

  void _updateHighLatitudeRule(HighLatitudeRule rule) {
    final newParams = _params.copyWith(highLatitudeRule: rule);
    _updateMethod(newParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الصلاة والحساب'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: AppSpacing.paddingScreen,
              children: [
                // 1. Calculation Method Section
                _buildSectionHeader('طريقة الحساب المعتمدة'),
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<CalculationParameters>(
                          initialValue: _getMatchingPreset(_params),
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'الجهة الفقهية أو الهيئة الفلكية',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: CalculationParameters.muslimWorldLeague,
                              child: Text('رابطة العالم الإسلامي (MWL)'),
                            ),
                            DropdownMenuItem(
                              value: CalculationParameters.ummAlQura,
                              child: Text('جامعة أم القرى (مكة المكرمة)'),
                            ),
                            DropdownMenuItem(
                              value: CalculationParameters.egyptian,
                              child: Text('الهيئة المصرية العامة للمساحة'),
                            ),
                            DropdownMenuItem(
                              value: CalculationParameters.karachi,
                              child: Text('جامعة العلوم الإسلامية بكراتشي'),
                            ),
                            DropdownMenuItem(
                              value: CalculationParameters.isna,
                              child: Text('الجمعية الإسلامية لأمريكا الشمالية (ISNA)'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) _updateMethod(val);
                          },
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          'زاوية الفجر: ${_params.fajrAngle}° | العشاء: ${_params.ishaAngle != null ? "${_params.ishaAngle}°" : "${_params.ishaIntervalMinutes} دقيقة بعد المغرب"}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // 2. Juristic School (Asr) Section
                _buildSectionHeader('المذهب الفقهي لحساب وقت صلاة العصر'),
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingCard,
                    child: DropdownButtonFormField<AsrJuristicMethod>(
                      initialValue: _params.asrJuristicMethod,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'المذهب المتبع في صلاة العصر',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: AsrJuristicMethod.shafii,
                          child: Text('جمهور الفقهاء (الشافعي، المالكي، الحنبلي - 1x)'),
                        ),
                        DropdownMenuItem(
                          value: AsrJuristicMethod.hanafi,
                          child: Text('المذهب الحنفي (صيرورة الظل مثليه - 2x)'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) _updateAsrMethod(v);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // 3. High Latitude Rule Section
                _buildSectionHeader('قاعدة المناطق ذات خطوط العرض العالية'),
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingCard,
                    child: DropdownButtonFormField<HighLatitudeRule>(
                      initialValue: _params.highLatitudeRule,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'معالجة غياب الشفق الفلكي',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: HighLatitudeRule.middleOfTheNight,
                          child: Text('منتصف الليل (Middle of the Night)'),
                        ),
                        DropdownMenuItem(
                          value: HighLatitudeRule.seventhOfTheNight,
                          child: Text('سُبع الليل (One Seventh of Night)'),
                        ),
                        DropdownMenuItem(
                          value: HighLatitudeRule.angleBased,
                          child: Text('النسبة بالزاوية (Angle-Based Rule)'),
                        ),
                        DropdownMenuItem(
                          value: HighLatitudeRule.none,
                          child: Text('بدون تعديل (حساب فلكي مباشر)'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) _updateHighLatitudeRule(v);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // 4. Minute Calibration Adjustments Section
                _buildSectionHeader('المعايرة والتعديل اليدوي بالدقائق'),
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تعديلات يدوية مخصصة لكل صلاة بالدقائق لمطابقة تقويم المسجد المحلي بدقة وشفافية كاملة:',
                          style: TextStyle(fontSize: 12, height: 1.4),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        _buildAdjSummary('الفجر', _adjustments.fajr),
                        _buildAdjSummary('الظهر', _adjustments.dhuhr),
                        _buildAdjSummary('العصر', _adjustments.asr),
                        _buildAdjSummary('المغرب', _adjustments.maghrib),
                        _buildAdjSummary('العشاء', _adjustments.isha),
                        const SizedBox(height: AppSpacing.s),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _openCalibrationDialog(context),
                                icon: const Icon(Icons.tune_rounded, size: 16),
                                label: const Text('تعديل الدقائق'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () async {
                                await widget.prayerModule.calibrationService.resetAdjustments();
                                _loadSettings();
                                widget.onSettingsChanged();
                              },
                              style: OutlinedButton.styleFrom(foregroundColor: AppColors.warning),
                              child: const Text('تصفير (0)'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // 5. Notifications Section
                _buildSectionHeader('التنبيهات والأذان'),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('تنبيهات دخول وقت الصلاة'),
                        subtitle: const Text('إشعار محلي فوري عند حلول كل صلاة مفروضة'),
                        value: _notificationsEnabled,
                        activeTrackColor: AppColors.primary,
                        onChanged: (v) {
                          setState(() => _notificationsEnabled = v);
                          if (!v) {
                            widget.prayerModule.notificationService.cancelAll();
                          }
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('تذكير مسبق قبل الأذان'),
                        subtitle: Text('تنبيه لطيف قبل حلول الوقت بـ $_prePrayerMinutes دقيقة للاستعداد للوضوء'),
                        value: _prePrayerReminder,
                        activeTrackColor: AppColors.primary,
                        onChanged: (v) {
                          setState(() => _prePrayerReminder = v);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.music_note_rounded, color: AppColors.primary),
                        title: const Text('إعدادات صوت الأذان والتخصيص'),
                        subtitle: const Text('أذان الشيخ عبد الباسط عبد الصمد، ومستوى الصوت، والاهتزاز، وتخصيص كل صلاة'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AthanSettingsScreen(
                                prayerModule: widget.prayerModule,
                                onSettingsChanged: widget.onSettingsChanged,
                              ),
                            ),
                          );
                          widget.onSettingsChanged();
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.notifications_active_rounded, color: AppColors.primary),
                        title: const Text('اختبار التنبيه والأذان الآن'),
                        subtitle: const Text('تشغيل نموذج إشعار فوري وتكبيرات الأذان للتحقق من عملهما'),
                        trailing: ElevatedButton.icon(
                          onPressed: () async {
                            await SirajNotificationManager.instance.requestPermissions();
                            await SirajNotificationManager.instance.showPrayerNotification(
                              id: 999,
                              title: 'تجربة أذان سِراج (صلاة العصر)',
                              body: 'الله أكبر الله أكبر — مواقيت الصلاة والأذان تعمل بنجاح',
                            );
                            if (context.mounted) {
                              widget.prayerModule.athanAudioService.playAthan(
                                soundOption: AthanSoundOption.abdulbasit,
                              );
                              showSirajAthanDialog(
                                context: context,
                                prayerType: PrayerType.asr,
                                prayerTime: DateTime.now(),
                                locationName: 'موقعك الحالي',
                                audioService: widget.prayerModule.athanAudioService,
                              );
                            }
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('تجربة الآن'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  CalculationParameters _getMatchingPreset(CalculationParameters current) {
    if (current.methodProfileName == CalculationParameters.ummAlQura.methodProfileName) {
      return CalculationParameters.ummAlQura;
    }
    if (current.methodProfileName == CalculationParameters.egyptian.methodProfileName) {
      return CalculationParameters.egyptian;
    }
    if (current.methodProfileName == CalculationParameters.karachi.methodProfileName) {
      return CalculationParameters.karachi;
    }
    if (current.methodProfileName == CalculationParameters.isna.methodProfileName) {
      return CalculationParameters.isna;
    }
    return CalculationParameters.muslimWorldLeague;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
      ),
    );
  }

  Widget _buildAdjSummary(String prayerName, int val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(prayerName, style: const TextStyle(fontSize: 12)),
          Text(
            '${val > 0 ? "+" : ""}$val دقيقة',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: val != 0 ? AppColors.goldAccent : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _openCalibrationDialog(BuildContext context) {
    var fajrAdj = _adjustments.fajr;
    var dhuhrAdj = _adjustments.dhuhr;
    var asrAdj = _adjustments.asr;
    var maghribAdj = _adjustments.maghrib;
    var ishaAdj = _adjustments.isha;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('معايرة الدقائق'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSlider('الفجر', fajrAdj, (v) => setDialogState(() => fajrAdj = v.toInt())),
                _buildSlider('الظهر', dhuhrAdj, (v) => setDialogState(() => dhuhrAdj = v.toInt())),
                _buildSlider('العصر', asrAdj, (v) => setDialogState(() => asrAdj = v.toInt())),
                _buildSlider('المغرب', maghribAdj, (v) => setDialogState(() => maghribAdj = v.toInt())),
                _buildSlider('العشاء', ishaAdj, (v) => setDialogState(() => ishaAdj = v.toInt())),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newAdj = PrayerAdjustments(
                  fajr: fajrAdj,
                  dhuhr: dhuhrAdj,
                  asr: asrAdj,
                  maghrib: maghribAdj,
                  isha: ishaAdj,
                );
                await widget.prayerModule.calibrationService.saveAdjustments(newAdj);
                if (dialogCtx.mounted) {
                  Navigator.pop(dialogCtx);
                }
                _loadSettings();
                widget.onSettingsChanged();
              },
              child: const Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String title, int val, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text('${val > 0 ? "+" : ""}$val دقيقة'),
          ],
        ),
        Slider(
          value: val.toDouble(),
          min: -30,
          max: 30,
          divisions: 60,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
