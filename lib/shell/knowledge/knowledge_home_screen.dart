import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import 'fiqh_topic_screen.dart';
import 'hadith_detail_screen.dart';
import 'knowledge_search_screen.dart';
import 'widgets/fiqh_topic_tile.dart';
import 'widgets/hadith_card.dart';

/// Main Home Screen for Islamic Knowledge & Hadith Foundation (§3, §45).
class KnowledgeHomeScreen extends StatefulWidget {
  final KnowledgeModule module;

  const KnowledgeHomeScreen({
    super.key,
    required this.module,
  });

  @override
  State<KnowledgeHomeScreen> createState() => _KnowledgeHomeScreenState();
}

class _KnowledgeHomeScreenState extends State<KnowledgeHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HadithEntity> _hadiths = [];
  List<FiqhTopic> _fiqhTopics = [];
  List<SourceRecord> _sources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadKnowledgeData();
  }

  void _loadKnowledgeData() {
    setState(() => _isLoading = true);

    final allHadithsRes = widget.module.store.getAllHadiths();
    final fiqhRes = widget.module.fiqhService.getAllTopics();
    final sourcesRes = widget.module.sourceRegistryService.getAllSources();

    setState(() {
      _hadiths = allHadithsRes.valueOrNull ?? [];
      _fiqhTopics = fiqhRes.valueOrNull ?? [];
      _sources = sourcesRes.valueOrNull ?? [];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المعرفة والحديث الشريف'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'البحث المعرفي',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => KnowledgeSearchScreen(module: widget.module),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الحديث النبوي'),
            Tab(text: 'الفقه المقارن'),
            Tab(text: 'المصادر المعتمدة'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // 1. Hadith Tab
                _hadiths.isEmpty
                    ? const Center(child: Text('لا توجد أحاديث مسجلة في الحزمة', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _hadiths.length,
                        itemBuilder: (context, index) {
                          final h = _hadiths[index];
                          return HadithCard(
                            hadith: h,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HadithDetailScreen(
                                    hadith: h,
                                    module: widget.module,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                // 2. Fiqh Tab
                _fiqhTopics.isEmpty
                    ? const Center(child: Text('لا توجد مسائل فقهية مسجلة', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _fiqhTopics.length,
                        itemBuilder: (context, index) {
                          final t = _fiqhTopics[index];
                          return FiqhTopicTile(
                            topic: t,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FiqhTopicScreen(
                                    topic: t,
                                    module: widget.module,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                // 3. Sources Tab
                _sources.isEmpty
                    ? const Center(child: Text('لا توجد مصادر مسجلة', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _sources.length,
                        itemBuilder: (context, index) {
                          final s = _sources[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: const Icon(Icons.menu_book, color: Color(0xFF0F5132)),
                              title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Text('${s.author} • ${s.sourceType.labelArabic}', style: const TextStyle(fontSize: 12)),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  s.reviewState,
                                  style: TextStyle(fontSize: 10, color: Colors.green.shade800, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}
