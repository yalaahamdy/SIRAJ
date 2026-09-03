import 'package:flutter/material.dart';
import '../../../modules/fasting/domain/fasting_schedule_day.dart';
import '../../../modules/fasting/domain/fasting_status.dart';

/// Hero Card showing current Hijri date, Suhoor/Iftar countdown, and fast toggle (§40).
class TodayFastingHeroCard extends StatelessWidget {
  final FastingScheduleDay schedule;
  final FastingStatus? currentStatus;
  final VoidCallback onToggleFast;

  const TodayFastingHeroCard({
    super.key,
    required this.schedule,
    this.currentStatus,
    required this.onToggleFast,
  });

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '$hours س $minutes د';
  }

  @override
  Widget build(BuildContext context) {
    final isFasted = currentStatus == FastingStatus.fasted;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF0F5132), // Islamic Emerald Green
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hijri & Ramadan Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    schedule.hijriDate.formatArabic(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (schedule.isRamadan && schedule.ramadanDayNumber != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37), // Gold
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'اليوم ${schedule.ramadanDayNumber} من رمضان',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Next Boundary & Countdown
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_filled, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.nextBoundaryLabel,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatTime(schedule.nextBoundaryTime)} (متبقي ${_formatDuration(schedule.remainingToNextBoundary)})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Suhoor vs Iftar Timings Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الإمساك / السحور', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(
                        _formatTime(schedule.suhoorImsakTime),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('أذان الفجر', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(
                        _formatTime(schedule.fastStartTime),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('موعد الإفطار', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(
                        _formatTime(schedule.fastEndTime),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Action Button: Mark Fasted
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFasted ? Colors.white : const Color(0xFFD4AF37),
                  foregroundColor: isFasted ? const Color(0xFF0F5132) : Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onToggleFast,
                icon: Icon(isFasted ? Icons.check_circle : Icons.bookmark_add),
                label: Text(
                  isFasted ? 'تم تسجيل صيام اليوم بنجاح' : 'تسجيل صيام اليوم',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
