import 'package:flutter/material.dart';
import '../../../modules/seerah/seerah_module.dart';
import '../theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'المخطط الزمني للسيرة النبوية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        centerTitle: true,
      ),
      body: slices.isEmpty
          ? Center(
              child: Text(
                'لا توجد أحداث زمنية مسجلة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: slices.length,
              itemBuilder: (context, index) {
                final slice = slices[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period Header
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F5132),
                        border: isDark ? Border.all(color: AppColors.borderDark) : null,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 30 : 25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.history_edu,
                            color: isDark ? AppColors.goldAccentLight : Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              slice.period.titleArabic,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.goldAccentLight.withAlpha(30)
                                  : Colors.white.withAlpha(40),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${slice.period.startYearDisplay} — ${slice.period.endYearDisplay}',
                              style: TextStyle(
                                color: isDark ? AppColors.goldAccentLight : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (slice.events.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'لا توجد أحداث مسجلة لهذه الفترة',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
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
