import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../modules/adhkar/adhkar_module.dart';
import '../../modules/adhkar/domain/dhikr_item.dart';
import '../../modules/adhkar/domain/dhikr_user_progress.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'widgets/interactive_counter_view.dart';
import 'widgets/provenance_disclosure_card.dart';

/// Screen for displaying individual Dhikr with authenticated provenance and interactive counter (§9..§25, §47..§50, §87, §88).
class DhikrDetailScreen extends StatefulWidget {
  final DhikrItem item;
  final AdhkarModule module;

  const DhikrDetailScreen({
    super.key,
    required this.item,
    required this.module,
  });

  @override
  State<DhikrDetailScreen> createState() => _DhikrDetailScreenState();
}

class _DhikrDetailScreenState extends State<DhikrDetailScreen> {
  DhikrUserProgress? _progress;
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final progRes = await widget.module.getProgress(widget.item.id, widget.item.repetition.count);
    final favRes = await widget.module.isFavorite(widget.item.id);

    if (mounted) {
      setState(() {
        _progress = progRes.valueOrNull;
        _isFavorite = favRes.valueOrNull ?? false;
        _isLoading = false;
      });
    }
  }

  Future<void> _incrementCounter() async {
    final res = await widget.module.incrementProgress(
      contentId: widget.item.id,
      targetCount: widget.item.repetition.count,
    );
    if (res.isSuccess && mounted) {
      setState(() {
        _progress = res.valueOrNull;
      });
    }
  }

  Future<void> _undoCounter() async {
    final res = await widget.module.decrementProgress(
      contentId: widget.item.id,
      targetCount: widget.item.repetition.count,
    );
    if (res.isSuccess && mounted) {
      setState(() {
        _progress = res.valueOrNull;
      });
    }
  }

  Future<void> _resetCounter() async {
    final res = await widget.module.resetProgress(
      contentId: widget.item.id,
      targetCount: widget.item.repetition.count,
    );
    if (res.isSuccess && mounted) {
      setState(() {
        _progress = res.valueOrNull;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final res = await widget.module.toggleFavorite(widget.item.id);
    if (res.isSuccess && mounted) {
      setState(() {
        _isFavorite = res.valueOrNull ?? false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'تمت إضافة الذكر إلى المفضلة' : 'تمت إزالة الذكر من المفضلة'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _copyDhikr() {
    final textToCopy = '${widget.item.textArabic}\n[المصدر: ${widget.item.sourceTitle} — ${widget.item.reference}]';
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ نص الذكر الشريف مع الإسناد والتخريج'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareDhikr() {
    final reference = '${widget.item.textArabic}\n\nتخريج: ${widget.item.sourceTitle} (${widget.item.reference}) — النسبة: ${widget.item.attribution} — درجة الصحة: ${widget.item.authenticityGrade.labelArabic}';
    Clipboard.setData(ClipboardData(text: reference));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تجهيز مرجع الذكر الموثق للمشاركة'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.occasion.labelArabic),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : null,
            ),
            tooltip: _isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
            onPressed: _toggleFavorite,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'خيارات إضافية',
            onSelected: (value) {
              if (value == 'copy') {
                _copyDhikr();
              } else if (value == 'share') {
                _shareDhikr();
              }
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('نسخ الذكر مع التوثيق'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('مشاركة المرجع الموثق'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Canonical Arabic Text Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Text(
                          widget.item.textArabic,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 22,
                            height: 2.0,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Interactive Repetition Counter
                      InteractiveCounterView(
                        currentCount: _progress?.currentCount ?? 0,
                        targetCount: widget.item.repetition.count,
                        isSourced: widget.item.repetition.isSourced,
                        onIncrement: _incrementCounter,
                        onUndo: _undoCounter,
                        onReset: _resetCounter,
                      ),
                      const SizedBox(height: 24),

                      // 3. Provenance & Source Disclosure Card
                      ProvenanceDisclosureCard(item: widget.item),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
