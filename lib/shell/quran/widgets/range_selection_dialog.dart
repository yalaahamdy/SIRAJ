import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Modal dialog allowing the user to specify and action a multi-verse range (§15, §16).
class RangeSelectionDialog extends StatefulWidget {
  final int surahNumber;
  final String surahNameArabic;
  final int initialAyah;
  final int totalAyahs;
  final void Function(int startAyah, int endAyah) onSelectRange;
  final void Function(int startAyah, int endAyah)? onPlayRange;

  const RangeSelectionDialog({
    super.key,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.initialAyah,
    required this.totalAyahs,
    required this.onSelectRange,
    this.onPlayRange,
  });

  @override
  State<RangeSelectionDialog> createState() => _RangeSelectionDialogState();
}

class _RangeSelectionDialogState extends State<RangeSelectionDialog> {
  late int _startAyah;
  late int _endAyah;
  late final TextEditingController _startController;
  late final TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _startAyah = widget.initialAyah;
    _endAyah = (_startAyah + 4).clamp(1, widget.totalAyahs);
    _startController = TextEditingController(text: '$_startAyah');
    _endController = TextEditingController(text: '$_endAyah');
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _updateStart(int val) {
    final clamped = val.clamp(1, widget.totalAyahs);
    setState(() {
      _startAyah = clamped;
      _startController.text = '$clamped';
      if (_endAyah < clamped) {
        _endAyah = clamped;
        _endController.text = '$clamped';
      }
    });
  }

  void _updateEnd(int val) {
    final clamped = val.clamp(_startAyah, widget.totalAyahs);
    setState(() {
      _endAyah = clamped;
      _endController.text = '$clamped';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        'تحديد نطاق آيات — سورة ${widget.surahNameArabic}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'أدخل بداية ونهاية نطاق الآيات (1 حتى ${widget.totalAyahs}):',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Start Ayah Numeric Field + Steppers
          Row(
            children: [
              const SizedBox(width: 70, child: Text('من الآية:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                onPressed: _startAyah > 1 ? () => _updateStart(_startAyah - 1) : null,
              ),
              Expanded(
                child: TextField(
                  controller: _startController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                  ),
                  onChanged: (val) {
                    final p = int.tryParse(val.trim());
                    if (p != null) _updateStart(p);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                onPressed: _startAyah < widget.totalAyahs ? () => _updateStart(_startAyah + 1) : null,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // End Ayah Numeric Field + Steppers
          Row(
            children: [
              const SizedBox(width: 70, child: Text('إلى الآية:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                onPressed: _endAyah > _startAyah ? () => _updateEnd(_endAyah - 1) : null,
              ),
              Expanded(
                child: TextField(
                  controller: _endController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                  ),
                  onChanged: (val) {
                    final p = int.tryParse(val.trim());
                    if (p != null) _updateEnd(p);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                onPressed: _endAyah < widget.totalAyahs ? () => _updateEnd(_endAyah + 1) : null,
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'النطاق المحدد: ${_endAyah - _startAyah + 1} آيات ($_startAyah إلى $_endAyah)',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        if (widget.onPlayRange != null)
          TextButton.icon(
            icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
            label: const Text('تلاوة النطاق'),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onPlayRange?.call(_startAyah, _endAyah);
            },
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.goldAccent : AppColors.primary,
            foregroundColor: isDark ? Colors.black87 : Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSelectRange(_startAyah, _endAyah);
          },
          child: const Text('تحديد في القارئ'),
        ),
      ],
    );
  }
}
