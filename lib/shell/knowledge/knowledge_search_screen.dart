import 'package:flutter/material.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import '../../../modules/knowledge/services/knowledge_search_service.dart';
import 'fiqh_topic_screen.dart';
import 'hadith_detail_screen.dart';

/// Screen providing provenance-preserving interactive search (§19, §28).
class KnowledgeSearchScreen extends StatefulWidget {
  final KnowledgeModule module;
  final String? initialQuery;

  const KnowledgeSearchScreen({
    super.key,
    required this.module,
    this.initialQuery,
  });

  @override
  State<KnowledgeSearchScreen> createState() => _KnowledgeSearchScreenState();
}

class _KnowledgeSearchScreenState extends State<KnowledgeSearchScreen> {
  late final TextEditingController _searchController;
  List<KnowledgeSearchResult> _results = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _onSearch(widget.initialQuery!);
    }
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    final res = widget.module.search(query);
    setState(() {
      _results = res.valueOrNull ?? [];
      _hasSearched = true;
    });
  }

  void _openResult(KnowledgeSearchResult result) {
    if (result.contentType == 'hadith') {
      final hadithRes = widget.module.getHadith(result.id);
      if (hadithRes.isSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HadithDetailScreen(
              hadith: hadithRes.valueOrNull!,
              module: widget.module,
            ),
          ),
        );
      }
    } else if (result.contentType == 'fiqh') {
      final topicRes = widget.module.getFiqhTopic(result.id);
      if (topicRes.isSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FiqhTopicScreen(
              topic: topicRes.valueOrNull!,
              module: widget.module,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث في المعرفة والحديث'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن حديث، مسألة فقهية، أو مصطلح...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _onSearch,
            ),
          ),

          // 2. Results List
          Expanded(
            child: !_hasSearched
                ? const Center(
                    child: Text(
                      'أدخل كلمة للبحث في الأحاديث والمسائل الفقهية الموثقة',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : _results.isEmpty
                    ? const Center(
                        child: Text(
                          'لم يتم العثور على نتائج مطابقة',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final r = _results[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                r.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    r.snippet,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${r.sourceTitle}${r.attributionDetails != null ? ' • ${r.attributionDetails}' : ''}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF0F5132), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () => _openResult(r),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
