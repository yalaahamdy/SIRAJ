import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import 'hadith_detail_screen.dart';
import 'widgets/hadith_card.dart';

/// Screen displaying locally bookmarked Hadiths and user notes in mod_knowledge (§33, §36).
class KnowledgeFavoritesScreen extends StatefulWidget {
  final KnowledgeModule module;

  const KnowledgeFavoritesScreen({super.key, required this.module});

  @override
  State<KnowledgeFavoritesScreen> createState() => _KnowledgeFavoritesScreenState();
}

class _KnowledgeFavoritesScreenState extends State<KnowledgeFavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HadithEntity> _bookmarkedHadiths = [];
  Map<String, String> _notes = {};
  List<HadithEntity> _notedHadiths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final progRes = await widget.module.getUserProgress();
    if (progRes.isSuccess && progRes.valueOrNull != null) {
      final prog = progRes.valueOrNull!;
      final bookmarks = <HadithEntity>[];
      final noted = <HadithEntity>[];

      for (final id in prog.bookmarkedItemIds) {
        final hRes = widget.module.getHadith(id);
        if (hRes.isSuccess) {
          bookmarks.add(hRes.valueOrNull!);
        }
      }

      for (final entry in prog.userNotes.entries) {
        final hRes = widget.module.getHadith(entry.key);
        if (hRes.isSuccess) {
          noted.add(hRes.valueOrNull!);
        }
      }

      if (mounted) {
        setState(() {
          _bookmarkedHadiths = bookmarks;
          _notes = prog.userNotes;
          _notedHadiths = noted;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة والملاحظات'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'المفضلة (${_bookmarkedHadiths.length})'),
            Tab(text: 'الملاحظات (${_notes.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Bookmarks
                _bookmarkedHadiths.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border, size: 56, color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            const SizedBox(height: 12),
                            Text(
                              'لم تقم بإضافة أي حديث إلى المفضلة بعد',
                              style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155), fontSize: 14.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _bookmarkedHadiths.length,
                        itemBuilder: (ctx, idx) {
                          final h = _bookmarkedHadiths[idx];
                          return HadithCard(
                            hadith: h,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HadithDetailScreen(hadith: h, module: widget.module),
                                ),
                              );
                              _loadData();
                            },
                          );
                        },
                      ),

                // Tab 2: User Notes
                _notedHadiths.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.note_alt_outlined, size: 56, color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد ملاحظات مسجلة على الأحاديث',
                              style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155), fontSize: 14.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notedHadiths.length,
                        itemBuilder: (ctx, idx) {
                          final h = _notedHadiths[idx];
                          final note = _notes[h.hadithId] ?? '';
                          final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
                          final cardBorder = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
                          final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
                          final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: cardBorder, width: 1.1),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${h.bookName} · حديث ${h.primaryNumber}',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryAccent),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward, size: 18, color: primaryAccent),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => HadithDetailScreen(hadith: h, module: widget.module),
                                            ),
                                          );
                                          _loadData();
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 16),
                                  Text(
                                    note,
                                    style: TextStyle(fontSize: 14.5, height: 1.6, fontWeight: FontWeight.w500, color: textPrimary),
                                  ),
                                ],
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
