import 'package:flutter/material.dart';
import '../../../modules/ai/ai_module.dart';
import '../../../modules/ai/domain/ai_response.dart';
import 'widgets/abstention_card.dart';
import 'widgets/evidence_drawer.dart';

class AISearchQueryScreen extends StatefulWidget {
  final AIModule module;

  const AISearchQueryScreen({super.key, required this.module});

  @override
  State<AISearchQueryScreen> createState() => _AISearchQueryScreenState();
}

class _AISearchQueryScreenState extends State<AISearchQueryScreen> {
  final _controller = TextEditingController();
  AIResponse? _response;
  bool _isLoading = false;

  Future<void> _executeQuery(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _isLoading = true);

    final res = await widget.module.processQuery(query);
    if (mounted) {
      setState(() {
        _response = res;
        _isLoading = false;
      });
    }
  }

  void _showEvidenceDrawer() {
    if (_response == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EvidenceDrawer(evidenceItems: _response!.evidenceItems),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('البحث والاسترجاع المعرفي'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'اطرح سؤالاً معرفياً (مثال: ما فضل صلاة الفجر؟)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_rounded),
                      onPressed: () => _executeQuery(_controller.text),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onSubmitted: _executeQuery,
                ),
                const SizedBox(height: 6),
                const Text(
                  'تنبيه: سِراج يقدم استرجاعاً وتوثيقاً من المصادر المعتمدة فقط ولا يقدم فتاوى شخصية.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: _response == null
                ? const Center(
                    child: Text(
                      'أدخل سؤالك للبحث في المصادر والأدلة الكنسية الموثقة',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      if (_response!.isAbstained)
                        AbstentionCard(
                          reasonArabic: _response!.abstentionReasonArabic ?? _response!.answerArabic,
                          referralArabic: _response!.scholarReferralArabic,
                        )
                      else ...[
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.verified, size: 14, color: Colors.green),
                                          const SizedBox(width: 4),
                                          Text(
                                            _response!.groundingStatus.labelArabic,
                                            style: TextStyle(fontSize: 11, color: Colors.green.shade900),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: _showEvidenceDrawer,
                                      icon: const Icon(Icons.library_books_outlined, size: 16),
                                      label: Text('الأدلة (${_response!.evidenceItems.length})'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Text(
                                  _response!.answerArabic,
                                  style: const TextStyle(fontSize: 14, height: 1.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
