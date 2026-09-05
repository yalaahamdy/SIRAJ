import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/miqat.dart';
import '../../../modules/hajj/hajj_module.dart';
import '../../../modules/hajj/services/miqat_service.dart';

/// Miqat Guide Screen with on-demand lookup (§14..§19, §107).
class MiqatGuideScreen extends StatefulWidget {
  final HajjModule module;
  final double? userLatitude;
  final double? userLongitude;

  const MiqatGuideScreen({
    super.key,
    required this.module,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  State<MiqatGuideScreen> createState() => _MiqatGuideScreenState();
}

class _MiqatGuideScreenState extends State<MiqatGuideScreen> {
  List<MiqatDistanceResult>? _closestMiqats;

  @override
  void initState() {
    super.initState();
    if (widget.userLatitude != null && widget.userLongitude != null) {
      final res = widget.module.findClosestMiqats(widget.userLatitude!, widget.userLongitude!);
      if (res.isSuccess) {
        _closestMiqats = res.valueOrNull;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final miqatsRes = widget.module.getAllMiqats();
    final miqats = miqatsRes.isSuccess ? miqatsRes.valueOrNull! : <Miqat>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('المواقيت المكانية للإحرام'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Informational Banner (§16)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.teal, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'المواقيت المكانية المحددة شرعاً للإحرام لمن مرّ بها أو حاذاها براً أو بحراً أو جواً.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // Closest Miqat Section if location available (§17)
          if (_closestMiqats != null && _closestMiqats!.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.near_me, color: Colors.amber, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'أقرب ميقات لموقعك الجغرافي الحالي:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_closestMiqats!.first.miqat.nameArabic} (يبعد عنك تقريباً ${_closestMiqats!.first.distanceKm.toInt()} كم)',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal),
                  ),
                ],
              ),
            ),
          ],

          if (miqats.isEmpty)
            const Center(child: Text('لا توجد بيانات مواقيت محملة.'))
          else
            ...miqats.map((m) {
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              m.nameArabic,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text('${m.distanceFromMakkahKm.toInt()} كم عن مكة'),
                            backgroundColor: Colors.teal.shade50,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'الاسم التاريخي: ${m.historicalName} • المعاصر: ${m.modernName}',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ميقات أهل: ${m.designatedFor}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.teal),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'الإقليم: ${m.region} (الإحداثيات: ${m.latitude.toStringAsFixed(3)}, ${m.longitude.toStringAsFixed(3)})',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
