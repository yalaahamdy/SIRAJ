import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/sacred_location.dart';
import '../../../modules/hajj/hajj_module.dart';
import 'widgets/interactive_sacred_map_widget.dart';

/// Sacred Locations Guide Screen (§50..§52, §107).
class SacredLocationsScreen extends StatelessWidget {
  final HajjModule module;

  const SacredLocationsScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final locRes = module.getAllLocations();
    final locations = locRes.isSuccess ? locRes.valueOrNull! : <SacredLocation>[];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المشاعر والمواقع المقدسة', style: TextStyle(fontSize: 16)),
        centerTitle: false,
      ),
      body: locations.isEmpty
          ? const Center(child: Text('لا توجد مواقع مقدسة محملة.'))
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.map_outlined,
                      color: isDark ? const Color(0xFF2DD4BF) : Colors.teal,
                    ),
                    title: const Text(
                      'خريطة المشاعر والمواقيت التفاعلية',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      'عرض جغرافي بصري تفاعلي للمشاعر والمواقيت بدون إنترنت',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InteractiveSacredMapWidget(locations: locations),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    'دليل المواقع والمشاعر التفصيلي (${locations.length}):',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                ...locations.map((l) {
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.teal, size: 20),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l.nameArabic,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l.description,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'السياق الشرعي والتاريخي: ${l.historicalContext}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
