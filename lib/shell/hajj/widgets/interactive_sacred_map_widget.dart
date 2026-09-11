import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/sacred_location.dart';
import '../../theme/app_colors.dart';

/// Point on the sacred map canvas
class _MapPoint {
  final String id;
  final String nameArabic;
  final String subtitle;
  final double distanceKm;
  final double angleDeg; // Angle from Makkah (0 = East, 90 = North, etc.)
  final IconData icon;
  final Color color;
  final String ritualSignificance;

  const _MapPoint({
    required this.id,
    required this.nameArabic,
    required this.subtitle,
    required this.distanceKm,
    required this.angleDeg,
    required this.icon,
    required this.color,
    required this.ritualSignificance,
  });
}

/// Offline, interactive vector canvas map for Hajj and Umrah Sacred Locations (§50..§52, §107).
class InteractiveSacredMapWidget extends StatefulWidget {
  final List<SacredLocation> locations;

  const InteractiveSacredMapWidget({
    super.key,
    required this.locations,
  });

  @override
  State<InteractiveSacredMapWidget> createState() => _InteractiveSacredMapWidgetState();
}

class _InteractiveSacredMapWidgetState extends State<InteractiveSacredMapWidget> {
  _MapPoint? _selectedPoint;
  bool _showMiqats = false;

  // Canonical Makkah & Ritual Stations
  static const List<_MapPoint> _ritualStations = [
    _MapPoint(
      id: 'haram',
      nameArabic: 'المسجد الحرام والكعبة المشرفة',
      subtitle: 'مركز النسك وبداية الطواف والسعي',
      distanceKm: 0.0,
      angleDeg: 0.0,
      icon: Icons.mosque_rounded,
      color: Color(0xFFD4AF37),
      ritualSignificance: 'طواف القدوم، السعي، طواف الإفاضة، وطواف الوداع',
    ),
    _MapPoint(
      id: 'mina',
      nameArabic: 'مشعر منى',
      subtitle: 'يوم التروية وأيام التشريق ورمي الجمار',
      distanceKm: 7.5,
      angleDeg: 75.0, // North-East
      icon: Icons.holiday_village_rounded,
      color: Color(0xFF1B4D3E),
      ritualSignificance: 'المبيت ليلة 9 ذو الحجة وأيام التشريق 11، 12، 13',
    ),
    _MapPoint(
      id: 'muzdalifah',
      nameArabic: 'مشعر مزدلفة (المشعر الحرام)',
      subtitle: 'المبيت بعد الإفاضة من عرفات وجمع الحصى',
      distanceKm: 13.0,
      angleDeg: 85.0,
      icon: Icons.nights_stay_rounded,
      color: Color(0xFF2C3E50),
      ritualSignificance: 'المبيت ليلة النحر وصلاة المغرب والعشاء جمعاً وقصراً',
    ),
    _MapPoint(
      id: 'arafat',
      nameArabic: 'صعيد وجبل عرفات',
      subtitle: 'الركن الأعظم للحج (الحج عرفة)',
      distanceKm: 21.0,
      angleDeg: 95.0, // South-East
      icon: Icons.terrain_rounded,
      color: Color(0xFFC0392B),
      ritualSignificance: 'الوقوف بعرفة من زوال شمس يوم 9 ذو الحجة إلى غروبها',
    ),
    _MapPoint(
      id: 'jamarat',
      nameArabic: 'موقع منشأة الجمرات',
      subtitle: 'رمي الجمرة الكبرى والوسطى والصغرى',
      distanceKm: 5.0,
      angleDeg: 65.0,
      icon: Icons.gps_fixed_rounded,
      color: Color(0xFFE67E22),
      ritualSignificance: 'رمي جمرة العقبة يوم النحر، ورمي الجمار الثلاث في التشريق',
    ),
  ];

  // The 5 Spatial Miqats (المواقيت المكانية الخمسة)
  static const List<_MapPoint> _miqatStations = [
    _MapPoint(
      id: 'dhul_hulaifah',
      nameArabic: 'ذو الحليفة (أبيار علي)',
      subtitle: 'ميقات أهل المدينة ومن أتى على طريقهم',
      distanceKm: 420.0,
      angleDeg: 0.0, // North
      icon: Icons.flag_rounded,
      color: Color(0xFF16A085),
      ritualSignificance: 'أبعد المواقيت عن مكة المكرمة (حوالي 420 كم شمالاً)',
    ),
    _MapPoint(
      id: 'al_juhfah',
      nameArabic: 'الجحفة (رابغ)',
      subtitle: 'ميقات أهل الشام ومصر والمغرب العربي',
      distanceKm: 187.0,
      angleDeg: 315.0, // North-West
      icon: Icons.flag_rounded,
      color: Color(0xFF2980B9),
      ritualSignificance: 'ميقات أهل الشام ومصر ومَن في طريقهم',
    ),
    _MapPoint(
      id: 'qarn_manazil',
      nameArabic: 'قرن المنازل (السيل الكبير)',
      subtitle: 'ميقات أهل نجد والطائف والخليج',
      distanceKm: 78.0,
      angleDeg: 80.0, // East
      icon: Icons.flag_rounded,
      color: Color(0xFF8E44AD),
      ritualSignificance: 'ميقات أهل نجد وشرق الجزيرة والخليج العربي',
    ),
    _MapPoint(
      id: 'yalamlam',
      nameArabic: 'يَلَمْلَم (السعدية)',
      subtitle: 'ميقات أهل اليمن ومن في طريقهم',
      distanceKm: 120.0,
      angleDeg: 160.0, // South
      icon: Icons.flag_rounded,
      color: Color(0xFFD35400),
      ritualSignificance: 'ميقات القادمين من اليمن وجنوب الجزيرة وجنوب آسيا',
    ),
    _MapPoint(
      id: 'dhat_irq',
      nameArabic: 'ذات عِرْق (الضريبة)',
      subtitle: 'ميقات أهل العراق وإيران وخراسان',
      distanceKm: 100.0,
      angleDeg: 45.0, // North-East
      icon: Icons.flag_rounded,
      color: Color(0xFF27AE60),
      ritualSignificance: 'ميقات أهل العراق ومن جاء من جهتهم',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activePoints = _showMiqats ? _miqatStations : _ritualStations;

    return Column(
      children: [
        // Mode Selector Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('المشاعر (منى/عرفات)'),
                      icon: Icon(Icons.route_rounded, size: 16),
                    ),
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('المواقيت المكانية'),
                      icon: Icon(Icons.explore_rounded, size: 16),
                    ),
                  ],
                  selected: {_showMiqats},
                  onSelectionChanged: (val) {
                    setState(() {
                      _showMiqats = val.first;
                      _selectedPoint = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Interactive Vector Canvas
        Container(
          height: 260,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Canvas Background Grid & Paths
                CustomPaint(
                  size: const Size(double.infinity, 260),
                  painter: _SacredMapPainter(
                    isDark: isDark,
                    isMiqatsMode: _showMiqats,
                    points: activePoints,
                    selectedPoint: _selectedPoint,
                  ),
                ),

                // Interactive Station Buttons overlay
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    final cx = constraints.maxWidth / 2;
                    final cy = constraints.maxHeight / 2;
                    final scale = _showMiqats ? (cx * 0.75) / 450.0 : (cx * 0.75) / 24.0;

                    return Stack(
                      children: activePoints.map((pt) {
                        final rad = pt.angleDeg * math.pi / 180.0;
                        final px = cx + (pt.distanceKm * scale * math.cos(rad));
                        final py = cy - (pt.distanceKm * scale * math.sin(rad));
                        final isSelected = _selectedPoint?.id == pt.id;

                        return Positioned(
                          left: px - (isSelected ? 22 : 18),
                          top: py - (isSelected ? 22 : 18),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedPoint = pt);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isSelected ? 44 : 36,
                              height: isSelected ? 44 : 36,
                              decoration: BoxDecoration(
                                color: pt.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.amber : Colors.white,
                                  width: isSelected ? 2.5 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: pt.color.withValues(alpha: 0.4),
                                    blurRadius: isSelected ? 12 : 6,
                                    spreadRadius: isSelected ? 2 : 0,
                                  ),
                                ],
                              ),
                              child: Icon(pt.icon, color: Colors.white, size: isSelected ? 22 : 18),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                // Map Compass Indicator
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.navigation, size: 12, color: Color(0xFFD4AF37)),
                        SizedBox(width: 4),
                        Text('الشمال', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Selected Station Info Card
        if (_selectedPoint != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _selectedPoint!.color.withValues(alpha: 0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _selectedPoint!.color.withValues(alpha: 0.15),
                  child: Icon(_selectedPoint!.icon, color: _selectedPoint!.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedPoint!.nameArabic,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedPoint!.distanceKm == 0
                            ? 'نقطة الانطلاق والمركز المقدس'
                            : 'المسافة عن الحرم المكي: ${_selectedPoint!.distanceKm.toStringAsFixed(1)} كم تقريباً',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? Colors.amber[200] : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedPoint!.ritualSignificance,
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() => _selectedPoint = null),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Custom Vector Canvas drawing concentric distance rings and pilgrim trajectory
class _SacredMapPainter extends CustomPainter {
  final bool isDark;
  final bool isMiqatsMode;
  final List<_MapPoint> points;
  final _MapPoint? selectedPoint;

  const _SacredMapPainter({
    required this.isDark,
    required this.isMiqatsMode,
    required this.points,
    this.selectedPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);

    final ringPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric distance circles
    final maxDist = isMiqatsMode ? 450.0 : 24.0;
    final maxRadius = cx * 0.75;
    final scale = maxRadius / maxDist;

    final ringsCount = isMiqatsMode ? 4 : 3;
    for (int i = 1; i <= ringsCount; i++) {
      final r = maxRadius * (i / ringsCount);
      canvas.drawCircle(center, r, ringPaint);
    }

    // In Ritual Mode: Draw connected pilgrim trajectory line (Makkah -> Mina -> Arafat -> Muzdalifah -> Mina)
    if (!isMiqatsMode && points.length >= 4) {
      final pathPaint = Paint()
        ..color = const Color(0xFFD4AF37).withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final path = Path();
      bool first = true;
      for (final pt in points) {
        final rad = pt.angleDeg * math.pi / 180.0;
        final px = cx + (pt.distanceKm * scale * math.cos(rad));
        final py = cy - (pt.distanceKm * scale * math.sin(rad));
        if (first) {
          path.moveTo(px, py);
          first = false;
        } else {
          path.lineTo(px, py);
        }
      }
      canvas.drawPath(path, pathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SacredMapPainter oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.isMiqatsMode != isMiqatsMode ||
        oldDelegate.selectedPoint != selectedPoint;
  }
}
