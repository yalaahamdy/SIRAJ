import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/historical_place.dart';
import '../theme/app_colors.dart';

/// Screen displaying historical location details, modern equivalents, and certainty levels (§11, §36).
class PlaceDetailScreen extends StatelessWidget {
  final HistoricalPlace place;

  const PlaceDetailScreen({
    super.key,
    required this.place,
  });

  Color _getCertaintyColor(bool isDark) {
    switch (place.certainty) {
      case PlaceCertainty.high:
        return isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);
      case PlaceCertainty.approximate:
        return isDark ? const Color(0xFFFBBF24) : const Color(0xFF856404);
      case PlaceCertainty.disputed:
        return isDark ? const Color(0xFFF87171) : Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = _getCertaintyColor(isDark);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155);
    final primaryAccent = isDark ? AppColors.goldAccentLight : const Color(0xFF0F5132);
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final cardBorder = isDark ? AppColors.borderDark : const Color(0xFF0F5132).withAlpha(45);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            place.nameArabic,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          Card(
            elevation: isDark ? 1 : 2,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: cardBorder, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor.withAlpha(isDark ? 40 : 25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: badgeColor.withAlpha(isDark ? 120 : 80)),
                          ),
                          child: Text(
                            place.certainty.labelArabic,
                            style: TextStyle(
                              color: badgeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
                          ),
                          child: Text(
                            'إقليم: ${place.region}',
                            style: TextStyle(fontSize: 12, color: bodyColor, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    place.nameArabic,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (place.modernName != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.pin_drop_outlined, size: 14, color: primaryAccent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'الاسم المعاصر المحقق: ${place.modernName!}',
                            style: TextStyle(fontSize: 13, color: subColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (place.latitude != null && place.longitude != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.my_location, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          'الإحداثيات التقريبية: ${place.latitude!.toStringAsFixed(4)}° N, ${place.longitude!.toStringAsFixed(4)}° E',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Divider(height: 24, color: isDark ? AppColors.borderDark : null),
                  Row(
                    children: [
                      Icon(Icons.map_outlined, size: 16, color: primaryAccent),
                      const SizedBox(width: 6),
                      Text(
                        'الوصف الجغرافي والتاريخي:',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: primaryAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.geographicalDescription,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.65,
                      color: bodyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
