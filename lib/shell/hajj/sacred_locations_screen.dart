import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/sacred_location.dart';
import '../../../modules/hajj/hajj_module.dart';

/// Sacred Locations Guide Screen (§50..§52, §107).
class SacredLocationsScreen extends StatelessWidget {
  final HajjModule module;

  const SacredLocationsScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final locRes = module.getAllLocations();
    final locations = locRes.isSuccess ? locRes.valueOrNull! : <SacredLocation>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('المشاعر والمواقع المقدسة', style: TextStyle(fontSize: 16)),
        centerTitle: false,
      ),
      body: locations.isEmpty
          ? const Center(child: Text('لا توجد مواقع مقدسة محملة.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final l = locations[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
