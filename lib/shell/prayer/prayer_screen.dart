import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/i18n/app_strings.dart';
import '../../core/location/location_models.dart';
import '../../modules/prayer/domain/athan_sound_option.dart';
import '../../modules/prayer/domain/calculation_parameters.dart';
import '../../modules/prayer/domain/calculation_status.dart';
import '../../modules/prayer/domain/prayer_adjustments.dart';
import '../../modules/prayer/domain/prayer_log_entry.dart';
import '../../modules/prayer/domain/prayer_notification_settings.dart';
import '../../modules/prayer/domain/prayer_schedule.dart';
import '../../modules/prayer/domain/prayer_tracking_status.dart';
import '../../modules/prayer/domain/prayer_type.dart';
import '../../modules/prayer/domain/qibla_result.dart';
import '../../modules/prayer/prayer_module.dart';
import '../../core/location/location_engine.dart';
import '../../core/location/sensor_compass_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';
import 'prayer_settings_screen.dart';
import 'widgets/location_selection_dialog.dart';
import 'widgets/qibla_compass_view.dart';
import 'widgets/siraj_athan_dialog.dart';
import '../../core/notifications/siraj_notification_manager.dart';

/// Production-Quality, Responsive Prayer & Qibla Screen (§4..§19, §25..§35).
class PrayerScreen extends StatefulWidget {
  final PrayerModule prayerModule;
  final GeoCoordinates initialLocation;
  final CalculationParameters initialParameters;
  final LocationEngine? locationEngine;
  final SensorCompassService? compassService;

  const PrayerScreen({
    super.key,
    required this.prayerModule,
    this.initialLocation = const GeoCoordinates(
      latitude: 24.7136, // Riyadh
      longitude: 46.6753,
      source: LocationSource.manual,
      cityName: 'الرياض',
      countryName: 'المملكة العربية السعودية',
    ),
    this.initialParameters = CalculationParameters.muslimWorldLeague,
    this.locationEngine,
    this.compassService,
  });

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  late GeoCoordinates _location;
  late CalculationParameters _selectedParameters;
  PrayerSchedule? _todaySchedule;
  PrayerSchedule? _tomorrowSchedule;
  QiblaResult? _qiblaResult;
  Map<PrayerType, PrayerLogEntry> _trackingLogs = {};
  PrayerAdjustments _adjustments = PrayerAdjustments.zero;
  bool _isLoading = true;
  String? _errorMessage;

  Timer? _countdownTicker;
  StreamSubscription<GeoCoordinates>? _locationSubscription;
  bool _isAcquiringLocation = false;
  DateTime? _lastComputedNextPrayerTime;
  bool _showCompass = false;
  final Set<String> _firedPrayersToday = {};

  @override
  void initState() {
    super.initState();
    _location = widget.locationEngine?.currentEffectiveLocation ?? widget.initialLocation;
    _selectedParameters = widget.initialParameters;
    _loadAllData();
    _startCountdownTicker();
    _initLocationSubscription();
    SirajNotificationManager.instance.init();
    SirajNotificationManager.instance.requestPermissions();
  }

  void _initLocationSubscription() {
    if (widget.locationEngine != null) {
      _locationSubscription = widget.locationEngine!.locationStream.listen((newLoc) {
        if (mounted && newLoc != _location) {
          _onLocationChanged(newLoc);
        }
      });
      // Always acquire fresh GPS coordinates in the background automatically
      _refreshGpsLocation(silent: true);
    }
  }

  void _startCountdownTicker() {
    _countdownTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      _checkPrayerTransition();
    });
  }

  void _checkPrayerTransition() {
    if (_todaySchedule == null) return;
    final now = widget.prayerModule.clock.nowLocal();

    // Check obligatory prayers to trigger automatic Athan and notification (within 60s window)
    for (final entry in _todaySchedule!.obligatoryPrayers) {
      final diff = now.difference(entry.time).inSeconds;
      final key = '${entry.type.name}_${_todaySchedule!.date.year}_${_todaySchedule!.date.month}_${_todaySchedule!.date.day}';

      // Trigger if at or within 60 seconds of prayer entry and not yet fired today
      if (diff >= 0 && diff <= 59 && !_firedPrayersToday.contains(key)) {
        _firedPrayersToday.add(key);
        _triggerAthanAndNotification(entry.type, entry.time);
      }
    }

    final countdown = widget.prayerModule.countdownService.getCountdownState(
      todaySchedule: _todaySchedule!,
      tomorrowSchedule: _tomorrowSchedule,
    );
    final nextTime = countdown.nextPrayer?.time;
    if (nextTime != null && _lastComputedNextPrayerTime != null) {
      if (now.isAfter(_lastComputedNextPrayerTime!)) {
        _lastComputedNextPrayerTime = nextTime;
        _loadAllData();
      }
    } else {
      _lastComputedNextPrayerTime = nextTime;
    }
  }

  void _triggerAthanAndNotification(PrayerType prayerType, DateTime prayerTime) {
    final settings = widget.prayerModule.notificationService.settings;
    final perPrayer = settings.getSettingFor(prayerType);
    if (perPrayer.mode == PrayerNotificationMode.disabled) return;

    final shouldPlayAudio = perPrayer.mode == PrayerNotificationMode.fullAthan ||
        perPrayer.mode == PrayerNotificationMode.takbeerOnly;

    // 1. Play authentic Athan audio if configured
    if (shouldPlayAudio) {
      widget.prayerModule.athanAudioService.playAthan(
        soundOption: AthanSoundOption.abdulbasit,
        volume: settings.masterVolume,
      );
    }

    // 2. Send native system notification
    SirajNotificationManager.instance.showPrayerNotification(
      id: prayerType.index,
      title: 'حان الآن موعد أذان ${prayerType.nameArabic}',
      body: 'حي على الصلاة، حي على الفلاح — ${_location.cityName ?? "موقعك الحالي"}',
      playAthanSound: shouldPlayAudio,
    );

    // 3. Show in-app interactive Athan modal
    if (mounted) {
      showSirajAthanDialog(
        context: context,
        prayerType: prayerType,
        prayerTime: prayerTime,
        locationName: _location.cityName ?? 'موقعك الحالي',
        audioService: widget.prayerModule.athanAudioService,
        onMarkPrayed: () => _updateTracking(prayerType, PrayerTrackingStatus.prayed),
      );
    }
  }

  Future<void> _refreshGpsLocation({bool silent = false}) async {
    if (widget.locationEngine == null || _isAcquiringLocation) return;
    if (!silent) {
      setState(() => _isAcquiringLocation = true);
    }
    final res = await widget.locationEngine!.acquireLocation();
    if (mounted) {
      if (!silent) {
        setState(() => _isAcquiringLocation = false);
        if (res.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.valueOrNull!.statusMessageArabic),
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
      if (res.isSuccess) {
        _onLocationChanged(res.valueOrNull!.coordinates);
      }
    }
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final now = widget.prayerModule.clock.nowLocal();
    final tomorrow = now.add(const Duration(days: 1));

    // 1. Load calibration adjustments
    final adjRes = await widget.prayerModule.calibrationService.getAdjustments();
    _adjustments = adjRes.valueOrNull ?? PrayerAdjustments.zero;

    // 2. Compute schedules with adjustments
    final todayRes = await widget.prayerModule.getSchedule(
      date: now,
      location: _location,
      parameters: _selectedParameters,
      adjustments: _adjustments,
    );

    final tomorrowRes = await widget.prayerModule.getSchedule(
      date: tomorrow,
      location: _location,
      parameters: _selectedParameters,
      adjustments: _adjustments,
    );

    if (todayRes.isFailure) {
      setState(() {
        _isLoading = false;
        _errorMessage = todayRes.failureOrNull?.message ?? AppStrings.errorOccurred;
      });
      return;
    }

    // 3. Compute Qibla
    final qiblaRes = widget.prayerModule.getQibla(_location);
    if (qiblaRes.isSuccess) {
      _qiblaResult = qiblaRes.valueOrNull;
    }

    // 4. Load tracking logs
    final logsRes = await widget.prayerModule.trackerService.getLogsForDate(now);
    if (logsRes.isSuccess) {
      _trackingLogs = logsRes.valueOrNull ?? {};
    }

    // 5. Schedule local notifications if enabled
    if (todayRes.valueOrNull != null) {
      widget.prayerModule.notificationService.scheduleDailyPrayers(
        schedule: todayRes.valueOrNull!,
        clearPrevious: true,
      );
    }
    if (tomorrowRes.valueOrNull != null) {
      widget.prayerModule.notificationService.scheduleDailyPrayers(
        schedule: tomorrowRes.valueOrNull!,
        clearPrevious: false,
      );
    }

    setState(() {
      _todaySchedule = todayRes.valueOrNull;
      _tomorrowSchedule = tomorrowRes.valueOrNull;
      _isLoading = false;
    });
  }

  Future<void> _updateTracking(PrayerType type, PrayerTrackingStatus status) async {
    final now = widget.prayerModule.clock.nowLocal();
    final res = await widget.prayerModule.trackerService.logPrayer(
      date: now,
      prayerType: type,
      status: status,
    );
    if (res.isSuccess) {
      setState(() {
        _trackingLogs[type] = res.valueOrNull!;
      });
    }
  }

  void _onLocationChanged(GeoCoordinates newLocation) {
    setState(() {
      _location = newLocation;
    });
    _loadAllData();
  }

  void _openLocationPicker() {
    showDialog(
      context: context,
      builder: (_) => LocationSelectionDialog(
        currentLocation: _location,
        onLocationSelected: _onLocationChanged,
        locationEngine: widget.locationEngine,
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrayerSettingsScreen(
          prayerModule: widget.prayerModule,
          currentParameters: _selectedParameters,
          onParametersChanged: (newParams) {
            setState(() => _selectedParameters = newParams);
          },
          onSettingsChanged: _loadAllData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(AppStrings.prayerTimes),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            tooltip: 'تغيير الموقع الجغرافي',
            onPressed: _openLocationPicker,
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'إعدادات الصلاة والحساب',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingStateView()
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: AppSpacing.paddingScreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 56, color: AppColors.warning),
                        const SizedBox(height: AppSpacing.m),
                        Text(_errorMessage!, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                        const SizedBox(height: AppSpacing.m),
                        ElevatedButton.icon(
                          onPressed: _loadAllData,
                          icon: const Icon(Icons.refresh),
                          label: const Text(AppStrings.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAllData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppSpacing.paddingScreen,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Location & Date Header Bar
                            _buildLocationHeader(context, isDark),
                            const SizedBox(height: AppSpacing.m),

                            // Extreme / Polar Conditions Alert Banner
                            if (_todaySchedule != null && _todaySchedule!.status != CalculationStatus.normal) ...[
                              _buildCalculationStatusAlert(context, _todaySchedule!.status),
                              const SizedBox(height: AppSpacing.m),
                            ],

                            // Next Prayer & Countdown Hero Card
                            _buildNextPrayerHeroCard(context, isDark),
                            const SizedBox(height: AppSpacing.m),

                            // Full Daily Prayer Schedule with Interactive Tracking
                            _buildDailyScheduleCard(context, isDark),
                            const SizedBox(height: AppSpacing.m),

                            // Qibla Compass Card - Hidden by default behind dedicated button
                            _buildQiblaCompassSection(context, isDark),
                            const SizedBox(height: AppSpacing.m),

                            // Calculation Method & Transparent Assumptions Disclosure
                            if (_todaySchedule != null)
                              _buildMethodologyDisclosureCard(context, isDark, _todaySchedule!),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildLocationHeader(BuildContext context, bool isDark) {
    final locTitle = _location.cityName != null
        ? '${_location.cityName} (${_location.latitude.toStringAsFixed(2)}°, ${_location.longitude.toStringAsFixed(2)}°) (${_location.source == LocationSource.gps ? "تلقائي GPS" : "يدوي"})'
        : 'الموقع: ${_location.latitude.toStringAsFixed(2)}°, ${_location.longitude.toStringAsFixed(2)}° (${_location.source == LocationSource.gps ? "تلقائي GPS" : "يدوي"})';

    return Card(
      elevation: 0,
      color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _openLocationPicker,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.location_on, size: 20, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: _openLocationPicker,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    locTitle,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            if (widget.locationEngine != null)
              IconButton(
                icon: _isAcquiringLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      )
                    : const Icon(Icons.gps_fixed, size: 18, color: AppColors.primary),
                tooltip: 'تحديث الموقع عبر GPS',
                onPressed: _isAcquiringLocation ? null : () => _refreshGpsLocation(),
              ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationStatusAlert(BuildContext context, CalculationStatus status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تنبيه خط العرض العالي أو الشروط القطبية',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warning),
                ),
                const SizedBox(height: 4),
                Text(
                  status.messageArabic,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerHeroCard(BuildContext context, bool isDark) {
    if (_todaySchedule == null) return const SizedBox.shrink();

    final countdownState = widget.prayerModule.countdownService.getCountdownState(
      todaySchedule: _todaySchedule!,
      tomorrowSchedule: _tomorrowSchedule,
    );

    final next = countdownState.nextPrayer;
    final current = countdownState.currentPrayer;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? AppColors.surfaceDark : AppColors.primary,
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          children: [
            if (current != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'الصلاة الحالية: ${current.type.nameArabic}',
                  style: TextStyle(
                    color: isDark ? AppColors.goldAccent : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.s),
            Text(
              next != null ? 'الصلاة القادمة: ${next.type.nameArabic}' : AppStrings.nextPrayer,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                countdownState.formattedTimer,
                style: TextStyle(
                  color: isDark ? AppColors.goldAccent : AppColors.goldAccentLight,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              next != null ? 'يحين وقتها في ${_formatTime(next.time)}' : '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyScheduleCard(BuildContext context, bool isDark) {
    if (_todaySchedule == null) return const SizedBox.shrink();

    final prayers = _todaySchedule!.obligatoryPrayers;
    final now = widget.prayerModule.clock.nowLocal();
    final nextPrayer = widget.prayerModule.scheduleService.getNextPrayer(
      todaySchedule: _todaySchedule!,
      tomorrowSchedule: _tomorrowSchedule,
    );
    final currentPrayer = widget.prayerModule.scheduleService.getCurrentPrayer(
      todaySchedule: _todaySchedule!,
    );

    return Card(
      child: Padding(
        padding: AppSpacing.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  AppStrings.prayerTimes,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  _formatDate(_todaySchedule!.date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(height: AppSpacing.l),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prayers.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = prayers[index];
                final log = _trackingLogs[entry.type];
                final isPrayed = log?.status == PrayerTrackingStatus.prayed;
                final isMissed = log?.status == PrayerTrackingStatus.missed;

                final isNext = nextPrayer?.type == entry.type;
                final isCurrent = currentPrayer?.type == entry.type;
                final isPassed = entry.time.isBefore(now);

                return Container(
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : (isNext ? AppColors.goldAccent.withValues(alpha: 0.08) : Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        _getPrayerIcon(entry.type),
                        color: isCurrent ? AppColors.primary : (isNext ? AppColors.goldAccent : Colors.grey),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 2,
                              children: [
                                Text(
                                  entry.type.nameArabic,
                                  style: TextStyle(
                                    fontWeight: (isCurrent || isNext) ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 15,
                                    color: isPassed && !isCurrent ? (isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600) : null,
                                  ),
                                ),
                                if (isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('الحالية', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  )
                                else if (isNext)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.goldAccent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('القادمة', style: TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                if (entry.isAdjusted)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${entry.adjustmentMinutes > 0 ? "+" : ""}${entry.adjustmentMinutes} د',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              _formatTime(entry.time),
                              style: TextStyle(
                                fontSize: 13,
                                color: isPassed && !isCurrent
                                    ? (isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600)
                                    : (isDark ? const Color(0xFFCBD5E1) : Theme.of(context).textTheme.bodySmall?.color),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tracking status buttons
                      IconButton(
                        icon: Icon(
                          isPrayed ? Icons.check_circle : Icons.check_circle_outline,
                          color: isPrayed ? AppColors.success : Theme.of(context).disabledColor,
                        ),
                        tooltip: AppStrings.prayed,
                        onPressed: () => _updateTracking(
                          entry.type,
                          isPrayed ? PrayerTrackingStatus.notRecorded : PrayerTrackingStatus.prayed,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isMissed ? Icons.cancel : Icons.cancel_outlined,
                          color: isMissed ? AppColors.error : Theme.of(context).disabledColor,
                        ),
                        tooltip: AppStrings.missed,
                        onPressed: () => _updateTracking(
                          entry.type,
                          isMissed ? PrayerTrackingStatus.notRecorded : PrayerTrackingStatus.missed,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiblaCompassSection(BuildContext context, bool isDark) {
    final degrees = _qiblaResult?.directionDegrees.toStringAsFixed(1) ?? '--';

    return Card(
      elevation: 0.5,
      color: isDark ? AppColors.surfaceDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.explore_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            AppStrings.qiblaDirection,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            ': $degrees°',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'الكعبة المشرفة بمكة المكرمة',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFFCBD5E1) : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showCompass = !_showCompass),
                  icon: Icon(
                    _showCompass ? Icons.visibility_off_rounded : Icons.explore_rounded,
                    size: 16,
                  ),
                  label: Text(_showCompass ? 'إخفاء البوصلة' : 'إظهار البوصلة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.goldAccentLight : AppColors.primary,
                    side: BorderSide(
                      color: (isDark ? AppColors.goldAccentLight : AppColors.primary).withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ],
            ),
            if (_showCompass) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              QiblaCompassView(
                qibla: _qiblaResult,
                isDark: isDark,
                compassService: widget.compassService,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMethodologyDisclosureCard(BuildContext context, bool isDark, PrayerSchedule schedule) {
    final d = schedule.disclosure;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
        title: Text(
          AppStrings.assumptionsDisclosure,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          d.methodName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: AppSpacing.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildParamRow(context, 'الجهة المعتمدة للحساب', d.methodName),
                _buildParamRow(context, AppStrings.fajrAngle, '${d.fajrAngle}°'),
                _buildParamRow(
                  context,
                  AppStrings.ishaAngle,
                  d.ishaAngle != null ? '${d.ishaAngle}°' : '${d.ishaIntervalMinutes} دقيقة بعد المغرب',
                ),
                _buildParamRow(
                  context,
                  AppStrings.asrMethod,
                  d.asrMethod == AsrJuristicMethod.hanafi ? 'المذهب الحنفي (ظل الشيء مثليه)' : 'جمهور الفقهاء (الشافعي وظل الشيء مثله)',
                ),
                _buildParamRow(
                  context,
                  AppStrings.highLatitudeRule,
                  d.highLatitudeRule.name,
                ),
                _buildParamRow(
                  context,
                  AppStrings.location,
                  '${d.location.latitude.toStringAsFixed(4)}°, ${d.location.longitude.toStringAsFixed(4)}°',
                ),
                const SizedBox(height: AppSpacing.s),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _openSettings,
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('تعديل الإعدادات والجهة'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParamRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  IconData _getPrayerIcon(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Icons.wb_twilight_rounded;
      case PrayerType.sunrise:
        return Icons.wb_sunny_outlined;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_rounded;
      case PrayerType.asr:
        return Icons.wb_cloudy_rounded;
      case PrayerType.maghrib:
        return Icons.nights_stay_outlined;
      case PrayerType.isha:
        return Icons.nights_stay_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }
}
