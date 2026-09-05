import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/historical_period.dart';
import '../../../modules/seerah/domain/historical_person.dart';
import '../../../modules/seerah/domain/historical_place.dart';
import '../../../modules/seerah/domain/seerah_event.dart';
import '../../../modules/seerah/search/seerah_search_service.dart';
import '../../../modules/seerah/seerah_module.dart';
import 'event_detail_screen.dart';
import 'person_detail_screen.dart';
import 'place_detail_screen.dart';
import 'timeline_screen.dart';
import 'widgets/event_card.dart';
import '../theme/app_colors.dart';

/// Main Hub for Seerah & Islamic History platform (§36).
class SeerahHomeScreen extends StatefulWidget {
  final SeerahModule module;

  const SeerahHomeScreen({
    super.key,
    required this.module,
  });

  @override
  State<SeerahHomeScreen> createState() => _SeerahHomeScreenState();
}

class _SeerahHomeScreenState extends State<SeerahHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  List<SeerahSearchResult> _searchResults = [];
  bool _isSearching = false;
  SeerahEvent? _lastViewedEvent;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progRes = await widget.module.getUserProgress();
    if (progRes.isSuccess && mounted) {
      final p = progRes.valueOrNull!;
      if (p.lastViewedEventId != null) {
        final evRes = widget.module.getEvent(p.lastViewedEventId!);
        if (evRes.isSuccess && mounted) {
          setState(() {
            _lastViewedEvent = evRes.valueOrNull;
          });
        }
      }
    }
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    final res = widget.module.search(query);
    setState(() {
      _isSearching = true;
      _searchResults = res.valueOrNull ?? [];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final periods = widget.module.getAllPeriods().valueOrNull ?? [];
    final events = widget.module.getAllEvents().valueOrNull ?? [];
    final persons = widget.module.getAllPersons().valueOrNull ?? [];
    final places = widget.module.getAllPlaces().valueOrNull ?? [];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'السيرة النبوية والتاريخ الإسلامي',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.timeline),
            tooltip: 'المخطط الزمني الشامل',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TimelineScreen(module: widget.module)),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: isDark ? AppColors.goldAccentLight : AppColors.primary,
          labelColor: isDark ? AppColors.goldAccentLight : AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
          tabs: const [
            Tab(text: 'الأحداث والوقائع'),
            Tab(text: 'الشخصيات'),
            Tab(text: 'الأماكن والمواقع'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'ابحث في الأحداث، الشخصيات، المواقع...',
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
          ),

          // 2. Body or Search Results
          Expanded(
            child: _isSearching
                ? _buildSearchResults(isDark)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEventsTab(periods, events, isDark),
                      _buildPersonsTab(persons, isDark),
                      _buildPlacesTab(places, isDark),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isDark) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج مطابقة لبحثك في حزمة السيرة',
          style: TextStyle(
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
          ),
        ),
      );
    }

    final accent = isDark ? AppColors.goldAccentLight : AppColors.primary;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final snippetColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        IconData icon;
        if (item.type == 'event') {
          icon = Icons.history_edu;
        } else if (item.type == 'person') {
          icon = Icons.person;
        } else {
          icon = Icons.place;
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isDark ? AppColors.borderDark : Colors.grey.shade200,
            ),
          ),
          child: ListTile(
            leading: Icon(icon, color: accent),
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: titleColor,
              ),
            ),
            subtitle: Text(
              item.snippet,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: snippetColor),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withAlpha(isDark ? 40 : 15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.tagLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ),
            onTap: () => _handleSearchResultClick(item),
          ),
        );
      },
    );
  }

  void _handleSearchResultClick(SeerahSearchResult item) {
    if (item.type == 'event') {
      final evRes = widget.module.getEvent(item.id);
      if (evRes.isSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EventDetailScreen(event: evRes.valueOrNull!, module: widget.module)),
        );
      }
    } else if (item.type == 'person') {
      final pRes = widget.module.getPerson(item.id);
      if (pRes.isSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PersonDetailScreen(person: pRes.valueOrNull!, module: widget.module)),
        );
      }
    } else if (item.type == 'place') {
      final plRes = widget.module.getPlace(item.id);
      if (plRes.isSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: plRes.valueOrNull!)),
        );
      }
    }
  }

  Widget _buildEventsTab(List<HistoricalPeriod> periods, List<SeerahEvent> events, bool isDark) {
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final primaryAccent = isDark ? AppColors.goldAccentLight : AppColors.primary;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // Continue Seerah Banner (if available)
        if (_lastViewedEvent != null) ...[
          Card(
            elevation: isDark ? 1 : 2,
            margin: const EdgeInsets.only(bottom: 12),
            color: isDark ? AppColors.surfaceDark : const Color(0xFFF6FAF7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark ? AppColors.goldAccent : const Color(0xFF0F5132),
                width: 1.5,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isDark ? AppColors.goldAccent.withAlpha(45) : const Color(0xFF0F5132),
                child: Icon(
                  Icons.bookmark_added,
                  color: isDark ? AppColors.goldAccentLight : Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                'متابعة قراءة السيرة (آخر حدث تمت مطالعته)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                ),
              ),
              subtitle: Text(
                _lastViewedEvent!.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                  color: primaryAccent,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: primaryAccent,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EventDetailScreen(
                      event: _lastViewedEvent!,
                      module: widget.module,
                    ),
                  ),
                ).then((_) => _loadProgress());
              },
            ),
          ),
        ],

        // Timeline Banner Hero
        Card(
          elevation: isDark ? 1.5 : 2.5,
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F5132),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isDark ? AppColors.borderDark : Colors.transparent,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.auto_stories,
                  color: isDark ? AppColors.goldAccentLight : Colors.white,
                  size: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المخطط الزمني للسيرة النبوية',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'استعرض وقائع السيرة مرتبة وموثقة حسب الحقب التاريخية',
                        style: TextStyle(
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
                          fontSize: 11.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TimelineScreen(module: widget.module)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.goldAccentLight : Colors.white,
                    foregroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFF0F5132),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: const Size(70, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('فتح المخطط', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'أبرز الوقائع والغزوات الموثقة:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        ...events.map(
          (event) => EventCard(
            event: event,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EventDetailScreen(event: event, module: widget.module)),
              ).then((_) => _loadProgress());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPersonsTab(List<HistoricalPerson> persons, bool isDark) {
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final accent = isDark ? AppColors.goldAccentLight : AppColors.primary;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: persons.length,
      itemBuilder: (context, index) {
        final p = persons[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          elevation: isDark ? 0.8 : 1.5,
          color: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isDark ? AppColors.borderDark : Colors.grey.shade200,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isDark ? AppColors.goldAccent.withAlpha(40) : const Color(0xFF0F5132),
              child: Icon(
                Icons.person,
                color: isDark ? AppColors.goldAccentLight : Colors.white,
                size: 22,
              ),
            ),
            title: Text(
              p.canonicalName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
                color: titleColor,
              ),
            ),
            subtitle: Text(
              '${p.historicalRole} ${p.titleOrLakab != null ? '— ${p.titleOrLakab!}' : ''}',
              style: TextStyle(fontSize: 12.5, color: subtitleColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 12, color: accent),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PersonDetailScreen(person: p, module: widget.module)),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPlacesTab(List<HistoricalPlace> places, bool isDark) {
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final placeAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final pl = places[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          elevation: isDark ? 0.8 : 1.5,
          color: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isDark ? AppColors.borderDark : Colors.grey.shade200,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: placeAccent.withAlpha(isDark ? 45 : 255),
              child: Icon(
                Icons.place,
                color: isDark ? placeAccent : Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              pl.nameArabic,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
                color: titleColor,
              ),
            ),
            subtitle: Text(
              'إقليم ${pl.region} ${pl.modernName != null ? '(${pl.modernName!})' : ''}',
              style: TextStyle(fontSize: 12.5, color: subtitleColor),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: placeAccent.withAlpha(isDark ? 35 : 20),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: placeAccent.withAlpha(isDark ? 120 : 80)),
              ),
              child: Text(
                pl.certainty.labelArabic,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: placeAccent,
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: pl)),
              );
            },
          ),
        );
      },
    );
  }
}
