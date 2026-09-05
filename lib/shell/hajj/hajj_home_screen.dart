import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/hajj_user_progress.dart';
import '../../../modules/hajj/domain/journey_type.dart';
import '../../../modules/hajj/hajj_module.dart';
import 'journey_dashboard_screen.dart';
import 'miqat_guide_screen.dart';
import 'preparation_checklist_screen.dart';
import 'sacred_locations_screen.dart';

/// Hajj & Umrah Experience Hub Screen (§3, §4, §5, §107).
class HajjHomeScreen extends StatefulWidget {
  final HajjModule module;

  const HajjHomeScreen({super.key, required this.module});

  @override
  State<HajjHomeScreen> createState() => _HajjHomeScreenState();
}

class _HajjHomeScreenState extends State<HajjHomeScreen> {
  HajjUserProgress _progress = const HajjUserProgress();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final res = await widget.module.getUserProgress();
    if (mounted) {
      setState(() {
        if (res.isSuccess) {
          _progress = res.valueOrNull!;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmResetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة ضبط بيانات الحج والعمرة'),
        content: const Text(
          'هل أنت متأكد من رغبتك في إعادة ضبط وحذف كافة خطوات النسك وقائمة الاستعداد المحلية؟ لن يؤثر هذا على أي وحدات أخرى.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('إعادة الضبط', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.module.resetAllUserData();
      await _loadProgress();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إعادة ضبط بيانات النسك بنجاح.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final hasActiveJourney = _progress.completedStepIds.isNotEmpty ||
        _progress.journeyState != JourneyState.notStarted;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            'الحج والعمرة — دليل ومناسك النسك',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة ضبط بيانات النسك',
            onPressed: _confirmResetData,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero header banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.teal.shade700],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'رحلة الحج والعمرة الميسرة',
                    style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'إرشاد خطوة بخطوة بالترتيب الشرعي الموثق والمواقيت والمشاعر دون فتاوى أو أحكام قطعية.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Continue Journey Card if active (§3, §79, §81)
          if (hasActiveJourney) ...[
            Card(
              color: Colors.amber.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.amber.shade400, width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.amber.shade800,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.directions_walk),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'متابعة رحلة النسك الحالية',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_progress.activeJourneyType.labelArabic} • تم إنجاز ${_progress.completedStepIds.length} خطوة',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5132),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JourneyDashboardScreen(
                              module: widget.module,
                              journeyType: _progress.activeJourneyType,
                            ),
                          ),
                        );
                        _loadProgress();
                      },
                      child: const Text('متابعة'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          const Text(
            'اختر نوع النسك والرحلة (§6, §12):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildJourneyCard(
            context,
            type: JourneyType.umrah,
            title: 'مناسك العمرة المفردة',
            subtitle: 'الإحرام، الطواف، السعي، والحلق أو التقصير',
            icon: Icons.brightness_5,
            color: Colors.teal,
          ),

          _buildJourneyCard(
            context,
            type: JourneyType.hajjTamattu,
            title: 'حج التمتع (الأفضل للآفاقي)',
            subtitle: 'عمرة كاملة في أشهر الحج ثم التحلل، والإحرام بالحج في 8 ذي الحجة',
            icon: Icons.mosque,
            color: Colors.indigo,
          ),

          _buildJourneyCard(
            context,
            type: JourneyType.hajjQiran,
            title: 'حج القِران',
            subtitle: 'الإحرام بالعمرة والحج معاً في نية واحدة دون تحلل بينهما',
            icon: Icons.all_inclusive,
            color: Colors.brown,
          ),

          _buildJourneyCard(
            context,
            type: JourneyType.hajjIfrad,
            title: 'حج الإفراد',
            subtitle: 'الإحرام بالحج فقط من الميقات، ولا يلزم هدي',
            icon: Icons.person_outline,
            color: Colors.blueGrey,
          ),

          const SizedBox(height: 16),

          const Text(
            'دليل الاستعداد والمعالم:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.checklist, color: Colors.white)),
            title: const Text('حقيبة واستعداد الحاج والمعتمر', maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: const Text('قائمة التجهيز والمستلزمات الشخصية والوثائق', maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PreparationChecklistScreen(module: widget.module)),
              );
            },
          ),

          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.map, color: Colors.white)),
            title: const Text('دليل المواقيت المكانية الخمسة', maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: const Text('ذو الحليفة، الجحفة، قرن المنازل، يلملم، ذات عرق', maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MiqatGuideScreen(module: widget.module)),
              );
            },
          ),

          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.location_city, color: Colors.white)),
            title: const Text('المشاعر والمواقع المقدسة', maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: const Text('الحرم، منى، عرفات، مزدلفة، الجمرات', maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SacredLocationsScreen(module: widget.module)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(
    BuildContext context, {
    required JourneyType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JourneyDashboardScreen(module: widget.module, journeyType: type),
            ),
          );
          _loadProgress();
        },
      ),
    );
  }
}
