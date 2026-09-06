import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/location/location_models.dart';
import '../../../core/location/sensor_compass_service.dart';
import '../../../modules/prayer/domain/qibla_result.dart';
import '../../theme/app_colors.dart';
import 'qibla_compass_painter.dart';

/// Full-Screen Immersive, Luxury Astrolabe Qibla Compass Experience (§15, §16, §31, §34).
class QiblaFullScreenView extends StatefulWidget {
  final QiblaResult qibla;
  final SensorCompassService? compassService;

  const QiblaFullScreenView({
    super.key,
    required this.qibla,
    this.compassService,
  });

  @override
  State<QiblaFullScreenView> createState() => _QiblaFullScreenViewState();
}

class _QiblaFullScreenViewState extends State<QiblaFullScreenView>
    with SingleTickerProviderStateMixin {
  late SensorCompassService _compassService;
  StreamSubscription<CompassHeading>? _headingSub;

  double _currentHeading = 0.0;
  double _targetHeading = 0.0;
  bool _hasSensor = true;
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

  Future<void> _initCompass() async {
    final available = await _compassService.checkSensorAvailability();
    if (!mounted) return;
    setState(() {
      _hasSensor = available;
    });

    if (available) {
      _headingSub = _compassService.headingStream.listen((heading) {
        if (!mounted) return;
        if (!heading.hasSensor) {
          setState(() => _hasSensor = false);
          return;
        }

        final newHeading = heading.degrees;
        // Smooth angular tracking without 360 wrap glitch
        double diff = (newHeading - _currentHeading + 540) % 360 - 180;
        _targetHeading = _currentHeading + diff;

        final bearing = widget.qibla.directionDegrees;
        final deltaToQibla = ((bearing - newHeading).abs()) % 360;
        final isFacing = deltaToQibla <= 3.5 || deltaToQibla >= 356.5;

        if (isFacing && !_lastFacingState) {
          // Haptic impact feedback on locking into Qibla
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

        setState(() {
          _currentHeading = _targetHeading;
        });
      });
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

  String _getDirectionTurnText(double diff) {
    if (diff.abs() <= 3.5 || diff.abs() >= 356.5) {
      return 'أنت باتجاه القبلة المشرفة الآن 🕋';
    }
    // Normalize diff to -180..180
    final normalized = (diff + 540) % 360 - 180;
    if (normalized > 0) {
      return 'أدر هاتفك ${normalized.toStringAsFixed(0)}° يميناً ↻';
    } else {
      return 'أدر هاتفك ${normalized.abs().toStringAsFixed(0)}° يساراً ↺';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bearing = widget.qibla.directionDegrees;
    final distance = widget.qibla.distanceKilometers;
    final normHeading = (_currentHeading % 360 + 360) % 360;
    final deltaToQibla = (bearing - normHeading);
    final isFacing = _hasSensor && (deltaToQibla.abs() <= 3.5 || (360 - deltaToQibla.abs()) <= 3.5);

    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.goldAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'بوصلة القبلة المشرفة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => _showCalibrationInstructions(context),
            icon: const Icon(Icons.screen_rotation_rounded, size: 16, color: AppColors.goldAccent),
            label: const Text('المعايرة', style: TextStyle(color: AppColors.goldAccent, fontSize: 13)),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dialSize = math.min(constraints.maxWidth - 40, constraints.maxHeight * 0.48).clamp(220.0, 360.0);

            return Column(
              children: [
                const SizedBox(height: 8),

                // Top Guidance Status Badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isFacing
                          ? const Color(0xFF10B981).withValues(alpha: 0.22)
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isFacing
                            ? const Color(0xFF10B981)
                            : AppColors.goldAccent.withValues(alpha: 0.4),
                        width: isFacing ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFacing ? Icons.check_circle_rounded : Icons.explore_rounded,
                          size: 18,
                          color: isFacing ? const Color(0xFF34D399) : AppColors.goldAccent,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isFacing
                                ? 'أنت باتجاه القبلة المشرفة الآن 🕋'
                                : (_hasSensor
                                    ? _getDirectionTurnText(deltaToQibla)
                                    : 'المستشعر المغناطيسي غير متاح'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: isFacing ? const Color(0xFF34D399) : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Center Dial
                Center(
                  child: SizedBox(
                    width: dialSize,
                    height: dialSize,
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: QiblaCompassPainter(
                            deviceHeading: normHeading,
                            qiblaBearing: bearing,
                            isFacingQibla: isFacing,
                            glowAnimation: _glowController.value,
                            isDark: true,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const Spacer(),

                // Degree Details Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.goldAccent.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricColumn('زاوية الاتجاه', '${bearing.toStringAsFixed(1)}°'),
                      Container(height: 32, width: 1, color: Colors.white12),
                      _buildMetricColumn('اتجاه الهاتف', '${normHeading.toStringAsFixed(0)}°'),
                      Container(height: 32, width: 1, color: Colors.white12),
                      _buildMetricColumn('المسافة إلى مكة المكرمة', '${distance.toStringAsFixed(0)} كم'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white60),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.goldAccent,
          ),
        ),
      ],
    );
  }

  void _showCalibrationInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.screen_rotation_rounded, color: AppColors.goldAccent),
                    SizedBox(width: 8),
                    Text(
                      'إرشادات معايرة البوصلة',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'للحصول على أعلى دقة، حرك الهاتف على شكل رقم (8) بالإنجليزية عدة مرات بعيداً عن المعادن والأجهزة الكهربائية.',
                  style: TextStyle(fontSize: 14, height: 1.6, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('حسناً، فهمت', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
