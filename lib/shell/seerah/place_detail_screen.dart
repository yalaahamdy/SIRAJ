import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/historical_place.dart';

/// Screen displaying historical location details, modern equivalents, and certainty levels (§11, §36).
class PlaceDetailScreen extends StatelessWidget {
  final HistoricalPlace place;

  const PlaceDetailScreen({
    super.key,
    required this.place,
  });

  Color _getCertaintyColor() {
    switch (place.certainty) {
      case PlaceCertainty.high:
        return const Color(0xFF0F5132);
      case PlaceCertainty.approximate:
        return const Color(0xFF856404);
      case PlaceCertainty.disputed:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getCertaintyColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(place.nameArabic),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            place.certainty.labelArabic,
                            style: TextStyle(
                              color: badgeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'إقليم: ${place.region}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    place.nameArabic,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (place.modernName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'الاسم المعاصر المحقق: ${place.modernName!}',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                    ),
                  ],
                  const Divider(height: 24),
                  const Text(
                    'الوصف الجغرافي والتاريخي:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F5132)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.geographicalDescription,
                    style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
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
