import 'package:flutter/material.dart';
import '../../../modules/learning/domain/learning_path.dart';
import '../../../modules/learning/engine/learning_mastery_engine.dart';
import '../../../modules/learning/learning_module.dart';
import 'learning_goals_screen.dart';
import 'learning_path_screen.dart';
import 'widgets/learning_progress_card.dart';

/// Main Home Screen for Islamic Learning & Education Engine (§4, §26, §45).
class LearningHomeScreen extends StatefulWidget {
  final LearningModule module;

  const LearningHomeScreen({
    super.key,
    required this.module,
  });

  @override
  State<LearningHomeScreen> createState() => _LearningHomeScreenState();
}

class _LearningHomeScreenState extends State<LearningHomeScreen> {
  List<LearningPath> _paths = [];
  LearningMasterySnapshot? _mastery;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final pathsRes = widget.module.getAllPaths();
    final masteryRes = await widget.module.computeMastery();

    if (mounted) {
      setState(() {
        _paths = pathsRes.valueOrNull ?? [];
        _mastery = masteryRes.valueOrNull;
        _isLoading = false;
      });
    }
  }

  void _openPath(LearningPath path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LearningPathScreen(
          path: path,
          module: widget.module,
        ),
      ),
    ).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('المنصة التعليمية والمناهج'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'أهدافي التعليمية',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LearningGoalsScreen(module: widget.module),
                ),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Hero Progress Card
                  if (_mastery != null) ...[
                    LearningProgressCard(snapshot: _mastery!),
                    const SizedBox(height: 20),
                  ],

                  // 2. Paths Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'المسارات التعليمية المعتمدة',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${_paths.length} مسارات',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 3. Paths List
                  if (_paths.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'لا توجد مسارات مسجلة في الحزمة التعليمية حالياً',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._paths.map((p) => _buildPathCard(p)),
                ],
              ),
            ),
    );
  }

  Widget _buildPathCard(LearningPath path) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openPath(path),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5132).withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      path.level.labelArabic,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5132),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${path.courseIds.length} مقررات منهجية',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                path.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                path.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'المجال: ${path.category}',
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade700, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'عرض المقررات',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F5132),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF0F5132)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
