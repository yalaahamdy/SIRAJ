import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/seerah_event.dart';
import '../../../modules/seerah/seerah_module.dart';
import 'person_detail_screen.dart';
import 'place_detail_screen.dart';
import 'widgets/moral_lesson_card.dart';
import 'widgets/narrative_variant_box.dart';
import '../theme/app_colors.dart';

/// Screen presenting comprehensive event details, sources, variants, lessons, and references (§5, §12, §15, §36).
class EventDetailScreen extends StatefulWidget {
  final SeerahEvent event;
  final SeerahModule module;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.module,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _noteController = TextEditingController();
  bool _isBookmarked = false;
  bool _isLoading = true;
  double _fontSizeMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await widget.module.markEventViewed(widget.event.eventId);
    final progressRes = await widget.module.getUserProgress();
    if (progressRes.isSuccess && mounted) {
      final p = progressRes.valueOrNull!;
      setState(() {
        _isBookmarked = p.bookmarkedEventIds.contains(widget.event.eventId);
        _noteController.text = p.userNotes[widget.event.eventId] ?? '';
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBookmark() async {
    await widget.module.toggleBookmark(widget.event.eventId);
    setState(() => _isBookmarked = !_isBookmarked);
  }

  Future<void> _saveNote() async {
    await widget.module.saveUserNote(widget.event.eventId, _noteController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الملاحظة الشخصية بنجاح')),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);
    final dateColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final primaryAccent = isDark ? AppColors.goldAccentLight : const Color(0xFF0F5132);
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final cardBorder = isDark ? AppColors.borderDark : const Color(0xFF0F5132).withAlpha(45);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease, size: 20),
            tooltip: 'تصغير الخط',
            onPressed: _fontSizeMultiplier > 0.85
                ? () => setState(() => _fontSizeMultiplier = (_fontSizeMultiplier - 0.1).clamp(0.85, 1.45))
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.text_increase, size: 20),
            tooltip: 'تكبير الخط',
            onPressed: _fontSizeMultiplier < 1.45
                ? () => setState(() => _fontSizeMultiplier = (_fontSizeMultiplier + 0.1).clamp(0.85, 1.45))
                : null,
          ),
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? primaryAccent : null,
            ),
            tooltip: _isBookmarked ? 'إزالة من المحفوظات' : 'حفظ في المفضلة',
            onPressed: _isLoading ? null : _toggleBookmark,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        children: [
          // 1. Header Card: Evidence Level & Date & Title & Summary
          Card(
            elevation: isDark ? 1 : 2,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: cardBorder, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: primaryAccent.withAlpha(isDark ? 40 : 25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: primaryAccent.withAlpha(isDark ? 120 : 80),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            event.evidenceLevel.labelArabic,
                            style: TextStyle(
                              color: primaryAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_month, size: 14, color: primaryAccent),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                event.historicalDate.dateDisplay,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                  color: dateColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                      height: 1.3,
                    ),
                  ),
                  if (event.isOrderUncertain) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF78350F).withAlpha(50)
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFFFBBF24).withAlpha(120)
                              : Colors.orange.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 13,
                            color: isDark
                                ? const Color(0xFFFBBF24)
                                : Colors.orange.shade900,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'ترتيب مختلف فيه بين أئمة السير والمغازي',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? const Color(0xFFFBBF24)
                                    : Colors.orange.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      height: 1,
                      color: isDark ? AppColors.borderDark : null,
                    ),
                  ),
                  SelectableText(
                    event.summary,
                    style: TextStyle(
                      fontSize: 14.5 * _fontSizeMultiplier,
                      height: 1.8,
                      color: bodyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Participants & Location Chips
          if (event.participantIds.isNotEmpty || event.locationId != null) ...[
            Text(
              'المكان والمشاركون في الواقعة:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: titleColor),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (event.locationId != null) _buildLocationChip(context, event.locationId!, isDark),
                ...event.participantIds.map((pId) => _buildParticipantChip(context, pId, isDark)),
              ],
            ),
            const SizedBox(height: 14),
          ],

          // 3. Quran & Hadith References
          if (event.relatedQuranAyahs.isNotEmpty || event.relatedHadithIds.isNotEmpty) ...[
            Text(
              'الأدلة والشواهد النصية الموثقة:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: titleColor),
            ),
            const SizedBox(height: 8),
            if (event.relatedQuranAyahs.isNotEmpty) ...[
              ...event.relatedQuranAyahs.map(
                (ayah) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryAccent.withAlpha(isDark ? 28 : 12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primaryAccent.withAlpha(isDark ? 100 : 60),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(Icons.auto_stories, size: 18, color: primaryAccent),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SelectableText(
                          ayah,
                          style: TextStyle(
                            fontSize: 14 * _fontSizeMultiplier,
                            height: 1.7,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (event.relatedHadithIds.isNotEmpty) ...[
              ...event.relatedHadithIds.map(
                (hadith) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B).withAlpha(160) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.format_quote_rounded,
                          size: 18,
                          color: isDark ? AppColors.goldAccentLight : const Color(0xFF0F5132),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SelectableText(
                          hadith,
                          style: TextStyle(
                            fontSize: 13.5 * _fontSizeMultiplier,
                            height: 1.65,
                            color: bodyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
          ],

          // 5. Narrative Variants (if any)
          if (event.variants.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.library_books_outlined,
                  size: 18,
                  color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
                ),
                const SizedBox(width: 8),
                Text(
                  'الروايات والمصادر السردية المقارنة:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...event.variants.map((v) => NarrativeVariantBox(variant: v)),
            const SizedBox(height: 20),
          ],

          // 6. Moral Lessons & Reflections
          if (event.moralLessons.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.psychology_outlined, size: 18, color: primaryAccent),
                const SizedBox(width: 8),
                Text(
                  'الدروس والمقاصد التربوية المستنبطة:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...event.moralLessons.map((l) => MoralLessonCard(lesson: l)),
            const SizedBox(height: 20),
          ],

          // 7. User Note Local Section
          Row(
            children: [
              Icon(Icons.edit_note, size: 20, color: primaryAccent),
              const SizedBox(width: 8),
              Text(
                'ملاحظاتي وتأملاتي الشخصية:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            elevation: isDark ? 1 : 1,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.white : const Color(0xFF1E293B)),
                    decoration: InputDecoration(
                      hintText: 'سجّل تأملاتك الشخصية واستنباطاتك الإيمانية حول هذا الحدث...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryAccent, width: 1.5),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: _saveNote,
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('حفظ الملاحظة', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryAccent,
                        foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationChip(BuildContext context, String locationId, bool isDark) {
    final placeRes = widget.module.getPlace(locationId);
    final placeName = placeRes.valueOrNull?.nameArabic ?? locationId;
    final placeAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    return ActionChip(
      avatar: Icon(Icons.place, size: 16, color: placeAccent),
      label: Text(
        placeName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: placeAccent,
          fontSize: 12.5,
        ),
      ),
      backgroundColor: placeAccent.withAlpha(isDark ? 35 : 18),
      side: BorderSide(color: placeAccent.withAlpha(isDark ? 100 : 60)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: placeRes.isSuccess
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlaceDetailScreen(place: placeRes.valueOrNull!),
                ),
              );
            }
          : null,
    );
  }

  Widget _buildParticipantChip(BuildContext context, String personId, bool isDark) {
    final personRes = widget.module.getPerson(personId);
    final personName = personRes.valueOrNull?.canonicalName ?? personId;
    final personTextColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return ActionChip(
      avatar: Icon(
        Icons.person,
        size: 16,
        color: isDark ? AppColors.goldAccentLight : const Color(0xFF1E293B),
      ),
      label: Text(
        personName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: personTextColor,
          fontSize: 12.5,
        ),
      ),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
      side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: personRes.isSuccess
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PersonDetailScreen(
                    person: personRes.valueOrNull!,
                    module: widget.module,
                  ),
                ),
              );
            }
          : null,
    );
  }
}
