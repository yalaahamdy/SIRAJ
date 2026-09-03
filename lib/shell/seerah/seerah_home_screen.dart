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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'السيرة النبوية والتاريخ الإسلامي',
          style: TextStyle(fontSize: 16),
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
          indicatorColor: const Color(0xFF0F5132),
          labelColor: const Color(0xFF0F5132),
          unselectedLabelColor: Colors.grey.shade700,
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
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0F5132)),
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
                ? _buildSearchResults()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEventsTab(periods, events),
                      _buildPersonsTab(persons),
                      _buildPlacesTab(places),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('لا توجد نتائج مطابقة لبحثك في حزمة السيرة'));
    }

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
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF0F5132)),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(item.snippet, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5132).withAlpha(15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(item.tagLabel, style: const TextStyle(fontSize: 10, color: Color(0xFF0F5132))),
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

  Widget _buildEventsTab(List<HistoricalPeriod> periods, List<SeerahEvent> events) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Continue Seerah Banner (if available)
        if (_lastViewedEvent != null) ...[
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF0F5132), width: 1.5),
            ),
            child: ListTile(
              leading: const Icon(Icons.bookmark_added, color: Color(0xFF0F5132)),
              title: const Text('متابعة قراءة السيرة (آخر حدث تمت مطالعته)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              subtitle: Text(
                _lastViewedEvent!.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F5132)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF0F5132)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EventDetailScreen(event: _lastViewedEvent!, module: widget.module)),
                ).then((_) => _loadProgress());
              },
            ),
          ),
        ],

        // Timeline Banner Hero
        Card(
          color: const Color(0xFF0F5132),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.auto_stories, color: Colors.white, size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المخطط الزمني للسيرة النبوية',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'استعرض وقائع السيرة مرتبة وموثقة حسب الحقب التاريخية',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TimelineScreen(module: widget.module)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0F5132),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(60, 32),
                  ),
                  child: const Text('فتح المخطط', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('أبرز الوقائع والغزوات الموثقة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
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

  Widget _buildPersonsTab(List<HistoricalPerson> persons) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: persons.length,
      itemBuilder: (context, index) {
        final p = persons[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF0F5132),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(p.canonicalName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('${p.historicalRole} ${p.titleOrLakab != null ? '— ${p.titleOrLakab!}' : ''}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 12),
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

  Widget _buildPlacesTab(List<HistoricalPlace> places) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final pl = places[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.place, color: Color(0xFF0F5132)),
            title: Text(pl.nameArabic, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('إقليم ${pl.region} ${pl.modernName != null ? '(${pl.modernName!})' : ''}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5132).withAlpha(15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(pl.certainty.labelArabic, style: const TextStyle(fontSize: 10, color: Color(0xFF0F5132))),
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
