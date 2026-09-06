import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/i18n/app_strings.dart';
import '../../../core/location/location_models.dart';
import '../../../core/location/sensor_compass_service.dart';
import '../../../modules/prayer/domain/qibla_result.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'qibla_compass_painter.dart';
import 'qibla_full_screen_view.dart';

/// Professional, Luxury Islamic Astrolabe Qibla Compass Card (§15, §16, §31, §34).
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

class _QiblaCompassViewState extends State<QiblaCompassView>
    with SingleTickerProviderStateMixin {
  late SensorCompassService _compassService;
  StreamSubscription<CompassHeading>? _headingSub;

  double? _deviceHeading;
  double _animatedHeading = 0.0;
  bool _hasSensor = true;
  bool _checkingSensor = true;
  bool _lastFacingState = false;

  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _compassService = widget.compassService ?? DeviceSensorCompassService();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

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

              // Smooth angular tracking without 360 wrap glitch
              final newDegrees = heading.degrees;
              double diff = (newDegrees - _animatedHeading + 540) % 360 - 180;
              _animatedHeading += diff;

              if (widget.qibla != null) {
                final bearing = widget.qibla!.directionDegrees;
                final deltaToQibla = ((bearing - newDegrees).abs()) % 360;
                final isFacing = deltaToQibla <= 4.0 || deltaToQibla >= 356.0;

                if (isFacing && !_lastFacingState) {
                  HapticFeedback.mediumImpact();
                  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
                    _glowController.repeat(reverse: true);
                  }
                } else if (!isFacing && _lastFacingState) {
                  if (_glowController.isAnimating) {
                    _glowController.stop();
                    _glowController.reset();
                  }
                }
                _lastFacingState = isFacing;
              }
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
    _glowController.dispose();
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

  String _getDirectionTurnText(double diff) {
    final normalized = (diff + 540) % 360 - 180;
    if (normalized.abs() <= 4.0) {
      return 'أنت باتجاه القبلة المشرفة الآن 🕋';
    }
    if (normalized > 0) {
      return 'أدر هاتفك ${normalized.toStringAsFixed(0)}° يميناً ↻';
    } else {
      return 'أدر هاتفك ${normalized.abs().toStringAsFixed(0)}° يساراً ↺';
    }
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
    final currentDegrees = _deviceHeading ?? 0.0;
    final deltaToQibla = (bearing - currentDegrees);
    final isFacingQibla = _deviceHeading != null &&
        ((deltaToQibla.abs() <= 4.0) || (360.0 - deltaToQibla.abs()) <= 4.0);

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isFacingQibla
              ? Colors.green.withValues(alpha: 0.6)
              : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isFacingQibla ? 1.8 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Actions
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isFacingQibla
                            ? Colors.green.withValues(alpha: 0.18)
                            : AppColors.primary.withValues(alpha: widget.isDark ? 0.25 : 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.explore_rounded,
                        color: isFacingQibla ? Colors.green : AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        AppStrings.qiblaDirection,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.fullscreen_rounded, size: 20),
                      tooltip: 'عرض البوصلة بالكامل',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      color: AppColors.goldAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QiblaFullScreenView(
                              qibla: widget.qibla!,
                              compassService: widget.compassService,
                            ),
                          ),
                        );
                      },
                    ),
                    TextButton.icon(
                      onPressed: widget.onCalibrate ?? () => _showCalibrationInstructions(context),
                      icon: const Icon(Icons.screen_rotation_rounded, size: 15),
                      label: const Text('المعايرة', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Layer 1: Geographic True North Bearing Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.isDark ? Colors.white10 : Colors.black12,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.public_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'القبلة: ${bearing.toStringAsFixed(1)}° من الشمال الحقيقي',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Layer 2: Live Astrolabe Dial OR Honest Sensor Unavailable Notice
            if (_checkingSensor)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_hasSensor && _deviceHeading != null) ...[
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: AnimatedBuilder(
                        animation: _glowController,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: QiblaCompassPainter(
                              deviceHeading: _animatedHeading,
                              qiblaBearing: bearing,
                              isFacingQibla: isFacingQibla,
                              glowAnimation: _glowController.value,
                              isDark: widget.isDark,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isFacingQibla
                            ? Colors.green.withValues(alpha: 0.15)
                            : (widget.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isFacingQibla ? Colors.green : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        isFacingQibla
                            ? 'أنت باتجاه القبلة المشرفة الآن 🕋'
                            : _getDirectionTurnText(deltaToQibla),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isFacingQibla
                              ? Colors.green
                              : (widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Device lacks magnetometer sensor — HONEST TRANSPARENT UI
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
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
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Positioned(
                        top: 6,
                        child: Text('الشمال 0°', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                      Transform.rotate(
                        angle: bearing * (math.pi / 180.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.navigation_rounded, size: 22, color: AppColors.primary),
                            Container(width: 2.5, height: 28, color: AppColors.primary),
                            const SizedBox(height: 28),
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
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('زاوية الاتجاه', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
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
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('المسافة إلى مكة المكرمة', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
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
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('مصدر الحساب', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
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
