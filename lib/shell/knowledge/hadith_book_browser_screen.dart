import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import '../../../modules/knowledge/domain/source_type.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import 'hadith_detail_screen.dart';
import 'widgets/hadith_card.dart';

/// Screen for browsing Sunnah collections, classical books, and chapters with dynamic counts (§7, §8).
class HadithBookBrowserScreen extends StatefulWidget {
  final KnowledgeModule module;
  final String? initialCollectionId;

  const HadithBookBrowserScreen({
    super.key,
    required this.module,
    this.initialCollectionId,
  });

  @override
  State<HadithBookBrowserScreen> createState() => _HadithBookBrowserScreenState();
}

class _HadithBookBrowserScreenState extends State<HadithBookBrowserScreen> {
  List<SourceRecord> _collections = [];
  String? _selectedCollectionId;
  List<Map<String, dynamic>> _books = [];
  int? _selectedBookNumber;
  String? _selectedBookName;
  List<HadithEntity> _bookHadiths = [];
  List<String> _chaptersInBook = [];
  String? _selectedChapterName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  void _loadCollections() {
    final colRes = widget.module.hadithService.getHadithCollections();
    if (colRes.isSuccess) {
      _collections = colRes.valueOrNull ?? [];
      final initialId = widget.initialCollectionId;
      if (initialId != null && _collections.any((c) => c.sourceId == initialId)) {
        _selectCollection(initialId);
      } else if (_collections.isNotEmpty) {
        _selectCollection(_collections.first.sourceId);
      } else {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _selectCollection(String collectionId) {
    setState(() {
      _selectedCollectionId = collectionId;
      _selectedBookNumber = null;
      _selectedBookName = null;
      _bookHadiths = [];
      _chaptersInBook = [];
      _selectedChapterName = null;
      _isLoading = true;
    });

    final booksRes = widget.module.hadithService.getBooksWithCounts(collectionId);
    setState(() {
      _books = booksRes.valueOrNull ?? [];
      _isLoading = false;
    });
  }

  void _selectBook(int bookNumber, String bookName) {
    if (_selectedCollectionId == null) return;
    final hadithsRes = widget.module.hadithService.getHadithsByBook(_selectedCollectionId!, bookNumber);
    final hadiths = hadithsRes.valueOrNull ?? [];
    final chapters = hadiths.map((h) => h.chapterName).whereType<String>().toSet().toList();
    setState(() {
      _selectedBookNumber = bookNumber;
      _selectedBookName = bookName;
      _bookHadiths = hadiths;
      _chaptersInBook = chapters;
      _selectedChapterName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    final selectedCol = _collections.firstWhere(
      (c) => c.sourceId == _selectedCollectionId,
      orElse: () => _collections.isNotEmpty
          ? _collections.first
          : SourceRecord.create(
              sourceId: '',
              title: '',
              author: '',
              editor: '',
              publisher: '',
              edition: '',
              year: 1400,
              sourceType: SourceType.hadithCollection,
              referenceScheme: '',
            ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('تصفح كتب السنة المشرفة'),
        centerTitle: true,
        leading: _selectedBookNumber != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _selectedBookNumber = null;
                  _selectedBookName = null;
                  _bookHadiths = [];
                }),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. Horizontal Collections Selector
                Container(
                  height: 56,
                  color: isDark ? const Color(0xFF141F18) : const Color(0xFFF1F5F9),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: _collections.length,
                    itemBuilder: (ctx, idx) {
                      final col = _collections[idx];
                      final isSelected = col.sourceId == _selectedCollectionId;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(col.title.split('(').first.trim()),
                          selected: isSelected,
                          selectedColor: isDark ? const Color(0xFF142E1F) : const Color(0xFF0F5132),
                          side: BorderSide(
                            color: isSelected
                                ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132))
                                : (isDark ? const Color(0xFF26382D) : const Color(0xFFCBD5E1)),
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12.5,
                          ),
                          onSelected: (_) => _selectCollection(col.sourceId),
                        ),
                      );
                    },
                  ),
                ),

                // 2. Collection Header Info
                if (_selectedCollectionId != null && _selectedBookNumber == null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF152019) : const Color(0xFFE8F5E9),
                      border: Border(
                        bottom: BorderSide(color: isDark ? const Color(0xFF26382D) : const Color(0xFFA5D6A7)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCol.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: primaryAccent),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'المؤلف: ${selectedCol.author} · ${selectedCol.edition}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                        ),
                      ],
                    ),
                  ),

                // 3. Book Sub-Header when a book is selected
                if (_selectedBookNumber != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1C271E) : const Color(0xFFFEF3C7),
                      border: Border(
                        bottom: BorderSide(color: isDark ? const Color(0xFF3B381A) : const Color(0xFFFDE68A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$_selectedBookName (كتاب رقم $_selectedBookNumber)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2E2616) : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: isDark ? const Color(0xFF5E491A) : const Color(0xFFF59E0B)),
                          ),
                          child: Text(
                            '${_bookHadiths.length} أحاديث',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // 4. Body: Either Books List or Hadiths in Selected Book
                Expanded(
                  child: _selectedBookNumber != null
                      ? _buildHadithsList()
                      : _buildBooksList(),
                ),
              ],
            ),
    );
  }

  Widget _buildBooksList() {
    if (_books.isEmpty) {
      return const Center(child: Text('لا توجد كتب مسجلة لهذه المجموعة'));
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
    final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _books.length,
      itemBuilder: (ctx, idx) {
        final b = _books[idx];
        final bookNum = b['bookNumber'] as int;
        final bookName = b['bookName'] as String;
        final count = b['hadithCount'] as int;
        final chapters = b['chapters'] as Set<String>;

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
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isDark ? const Color(0xFF142E1F) : const Color(0xFF0F5132),
              radius: 18,
              child: Text(
                '$bookNum',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              bookName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '$count أحاديث محققة${chapters.isNotEmpty ? ' · ${chapters.length} أبواب' : ''}',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(Icons.chevron_left, size: 20, color: primaryAccent),
            onTap: () => _selectBook(bookNum, bookName),
          ),
        );
      },
    );
  }

  Widget _buildHadithsList() {
    if (_bookHadiths.isEmpty) {
      return const Center(child: Text('لا توجد أحاديث مسجلة في هذا الكتاب'));
    }

    final displayedHadiths = _selectedChapterName == null
        ? _bookHadiths
        : _bookHadiths.where((h) => h.chapterName == _selectedChapterName).toList();

    return Column(
      children: [
        if (_chaptersInBook.length > 1)
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: FilterChip(
                    label: Text('كافة الأبواب (${_bookHadiths.length})'),
                    selected: _selectedChapterName == null,
                    onSelected: (_) => setState(() => _selectedChapterName = null),
                  ),
                ),
                ..._chaptersInBook.map((ch) {
                  final chCount = _bookHadiths.where((h) => h.chapterName == ch).length;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: FilterChip(
                      label: Text('$ch ($chCount)'),
                      selected: _selectedChapterName == ch,
                      onSelected: (_) => setState(() => _selectedChapterName = ch),
                    ),
                  );
                }),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: displayedHadiths.length,
            itemBuilder: (ctx, idx) {
              final hadith = displayedHadiths[idx];
              return HadithCard(
                hadith: hadith,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HadithDetailScreen(hadith: hadith, module: widget.module),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
