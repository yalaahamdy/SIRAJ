import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_grading.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import 'fiqh_topic_screen.dart';
import 'hadith_detail_screen.dart';

/// Screen providing provenance-preserving interactive search with smart filters (§19, §28).
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

  String _selectedType = 'all'; // 'all', 'hadith', 'fiqh'
  String? _selectedCollectionId;
  HadithGrade? _selectedGrade;
  List<SourceRecord> _collections = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _loadCollections();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _executeSearch();
    }
  }

  void _loadCollections() {
    final colRes = widget.module.hadithService.getHadithCollections();
    if (colRes.isSuccess) {
      setState(() => _collections = colRes.valueOrNull ?? []);
    }
  }

  void _executeSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    final filter = KnowledgeSearchFilter(
      contentType: _selectedType,
      collectionId: _selectedCollectionId,
      grade: _selectedGrade,
    );

    final res = widget.module.search(query, filter);
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
    final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث في المعرفة والحديث'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث في المتون، الأسانيد، المسائل الفقهية...',
                hintStyle: TextStyle(color: textSecondary),
                prefixIcon: Icon(Icons.search, color: primaryAccent),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          _executeSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF152019) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cardBorder, width: 1.1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cardBorder, width: 1.1),
                ),
              ),
              style: TextStyle(color: textPrimary),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _executeSearch(),
              onChanged: (_) => _executeSearch(),
            ),
          ),

          // 2. Filter Chips (Type, Collection, Grade)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                // Type Filter: الكل
                ChoiceChip(
                  label: const Text('الكل'),
                  selected: _selectedType == 'all',
                  onSelected: (val) {
                    if (val) {
                      setState(() => _selectedType = 'all');
                      _executeSearch();
                    }
                  },
                ),
                const SizedBox(width: 6),
                // Type Filter: أحاديث
                ChoiceChip(
                  label: const Text('أحاديث نبوية'),
                  selected: _selectedType == 'hadith',
                  onSelected: (val) {
                    setState(() => _selectedType = val ? 'hadith' : 'all');
                    _executeSearch();
                  },
                ),
                const SizedBox(width: 6),
                // Type Filter: فقه مقارن
                ChoiceChip(
                  label: const Text('مسائل فقهية'),
                  selected: _selectedType == 'fiqh',
                  onSelected: (val) {
                    setState(() => _selectedType = val ? 'fiqh' : 'all');
                    _executeSearch();
                  },
                ),
                if (_selectedType != 'fiqh') ...[
                  const SizedBox(width: 8),
                  // Grade Filter: صحيح فقط
                  FilterChip(
                    label: const Text('صحيح فقط'),
                    selected: _selectedGrade == HadithGrade.sahih,
                    onSelected: (val) {
                      setState(() => _selectedGrade = val ? HadithGrade.sahih : null);
                      _executeSearch();
                    },
                  ),
                  const SizedBox(width: 8),
                  // Collections Dropdown
                  if (_collections.isNotEmpty)
                    DropdownButton<String?>(
                      value: _selectedCollectionId,
                      hint: Text('كل كتب السنة', style: TextStyle(fontSize: 12, color: textSecondary)),
                      dropdownColor: cardBg,
                      style: TextStyle(fontSize: 12, color: textPrimary, fontWeight: FontWeight.bold),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text('كل كتب السنة', style: TextStyle(fontSize: 12, color: textPrimary)),
                        ),
                        ..._collections.map(
                          (c) => DropdownMenuItem(
                            value: c.sourceId,
                            child: Text(c.title.split('(').first.trim(), style: TextStyle(fontSize: 12, color: textPrimary)),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedCollectionId = val);
                        _executeSearch();
                      },
                    ),
                ],
              ],
            ),
          ),

          // 3. Results Count
          if (_hasSearched)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تم العثور على ${_results.length} نتيجة موثقة',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: primaryAccent),
                  ),
                ],
              ),
            ),

          // 4. Results List
          Expanded(
            child: !_hasSearched
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.manage_search, size: 64, color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                        const SizedBox(height: 12),
                        Text(
                          'اكتب كلمة للبحث في متون الأحاديث أو المسائل الفقهية',
                          style: TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 56, color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            const SizedBox(height: 12),
                            Text(
                              'لم يتم العثور على نتائج تطابق بحثك',
                              style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'جرب كلمات أخرى أو قم بإلغاء بعض الفلاتر',
                              style: TextStyle(color: textSecondary, fontSize: 12.5, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _results.length,
                        itemBuilder: (ctx, idx) {
                          final res = _results[idx];
                          final isHadith = res.contentType == 'hadith';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cardBorder, width: 1.1),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _openResult(res),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: isHadith
                                                  ? (isDark ? const Color(0xFF142E1F) : const Color(0xFFE8F5E9))
                                                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF)),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: isHadith
                                                    ? (isDark ? const Color(0xFF22543D) : const Color(0xFFA5D6A7))
                                                    : (isDark ? const Color(0xFF3B82F6) : const Color(0xFF93C5FD)),
                                              ),
                                            ),
                                            child: Text(
                                              isHadith ? 'حديث نبوي' : 'مسألة فقهية',
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                                color: isHadith ? primaryAccent : const Color(0xFF2563EB),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            res.sourceTitle,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        res.title,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textPrimary),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        res.snippet,
                                        style: TextStyle(fontSize: 13.5, height: 1.6, fontWeight: FontWeight.w500, color: textSecondary),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (res.attributionDetails != null) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          res.attributionDetails!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
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
