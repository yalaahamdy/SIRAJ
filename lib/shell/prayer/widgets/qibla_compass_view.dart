import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/i18n/app_strings.dart';
import '../../../core/location/location_models.dart';
import '../../../core/location/sensor_compass_service.dart';
import '../../../modules/prayer/domain/qibla_result.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Interactive, sensor-aware, transparent Qibla Compass Card (§15, §16, §31, §34).
class QiblaCompassView extends StatefulWidget {
  final QiblaResult? qibla;
  final bool isDark;
  final VoidCallback? onCalibrate;
  final SensorCompassService? compassService;

  const QiblaCompassView({
    super.key,
    required this.qibla,
    required this.isDark,
    this.onCalibrate,
    this.compassService,
  });

  @override
  State<QiblaCompassView> createState() => _QiblaCompassViewState();
}

class _QiblaCompassViewState extends State<QiblaCompassView> {
  late SensorCompassService _compassService;
  StreamSubscription<CompassHeading>? _headingSub;
  double? _deviceHeading;
  bool _hasSensor = true;
  bool _checkingSensor = true;

  @override
  void initState() {
    super.initState();
    _compassService = widget.compassService ?? DeviceSensorCompassService();
    _initCompass();
  }

  @override
  void didUpdateWidget(covariant QiblaCompassView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.compassService != oldWidget.compassService && widget.compassService != null) {
      _headingSub?.cancel();
      _compassService = widget.compassService!;
      _initCompass();
    }
  }

  Future<void> _initCompass() async {
    final available = await _compassService.checkSensorAvailability();
    if (!mounted) return;
    setState(() {
      _hasSensor = available;
      _checkingSensor = false;
    });

    if (available) {
      _headingSub = _compassService.headingStream.listen(
        (heading) {
          if (!mounted) return;
          setState(() {
            if (!heading.hasSensor) {
              _hasSensor = false;
            } else {
              _deviceHeading = heading.degrees;
            }
          });
        },
        onError: (_) {
          if (!mounted) return;
          setState(() {
            _hasSensor = false;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _headingSub?.cancel();
    if (widget.compassService == null) {
      _compassService.dispose();
    }
    super.dispose();
  }

  void _showCalibrationInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.screen_rotation_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'إرشادات معايرة البوصلة',
                      style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                const Text(
                  'للحصول على أعلى دقة، حرك الهاتف على شكل رقم (8) بالإنجليزية عدة مرات بعيداً عن المعادن والأجهزة الكهربائية.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: AppSpacing.l),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('حسناً، فهمت'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.qibla == null) {
      return Card(
        child: Padding(
          padding: AppSpacing.paddingCard,
          child: Column(
            children: [
              const Icon(Icons.location_off_rounded, size: 40, color: Colors.grey),
              const SizedBox(height: AppSpacing.s),
              Text(
                'الموقع الجغرافي غير محدد لحساب القبلة',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final bearing = widget.qibla!.directionDegrees;
    final distance = widget.qibla!.distanceKilometers;

    // Relative Qibla angle from top of phone:
    // If phone is facing _deviceHeading, Kaaba is at (bearing - _deviceHeading)
    final relativeAngle = _deviceHeading != null ? (bearing - _deviceHeading!) : bearing;
    final isFacingQibla = _deviceHeading != null && ((bearing - _deviceHeading!).abs() < 5.0 || (360.0 - (bearing - _deviceHeading!).abs()) < 5.0);

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.explore_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        AppStrings.qiblaDirection,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: widget.onCalibrate ?? () => _showCalibrationInstructions(context),
                  icon: const Icon(Icons.screen_rotation_rounded, size: 16),
                  label: const Text('المعايرة', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),

            // Layer 1: Explicit True North Geographic Bearing
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.public_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'القبلة: ${bearing.toStringAsFixed(1)}° من الشمال الحقيقي',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.m),

            // Layer 2: Sensor-Aware Visual Dial OR Honest Unsupported Notice
            if (_checkingSensor)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_hasSensor && _deviceHeading != null) ...[
              // Device has active magnetometer sensor
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Dial rotated by -deviceHeading so North points to real world North
                    Transform.rotate(
                      angle: -_deviceHeading! * (math.pi / 180.0),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          border: Border.all(
                            color: isFacingQibla ? Colors.green : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: isFacingQibla ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isFacingQibla ? Colors.green.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 6,
                              child: Column(
                                children: [
                                  const Text('N', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                                  Container(width: 2, height: 8, color: Colors.red),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              child: Text('S', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            ),
                            Positioned(
                              right: 6,
                              child: Text('E', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            ),
                            Positioned(
                              left: 6,
                              child: Text('W', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Pointer to Qibla
                    Transform.rotate(
                      angle: relativeAngle * (math.pi / 180.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isFacingQibla ? Colors.green : AppColors.goldAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mosque_rounded, color: Colors.black87, size: 18),
                          ),
                          Container(
                            width: 3,
                            height: 42,
                            decoration: BoxDecoration(
                              color: isFacingQibla ? Colors.green : AppColors.goldAccent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 42),
                        ],
                      ),
                    ),

                    // Center Pivot
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFacingQibla ? Colors.green : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Center(
                child: Text(
                  isFacingQibla ? 'أنت باتجاه القبلة المشرفة الآن 🕋' : 'وجّه هاتفك نحو رمز الكعبة المشرفة',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isFacingQibla ? Colors.green : (widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                ),
              ),
            ] else ...[
              // Device lacks magnetometer sensor — HONEST TRANSPARENT UI
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade700, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Colors.amber.shade800, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'المستشعر المغناطيسي غير متاح',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'هاتفك لا يحتوي على مستشعر اتجاه (بوصلة) مناسب.\nيمكنك معرفة اتجاه القبلة الجغرافي بالنسبة إلى الشمال الحقيقي، أو الاستعانة بموقعك على الخريطة لتحديد الوجهة بدقة.',
                      style: TextStyle(fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              // Static Azimuth Guide
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Positioned(
                        top: 4,
                        child: Text('الشمال 0°', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                      Transform.rotate(
                        angle: bearing * (math.pi / 180.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.navigation_rounded, size: 20, color: AppColors.primary),
                            Container(width: 2, height: 26, color: AppColors.primary),
                            const SizedBox(height: 26),
                          ],
                        ),
                      ),
                      Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'رسم توضيحي للزاوية الجغرافية من الشمال (وليس بوصلة حية)',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.m),

            // Geographic Details Summary
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('زاوية الاتجاه', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${bearing.toStringAsFixed(1)}°',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 24, width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: Column(
                    children: [
                      const Text('المسافة إلى مكة المكرمة', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${distance.toStringAsFixed(0)} كم',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 24, width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: Column(
                    children: [
                      const Text('مصدر الحساب', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'حساب كروي دقيق',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
