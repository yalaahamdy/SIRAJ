import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/seerah_event.dart';
import '../../../modules/seerah/seerah_module.dart';
import 'person_detail_screen.dart';
import 'place_detail_screen.dart';
import 'widgets/moral_lesson_card.dart';
import 'widgets/narrative_variant_box.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _isLoading ? null : _toggleBookmark,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Header Card: Evidence Level & Date
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F5132).withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event.evidenceLevel.labelArabic,
                            style: const TextStyle(
                              color: Color(0xFF0F5132),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          event.historicalDate.dateDisplay,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.summary,
                    style: const TextStyle(fontSize: 14.5, height: 1.6, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Participants & Location Chips
          if (event.participantIds.isNotEmpty || event.locationId != null) ...[
            const Text('المكان والمشاركون في الواقعة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (event.locationId != null) _buildLocationChip(context, event.locationId!),
                ...event.participantIds.map((pId) => _buildParticipantChip(context, pId)),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // 3. Quran & Hadith References
          if (event.relatedQuranAyahs.isNotEmpty || event.relatedHadithIds.isNotEmpty) ...[
            const Text('الأدلة والشواهد النصية الموثقة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.relatedQuranAyahs.isNotEmpty) ...[
                      const Row(
                        children: [
                          Icon(Icons.menu_book, size: 16, color: Color(0xFF0F5132)),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text('الآيات الكريمة ذات الصلة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(event.relatedQuranAyahs.join('، '), style: const TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 8),
                    ],
                    if (event.relatedHadithIds.isNotEmpty) ...[
                      const Row(
                        children: [
                          Icon(Icons.format_quote, size: 16, color: Color(0xFF0F5132)),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text('الأحاديث النبوية المسندة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(event.relatedHadithIds.join('، '), style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 4. Narrative Variants (if any)
          if (event.variants.isNotEmpty) ...[
            const Text('الروايات والمصادر السردية المقارنة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ...event.variants.map((v) => NarrativeVariantBox(variant: v)),
            const SizedBox(height: 16),
          ],

          // 5. Moral Lessons & Reflections
          if (event.moralLessons.isNotEmpty) ...[
            const Text('الدروس والمقاصد التربوية المستنبطة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ...event.moralLessons.map((l) => MoralLessonCard(lesson: l)),
            const SizedBox(height: 16),
          ],

          // 6. User Note Local Section
          const Text('ملاحظاتي وتأملاتي الشخصية:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'أضف تأملاتك الشخصية حول هذا الحدث...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: _saveNote,
              icon: const Icon(Icons.save),
              label: const Text('حفظ الملاحظة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationChip(BuildContext context, String locationId) {
    final placeRes = widget.module.getPlace(locationId);
    final placeName = placeRes.valueOrNull?.nameArabic ?? locationId;

    return ActionChip(
      avatar: const Icon(Icons.place_outlined, size: 16, color: Color(0xFF0F5132)),
      label: Text(placeName),
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

  Widget _buildParticipantChip(BuildContext context, String personId) {
    final personRes = widget.module.getPerson(personId);
    final personName = personRes.valueOrNull?.canonicalName ?? personId;

    return ActionChip(
      avatar: const Icon(Icons.person_outline, size: 16, color: Color(0xFF0F5132)),
      label: Text(personName),
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
