import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../modules/adhkar/adhkar_module.dart';
import '../../modules/adhkar/domain/dhikr_item.dart';
import '../../modules/adhkar/domain/dhikr_user_progress.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'widgets/interactive_counter_view.dart';
import 'widgets/provenance_disclosure_card.dart';

/// Screen for displaying individual Dhikr or sequential routine flow with authenticated provenance
/// and interactive counter with automatic progression (§9..§25, §47..§50, §87, §88).
class DhikrDetailScreen extends StatefulWidget {
  final DhikrItem? item;
  final List<DhikrItem>? items;
  final int initialIndex;
  final AdhkarModule module;

  const DhikrDetailScreen({
    super.key,
    this.item,
    this.items,
    this.initialIndex = 0,
    required this.module,
  }) : assert(item != null || (items != null && items.length > 0), 'Either item or non-empty items must be provided');

  @override
  State<DhikrDetailScreen> createState() => _DhikrDetailScreenState();
}

class _DhikrDetailScreenState extends State<DhikrDetailScreen> {
  late List<DhikrItem> _items;
  late int _currentIndex;
  late PageController _pageController;

  DhikrUserProgress? _progress;
  bool _isFavorite = false;
  bool _isLoading = true;
  bool _autoAdvance = true;
  bool _isTransitioning = false;

  DhikrItem get _currentItem => _items[_currentIndex];

  @override
  void initState() {
    super.initState();
    if (widget.items != null && widget.items!.isNotEmpty) {
      _items = widget.items!;
      _currentIndex = widget.initialIndex.clamp(0, _items.length - 1);
    } else {
      _items = [widget.item!];
      _currentIndex = 0;
    }
    _pageController = PageController(initialPage: _currentIndex);
    _loadStateForCurrent();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadStateForCurrent() async {
    final item = _currentItem;
    final progRes = await widget.module.getProgress(item.id, item.repetition.count);
    final favRes = await widget.module.isFavorite(item.id);

    if (mounted) {
      setState(() {
        _progress = progRes.valueOrNull;
        _isFavorite = favRes.valueOrNull ?? false;
        _isLoading = false;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _isLoading = true;
    });
    _loadStateForCurrent();
  }

  void _goToNext() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _incrementCounter() async {
    final item = _currentItem;
    final res = await widget.module.incrementProgress(
      contentId: item.id,
      targetCount: item.repetition.count,
    );
    if (res.isSuccess && mounted) {
      final newProgress = res.valueOrNull;
      setState(() {
        _progress = newProgress;
      });

      // Auto-advance logic upon completing current count
      if (newProgress != null &&
          newProgress.currentCount >= item.repetition.count &&
          item.repetition.count > 0 &&
          !_isTransitioning) {
        if (_autoAdvance && _currentIndex < _items.length - 1) {
          _isTransitioning = true;
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted && _currentIndex < _items.length - 1) {
              _goToNext();
            }
            _isTransitioning = false;
          });
        } else if (_currentIndex == _items.length - 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الحمد لله، تم إتمام الورد المبارك بالكامل تقبل الله طاعتكم 🤲'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<void> _undoCounter() async {
    final item = _currentItem;
    final res = await widget.module.decrementProgress(
      contentId: item.id,
      targetCount: item.repetition.count,
    );
    if (res.isSuccess && mounted) {
      setState(() {
        _progress = res.valueOrNull;
      });
    }
  }

  Future<void> _resetCounter() async {
    final item = _currentItem;
    final res = await widget.module.resetProgress(
      contentId: item.id,
      targetCount: item.repetition.count,
    );
    if (res.isSuccess && mounted) {
      setState(() {
        _progress = res.valueOrNull;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final item = _currentItem;
    final res = await widget.module.toggleFavorite(item.id);
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
    final item = _currentItem;
    final textToCopy = '${item.textArabic}\n[المصدر: ${item.sourceTitle} — ${item.reference}]';
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ نص الذكر الشريف مع الإسناد والتخريج'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareDhikr() {
    final item = _currentItem;
    final reference = '${item.textArabic}\n\nتخريج: ${item.sourceTitle} (${item.reference}) — النسبة: ${item.attribution} — درجة الصحة: ${item.authenticityGrade.labelArabic}';
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
    final hasMultiple = _items.length > 1;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            hasMultiple
                ? '${_currentItem.occasion.labelArabic} (${_currentIndex + 1} / ${_items.length})'
                : _currentItem.occasion.labelArabic,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        bottom: hasMultiple
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _items.length,
                  backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppColors.goldAccent : AppColors.primary,
                  ),
                  minHeight: 3,
                ),
              )
            : null,
        actions: [
          if (hasMultiple)
            IconButton(
              icon: Icon(
                _autoAdvance ? Icons.fast_forward_rounded : Icons.pause_circle_outline_rounded,
                color: _autoAdvance ? (isDark ? AppColors.goldAccent : AppColors.primary) : Colors.grey,
              ),
              tooltip: _autoAdvance ? 'الانتقال التلقائي مفعّل' : 'الانتقال التلقائي متوقف',
              onPressed: () {
                setState(() {
                  _autoAdvance = !_autoAdvance;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_autoAdvance
                        ? 'تم تفعيل الانتقال التلقائي للذكر التالي عند اكتمال العداد'
                        : 'تم إيقاف الانتقال التلقائي (تنقل يدوي)'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
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
      bottomNavigationBar: hasMultiple
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _currentIndex > 0 ? _goToPrevious : null,
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      label: const Text('السابق'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    Text(
                      'الذكر ${_currentIndex + 1} من ${_items.length}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _currentIndex < _items.length - 1 ? _goToNext : null,
                      label: const Text('التالي'),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark ? AppColors.goldAccent : AppColors.primary,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _items.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Canonical Arabic Text Card (Tappable to increment comfortably)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      child: InkWell(
                        onTap: _incrementCounter,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            children: [
                              Text(
                                item.textArabic,
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 22,
                                  height: 2.0,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'انقر على النص أو العداد للعدّ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Interactive Repetition Counter
                    _isLoading
                        ? const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                        : InteractiveCounterView(
                            currentCount: _progress?.currentCount ?? 0,
                            targetCount: item.repetition.count,
                            isSourced: item.repetition.isSourced,
                            onIncrement: _incrementCounter,
                            onUndo: _undoCounter,
                            onReset: _resetCounter,
                          ),
                    const SizedBox(height: 24),

                    // 3. Provenance & Source Disclosure Card
                    ProvenanceDisclosureCard(item: item),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
