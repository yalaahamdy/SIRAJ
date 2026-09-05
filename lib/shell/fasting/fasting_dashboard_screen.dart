import 'package:flutter/material.dart';
import '../../../core/location/location_models.dart';
import '../../../modules/fasting/domain/fasting_day_record.dart';
import '../../../modules/fasting/domain/fasting_schedule_day.dart';
import '../../../modules/fasting/domain/fasting_status.dart';
import '../../../modules/fasting/domain/fasting_type.dart';
import '../../../modules/fasting/domain/qada_plan.dart';
import '../../../modules/fasting/fasting_module.dart';
import '../../../modules/prayer/domain/calculation_parameters.dart';
import '../../../modules/fasting/domain/fasting_guide_topic.dart';
import '../theme/app_colors.dart';
import 'fasting_calendar_screen.dart';
import 'fasting_settings_screen.dart';
import 'fasting_topic_detail_screen.dart';
import 'qada_planner_screen.dart';
import 'widgets/fasting_day_tile.dart';
import 'widgets/qada_balance_card.dart';
import 'widgets/today_fasting_hero_card.dart';

/// Main Dashboard Screen for Fasting & Ramadan Foundation (§13, §40).
class FastingDashboardScreen extends StatefulWidget {
  final FastingModule module;
  final GeoCoordinates? location;
  final CalculationParameters? calculationParameters;

  const FastingDashboardScreen({
    super.key,
    required this.module,
    this.location,
    this.calculationParameters,
  });

  @override
  State<FastingDashboardScreen> createState() => _FastingDashboardScreenState();
}

class _FastingDashboardScreenState extends State<FastingDashboardScreen> {
  FastingScheduleDay? _todaySchedule;
  List<FastingDayRecord> _recentRecords = [];
  QadaPlan? _qadaPlan;
  FastingDayRecord? _todayRecord;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    final loc = widget.location ?? const GeoCoordinates(latitude: 21.4225, longitude: 39.8262);
    final params = widget.calculationParameters ?? CalculationParameters.ummAlQura;

    final schedRes = await widget.module.getTodaySchedule(
      location: loc,
      calculationParameters: params,
    );

    final recordsRes = await widget.module.getDayRecords();
    final planRes = await widget.module.getQadaPlan();

    if (mounted) {
      final records = recordsRes.valueOrNull ?? [];
      final todayStr = DateTime.now().toUtc().toIso8601String().substring(0, 10);
      final todayMatch = records.where(
        (r) => r.date.toIso8601String().substring(0, 10) == todayStr,
      );

      setState(() {
        _todaySchedule = schedRes.valueOrNull;
        _recentRecords = records.reversed.take(5).toList();
        _qadaPlan = planRes.valueOrNull;
        _todayRecord = todayMatch.isEmpty ? null : todayMatch.first;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleTodayFast() async {
    final current = _todayRecord?.status;
    final newStatus = current == FastingStatus.fasted ? FastingStatus.notFasted : FastingStatus.fasted;
    final type = (_todaySchedule?.isRamadan ?? false) ? FastingType.ramadan : FastingType.voluntary;

    await widget.module.markTodayStatus(type: type, status: newStatus);
    await _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصيام ورمضان المبارك'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'تقويم الصيام',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FastingCalendarScreen(module: widget.module),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'الإعدادات والسياسات',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FastingSettingsScreen(module: widget.module),
                ),
              ).then((_) => _loadDashboardData());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Hero Fasting Card
                  if (_todaySchedule != null)
                    TodayFastingHeroCard(
                      schedule: _todaySchedule!,
                      currentStatus: _todayRecord?.status,
                      onToggleFast: _toggleTodayFast,
                    ),
                  const SizedBox(height: 16),

                  // 2. Qada Balance Card
                  if (_qadaPlan != null)
                    QadaBalanceCard(
                      plan: _qadaPlan!,
                      onManagePlan: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QadaPlannerScreen(module: widget.module),
                          ),
                        ).then((_) => _loadDashboardData());
                      },
                    ),
                  const SizedBox(height: 20),

                  // 3. Recent Fasting Records
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'سجل الأيام الأخيرة',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FastingCalendarScreen(module: widget.module),
                            ),
                          );
                        },
                        child: const Text('عرض الكل'),
                      ),
                    ],
                  ),
                  if (_recentRecords.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'لم يتم تسجيل أي أيام صيام بعد',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._recentRecords.map((r) => FastingDayTile(record: r)),

                  const SizedBox(height: 24),

                  // 4. Educational Guide Section (§11)
                  Row(
                    children: [
                      Icon(Icons.school_rounded, size: 20, color: AppColors.primaryAction(context)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'دليل الصائم والتفقه في أحكام الصيام',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...FastingGuideData.topics.map((t) => Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(Icons.menu_book_rounded, color: AppColors.primaryAction(context), size: 20),
                      ),
                      title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(t.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.chevron_left, size: 20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FastingTopicDetailScreen(topic: t)),
                        );
                      },
                    ),
                  )),
                ],
              ),
            ),
    );
  }
}
