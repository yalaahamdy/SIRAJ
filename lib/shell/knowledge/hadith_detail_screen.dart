import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/knowledge_relation.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import 'fiqh_topic_screen.dart';
import 'widgets/provenance_badge.dart';

/// Professional, rich Hadith Detail Screen with interactive Isnad, multi-gradings,
/// commentaries, local bookmarks/notes, and knowledge graph links (§9, §45).
class HadithDetailScreen extends StatefulWidget {
  final HadithEntity hadith;
  final KnowledgeModule module;

  const HadithDetailScreen({
    super.key,
    required this.hadith,
    required this.module,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  bool _isBookmarked = false;
  String? _userNote;
  SourceRecord? _sourceRecord;
  List<KnowledgeRelation> _relations = [];
  bool _isIsnadExpanded = false;
  double _fontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _loadMetadataAndUserProgress();
  }

  Future<void> _loadMetadataAndUserProgress() async {
    // 1. Load source record
    final srcRes = widget.module.getSource(widget.hadith.sourceId);
    if (srcRes.isSuccess) {
      _sourceRecord = srcRes.valueOrNull;
    }

    // 2. Load relations
    final relsRes = widget.module.graphService.getRelationsFor(widget.hadith.hadithId);
    if (relsRes.isSuccess) {
      _relations = relsRes.valueOrNull ?? [];
    }

    // 3. Load user progress
    final progRes = await widget.module.getUserProgress();
    if (progRes.isSuccess && progRes.valueOrNull != null) {
      final prog = progRes.valueOrNull!;
      if (mounted) {
        setState(() {
          _isBookmarked = prog.bookmarkedItemIds.contains(widget.hadith.hadithId);
          _userNote = prog.userNotes[widget.hadith.hadithId];
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    final res = await widget.module.toggleBookmark(widget.hadith.hadithId);
    if (res.isSuccess) {
      setState(() => _isBookmarked = !_isBookmarked);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isBookmarked ? 'تمت إضافة الحديث إلى المفضلة' : 'تمت إزالة الحديث من المفضلة'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _openNoteDialog() {
    final controller = TextEditingController(text: _userNote ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تدوين ملاحظة على الحديث'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'اكتب فائدتك أو تدبرك في هذا الحديث الشريف...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newNote = controller.text.trim();
              await widget.module.saveNote(widget.hadith.hadithId, newNote);
              setState(() => _userNote = newNote.isEmpty ? null : newNote);
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حفظ الملاحظة بنجاح')),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _shareHadith() {
    final sourceName = _sourceRecord?.title ?? widget.hadith.bookName;
    final primaryGrade = widget.hadith.gradings.isNotEmpty
        ? ' [${widget.hadith.gradings.first.grade.labelArabic} - ${widget.hadith.gradings.first.scholarName}]'
        : '';

    final shareText = '''
«${widget.hadith.arabicMatn}»

📚 $sourceName · ${widget.hadith.bookName} · رقم الحديث: ${widget.hadith.primaryNumber}$primaryGrade
تطبيق سِراج (SIRAJ) — المنظومة الإسلامية
''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الحديث وتخريجه إلى الحافظة بنجاح'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _copyMatnOnly() {
    Clipboard.setData(ClipboardData(text: widget.hadith.arabicMatn));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ المتن الشريف إلى الحافظة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
    final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    final sourceTitle = _sourceRecord?.title ?? 'كتب السنة المعتمدة';

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            '${widget.hadith.bookName} — حديث ${widget.hadith.primaryNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? const Color(0xFFD4AF37) : null,
            ),
            tooltip: _isBookmarked ? 'إزالة من المفضلة' : 'حفظ في المفضلة',
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: Icon(
              _userNote != null && _userNote!.isNotEmpty ? Icons.note_alt : Icons.note_alt_outlined,
              color: _userNote != null && _userNote!.isNotEmpty ? const Color(0xFF10B981) : null,
            ),
            tooltip: 'تدوين ملاحظة',
            onPressed: _openNoteDialog,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'مشاركة الحديث وتخريجه',
            onPressed: _shareHadith,
          ),
        ],
      ),
      body: ListView(
        cacheExtent: 4000,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Breadcrumb Location Path
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF152019) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? const Color(0xFF26382D) : const Color(0xFFCBD5E1), width: 1.1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.menu_book, size: 16, color: primaryAccent),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$sourceTitle ← ${widget.hadith.bookName}${widget.hadith.chapterName != null ? ' ← ${widget.hadith.chapterName}' : ''}',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Canonical Matn Card with Font Scaling & High Contrast
          Card(
            elevation: 2,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: cardBorder, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: primaryAccent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'المتن العربي الأصيل',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryAccent,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.text_decrease, size: 18),
                            tooltip: 'تصغير الخط',
                            onPressed: () => setState(() => _fontSize = (_fontSize - 1).clamp(16.0, 32.0)),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                          IconButton(
                            icon: const Icon(Icons.text_increase, size: 18),
                            tooltip: 'تكبير الخط',
                            onPressed: () => setState(() => _fontSize = (_fontSize + 1).clamp(16.0, 32.0)),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: 'نسخ المتن',
                            onPressed: _copyMatnOnly,
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF142E1F) : const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isDark ? const Color(0xFF22543D) : const Color(0xFFA5D6A7)),
                            ),
                            child: Text(
                              'رقم ${widget.hadith.primaryNumber}',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: primaryAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    widget.hadith.arabicMatn,
                    style: TextStyle(
                      fontSize: _fontSize,
                      height: 2.05,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Amiri',
                      color: textPrimary,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 3. Interactive Isnad Section
          if (widget.hadith.isnad != null && widget.hadith.isnad!.isNotEmpty) ...[
            Card(
              elevation: 1.5,
              color: cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: cardBorder, width: 1.1),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: _isIsnadExpanded,
                  onExpansionChanged: (val) => setState(() => _isIsnadExpanded = val),
                  leading: const Icon(Icons.account_tree_outlined, color: Color(0xFFD97706), size: 22),
                  title: Text(
                    'سلسلة الإسناد والرواة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textPrimary),
                  ),
                  subtitle: Text(
                    _isIsnadExpanded ? 'انقر للطي' : 'عرض مسار السند والرواية المتصلة',
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF142017) : const Color(0xFFFDFBF7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF2A3D2D) : const Color(0xFFDCD6BE),
                            width: 1.1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hadith.isnad!,
                              style: TextStyle(
                                fontSize: 14.5,
                                height: 1.85,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.verified_user_outlined, size: 15, color: primaryAccent),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'سلسلة رواة محققة ومعتمدة من أمهات كتب السنة المعتمدة.',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 4. Gradings & Takhrij Section
          Card(
            elevation: 1.5,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: cardBorder, width: 1.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_outlined, color: primaryAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'درجة الحديث والتخريج المعتمد',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  if (widget.hadith.gradings.isEmpty)
                    Text('لم تسجل أحكام خاصة على هذا الحديث بعد', style: TextStyle(color: textSecondary, fontSize: 13))
                  else
                    ...widget.hadith.gradings.map(
                      (g) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF162219) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isDark ? const Color(0xFF26382D) : const Color(0xFFCBD5E1), width: 1.1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProvenanceBadge(grade: g.grade),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g.scholarName,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textPrimary),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'المصدر: ${g.sourceBook}${g.context != null ? ' — ${g.context}' : ''}',
                                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.hadith.internationalNumber != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'الترقيم العالمي المقارن: ${widget.hadith.internationalNumber}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 5. Commentaries & Benefits Section
          if (widget.hadith.commentaries.isNotEmpty) ...[
            Card(
              elevation: 1.5,
              color: cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: cardBorder, width: 1.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Color(0xFFD97706), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'الشروح والفوائد العلمية المنسوبة',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    ...widget.hadith.commentaries.map(
                      (c) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1C271E) : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF3B381A) : const Color(0xFFFDE68A),
                            width: 1.1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'قول: ${c.scholarName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.quote,
                              style: TextStyle(fontSize: 14, height: 1.75, fontWeight: FontWeight.w500, color: textPrimary),
                            ),
                            if (c.pageReference != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                'المرجع: ${c.pageReference}',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 6. User Note Preview Card
          if (_userNote != null && _userNote!.isNotEmpty) ...[
            Card(
              color: isDark ? const Color(0xFF142E1F) : const Color(0xFFF0FDF4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? const Color(0xFF22543D) : const Color(0xFFA5D6A7), width: 1.1),
              ),
              child: ListTile(
                leading: const Icon(Icons.sticky_note_2, color: Color(0xFF10B981)),
                title: Text('ملاحظتك الشخصية المحفوظة محلياً', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: primaryAccent)),
                subtitle: Text(_userNote!, style: TextStyle(fontSize: 13.5, color: textPrimary)),
                trailing: IconButton(
                  icon: Icon(Icons.edit, size: 18, color: primaryAccent),
                  onPressed: _openNoteDialog,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 7. Knowledge Graph Links (Related Fiqh Topics)
          if (_relations.isNotEmpty) ...[
            Card(
              elevation: 1.5,
              color: cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: cardBorder, width: 1.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.hub_outlined, color: Color(0xFF2563EB), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'المسائل والأبواب المرتبطة بهذا الحديث',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: textPrimary),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    ..._relations.map((rel) {
                      final targetKey = rel.sourceKey == widget.hadith.hadithId ? rel.targetKey : rel.sourceKey;
                      final fiqhRes = widget.module.getFiqhTopic(targetKey);
                      if (fiqhRes.isSuccess) {
                        final topic = fiqhRes.valueOrNull!;
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.gavel, size: 18, color: Color(0xFF2563EB)),
                          title: Text(topic.title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: textPrimary)),
                          subtitle: Text(rel.description ?? topic.category, style: TextStyle(fontSize: 12, color: textSecondary)),
                          trailing: const Icon(Icons.chevron_left, size: 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FiqhTopicScreen(topic: topic, module: widget.module),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 8. Provenance & Fail-Closed Integrity Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF152019) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? const Color(0xFF26382D) : const Color(0xFFCBD5E1), width: 1.1),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 16, color: primaryAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'المتن والإسناد موثقان ومحميان ببصمة تجزئة مشفرة SHA-256 (Fail-Closed).',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
