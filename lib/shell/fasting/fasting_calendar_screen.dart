import 'package:flutter/material.dart';
import '../../../modules/fasting/domain/fasting_day_record.dart';
import '../../../modules/fasting/domain/hijri_date.dart';
import '../../../modules/fasting/fasting_module.dart';
import 'widgets/fasting_day_tile.dart';

/// Screen displaying the user's complete historical fasting calendar (§40).
class FastingCalendarScreen extends StatefulWidget {
  final FastingModule module;

  const FastingCalendarScreen({
    super.key,
    required this.module,
  });

  @override
  State<FastingCalendarScreen> createState() => _FastingCalendarScreenState();
}

class _FastingCalendarScreenState extends State<FastingCalendarScreen> {
  List<FastingDayRecord> _records = [];
  late HijriDate _currentHijriMonth;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final now = widget.module.clock.nowUtc();
    _currentHijriMonth = widget.module.calendarService.getHijriDate(now);
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    final res = await widget.module.getDayRecords();
    if (mounted) {
      setState(() {
        _records = res.valueOrNull ?? [];
        _isLoading = false;
      });
    }
  }

  void _previousMonth() {
    setState(() {
      var m = _currentHijriMonth.month - 1;
      var y = _currentHijriMonth.year;
      if (m < 1) {
        m = 12;
        y -= 1;
      }
      _currentHijriMonth = HijriDate(year: y, month: m, day: 1);
    });
  }

  void _nextMonth() {
    setState(() {
      var m = _currentHijriMonth.month + 1;
      var y = _currentHijriMonth.year;
      if (m > 12) {
        m = 1;
        y += 1;
      }
      _currentHijriMonth = HijriDate(year: y, month: m, day: 1);
    });
  }

  Future<void> _confirmDeleteRecord(FastingDayRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف سجل الصيام'),
        content: Text('هل تريد بالتأكيد حذف سجل صيام يوم ${record.hijriDate.formatArabic()}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.module.userDataStore.deleteDayRecord(record.recordId);
      await _loadRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRamadan = _currentHijriMonth.month == 9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل وتقويم الصيام'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Month Navigation Header
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          tooltip: 'الشهر السابق',
                          onPressed: _previousMonth,
                        ),
                        Column(
                          children: [
                            Text(
                              '${_currentHijriMonth.monthNameArabic} ${_currentHijriMonth.year}هـ',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            if (isRamadan)
                              const Text(
                                'شهر رمضان المبارك',
                                style: TextStyle(color: Color(0xFF0F5132), fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded),
                          tooltip: 'الشهر القادم',
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ),
                ),

                // Records Content
                Expanded(
                  child: _records.isEmpty
                      ? const Center(
                          child: Text(
                            'لا توجد أيام صيام مسجلة في السجل',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _records.length,
                          itemBuilder: (context, index) {
                            final record = _records[index];
                            return Dismissible(
                              key: Key(record.recordId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                color: Colors.red,
                                child: const Icon(Icons.delete_rounded, color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                await _confirmDeleteRecord(record);
                                return false;
                              },
                              child: FastingDayTile(record: record),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
