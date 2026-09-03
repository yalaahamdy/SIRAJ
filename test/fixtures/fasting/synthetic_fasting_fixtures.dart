import 'package:siraj/modules/fasting/domain/fasting_day_record.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/domain/hijri_date.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';

/// Synthetic fixture factory for Fasting tests (§34).
class SyntheticFastingFixtures {
  static FastingDayRecord createDayRecord({
    String id = 'record_001',
    DateTime? date,
    HijriDate? hijriDate,
    FastingType type = FastingType.ramadan,
    FastingStatus status = FastingStatus.fasted,
    DateTime? fastStartTime,
    DateTime? fastEndTime,
    String? note,
  }) {
    final d = date ?? DateTime.utc(2026, 3, 15);
    return FastingDayRecord(
      recordId: id,
      date: d,
      hijriDate: hijriDate ?? const HijriDate(year: 1447, month: 9, day: 25),
      type: type,
      status: status,
      fastStartTime: fastStartTime ?? d.add(const Duration(hours: 4, minutes: 45)),
      fastEndTime: fastEndTime ?? d.add(const Duration(hours: 18, minutes: 15)),
      note: note,
      createdAt: d,
    );
  }

  static QadaPlan createQadaPlan({
    int totalDays = 7,
    int completedDays = 2,
    DateTime? targetDate,
    List<int> preferredWeekdays = const [1, 4],
  }) {
    return QadaPlan(
      totalDays: totalDays,
      completedDays: completedDays,
      targetDate: targetDate ?? DateTime.utc(2027, 2, 1),
      preferredWeekdays: preferredWeekdays,
      updatedAt: DateTime.utc(2026, 8, 31),
    );
  }
}
