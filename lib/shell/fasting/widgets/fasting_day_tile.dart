import 'package:flutter/material.dart';
import '../../../modules/fasting/domain/fasting_day_record.dart';
import '../../../modules/fasting/domain/fasting_status.dart';

/// List Tile representing a recorded fasting day in history or calendar (§40).
class FastingDayTile extends StatelessWidget {
  final FastingDayRecord record;

  const FastingDayTile({
    super.key,
    required this.record,
  });

  Color _getStatusColor() {
    switch (record.status) {
      case FastingStatus.fasted:
        return const Color(0xFF0F5132); // Emerald
      case FastingStatus.planned:
        return Colors.blueGrey;
      case FastingStatus.notFasted:
      case FastingStatus.missed:
        return Colors.amber.shade800;
      case FastingStatus.interrupted:
        return Colors.orange;
      case FastingStatus.unknown:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = record.date.toIso8601String().substring(0, 10);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(),
          foregroundColor: Colors.white,
          child: Icon(
            record.status == FastingStatus.fasted ? Icons.check : Icons.calendar_today,
            size: 18,
          ),
        ),
        title: Text(
          record.hijriDate.formatArabic(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '$dateStr • ${record.type.labelArabic}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor().withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            record.status.labelArabic,
            style: TextStyle(
              color: _getStatusColor(),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
