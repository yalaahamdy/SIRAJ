import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// High-performance, luxury Islamic Astrolabe & Compass Dial Painter (§15, §16, §31, §34).
class QiblaCompassPainter extends CustomPainter {
  final double deviceHeading; // Degrees (0..360)
  final double qiblaBearing; // True North bearing (0..360)
  final bool isFacingQibla;
  final double glowAnimation; // 0.0 .. 1.0 for pulsating alignment
  final bool isDark;

  QiblaCompassPainter({
    required this.deviceHeading,
    required this.qiblaBearing,
    required this.isFacingQibla,
    required this.glowAnimation,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;
    if (radius <= 0) return;

    // Outer rotating dial angle: rotated by -deviceHeading so North points to real world North
    final dialRotation = -deviceHeading * (math.pi / 180.0);
    // Relative angle for Kaaba on the screen
    final kaabaAngleRad = (qiblaBearing - deviceHeading) * (math.pi / 180.0);

    // 1. Draw Outer Shadow & Aura Glow
    _drawOuterGlow(canvas, center, radius);

    // 2. Draw Astrolabe Brass Bezel & Base Plate
    _drawBezel(canvas, center, radius);

    // 3. Save canvas and rotate for the compass dial (Ticks, Cardinal directions, Astrolabe grid)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(dialRotation);

    _drawDialTicksAndDegrees(canvas, radius);
    _drawCardinalLabels(canvas, radius);
    _drawInnerIslamicStar(canvas, radius);
    _drawKaabaMarkerOnDial(canvas, radius);

    canvas.restore();

    // 4. Draw Center Alignment Beam (Screen-fixed towards top when facing Qibla)
    if (isFacingQibla) {
      _drawAlignmentBeam(canvas, center, radius, kaabaAngleRad);
    }

    // 5. Draw Target Top Indicator (Screen Fixed at 12 o'clock)
    _drawTopScreenIndicator(canvas, center, radius);

    // 6. Draw Center Pivot Jewel
    _drawCenterPivot(canvas, center, radius);
  }

  void _drawOuterGlow(Canvas canvas, Offset center, double radius) {
    if (isFacingQibla) {
      final pulseRadius = radius + 6 + (glowAnimation * 6);
      final glowPaint = Paint()
        ..color = const Color(0xFF10B981).withValues(alpha: 0.25 + (glowAnimation * 0.25))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawCircle(center, pulseRadius, glowPaint);
    } else {
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.35 : 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, radius, shadowPaint);
    }
  }

  void _drawBezel(Canvas canvas, Offset center, double radius) {
    // Outer Dial Background
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: isDark
            ? (isFacingQibla
                ? [const Color(0xFF064E3B), const Color(0xFF0F172A), const Color(0xFF022C22)]
                : [const Color(0xFF1E293B), const Color(0xFF0F172A), const Color(0xFF0B1120)])
            : (isFacingQibla
                ? [const Color(0xFFECFDF5), const Color(0xFFF0FDF4), const Color(0xFFD1FAE5)]
                : [const Color(0xFFFFFFFF), const Color(0xFFFDFBF7), const Color(0xFFF5EFE6)]),
        stops: const [0.4, 0.85, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    // Outer Brass Ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..color = isFacingQibla
          ? const Color(0xFF10B981)
          : (isDark ? AppColors.goldAccent.withValues(alpha: 0.7) : AppColors.goldAccent);
    canvas.drawCircle(center, radius - 2, ringPaint);

    // Inner Thin Rim
    final innerRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = (isDark ? Colors.white24 : Colors.black12);
    canvas.drawCircle(center, radius - 18, innerRimPaint);
  }

  void _drawDialTicksAndDegrees(Canvas canvas, double radius) {
    final tickPaintMajor = Paint()
      ..color = isFacingQibla
          ? const Color(0xFF34D399)
          : (isDark ? AppColors.goldAccentLight : AppColors.goldAccent)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final tickPaintMedium = Paint()
      ..color = isDark ? Colors.white38 : Colors.black38
      ..strokeWidth = 1.2;

    final tickPaintMinor = Paint()
      ..color = isDark ? Colors.white24 : Colors.black26
      ..strokeWidth = 0.8;

    for (int deg = 0; deg < 360; deg += 5) {
      final rad = deg * (math.pi / 180.0) - (math.pi / 2.0); // 0° at top (North)
      final cosA = math.cos(rad);
      final sinA = math.sin(rad);

      double tickLength;
      Paint paintToUse;

      if (deg % 30 == 0) {
        tickLength = 10.0;
        paintToUse = tickPaintMajor;
      } else if (deg % 10 == 0) {
        tickLength = 6.5;
        paintToUse = tickPaintMedium;
      } else {
        tickLength = 4.0;
        paintToUse = tickPaintMinor;
      }

      final startR = radius - 3.5;
      final endR = startR - tickLength;

      canvas.drawLine(
        Offset(cosA * startR, sinA * startR),
        Offset(cosA * endR, sinA * endR),
        paintToUse,
      );
    }
  }

  void _drawCardinalLabels(Canvas canvas, double radius) {
    const cardinals = [
      {'deg': 0, 'label': 'N', 'sub': 'شمال', 'color': Color(0xFFEF4444)},
      {'deg': 90, 'label': 'E', 'sub': 'شرق', 'color': AppColors.goldAccent},
      {'deg': 180, 'label': 'S', 'sub': 'جنوب', 'color': Colors.grey},
      {'deg': 270, 'label': 'W', 'sub': 'غرب', 'color': AppColors.goldAccent},
    ];

    for (final c in cardinals) {
      final deg = c['deg'] as int;
      final label = c['label'] as String;
      final color = c['color'] as Color;

      final rad = deg * (math.pi / 180.0) - (math.pi / 2.0);
      final labelRadius = radius - 30.0;
      final pos = Offset(math.cos(rad) * labelRadius, math.sin(rad) * labelRadius);

      final textSpan = TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: deg == 0 ? 14.5 : 12.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      // Keep letters readable right-side up relative to the cardinal point
      canvas.rotate(rad + math.pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  void _drawInnerIslamicStar(Canvas canvas, double radius) {
    final innerR = radius * 0.42;
    final starPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = (isDark ? AppColors.goldAccent.withValues(alpha: 0.25) : AppColors.goldAccent.withValues(alpha: 0.35));

    // Octagram (8-pointed Islamic geometric star)
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final outerAngle = (i * 45) * math.pi / 180.0;
      final innerAngle = ((i * 45) + 22.5) * math.pi / 180.0;

      final ox = math.cos(outerAngle) * innerR;
      final oy = math.sin(outerAngle) * innerR;
      final ix = math.cos(innerAngle) * (innerR * 0.72);
      final iy = math.sin(innerAngle) * (innerR * 0.72);

      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, starPaint);
    canvas.drawCircle(Offset.zero, innerR * 0.35, starPaint);
  }

  void _drawKaabaMarkerOnDial(Canvas canvas, double radius) {
    // Kaaba angle relative to North (0° = North = Top of dial)
    final rad = qiblaBearing * (math.pi / 180.0) - (math.pi / 2.0);
    final markerRadius = radius - 16.0;
    final markerPos = Offset(math.cos(rad) * markerRadius, math.sin(rad) * markerRadius);

    canvas.save();
    canvas.translate(markerPos.dx, markerPos.dy);
    canvas.rotate(rad + math.pi / 2);

    // Kaaba Needle / Pointer Line to Dial Edge
    final linePaint = Paint()
      ..color = isFacingQibla ? const Color(0xFF10B981) : AppColors.goldAccent
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, const Offset(0, -10), linePaint);

    // Kaaba Icon Cube Representation
    final cubePaint = Paint()
      ..color = isFacingQibla ? const Color(0xFF059669) : const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    final cubeBorder = Paint()
      ..color = isFacingQibla ? const Color(0xFF34D399) : AppColors.goldAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = Rect.fromCenter(center: const Offset(0, 4), width: 14, height: 14);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2.5)), cubePaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2.5)), cubeBorder);

    // Golden Kiswa Belt Line across the Kaaba Cube
    final goldBeltPaint = Paint()
      ..color = AppColors.goldAccent
      ..strokeWidth = 1.8;
    canvas.drawLine(const Offset(-6, 2), const Offset(6, 2), goldBeltPaint);

    canvas.restore();
  }

  void _drawAlignmentBeam(Canvas canvas, Offset center, double radius, double kaabaAngleRad) {
    final beamPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.45 + (glowAnimation * 0.3)),
          const Color(0xFF10B981).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    final beamPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - 24, center.dy - radius)
      ..lineTo(center.dx + 24, center.dy - radius)
      ..close();

    canvas.drawPath(beamPath, beamPaint);
  }

  void _drawTopScreenIndicator(Canvas canvas, Offset center, double radius) {
    // Fixed pointer at 12 o'clock showing phone pointing direction
    final trianglePaint = Paint()
      ..color = isFacingQibla ? const Color(0xFF10B981) : AppColors.goldAccent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy - radius + 2)
      ..lineTo(center.dx - 6, center.dy - radius - 7)
      ..lineTo(center.dx + 6, center.dy - radius - 7)
      ..close();
    canvas.drawPath(path, trianglePaint);
  }

  void _drawCenterPivot(Canvas canvas, Offset center, double radius) {
    // Concentric Jeweled Pivot
    final basePivot = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFFAF8F5)
      ..style = PaintingStyle.fill;
    final brassPivot = Paint()
      ..color = isFacingQibla ? const Color(0xFF10B981) : AppColors.goldAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final centerDot = Paint()
      ..color = isFacingQibla ? const Color(0xFF10B981) : AppColors.goldAccent
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 12, basePivot);
    canvas.drawCircle(center, 12, brassPivot);
    canvas.drawCircle(center, 4, centerDot);
  }

  @override
  bool shouldRepaint(covariant QiblaCompassPainter oldDelegate) {
    return oldDelegate.deviceHeading != deviceHeading ||
        oldDelegate.qiblaBearing != qiblaBearing ||
        oldDelegate.isFacingQibla != isFacingQibla ||
        oldDelegate.glowAnimation != glowAnimation ||
        oldDelegate.isDark != isDark;
  }
}
