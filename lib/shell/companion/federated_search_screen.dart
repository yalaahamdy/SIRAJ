import 'package:flutter/material.dart';
import '../../../modules/companion/companion_module.dart';
import '../../../modules/companion/domain/federated_search_result.dart';

class FederatedSearchScreen extends StatefulWidget {
  final CompanionModule module;

  const FederatedSearchScreen({super.key, required this.module});

  @override
  State<FederatedSearchScreen> createState() => _FederatedSearchScreenState();
}

class _FederatedSearchScreenState extends State<FederatedSearchScreen> {
  final _searchCtrl = TextEditingController();
  List<FederatedSearchResult> _results = [];
  bool _isSearching = false;

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isSearching = true);
    final res = await widget.module.search(query);
    if (mounted) {
      setState(() {
        if (res.isSuccess) {
          _results = res.valueOrNull!;
        }
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث الشامل الموحد'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'ابحث في القرآن، الأذكار، الحديث، الفقه، السيرة، الحج...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _performSearch,
            ),
          ),
          if (_isSearching) const LinearProgressIndicator(),
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(
                      _searchCtrl.text.isEmpty
                          ? 'اكتب كلمة للبحث في كافة مصادر سِراج الموثقة'
                          : 'لا توجد نتائج مطابقة لبحثك',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _results.length,
                    itemBuilder: (context, idx) {
                      final item = _results[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(
                            item.titleArabic,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                item.snippet,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.moduleTitleArabic,
                                      style: TextStyle(fontSize: 10, color: Colors.teal.shade800),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${item.itemType})',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, item.targetRoute);
                          },
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
