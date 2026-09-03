import 'package:flutter/material.dart';
import '../../../modules/seerah/seerah_module.dart';
import 'event_detail_screen.dart';
import 'widgets/event_card.dart';

/// Screen presenting the complete chronological timeline across periods (§20, §36).
class TimelineScreen extends StatelessWidget {
  final SeerahModule module;

  const TimelineScreen({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    final slicesRes = module.getSequencedTimeline();
    final slices = slicesRes.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('المخطط الزمني للسيرة النبوية'),
        centerTitle: true,
      ),
      body: slices.isEmpty
          ? const Center(child: Text('لا توجد أحداث زمنية مسجلة'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: slices.length,
              itemBuilder: (context, index) {
                final slice = slices[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period Header
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F5132),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              slice.period.titleArabic,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${slice.period.startYearDisplay} — ${slice.period.endYearDisplay}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (slice.events.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('لا توجد أحداث مسجلة لهذه الفترة', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      )
                    else
                      ...slice.events.map(
                        (event) => EventCard(
                          event: event,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EventDetailScreen(
                                  event: event,
                                  module: module,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }
}
